--[[ GUI Editor - Sizing and Positioning - Client ]]--

local loose_manipulation = false

divider_element = nil
dividing_count = false
local dividers = {}
local divider_thickness = 2
local divider_height = 10


addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()
	bindKey("lshift","down",function () 
		loose_manipulation = true
	end)
	bindKey("lshift","up",function () 
		loose_manipulation = false 
	end)
		
	bindKey("rshift","down",function () 
		loose_manipulation = true
	end)
	bindKey("rshift","up",function () 
		loose_manipulation = false 
	end)
end)




-- updates the position of the selected gui element on render
function UpdateCurrentGUIElementPosition()
	if creating~=nil then	
		local mX,mY = getCursorPosition()
		local sX,sY = guiGetScreenSize()
		-- when the cursor is off the screen (such as in window mode) x is nil
		if sX and mX then 
			sX = mX*sX
			sY = mY*sY
			
			if dividing_count then 
				local closest = {9999}
				
				for i,divider in ipairs(dividers) do
					if divider and i ~= 1 and i ~= 2 and i ~= #dividers then
						local dX,dY = guiGetPosition(divider,true)
						local dist = getDistanceBetweenPoints2D(dX,dY,mX,mY)
						
						if dist < closest[1] then
							closest[1] = dist
							closest[2] = i
						end
					end
				end
				
				if closest[2] then
					local dX,_ = guiGetPosition(dividers[closest[2]],false)

					if captured then
						for i,capture in ipairs(captured_elements) do
							local local_dX = dX
							if DoesElementHaveGUIParent(capture) then
								local_dX = local_dX - GetAbsolutePositionAndSizeOfElement(getElementParent(capture))
							end
							
							local eWidth,_ = guiGetSize(capture,false)
							local _,eY = guiGetPosition(capture,false)

							guiSetPosition(capture,(local_dX-(eWidth/2))-captured_move_offset_x[i],eY,false)
						end
					
					else
						if DoesElementHaveGUIParent(move) then
							dX = dX - GetAbsolutePositionAndSizeOfElement(getElementParent(move))
						end
						
						local eWidth,_ = guiGetSize(move,false)
						local _,eY = guiGetPosition(move,false)

						guiSetPosition(move,dX-(eWidth/2),eY,false)
						
						local type = getElementType(move)
						if type=="gui-label" or type=="gui-checkbox" or type=="gui-radiobutton" then
							ShowBorder(move)
						end							
					end
				end
				return 
			end
			
			if captured==true then
				for i,capture in ipairs(captured_elements) do
					local pX,pY,pWidth,pHeight = 0,0,sx,sy
					if DoesElementHaveGUIParent(capture) then
						pX,pY,pWidth,pHeight = GetAbsolutePositionAndSizeOfElement(getElementParent(capture))
					end
					
					local x_,y_
					local w,h = guiGetSize(capture,false)
					x_ = sX-pX-captured_move_offset_x[i]
					y_ = sY-pY-captured_move_offset_y[i]
					
					if creating=="move_y" then				
						x_,_ = guiGetPosition(capture,false)
					end
							
					if creating=="move_x" then
						_,y_ = guiGetPosition(capture,false)
					end								
					
					-- if its within the bounds of its parent
					if not loose_manipulation and (x_>=0 and x_+w<=pWidth and y_>=0 and y_+h<=pHeight) then
						guiSetPosition(capture,x_,y_,false)						
					elseif loose_manipulation then
						guiSetPosition(capture,x_,y_,false)	
					end							
				end
			else
				local pX,pY,pWidth,pHeight = 0,0,sx,sy
				if DoesElementHaveGUIParent(move) then
					pX,pY,pWidth,pHeight = GetAbsolutePositionAndSizeOfElement(getElementParent(move))
				end
				
				local x_,y_
				local w,h = guiGetSize(move,false)
				x_ = sX-pX-move_offset_x
				y_ = sY-pY-move_offset_y			
				
				-------------------------------------------------------------------------------
				if settings.snapping.value and not loose_manipulation then
					-- track other elements on the same 'plane'
					
					local nearx,neary = calculateSnaps(move,x_,y_,w,h,pX,pY)
					local type = getElementType(move)
					
					if nearx[2] ~= 9999 or neary[2] ~= 9999 then
						if nearx[2] <= settings.snapping_precision.value and neary[2] <= settings.snapping_precision.value then
							x_,y_ = x_-nearx[2],y_-neary[2]
						elseif nearx[2] <= settings.snapping_precision.value and neary[2] > settings.snapping_precision.value then
							x_ = x_-nearx[2]
						elseif nearx[2] > settings.snapping_precision.value and neary[2] <= settings.snapping_precision.value then
							y_ = y_-neary[2]
						end				
					end
				end
				-------------------------------------------------------------------------------
				
				if creating=="move_y" then				
					x_,_ = guiGetPosition(move,false)
				end
						
				if creating=="move_x" then
					_,y_ = guiGetPosition(move,false)
				end					
				
				-- if its within the bounds of its parent
				if not loose_manipulation and (x_>=0 and x_+w<=pWidth and y_>=0 and y_+h<=pHeight) then
					guiSetPosition(move,x_,y_,false)
				elseif loose_manipulation then
					guiSetPosition(move,x_,y_,false)
				end
										
				local type = getElementType(move)
				if type=="gui-label" or type=="gui-checkbox" or type=="gui-radiobutton" then
					ShowBorder(move)
				end	
			end
		end
	end
