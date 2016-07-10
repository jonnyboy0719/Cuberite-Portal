WARNING_MESSAGE = "WARNING: Any changes made here might require a server restart in order to be applied!"

PLAYERS_FIELD_KEY = "players_ini"
PORTALS_FIELD_KEY = 'portals_ini'

function textareaFormPage(content, fieldName, message)
  content = content or ""
  return [[
    <br />
    <form method="post">
      <textarea hidden style="width: 100%; height: 500px;" name="]] .. fieldName .. [[">]] .. content .. [[</textarea>
      <input type="submit" value="Save Settings" name="world_submit" />
      <p>]] .. message .. [[</p>
    </form>
    <div id='gui-form'>
      <form>
      </form>
    </div>
  ]]
end

function errorMessage(fileName)
  return [[<b style="color: red;">]] .. fileName .. [[!</b>]]
end

-- function ShowPortalSettings(Request)
--   local PORTALS_FIELD_KEY = 'portals_ini'
--   local message = validate(PORTALS_INI_FILE, PORTALS_FIELD_KEY)

--  if (Request.Method == "POST") then
--     local val = Request.PostParams[PORTALS_FIELD_KEY]
--     if (val ~= nil) then
--       pcall(saveFile, PORTALS_INI_FILE, val)
--     end
--  end

--  local SettingsIniContent = cFile:ReadWholeFile(PORTALS_INI_FILE)
--   return textareaFormPage(SettingsIniContent, PORTALS_FIELD_KEY, message)
-- end

function ShowPlayerSettings(Request)
  -- local message = validate(PLAYERS_INI_NAME, PLAYERS_FIELD_KEY)
  if (Request.Method == "POST") then
    local val = Request.PostParams[PLAYERS_FIELD_KEY]
    if (val ~= nil) then
      saveFile(PLAYERS_INI_NAME , val)
    end
  end

  return [[
    <div>
      ]] .. playersDisplay(DATA.players) .. [[
      <script> window.players = ]] .. cJson:Serialize(DATA.players) .. [[ </script>
    </div>
  ]]
    -- return textareaFormPage(SettingsIniContent, PLAYERS_FIELD_KEY, message)
end

function playersDisplay(players)
  str = ""
  for key, val in pairs(players) do
    val = players[key]["HasToolEnabled"] and "true" or "false"
    str = str .. [[
      <div>
        ]] .. key .. " HasToolEnabled: " .. val .. [[
      </div>
    ]]
  end

  return str
end

function HandleRequest_Portals(Request)
  message = ""
  if Request.Method == 'GET' then
    local success, fileContent = pcall(cFile:ReadWholeFile(PORTALS_INI_NAME))
    if not success then
      message = "Could not read " .. PORTALS_INI_NAME
    end

    return textareaFormPage(fileContent, PLAYERS_FIELD_KEY, message)
  elseif Request.Method == 'POST' then
    local val = Request.PostParams[PORTALS_FIELD_KEY]
    if (val) then
      -- save in a tmp file and validate
      local success, _ = pcall(saveFile, PORTALS_INI_NAME, val)
      local content = val
      if not success then
        local fileOpened, content = pcall(cFile:ReadWholeFile(PORTALS_INI_NAME))
        message = 'Error: could not save file'
      end
      return textareaFormPage(content, PORTALS_FIELD_KEY, message)
    else
      message = "Error: the " .. PORTALS_FIELD_KEY .. " field was not recieved"
    end

    -- left here as a default handler
    local success, fileContent = pcall(cFile:ReadWholeFile(PORTALS_INI_NAME))
    return textareaFormPage(fileContent, PORTALS_FIELD_KEY, message)
  end
end

function HandleRequest_Players(Request)
  return ShowPlayerSettings(Request)
end
