--[[ GUI Editor - Right Click Options - Client ]]--


-- used to find the appropriate action when a right click menu option has been clicked
function PerformRightClickOption(id,menu_source,menu_type)
	guiSetVisible(right_click_menu,false)
	guiSetVisible(right_click_sub_menu,false)
	guiSetVisible(right_click_parent_menu,false)

	local type, dxdraw = nil,nil
	if isElement(menu_source) then 
		type = getElementType(menu_source)
		
		if getElementData(menu_source,"modify_menu") and getElementData(menu_source,"modify_menu") >= dx_options and getElementData(menu_source,"modify_menu") <= dx_options + 3 then
			dxdraw = true
		end
	end

	local text = ""
	if menu_type=="menu" then
		text = guiGetText(right_click_labels[id])
	elseif menu_type=="sub" then
		text = guiGetText(right_click_sub_menu_labels[id])
	elseif menu_type=="sub_parent" then
		text = guiGetText(right_click_parent_menu_labels[id])
		current_menu = menu_source
		if getElementType(current_menu) == "guiroot" then
			current_menu = "Screen" 
		end
	end
	
	-- figure out which gui element was right clicked so we can load the appropriate options into the menu
	local id = 1
	if isElement(menu_source) then
		id = GetIDFromType(getElementType(menu_source))
	end
	
	if captured == true then
		id = "captured"
	end	
	
	if guieditor_tutorial then
		if not guieditor_tutorial_allowed[text] or 
		(guieditor_tutorial_allowed[text] and guieditor_tutorial_allowed[text] ~= true and guieditor_tutorial_allowed[text] ~= menu_type) or
		(guieditor_tutorial_allowed["AllowedMenu"] and guieditor_tutorial_allowed["AllowedMenu"] ~= id)then
			outputChatBox("Continue with the tutorial to use this option. ("..tostring(text)..")")
			return 
		end
	end
	
	text = string.lower(text)
	
	if dxdraw then
		if text:find("set scale") then
			ShowInputBox(menu_source,"dx_scale","Enter the new scale (0-100)") return
		elseif text:find("clip") then
			ShowInputBox(menu_source,"dx_clip","Clip: Enter true or false") return
		elseif text:find("post gui") then
			ShowInputBox(menu_source,"dx_postgui","Post GUI: Enter true or false") return
		elseif text:find("set width") then
			ShowInputBox(menu_source,"dx_linewidth","Enter the line width (1-1000)") return
		elseif text:find("set rotation") then
			ShowInputBox(menu_source,"dx_rotation","Enter the rotation (0-360)") return
		elseif text:find("set rot x offset") then
			ShowInputBox(menu_source,"dx_rotx_offset","Enter the X offset in pixels") return
		elseif text:find("set rot y offset") then
			ShowInputBox(menu_source,"dx_roty_offset","Enter the Y offset in pixels") return
		end	
	end

	-- all the possible options across all possible menus (messy)
	if text:find("create window")~=nil then
		creating = "window"
		SetInstruction("Click and hold your mouse to create the window,\nmove the cursor to adjust the size")
	elseif text:find("create button")~=nil and text:find("radio")==nil then
		creating = "button"
		SetInstruction("Click and hold your mouse to create the button,\nmove the cursor to adjust the size")
	elseif text:find("set title")~=nil then
		ShowInputBox(menu_source,"text","Enter the new title") -- set title/text
	elseif text:find("move to back")~=nil then
		local ghost = getElementData(menu_source,"guieditor_ghost")
		if ghost and isElement(ghost) then
			guiMoveToBack(ghost)
		end	
	
		guiMoveToBack(menu_source)	
		
		if dxdraw then moveDXToBack(menu_source) end
	elseif text:find("move x") then
		creating = "pre_move_x"
		move = menu_source
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the position of the ".. (dxdraw == true and "direct X" or "gui"))	
	elseif text:find("move y") then
		creating = "pre_move_y"
		move = menu_source
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the position of the ".. (dxdraw == true and "direct X" or "gui"))	
	elseif text:find("move")~=nil and text:find("remove")==nil then
		creating = "pre_move"
		move = menu_source
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the position of the ".. (dxdraw == true and "direct X" or "gui"))
	elseif text:find("resize width")~=nil then	
		creating = "pre_resize_width"
		move = menu_source	
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the width of the ".. (dxdraw == true and "direct X" or "gui"))
	elseif text:find("resize height")~=nil then
		creating = "pre_resize_height"
		move = menu_source	
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the height of the ".. (dxdraw == true and "direct X" or "gui"))
	elseif text:find("resize")~=nil then
		creating = "pre_resize"
		move = menu_source
		if isElement(move) and getElementType(move)=="gui-tab" then move = getElementParent(move) end
		SetInstruction("Click, hold and move your mouse to adjust the size of the ".. (dxdraw == true and "direct X" or "gui"))
	elseif text:find("copy")~=nil then
	
		local children = false
		if text:find("children")==nil then
			children = false
		else
			children = true
		end
		
		if isElement(menu_source) and getElementType(menu_source)=="gui-tab" then menu_source = getElementParent(menu_source) type = getElementType(menu_source) end
		
		if captured==true then
			for _,v in ipairs(captured_elements) do
				CopyGUIElement(v,getElementParent(v),getElementType(v),children)		
			end
		else
			local p = CopyGUIElement(menu_source,getElementParent(menu_source),type,children)
			
			if children == false then
				-- tabpanels alone are not triggered by onClientMouseEnter, copying & creating just the tab panel leaves an immovable panel on the screen so add its tabs as well
				if getElementType(menu_source)=="gui-tabpanel" then
					for _,v in ipairs(getElementChildren(menu_source)) do
						CopyGUIElement(v,p,getElementType(v),false)
					end
				end
			end
		end
		outputChatBox("A copy was made ontop of the original.")
	elseif text:find("alpha")~=nil then
		ShowInputBox(menu_source,"alpha","Enter the alpha level (0-1)")
	elseif text:find("delete")~=nil and text:find("tab")==nil then
		ShowInputBox(menu_source,"delete_element","Delete")
	elseif text == "cancel" then
		creating = nil
		cancel = false
		captured = false
		HideDragBox()				
		SetInstruction("Right click to begin - /guihelp for feature details")
