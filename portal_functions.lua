function HandleToggleCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		local playerData = DATA.players[Player:GetName()]

		if playerData.HasToolEnabled == 1 then
			playerData.HasToolEnabled = 0
			Player:SendMessage("Your wooden sword will now act as usual")
		else
			playerData.HasToolEnabled = 1
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
					portalData.target = ""
					portalData.portal_point1_x = point1.x
					portalData.portal_point1_y = point1.y
					portalData.portal_point1_z = point1.z
					portalData.portal_point2_x = point2.x
					portalData.portal_point2_y = point2.y
					portalData.portal_point2_z = point2.z
					portalData.destination_x = 0
					portalData.destination_y = 0
					portalData.destination_z = 0

					playerData.point1 = nil
					playerData.point2 = nil

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
	if (Player:HasPermission("portal.create") == true) then
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
	else
		Player:SendMessage("You're not allowed to create destinations")
	end
	return true
end

function HandleMakeEnterCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		if (#Split == 3) then
			local portal1Name = Split[2]
			local portal2Name = Split[3]

			if portal1Name ~= "" then
				local portalData = DATA.portals[portal1Name]
				if not DATA.portals[portal2Name] then
					Player:SendMessage('The id "' .. cChatColor.LightBlue .. portal2Name .. cChatColor.White .. '" doesn\'t exist!')
					return true
				end

				portalData.target = portal2Name
				Player:SendMessage('Entrance from "' .. cChatColor.LightBlue .. portal1Name .. cChatColor.White .. '" to "' .. cChatColor.LightBlue .. portal2Name .. cChatColor.White .. '" created!')
			else
				Player:SendMessage('You can\'t set the target as itself!')
			end
		else
			Player:SendMessage("Usage: "..Split[1].." <id> <target_id>")
		end
	else
		Player:SendMessage("You're not allowed to connect 2 portal destinations")
	end
	return true
end

function HandleListPortals(Split, Player)
	Player:SendMessage("name -> target")
	Player:SendMessage("--------------")
	for k, v in pairs(DATA.portals) do
		Player:SendMessage(k .. " -> " .. DATA.portals[k].target)
	end
	return true
end

function HandleListPortalDetails(Split, Player)
	local portalName = Split[2]
	if not portalName then
		Player:SendMessage(cChatColor.Red .. "you must supply a portal name")
		return true
	end

	local portalData = DATA.portals[portalName]
	if not portalData then
		Player:SendMessage(cChatColor.Red .. "portal " .. portalName .. "Does not exist")  
		return true
	end

	local destPoints = getPoints("destination", portalData)
	local point1 = getPoints("portal_point1", portalData)
	local point2 = getPoints("portal_point2", portalData)

	Player:SendMessage("portal: " .. portalName)
	Player:SendMessage("--------------")
	Player:SendMessage("target = " .. portalData.target)
	Player:SendMessage("world = " .. portalData.world)
	Player:SendMessage("dest = " .. destPoints.x .. ", " .. destPoints.y .. ", " .. destPoints.z)
	Player:SendMessage("point 1 = " .. point1.x .. ", " .. point1.y .. ", " .. point1.z)
	Player:SendMessage("point 2 = " .. point2.x .. ", " .. point2.y .. ", " .. point2.z)
	Player:SendMessage("--------------")
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
			portalData["target"] = Portalini:GetValue( portalName , "target")
			portalData["portal_point1_x"] = Portalini:GetValueI( portalName , "portal_point1_x")
			portalData["portal_point1_y"] = Portalini:GetValueI( portalName , "portal_point1_y")
			portalData["portal_point1_z"] = Portalini:GetValueI( portalName , "portal_point1_z")
			portalData["portal_point2_x"] = Portalini:GetValueI( portalName , "portal_point2_x")
			portalData["portal_point2_y"] = Portalini:GetValueI( portalName , "portal_point2_y")
			portalData["portal_point2_z"] = Portalini:GetValueI( portalName , "portal_point2_z")
			portalData["destination_x"] = Portalini:GetValueI( portalName , "destination_x")
			portalData["destination_y"] = Portalini:GetValueI( portalName , "destination_y")
			portalData["destination_z"] = Portalini:GetValueI( portalName , "destination_z")
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
			 ini:SetValue( key , "target", portalData["target"])
			 ini:SetValueI( key , "portal_point1_x", portalData["portal_point1_x"])
			 ini:SetValueI( key , "portal_point1_y", portalData["portal_point1_y"])
			 ini:SetValueI( key , "portal_point1_z", portalData["portal_point1_z"])
			 ini:SetValueI( key , "portal_point2_x", portalData["portal_point2_x"])
			 ini:SetValueI( key , "portal_point2_y", portalData["portal_point2_y"])
			 ini:SetValueI( key , "portal_point2_z", portalData["portal_point2_z"])
			 ini:SetValueI( key , "destination_x", portalData["destination_x"])
			 ini:SetValueI( key , "destination_y", portalData["destination_y"])
			 ini:SetValueI( key , "destination_z", portalData["destination_z"])
		else
			ini:AddKeyName(key)
			ini:AddValue( key , "world", portalData["world"])
			ini:AddValue( key , "target", portalData["target"])
			ini:AddValueI( key , "portal_point1_x", portalData["portal_point1_x"])
			ini:AddValueI( key , "portal_point1_y", portalData["portal_point1_y"])
			ini:AddValueI( key , "portal_point1_z", portalData["portal_point1_z"])
			ini:AddValueI( key , "portal_point2_x", portalData["portal_point2_x"])
			ini:AddValueI( key , "portal_point2_y", portalData["portal_point2_y"])
			ini:AddValueI( key , "portal_point2_z", portalData["portal_point2_z"])
			ini:AddValueI( key , "destination_x", portalData["destination_x"])
			ini:AddValueI( key , "destination_y", portalData["destination_y"])
			ini:AddValueI( key , "destination_z", portalData["destination_z"])
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

function playerIniToTable(playerini)
	local playerData = {}
	enabledPlayers = playerini:GetNumKeys()
	if enabledPlayers > 0 then
		for i=0, enabledPlayers - 1 do
			local Tag = playerini:GetKeyName(i)
			playerData[Tag] = {}
			-- HasToolEnabled will be parsed as bool once new release comes out with cJson fix
			playerData[Tag]["HasToolEnabled"] = playerini:GetValueI(Tag , "HasToolEnabled")
		end
	end

	return playerData
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

				vector1.x = v["portal_point1_x"]
				vector1.y = v["portal_point1_y"]
				vector1.z = v["portal_point1_z"]

				vector2.x = v["portal_point2_x"]
				vector2.y = v["portal_point2_y"]
				vector2.z = v["portal_point2_z"]

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
 return num .. " portal entrance volume point selected at: (" .. 
	 cChatColor.LightGreen .. x .. cChatColor.White .. "," .. 
	 cChatColor.LightGreen .. y .. cChatColor.White .. "," .. 
	 cChatColor.LightGreen .. z .. cChatColor.White .. ")"
end

function getPoints(prefix, data)
	local table = {}
	table.x = data[prefix .. "_x"]
	table.y = data[prefix .. "_y"]
	table.z = data[prefix .. "_z"]

	return table
end