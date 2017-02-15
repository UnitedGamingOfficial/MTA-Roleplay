--[[ GUI Editor - Code Output - Client ]]--

local editorwindow,editortabpanel,editortab,editorbutton,editormemo,editorcheckbox,editorlabel,editoredit,editorprogress,editorradio,editorgrid,editorimage = false,false,false,false,false,false,false,false,false,false,false,false
guieditor_version = nil

addEventHandler("onClientResourceStart",resourceRoot,function()

	output_window = guiCreateWindow(0,258,500,373,"Output",false)
	output_button_refresh = guiCreateButton(67,314,156,23,"Refresh",false,output_window)
	output_button_output = guiCreateButton(282,314,156,23,"Output to file",false,output_window)
	output_button_close = guiCreateButton(67,342,156,23,"Close",false,output_window)
	output_memo = guiCreateMemo(12,22,475,284,"",false,output_window)
	output_checkbox = guiCreateCheckBox(282,347,156,18,"generate basic lua code",false,false,output_window)
	setElementData(output_checkbox,"cant_highlight",true)
	
	guiSetVisible(output_window,false)

	addEventHandler("onClientGUIClick",output_button_close,function(button,state)
		if button == "left" and state == "up" then
			HidePrintGUI()
		end
	end,false)
	
	addEventHandler("onClientGUIClick",output_button_output,function(button,state)
		if button == "left" and state == "up" then
			PrintAllGUI("guioutput")
		end
	end,false)
	
	addEventHandler("onClientGUIClick",output_button_refresh,function(button,state)
		if button == "left" and state == "up" then
			PrintAllGUI("guiprint")
		end
	end,false)	
	
	triggerServerEvent("getEditorVersion",getLocalPlayer())
end)


addEvent("receiveEditorVersion",true)
addEventHandler("receiveEditorVersion",root,function(version)
	guiSetText(output_window,"GUI Editor Version "..tostring(version).." - Output")
	guieditor_version = tostring(version)
end)


local guiGetText_ = guiGetText

local function guiGetText(element)
	local t = guiGetText_(element)
	
	if t == '\\' then return '\\\\'
	elseif t:find('"') then return t:gsub('"','\\"') end
	
	return t
end


-- as of 1.0, we need to wrap this and do some hacky server-client tricks to actually get a gui element list
-- no longer needed as of 1.0.1
------------------------------------------------------------------------------------------------------------
--[[
function PrintAllGUI(command)
	triggerServerEvent("GetResourcesForOutput",getLocalPlayer(),command)
end

local glob_gui_elements = {}

addEvent("RecieveResourcesForOutput",true)
addEventHandler("RecieveResourcesForOutput",getRootElement(),function(resources,arg1,arg2)	
	-- both arguments exist, calling from GetGUIElementsWithinBox2
	if arg1 and arg2 then
		glob_gui_elements = {}
		for _,res in ipairs(resources) do
			local function search(element)
				-- dont want to add guiroot
				if getElementType(element)~="guiroot" then
					table.insert(glob_gui_elements,element)
				end
			
				for _,v in ipairs(getElementChildren(element)) do
					if string.find(getElementType(v),'gui-...') then
						search(v)
					end
				end
			end	
	
			search(getResourceGUIElement(getResourceFromName(res)))
		end
		
		GetGUIElementsWithinBox2(glob_gui_elements,arg1,arg2)
	else
		-- loop all resource names, then loop all children of the resources gui root
		local gui_elements = {}
		for _,res in pairs(resources) do
			for _,gui_element in ipairs(getElementChildren(getResourceGUIElement(getResourceFromName(res)))) do
				table.insert(gui_elements,gui_element)
			--	outputChatBox("Found: "..getElementType(gui_element).."("..res..")")			
			end
		end
	
		PrintAllGUI2(arg1,gui_elements)
	end
end)
]]
------------------------------------------------------------------------------------------------------------]]


