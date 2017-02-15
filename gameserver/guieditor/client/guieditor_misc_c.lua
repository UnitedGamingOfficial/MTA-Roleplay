--[[ GUI Editor (client) ]]--

--[[ Todo: 
--		figure a way to manipulate elements that do not trigger onClientMouseEnter/Leave (is this even a practical possibility? heavy maths on render is not ideal) (check mapeditor, this may have already been solved there)
--			scrollbars do not trigger, scrollpanes are untested (but currently not included in guieditor)
--			tested onClientMouseMove, no effect
--		would be nice to be able to automatically flag elements to be created (using abs values) with the screen size in mind
--		eg: flagging that you want the window in the centre of the screen, and the editor automatically generating the guiGetScreenSize line & maths involved
--		large portions of the code could also do with a good rewrite but im not sure its worth it this late in the game (or if i have the time)
--			have been rewriting sections as i come accross them when implementing new features, hopefully this will suffice for now
--			jan/2011 - only supervised adults are allowed access to this file. High risk of full body shutdown on viewing

--		loading gui by resource name
--		find a way to stop maintaining this code from making my brain bleed

	Done (this release):
--		fixed superfluous label settings
--		added gridlist item text and colour options
--		attempt image loading before reverting to mtalogo
--		added scrollpanes and scrollbars (really just placeholders, functionality is very limited)
--		fixed dx text alignment
--		fixed code output date
--		when changing dx text the old text now fills in correctly
--		fixed a few code output bugs
--]]


root = getRootElement()
local_player = getLocalPlayer()
gui_editor = false

-- tables that store all the user created gui elements
GUIEditor_Window,GUIEditor_Button,GUIEditor_Checkbox,GUIEditor_Memo,GUIEditor_Label,GUIEditor_Edit,GUIEditor_Grid,GUIEditor_Progress,GUIEditor_TabPanel,GUIEditor_Tab,GUIEditor_Radio,GUIEditor_Image,GUIEditor_Scrollpane,GUIEditor_Scrollbar = {},{},{},{},{},{},{},{},{},{},{},{},{},{}
window_count,button_count,checkbox_count,memo_count,label_count,edit_count,grid_count,progress_count,tabpanel_count,tab_count,radio_count,image_count,scrollpane_count,scrollbar_count = 1,1,1,1,1,1,1,1,1,1,1,1,1,1


current_menu = nil
current_cursor_element = nil
move, move_offset_x, move_offset_y = nil,nil,nil

local parent
cancel = false
creating = nil
offset_element,offset_active,offset_x,offset_y = nil,false,nil,nil
image_dir = ""

border_thickness = 1

extra_menu_x_flip = false

local checking_updates = false