end

			--[[		if getElementData(move,"modify_menu") == (dx_options + 1) then
						dx_attributes[move].sx = x_
						dx_attributes[move].sy = y_
						dx_attributes[move].ex = x_+w
						dx_attributes[move].ey = y_+h						
					end		]]	


-- updates the size of the selected gui element on render
function UpdateGUIElementSize(element)
	if creating~=nil then
		local mx,my,wx,wy,wz = getCursorPosition()
		local sX,sY = guiGetScreenSize()
		-- sX and sY are the absolute cursor position
		sX = mx*sX
		sY = my*sY
		
		-- when the cursor is off the screen (such as in window mode) x is nil so we have to check
		if sX and sY and element then		
			if captured then
				for i,capture in ipairs(captured_elements) do	
					if getElementData(capture,"modify_menu",false) == (dx_options + 1) then 
						clicked_mx = dx_attributes[capture].sx
						clicked_my = dx_attributes[capture].sy
						
						local width,height = false,false
						if creating == "resize_width" then width = true elseif creating == "resize_height" then height = true end
						
						UpdateOmnidirectionalSize("dx_line",width,height)
					else
						local eX,eY,eWidth,eHeight = 0,0,sX/mx,sY/my
						
						if DoesElementHaveGUIParent(capture)==true then
							eX,eY = GetAbsolutePositionAndSizeOfElement(capture)	
							eWidth,eHeight = guiGetSize(getElementParent(capture),false)
						else
							eX,eY = GetAbsolutePositionAndSizeOfElement(capture)
						end
						
						local width_,height_ = math.abs(sX-eX)-captured_move_offset_x[i],math.abs(sY-eY)-captured_move_offset_y[i]

						if creating=="resize_height" then				
							width_,_ = guiGetSize(capture,false)
						end
							
						if creating=="resize_width" then
							_,height_ = guiGetSize(capture,false)
						end
						
						eX,eY = guiGetPosition(capture,false)
						
						-- if its within the bounds of its parent
						if (not loose_manipulation) and eX+width_<=eWidth and eY+height_<=eHeight then
							-- limit the smallest possible size to min_size
							width_ = width_ < min_size[1] and min_size[1] or width_
							height_ = height_ < min_size[2] and min_size[2] or height_
							guiSetSize(capture,width_,height_,false)
						elseif loose_manipulation then
							width_ = width_ < min_size[1] and min_size[1] or width_
							height_ = height_ < min_size[2] and min_size[2] or height_			
							guiSetSize(capture,width_,height_,false)
						end		
					end
				end			
			else
				local eX,eY,eWidth,eHeight = 0,0,sX/mx,sY/my
				
				if DoesElementHaveGUIParent(element)==true then
					eX,eY = GetAbsolutePositionAndSizeOfElement(element)	
					eWidth,eHeight = guiGetSize(getElementParent(element),false)
				else
					eX,eY = GetAbsolutePositionAndSizeOfElement(element)
				end
				
				local width_,height_ = math.abs(sX-eX),math.abs(sY-eY)
				
				eX,eY = guiGetPosition(element,false)
				
				-------------------------------------------------------------------------------
				if settings.snapping.value and not loose_manipulation then
					-- track other elements on the same 'plane'
					local pX,pY = 0,0
					if DoesElementHaveGUIParent(element)==true then
						pX,pY = GetAbsolutePositionAndSizeOfElement(getElementParent(element))
					end
					local nearx,neary = calculateSnaps(element,eX,eY,width_,height_,pX,pY)
					local type = getElementType(element)
					
					if nearx[2] ~= 9999 or neary[2] ~= 9999 then
						if nearx[2] <= settings.snapping_precision.value and neary[2] <= settings.snapping_precision.value then
							width_, height_ = width_-nearx[2], height_-neary[2]
						elseif nearx[2] <= settings.snapping_precision.value and neary[2] > settings.snapping_precision.value then
							width_ = width_-nearx[2]
						elseif nearx[2] > settings.snapping_precision.value and neary[2] <= settings.snapping_precision.value then
							height_ = height_-neary[2]
						end					
					end	
				end
				-------------------------------------------------------------------------------		

				if creating=="resize_height" then
					width_,_ = guiGetSize(element,false)
				end
					
				if creating=="resize_width" then
					_,height_ = guiGetSize(element,false)
				end
				
				--outputDebugString(string.format("sizing "..getElementType(element)..": %.2f %.2f (%.1f %.1f) [%.1f %.1f]", width_, height_, eX, eY, eWidth, eHeight))
				
				-- if its within the bounds of its parent
				if (not loose_manipulation) and eX+width_<=eWidth and eY+height_<=eHeight then
					-- limit the smallest possible size to min_size
					width_ = width_ < min_size[1] and min_size[1] or width_
					height_ = height_ < min_size[2] and min_size[2] or height_
					guiSetSize(element,width_,height_,false)
				elseif loose_manipulation then
					width_ = width_ < min_size[1] and min_size[1] or width_
					height_ = height_ < min_size[2] and min_size[2] or height_			
					guiSetSize(element,width_,height_,false)
				end
					
				local type = getElementType(element)
				if type=="gui-label" or type=="gui-checkbox" or type=="gui-radiobutton" then
					ShowBorder(element)
				end		
			end
		end
	end
