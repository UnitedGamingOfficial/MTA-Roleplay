--[[ GUI Editor - Multiple Element Selection - Client ]]--


clicked_mx, clicked_my, clicked_element = nil,nil,nil

-- true if controlling multiple elements having just dragged a box and selected
captured = false
captured_elements = {}
captured_move_offset_x, captured_move_offset_y = {},{}

gui_element_names = {
"gui-window",
"gui-button",
"gui-label",
"gui-checkbox",
"gui-memo",
"gui-edit",
"gui-gridlist",
"gui-progressbar",
"gui-tabpanel",
"gui-tab",
"gui-radiobutton",
"gui-staticimage",
"gui-scrollpane",
"gui-scrollbar"
}


addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()

	drag_box_left = guiCreateStaticImage(0,0,border_thickness,10,"blue_dot.png",false)
	drag_box_right = guiCreateStaticImage(0,0,border_thickness,10,"blue_dot.png",false)
	drag_box_top = guiCreateStaticImage(0,0,10,border_thickness,"blue_dot.png",false)
	drag_box_bottom = guiCreateStaticImage(0,0,10,border_thickness,"blue_dot.png",false)
	guiSetVisible(drag_box_left,false)
	guiSetVisible(drag_box_right,false)
	guiSetVisible(drag_box_top,false)
	guiSetVisible(drag_box_bottom,false)

end)


-- wrap this function to fix not being able to 'return' back to here from the trigger
-- no longer needed as of 1.0.1
-------------------------------------------------------------------------------------------]]
--[[
function SelectGUIElements(state,absx,absy)
	if state == "up" then
		GetGUIElementsWithinBox(absx,absy)
	elseif state == "down" then
		SelectGUIElements2(state,absx,absy)
	end
end
]]
-------------------------------------------------------------------------------------------]]


function SelectGUIElements(state,absx,absy)
	if state=="up" then
		local gui_elements = GetGUIElementsWithinBox(absx,absy)
			
		outputChatBox(#gui_elements.." GUI element(s) selected")
			
		clicked_mx = nil
		clicked_my = nil
		clicked_element = nil	
		removeEventHandler("onClientRender",root,UpdateDragBox)		
		captured = true			
		captured_elements = gui_elements
		SetInstruction("Right click to perform an action on all your selected GUI elements. Left click to cancel.")
	elseif state=="down" then
		clicked_element = current_cursor_element
		captured = false
		showDragBox(absx,absy)
	end
end


function showDragBox(absx,absy)
	clicked_mx = absx
	clicked_my = absy
	addEventHandler("onClientRender",root,UpdateDragBox)
end


-- again, we wrap this function and perform magic
-- no longer needed as of 1.0.1
-------------------------------------------------------------------------------------------]]
--[[
function GetGUIElementsWithinBox(current_mx,current_my)
	triggerServerEvent("GetResourcesForOutput",getLocalPlayer(),current_mx,current_my)
end
]]
-- see code_output_c.lua for the recieving function triggered from the server
-------------------------------------------------------------------------------------------]]


function GetGUIElementsWithinBox(current_mx,current_my)
	local gui_elements,gui_elements_captured = {},{}
	local gui_elements_captured = {}
	
	-- put all existing gui elements into gui_elements	
	for _,v in ipairs(gui_element_names) do
		-- ignore these, only catch their ghost
		if v ~= "gui-scrollpane" and v ~= "gui-scrollbar" then
			for _,gui_element in ipairs(getElementsByType(v)) do
				table.insert(gui_elements,gui_element)
			end
		end
	end
	
	if #gui_elements>0 then
		for _,gui_element in pairs(gui_elements) do
			-- same parent, dont want to mix elements from different planes
			if not getElementData(gui_element,"cant_edit",false) and ((clicked_element==nil and DoesElementHaveGUIParent(gui_element)==false) or getElementParent(gui_element)==clicked_element) then
				--local x,y = guiGetPosition(gui_element,false)
				local x,y = GetAbsolutePositionAndSizeOfElement(gui_element)
				if x and y then
					-- if its within the box
					if (((x>clicked_mx and x<current_mx) or (x>current_mx and x<clicked_mx)) and ((y>clicked_my and y<current_my) or (y>current_my and y<clicked_my))) then
						-- do not want to count hidden elements
						if guiGetVisible(gui_element)==true then
							table.insert(gui_elements_captured,gui_element)
						end
					end
				end
			end
		end
	else
		--outputChatBox("GUIEditor Error: unable to find any gui elements") 
	end
	
	return gui_elements_captured
