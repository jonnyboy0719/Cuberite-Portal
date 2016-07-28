function HandleToggleCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		local playerData = DATA.players[Player:GetName()]

		if playerData.HasToolEnabled == true then
			playerData.HasToolEnabled = false
			Player:SendMessage("Your wooden sword will now act as usual")
		else
			playerData.HasToolEnabled = true
			Player:SendMessage("Your wooden sword will now select portal entrance zone")
		end
	end
	return true
end

function HandleMakeWarpCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		if (#Split == 2) then
			local portalName = Split[2]
			if not DATA.portals[portalName] then -- if portal name not taken
				local playerData = DATA.players[Player:GetName()]

				if not (playerData.point1 == nil or playerData.point2 == nil) then
					local point1 = playerData.point1
					local point2 = playerData.point2
					DATA.portals[portalName] = {}
					local portalData = DATA.portals[portalName]

					portalData.world = Player:GetWorld():GetName()
					portalData.target = {}
					portalData.point1_x = point1.x
					portalData.point1_y = point1.y
					portalData.point1_z = point1.z
					portalData.point2_x = point2.x
					portalData.point2_y = point2.y
					portalData.point2_z = point2.z
					portalData.destination_x = 0
					portalData.destination_y = 0
					portalData.destination_z = 0
					portalData.disabled = false

					Player:SendMessage('Warp "' .. cChatColor.LightBlue .. portalName .. cChatColor.White .. '" created!')
				else
					Player:SendMessage("The portal volume can't be empty!")
				end
			else
				Player:SendMessage('There already is a warp, named "' .. cChatColor.LightBlue .. portalName .. cChatColor.White .. '"')
			end
		else
			Player:SendMessage("Usage: "..Split[1].." <id>")
		end
	else
		Player:SendMessage("You're not allowed to create warps")
	end
	return true
end

function HandleMakeDestinationCommand(Split, Player)
	if (#Split == 2) then
		local portalName = Split[2]
		local portalData = DATA.portals[portalName]
		if portalData ~= nil then
			portalData.destination_x = Player:GetPosX()
			portalData.destination_y = Player:GetPosY()
			portalData.destination_z = Player:GetPosZ()

			Player:SendMessage('Destination for Portal ID "' .. cChatColor.LightBlue .. portalName .. cChatColor.White .. '" created!')
		else
			Player:SendMessage('The id "' .. cChatColor.LightBlue .. portalName .. cChatColor.White .. '" doesn\'t exist!')
		end
	else
		Player:SendMessage("Usage: "..Split[1].." <id>")
	end
	return true
end

function HandleConnectCmd(Split, Player)
	if (#Split == 3) then
		local portal1Name = Split[2]
		local portal2Name = Split[3]

		if portal1Name ~= "" then
			local portalData = DATA.portals[portal1Name]
			if not DATA.portals[portal2Name] then
				Player:SendMessage('The id "' .. cChatColor.LightBlue .. portal2Name ..
					cChatColor.White .. '" doesn\'t exist!')
				return true
			end
			if not portalData then
				Player:SendMessage('The id "' .. cChatColor.LightBlue ..
					portal1Name .. cChatColor.White .. '" doesn\'t exist!')
				return true
			end

			if includes(portalData.target, portal2Name) then -- remove from targets
				local index = find(portalData.target, portal2Name)
				table.remove(portalData.target, index)
				Player:SendMessage(portal2Name .. " removed from targets")
			else -- add to targets
				table.insert(portalData.target, portal2Name)
				Player:SendMessage('Entrance from "' .. cChatColor.LightBlue ..
					portal1Name .. cChatColor.White .. '" to "' ..
					  cChatColor.LightBlue .. portal2Name .. cChatColor.White .. '" created!')
			end
		else
			Player:SendMessage('You can\'t set the target as itself!')
		end
	else
		Player:SendMessage("Usage: "..Split[1].." <id> <target_id>")
	end
	return true
end

function findKey(table, val)
	if (not table or not val) then return false end
	for k, v in pairs(table) do
		if k == val then return true end
	end
	return false
end

function HandleHelpCmd(Split, Player)
	if #Split == 1 then
		Player:SendMessage("Valid commands:")
		Player:SendMessage("---------------")
		for k, v in pairs(g_PluginInfo.Commands) do
			Player:SendMessage(k)	
		end
		return true
	end

	local command = "/" .. Split[2]
	if g_PluginInfo.Commands[command] ~= nil then
		local commandConfig = g_PluginInfo.Commands[command]
		Player:SendMessage("---------------")
		Player:SendMessage("Command: " .. command)
		Player:SendMessage(commandConfig.HelpString)
		if commandConfig.ParameterCombinations ~= nil then
			Player:SendMessage("valid argument combinations:")
			for i, v in ipairs(commandConfig.ParameterCombinations) do
				local params = v.Params ~= "" and v.Params or "no args"
				Player:SendMessage(cChatColor.LightBlue .. "params: " .. 
					cChatColor.LightGreen .. params)
				Player:SendMessage(v.Help)
			end
		end
		Player:SendMessage("---------------")
	else
		Player:SendMessage("Must provide valid command name")	
	end
	return true
end

function HandleInfoCmd(Split, Player)
	local arg = Split[2]
	if not arg then
		HandleListPortals(Split, Player)
		return true
	elseif findKey(DATA.portals, arg) then
		HandleListPortalDetails(Split, Player)
		return true
	elseif (findKey(DATA.players, arg) or arg == "me") then
		HandlePLayerDetails(Split, Player)	
		return true
	end
	Player:SendMessage(cChatColor.Red .. "you must supply a valid portal/player name")
	return true
end

function HandleListPortals(Split, Player)
	Player:SendMessage("name -> target")
	Player:SendMessage("--------------")
	for k, v in pairs(DATA.portals) do
		Player:SendMessage(k .. " -> " .. arrayTableToString(DATA.portals[k].target))
	end
	return true
end

function HandleListPortalDetails(Split, Player)
	local portalName = Split[2]
	local portalData = DATA.portals[portalName]

	local destPoints = getPoints("destination", portalData)
	local point1 = getPoints("point1", portalData)
	local point2 = getPoints("point2", portalData)

	Player:SendMessage("portal: " .. portalName)
	Player:SendMessage("--------------")
	Player:SendMessage("disabled = " .. tostring(portalData.disabled))
	Player:SendMessage("target = " .. arrayTableToString(portalData.target))
	Player:SendMessage("world = " .. portalData.world)
	Player:SendMessage("dest = " .. destPoints.x .. ", " .. destPoints.y .. ", " .. destPoints.z)
	Player:SendMessage("point 1 = " .. point1.x .. ", " .. point1.y .. ", " .. point1.z)
	Player:SendMessage("point 2 = " .. point2.x .. ", " .. point2.y .. ", " .. point2.z)
	Player:SendMessage("--------------")
	return true
end

function handleManageCmd(Split, Player)
	local command = Split[2]
	local portal = Split[3]

	if portal == nil then
		Player:SendMessage("you must supply portal name or specify 'all'")
		return true
	end

	if command ~= "enable" and command ~= "disable" then
		Player:SendMessage("Valid sub-commands are: enable, disable")
		return true
	end

	if portal == "all" then
		HandleToggleAllPortalsdisabled(command, Player)
		return true
	end

	HandleToggleDisablePortal(command, portal, Player)
	return true
end

function HandleToggleDisablePortal(command, portal, Player)
	local portalData = DATA.portals[portal]

	if portalData then
		if command == "disable" then
			portalData.disabled = true
			Player:SendMessage("portal " .. portal .. " disabled")
		elseif command == "enable" then
			portalData.disabled = false
			Player:SendMessage("portal " .. portal .. " Enabled")
		end
	else
		Player:SendMessage("portal " .. portal .. " does not exist")	
	end
	return true
end

function HandlePLayerDetails(Split, Player)
	-- for debugging
	local playerName = Split[2]
	if Split[2] == "me" then
		playerName = Player:GetName()
	end
	local playerData = DATA.players[playerName]

	Player:SendMessage("Current player data: ")
	for k, v in pairs(playerData) do
		Player:SendMessage(k .. ": " .. tostring(v))
	end
	return true
end

function HandleToggleAllPortalsdisabled(command, Player)
	local color = cChatColor.Red
	if command == "enable" then
		DATA.all_portals_disabled = false
		color = cChatColor.LightBlue
	elseif command == "disable" then
		DATA.all_portals_disabled = true
	end

  Player:SendMessage(color .. "All portals are now " .. command .. "d")
  return true
end

function HandleTeleport(Split, Player)
	local portalName = playerInAPortal(Player)
	if portalName then
		local currentPortal = DATA.portals[portalName]
		local targetName = Split[2]
		if targetName == nil then
			Player:SendMessage("portal option not provided")
			return true
		end

		if not includes(currentPortal.target, targetName) then
			Player:SendMessage("Not a valid option.")
			Player:SendMessage("Choose from: " .. arrayTableToString(currentPortal.target))
			return true
		end

		if targetPortalHasNoDest(DATA.portals[targetName]) then
			Player:SendMessage(cChatColor.Red .. targetName .. " Does not have a destination set")
			return true
		end

		local playerName = Player:GetName()
		local playerData = DATA.players[playerName]
		playerData.targetPortalName = targetName
		playerData.state = PLAYER_STATES.TELEPORTING
		teleportPlayer(Player)  -- !!!!!!!! need to pass in the target portal here
	end
	return true
end

function portalIniToTable(Portalini)
	local PortalsData = {}
	local warpNum = Portalini:GetNumKeys();
	if warpNum > 0 then
		for i=0, warpNum - 1 do
			local portalName = Portalini:GetKeyName(i)
			PortalsData[portalName] = {}
			local portalData = PortalsData[portalName]

			portalData["world"] = Portalini:GetValue( portalName , "world")
			portalData["target"] = StringSplit(Portalini:GetValue( portalName , "target"), ",")
			portalData["point1_x"] = Portalini:GetValueI( portalName , "point1_x")
			portalData["point1_y"] = Portalini:GetValueI( portalName , "point1_y")
			portalData["point1_z"] = Portalini:GetValueI( portalName , "point1_z")
			portalData["point2_x"] = Portalini:GetValueI( portalName , "point2_x")
			portalData["point2_y"] = Portalini:GetValueI( portalName , "point2_y")
			portalData["point2_z"] = Portalini:GetValueI( portalName , "point2_z")
			portalData["destination_x"] = Portalini:GetValueI( portalName , "destination_x")
			portalData["destination_y"] = Portalini:GetValueI( portalName , "destination_y")
			portalData["destination_z"] = Portalini:GetValueI( portalName , "destination_z")
			portalData["disabled"] = intToBool(Portalini:GetValueI( portalName , "disabled"))
			
		end
	end

	return PortalsData
end

function portalDataToIni()
	local ini = DATA.portalIniFile
	for key, val in pairs(DATA.portals) do
		local portalData = DATA.portals[key]
		if ini:FindKey(key) then
			 ini:SetValue( key , "world", portalData["world"])
			 ini:SetValue( key , "target", arrayTableToString(portalData["target"]))
			 ini:SetValueI( key , "point1_x", portalData["point1_x"])
			 ini:SetValueI( key , "point1_y", portalData["point1_y"])
			 ini:SetValueI( key , "point1_z", portalData["point1_z"])
			 ini:SetValueI( key , "point2_x", portalData["point2_x"])
			 ini:SetValueI( key , "point2_y", portalData["point2_y"])
			 ini:SetValueI( key , "point2_z", portalData["point2_z"])
			 ini:SetValueI( key , "destination_x", portalData["destination_x"])
			 ini:SetValueI( key , "destination_y", portalData["destination_y"])
			 ini:SetValueI( key , "destination_z", portalData["destination_z"])
			 ini:SetValueI( key , "disabled", boolToInt( portalData["disabled"]))
		else
			ini:AddKeyName(key)
			ini:AddValue( key , "world", portalData["world"])
			ini:AddValue( key , "target", arrayTableToString(portalData["target"]))
			ini:AddValueI( key , "point1_x", portalData["point1_x"])
			ini:AddValueI( key , "point1_y", portalData["point1_y"])
			ini:AddValueI( key , "point1_z", portalData["point1_z"])
			ini:AddValueI( key , "point2_x", portalData["point2_x"])
			ini:AddValueI( key , "point2_y", portalData["point2_y"])
			ini:AddValueI( key , "point2_z", portalData["point2_z"])
			ini:AddValueI( key , "destination_x", portalData["destination_x"])
			ini:AddValueI( key , "destination_y", portalData["destination_y"])
			ini:AddValueI( key , "destination_z", portalData["destination_z"])
			ini:AddValueI( key , "disabled", boolToInt( portalData["disabled"]))
		end
	end

	-- remove deleted
	local numKeys = ini:GetNumKeys()
	for i=0, numKeys - 1 do
		local portalName = ini:GetKeyName(i)
		if not DATA.portals[portalName] then
			ini:DeleteKey(portalName)
		end
	end 
end

function playerInAPortal(Player)
	local _check_cuboid = cCuboid()
	local _player_pos = Player:GetPosition()
	_player_pos.x = math.floor(_player_pos.x)
	_player_pos.y = math.floor(_player_pos.y)
	_player_pos.z = math.floor(_player_pos.z)
	for k,v in pairs(DATA.portals) do
		if (v["target"]) then
			if (v["world"] == Player:GetWorld():GetName()) then
				local vector1 = Vector3i()
				local vector2 = Vector3i()

				vector1.x = v["point1_x"]
				vector1.y = v["point1_y"]
				vector1.z = v["point1_z"]

				vector2.x = v["point2_x"]
				vector2.y = v["point2_y"]
				vector2.z = v["point2_z"]

				_check_cuboid.p1 = vector1
				_check_cuboid.p2 = vector2
				_check_cuboid:Sort()
				if (_check_cuboid:IsInside(_player_pos)) then
					return k
				end
			end
		end
	end
	return false
end

function portalPointSelectMessage(num, x, y, z)
 return num .. " (" .. 
	 cChatColor.LightGreen .. x .. cChatColor.White .. " , " .. 
	 cChatColor.LightGreen .. y .. cChatColor.White .. " , " .. 
	 cChatColor.LightGreen .. z .. cChatColor.White .. " )"
end

function boolToInt(val)
	if type(val) == "boolean" then
	 if val == false then
			return 0
		else 
			return 1
		end
	end
end

function intToBool(val)
	if type(val) == "number" then
	 if val == 1 then
			return true
		else 
			return false
		end
	end
end

function arrayTableToString(table)
	local string = ""
	for i, v in ipairs(table) do
		local newString = v
		if i ~= #table then
			newString = newString .. ","
		end
		string = string .. newString
	end

	return string
end

function includes(table, val)
	-- check if key exists in array like table
	for i, v in ipairs(table) do
		if v == val then
			return true
		end
	end
	return false
end

function find(table, val)
	-- return index of item in array like table
	for i, v in ipairs(table) do
		if v == val then
			return i
		end
	end
	return 0
end

function getPoints(prefix, data)
	local table = {}
	table.x = data[prefix .. "_x"]
	table.y = data[prefix .. "_y"]
	table.z = data[prefix .. "_z"]

	return table
end