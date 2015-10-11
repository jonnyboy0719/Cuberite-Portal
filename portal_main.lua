-- Global variables
PLUGIN = {}	-- Reference to own plugin object
-- LOGIC
PORTAL_ACTIVATION_TIME = 1
PlayersData = {}
	PlayersData.zones = {}
PortalsData = {}

-- Teleportation fixes
local IsWorld = false

function Initialize(Plugin)
	PLUGIN = Plugin
	
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(2)
	
	PluginManager = cRoot:Get():GetPluginManager()
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_CHANGED_WORLD, OnEntityChangedWorld)
	
	Plugin:AddWebTab("Portals", HandleRequest_Portals)
	Plugin:AddWebTab("Players", HandleRequest_Players)
	
	RegisterPluginInfoCommands();
	
	LoadPortalsData()
	LoadPlayersData()
	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. g_PluginInfo.Version)
	return true
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " v" .. g_PluginInfo.Version .. " is shutting down...")
end

function OnPlayerMoving(Player)
	local _name = Player:GetName()
	if (PlayersData[_name] == nil) then
		PlayersData[_name] = {}	-- create player's page
		
		PlayersData[_name].IsWorld = false
		PlayersData[_name].HasTeleported = false
	end
	if (PlayersData[_name].portal_state == nil) then
		PlayersData[_name].portal_state = -1
	end
	local _zone = FindZone(Player)
	if (_zone ~= false) then
		local TargetArea = PortalsData[_zone]["target"]
		if TargetArea ~= "" then
			if (PlayersData[_name].portal_state == -1) then
				Player:SendMessage(cChatColor.LightBlue .. "Stand still for a few seconds for teleportation")
				PlayersData[_name].portal_state = 1
			end
			if (os.clock() > PlayersData[_name].portal_timer) then
				-- Lets teleport the player
				if (Player:GetWorld():GetName() ~= PortalsData[_zone]["target"]) then
				
					PlayersData[_name].IsWorld = true
					PlayersData[_name].HasTeleported = true
					PlayersData[_name].zones = _zone
					
					Player:MoveToWorld(PortalsData[TargetArea]["world"])
				else
					Player:TeleportToCoords(PortalsData[TargetArea]["destination_x"], PortalsData[TargetArea]["destination_y"], PortalsData[TargetArea]["destination_z"])
					Player:SendMessage(cChatColor.Yellow .. "You have been teleported!")
				end
				PlayersData[_name].portal_state = -1
				PlayersData[_name].portal_timer = os.clock() + PORTAL_ACTIVATION_TIME
				return true
			end
		else
			if (PlayersData[_name].portal_state == -1) then
				Player:SendMessage(cChatColor.Red .. "This portal doesn't lead anywhere!")
				PlayersData[_name].portal_state = -2
			end
		end
	else
		PlayersData[_name].portal_timer = os.clock() + PORTAL_ACTIVATION_TIME
		if (PlayersData[_name].portal_state == 1) then
			Player:SendMessage(cChatColor.Red .. "You have left teleportation zone")
			PlayersData[_name].portal_state = -1
		else
			PlayersData[_name].portal_state = -1
		end
	end
    return false
end

function OnEntityChangedWorld(Entity, World)
	if Entity:IsPlayer() then
		if HasTeleported then
			local _name = Entity:GetName()
			local _zone = PlayersData[_name].zones
			
			local TargetArea = PortalsData[_zone]["target"]

			Entity:TeleportToCoords(PortalsData[TargetArea]["destination_x"], PortalsData[TargetArea]["destination_y"], PortalsData[TargetArea]["destination_z"])
			Entity:SendMessage(cChatColor.Yellow .. "You have been teleported!")
			
			PlayersData[_name].IsWorld = false
			PlayersData[_name].HasTeleported = false
		end
	end
	return false
end

function OnPlayerBreakingBlock(Player, IN_x, IN_y, IN_z, BlockFace, Status, OldBlock, OldMeta)
	local _name = Player:GetName()
	local playerini = cIniFile()
	local GetIniFileName = "portals_players.ini"
	
	if PortalsData[_name]["hastool"] == 1 then
		if (PlayersData[_name] == nil) then
			PlayersData[_name] = {}	-- create player's page
		end
		
		if PlayersData[_name].IsRightclicking == nil then
			PlayersData[_name].IsRightclicking = false
		end
		
		if not PlayersData[_name].IsRightclicking then
			if (ItemToString(Player:GetEquippedItem()) == "woodsword") then
				if (PlayersData[_name].point1 == nil) then
				-- debug
				--	Player:SendMessage(IN_x);
					PlayersData[_name].point1 = Vector3i()
				end
				PlayersData[_name].point1.x = IN_x
				PlayersData[_name].point1.y = IN_y
				PlayersData[_name].point1.z = IN_z
				Player:SendMessage("First portal entrance volume point selected at: (" .. cChatColor.LightGreen .. IN_x .. cChatColor.White .. "," .. cChatColor.LightGreen .. IN_y .. cChatColor.White .. "," .. cChatColor.LightGreen .. IN_z .. cChatColor.White .. ")")
				Player:SendMessage(cChatColor.LightBlue .. "Now select the second portal entrance volume point.")
				PlayersData[_name].IsRightclicking = true
				return true
			end
		else
			if (IN_x ~= -1 and IN_y ~= 255 and IN_z ~= -1) then
				if (ItemToString(Player:GetEquippedItem()) == "woodsword") then
					if (PlayersData[_name].point2 == nil) then
						PlayersData[_name].point2 = Vector3i()
					end
					PlayersData[_name].point2.x = IN_x
					PlayersData[_name].point2.y = IN_y
					PlayersData[_name].point2.z = IN_z
					Player:SendMessage("Second portal entrance volume point selected at: (" .. cChatColor.LightGreen .. IN_x .. cChatColor.White .. "," .. cChatColor.LightGreen .. IN_y .. cChatColor.White .. "," .. cChatColor.LightGreen .. IN_z .. cChatColor.White .. ")")
					PlayersData[_name].IsRightclicking = false
					return true
				end
			end
		end
	end
	return false
end