function PrintAllGUI(command)
	if not gui_editor then
		outputChatBox("Type /guieditor to begin using the GUI Editor")
		return
	end
	
	if guieditor_tutorial then
		if not guieditor_tutorial_waiting["output_code"] then
			outputChatBox("Continue with the tutorial to access this command.")
		end
	end
	
	guiSetText(output_memo,"")
	local code = ""
	local dx_code = ""
	local luaFile = guiCheckBoxGetSelected(output_checkbox)
	
	editorwindow,editortabpanel,editortab,editorbutton,editormemo,editorcheckbox,editorlabel,editoredit,editorprogress,editorradio,editorgrid,editorimage,editorscrollpane,editorscrollbar = false,false,false,false,false,false,false,false,false,false,false,false,false,false
	
	-- put all existing child gui elements of guiroot into gui_elements
	local gui_elements = {}
	for _,v in ipairs(gui_element_names) do
		for _,gui_element in ipairs(getElementsByType(v)) do
			if getElementType(getElementParent(gui_element))=="guiroot" then
				if getElementType(gui_element) ~= "gui-scrollbar" and getElementType(gui_element) ~= "gui-scrollpane" then
					table.insert(gui_elements,gui_element)
				end
			end
		end
	end
	
	
	
	local variable_table_index = {["gui-window"] = 0,["gui-button"] = 0,["gui-memo"] = 0,["gui-label"] = 0,["gui-checkbox"] = 0,["gui-edit"] = 0,["gui-gridlist"] = 0,["gui-progressbar"] = 0,["gui-tabpanel"] = 0,["gui-tab"] = 0,["gui-radiobutton"] = 0,["gui-staticimage"] = 0,["gui-scrollpane"] = 0,["gui-scrollbar"] = 0}

	-- loop every child gui element of gui-root
	for i,parent_element in ipairs(gui_elements) do	
		-- if it was made with the editor (isnt part of the editor's own gui, etc)
		if getElementData(parent_element,"guieditor_varname",false) then
			-- loop all its child elements
			local function search(element)
				-- if its not dx
				if (not getElementData(element,"modify_menu",false)) or (getElementData(element,"modify_menu",false) < dx_options or getElementData(element,"modify_menu",false) > dx_options + 3) then
			--	if not getElementData(element,"modify_menu") then
			
					--outputChatBox("Generating "..getElementType(element).." ["..i.."]")
								
					local ghost, ghosted

					if getElementType(element) == "gui-scrollpane" or getElementType(element) == "gui-scrollbar" then
						for i,v in ipairs(getElementsByType("gui-label")) do
							if getElementData(v,"guieditor_ghost",false) and getElementData(v,"guieditor_ghost",false) == element then
								ghosted = true
							end
						end
					end					
					
					if getElementData(element,"guieditor_ghost",false) then
						ghost = element
						element = getElementData(element,"guieditor_ghost",false)	
						
					--	if element then
					--		outputChatBox("Changed to: "..getElementType(element))
					--	end
					end
					
					if element and isElement(element) and (not ghosted) then
						-- we want to properly index output elements with the default table-variable, after loading big guis (eg: admin) and then deleting them (or just a lot of creation/deletion in general) the first index in the output code can balloon to 60+
						-- so, we keep count of each variable type and properly order them
						if UsingDefaultVariable(element) then
							local type = getElementType(element)
							variable_table_index[type] = variable_table_index[type] + 1
							local varname = ""
							
							if type == "gui-window" then varname = "GUIEditor_Window["..variable_table_index[type].."]"
							elseif type == "gui-button" then varname = "GUIEditor_Button["..variable_table_index[type].."]" 
							elseif type == "gui-memo" then varname = "GUIEditor_Memo["..variable_table_index[type].."]" 
							elseif type == "gui-label" then varname = "GUIEditor_Label["..variable_table_index[type].."]" 
							elseif type == "gui-checkbox" then varname = "GUIEditor_Checkbox["..variable_table_index[type].."]" 
							elseif type == "gui-edit" then varname = "GUIEditor_Edit["..variable_table_index[type].."]" 
							elseif type == "gui-gridlist" then varname = "GUIEditor_Grid["..variable_table_index[type].."]" 
							elseif type == "gui-progressbar" then varname = "GUIEditor_Progress["..variable_table_index[type].."]" 
							elseif type == "gui-tabpanel" then varname = "GUIEditor_TabPanel["..variable_table_index[type].."]" 
							elseif type == "gui-tab" then varname = "GUIEditor_Tab["..variable_table_index[type].."]" 
							elseif type == "gui-radiobutton" then varname = "GUIEditor_Radio["..variable_table_index[type].."]" 
							elseif type == "gui-staticimage" then varname = "GUIEditor_Image["..variable_table_index[type].."]"
							elseif type == "gui-scrollpane" then varname = "GUIEditor_Scrollpane["..variable_table_index[type].."]" 
							elseif type == "gui-scrollbar" then varname = "GUIEditor_Scrollbar["..variable_table_index[type].."]" 
							end
							
							setElementData(element,"guieditor_varname",varname)
						end
						
						-- generate code for the element
						local element_code = GenerateCodeForElement(element,getElementType(element),luaFile)
						if element_code then
							if luaFile then
								element_code = "        " .. element_code
							end					

							code = code .. "\n" .. element_code
						else
							outputDebugString("GUIEditor Error: code generation failed on element ["..getElementType(element).."]")
						end
					end
					
					if ghost then
						element = ghost
					end
				
					if (not ghosted) then
						for _,v in ipairs(getElementChildren(element)) do
							if getElementData(v,"guieditor_varname",false) --[[and getElementType(v) ~= "gui-scrollbar" and getElementType(v) ~= "gui-scrollpane"]]  then
								search(v)
							end
						end
					end
				elseif getElementData(element,"modify_menu",false) >= dx_options and getElementData(element,"modify_menu",false) <= dx_options + 3 then
					-- generate the render handle
					if dx_code == "" then
						dx_code = "-- Direct X Drawing\naddEventHandler(\"onClientRender\",root,\n    function()"
					end
					
					local element_code = GenerateCodeForDX(element)
					if element_code and #element_code>0 then
						dx_attributes[element].code = element_code
					--	outputDebugString("GUIEditor: successful DX code generation on ["..getElementType(element).."]")
					else
						dx_attributes[element].code = ""
						outputDebugString("GUIEditor Error: DX code generation failed on ["..getElementType(element).."]")
					end
				
					for _,v in ipairs(getElementChildren(element)) do
						if getElementData(v,"guieditor_varname",false) then
							search(v)
						end
					end		
				end
			end

			if parent_element then
				search(parent_element)
			end
			
			if (not getElementData(parent_element,"modify_menu",false)) or (getElementData(parent_element,"modify_menu",false) < dx_options or getElementData(parent_element,"modify_menu",false) > dx_options + 3) then
				code = code .. "\n"
			end
		end		
	end
	
	for i=#dx_ordering, 1, -1 do
		if dx_ordering[i] and dx_attributes[dx_ordering[i]] then
			dx_code = dx_code .. "\n" .. tostring(dx_attributes[dx_ordering[i]].code)
			dx_attributes[dx_ordering[i]].code = nil
		end
	end			
	
	if dx_code ~= "" then
		dx_code = dx_code .. "\n    end\n)\n"
	end
	
			
	local tables = ""
	if editorwindow == true then tables = tables .. (luaFile == true and "        " or "") .. "GUIEditor_Window = {}\n" end
	if editortabpanel == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_TabPanel = {}\n" end
	if editortab == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Tab = {}\n" end
	if editorbutton == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Button = {}\n" end
	if editormemo == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Memo = {}\n" end
	if editorcheckbox == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Checkbox = {}\n" end
	if editorlabel == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Label = {}\n" end
	if editoredit == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Edit = {}\n" end
	if editorprogress == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Progress = {}\n" end
	if editorradio == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Radio = {}\n" end
	if editorgrid == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Grid = {}\n" end
	if editorimage == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Image = {}\n" end
	if editorscrollpane == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Scrollpane = {}\n" end
	if editorscrollbar == true then tables = tables.. (luaFile == true and "        " or "") .. "GUIEditor_Scrollbar = {}\n" end

	code = tables .. code
	
	if luaFile then
		code = "addEventHandler(\"onClientResourceStart\",resourceRoot,\n    function()\n" .. code .. "    end\n)"
	end
	
	code = code .. (code == "\n" and "" or "\n\n\n") .. dx_code

	if command=="guiprint" then
		guiSetText(output_memo,code)
		guiSetVisible(output_window,true)
	elseif command=="guioutput" then
		local valuescreen, valuechildren
		if settings.screen_output_type.value==true then valuescreen="relative" else valuescreen="absolute" end
		if settings.child_output_type.value==true then valuechildren="relative" else valuechildren="absolute" end
		
		if guieditor_tutorial and guieditor_tutorial_waiting["output_code"] then
			progressTutorial("output_code")
		end
		
		triggerServerEvent("OutputGUIToFile",local_player,code,"with "..valuescreen.." screen and "..valuechildren.." children.")
	elseif command == "sharing" then
		triggerServerEvent("sendSharedCode",local_player,code)
	end
end
addCommandHandler("guiprint",PrintAllGUI)
addCommandHandler("guioutput",PrintAllGUI)


function HidePrintGUI()
	guiSetVisible(output_window,false)
	
	guiSetEnabled(output_button_output,true)
	guiSetEnabled(output_button_refresh,true)
end
addCommandHandler("guihide",HidePrintGUI)


function GenerateCodeForElement(element,type,luaFile)
	local code = ""
	-- check both variables exist and check element has not been deleted
	if element and type and isElement(element) then
		if type == "gui-window" then
			local w,h = guiGetSize(element,settings.screen_output_type.value)
			local x,y = guiGetPosition(element,settings.screen_output_type.value)
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))		
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end
			local t = t_:gsub("\n","\\n") 
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateWindow("..x..","..y..","..w..","..h..",\""..t.."\","..tostring(settings.screen_output_type.value)..")" --guiCreateWindow(float x,float y,float width,float height,string titleBarText,bool relative )
			if getElementData(element,"guieditor_alpha",false)==true then code = code .."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if getElementData(element,"guieditor_movable",false)==false then code = code .."\n"..(luaFile and "        " or "").."guiWindowSetMovable("..varname..",false)" end
			if getElementData(element,"guieditor_sizable",false)==false then code = code .."\n"..(luaFile and "        " or "").."guiWindowSetSizable("..varname..",false)" end
			-- loop all saved property changes for the element
			code = code .. formatProperties(element, varname)

			-- if it is still using its original variable name, indicate that code for the variable table needs to be created
			if UsingDefaultVariable(element) then
				editorwindow = true
			end
			
			return code
		end

		if type == "gui-tabpanel" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)		 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				-- force absolute values if loose manipulation has been used to breach the parent border, relative values will fail with values <0 or >1
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)
				end
			end
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateTabPanel("..x..","..y..","..w..","..h..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code .."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editortabpanel = true
			end
			
			return code
		end
	
		if type == "gui-tab" then
			-- dont remember why tabs specifically stored their parents variable, though it seems to work fine now without (perhaps due to the reorganisation)
			-- keep an eye on this
		--	local parent = getElementData(element,"guieditor_parent")
			local parent = getElementData(getElementParent(element),"guieditor_varname",false)
			local t = guiGetText(element) if t==nil or t==false then t = "" end
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateTab(\""..t.."\","..parent..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			
			code = code .. formatProperties(element, varname)
			
			if UsingDefaultVariable(element) then
				editortab = true
			end
			
			return code
		end	
	
		if type == "gui-button" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type) 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end
			local t = t_:gsub("\n","\\n") 
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateButton("..x..","..y..","..w..","..h..",\""..t.."\""..parent_name..")" --guiCreateButton(float x,float y,float width,float height, string text, bool relative, [ element parent = nil ])
			if getElementData(element,"guieditor_alpha",false)==true then code = code .."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if guiGetFont(element)~="default-normal" then code = code.."\n"..(luaFile and "        " or "").."guiSetFont("..varname..",\""..guiGetFont(element).."\")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorbutton = true
			end
			
			return code
		end
	
		if type == "gui-memo" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)			 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end
			t_ = string.sub(t_,1,-2)
			local t = t_:gsub("\n","\\n") 
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateMemo("..x..","..y..","..w..","..h..",\""..t.."\""..parent_name..")" --guiCreateMemo ( float x, float y, float width, float height, string text, bool relative, [element parent = nil] )
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if getElementData(element,"guieditor_readonly",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiMemoSetReadOnly("..varname..",true)" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editormemo = true
			end
			
			return code
		end

		if type == "gui-checkbox" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)			 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))	
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end			
			local t = t_:gsub("\n","\\n") 
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateCheckBox("..x..","..y..","..w..","..h..",\""..t.."\",false"..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if guiCheckBoxGetSelected(element)==true then code = code.."\n"..(luaFile and "        " or "").."guiCheckBoxSetSelected("..varname..",true)" end
			if guiGetFont(element)~="default-normal" then code = code.."\n"..(luaFile and "        " or "").."guiSetFont("..varname..",\""..guiGetFont(element).."\")" end
			
			code = code .. formatProperties(element, varname)
			
			if UsingDefaultVariable(element) then
				editorcheckbox = true
			end
			
			return code
		end
	
		if type == "gui-label" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)		 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end
			local t = t_:gsub("\n","\\n") 
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateLabel("..x..","..y..","..w..","..h..",\""..t.."\""..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			if getElementData(element,"guieditor_colour",false) then 
				if getElementData(element,"guieditor_colour",false) ~= "255,255,255" then
					code = code.."\n"..(luaFile and "        " or "").."guiLabelSetColor("..varname..","..getElementData(element,"guieditor_colour",false)..")"
				end
			end
			
			if getElementData(element,"guieditor_vertalign",false) and getElementData(element,"guieditor_vertalign",false) ~= "top" then 
				code = code.."\n"..(luaFile and "        " or "").."guiLabelSetVerticalAlign("..varname..",\""..getElementData(element,"guieditor_vertalign",false).."\")" 
			end
			
			local wordwrap = "false"
			if getElementData(element,"guieditor_wordwrap",false)==true then wordwrap = "true" end
			
			if (getElementData(element,"guieditor_horizalign",false) and getElementData(element,"guieditor_horizalign",false) ~= "left") or wordwrap == "true" then 
				code = code.."\n"..(luaFile and "        " or "").."guiLabelSetHorizontalAlign("..varname..",\""..getElementData(element,"guieditor_horizalign",false).."\","..wordwrap..")"
			end
			
			if guiGetFont(element) ~= "default-normal" then code = code.."\n"..(luaFile and "        " or "").."guiSetFont("..varname..",\""..guiGetFont(element).."\")" end
			
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorlabel = true
			end
			
			return code
		end
	
		if type == "gui-edit" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)			 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local t = guiGetText(element) if t==nil or t==false then t = "" end
		--	t = t:gsub("\\","\\\\")
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateEdit("..x..","..y..","..w..","..h..",\""..t.."\""..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if getElementData(element,"guieditor_masked",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiEditSetMasked("..varname..",true)" end
			if getElementData(element,"guieditor_readonly",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiEditSetReadOnly("..varname..",true)" end
			if getElementData(element,"guieditor_maxlength",false)~=nil then code = code.."\n"..(luaFile and "        " or "").."guiEditSetMaxLength("..varname..","..getElementData(element,"guieditor_maxlength",false)..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editoredit = true
			end
			
			return code
		end	
	
		if type == "gui-progressbar" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)			 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateProgressBar("..x..","..y..","..w..","..h..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if guiProgressBarGetProgress(element)>0 then code = code.."\n"..(luaFile and "        " or "").."guiProgressBarSetProgress("..varname..","..guiProgressBarGetProgress(element)..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorprogress = true
			end
			
			return code
		end

		if type == "gui-radiobutton" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)			 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))		
			local t_ = guiGetText(element) if t_==nil or t_==false then t_ = "" end			
			local t = t_:gsub("\n","\\n") 		
		--	t = t:gsub("\\","\\\\")	
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateRadioButton("..x..","..y..","..w..","..h..",\""..t.."\""..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if guiRadioButtonGetSelected(element)==true then code = code.."\n"..(luaFile and "        " or "").."guiRadioButtonSetSelected("..varname..",true)" end
			if guiGetFont(element)~="default-normal" then code = code.."\n"..(luaFile and "        " or "").."guiSetFont("..varname..",\""..guiGetFont(element).."\")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorradio = true
			end
			
			return code
		end	

		if type == "gui-gridlist" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)		 
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end					
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateGridList("..x..","..y..","..w..","..h..parent_name..")" --
			code = code.."\n"..(luaFile and "        " or "").."guiGridListSetSelectionMode("..varname..",2)"
			
			local col_c = getElementData(element,"guieditor_colcount",false)
			if col_c>0 then
			--	code = code.."\nfor i = 1, "..col_c.." do\n    guiGridListAddColumn("..varname..",".. ..",0.2)\nend"
				for i=1, col_c do
					code = code.."\n\n"..(luaFile and "        " or "").."guiGridListAddColumn("..varname..",\""..getElementData(element,"guieditor_coltitle_"..i,false).."\",0.2)"
				end
			end			
			
			local row_c = guiGridListGetRowCount(element)
			if row_c~=false and row_c>0 then
				code = code .."\n\n"..(luaFile and "        " or "").."for i = 1, "..row_c.." do\n"..(luaFile and "        " or "").."    guiGridListAddRow("..varname..")\nend"
			end
			
			for column = 1, col_c do
				for row = 0, row_c-1 do
					if guiGridListGetItemText(element,row,column) ~= "-" then
						code = code .. "\n\n"..(luaFile and "        " or "").."guiGridListSetItemText("..varname..","..tostring(row)..","..tostring(column)..",\""..tostring(guiGridListGetItemText(element,row,column)).."\")"
					end
					
					local r,g,b,a = guiGridListGetItemColor(element,row,column)
					if r and (r ~= 255 or g ~= 255 or b ~= 255 or a ~= 255) then
						code = code .. "\n\n"..(luaFile and "        " or "").."guiGridListSetItemColor("..varname..","..tostring(row)..","..tostring(column)..","..tostring(r)..","..tostring(g)..","..tostring(b)..","..tostring(a)..")"
					end
				end
			end
			
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorgrid = true
			end
			
			return code
		end
	
		if type == "gui-staticimage" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)
			
			local w,h = guiGetSize(element,values_type)
			local x,y = guiGetPosition(element,values_type)
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					w,h = guiGetSize(element,values_type)
					x,y = guiGetPosition(element,values_type)					
				end
			end			
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			
			local t = guiGetText(element) if t==nil or t==false then t = "" end
			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateStaticImage("..x..","..y..","..w..","..h..",\""..getElementData(element,"guieditor_dir",false).."\""..parent_name..")" --
			if getElementData(element,"guieditor_alpha",false)==true then code = code.."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorimage = true
			end
			
			return code
		end
		
		if type == "gui-scrollpane" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)		 
			
			local x,y,w,h
			
			if getElementData(element, "guieditor_ghost_host", false) then
				w,h = guiGetSize(getElementData(element, "guieditor_ghost_host", false),values_type)
				x,y = guiGetPosition(getElementData(element, "guieditor_ghost_host", false),values_type)
			else
				w,h = guiGetSize(element,values_type)
				x,y = guiGetPosition(element,values_type)
			end
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					if getElementData(element, "guieditor_ghost_host", false) then
						w,h = guiGetSize(getElementData(element, "guieditor_ghost_host", false),values_type)
						x,y = guiGetPosition(getElementData(element, "guieditor_ghost_host", false),values_type)
					else
						w,h = guiGetSize(element,values_type)
						x,y = guiGetPosition(element,values_type)
					end
				end
			end
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))			

			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateScrollPane("..x..","..y..","..w..","..h..parent_name..")" --guiCreateScrollPane( float x, float y, float width, float height, bool relative, [gui-element parent = nil])
			if getElementData(element,"guieditor_alpha",false)==true then code = code .."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorscrollpane = true
			end
			
			return code
		end
		
		if type == "gui-scrollbar" then
			local parent_name = ",false"
			local parent = DoesElementHaveGUIParent(element)
			local values_type = false
		
			parent, parent_name, values_type = formatParentAndOutputTypeData(element, parent, parent_name, values_type)		 
			
			local x,y,w,h
			
			if getElementData(element, "guieditor_ghost_host", false) then
				w,h = guiGetSize(getElementData(element, "guieditor_ghost_host", false),values_type)
				x,y = guiGetPosition(getElementData(element, "guieditor_ghost_host", false),values_type)
			else
				w,h = guiGetSize(element,values_type)
				x,y = guiGetPosition(element,values_type)
			end
			
			if values_type == true then
				if x > 1 or x < 0 or y > 1 or y < 0 or w > 1 or w < 0 or h > 1 or h < 0 then
					values_type = false
					parent_name = parent_name:gsub(",true",",false")
					
					if getElementData(element, "guieditor_ghost_host", false) then
						w,h = guiGetSize(getElementData(element, "guieditor_ghost_host", false),values_type)
						x,y = guiGetPosition(getElementData(element, "guieditor_ghost_host", false),values_type)
					else
						w,h = guiGetSize(element,values_type)
						x,y = guiGetPosition(element,values_type)
					end
				end
			end
			
			x = tonumber(string.format("%.4f",x)) y = tonumber(string.format("%.4f",y))
			w = tonumber(string.format("%.4f",w)) h = tonumber(string.format("%.4f",h))

			local varname = getElementData(element,"guieditor_varname",false)
			code = varname.." = guiCreateScrollBar("..x..","..y..","..w..","..h..","..tostring(getElementData(element,"guieditor_horizontal",false))..parent_name..")" --guiCreateScrollPane( float x, float y, float width, float height, bool relative, [gui-element parent = nil])
			if getElementData(element,"guieditor_alpha",false)==true then code = code .."\n"..(luaFile and "        " or "").."guiSetAlpha("..varname..","..guiGetAlpha(element)..")" end
			if guiScrollBarGetScrollPosition(element) ~= 0 then code = code .. "\n"..(luaFile and "        " or "").."guiScrollBarSetScrollPosition("..varname..","..tostring(guiScrollBarGetScrollPosition(element))..")" end
			
			code = code .. formatProperties(element, varname)

			if UsingDefaultVariable(element) then
				editorscrollbar = true
			end
			
			return code
		end		
	end	
	return ""
