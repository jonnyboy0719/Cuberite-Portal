function worldOption(name)
	return [[
		<option value=']] .. name .. [['>]] .. name .. [[</option>
	]]
end

function worldsOptions()
	local options = ""
	for index, worldName in pairs(WORLDS) do
		options = options .. worldOption(worldName)
	end

	return options
end

function get(table, key, default)
	if table ~= nil and table[key] ~= nil then
		if type(table[key]) == 'table' then
			return arrayTableToString(table[key])
		end
		return table[key]
	end
	return default
end

function renderGuiForm(portalConfigs, portalToEditName, path)
	local previewItems = ""
	for portalName, config in pairs(portalConfigs) do
		previewItems = previewItems .. makePreviewItem(portalName, config)
	end

	local editPortal = DATA.portals[portalToEditName]
	local buttonText = "ADD"
	local name = ""
	if editPortal ~= nil then
		buttonText = "SAVE"
		name = portalToEditName
	end

	local globalDisableMessage = DATA.all_portals_disabled and "Disable" or "Enable"

	return [[ 
		<style> ]]
			.. CSS_STYLES .. [[
		</style> ]] .. [[
	  <form method="post" class="global-disable-form" >
	    <input hidden name='disable' value='global_disable' />
	    <span>Global portal lock </span>
			<button type="submit">]] .. globalDisableMessage .. [[</button>
	  </form>
		<form class='table' id='portalForm' method="post" action="]] .. path .. [[">
			<div class='block'>
				<h3>Name</h3>
				<input name='name' type='text' value=']] .. name .. [['/>
			</div>
			
			<div class='block'>
				<h3>World</h3>
				<select class='world-field__select' name='world' value=']] .. get(editPortal, "world", "") .. [['>
				 ]] .. worldsOptions() .. [[
				</select>
			</div>
			
			<div class='block'>
				<h3>Target Portal Name</h3>
				<input name='target' type='text' value=']] .. get(editPortal, "target", "") .. [['/>
			</div>

			]] .. makePointBlock("Portal Point 1", "point1", editPortal) .. [[
			]] .. makePointBlock("Portal Point 2", "point2", editPortal) .. [[
			]] .. makePointBlock("Portal Destination Point", "destination", editPortal) .. [[

			<button class='submit-btn' type='submit'>]] .. buttonText.. [[</button>
		</form>

		<div class='preview'>
			]] .. previewItems .. [[
		</div>
	]]
end

function makePointBlock(title, prefix, editPortal)
	return [[
		<div class='block'>
			<h3>]] .. title .. [[</h3>
			<div class='num-field'>
				<label class='num-field__label'>X:</label>
				<input name=']] .. prefix .. "_x" ..  [[' class='num-field__input' type='number' value=']] .. get(editPortal, prefix .. "_x", "") .. [['/>
			</div>
			<div class='num-field'>
				<label class='num-field__label'l>Y:</label>
				<input name=']] .. prefix .. "_y" ..  [[' class='num-field__input' type='number' value=']] .. get(editPortal, prefix .. "_y", "") .. [['/>
			</div>
			<div class='num-field'>
				<label class='num-field__label'>Z:</label>
				<input name=']] .. prefix .. "_z" ..  [[' class='num-field__input' type='number' value=']] .. get(editPortal, prefix .. "_z", "") .. [['/>
			</div>
		</div> 
	]]
end

function makePreviewItem(portalName, portalConfig)
	local p1 = getPoints('point1', portalConfig)
	local p2 = getPoints('point2', portalConfig)
	local dest = getPoints('destination', portalConfig)
	local disableText = portalConfig.disabled and "enable" or "disable"
	return [[
	<div class='preview-item'>
		<div class='preview-item__left'>
			<h3 class='preview-item__name'>]] .. portalName .. [[</h3>
			<p>world: ]] .. portalConfig.world .. [[</p>
			<p>target: ]] .. arrayTableToString(portalConfig.target)  .. [[</p>
			<p>disabled: ]] .. tostring(portalConfig.disabled) .. [[</p>
		</div>
		<div class='preview-item__right'>
			]] .. previewPointBox("Point 1", p1.x, p1.y, p1.z) .. [[
			]] .. previewPointBox("Point 2", p2.x, p2.y, p2.z) .. [[
			]] .. previewPointBox("Dest", dest.x, dest.y, dest.z) .. [[
			<form method="get" >
				<input hidden type="text" name='edit' value=']] .. portalName .. [[' />
				<button class="preview-item__edit">Edit</button>
			</form>
			<form method="post">
				<input hidden name='del' value=']] .. portalName .. [[' />
				<button class="preview-item__del">Del</button>
			</form>
			<form method="post">
				<input hidden name='disable' value=']] .. portalName .. [[' />
				<button class="preview-item__disable">]] .. disableText .. [[</button>
			</form>
		</div>
	</div>
	]]
end

function previewPointBox(label, x, y, z)
	return [[
		<div class="preview-item__point-box">
			<h3>]] .. label .. [[</h3>
			<ul>
				<li>X: ]] .. x .. [[</li>
				<li>Y: ]] .. y .. [[</li>
				<li>Z: ]] .. z .. [[</li>
			</ul>
		</div>
	]]
end