--[[elseif text:find("parent")~=nil then
		creating = "parent"
		parent = menu_source
		SetInstruction("Click on the gui element you want to set as the parent")
		]]
	elseif text:find("create checkbox")~=nil then
		creating = "checkbox"
		SetInstruction("Click and hold your mouse to create the checkbox,\nmove the cursor to adjust the size")
	elseif text:find("create memo")~=nil then
		creating = "memo"
		SetInstruction("Click and hold your mouse to create the memo,\nmove the cursor to adjust the size")
	elseif text:find("create label")~=nil then
		creating = "label"
		SetInstruction("Click and hold your mouse to create the label,\nmove the cursor the adjust the size")
--[[	elseif string.find(text,"selected")~=nil then
		if getElementType(menu_source)=="gui-checkbox" then
			ShowInputBox(menu_source,"selected_check","")
			SetInstruction("Enter true or false to set whether the checkbox is selected")
		else
			ShowInputBox(menu_source,"selected_radio","")
			SetInstruction("Enter true or false to set whether the radio button is selected")
		end]]
	elseif text:find("variable")~=nil then
		ShowInputBox(menu_source,"variable","Enter the new name of the variable")
		SetInstruction("Enter the name of the variable you want to assign to\nthis gui element")
	elseif text:find("create edit")~=nil then
		creating = "edit"
		SetInstruction("Click and hold your mouse to create the edit field,\nmove the cursor to adjust the size")
	elseif text:find("create grid")~=nil then
		creating = "grid"
		SetInstruction("Click and hold your mouse to create the gridlist,\nmove the cursor to adjust the size")
	elseif text == "item text" or text == "item colour" then
		local r,c = guiGridListGetSelectedItem(menu_source)
		
		if r and c and r ~= -1 and c ~= -1 then
			if text == "item text" then
				ShowInputBox(menu_source,"gridlist_item_text","Enter the new text for the gridlist item")
			elseif text == "item colour" then
				ShowInputBox(menu_source,"gridlist_item_colour","Enter the colour in the format: \"red,green,blue[,alpha]\" (0-255)")
			end
		else
			outputChatBox("Please select an item on the gridlist first.")
		end
	elseif text:find("create progress")~=nil then
		creating = "progress"
		SetInstruction("Click and hold your mouse to create the progress bar,\nmove the cursor to adjust the size")
	elseif text:find("create radio")~=nil then
		creating = "radio"
		SetInstruction("Click and hold your mouse to create the radio button,\nmove the cursor to adjust the size")		
	elseif text:find("create tab panel")~=nil and text:find("delete")==nil then
		creating = "tabpanel"
		SetInstruction("Click and hold your mouse to create the tab panel,\nmove the cursor to adjust the size")
	elseif text:find("add tab")~=nil then
		local panel = getElementType(menu_source) == "gui-tab" and getElementParent(menu_source) or menu_source
		GUIEditor_Tab[tab_count] = guiCreateTab("Tab",panel)
		setElementData(GUIEditor_Tab[tab_count],"guieditor_varname","GUIEditor_Tab["..tab_count.."]",false)
	--	setElementData(GUIEditor_Tab[tab_count],"guieditor_parent",getElementData(getElementParent(menu_source),"guieditor_varname"),false)
		tab_count = tab_count + 1
	elseif text:find("delete tab")~=nil and text:find("panel")==nil then
		ShowInputBox(menu_source,"delete_tab","Delete")
	elseif text:find("delete tab panel")~=nil then
		ShowInputBox(menu_source,"delete_tabpanel","Delete")
	elseif text:find("add column")~=nil then
		ShowInputBox(menu_source,"column_title","Enter the column title")
	elseif text:find("add row")~=nil then
		local row = guiGridListAddRow(menu_source)

		local col = getElementData(menu_source,"guieditor_colcount")
		if col and col>0 then
			for i = 1, col do
				guiGridListSetItemText(menu_source,row,i,"-",false,false)
			
			--[[
				local row = guiGridListGetRowCount(menu_source)
				if row~=false and row>0 then
					for j = 0, row do
						guiGridListSetItemText(menu_source,j,i,"-",false,false)
					end
				end
			]]
			end
		end
	elseif text:find("read only")~=nil then
		if type=="gui-memo" then
			ShowInputBox(menu_source,"memo_read_only","Read only: Enter true or false")
		elseif type=="gui-edit" then
			ShowInputBox(menu_source,"edit_read_only","Read only: Enter true or false")
		end
	elseif text:find("colour")~=nil then
		if dxdraw then
			ShowInputBox(menu_source,"label_colour","Enter the colour in the format: \"red,green,blue,alpha\" (0-255)")
		else
			ShowInputBox(menu_source,"label_colour","Enter the colour in the format: \"red,green,blue\" (0-255)")
		end
	elseif text:find("vertical align")~=nil then
		ShowInputBox(menu_source,"label_vertical_align","Enter \"top\",\"center\" or \"bottom\"")
	elseif text:find("horizontal align")~=nil then
		ShowInputBox(menu_source,"label_horizontal_align","Enter \"left\",\"center\" or \"right\"")
	elseif text:find("wordwrap")~=nil then
		ShowInputBox(menu_source,"label_wordwrap","Wordwrap: Enter true or false")
	elseif text:find("masked")~=nil then
		ShowInputBox(menu_source,"edit_masked","Masked: Enter true or false")
	elseif text:find("max length")~=nil then
		ShowInputBox(menu_source,"edit_maxlength","Enter the maximum number of characters")
	elseif text:find("set progress")~=nil then
		ShowInputBox(menu_source,"progress_set","Enter a number from 0 - 100")
	elseif text:find("movable")~=nil then
		ShowInputBox(menu_source,"window_movable","Movable: Enter true or false")
	elseif text:find("sizable")~=nil then
		ShowInputBox(menu_source,"window_sizable","Sizable: Enter true or false")
	elseif text:find("offset") and not text:find("rot") then
		ShowInputBox(menu_source,"set_offset","Enter the offset in pixels in the format: \"x,y\"")
		SetInstruction("Left click on a GUI element to offset it, right click to cancel")
	elseif text:find("load gui")~=nil then
		creating = "load"
		SetInstruction("Left click on a GUI element to load it and all of its children")
	elseif text:find("load code") then
		loadGUICode()
	elseif text:find("enable input")~=nil then
		if guiGetInputEnabled()==true then
			guiSetInputEnabled(false)
			outputChatBox("GUI input focus disabled")
		else
			guiSetInputEnabled(true)
			outputChatBox("GUI input focus enabled")
		end
	elseif text:find("font")~=nil then
		if dxdraw then
			ShowInputBox(menu_source,"dx_font","Enter the name of the font")
			guiSetVisible(dx_font_window,true)			
		else
			ShowInputBox(menu_source,"set_font","Enter the font ID (1 - 6)")
			guiSetVisible(font_example,true)
		end
	elseif text:find("create image")~=nil then
		ShowImageList(nil)
		creating = "pre_pre_image"
	elseif text:find("get property")~=nil then
		property_window_purpose = "get"
		
		local e = menu_source
		
		if getElementData(menu_source,"guieditor_ghost") then
			e = getElementData(menu_source,"guieditor_ghost") 
		end	
		
		property_window_source = e
		ToggleCEGUIProperties()
	elseif text:find("set property")~=nil then
		property_window_purpose = "set"
		
		local e = menu_source
		
		if getElementData(menu_source,"guieditor_ghost") then
			e = getElementData(menu_source,"guieditor_ghost") 
		end	
		
		property_window_source = e
		ToggleCEGUIProperties()
	elseif text:find("rel/abs screen")~=nil then
		if settings.screen_output_type.value==false then
			settings.screen_output_type.value = true
			outputChatBox("Set GUI elements (that are children of the screen) output type to Relative")
		else
			settings.screen_output_type.value = false
			outputChatBox("Set GUI elements (that are children of the screen) output type to Absolute")
		end
	elseif text:find("rel/abs child")~=nil then
		if settings.child_output_type.value==false then
			settings.child_output_type.value = true
			outputChatBox("Set GUI elements (that are children of a GUI element) output type to Relative")
		else
			settings.child_output_type.value = false
			outputChatBox("Set GUI elements (that are children of a GUI element) output type to Absolute")
		end	
	elseif text:find("print code")~=nil then
		PrintAllGUI("guiprint")
	elseif text:find("output code")~=nil then
		PrintAllGUI("guioutput")
	elseif text:find("print data")~=nil then
		local infox,infoy,infow,infoh,datatype
		
		infox,infoy = guiGetPosition(menu_source,true)
		infow,infoh = guiGetSize(menu_source,true)
		datatype = "Relative"
		outputChatBox("----------- " .. datatype .. " -----------")
		outputChatBox(string.format("x: %.4f  y: %.4f",infox,infoy))
		outputChatBox(string.format("width: %.4f  height: %.4f",infow,infoh))		
		
		infox,infoy = guiGetPosition(menu_source,false)
		infow,infoh = guiGetSize(menu_source,false)
		datatype = "Absolute"	
		outputChatBox("----------- " .. datatype .. " -----------")
		outputChatBox(string.format("x: %.4f  y: %.4f",infox,infoy))
		outputChatBox(string.format("width: %.4f  height: %.4f",infow,infoh))
	elseif text:find("set pos relative")~=nil then		
		ShowInputBox(menu_source,"set_pos_relative","Enter the new position in the format: \"x,y\" (0-1)")
	elseif text:find("set pos absolute")~=nil then	
		ShowInputBox(menu_source,"set_pos_absolute","Enter the new position in pixels in the format: \"x,y\"")	
	elseif text:find("set size relative")~=nil then		
		ShowInputBox(menu_source,"set_size_relative","Enter the new size in the format: \"width,height\" (0-1)")
	elseif text:find("set size absolute")~=nil then		
		ShowInputBox(menu_source,"set_size_absolute","Enter the new size in pixels in the format: \"width,height\"")
	elseif text == "undo" then
		undoPrevious()
	elseif text == "redo" then
		redoPrevious()
	elseif text == "horizontal scrollbar" or text == "create h. scrollbar" then
		creating = "horizontal_scrollbar"
		SetInstruction("Click and hold your mouse to create the scroll bar,\nmove the cursor to adjust the size")	
	elseif text == "vertical scrollbar" or text == "create v. scrollbar" then
		creating = "vertical_scrollbar"
		SetInstruction("Click and hold your mouse to create the scroll bar,\nmove the cursor to adjust the size")	
	elseif text == "create scrollpane" then
		creating = "scrollpane"
		SetInstruction("Click and hold your mouse to create the scrollpane,\nmove the cursor to adjust the size")
	elseif text == "set scroll pos" then
		ShowInputBox(menu_source,"scrollbar_pos","Enter a number between 0 - 100")
	elseif text == "help" then
		GUIEditorHelp()
	elseif text == "share" then
		shareCode()
	elseif text == "tutorial" then
		showTutorialPrompt(true)
	elseif text == "info & updates" then
		showInfoWindow()
	elseif text:find("dx text") then
		creating = "dx_text"
		SetInstruction("Click and hold your mouse to create the dx text,\nmove the cursor to adjust the size")
	elseif text:find("dx line") then
		creating = "dx_line"
		SetInstruction("Click and hold your mouse to create the first line point,\nmove the cursor and release to create the second")
	elseif text:find("dx rectangle") then
		creating = "dx_rectangle"
		SetInstruction("Click and hold your mouse to create the dx rectangle,\nmove the cursor to adjust the size")
	elseif text:find("dx image") then
		ShowImageList(nil)
		creating = "dx_pre_pre_image"	
	elseif text:find("settings") then
		loadSettings()
		showSettings()
	end
