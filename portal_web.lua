function ShowPortalSettings(Request)
	local Content = ""
	local InfoMsg = nil
	local SettingsIni = cIniFile()
	local inifile = "portals_portals.ini"
	
	if not(SettingsIni:ReadFile(inifile)) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read ]] .. inifile .. [[!</b>]]
	end
	
	if (Request.PostParams['SettingsIniContent'] ~= nil) then
		local File = io.open(inifile, "w")
		File:write(Request.PostParams['SettingsIniContent'])
		File:close()
	end
	
	local SettingsIniContent = cFile:ReadWholeFile(inifile)
	Content = Content .. [[<br />
	<form method="post">
	<textarea style="width: 100%; height: 500px;" name="SettingsIniContent">]] .. SettingsIniContent .. [[</textarea>
	<input type="submit" value="Save Settings" name="world_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end

function ShowPlayerSettings(Request)
	local Content = ""
	local InfoMsg = nil
	local SettingsIni = cIniFile()
	local inifile = "portals_players.ini"
	
	if not(SettingsIni:ReadFile(inifile)) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read ]] .. inifile .. [[!</b>]]
	end
	
	if (Request.PostParams['SettingsIniContent'] ~= nil) then
		local File = io.open(inifile, "w")
		File:write(Request.PostParams['SettingsIniContent'])
		File:close()
	end
	
	local SettingsIniContent = cFile:ReadWholeFile(inifile)
	Content = Content .. [[<br />
	<form method="post">
	<textarea style="width: 100%; height: 500px;" name="SettingsIniContent">]] .. SettingsIniContent .. [[</textarea>
	<input type="submit" value="Save Settings" name="world_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end

function HandleRequest_Portals(Request)
	local Content = ""
	
	Content = Content .. ShowPortalSettings(Request)
	
	return Content
end

function HandleRequest_Players(Request)
	local Content = ""
	
	Content = Content .. ShowPlayerSettings(Request)
	
	return Content
end
