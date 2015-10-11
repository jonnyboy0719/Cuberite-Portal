function HandleToggleCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
	
		local playerini = cIniFile()
		local GetIniFileName = "portals_players.ini"
		local SetValue
		
		playerini:ReadFile(GetIniFileName)
		
		if (playerini:GetValueI( Player:GetName() , "HasToolEnabled") == 0) then
			SetValue = 1
			Player:SendMessage("Your wooden sword will now select portal entrance zone")
		else
			SetValue = 0
			Player:SendMessage("Your wooden sword will now act as usual")
		end
		
		playerini:DeleteValue(Player:GetName(), "HasToolEnabled")
		
		playerini:SetValue(Player:GetName(), "HasToolEnabled", SetValue)
		
		playerini:WriteFile(GetIniFileName)
		
	end
	return true
end

function HandleMakeWarpCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		if (#Split == 2) then
			local warpini = cIniFile()
			local GetIniFileName = "portals_portals.ini"
			
			warpini:ReadFile(GetIniFileName)
			
			local getkeyid = warpini:FindKey( Split[2] )
			
			if getkeyid == -1 then
				-----
				local _name = Player:GetName()
				local getworldname = Player:GetWorld():GetName()
				local portal_x = PlayersData[_name].point1.x
				local portal_y = PlayersData[_name].point1.y
				local portal_z = PlayersData[_name].point1.z
				local portal_p2_x = PlayersData[_name].point2.x
				local portal_p2_y = PlayersData[_name].point2.y
				local portal_p2_z = PlayersData[_name].point2.z
				-----
				
				warpini:SetValue(Split[2], "world", getworldname)
				warpini:SetValue(Split[2], "target", "")
				warpini:SetValueI(Split[2], "portal_point1_x", portal_x)
				warpini:SetValueI(Split[2], "portal_point1_y", portal_y)
				warpini:SetValueI(Split[2], "portal_point1_z", portal_z)
				warpini:SetValueI(Split[2], "portal_point2_x", portal_p2_x)
				warpini:SetValueI(Split[2], "portal_point2_y", portal_p2_y)
				warpini:SetValueI(Split[2], "portal_point2_z", portal_p2_z)
				warpini:SetValueI(Split[2], "destination_x", 0)
				warpini:SetValueI(Split[2], "destination_y", 0)
				warpini:SetValueI(Split[2], "destination_z", 0)
				
				warpini:WriteFile(GetIniFileName)
				
				Player:SendMessage('Warp "' .. cChatColor.LightBlue .. Split[2] .. cChatColor.White .. '" created!')
				
				LoadPortalsData()
			else
				Player:SendMessage('There already is a warp, named "' .. cChatColor.LightBlue .. Split[2] .. cChatColor.White .. '"')
			end
		else
			Player:SendMessage("/pwarp <id>")
		end
	else
		Player:SendMessage("You're not allowed to create warps")
	end
	return true
end

function HandleMakeDestinationCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		if (#Split == 2) then
			local warpini = cIniFile()
			local GetIniFileName = "portals_portals.ini"
			
			warpini:ReadFile(GetIniFileName)
			
			local getkeyid = warpini:FindKey( Split[2] )
			
			if getkeyid ~= -1 then
				-----
				local player_pos_x = Player:GetPosX()
				local player_pos_y = Player:GetPosY()
				local player_pos_z = Player:GetPosZ()
				-----
				
				warpini:SetValueI(Split[2], "destination_x", player_pos_x)
				warpini:SetValueI(Split[2], "destination_y", player_pos_y)
				warpini:SetValueI(Split[2], "destination_z", player_pos_z)
				
				warpini:WriteFile(GetIniFileName)
				
				Player:SendMessage('Destination for Portal ID "' .. cChatColor.LightBlue .. Split[2] .. cChatColor.White .. '" created!')
				
				LoadPortalsData()
			else
				Player:SendMessage('The id "' .. cChatColor.LightBlue .. Split[2] .. cChatColor.White .. '" doesn\'t exist!')
			end
		else
			Player:SendMessage("/penter <id> <target_id>")
		end
	else
		Player:SendMessage("You're not allowed to create destinations")
	end
	return true
end

function HandleMakeEnterCommand(Split, Player)
	if (Player:HasPermission("portal.create") == true) then
		if (#Split == 3) then
			local warpini = cIniFile()
			local GetIniFileName = "portals_portals.ini"
			
			warpini:ReadFile(GetIniFileName)
			
			if Split[2] ~= "" then
				local getkeyid = warpini:FindKey( Split[3] )
				if getkeyid == -1 then
					Player:SendMessage('The id "' .. cChatColor.LightBlue .. Split[3] .. cChatColor.White .. '" doesn\'t exist!')
					return true
				end
				-----
				local player_pos_x = Player:GetPosX()
				local player_pos_y = Player:GetPosY()
				local player_pos_z = Player:GetPosZ()
				-----
				
				warpini:SetValue(Split[2], "target", Split[3])
				warpini:SetValueI(Split[2], "destination_x", player_pos_x)
				warpini:SetValueI(Split[2], "destination_y", player_pos_y)
				warpini:SetValueI(Split[2], "destination_z", player_pos_z)
				
				warpini:WriteFile(GetIniFileName)
				
				Player:SendMessage('Entrance from "' .. cChatColor.LightBlue .. Split[2] .. cChatColor.White .. '" to "' .. cChatColor.LightBlue .. Split[3] .. cChatColor.White .. '" created!')
				
				LoadPortalsData()
			else
				Player:SendMessage('You can\'t set the target as itself!')
			end
		else
			Player:SendMessage("/pdest <id>")
		end
	else
		Player:SendMessage("You're not allowed to connect 2 portal destinations")
	end
	return true
end

function LoadPortalsData()
	local Portalini = cIniFile()
	if (Portalini:ReadFile("portals_portals.ini")) then
		warpNum = Portalini:GetNumKeys();
		for i=0, warpNum do
			local Tag = Portalini:GetKeyName(i)
			PortalsData[Tag] = {}
			PortalsData[Tag]["world"] = Portalini:GetValue( Tag , "world")
			PortalsData[Tag]["target"] = Portalini:GetValue( Tag , "target")
			PortalsData[Tag]["portal_point1_x"] = Portalini:GetValueI( Tag , "portal_point1_x")
			PortalsData[Tag]["portal_point1_y"] = Portalini:GetValueI( Tag , "portal_point1_y")
			PortalsData[Tag]["portal_point1_z"] = Portalini:GetValueI( Tag , "portal_point1_z")
			PortalsData[Tag]["portal_point2_x"] = Portalini:GetValueI( Tag , "portal_point2_x")
			PortalsData[Tag]["portal_point2_y"] = Portalini:GetValueI( Tag , "portal_point2_y")
			PortalsData[Tag]["portal_point2_z"] = Portalini:GetValueI( Tag , "portal_point2_z")
			PortalsData[Tag]["destination_x"] = Portalini:GetValueI( Tag , "destination_x")
			PortalsData[Tag]["destination_y"] = Portalini:GetValueI( Tag , "destination_y")
			PortalsData[Tag]["destination_z"] = Portalini:GetValueI( Tag , "destination_z")
		end
	end
end

function LoadPlayersData()
	local Portalini = cIniFile()
	if (Portalini:ReadFile("portals_players.ini")) then
		warpNum = Portalini:GetNumKeys();
		for i=0, warpNum do
			local Tag = Portalini:GetKeyName(i)
			PortalsData[Tag] = {}
			PortalsData[Tag]["hastool"] = Portalini:GetValueI( Tag , "HasToolEnabled")
		end
	end
end

function FindZone(Player)
	local _check_cuboid = cCuboid()
	local _player_pos = Player:GetPosition()
	_player_pos.x = math.floor(_player_pos.x)
	_player_pos.y = math.floor(_player_pos.y)
	_player_pos.z = math.floor(_player_pos.z)
	for k,v in pairs(PortalsData) do
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