end


function ShowInputBox(menu_source,reason,box_title)
	guiSetVisible(text_input_window,true)
	guiSetVisible(clear_button,false)
	guiSetText(text_input_window,box_title)
	guiSetInputEnabled(true)
	guiEditSetReadOnly(text_input_edit,false)
	guiSetText(text_input_edit,"")
	
	guiBringToFront(text_input_window)
	guiBringToFront(text_input_edit)
	
	--[[
	local ghost
	
	if menu_source and isElement(menu_source) then
		ghost = getElementData(menu_source,"guieditor_ghost",false)
		
		if ghost and isElement(ghost) then
			menu_source = ghost
		end
	end
	]]
	
	text_input_source = menu_source
	text_input_reason = reason
	
	if reason=="delete_element" or reason=="delete_tab" or reason=="delete_tabpanel" then
		local delete_text = "Are you sure you want to delete that? (".. getMenuHeader(menu_source) .. ")"
	--	if menu_source and isElement(menu_source) and (not getElementData(menu_source,"modify_menu")) then delete_text = "Are you sure you want to delete that element? ("..tostring(getElementType(menu_source))..")" end
		guiSetText(text_input_edit,delete_text)
		guiEditSetReadOnly(text_input_edit,true)
	elseif reason=="variable" and captured==false then
		guiSetVisible(clear_button,true)
		
		if getElementData(menu_source,"guieditor_ghost",false) then
			menu_source = getElementData(menu_source,"guieditor_ghost",false)
		end		
		
		guiSetText(text_input_edit,getElementData(menu_source,"guieditor_varname"))
		guiEditSetCaretIndex(text_input_edit,string.len(guiGetText(text_input_edit)))
	elseif reason=="text" then
		guiSetVisible(clear_button,true)
		
		local t = ""
		
		if getElementData(menu_source,"modify_menu") and getElementData(menu_source,"modify_menu") >= dx_options and getElementData(menu_source,"modify_menu") <= dx_options + 3 then
			t = dx_attributes[menu_source].text
		else
			t = guiGetText(menu_source)
		end
		
		-- warp the newlines to avoid them being processed in the (single line) editbox (causes the editbox to stop taking input properly)
		guiSetText(text_input_edit,t:gsub("\n","\\n") )
		guiEditSetCaretIndex(text_input_edit,string.len(guiGetText(menu_source)))
	end