function SetupGuiEditor()
	sx,sy = guiGetScreenSize()

	-- red border used around labels/checkboxes/radiobuttons
	border_left = guiCreateStaticImage(0,0,border_thickness,10,"red_dot.png",false)
	border_right = guiCreateStaticImage(0,0,border_thickness,10,"red_dot.png",false)
	border_top = guiCreateStaticImage(0,0,10,border_thickness,"red_dot.png",false)
	border_bottom = guiCreateStaticImage(0,0,10,border_thickness,"red_dot.png",false)
	guiSetVisible(border_left,false)
	guiSetVisible(border_right,false)
	guiSetVisible(border_top,false)
	guiSetVisible(border_bottom,false)
	
	setElementData(border_left,"cant_edit",true)
	setElementData(border_right,"cant_edit",true)
	setElementData(border_top,"cant_edit",true)
	setElementData(border_bottom,"cant_edit",true)
	
	text_input_window = guiCreateWindow((sx/2)-75,(sy/2)-25,360,100,"",false)
	text_input_edit = guiCreateEdit(0.01,0.3,0.99,0.3,"",true,text_input_window)
	local accept_button = guiCreateButton(0.1,0.7,0.3,0.2,"Accept",true,text_input_window)
	local decline_button = guiCreateButton(0.6,0.7,0.3,0.2,"Exit",true,text_input_window)
	clear_button = guiCreateButton(0.4371,0.7,0.1257,0.2,"Clear",true,text_input_window)
	guiSetVisible(clear_button,false)
	addEventHandler("onClientGUIClick",accept_button,HideInputBox,false)
	addEventHandler("onClientGUIClick",decline_button,HideInputBoxCancel,false)
	addEventHandler("onClientGUIClick",clear_button,ClearInputBox,false)
	guiSetVisible(text_input_window,false)
	
	-- label at the top, centre of the screen giving brief instructions about actions
	instruction_text = guiCreateLabel((sx/2)-225,10,450,40,"",false)
	guiLabelSetColor(instruction_text,255,70,70)
	guiLabelSetVerticalAlign(instruction_text,"center")
	guiLabelSetHorizontalAlign(instruction_text,"center",true)
	guiSetFont(instruction_text,"default-bold-small")	
	
	font_example = guiCreateLabel((sx/2)-350,sy-247,700,247,"",false)
	font_example_one = guiCreateLabel(0.0371,0.0445,0.2012,0.0650,"1: Example Text",true,font_example)
	guiSetFont(font_example_one,"default-normal")
	font_example_two = guiCreateLabel(0.0385,0.1255,0.1618,0.0582,"2: Example Text",true,font_example)
	guiSetFont(font_example_two,"default-small")
	font_example_three = guiCreateLabel(0.0371,0.1983,0.1991,0.0650,"3: Example Text",true,font_example)
	guiSetFont(font_example_three,"default-bold-small")
	font_example_four = guiCreateLabel(0.0357,0.2753,0.2219,0.0787,"4: Example Text",true,font_example)
	guiSetFont(font_example_four,"clear-normal")
	font_example_five = guiCreateLabel(0.0342,0.3360,0.6225,0.2794,"5: Example Text",true,font_example)
	guiSetFont(font_example_five,"sa-header")
	font_example_six = guiCreateLabel(0.0385,0.5708,0.9609,0.4279,"6: Example Text",true,font_example)
	guiSetFont(font_example_six,"sa-gothic")
	guiSetVisible(font_example,false)
	
	dx_font_window = guiCreateWindow((sx/2)-145,sy-214-5,290,214,"DX Fonts",false)
	dx_font_scrollpane = guiCreateScrollPane(9,23,274,183,false,dx_font_window)
	dx_font_label = guiCreateLabel(5,5,262,173,"\"default\": Tahoma\n\"default-bold\": Tahoma Bold\n\"clear\": Verdana\n\"arial\": Arial\n\"sans\": Microsoft Sans Serif\n\"pricedown\": Pricedown (GTA's theme text)\n\"bankgothic\": Bank Gothic Medium\n\"diploma\": Diploma Regular\n\"beckett\": Beckett Regular",false,dx_font_scrollpane)
	guiSetVisible(dx_font_window,false)
	guiWindowSetSizable(dx_font_window,false)
	
	setElementData(dx_font_window,"cant_edit",true)
	setElementData(dx_font_scrollpane,"cant_edit",true)
	setElementData(dx_font_label,"cant_edit",true)
	setElementData(dx_font_label,"cant_highlight",true)
		
	bindKey("g","up",function ()
		if getKeyState("lshift")==true or getKeyState("rshift")==true then
			StartEditing()
		end
	end)
		
	image_help_window = guiCreateWindow((sx/2)-159,(sy/2)-64,318,128,"",false)
	image_help_label = guiCreateLabel(0.0315,0.1191,0.9338,0.6094,"To add your own images, navigate to the ..\\resources\\guieditor\\images folder and place your .png image files inside. Open the guieditor meta.xml and add the image as a file using the same format as one of the test images (mtalogo.png/shruk.png)",true,image_help_window)
	image_help_ok = guiCreateButton(0.3817,0.7518,0.2271,0.1418,"ok",true,image_help_window)
	guiLabelSetHorizontalAlign(image_help_label,"center",true)
	guiLabelSetHorizontalAlign(image_help_label,"center",true)
	guiSetVisible(image_help_window,false)
		
	image_window = guiCreateWindow((sx/2)-112,(sy/2)-116,224,238,"",false)
	image_accept_button = guiCreateButton(0.5536,0.8228,0.3973,0.1266,"Accept",true,image_window)
	image_exit_button = guiCreateButton(0.0446,0.8228,0.3973,0.1266,"Exit",true,image_window)
	image_gridlist = guiCreateGridList(0.0402,0.097,0.9107,0.7004,true,image_window)
	image_help_button = guiCreateButton(0.4554,0.8529,0.0848,0.0798,"?",true,image_window)
	guiGridListSetSelectionMode(image_gridlist,2)
	guiGridListAddColumn(image_gridlist,"Images",0.2)
	addEventHandler("onClientGUIClick",image_exit_button,ExitImageList,false)
	addEventHandler("onClientGUIClick",image_accept_button,AcceptImageList,false)
	addEventHandler("onClientGUIClick",image_help_button,ShowImageHelp,false)
	addEventHandler("onClientGUIClick",image_help_ok,HideImageHelp,false)
	--addEventHandler("onClientGUIDoubleClick",image_gridlist,AcceptImageList,false)
	guiSetVisible(image_window,false)
	
	
	guieditorInfoWindow = guiCreateWindow((sx/2)-109,(sy/2)-74,218,148,"GUI Editor Info",false)
	
	guieditorVersionLabel = guiCreateLabel(11,23,196,18,"GUI Editor Version x.x.x",false,guieditorInfoWindow)
	guiLabelSetHorizontalAlign(guieditorVersionLabel,"center",true)
	
	guieditorUpdateButton = guiCreateButton(41,79,136,25,"Check for Updates",false,guieditorInfoWindow)
	
	guieditorUpdateLabel = guiCreateLabel(11,45,196,33,"Update Status: unknown",false,guieditorInfoWindow)
	guiLabelSetHorizontalAlign(guieditorUpdateLabel,"center",true)
	
	guieditorUpdateCheckbox = guiCreateCheckBox(9,116,200,18,"Check for updates on startup",false,false,guieditorInfoWindow)

	addEventHandler("onClientGUIClick",guieditorInfoWindow,function(button,state)
		if button == "left" and state == "up" then
			if source ~= guieditorUpdateButton and source ~= guieditorUpdateCheckbox then
				hideInfoWindow()
				checking_updates = false
			elseif source == guieditorUpdateButton then
				checking_updates = true
				triggerServerEvent("checkUpdateStatus",getLocalPlayer(),true)
				guiSetText(guieditorUpdateLabel,"Checking...")
			end
		end
	end,true)
	
	guiWindowSetSizable(guieditorInfoWindow,false)
	
	setElementData(guieditorInfoWindow,"cant_edit",true)
	setElementData(guieditorVersionLabel,"cant_edit",true)
	setElementData(guieditorUpdateButton,"cant_edit",true)
	setElementData(guieditorUpdateLabel,"cant_edit",true)
	setElementData(guieditorUpdateCheckbox,"cant_edit",true)
	
	setElementData(guieditorVersionLabel,"cant_highlight",true)
	setElementData(guieditorUpdateLabel,"cant_highlight",true)
	setElementData(guieditorUpdateCheckbox,"cant_highlight",true)
	
	guiSetVisible(guieditorInfoWindow,false)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),SetupGuiEditor)



