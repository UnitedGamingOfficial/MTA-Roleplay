--[[ GUI Editor - Settings - Client ]]--

settings = {}
settings.gui = {}
settings.guieditor_tutorial_completed = {value = false, type = "boolean"}
settings.guieditor_tutorial_version = {value = "1.0", type = "string"}
settings.guieditor_update_check = {value = false, type = "boolean"}
settings.screen_output_type = {value = false, type = "boolean"}
settings.child_output_type = {value = false, type = "boolean"}
settings.snapping = {value = false, type = "boolean"}
settings.snapping_precision = {value = 3, type = "number"}
settings.snapping_influence = {value = 500, type = "number"}
settings.snapping_recommended = {value = 10, type = "number"}



addEventHandler("onClientResourceStart",root,function()
	settings.gui.window = guiCreateWindow((sx/2)-209,(sy/2)-150,418,300,"GUI Editor Settings",false)
	guiWindowSetSizable(settings.gui.window,false)

	settings.gui.screen_label = guiCreateLabel(10,25,157,56,"Default screen output type:",false,settings.gui.window)
	settings.gui.screen_relative = guiCreateRadioButton(1,15,103,20,"Relative",false,settings.gui.screen_label)
	settings.gui.screen_absolute = guiCreateRadioButton(1,35,103,16,"Absolute",false,settings.gui.screen_label)
	guiRadioButtonSetSelected(settings.gui.screen_absolute,(settings.screen_output_type.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.screen_relative,(settings.screen_output_type.value == true and true or false))

	settings.gui.child_label = guiCreateLabel(247,25,157,56,"Default child output type:",false,settings.gui.window)
	settings.gui.child_relative = guiCreateRadioButton(1,15,103,20,"Relative",false,settings.gui.child_label)
	settings.gui.child_absolute = guiCreateRadioButton(1,35,103,16,"Absolute",false,settings.gui.child_label)
	guiRadioButtonSetSelected(settings.gui.child_absolute,(settings.child_output_type.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.child_relative,(settings.child_output_type.value == true and true or false))

	settings.gui.snapping_label = guiCreateLabel(10,89,157,56,"Element snapping enabled:",false,settings.gui.window)
	settings.gui.snapping_true = guiCreateRadioButton(1,15,103,20,"Enabled",false,settings.gui.snapping_label)
	settings.gui.snapping_false = guiCreateRadioButton(1,35,103,16,"Disabled",false,settings.gui.snapping_label)
	guiRadioButtonSetSelected(settings.gui.snapping_false,(settings.snapping.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.snapping_true,(settings.snapping.value == true and true or false))	
		
	settings.gui.snapping_grid = guiCreateGridList(10,150,399,100,false,settings.gui.window)
	guiGridListAddColumn(settings.gui.snapping_grid,"Setting",0.65)
	guiGridListAddColumn(settings.gui.snapping_grid,"Value",0.15)
	guiGridListAddColumn(settings.gui.snapping_grid,"Default",0.15)
	for i = 1, 4 do
		guiGridListAddRow(settings.gui.snapping_grid)
	end	
	guiGridListSetSelectionMode(settings.gui.snapping_grid,2)

	plotGridlistDefaultSettings()
	plotGridlistSettings()
	
	settings.gui.save_button = guiCreateButton(70,270,70,23,"Save",false,settings.gui.window)
	settings.gui.cancel_button = guiCreateButton(279,270,70,23,"Cancel",false,settings.gui.window)
	
	guiSetVisible(settings.gui.window,false)
	
	for _,gui in pairs(settings.gui) do
		setElementData(gui,"cant_edit",true)
		if getElementType(gui) == "gui-label" or getElementType(gui) == "gui-checkbox" or getElementType(gui) == "gui-radiobutton" then
			setElementData(gui,"cant_highlight",true)
		end
	end

	addEventHandler("onClientGUIDoubleClick",settings.gui.snapping_grid,function(button,state)
		if button == "left" and state == "up" then
			local row,col = guiGridListGetSelectedItem(settings.gui.snapping_grid)
			if row and col and row ~= -1 and col ~= -1 then
				if col == 2 then
					if row == 0 then
						ShowInputBox(nil,"settings_snapping_precision","Enter the new snapping precision. (0-10)")
					elseif row == 1 then
						ShowInputBox(nil,"settings_snapping_influence","Enter the new snapping influence. (0-2000)")
					elseif row == 2 then
						ShowInputBox(nil,"settings_snapping_recommended","Enter the new snap distance. (0-100)")
					end
				end
			end
		end
	end,false)
	
	addEventHandler("onClientGUIClick",settings.gui.save_button,function(button,state)
		if button == "left" and state == "up" then
			saveSettings()
			guiSetVisible(settings.gui.window,false)
		end
	end,false)
	
	addEventHandler("onClientGUIClick",settings.gui.cancel_button,function(button,state)
		if button == "left" and state == "up" then
			guiSetVisible(settings.gui.window,false)
		end
	end,false)	
end)


function plotGridlistDefaultSettings()
	guiGridListSetItemText(settings.gui.snapping_grid,0,3,tostring(settings.snapping_precision.value),false,true)	
	guiGridListSetItemText(settings.gui.snapping_grid,1,3,tostring(settings.snapping_influence.value),false,true)		
	guiGridListSetItemText(settings.gui.snapping_grid,2,3,tostring(settings.snapping_recommended.value),false,true)
end


function plotGridlistSettings()
	guiGridListSetItemText(settings.gui.snapping_grid,0,1,"Element snapping precision",false,false)
	guiGridListSetItemText(settings.gui.snapping_grid,0,2,tostring(settings.snapping_precision.value),false,true)
		
	guiGridListSetItemText(settings.gui.snapping_grid,1,1,"Element snapping influence distance",false,false)
	guiGridListSetItemText(settings.gui.snapping_grid,1,2,tostring(settings.snapping_influence.value),false,true)
	
	guiGridListSetItemText(settings.gui.snapping_grid,2,1,"Element snapping snap distance",false,false)
	guiGridListSetItemText(settings.gui.snapping_grid,2,2,tostring(settings.snapping_recommended.value),false,true)	
end


function saveSettings()
	settings.screen_output_type.value = (guiRadioButtonGetSelected(settings.gui.screen_absolute) == false and true or false)
	settings.child_output_type.value = (guiRadioButtonGetSelected(settings.gui.child_absolute) == false and true or false)
	settings.snapping.value = (guiRadioButtonGetSelected(settings.gui.snapping_true) == true and true or false)
	settings.snapping_precision.value = tonumber(guiGridListGetItemText(settings.gui.snapping_grid,0,2))
	settings.snapping_influence.value = tonumber(guiGridListGetItemText(settings.gui.snapping_grid,1,2))
	settings.snapping_recommended.value = tonumber(guiGridListGetItemText(settings.gui.snapping_grid,2,2))
end


function loadSettings()
	guiRadioButtonSetSelected(settings.gui.screen_absolute,(settings.screen_output_type.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.screen_relative,(settings.screen_output_type.value == true and true or false))

	guiRadioButtonSetSelected(settings.gui.child_absolute,(settings.child_output_type.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.child_relative,(settings.child_output_type.value == true and true or false))

	guiRadioButtonSetSelected(settings.gui.snapping_false,(settings.snapping.value == false and true or false))
	guiRadioButtonSetSelected(settings.gui.snapping_true,(settings.snapping.value == true and true or false))		
	
	plotGridlistSettings()
end


function showSettings()
	guiSetVisible(settings.gui.window,true)
	guiBringToFront(settings.gui.window)
	guiGridListSetSelectedItem(settings.gui.snapping_grid,1,1)
	guiGridListSetSelectedItem(settings.gui.snapping_grid,0,0)
end



function saveSettingsFile()
	local file = xmlLoadFile("settings.xml")
	if not file then
		file = xmlCreateFile("settings.xml","settings")
		if file then
			outputDebugString("Created GUI Editor settings file successfully.")
		else
			outputDebugString("Could not create GUI Editor settings file.")
			return
		end
	end
	
	for name,setting in pairs(settings) do
		if setting and setting ~= settings.gui then
			local node = getChild(file,tostring(name),0)
			if node then
				xmlNodeSetValue(node,tostring(setting.value))
			else
				outputDebugString("Failed to save GUI Editor '"..tostring(name).."' setting.")
			end
		end
	end

	
	xmlSaveFile(file)
	xmlUnloadFile(file)
	
	return
end

function getChild(file,type,index)
	local child = xmlFindChild(file,type,index)
	if not child then child = xmlCreateChild(file,type) end
	return child
end


function loadSettingsFile()
	local file = xmlLoadFile("settings.xml")
	if not file then
		outputDebugString("Couldnt find GUI Editor settings file. Creating...")
		saveSettingsFile(false)
		return
	end
	
	for i,node in ipairs(xmlNodeGetChildren(file)) do
		local value = xmlNodeGetValue(node)
		if value then
			local name = xmlNodeGetName(node)
			-- silly side effect of having shitty settings to begin with
			-- redirect deprecated names onto their new counterparts
			name = checkOutdatedNodes(node)
			local formatted = formatValue(value,name)
			if formatted ~= nil then
				settings[name].value = formatted
			--	outputDebugString("Loaded GUI Editor '"..name.."' setting. ("..tostring(formatted)..")")
			else
				outputDebugString("Failed to load GUI Editor '"..name.."' setting. Using default...")
			end
		end
	end

	
	xmlSaveFile(file)
	xmlUnloadFile(file)
	return	
end


function formatValue(value,name)	
	if name and settings[name] then
		if settings[name].type == "string" then
			return tostring(value)
		elseif settings[name].type == "number" then
			return tonumber(value)
		elseif settings[name].type == "boolean" then
			return loadstring("return "..tostring(value))()
		end
	end
	return nil
end


function checkOutdatedNodes(node)
	local name = xmlNodeGetName(node)
	
	if name == "tutorial" then
		xmlDestroyNode(node)
		outputDebugString("Destroyed deprecated GUI Editor settings node '"..name.."'.")
		return "guieditor_tutorial_completed"
	elseif name == "tutorialversion" then
		xmlDestroyNode(node)
		outputDebugString("Destroyed deprecated GUI Editor settings node '"..name.."'.")
		return "guieditor_tutorial_version"	
	elseif name == "updatecheck" then
		xmlDestroyNode(node)
		outputDebugString("Destroyed deprecated GUI Editor settings node '"..name.."'.")
		return "guieditor_update_check"
	end
	return name
end