end

-- used to find the appropriate action when then input box has been accepted
function HideInputBox()
	local validation = false
	local close = true
	local text = guiGetText(text_input_edit)
	
	
	local dxdraw = nil
	if text_input_source and isElement(text_input_source) then
		dxdraw = getElementData(text_input_source,"modify_menu")
		
		if dxdraw and dxdraw >= dx_options and dxdraw <= dx_options + 3 then
			-- dx
		else
			dxdraw = nil
		end
	end
	
	if dxdraw then
		if text_input_reason == "dx_scale" then
			local scale = tonumber(text)
			if scale and scale >=0 and scale <= 100 then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"scale",text_input_source,dx_attributes[text_input_source].scale},
									rfunc = setDXAttribute, rvalues = {"scale",text_input_source,scale}}
									
				insertAndClearAction("undo",currentAction)			
			
				dx_attributes[text_input_source].scale = scale								
				validation = true
			end
		elseif text_input_reason == "dx_font" then
			local fonts = {["default"] = true,["default-bold"] = true, ["clear"] = true,["arial"] = true,["sans"] = true,["pricedown"] = true,["bankgothic"] = true,["diploma"] = true,["beckett"] = true}
			
			if fonts[text] then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"font",text_input_source,dx_attributes[text_input_source].font},
									rfunc = setDXAttribute, rvalues = {"font",text_input_source,text}}
									
				insertAndClearAction("undo",currentAction)				
			
				dx_attributes[text_input_source].font = text
				guiSetVisible(dx_font_window,false)
				validation = true				
			end	
		elseif text_input_reason == "dx_clip" then
			if text and (text == "true" or text == "false") then
				local clip = loadstring("return "..text)()
				
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"clip",text_input_source,dx_attributes[text_input_source].clip},
									rfunc = setDXAttribute, rvalues = {"clip",text_input_source,clip}}
									
				insertAndClearAction("undo",currentAction)					
				
				dx_attributes[text_input_source].clip = clip
				validation = true
			end
		elseif text_input_reason == "dx_postgui" then
			if text and (text == "true" or text == "false") then
				local post = loadstring("return "..text)()
				
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"postgui",text_input_source,dx_attributes[text_input_source].postgui},
									rfunc = setDXAttribute, rvalues = {"postgui",text_input_source,post}}
									
				insertAndClearAction("undo",currentAction)					
				
				dx_attributes[text_input_source].postgui = post
				validation = true
			end
		elseif text_input_reason == "dx_linewidth" then
			if text and tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 100 then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"width",text_input_source,dx_attributes[text_input_source].width},
									rfunc = setDXAttribute, rvalues = {"width",text_input_source,tonumber(text)}}
									
				insertAndClearAction("undo",currentAction)					
			
				dx_attributes[text_input_source].width = tonumber(text)
				validation = true
			end
		elseif text_input_reason == "dx_rotation" then
			if text and tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 360 then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"rotation",text_input_source,dx_attributes[text_input_source].rotation},
									rfunc = setDXAttribute, rvalues = {"rotation",text_input_source,tonumber(text)}}
									
				insertAndClearAction("undo",currentAction)					
			
				dx_attributes[text_input_source].rotation = tonumber(text)
				validation = true
			end
		elseif text_input_reason == "dx_rotx_offset" then
			if text and tonumber(text) then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"rxoffset",text_input_source,dx_attributes[text_input_source].rxoffset},
									rfunc = setDXAttribute, rvalues = {"rxoffset",text_input_source,tonumber(text)}}
									
				insertAndClearAction("undo",currentAction)					
			
				dx_attributes[text_input_source].rxoffset = tonumber(text)
				validation = true
			end
		elseif text_input_reason == "dx_roty_offset" then
			if text and tonumber(text) then
				currentAction[1] = {ufunc = setDXAttribute, uvalues = {"ryoffset",text_input_source,dx_attributes[text_input_source].ryoffset},
									rfunc = setDXAttribute, rvalues = {"ryoffset",text_input_source,tonumber(text)}}
									
				insertAndClearAction("undo",currentAction)					
			
				dx_attributes[text_input_source].ryoffset = tonumber(text)
				validation = true
			end			
		end	
	end
		
	if text_input_reason=="text" then
		-- fix the newline parsing
		local new_text = text:gsub("\\n","\n") 
		if dxdraw then
			currentAction[1] = {ufunc = setDXAttribute, uvalues = {"text",text_input_source,dx_attributes[text_input_source].text},
								rfunc = setDXAttribute, rvalues = {"text",text_input_source,new_text}}
								
			insertAndClearAction("undo",currentAction)
		
			setDXAttribute("text",text_input_source,new_text)			
		else
			if captured==true then
				local count = 1
				for i,v in ipairs(captured_elements) do
					if getElementData(v,"guieditor_ghost",false) then
						v = getElementData(v,"guieditor_ghost",false)
					end
					
					currentAction[i] = {ufunc = guiSetText, uvalues = {v,guiGetText(v)}, rfunc = guiSetText, rvalues = {v,new_text}}

					guiSetText(v,new_text)
				end
			else			
				currentAction[1] = {ufunc = guiSetText, uvalues = {text_input_source,guiGetText(text_input_source)}, rfunc = guiSetText, rvalues = {text_input_source,new_text}}
				
				guiSetText(text_input_source,new_text)
			end
			insertAndClearAction("undo",currentAction)
		end
		validation = true
	elseif text_input_reason=="alpha" then
		if text and tonumber(text) and tonumber(text)>=0 and tonumber(text)<=1 then
			if getElementData(text_input_source,"guieditor_ghost",false) then
				text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
			end
			
			currentAction[1] = {ufunc = guiSetAlpha, uvalues = {text_input_source,guiGetAlpha(text_input_source)}, rfunc = guiSetAlpha, rvalues = {text_input_source,tonumber(text)}}
			
			insertAndClearAction("undo",currentAction)
			
			guiSetAlpha(text_input_source,tonumber(text))
			setElementData(text_input_source,"guieditor_alpha",true)
			validation = true
		end
