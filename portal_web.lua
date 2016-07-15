function HandleRequest_Portals(Request)
	local Query = getQuery(Request.URL)
	if Request.Method == 'POST' then
		local params = Request.PostParams
		local name = params['name']
		local del = params['del']

		if name then
			saveNewPortal(name, params)
		end

		if del then
			delPortal(del)
		end
	end

	local path = StringSplit(Request.URL, "?")[1]
	return renderGuiForm(DATA.portals, Query.edit, path)
end

function saveNewPortal(name, fields)
	if not DATA.portals[name] then
		DATA.portals[name] = {}
	end

	for key, val in pairs(fields) do
		if key ~= "name" then
			DATA.portals[name][key] = val
		end
	end
end

function delPortal(portalName)
		if DATA.portals[portalName] then
			DATA.portals[portalName] = nil
		end
end

function getQuery(url)
	-- local <return vals here> = cUrlParser:Parse( url ) -- this did not work for some reason
	local Query = StringSplit(url, '?')[2]
	local querySplit = StringSplit(Query, '&')
	local query = {}
	for i, val in pairs(querySplit) do
		local keyVal = StringSplit(val, '=')
		query[keyVal[1]] = keyVal[2]
	end
	return query
end