end


function UpdateOmnidirectionalSize(type,resizeWidth,resizeHeight)
	local current_mx, current_my = getCursorPosition()
	local x,y = guiGetScreenSize()
	current_mx = current_mx * x
	current_my = current_my * y
	
	if type == "dx_line" then
		if not resizeHeight then
			dx_attributes[GUIEditor_Label[label_count-1]].ex = current_mx
		end
		
		if not resizeWidth then
			dx_attributes[GUIEditor_Label[label_count-1]].ey = current_my
		end
	end	
end



function divideElement(direction)
	if not dividing_count then dividing_count = 1 end
	
	dividing_count = dividing_count + direction

	if dividing_count <= 1 then 
		hideElementDivide()
		dividing_count = false
	else
		drawElementDivide((DoesElementHaveGUIParent(divider_element) and getElementParent(divider_element) or "Screen"))
	end
end



function drawElementDivide(element)
	if element then
		if not dividing_count then dividing_count = 1 end
		
		if #dividers < dividing_count+2 then
			for i=1, dividing_count+2, 1 do
				if not dividers[i] then
					loadDivider(i)
				end
			end
		end
		
		if #dividers > dividing_count+2 then
			for i=#dividers, dividing_count+3, -1 do
				if dividers[i] then
					unloadDivider(i)
				end
			end
		end
		
		local eX,eY,eWidth,eHeight
		
		if element == "Screen" then
			eX,eY = 0,0
			eWidth,eHeight = guiGetScreenSize()
		else			
			eX,eY,eWidth,eHeight = GetAbsolutePositionAndSizeOfElement(element)
		end
		
		local dWidth = eWidth/dividing_count
		
		for i,divider in ipairs(dividers) do
			if i == 1 then
				guiSetPosition(divider,eX,eY+eHeight,false)
				guiSetSize(divider,eWidth,divider_thickness,false)
			else
				guiSetPosition(divider,eX+dWidth*(i-2),eY+eHeight-divider_height,false)
				guiSetSize(divider,divider_thickness,divider_height,false)
			end
		end
	end