--[[	elseif text_input_reason=="selected_check" then
		local select = false
		if text=="true" then select = true end
		guiCheckBoxSetSelected(text_input_source,select)
		setElementData(text_input_source,"guieditor_selected",select)
	elseif text_input_reason=="selected_radio" then
		local select = false
		if text=="true" then select = true end
		guiRadioButtonSetSelected(text_input_source,select)
		setElementData(text_input_source,"guieditor_selected",select)]]
	elseif text_input_reason=="variable" then
		-- strip spaces from the variable name
		text = text:gsub(" ","_")

		if captured==true then
			for i,v in ipairs(captured_elements) do
				if getElementData(v,"guieditor_ghost",false) then
					v = getElementData(v,"guieditor_ghost",false)
				end
				
				--outputChatBox("varname set for "..getElementType(v).." ["..i.."]")
				currentAction[i] = {ufunc = setElementData, uvalues = {v,"guieditor_varname",getElementData(v,"guieditor_varname")},
									rfunc = setElementData, rvalues = {v,"guieditor_varname",text}}
				insertAndClearAction("undo",currentAction)
				
				setElementData(v,"guieditor_varname",text)
				
		--		if getElementType(v)=="gui-tabpanel" then
		--			for _,child in ipairs(getElementChildren(v)) do
		--				if getElementType(child)=="gui-tab" then
		--					setElementData(child,"guieditor_parent",text)
		--				end
		--			end
		--		end
			end
		else
			if getElementData(text_input_source,"guieditor_ghost",false) then
				text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
			end
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_varname",getElementData(text_input_source,"guieditor_varname")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_varname",text}}
			
			insertAndClearAction("undo",currentAction)		
				
			setElementData(text_input_source,"guieditor_varname",text)
			
		--	if getElementType(text_input_source)=="gui-tabpanel" then
		--		for _,v in ipairs(getElementChildren(text_input_source)) do
		--			if getElementType(v)=="gui-tab" then
		--				setElementData(v,"guieditor_parent",text)
		--			end
		--		end
		--	end
		end
		validation = true
	elseif text_input_reason=="column_title" then
		local id = guiGridListAddColumn(text_input_source,text,0.2)
		setElementData(text_input_source,"guieditor_colcount",getElementData(text_input_source,"guieditor_colcount")+1)
		setElementData(text_input_source,"guieditor_coltitle_"..getElementData(text_input_source,"guieditor_colcount"),text)
		
		
		local row = guiGridListGetRowCount(text_input_source)
		if row~=false and row>0 then
			for j = 0, row do
				guiGridListSetItemText(text_input_source,j,id,"-",false,false)
			end
		end		
		