addEventHandler("onClientResourceStop",resourceRoot,function()
	for _,v in ipairs(gui_element_names) do
		for _,gui_element in ipairs(getElementsByType(v)) do
			if getElementType(getElementParent(gui_element))=="guiroot" then
				setElementData(gui_element,"guieditor_varname",nil)
			end
		end
	end
end)	


--[[ -- removed in favour of using straight pixel maths 
function ReturnRelativePosition(element_parent,x,y)
	-- parent is the immediate parent of the gui element you are trying to move
	-- x & y are the screen width & height respectively * the relative cursor position (a number between 0 and width/height)
	
	local px,py,pw,ph = GetAbsolutePositionAndSizeOfElement(element_parent)
	--outputChatBox("<RRP> ppx: "..ppx.." ppy: "..ppy.." psx: "..psx.." psy: "..psy.." x: "..x.." y: "..y)
	
	--((screen width*relative cursor position)/parent width)-(parent x/parent width),((screen height*relative cursor position)/parent height)-(parent y/parent height)
	return (x/pw)-(px/pw),(y/ph)-(py/ph)
end
]]

-- return the position and size of the element in pixels offset from 0,0
function GetAbsolutePositionAndSizeOfElement(element)
	if element and isElement(element) then
		-- x position,y position,width,height
		local px,py,pw,ph = 0,0,0,0 
		
		-- get the position and size of the element
		px,py = guiGetPosition(element,false)
		pw,ph = guiGetSize(element,false)
		
		-- if theres more than 1 tab (meaning the title tabs above the window are displayed) then we add the difference (pixel height of the tab) to compensate for the loss of real estate even though the original position remains
		if getElementType(element)=="gui-tab" and #getElementChildren(getElementParent(element))>1 then
			local _,parent_temp_h = guiGetSize(getElementParent(element),false)
			local _,temp_h = guiGetSize(element,false)
			py = py + (parent_temp_h - temp_h)
		end
		
		-- only the position needs to be stacked so get the sum of the offset pixel positions of every element from the initial element up until the child of the screen
		while DoesElementHaveGUIParent(element)==true do
			element = getElementParent(element)
			local temp_px,temp_py = guiGetPosition(element,false)
			px = px + temp_px
			py = py + temp_py
			
			if getElementType(element)=="gui-tab" and #getElementChildren(getElementParent(element))>1 then
				local _,parent_temp_h = guiGetSize(getElementParent(element),false)
				local _,temp_h = guiGetSize(element,false)
				py = py + (parent_temp_h - temp_h)		
			end
		end
		
		-- the width/height in pixels, the x/y in pixels from 0,0
		return px,py,pw,ph
	end
	return nil