end


function loadDivider(index)
	if not dividers[index] then
		dividers[index] = guiCreateStaticImage(0,0,divider_thickness,10,"red_dot.png",false)
		guiSetAlpha(dividers[index],1)
	end
end

function unloadDivider(index)
	if dividers[index] then
		destroyElement(dividers[index])
		dividers[index] = nil
	end
end


function hideElementDivide()
	for i,divider in ipairs(dividers) do
		destroyElement(divider)
		dividers[i] = nil
	end
end



function calculateSnaps(move,x_,y_,w,h,pX,pY)
	local nearx,neary = {0,9999},{0,9999}
	local near = {}
				
	for _,gui in ipairs(getElementChildren(getElementParent(move))) do
		if gui and guiGetVisible(gui) and getElementData(gui,"guieditor_varname",false) and gui ~= move then
			local trackX,trackY = guiGetPosition(gui,false)
			local trackW,trackH = guiGetSize(gui,false)
							
			local ax,ay,aw,ah = GetAbsolutePositionAndSizeOfElement(gui)

			local xdiff = x_-trackX

			-- if any point on the move element is within influence distance of this gui element on the y axis
			if (y_ >= (trackY+settings.snapping_influence.value) and y_ <= (trackY+trackH+settings.snapping_influence.value)) or ((y_+h) >= (trackY-settings.snapping_influence.value) and (y_+h) <= (trackY+trackH+settings.snapping_influence.value)) then
				-- if the x side of the move element is within precision distance of this gui elements x side
				if math.abs(xdiff) <= settings.snapping_precision.value then
					table.insert(near,{1,xdiff,gui,ax,ay,aw,ah})
				-- if the x side of the move element is within precision distance of this gui element x+w side			
				elseif math.abs(xdiff-trackW) <= settings.snapping_precision.value then
					table.insert(near,{1,xdiff-trackW,gui,ax,ay,aw,ah})											
				end
								
				-- if the x+w move side is within precision of the gui elements x side
				if math.abs(xdiff+w) <= settings.snapping_precision.value then
					table.insert(near,{2,(x_+w)-trackX,gui,ax,ay,aw,ah})
				-- if the x+w move side is within precision of the gui elements x+w side
				elseif math.abs(xdiff+w-trackW) <= settings.snapping_precision.value then
					table.insert(near,{2,(x_+w)-(trackX+trackW),gui,ax,ay,aw,ah})
				end								
							
				-- if any point on the move element is within distance of this gui element on the y axis (ignoring influence range)
				if (y_ >= (trackY) and y_ <= (trackY+trackH)) or ((y_+h) >= (trackY) and (y_+h) <= (trackY+trackH)) or
					((trackY >= y_ and trackY <= y_+h) or ((trackY+trackH) >= y_ and (trackY+trackH) <= y_+h)) then
					-- if the x side of the move element is within precision distance of the recommended distance of this gui element x+w side			
					if math.abs(xdiff-trackW-settings.snapping_recommended.value) <= settings.snapping_precision.value then
						loadInternalDXDrawing("dx_line",trackX+trackW+settings.snapping_recommended.value+pX,y_+(h/2)+pY,trackX+trackW+pX,y_+(h/2)+pY,255,70,0,255,1,true,true)	
						table.insert(near,{1,xdiff-trackW-settings.snapping_recommended.value,gui,ax,ay,aw,ah})
					end
								
					-- if the x+w move side is within precision of the recommended distance of this gui elements x+w side
					if math.abs(xdiff+w+settings.snapping_recommended.value) <= settings.snapping_precision.value then
						loadInternalDXDrawing("dx_line",trackX-settings.snapping_recommended.value+pX,y_+(h/2)+pY,trackX+pX,y_+(h/2)+pY,255,70,0,255,1,true,true)
						table.insert(near,{2,xdiff+w+settings.snapping_recommended.value,gui,ax,ay,aw,ah})
					end									
				end																																		
			end
							
			local ydiff = y_-trackY
							
			if (x_ >= (trackX-settings.snapping_influence.value) and x_ <= (trackX+trackW+settings.snapping_influence.value)) or ((x_+w) >= (trackX-settings.snapping_influence.value) and (x_+w) <= (trackX+trackW+settings.snapping_influence.value)) then
				-- if the y side of the move element is within precision distance of this gui elements y side
				if math.abs(ydiff) <= settings.snapping_precision.value then
					table.insert(near,{3,ydiff,gui,ax,ay,aw,ah})
				-- if the y side of the move element is within precision distance of this gui element y+h side			
				elseif math.abs(ydiff-trackH) <= settings.snapping_precision.value then
					table.insert(near,{3,ydiff-trackH,gui,ax,ay,aw,ah})
				end
								
				-- if the y+h move side is within precision of the gui elements y side
				if math.abs(ydiff+h) <= settings.snapping_precision.value then
					table.insert(near,{4,(y_+h)-trackY,gui,ax,ay,aw,ah})
				-- if the y+h move side is within precision of the gui elements y+h side
				elseif math.abs(ydiff+h-trackH) <= settings.snapping_precision.value then
					table.insert(near,{4,(y_+h)-(trackY+trackH),gui,ax,ay,aw,ah})
				end								
								
				-- if any point on the move element is within distance of this gui element on the x axis (ignoring influence range)
				if ((x_ >= (trackX) and x_ <= (trackX+trackW)) or ((x_+w) >= (trackX) and (x_+w) <= (trackX+trackW))) or
					((trackX >= x_ and trackX <= x_+w) or ((trackX+trackW) >= x_ and (trackX+trackW) <= x_+w)) then
					-- if the y side of the move element is within precision distance of the recommended distance of this gui element y+h side
					if math.abs(ydiff-trackH-settings.snapping_recommended.value) <= settings.snapping_precision.value then
						loadInternalDXDrawing("dx_line",x_+(w/2)+pX,trackY+trackH+settings.snapping_recommended.value+pY,x_+(w/2)+pX,trackY+trackH+pY,255,70,0,255,1,true,true)	
						table.insert(near,{3,ydiff-trackH-settings.snapping_recommended.value,gui,ax,ay,aw,ah})
					end
									
					-- if the y+h move side is within precision of the recommended distance of this gui elements y+h side
					if math.abs(ydiff+h+settings.snapping_recommended.value) <= settings.snapping_precision.value then
						loadInternalDXDrawing("dx_line",x_+(w/2)+pX,trackY-settings.snapping_recommended.value+pY,x_+(w/2)+pX,trackY+pY,255,70,0,255,1,true,true)
						table.insert(near,{4,ydiff+h+settings.snapping_recommended.value,gui,ax,ay,aw,ah})
					end									
				end																	
			end		
		end
	end
					
	for i,v in ipairs(near) do
		if v[1] <= 2 then
			if v[2] < nearx[2] and v[2] ~= 0 then 
				nearx = v	
			end
			if v[2] <= settings.snapping_precision.value then
				if v[1] == 1 then 
					loadInternalDXDrawing("dx_line",x_-v[2]+pX,y_+(h/2)+pY,x_-v[2]+pX,v[5]+(v[7]/2),255,70,0,255,1,true,true)
				else
					loadInternalDXDrawing("dx_line",x_+w-v[2]+pX,y_+(h/2)+pY,x_+w-v[2]+pX,v[5]+(v[7]/2),255,70,0,255,1,true,true)
				end
			end							
		else
			if v[2] < neary[2] and v[2] ~= 0 then 
				neary = v
			end
			if v[2] <= settings.snapping_precision.value then
				if v[1] == 3 then 
					loadInternalDXDrawing("dx_line",x_+(w/2)+pX,y_-v[2]+pY,v[4]+(v[6]/2),y_-v[2]+pY,255,70,0,255,1,true,true)
				else
					loadInternalDXDrawing("dx_line",x_+(w/2)+pX,y_+h-v[2]+pY,v[4]+(v[6]/2),y_+h-v[2]+pY,255,70,0,255,1,true,true)
				end		
			end
		end						
	end
	return nearx,neary				
end