--[[		local col = getElementData(text_input_source,"guieditor_colcount")
		if col>0 then
			for i = 1, col do
				local row = guiGridListGetRowCount(text_input_source)
				if row~=false and row>0 then
					for j = 0, row do
						guiGridListSetItemText(text_input_source,j,i,"-",false,false)
					end
				end
			end
		end
]]		
		validation = true
	elseif text_input_reason=="memo_read_only" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_readonly",getElementData(text_input_source,"guieditor_readonly")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_readonly",select}}
			
			currentAction[2] = {ufunc = guiMemoSetReadOnly, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_readonly")},
								rfunc = guiMemoSetReadOnly, rvalues = {text_input_source,select}}
			insertAndClearAction("undo",currentAction)		
			
			guiMemoSetReadOnly(text_input_source,select)
			setElementData(text_input_source,"guieditor_readonly",select)
			validation = true
		end
	elseif text_input_reason=="label_colour" then
		if text then
			local parts = split(text,string.byte(","))
			local red,green,blue,alpha
			red = tonumber(parts[1])
			green = tonumber(parts[2])
			blue = tonumber(parts[3])
			
			if red and red>=0 and red<=255 and green and green>=0 and green<=255 and blue and blue>=0 and blue<=255 then
				if dxdraw then
					alpha = tonumber(parts[4])
					if alpha and alpha >= 0 and alpha <= 255 then
						dx_attributes[text_input_source].colour = tocolor(red,green,blue,alpha)
						validation = true
					end
				else
					currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_colour",getElementData(text_input_source,"guieditor_colour")},
										rfunc = setElementData, rvalues = {text_input_source,"guieditor_colour",text}}
					
					local currentParts = split(getElementData(text_input_source,"guieditor_colour") or "0,0,0",string.byte(","))
					currentAction[2] = {ufunc = guiLabelSetColor, uvalues = {text_input_source,tonumber(currentParts[1]),tonumber(currentParts[2]),tonumber(currentParts[3])},
										rfunc = guiLabelSetColor, rvalues = {text_input_source,red,green,blue}}
					insertAndClearAction("undo",currentAction)					
				
					guiLabelSetColor(text_input_source,red,green,blue)
					setElementData(text_input_source,"guieditor_colour",text)
					validation = true
				end
			end
		end
	elseif text_input_reason=="label_vertical_align" then
		if text and (text=="top" or text=="center" or text=="bottom") then
			if dxdraw then
				dx_attributes[text_input_source].valign = text
			else
				currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_vertalign",getElementData(text_input_source,"guieditor_vertalign")},
									rfunc = setElementData, rvalues = {text_input_source,"guieditor_vertalign",text}}
				
				currentAction[2] = {ufunc = guiLabelSetVerticalAlign, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_vertalign")},
									rfunc = guiLabelSetVerticalAlign, rvalues = {text_input_source,text}}
				insertAndClearAction("undo",currentAction)				
			
				guiLabelSetVerticalAlign(text_input_source,text)
				setElementData(text_input_source,"guieditor_vertalign",text)
			end
			validation = true
		end
	elseif text_input_reason=="label_horizontal_align" then
		if text and (text=="left" or text=="center" or text=="right") then
			if dxdraw then
				dx_attributes[text_input_source].halign = text
			else
				currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_horizalign",getElementData(text_input_source,"guieditor_horizalign")},
									rfunc = setElementData, rvalues = {text_input_source,"guieditor_horizalign",text}}
				
				currentAction[2] = {ufunc = guiLabelSetHorizontalAlign, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_horizalign"),getElementData(text_input_source,"guieditor_wordwrap")},
									rfunc = guiLabelSetHorizontalAlign, rvalues = {text_input_source,text,getElementData(text_input_source,"guieditor_wordwrap")}}
				insertAndClearAction("undo",currentAction)				
			
				guiLabelSetHorizontalAlign(text_input_source,text,getElementData(text_input_source,"guieditor_wordwrap"))
				setElementData(text_input_source,"guieditor_horizalign",text)
			end
			validation = true
		end
	elseif text_input_reason=="label_wordwrap" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end
			if dxdraw then
				dx_attributes[text_input_source].wordwrap = select
			else
				currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_wordwrap",getElementData(text_input_source,"guieditor_wordwrap")},
									rfunc = setElementData, rvalues = {text_input_source,"guieditor_wordwrap",select}}
				
				currentAction[2] = {ufunc = guiLabelSetHorizontalAlign, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_horizalign"),getElementData(text_input_source,"guieditor_wordwrap")},
									rfunc = guiLabelSetHorizontalAlign, rvalues = {text_input_source,getElementData(text_input_source,"guieditor_horizalign"),select}}
				insertAndClearAction("undo",currentAction)			
				
				guiLabelSetHorizontalAlign(text_input_source,getElementData(text_input_source,"guieditor_horizalign"),select)
				setElementData(text_input_source,"guieditor_wordwrap",select)
			end
			validation = true
		end
	elseif text_input_reason=="edit_masked" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_masked",getElementData(text_input_source,"guieditor_masked")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_masked",select}}
				
			currentAction[2] = {ufunc = guiEditSetMasked, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_masked")},
								rfunc = guiEditSetMasked, rvalues = {text_input_source,select}}
			insertAndClearAction("undo",currentAction)				
			
			guiEditSetMasked(text_input_source,select)
			setElementData(text_input_source,"guieditor_masked",select)
			validation = true
		end
	elseif text_input_reason=="edit_read_only" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_readonly",getElementData(text_input_source,"guieditor_readonly")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_readonly",select}}
				
			currentAction[2] = {ufunc = guiEditSetReadOnly, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_readonly")},
								rfunc = guiEditSetReadOnly, rvalues = {text_input_source,select}}
			insertAndClearAction("undo",currentAction)					
			
			guiEditSetReadOnly(text_input_source,select)
			setElementData(text_input_source,"guieditor_readonly",select)	
			validation = true
		end
	elseif text_input_reason=="edit_maxlength" then
		if text and tonumber(text) and tonumber(text)>=0 and tonumber(text)<=65535 then
		
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_maxlength",getElementData(text_input_source,"guieditor_maxlength")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_maxlength",text}}
				
			currentAction[2] = {ufunc = guiEditSetMaxLength, uvalues = {text_input_source,tonumber(getElementData(text_input_source,"guieditor_maxlength") or 65535)},
								rfunc = guiEditSetMaxLength, rvalues = {text_input_source,tonumber(text)}}
			insertAndClearAction("undo",currentAction)				
		
			guiEditSetMaxLength(text_input_source,tonumber(text))
			setElementData(text_input_source,"guieditor_maxlength",text)
			validation = true
		end
	elseif text_input_reason=="progress_set" then
		if text and tonumber(text) and tonumber(text)>=0 and tonumber(text)<=100 then
		
			currentAction[1] = {ufunc = guiProgressBarSetProgress, uvalues = {text_input_source,guiProgressBarGetProgress(text_input_source)},
								rfunc = guiProgressBarSetProgress, rvalues = {text_input_source,tonumber(text)}}
			insertAndClearAction("undo",currentAction)			
		
			guiProgressBarSetProgress(text_input_source,tonumber(text))
			validation = true
		end
	elseif text_input_reason=="window_movable" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end	
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_movable",getElementData(text_input_source,"guieditor_movable")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_movable",select}}
				
			currentAction[2] = {ufunc = guiWindowSetMovable, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_movable")},
								rfunc = guiWindowSetMovable, rvalues = {text_input_source,select}}
			insertAndClearAction("undo",currentAction)			
			
			guiWindowSetMovable(text_input_source,select)
			setElementData(text_input_source,"guieditor_movable",select)	
			validation = true
		end
	elseif text_input_reason=="window_sizable" then
		if text and (text=="true" or text=="false") then
			local select = false
			if text=="true" then select = true end	
			
			currentAction[1] = {ufunc = setElementData, uvalues = {text_input_source,"guieditor_sizable",getElementData(text_input_source,"guieditor_sizable")},
								rfunc = setElementData, rvalues = {text_input_source,"guieditor_sizable",select}}
				
			currentAction[2] = {ufunc = guiWindowSetSizable, uvalues = {text_input_source,getElementData(text_input_source,"guieditor_sizable")},
								rfunc = guiWindowSetSizable, rvalues = {text_input_source,select}}
			insertAndClearAction("undo",currentAction)				
			
			guiWindowSetSizable(text_input_source,select)
			setElementData(text_input_source,"guieditor_sizable",select)
			validation = true
		end
	elseif text_input_reason=="delete_element" then
		--local var = getElementData(text_input_source,"guieditor_varname")
		currentAction = {}
		if captured==true then
			for _,v in ipairs(captured_elements) do
				local dx = getElementData(v,"modify_menu")
				
				if dx and dx >= dx_options and dx <= dx_options + 3 then
					-- dx
				else
					dx = nil
				end			
				
				currentAction = table.merge(currentAction,gatherRecreationData(v,dx))		
			
				if getElementData(v,"modify_menu") and getElementData(v,"modify_menu") >= dx_options and getElementData(v,"modify_menu") <= dx_options + 3 then
					removeDXDrawing(v)
				end 

				destroyElement(v)
			end
			
			insertAndClearAction("undo",currentAction)
		else
			currentAction = gatherRecreationData(text_input_source,dxdraw)
			
			if dxdraw then
				removeDXDrawing(text_input_source)
			end	
			
			insertAndClearAction("undo",currentAction)

			destroyElement(text_input_source)
		end
		validation = true
	elseif text_input_reason=="delete_tab" then
		currentAction = gatherRecreationData(text_input_source)
		insertAndClearAction("undo",currentAction)
		
        for _,value in ipairs(getElementChildren(text_input_source)) do	
			if value then
				destroyElement(value)
			end
		end
		guiDeleteTab(text_input_source,getElementParent(text_input_source))
		menu_source = nil
		validation = true
	elseif text_input_reason=="delete_tabpanel" then
		-- can only destroy a tabpanel from the tab right click menu, so get the tabpanel to destroy
		currentAction = gatherRecreationData(getElementParent(text_input_source))
		insertAndClearAction("undo",currentAction)		
		
		destroyElement(getElementParent(text_input_source))
		validation = true
	elseif text_input_reason=="set_offset" then
		if text then
			local sx,sy = guiGetScreenSize()
			local index = text:find(",")
			local valid = true
			
			if index==nil then valid = false end
			local x,y
			if valid == true then
				x = text:sub(0,index-1)
				y = text:sub(index+1)
				--outputChatBox("x: "..x.." y: "..y)
			end
			if x and y and tonumber(x) and tonumber(y) and tonumber(x)<=sx and tonumber(y)<=sy then
				validation = true
				offset_x = tonumber(x)
				offset_y = tonumber(y)
				offset_element = text_input_source
				offset_active = true
			end
		end
	elseif text_input_reason=="set_font" then
		if text then
			local id = tonumber(text)
			if id and id>0 and id<7 then
				validation = true
				
				currentAction[1] = {ufunc = guiSetFont, uvalues = {text_input_source,guiGetFont(text_input_source)},
									rfunc = guiSetFont, rvalues = {text_input_source,GetFontFromID(id)}}
				insertAndClearAction("undo",currentAction)					
				
				guiSetFont(text_input_source,GetFontFromID(id))
				guiSetVisible(font_example,false)
			end
		end
	elseif text_input_reason=="set_pos_relative" or text_input_reason=="set_size_relative" then
		if text then
			local parts = split(text,string.byte(','))
			if parts then
				local x,y = parts[1],parts[2]
				if x and y and tonumber(x) and tonumber(y) and tonumber(x)>=0 and tonumber(x)<=1 and tonumber(y)>=0 and tonumber(y)<=1 then
					validation = true
					if text_input_reason=="set_pos_relative" then 
						local cx,cy = guiGetPosition(text_input_source,true)
						currentAction[1] = {ufunc = guiSetPosition, uvalues = {text_input_source,cx,cy,true},
											rfunc = guiSetPosition, rvalues = {text_input_source,tonumber(x),tonumber(y),true}}
			
						insertAndClearAction("undo",currentAction)						
					
						guiSetPosition(text_input_source,tonumber(x),tonumber(y),true)				
					elseif text_input_reason=="set_size_relative" then 
						local cw,ch = guiGetSize(text_input_source,true)
						currentAction[1] = {ufunc = guiSetSize, uvalues = {text_input_source,cw,ch,true},
											rfunc = guiSetSize, rvalues = {text_input_source,tonumber(x),tonumber(y),true}}
						
						insertAndClearAction("undo",currentAction)						
					
						guiSetSize(text_input_source,tonumber(x),tonumber(y),true) 
					end				
				end
			end
		end
	elseif text_input_reason=="set_pos_absolute" or text_input_reason=="set_size_absolute" then
		if text then
			local parts = split(text,string.byte(','))
			if parts then
				x,y = parts[1], parts[2]
				if x and y and tonumber(x) and tonumber(y) then
					validation = true
					if text_input_reason=="set_pos_absolute" then 
						local cx,cy = guiGetPosition(text_input_source,false)
						currentAction[1] = {ufunc = guiSetPosition, uvalues = {text_input_source,cx,cy,false},
											rfunc = guiSetPosition, rvalues = {text_input_source,tonumber(x),tonumber(y),false}}				
											
						insertAndClearAction("undo",currentAction)						
					
						guiSetPosition(text_input_source,tonumber(x),tonumber(y),false)						
					elseif text_input_reason=="set_size_absolute" then 
						local cw,ch = guiGetSize(text_input_source,false)
						currentAction[1] = {ufunc = guiSetSize, uvalues = {text_input_source,cw,ch,false},
											rfunc = guiSetSize, rvalues = {text_input_source,tonumber(x),tonumber(y),false}}											
											
						insertAndClearAction("undo",currentAction)							
					
						guiSetSize(text_input_source,tonumber(x),tonumber(y),false) 				
					end
				end
			end
		end	
	elseif text_input_reason=="set_property_value" then
		if getElementData(text_input_source,"guieditor_ghost",false) then
			text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
		end	
	
		local oldprop = guiGetProperty(text_input_source,current_selected_property)
		
		if guiSetProperty(text_input_source,current_selected_property,text) then
			outputChatBox(getElementType(text_input_source).." property "..current_selected_property.." set to "..text)	

			currentAction[1] = {ufunc = guiSetProperty, uvalues = {text_input_source,current_selected_property,oldprop},
								rfunc = guiSetProperty, rvalues = {text_input_source,current_selected_property,text}}
			
			local prop_table = getElementData(text_input_source,"guieditor_properties")
			
			if prop_table[current_selected_property] then
				currentAction[2] = {ufunc = setPropTable, uvalues = {text_input_source,current_selected_property,prop_table[current_selected_property]},
									rfunc = setPropTable, rvalues = {text_input_source,current_selected_property,text}}
			else
				currentAction[2] = {ufunc = setPropTable, uvalues = {text_input_source,current_selected_property,nil},
									rfunc = setPropTable, rvalues = {text_input_source,current_selected_property,text}}
			end
			
			
			insertAndClearAction("undo",currentAction)	
			
			prop_table[current_selected_property] = text
			
			setElementData(text_input_source,"guieditor_properties",prop_table)
			validation = true
		else
			--outputChatBox("Invalid property")
		end	
	elseif text_input_reason=="get_property_value" then
		if getElementData(text_input_source,"guieditor_ghost",false) then
			text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
		end
			
		local value = guiGetProperty(text_input_source,text)
		if value then
			outputChatBox(getElementType(text_input_source).." property "..text..": "..value)
			property_window_source = nil
			guiSetVisible(property_window,false)
			validation = true		
		else
			--outputChatBox("Invalid Property")
		end
	elseif text_input_reason=="set_property" then
		if getElementData(text_input_source,"guieditor_ghost",false) then
			text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
		end	
	
		for property,_ in pairs(property_descriptions) do
			if text == property then
				current_selected_property = text
				ShowInputBox(text_input_source,"set_property_value","Enter the value you want to set the property to")
				property_window_source = nil
				guiSetVisible(property_window,false)				
				validation = true
				close = false
			end
		end
	elseif text_input_reason == "settings_snapping_precision" then
		if text then
			if tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 10 then
				guiGridListSetItemText(settings.gui.snapping_grid,0,2,tostring(text),false,true)
				validation = true
				guiGridListSetSelectedItem(settings.gui.snapping_grid,0,0)
			end
		end
	elseif text_input_reason == "settings_snapping_influence" then
		if text then
			if tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 2000 then
				guiGridListSetItemText(settings.gui.snapping_grid,1,2,tostring(text),false,true)
				validation = true
				guiGridListSetSelectedItem(settings.gui.snapping_grid,0,0)
			end
		end	
	elseif text_input_reason == "settings_snapping_recommended" then
		if text then
			if tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 100 then
				guiGridListSetItemText(settings.gui.snapping_grid,2,2,tostring(text),false,true)
				validation = true
				guiGridListSetSelectedItem(settings.gui.snapping_grid,0,0)
			end
		end	
	elseif text_input_reason == "scrollbar_pos" then
		if getElementData(text_input_source,"guieditor_ghost",false) then
			text_input_source = getElementData(text_input_source,"guieditor_ghost",false)
		end	
	
		if text then
			if tonumber(text) and tonumber(text) >= 0 and tonumber(text) <= 100 then
				guiScrollBarSetScrollPosition(text_input_source,tonumber(text))
				validation = true
			end
		end
	elseif text_input_reason == "gridlist_item_text" then
		if text then
			local r,c = guiGridListGetSelectedItem(text_input_source)
			
			if r and c and r ~= -1 and c ~= -1 then
				guiGridListSetItemText(text_input_source,r,c,text,false,false)
				validation = true
			else
				outputChatBox("Please select an item on the gridlist first.")
			end
		end
	elseif text_input_reason == "gridlist_item_colour" then
		if text then
			local r,c = guiGridListGetSelectedItem(text_input_source)
			
			if r and c and r ~= -1 and c ~= -1 then
				local parts = split(text,string.byte(","))
				local red,green,blue,alpha
				red = tonumber(parts[1])
				green = tonumber(parts[2])
				blue = tonumber(parts[3])
				alpha = tonumber(parts[4]) or 255
				
				if alpha < 0 or alpha > 255 then alpha = 255 end
				
				if red and red>=0 and red<=255 and green and green>=0 and green<=255 and blue and blue>=0 and blue<=255 then			
					guiGridListSetItemColor(text_input_source,r,c,red,green,blue,alpha)
					validation = true
				end
			else
				outputChatBox("Please select an item on the gridlist first.")
			end
		end
	end
	
	if validation == true and close == true then
		text_input_source = nil
		guiSetVisible(text_input_window,false)
		guiSetInputEnabled(false)
		guiSetText(text_input_window,"")
		SetInstruction("Right click to begin - /guihelp for feature details")
		if captured==true then
			captured = false
			HideDragBox()		
		end
		
		if guieditor_tutorial_waiting[text_input_reason] then
			progressTutorial(text_input_reason,text)
		end		
	elseif validation == false and close == true then
		outputChatBox("Invalid entry.")
	end
