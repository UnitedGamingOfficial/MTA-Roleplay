--[[ GUI Editor - Right Click Menus - Client ]]--


-- the options shown in each gui elements right click menu
local right_click_options = {
[1] = {"Create Window","Create Button","Create Label","Create Checkbox","Create Memo","Create Edit","Create Gridlist","Create Progress Bar","Create Tab Panel","Create Radio Button","Create Image","Create Scrollpane","Create Scrollbar","Drawing","Rel/Abs Screen","Rel/Abs Child","Load GUI","Load Code","Enable Input","Print Code","Output Code","Undo","Redo","Share","Help","Tutorial","Info & Updates","Settings","Cancel"}, -- screen
[2] = {"Set Title","Set Variable","Set Movable","Set Sizable","Set Alpha","Move","Create Button","Create Label","Create Checkbox","Create Memo","Create Edit","Create Gridlist","Create Progress Bar","Create Tab Panel","Create Radio Button","Create Image","Create Scrollpane","Create Scrollbar","Offset","Delete","Copy","Move to back","Print data","Set data","Set Property","Get Property","Cancel"}, -- window
[3] = {"Set Title","Set Variable","Set Alpha","Set Font","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print Data","Set data","Set Property","Get Property","Extra","Cancel"}, -- button
[4] = {"Set Title","Set Variable","Set Alpha","Set Read Only","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- memo
[5] = {"Set Title","Set Variable","Set Alpha","Set Colour","Set Font","Set Vertical Align","Set Horizontal Align","Wordwrap","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- label
[6] = {"Set Title","Set Variable","Set Alpha","Set Font","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- checkbox
[7] = {"Set Title","Set Variable","Set Alpha","Set Masked","Set Read Only","Set Max Length","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- edit field
[8] = {"Set Title","Set Variable","Set Alpha","Set Font","Move","Resize","Copy","Offset","Delete","Add Column","Add Row","Item Text","Item Colour","Print data","Set data","Move to back","Parent","Set Property","Get Property","Extra","Cancel"}, -- gridlist (needs work)
[9] = {"Set Variable","Set Alpha","Set Progress","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- progress bar
[10] = {"Set Variable","Set Alpha","Move","Resize","Copy","Delete","Add Tab","Move to back","Parent","Print data","Set data","Set Property","Get Property","Cancel"}, -- tab panel
[11] = {"Set Title","Set Variable",--[["Move","Resize",]]"Add Tab",--[["Copy",]]"Delete Tab Panel","Create Button","Create Label","Create Checkbox","Create Memo","Create Edit","Create Gridlist","Create Progress Bar","Create Tab Panel","Create Radio Button","Create Image","Parent","Set Property","Get Property","Cancel"}, -- tab
[12] = {"Set Title","Set Variable","Set Alpha","Set Font","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Set Property","Get Property","Extra","Cancel"}, -- radio button
[13] = {"Set Variable","Set Alpha","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Extra","Set data","Set Property","Get Property","Cancel"}, -- static image
[14] = {"Set Variable","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print data","Set data","Extra","Set Property","Get Property","Cancel"}, -- scrollpane (not detected by onClientMouseEnter)
[15] = {"Set Variable","Set Alpha","Set Scroll Pos","Move","Resize","Copy","Offset","Delete","Move to back","Print data","Set data","Extra","Set Property","Get Property","Cancel"}, -- scroll bar (not detected by onClientMouseEnter)
--[16] = {"Set Title","Set Variable","Set Alpha","Set Font","Move","Resize","Copy","Offset","Delete","Move to back","Parent","Print Data","Set data","Set Property","Get Property","Extra","Cancel"}, -- combobox

[16] = {"Set Title","Resize","Move","Set Colour","Set Scale","Set Font","Set Vertical Align","Set Horizontal Align","Clip","Wordwrap","Post GUI","Copy","Move to back","Print data","Set data","Delete","Cancel"},
[17] = {"Resize","Move","Set Colour","Set Width","Post GUI","Copy","Move to back","Print data","Set data","Delete","Cancel"},
[18] = {"Resize","Move","Set Colour","Post GUI","Copy","Move to back","Print data","Set data","Delete","Cancel"},
[19] = {"Resize","Move","Set Rotation","Set Rot X Offset","Set Rot Y Offset","Set Colour","Post GUI","Copy","Move to back","Print data","Set data","Delete","Cancel"},

["captured"] = {"Set Title","Set Variable","Copy","Move","Resize","Delete","Cancel"},
["extra"] = {"Create Button","Create Label","Create Checkbox","Create Memo","Create Edit","Create Gridlist","Create Progress Bar","Create Tab Panel","Create Radio Button","Create Image","Create Scrollpane","Create H. Scrollbar","Create V. Scrollbar"},
["resize"] = {"Resize width","Resize height"},
["set data"] = {"Set pos absolute","Set pos relative","Set size absolute","Set size relative"},
["copy"] = {"Copy Children"},
["move"] = {"Move X","Move Y"},
["drawing"] = {"DX Text","DX Line","DX Rectangle","DX Image"},
["create scrollbar"] = {"Horizontal Scrollbar", "Vertical Scrollbar"}
}


-- the highest number of options any individual GUI element has
max_options = 30 -- (window) dont forget to update this if you add a menu with more options (+1 extra for header label)
-- the highest number of options any individual sub menu has
--max_sub_options = 10 
max_sub_options = max_options -- as of parent_sub menus, these need to be the same

dx_options = 16 -- the start index of the direct x drawing function menus


-- the dimensions (width/height) of each right click menu
local row_size = 15
right_click_dimensions = {
[1] = {120,#right_click_options[1]*row_size},
[2] = {120,#right_click_options[2]*row_size},
[3] = {80,#right_click_options[3]*row_size},
[4] = {90,#right_click_options[4]*row_size},
[5] = {120,#right_click_options[5]*row_size},
[6] = {80,#right_click_options[6]*row_size},
[7] = {100,#right_click_options[7]*row_size},
[8] = {100,#right_click_options[8]*row_size},
[9] = {100,#right_click_options[9]*row_size},
[10] = {80,#right_click_options[10]*row_size},
[11] = {120,#right_click_options[11]*row_size},
[12] = {100,#right_click_options[12]*row_size},
[13] = {100,#right_click_options[13]*row_size},
[14] = {90,#right_click_options[14]*row_size},
[15] = {90,#right_click_options[15]*row_size},
--[16] = {90,#right_click_options[16]*row_size},

[16] = {120,#right_click_options[16]*row_size},
[17] = {90,#right_click_options[17]*row_size},
[18] = {90,#right_click_options[18]*row_size},
[19] = {120,#right_click_options[19]*row_size},

["captured"] = {80,#right_click_options["captured"]*row_size},
["extra"] = {120,#right_click_options["extra"]*row_size},
["resize"] = {80,#right_click_options["resize"]*row_size},
["set data"] = {100,#right_click_options["set data"]*row_size},
["copy"] = {90,#right_click_options["copy"]*row_size},
["move"] = {60,#right_click_options["move"]*row_size},
["drawing"] = {80,#right_click_options["drawing"]*row_size},
["create scrollbar"] = {110,#right_click_options["create scrollbar"]*row_size}
}


addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()
	
	right_click_menu = guiCreateStaticImage(0,0,right_click_dimensions[1][1],right_click_dimensions[1][2],"dot.png",false)
	guiSetVisible(right_click_menu,false)
	right_click_sub_menu = guiCreateStaticImage(0,0,right_click_dimensions[1][1],right_click_dimensions[1][2],"dot.png",false)
	guiSetVisible(right_click_sub_menu,false)
	right_click_parent_menu = guiCreateStaticImage(0,0,right_click_dimensions[1][1],right_click_dimensions[1][2],"dot.png",false)
	guiSetVisible(right_click_parent_menu,false)
	
	setElementData(right_click_menu,"cant_edit",true)
	setElementData(right_click_sub_menu,"cant_edit",true)
	setElementData(right_click_parent_menu,"cant_edit",true)
	
	right_click_labels = {}	
	for i=1, max_options do
		right_click_labels[i] = guiCreateLabel(0.00,0.0,0.95,0.1,"",true,right_click_menu)
		guiLabelSetVerticalAlign(right_click_labels[i],"center")
	end
	
	right_click_sub_menu_labels = {}
	for i=1, max_sub_options do
		right_click_sub_menu_labels[i] = guiCreateLabel(0.00,0.0,0.95,0.1,"",true,right_click_sub_menu)
		guiLabelSetVerticalAlign(right_click_sub_menu_labels[i],"center")	
	end
	
	right_click_parent_menu_labels = {}
	for i=1, max_sub_options do
		right_click_parent_menu_labels[i] = guiCreateLabel(0.00,0.0,0.95,0.1,"",true,right_click_parent_menu)
		guiLabelSetVerticalAlign(right_click_parent_menu_labels[i],"center")	
	end	
	
	for key,_ in ipairs(right_click_dimensions) do
		right_click_dimensions[key][2] = right_click_dimensions[key][2] + row_size
	end
	right_click_dimensions["captured"][2] = right_click_dimensions["captured"][2] + row_size
end)


addEventHandler("onClientMouseEnter",root,function(absx,abys)
	if gui_editor then
		--outputDebugString("Enter: "..tostring(getElementType(source)))
		local option = false
		for i=1, max_options do
			if (source==right_click_labels[i] or source==right_click_parent_menu_labels[i]) and i ~= 1 then
				local menu = right_click_labels
				if source==right_click_parent_menu_labels[i] then
					menu = right_click_parent_menu_labels
				end
			
				option = true
				guiLabelSetColor(menu[i],255,0,0)
				local text = guiGetText(menu[i])

				-- if its the extra option
				if text:find("Extra")~=nil then
					-- show the extra sub menu
					LoadSubMenu(text,menu)
				elseif text:find("Resize")~=nil then
					-- show the width/height only sub menu
					LoadSubMenu(text,menu)
				elseif text:find("Move") and not text:find("back") then
					LoadSubMenu(text,menu,"back")
				elseif text:find("Set data")~=nil then
					-- show the set data sub menu
					LoadSubMenu(text,menu)
				elseif text:find("Copy")~=nil and captured == false then
					-- show the copy sub menu
					LoadSubMenu(text,menu)
				elseif text:find("Parent")~=nil then
					if source~=right_click_parent_menu_labels[i] then
						LoadSubMenu(text,menu)
					else
						guiLabelSetColor(menu[i],255,255,255)
					end
				elseif text:find("Drawing") then
					LoadSubMenu(text,menu)
				elseif text:find("Create Scrollbar") then					
					LoadSubMenu(text,menu)
				end
			elseif source==right_click_labels[i] and i == 1 then
				option = true
			elseif source == right_click_sub_menu_labels[i] then
				option = true	
				guiLabelSetColor(right_click_sub_menu_labels[i],255,0,0)		
			elseif source == right_click_parent_menu_labels[i] then
				option = true
				if i ~= 1 then
					guiLabelSetColor(right_click_parent_menu_labels[i],255,0,0)
				end
			else
				if i ~= 1 then
					guiLabelSetColor(right_click_labels[i],255,255,255)
				end
				
				guiLabelSetColor(right_click_sub_menu_labels[i],255,255,255)

				if i ~= 1  then
					guiLabelSetColor(right_click_parent_menu_labels[i],255,255,255)
				end
			end
		end
		
		local text = guiGetText(source)
		if text~=nil and text=="Cancel" then cancel = true else cancel = false end
		
		local type = getElementType(source)
		-- draw borders around these types of elements (dont draw anything if the input box is visible as drawing borders steals the focus)
		if not guiGetVisible(text_input_window) and (type=="gui-label" or type=="gui-checkbox" or type=="gui-radiobutton") then
			local parent = getElementParent(source)
			-- only draw the border if the element isnt a right click menu option or an element on a guieditor menu (help,properties,etc) and we arent in the middle of creating, moving or resizing something
			if source~=right_click_menu and option==false and (not creating or (creating~="resize" and creating~="move" and creating~="resize_width" and creating~="resize_height")) and getElementData(source,"cant_highlight")~=true then
				ShowBorder(source)
			end
		end
		current_cursor_element = source
	end
end)


addEventHandler("onClientMouseLeave",root, function(absx,absy)
	if gui_editor then
		--outputDebugString("Exit: "..tostring(getElementType(source)))
		local extra = false
		local parent = false
		for i=1, max_options do
			if i ~= 1 then
				guiLabelSetColor(right_click_labels[i],255,255,255)
				if source==right_click_labels[i] or source==right_click_parent_menu_labels[i] then
					local menu = right_click_labels
					if source==right_click_parent_menu_labels[i] then
						menu = right_click_parent_menu_labels
					end
										
					local label_text = guiGetText(menu[i])
					if label_text:find("Extra")~=nil or label_text:find("Resize")~=nil or label_text:find("Set data")~=nil or label_text:find("Copy")~=nil or label_text:find("Parent") or label_text:find("Move") or label_text:find("Drawing") or label_text:find("Create Scrollbar") then
						if extra_menu_x_flip==true then
							local ex,ey,ew,eh = GetAbsolutePositionAndSizeOfElement(menu[i])
							if absx>=ex then
								if label_text:find("Parent") then
									parent = true
								else
									extra = true
								end
							end
						else
							if label_text:find("Parent") then
								parent = true
							else
								extra = true
							end							
						end
					--	outputChatBox("extra: "..tostring(extra).." parent: "..tostring(parent))
					end
				end
			end
			if source==right_click_parent_menu_labels[i] then
			--	extra = true
				parent = true
			end			
			if source==right_click_sub_menu_labels[i] then
				extra = true
			--	outputChatBox("leaving menu option")
			end
		end	
		if source==right_click_sub_menu then
			extra = true
		--	outputChatBox("leaving menu")
		end
		if source==right_click_parent_menu then
			extra = true
			parent = true
		end
		
		HideBorder()
		current_cursor_element = nil
		
		if extra or parent then
			if extra then		
			--	outputChatBox("checking extra")
				local extra_x, extra_y = guiGetPosition(right_click_sub_menu,false)
				local extra_w, extra_h = guiGetSize(right_click_sub_menu,false)

				if absx>=extra_x and absx<=(extra_x+extra_w-0.5) and absy>=extra_y and absy<=(extra_y+extra_h-0.5) then
					extra = "open"
				else
					guiSetVisible(right_click_sub_menu,false)
				end
			end		
			if parent and extra ~= "open" then
			--	outputChatBox("checking parent")
				local extra_x, extra_y = guiGetPosition(right_click_parent_menu,false)
				local extra_w, extra_h = guiGetSize(right_click_parent_menu,false)

				if absx>=extra_x and absx<=(extra_x+extra_w-0.5) and absy>=extra_y and absy<=(extra_y+extra_h-0.5) then
					parent = false
				else
					guiSetVisible(right_click_parent_menu,false)
				end		
			end
		end
	else
		HideBorder()
	end
end)


function LoadRightClickMenu(x,y)
	-- clean the labels
	for i=1, max_options do
		guiSetText(right_click_labels[i],"")
		guiSetSize(right_click_labels[i],0.0,0.0,true)
		guiSetPosition(right_click_labels[i],0.0,0.0,true)
		guiSetFont(right_click_labels[i],"default-normal")
	end
	
	--outputDebugString("Menu for: "..tostring(current_cursor_element and getElementType(current_cursor_element) or "nil"))
	
	-- figure out which gui element was right clicked so we can load the appropriate options into the menu
	local id = 1
	if current_cursor_element then
		id = GetIDFromType(getElementType(current_cursor_element))
		current_menu = current_cursor_element
	else
		current_menu = "Screen"
	end
	
	if captured == true then
		id = "captured"
	end
	
	if isElement(current_menu) and getElementData(current_menu,"modify_menu",false) then
		id = getElementData(current_menu,"modify_menu",false)
	end
	
	local slots = #right_click_options[id]+1
	
	-- calculate the positions and size of each option within the menu and set the text, +row_size to account for header slot
	guiSetSize(right_click_menu,right_click_dimensions[id][1],right_click_dimensions[id][2],false)
	
	for i=1, slots do
		guiSetPosition(right_click_labels[i],0.05,((1/(slots+1))*(i-1))+((1/(slots+1))/2),true)
		guiSetSize(right_click_labels[i],0.95,(1/(slots-1)),true)
		if i == 1 then
			local text = getMenuHeader(current_menu)
			guiSetText(right_click_labels[i],text)
			guiLabelSetColor(right_click_labels[i],80,0,102)
			guiSetFont(right_click_labels[i],"default-bold-small")
		else
			guiSetText(right_click_labels[i],right_click_options[id][i-1])
		end
	end
	
	local x_dir, y_dir = 0,0
	local sx,sy = guiGetScreenSize()
	
	-- flip the menu across the cursor if it breaks the screen
	if x+right_click_dimensions[id][1] > sx then x_dir = -right_click_dimensions[id][1] end
	if y+right_click_dimensions[id][2] > sy then y_dir = -right_click_dimensions[id][2] end
	
	guiSetPosition(right_click_menu,x+x_dir,y+y_dir,false)
	guiSetVisible(right_click_menu,true)
	guiBringToFront(right_click_menu)
end


function LoadSubMenu(trigger,source,ignore)
	local label = right_click_sub_menu_labels
	local menu = right_click_sub_menu
	local source_menu = right_click_menu
	local source_labels = right_click_labels

	-- if the trigger is parent, we want to modify the parent menu and the labels on it
	if trigger == "Parent" then
		label = right_click_parent_menu_labels
		menu = right_click_parent_menu
	end
	
	-- if the source is the parent menu, we want to use that as a reference for calculating the submenu
	if source == right_click_parent_menu_labels then
		source_menu = right_click_parent_menu
		source_labels = right_click_parent_menu_labels
	end

	-- clean all possible sub menu labels	
	for i=1, max_sub_options do
		guiSetText(label[i],"")
		guiSetSize(label[i],0.0,0.0,true)
		guiSetPosition(label[i],0.0,0.0,true)		
		guiSetFont(label[i],"default-normal")
	end

	local id = 1
	if source == right_click_parent_menu_labels then
		if getElementParent(current_menu)~=nil and getElementParent(current_menu)~="Screen" then
			id = GetIDFromType(getElementType(getElementParent(current_menu)))
		end		
	else
		if isElement(current_menu) then
			id = GetIDFromType(getElementType(current_menu))
		end	
	end

	if captured == true then
		id = "captured"
	end
	
	if isElement(current_menu) and getElementData(current_menu,"modify_menu",false) and source ~= right_click_parent_menu_labels then
		id = getElementData(current_menu,"modify_menu",false)
	end
	
	--outputDebugString(tostring(trigger)..","..tostring(id))
	
	-- find out which label id the extra option is on the menu
	local trigger_id = nil
	for key, value in ipairs(right_click_options[id]) do
		if value:find(trigger)~=nil then
			if (ignore and (not value:find(ignore))) or not ignore then
				trigger_id = key+1 -- +1 to account for the header slot
			end
		end
	end	
	
	trigger = trigger:lower()
	
	local slots = 0
	
	if trigger == "parent" then
		trigger = GetIDFromType(getElementType(getElementParent(current_menu)))
		slots = slots + 1
	end

	slots =  #right_click_options[trigger] + slots

	-- calculate the positions and size of each option within the menu and set the text	
	guiSetSize(menu,right_click_dimensions[trigger][1],right_click_dimensions[trigger][2],false)
	
	for i=1, slots do		
		if tonumber(trigger) then
			guiSetPosition(label[i],0.05,((1/(slots+1))*(i-1))+((1/(slots+1))/2),true)
			guiSetSize(label[i],0.95,(1/(slots-1)),true)		
			
			if i == 1 then
				local text = isElement(getElementParent(current_menu)) and getElementType(getElementParent(current_menu)) or getElementParent(current_menu)
				if text == "guiroot" then text = "Screen" end
				guiSetText(label[i],text)
				guiLabelSetColor(label[i],80,0,102)
				guiSetFont(label[i],"default-bold-small")
			else
				guiSetText(label[i],right_click_options[trigger][i-1])
			end	
		else
			guiSetPosition(label[i],0.05,((1/(slots))*(i-1)),true)
			guiSetSize(label[i],0.95,(1/(slots)),true)
			guiSetText(label[i],right_click_options[trigger][i])	
		end
	end	
	
	local x_dir, y_dir = 0,0
	local sx,sy = guiGetScreenSize()
	local menu_x,menu_y = guiGetPosition(source_menu,false)
	local menu_w,_ = guiGetSize(source_menu,false)	
	extra_menu_x_flip = false
	
	-- calculate the position of the resize option in pixels
	local x = menu_x+menu_w	
	local _,y_ = guiGetPosition(source_labels[trigger_id],false)
	local _,h_ = guiGetSize(source_labels[trigger_id],false)
	local y = y_+menu_y
	
	
	-- flip the menu across the cursor if it breaks the screen
	if x+right_click_dimensions[trigger][1] > sx then x_dir = -(right_click_dimensions[trigger][1]+menu_w) extra_menu_x_flip = true end
	if y+right_click_dimensions[trigger][2] > sy then y_dir = -right_click_dimensions[trigger][2]+h_ end	
	
	guiSetPosition(menu,x+x_dir,y+y_dir,false)
	guiSetVisible(menu,true)
	guiBringToFront(menu)
end



function getMenuHeader(menu)
	if menu and isElement(menu) then
		local ghost = getElementData(menu,"guieditor_ghost",false)
		if ghost and isElement(ghost) then menu = ghost end
		
		if getElementData(menu,"modify_menu",false) then
			local modifier = getElementData(menu,"modify_menu",false) 
			if modifier == 14 then
				return "Scrollpane"
			elseif modifier == 15 then
				return "Scroll Bar"
			elseif modifier == dx_options then
				return "DX  Text"
			elseif modifier == dx_options + 1 then
				return "DX  Line"
			elseif modifier == dx_options + 2 then
				return "DX  Rectangle"
			elseif modifier == dx_options + 3 then
				return "DX  Image"
			end
		else
			return getElementType(menu)
		end
	end
	
	return tostring(menu)
end