end


function StartEditing()
	if gui_editor==false then
		gui_editor = true
		showCursor(true,true)
		toggleAllControls(false,true,false)
		SetInstruction("Right click to begin - /guihelp for feature details")
		
		loadSettingsFile()
		
		if settings.guieditor_update_check.value then
			checking_updates = true
			triggerServerEvent("checkUpdateStatus",getLocalPlayer(),false)
		end
		
		if not settings.guieditor_tutorial_completed.value then
			showTutorialPrompt(false)
		end
		
		if tonumber(settings.guieditor_tutorial_version.value) < tonumber(current_tutorial_version) then
			showTutorialPrompt(false,true)
		end
		
	else
		gui_editor = false
		showCursor(false,false)
		toggleAllControls(true,true,true)
		
		saveSettingsFile()
		
		if guieditor_tutorial then
			stopTutorial()
		end
		
		SetInstruction("")
	end
end
addCommandHandler("guied",StartEditing)
addCommandHandler("guiedit",StartEditing)
addCommandHandler("guieditor",StartEditing)


addEventHandler("onClientResourceStop",resourceRoot,function()
	if gui_editor then StartEditing() end
end)


function DoesElementHaveGUIParent(element)
	if element then
		local element_parent = getElementParent(element)
		if element_parent then
			local type = getElementType(element_parent)
			if type then
				-- does it a parent gui element
				if type:find('gui-...') and type~="guiroot" then 
					-- yes
					return true
				else
					-- no
					return false
				end
			else
				-- not an element
				return false
			end
		else
			-- doesnt have a parent
			return false
		end
		-- should never happen
		return false
	end
	return false
end


function ShowBorder(element)
	if element and isElement(element) then
		local x,y,w,h = 0,0,0,0

		x,y,w,h = GetAbsolutePositionAndSizeOfElement(element)
			
		guiSetPosition(border_top,x,y,false)
		guiSetSize(border_top,w,border_thickness,false)
		guiSetPosition(border_bottom,x,y+h,false)
		guiSetSize(border_bottom,w+border_thickness,border_thickness,false)
			
		guiSetPosition(border_left,x,y,false)
		guiSetSize(border_left,border_thickness,h,false)
		guiSetPosition(border_right,x+w,y,false)
		guiSetSize(border_right,border_thickness,h+border_thickness,false)				
			
		guiSetVisible(border_top,true)
		guiSetVisible(border_bottom,true)
		guiSetVisible(border_left,true)
		guiSetVisible(border_right,true)
		guiBringToFront(border_top)
		guiBringToFront(border_bottom)
		guiBringToFront(border_left)
		guiBringToFront(border_right)
	else
		outputDebugString("GUI Editor error: attempt to draw border for non-existant element.")
	end