end


function HideInputBoxCancel()
	text_input_source = nil
	guiSetVisible(text_input_window,false)
	guiSetInputEnabled(false)
	guiSetText(text_input_window,"")
	if guiGetVisible(font_example)==true then
		guiSetVisible(font_example,false)
	end
	if guiGetVisible(dx_font_window) then
		guiSetVisible(dx_font_window,false)
	end
	SetInstruction("Right click to begin - /guihelp for feature details")
end


function ClearInputBox()
	guiSetText(text_input_edit,"")
	guiBringToFront(text_input_edit)
end


function setPropTable(element,prop,value)
	local prop_table = getElementData(element,"guieditor_properties")
	prop_table[prop] = value
	setElementData(element,"guieditor_properties",prop_table)
end


function gatherRecreationData(element,dx)
	local links = {}
	local group = {}
	local index = (dx == nil and 3 or 5)
	
	if dx and dx == 15 then index = 7 end
			
	local function search(e)
		if getElementData(e,"guieditor_ghost",false) then
			e = getElementData(e,"guieditor_ghost",false)
		end
				
		local a = generateCreation(e)
		local action = generateMiscSettings(e,index)
		
		for i,_ in ipairs(a) do
			action[i] = a[i]
		end
		
	--	action[1] = a
		action[#action + 1] = {ufunc = LoadGUIElement, uvalues = {e}}
		
		if dx then
			action = generateDXSettings(e,dx,action)
		end
				
		table.insert(links,{e,#group+1})
		group = table.merge(group,action)
				
		for i,v in ipairs(getElementChildren(e)) do
			search(v)
		end
	end
	
	search(element)

			
	-- generate all the links
	local link = {}
	for i,v in ipairs(group) do
		if v.uvalues then
			for k,a in ipairs(v.uvalues) do
				for _,e in ipairs(links) do
					if a == e[1] then
						if not group[e[2]].ulink then group[e[2]].ulink = {} end

						table.insert(group[e[2]].ulink,{#currentAction+i,"u",k})
					end
				end
			end
		end

		if v.rvalues then
			for k,a in ipairs(v.rvalues) do
				for _,e in ipairs(links) do
					if a == e[1] then
						if not group[e[2]].ulink then group[e[2]].ulink = {} end
						
						table.insert(group[e[2]].ulink,{#currentAction+i,"r",k})
					end
				end
			end
		end
	end
	
	return group
end