end



function UsingDefaultVariable(element)
	if element then
		local type = getElementType(element)
		local varname = getElementData(element,"guieditor_varname",false)
		
		if type=="gui-window" then 
			if varname:find("GUIEditor_Window[",1,true) then return true end
		elseif type=="gui-button" then
			if varname:find("GUIEditor_Button[",1,true) then return true end
		elseif type=="gui-memo" then 
			if varname:find("GUIEditor_Memo[",1,true) then return true end
		elseif type=="gui-label" then 
			if varname:find("GUIEditor_Label[",1,true) then return true end
		elseif type=="gui-checkbox" then 
			if varname:find("GUIEditor_Checkbox[",1,true) then return true end
		elseif type=="gui-edit" then 
			if varname:find("GUIEditor_Edit[",1,true) then return true end
		elseif type=="gui-gridlist" then 
			if varname:find("GUIEditor_Grid[",1,true) then return true end
		elseif type=="gui-progressbar" then 
			if varname:find("GUIEditor_Progress[",1,true) then return true end
		elseif type=="gui-tabpanel" then 
			if varname:find("GUIEditor_TabPanel[",1,true) then return true end
		elseif type=="gui-tab" then 
			if varname:find("GUIEditor_Tab[",1,true) then return true end
		elseif type=="gui-radiobutton" then
			if varname:find("GUIEditor_Radio[",1,true) then return true end
		elseif type=="gui-staticimage" then 
			if varname:find("GUIEditor_Image[",1,true) then return true end
		elseif type=="gui-scrollpane" then
			if varname:find("GUIEditor_Scrollpane[",1,true) then return true end
		elseif type=="gui-scrollbar" then
			if varname:find("GUIEditor_Scrollbar[",1,true) then return true end
		else return false
		end
	end
	
	return false
