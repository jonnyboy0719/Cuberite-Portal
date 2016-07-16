-- Global variables
PLUGIN = {} -- Reference to own plugin object
-- LOGIC
PORTAL_ACTIVATION_TIME = 2

PLAYER_STATES = {
	["NOT_IN_PORTAL"] = "NOT_IN_PORTAL",
	["WAITING"] = "WAITING",
	["TELEPORTING"] = "TELEPORTING",
	["PORTAL_NOT_SETUP"] = "PORTAL_NOT_SETUP",
}

DATA = {}
DATA.players = {}

PORTALS_INI_NAME = "portals_portals.ini"

PLUGIN_PATH = ''
DATA.portalIniFile = cIniFile()

CSS_STYLES = nil
WORLDS = {}

function Initialize(Plugin)
	PLUGIN = Plugin

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(2)

	PluginManager = cRoot:Get():GetPluginManager()
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, onPlayerJoin)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED, onPlayerDestroyed)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_CHANGED_WORLD, OnEntityChangedWorld)

	Plugin:AddWebTab("Portals", HandleRequest_Portals)

	cRoot:Get():ForEachWorld(function(world) WORLDS[#WORLDS + 1] = world:GetName() end)

	RegisterPluginInfoCommands();
	PLUGIN_PATH = cPluginManager:GetPluginsPath() .. "/" .. Plugin:GetFolderName() .. "/"
	CSS_STYLES = cFile:ReadWholeFile(PLUGIN_PATH .. "portal-styles.css")
	-- load ini files into memory or create them.
	initINI(PORTALS_INI_NAME, DATA.portalIniFile)
	DATA.portals = portalIniToTable(DATA.portalIniFile)

	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. g_PluginInfo.Version)
	return true
end

function initINI(fileName, iniObject)
	if cFile:IsFile(PLUGIN_PATH .. fileName) then
		iniObject:ReadFile(PLUGIN_PATH .. fileName)
		LOG(PLUGIN:GetName() .. ": loaded " .. fileName)
	else
		local success, _ = pcall(iniObject.WriteFile, iniObject, PLUGIN_PATH ..fileName)
		if success then
				LOG("PORTALS PLUGIN " .. fileName .. " created.")
		end
	end
end

function OnDisable()
	portalDataToIni()
	DATA.portalIniFile:WriteFile(PLUGIN_PATH .. PORTALS_INI_NAME)
	
	LOG(PLUGIN:GetName() .. " v" .. g_PluginInfo.Version .. " is shutting down...")
end

function teleportPlayer(Player, playerData)
	local portalData = DATA.portals[playerData.targetPortalName]
	if (Player:GetWorld():GetName() ~= portalData["world"]) then
		playerData.HasTeleportedToWorld = true
		Player:MoveToWorld(portalData["world"])
	else
		Player:TeleportToCoords(portalData["destination_x"], portalData["destination_y"], portalData["destination_z"])
		playerData.targetPortalName = ""
		Player:SendMessage(cChatColor.Yellow .. "You have been teleported!")
	end
end

function OnPlayerMoving(Player)
	local playerName = Player:GetName()
	local playerData = DATA.players[playerName]
	local portalName = playerInAPortal(Player) -- only returns result when player is in portal area

	if (portalName) then
		local portalData = DATA.portals[portalName]
		local targetPortalName = portalData["target"]

		-- check if we already set state to PORTAL_NOT_SETUP
		if playerData.state == PLAYER_STATES.PORTAL_NOT_SETUP then
			return false
		end

		-- check if the portal is not set up
		if targetPortalName == "" or targetPortalName == nil then
			Player:SendMessage(cChatColor.Red .. "This portal doesn't lead anywhere!")
			playerData.state = PLAYER_STATES.PORTAL_NOT_SETUP
			return false
		end

		-- check if player just entered
		if (playerData.state == PLAYER_STATES.NOT_IN_PORTAL) then
			Player:SendMessage(cChatColor.LightBlue .. "Stand still for a few seconds for teleportation")
			playerData.portal_timer = GetTime() + PORTAL_ACTIVATION_TIME
			playerData.state = PLAYER_STATES.WAITING
			playerData.targetPortalName = targetPortalName
		end

		if playerData.state == PLAYER_STATES.WAITING then
			if (GetTime() > playerData.portal_timer) then
				playerData.state = PLAYER_STATES.TELEPORTING
				teleportPlayer(Player, playerData)
				return true
			end
		end

	else
		if playerData.state ~= PLAYER_STATES.NOT_IN_PORTAL and playerData.state ~= PLAYER_STATES.TELEPORTING then
			Player:SendMessage(cChatColor.Red .. "You have left teleportation zone")
		end

		playerData.state = PLAYER_STATES.NOT_IN_PORTAL
		playerData.targetPortalName = ""
	end
		return false
end

function OnEntityChangedWorld(Entity, World)
	-- this will teleport the player to the desired location after changing worlds
	if Entity:IsPlayer() then
		local playerName = Entity:GetName()
		local playerData = DATA.players[playerName]
		if playerData.HasTeleportedToWorld then
			local portalName = playerData.targetPortalName
			local targetPortal = DATA.portals[portalName]

			Entity:TeleportToCoords(targetPortal.destination_x,
															targetPortal.destination_y,
															targetPortal.destination_z)
			Entity:SendMessage(cChatColor.Yellow .. "You have been teleported!")

			playerData.targetPortalName = ""
			playerData.HasTeleportedToWorld = false
		end
	end
	return false
end

function OnPlayerBreakingBlock(Player, IN_x, IN_y, IN_z, BlockFace, Status, OldBlock, OldMeta)
	local playerName = Player:GetName()
	local playerData = DATA.players[playerName]

	if (Player:HasPermission("portal.create") == true and playerData["HasToolEnabled"] == 1) then
		if playerData.isSelectingPoint2 then
			if (IN_x ~= -1 and IN_y ~= 255 and IN_z ~= -1) and ItemToString(Player:GetEquippedItem()) == "woodsword" then

					if (playerData.point2 == nil) then
						playerData.point2 = Vector3i()
					end

					playerData.point2.x = IN_x
					playerData.point2.y = IN_y
					playerData.point2.z = IN_z
					Player:SendMessage(portalPointSelectMessage("Second", IN_x, IN_y, IN_z))
					playerData.isSelectingPoint2 = false
					return true
			end
		else
			if (ItemToString(Player:GetEquippedItem()) == "woodsword") then
				if (playerData.point1 == nil) then
				-- debug
				--  Player:SendMessage(IN_x);
					playerData.point1 = Vector3i()
				end
				playerData.point1.x = IN_x
				playerData.point1.y = IN_y
				playerData.point1.z = IN_z
				Player:SendMessage(portalPointSelectMessage("First", IN_x, IN_y, IN_z))
				Player:SendMessage(cChatColor.LightBlue .. "Now select the second portal entrance volume point.")
				playerData.isSelectingPoint2 = true
				return true
			end

		end
	end
	return false
end

function onPlayerJoin(Player)
	local playerName = Player:GetName()
	if DATA.players[playerName] == nil then
		DATA.players[playerName] = {
			portal_timer = 0,
			targetPortalName = "",
			HasToolEnabled = 0,
			HasTeleportedToWorld = false,
			isSelectingPoint2 = false,
			state = PLAYER_STATES.NOT_IN_PORTAL,
		}
	end
end

function onPlayerDestroyed(Player)
	local playerName = Player:GetName()
	if DATA.players[playerName] then
		DATA.players[playerName] = nil
	end
end