--	SelectGUIElements2("up",current_mx,current_my,gui_elements_captured)
end

function UpdateDragBox()
	if clicked_mx and clicked_my then
		-- returns relative values
		local current_mx, current_my = getCursorPosition()
		local x,y = guiGetScreenSize()
		local unknown = false
		current_mx = current_mx * x
		current_my = current_my * y
		local w = math.abs(current_mx - clicked_mx)
		local h = math.abs(current_my - clicked_my)
		
		-- figure out which direction the box was dragged in, the centre point being clicked_mx,clicked_my
		-- top right
		if clicked_mx<=current_mx and clicked_my>current_my then
			--outputChatBox("top right ("..clicked_mx..","..clicked_my..") ["..current_mx..","..current_my.."]")
			guiSetPosition(drag_box_left,clicked_mx,current_my,false)
			guiSetPosition(drag_box_right,current_mx,current_my,false)
			guiSetPosition(drag_box_top,clicked_mx,current_my,false)
			guiSetPosition(drag_box_bottom,clicked_mx,clicked_my,false)				
		-- bottom right
		elseif clicked_mx<current_mx and clicked_my<=current_my then
			--outputChatBox("bottom right ("..clicked_mx..","..clicked_my..") ["..current_mx..","..current_my.."]")
			guiSetPosition(drag_box_left,clicked_mx,clicked_my,false)
			guiSetPosition(drag_box_right,current_mx,clicked_my,false)
			guiSetPosition(drag_box_top,clicked_mx,clicked_my,false)
			guiSetPosition(drag_box_bottom,clicked_mx,current_my,false)				
		-- top left
		elseif clicked_mx>current_mx and clicked_my>=current_my then
			--outputChatBox("top left ("..clicked_mx..","..clicked_my..") ["..current_mx..","..current_my.."]")
			guiSetPosition(drag_box_left,current_mx,current_my,false)
			guiSetPosition(drag_box_right,clicked_mx,current_my,false)
			guiSetPosition(drag_box_top,current_mx,current_my,false)
			guiSetPosition(drag_box_bottom,current_mx,clicked_my,false)		
		-- bottom left
		elseif clicked_mx>=current_mx and clicked_my<current_my then
			-- outputChatBox("bottom left ("..clicked_mx..","..clicked_my..") ["..current_mx..","..current_my.."]")
			guiSetPosition(drag_box_left,current_mx,clicked_my,false)
			guiSetPosition(drag_box_right,clicked_mx,clicked_my,false)
			guiSetPosition(drag_box_top,current_mx,clicked_my,false)
			guiSetPosition(drag_box_bottom,current_mx,current_my,false)			
		-- unknown, fail gracefully
		else
			unknown = true
			HideDragBox()		
		end
		
		if unknown == false then
			guiSetSize(drag_box_left,border_thickness,h,false)
			guiSetSize(drag_box_right,border_thickness,h,false)
			guiSetSize(drag_box_top,w,border_thickness,false)
			guiSetSize(drag_box_bottom,w,border_thickness,false)			
				
			guiSetVisible(drag_box_left,true)
			guiSetVisible(drag_box_right,true)
			guiSetVisible(drag_box_top,true)
			guiSetVisible(drag_box_bottom,true)
			guiBringToFront(drag_box_left)
			guiBringToFront(drag_box_right)
			guiBringToFront(drag_box_top)
			guiBringToFront(drag_box_bottom)
		end
	end
end

function HideDragBox()
	guiSetVisible(drag_box_left,false)
	guiSetVisible(drag_box_right,false)
	guiSetVisible(drag_box_top,false)
	guiSetVisible(drag_box_bottom,false)
end