end



function GenerateCodeForDX(element)
	if element and isElement(element) then
		local code = ""
		
		if getElementType(element) == "gui-label" then
			if dx_attributes[element].type == "text" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(element)
				if x then	
					local r,g,b,a = HexToRGBA(string.format("%X",dx_attributes[element].colour))
					code = string.format("        dxDrawText(\"%s\",%.1f,%.1f,%.1f,%.1f,tocolor(%d,%d,%d,%d),%.1f,\"%s\",\"%s\",\"%s\",%s,%s,%s)",tostring(dx_attributes[element].text),x,y,x+w,y+h,r,g,b,a,dx_attributes[element].scale,dx_attributes[element].font,dx_attributes[element].halign,dx_attributes[element].valign,tostring(dx_attributes[element].clip),tostring(dx_attributes[element].wordwrap),tostring(dx_attributes[element].postgui))
				end
			elseif dx_attributes[element].type == "line" then
				local r,g,b,a = HexToRGBA(string.format("%X",dx_attributes[element].colour))
				code = string.format("        dxDrawLine(%.1f,%.1f,%.1f,%.1f,tocolor(%d,%d,%d,%d),%.1f,%s)",dx_attributes[element].sx,dx_attributes[element].sy,dx_attributes[element].ex,dx_attributes[element].ey,r,g,b,a,dx_attributes[element].width,tostring(dx_attributes[element].postgui))
			elseif dx_attributes[element].type == "rectangle" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(element)
				if x then	
					local r,g,b,a = HexToRGBA(string.format("%X",dx_attributes[element].colour))
					code = string.format("        dxDrawRectangle(%.1f,%.1f,%.1f,%.1f,tocolor(%d,%d,%d,%d),%s)",x,y,w,h,r,g,b,a,tostring(dx_attributes[element].postgui))
				end			
			elseif dx_attributes[element].type == "image" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(element)
				if x then	
					local r,g,b,a = HexToRGBA(string.format("%X",dx_attributes[element].colour))
					code = string.format("        dxDrawImage(%.1f,%.1f,%.1f,%.1f,\"%s\",%.1f,%.1f,%.1f,tocolor(%d,%d,%d,%d),%s)",x,y,w,h,dx_attributes[element].image,dx_attributes[element].rotation,dx_attributes[element].rxoffset,dx_attributes[element].ryoffset,r,g,b,a,tostring(dx_attributes[element].postgui))
				end					
			end
		else
			outputDebugString("GUIEditor Error: attempt to generate DX code on ["..getElementType(element).."]")
		end
		
		return code
	end
	return ""
end



function formatParentAndOutputTypeData(element, parent, parent_name, values_type)
	local eParent = getElementParent(element)
	
	if eParent and isElement(eParent) then
		if getElementData(eParent, "guieditor_ghost", false) then
			eParent = getElementData(eParent, "guieditor_ghost", false)
		end
	end	
	
	if parent==true and settings.child_output_type.value==true then parent_name = ",true,"..getElementData(eParent,"guieditor_varname",false) values_type = true
	elseif parent==true and settings.child_output_type.value==false then parent_name = ",false,"..getElementData(eParent,"guieditor_varname",false) values_type = false
	elseif parent==false and settings.screen_output_type.value==true then parent_name = ",true" values_type = true
	elseif parent==false and settings.screen_output_type.value==false then parent_name = ",false" values_type = false end

	return parent, parent_name, values_type
end


function formatProperties(element, varname)
	local code = ""
	
	if getElementData(element,"guieditor_properties",false) then
		for prop,val in pairs(getElementData(element,"guieditor_properties",false)) do
			code = code .. "\nguiSetProperty("..varname..",\""..prop.."\",\""..val.."\")"
		end
	end
	
	return code
end