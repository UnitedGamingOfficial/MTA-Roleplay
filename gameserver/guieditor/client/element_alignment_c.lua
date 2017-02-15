--[[ GUI Editor - Element Alignment - Client ]]--

vert_control, horiz_control = false,false
local control_x,
	control_y,
	control_width,
	control_height,
	vert_left_control_element,
	vert_right_control_element,
	horiz_top_control_element,
	horiz_bottom_control_element

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()	
	bindKey("lctrl","down",function () 
		vert_control = true
		creating = nil
		cancel = false
	end)
	bindKey("lctrl","up",function () 
		vert_control = false 
		control_x = nil
		control_width = nil
		vert_left_control_element = nil
		vert_right_control_element = nil
	end)
		
	bindKey("rctrl","down",function () 
		horiz_control = true
		creating = nil
		cancel = false
	end)
	bindKey("rctrl","up",function () 
		horiz_control = false 
		control_y = nil
		control_height = nil
		horiz_top_control_element = nil
		horiz_bottom_control_element = nil
	end)		
end)
	
function VerticalControl(state,button)
	if state=="up" then
	-- if a gui element is actually being clicked
		if current_cursor_element then
			local x,y = guiGetPosition(current_cursor_element,true)
			-- left alignment
			if button=="left" then
				-- first element clicked (the one the following ones are aligned to)
				if vert_left_control_element==nil then 
					control_x = x
					vert_left_control_element = current_cursor_element
				else	
					-- if they both have the same parent (are both being moved in the same area)
					if getElementParent(vert_left_control_element)==getElementParent(current_cursor_element) then
						guiSetPosition(current_cursor_element,control_x,y,true)
					end
				end
			-- right alignment
			elseif button=="right" then
				local w,h = guiGetSize(current_cursor_element,true)
					
				if vert_right_control_element==nil then
					control_x = x
					control_width = w
					vert_right_control_element = current_cursor_element
				else
					
					if getElementParent(vert_right_control_element)==getElementParent(current_cursor_element) then
						guiSetPosition(current_cursor_element,(control_x+control_width)-w,y,true)
					end
				end
			end
		end
	end
end
	
function HorizontalControl(state,button)
	if state=="up" then
		if current_cursor_element then
			local x,y = guiGetPosition(current_cursor_element,true)
			if button=="left" then
				if horiz_top_control_element==nil then
					control_y = y
					horiz_top_control_element = current_cursor_element
				else
					if getElementParent(horiz_top_control_element)==getElementParent(current_cursor_element) then
						guiSetPosition(current_cursor_element,x,control_y,true)
					end
				end
			elseif button=="right" then
				local w,h = guiGetSize(current_cursor_element,true)
				
				if horiz_bottom_control_element==nil then
					control_y = y
					control_height = h
					horiz_bottom_control_element = current_cursor_element
				else
				
					if getElementParent(horiz_bottom_control_element)==getElementParent(current_cursor_element) then
						guiSetPosition(current_cursor_element,x,(control_y+control_height)-h,true)
					end
				end
			end
		end
	end
end