end


function HideBorder()
	guiSetVisible(border_top,false)
	guiSetVisible(border_bottom,false)
	guiSetVisible(border_left,false)
	guiSetVisible(border_right,false)
end


function GetFontFromID(id)
	if id==1 then return "default-normal"
	elseif id==2 then return "default-small"
	elseif id==3 then return "default-bold-small"
	elseif id==4 then return "clear-normal"
	elseif id==5 then return "sa-header"
	elseif id==6 then return "sa-gothic"
	end
end


function GetIDFromType(type)
	if type=="gui-window" then return 2
	elseif type=="gui-button" then return 3
	elseif type=="gui-memo" then return 4
	elseif type=="gui-label" then return 5
	elseif type=="gui-checkbox" then return 6
	elseif type=="gui-edit" then return 7
	elseif type=="gui-gridlist" then return 8
	elseif type=="gui-progressbar" then return 9
	elseif type=="gui-tabpanel" then return 10
	elseif type=="gui-tab" then return 11
	elseif type=="gui-radiobutton" then return 12
	elseif type=="gui-staticimage" then return 13
	elseif type=="gui-scrollpane" then return 14
	elseif type=="gui-scrollbar" then return 15
	else return 1
	end
end


function ShowImageList(table_)
	if table_==nil then
		triggerServerEvent("ServerLoadImageTable",getLocalPlayer())
	else
		for i=0, guiGridListGetRowCount(image_gridlist)+1 do
			local del = guiGridListRemoveRow(image_gridlist,0)
		end
		
		for _,v in ipairs(table_) do
			local row = guiGridListAddRow(image_gridlist)
			guiGridListSetItemText(image_gridlist,row,1,v,false,false)
		end
		guiGridListAutoSizeColumn(image_gridlist,1)
		guiSetVisible(image_window,true)
		guiBringToFront(image_window)
	end
end
addEvent("ClientReceiveImageTable",true)
addEventHandler("ClientReceiveImageTable",getRootElement(),ShowImageList)


function ExitImageList()
	guiSetVisible(image_window,false)
	creating = nil
end


function AcceptImageList()
	local row,col = guiGridListGetSelectedItem(image_gridlist)
	if row and row~=-1 then
		local text = guiGridListGetItemText(image_gridlist,row,1)
		guiSetVisible(image_window,false)
		LoadImage(text)
	end
end


function LoadImage(dir)
	image_dir = dir
	if creating == "pre_pre_image" then
		creating = "pre_image"
	elseif creating == "dx_pre_pre_image" then
		creating = "dx_pre_image"
	end
	SetInstruction("Click and drag to create and size your image")
end


function ShowImageHelp()
	guiSetVisible(image_help_window,true)
	guiBringToFront(image_help_window)
end


function HideImageHelp()
	guiSetVisible(image_help_window,false)
end


function SetInstruction(text)
	if instruction_text and isElement(instruction_text) then
		if guieditor_tutorial then return end
		guiSetText(instruction_text,text)
	end
end


function showInfoWindow()
	guiSetText(guieditorVersionLabel,"GUI Editor Version "..tostring(guieditor_version))
	
	guiCheckBoxSetSelected(guieditorUpdateCheckbox,settings.guieditor_update_check.value)
	
	guiSetVisible(guieditorInfoWindow,true)
	
	guiBringToFront(guieditorInfoWindow)
end


function hideInfoWindow()
	guiSetVisible(guieditorInfoWindow,false)
	
	settings.guieditor_update_check.value = guiCheckBoxGetSelected(guieditorUpdateCheckbox)
	saveSettingsFile()
end


addEvent("receiveUpdateCheck",true)
addEventHandler("receiveUpdateCheck",root,function(update,newVersion,oldVersion,manual)
	if checking_updates then
		if update then
			guiSetText(guieditorUpdateLabel,"An update is available! (v. "..tostring(newVersion)..")")
			if manual == false then
				if not guieditor_version then guieditor_version = oldVersion end
				showInfoWindow()
			end
		elseif update == false then
			guiSetText(guieditorUpdateLabel,"No updates available")
		else
			guiSetText(guieditorUpdateLabel,"Error: Check ACL permissions and MTA website availability.")
		end
	end
end)