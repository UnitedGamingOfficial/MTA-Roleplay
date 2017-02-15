--[[ GUI Editor - Drawing - Client/DX ]]--

dx_attributes = {}
dx_ordering = {}
dx_internal = {}


addEventHandler("onClientPreRender",root,function()
	-- loop it backwards because the last dx item to be created is the top
	for i=#dx_ordering, 1, -1 do
		if dx_ordering[i] and dx_attributes[dx_ordering[i]] then
			local drawing = dx_attributes[dx_ordering[i]]
			if drawing.type == "rectangle" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(dx_ordering[i])
				if x then			
					dxDrawRectangle(x,y,w,h,drawing.colour,drawing.postgui)
				end		
			elseif drawing.type == "image" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(dx_ordering[i])
				if x then			
					dxDrawImage(x,y,w,h,drawing.image,drawing.rotation,drawing.rxoffset,drawing.ryoffset,drawing.colour,drawing.postgui)
				end	
			elseif drawing.type == "line" then
				dxDrawLine(drawing.sx,drawing.sy,drawing.ex,drawing.ey,drawing.colour,drawing.width,drawing.postgui)				
			elseif drawing.type == "text" then
				local x,y,w,h = GetAbsolutePositionAndSizeOfElement(dx_ordering[i])
				if x then
					dxDrawText(tostring(drawing.text),x,y,x+w,y+h,drawing.colour,drawing.scale,drawing.font,drawing.halign,drawing.valign,drawing.clip,drawing.wordwrap,drawing.postgui)
				--	outputDebugString(tostring(drawing.text)..","..tostring(drawing.scale)..","..tostring(drawing.font)..","..drawing.halign..","..drawing.valign)
				end	
			end			
		end
	end
	--dxDrawText("text",569.0,400.0,141.0,74.0,"0xFF0000FF",5.0,"default","left","top",false,false,false)
	-- alpha red green (blue not detected), MTA bug, remember to submit report
	
	
	for i,drawing in ipairs(dx_internal) do
		if drawing.type == "line" then
			dxDrawLine(drawing.sx,drawing.sy,drawing.ex,drawing.ey,drawing.colour,drawing.width,drawing.postgui)
			if drawing.destruct then dx_internal[i] = nil end
		end
	end
end)



function loadDXDrawing(type,gui,...)
	if type == "dx_text" then				
		dx_attributes[gui] = {}
		dx_attributes[gui].type = "text"
		dx_attributes[gui].text = ""
		dx_attributes[gui].colour = tocolor(255,255,255,255)
		dx_attributes[gui].scale = 1
		dx_attributes[gui].font = "default"
		dx_attributes[gui].valign = "top"
		dx_attributes[gui].halign = "left"
		dx_attributes[gui].clip = false
		dx_attributes[gui].wordwrap = false
		dx_attributes[gui].postgui = false
		table.insert(dx_ordering,gui)
		setElementData(gui,"guieditor_varname","")
		setElementData(gui,"modify_menu",dx_options)
	elseif type == "dx_line" then
		dx_attributes[gui] = {}
		dx_attributes[gui].type = "line"
		dx_attributes[gui].sx = arg[1] or 0
		dx_attributes[gui].sy = arg[2] or 0
		dx_attributes[gui].ex = arg[3] or 0
		dx_attributes[gui].ey = arg[4] or 0
		dx_attributes[gui].colour = tocolor(255,255,255,255)
		dx_attributes[gui].width = 1
		dx_attributes[gui].postgui = false
		table.insert(dx_ordering,gui)
		addEventHandler("onClientGUIMove",gui,plotCorrectDXPosition)
		addEventHandler("onCleintGUISize",gui,plotCorrectDXPosition)
		setElementData(gui,"guieditor_varname","")
		setElementData(gui,"modify_menu",dx_options + 1)			
	elseif type == "dx_rectangle" then
		dx_attributes[gui] = {}
		dx_attributes[gui].type = "rectangle"
		dx_attributes[gui].colour = tocolor(255,255,255,255)
		dx_attributes[gui].postgui = false
		table.insert(dx_ordering,gui)
		setElementData(gui,"guieditor_varname","")
		setElementData(gui,"modify_menu",dx_options + 2)
	elseif type == "dx_pre_image" then
		dx_attributes[gui] = {}
		dx_attributes[gui].type = "image"
		dx_attributes[gui].image = arg[1]
		dx_attributes[gui].rotation = 0
		dx_attributes[gui].rxoffset = 0
		dx_attributes[gui].ryoffset = 0
		dx_attributes[gui].colour = tocolor(255,255,255,255)
		dx_attributes[gui].postgui = false
		table.insert(dx_ordering,gui)
		setElementData(gui,"guieditor_varname","")
		setElementData(gui,"modify_menu",dx_options + 3)		
		creating = "dx_image"	
	end
end


function getDXNameFromID(id)
	if id == 14 then return "dx_text"
	elseif id == 15 then return "dx_line"
	elseif id == 16 then return "dx_rectangle"
	elseif id == 17 then return "dx_pre_image"
	end
	return ""
end


function copyDXItem(original,copy)
	if original and copy then
		dx_attributes[copy] = {}
		
		for key,value in pairs(dx_attributes[original]) do
			dx_attributes[copy][tostring(key)] = value
		--	outputChatBox("Copying: "..tostring(key).." as "..tostring(value))
		end
		
		setElementData(copy,"modify_menu",getElementData(original,"modify_menu"))
		table.insert(dx_ordering,copy)
		
		if dx_attributes[copy].type == "line" then
			addEventHandler("onClientGUIMove",copy,plotCorrectDXPosition)
			addEventHandler("onCleintGUISize",copy,plotCorrectDXPosition)
		end
	end
end


function removeDXDrawing(gui)
	if dx_attributes[gui].type == "line" then
		removeEventHandler("onClientGUIMove",gui,plotCorrectDXPosition)
		removeEventHandler("onCleintGUISize",gui,plotCorrectDXPosition)
	end

	dx_attributes[gui] = nil
	
	removeOrdering(gui)
end


function removeOrdering(gui)
	local removal = nil
	
	for index,value in pairs(dx_ordering) do
		if value == gui then removal = index end
	end
	
	if removal then
		table.remove(dx_ordering,removal)
	end
end


function moveDXToBack(gui)
	removeOrdering(gui)
	
	table.insert(dx_ordering,gui)
end


function plotCorrectDXPosition(gui)
	if not gui then gui = source end
	
	if gui then
		local x,y,w,h = GetAbsolutePositionAndSizeOfElement(gui)
		
		if dx_attributes[gui].orientation == "tr" then
			dx_attributes[gui].sx = x
			dx_attributes[gui].sy = y+h
			dx_attributes[gui].ex = x+w
			dx_attributes[gui].ey = y
		elseif dx_attributes[gui].orientation == "br" then
			dx_attributes[gui].sx = x
			dx_attributes[gui].sy = y
			dx_attributes[gui].ex = x+w
			dx_attributes[gui].ey = y+h		
		elseif dx_attributes[gui].orientation == "tl" then
			dx_attributes[gui].sx = x+w
			dx_attributes[gui].sy = y+h
			dx_attributes[gui].ex = x
			dx_attributes[gui].ey = y		
		elseif dx_attributes[gui].orientation == "bl" then
			dx_attributes[gui].sx = x+w
			dx_attributes[gui].sy = y
			dx_attributes[gui].ex = x
			dx_attributes[gui].ey = y+h		
	--[[	elseif dx_attributes[gui].orientation == "t" then
			dx_attributes[gui].sx = x+(w/2)
			dx_attributes[gui].sy = y+h
			dx_attributes[gui].ex = x+(w/2)
			dx_attributes[gui].ey = y
		elseif dx_attributes[gui].orientation == "b" then
			dx_attributes[gui].sx = x+(w/2)
			dx_attributes[gui].sy = y
			dx_attributes[gui].ex = x+(w/2)
			dx_attributes[gui].ey = y+h	
		elseif dx_attributes[gui].orientation == "l" then
			dx_attributes[gui].sx = x
			dx_attributes[gui].sy = y+(h/2)
			dx_attributes[gui].ex = x+w
			dx_attributes[gui].ey = y+(h/2)		
		elseif dx_attributes[gui].orientation == "r" then
			dx_attributes[gui].sx = x+w
			dx_attributes[gui].sy = y+(h/2)
			dx_attributes[gui].ex = x
			dx_attributes[gui].ey = y+(h/2)		]]			
		end
	end	
end


function plotCorrectMaskPosition(center_x,center_y,clicked_x,clicked_y,element)
	-- top right
	if center_x<=clicked_x and center_y>clicked_y then
		guiSetPosition(element,center_x,clicked_y,false)
		guiSetSize(element,clicked_x-center_x,center_y-clicked_y,false)
		dx_attributes[element].orientation = "tr"
	-- bottom right
	elseif center_x<clicked_x and center_y<=clicked_y then
		guiSetPosition(element,center_x,center_y,false)
		guiSetSize(element,clicked_x-center_x,clicked_y-center_y,false)
		dx_attributes[element].orientation = "br"		
	-- top left
	elseif center_x>clicked_x and center_y>=clicked_y then
		guiSetPosition(element,clicked_x,clicked_y,false)
		guiSetSize(element,center_x-clicked_x,center_y-clicked_y,false)	
		dx_attributes[element].orientation = "tl"
	-- bottom left
	elseif center_x>=clicked_x and center_y<clicked_y then
		guiSetPosition(element,clicked_x,center_y,false)
		guiSetSize(element,center_x-clicked_x,clicked_y-center_y,false)	
		dx_attributes[element].orientation = "bl"
	-- top
--[[	elseif center_x==clicked_x and center_y>clicked_y then
		guiSetPosition(element,center_x-(math.ceil(min_size[1]/2)),clicked_y,false)
		guiSetSize(element,min_size[1],center_y-clicked_y,false)	
		dx_attributes[element].orientation = "t"		
	-- bottom
	elseif center_x==clicked_x and center_y<clicked_y then
		guiSetPosition(element,center_x-(math.ceil(min_size[1]/2)),center_y,false)
		guiSetSize(element,min_size[1],clicked_y-center_y,false)	
		dx_attributes[element].orientation = "b"		
	-- left
	elseif center_x>clicked_x and center_y==clicked_y then
		guiSetPosition(element,clicked_x,center_y-(math.ceil(min_size[1]/2)),false)
		guiSetSize(element,center_x-clicked_x,min_size[2],false)	
		dx_attributes[element].orientation = "l"		
	-- right
	elseif center_x<clicked_x and center_y==clicked_y then
		guiSetPosition(element,center_x,center_y-(math.ceil(min_size[1]/2)),false)
		guiSetSize(element,clicked_x-center_x,min_size[2],false)	
		dx_attributes[element].orientation = "r"	]]	
	-- fucked
	else
		outputDebugString("GUIEditor Error: plotCorrectMaskPosition failed to determine position.")
	end
						
--	local w,h = guiGetSize(element,false)
--	if w < min_size[1] then w = min_size[1] end
--	if h < min_size[2] then h = min_size[2] end
--	guiSetSize(element,w,h,false)	
end




function loadInternalDXDrawing(type,...)
	
	local index = #dx_internal+1
	
	if type == "dx_line" then
		dx_internal[index] = {}
		
		local args = {...}
		
		dx_internal[index].type = "line"
		dx_internal[index].sx = args[1]
		dx_internal[index].sy = args[2]
		dx_internal[index].ex = args[3]
		dx_internal[index].ey = args[4]
		dx_internal[index].colour = tocolor(args[5],args[6],args[7],args[8])
		dx_internal[index].width = args[9]
		dx_internal[index].postgui = args[10]
		dx_internal[index].destruct = args[11]
		return index
	end
end


function removeInternalDXDrawing(index)
	dx_internal[index] = nil
end



function setDXAttribute(type,gui,new_val)
	if gui then
		if type == "text" then
			dx_attributes[gui].text = new_val
		elseif type == "scale" then
			dx_attributes[gui].scale = new_val		
		elseif type == "font" then
			dx_attributes[gui].font = new_val	
		elseif type == "colour" then
			dx_attributes[gui].colour = new_val
		elseif type == "clip" then
			dx_attributes[gui].clip = new_val	
		elseif type == "width" then
			dx_attributes[gui].width = new_val	
		elseif type == "postgui" then
			dx_attributes[gui].postgui = new_val	
		elseif type == "rotation" then
			dx_attributes[gui].rotation = new_val	
		elseif type == "rxoffset" then
			dx_attributes[gui].rxoffset = new_val	
		elseif type == "ryoffset" then
			dx_attributes[gui].ryoffset = new_val
		elseif type == "valign" then
			dx_attributes[gui].valign = new_val
		elseif type == "halign" then
			dx_attributes[gui].halign = new_val
		elseif type == "width" then
			dx_attributes[gui].width = new_val					
		end
	end	
end


function loadDXString(text)
	local arg = split(text,string.byte(','))
	
	local func = arg[1]
	arg[1] = arg[1]:sub(arg[1]:find("(",1,true)+1)
	
	
	if func:find("dxDrawRectangle") then
		elem = LoadGUIElement(guiCreateLabel(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]),"",false))
					
		guiSetProperty(elem,"ZOrderChangeEnabled","true")	

		loadDXDrawing("dx_rectangle",elem)

		dx_attributes[elem].colour = loadstring("return "..arg[5]..","..arg[6]..","..arg[7]..","..arg[8])()
		
		local s = arg[9]:find(")",1,true)
		if s then arg[9] = arg[9]:sub(1,s-1) end
		dx_attributes[elem].postgui = loadstring("return "..arg[9])()
	elseif func:find("dxDrawLine") then
		elem = LoadGUIElement(guiCreateLabel(0,0,5,5,"",false))
					
		guiSetProperty(elem,"ZOrderChangeEnabled","true")
		
		HideBorder()
					
		setElementData(elem,"cant_highlight",true)

		loadDXDrawing("dx_line",elem,tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]))
		
		plotCorrectMaskPosition(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]),elem)	

		dx_attributes[elem].colour = loadstring("return "..arg[5]..","..arg[6]..","..arg[7]..","..arg[8])()
		dx_attributes[elem].width = tonumber(arg[9])
		
		local s = arg[10]:find(")",1,true)
		if s then arg[10] = arg[10]:sub(1,s-1) end
		dx_attributes[elem].postgui = loadstring("return "..arg[10])()	
	elseif func:find("dxDrawImage") then
		elem = LoadGUIElement(guiCreateLabel(tonumber(arg[1]),tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]),"",false))
					
		guiSetProperty(elem,"ZOrderChangeEnabled","true")	

		arg[5] = arg[5]:sub(2,-2)
		loadDXDrawing("dx_pre_image",elem,arg[5])
		creating = nil
		
		dx_attributes[elem].rotation = tonumber(arg[6])
		dx_attributes[elem].rxoffset = tonumber(arg[7])
		dx_attributes[elem].ryoffset = tonumber(arg[8])	

		dx_attributes[elem].colour = loadstring("return "..arg[9]..","..arg[10]..","..arg[11]..","..arg[12])()
		
		local s = arg[13]:find(")",1,true)
		if s then arg[13] = arg[13]:sub(1,s-1) end
		dx_attributes[elem].postgui = loadstring("return "..arg[13])()	
	elseif func:find("dxDrawText") then
		-- the text has a comma in it
		local t = ""
		if #arg > 16 then
			for i=1, #arg-15 do
				t = t .. "," .. arg[i]
			end
	
			for i= #arg-15, 2, -1 do
				table.remove(arg,i)
			end
		else
			t = arg[1]
		end
		
		arg[1] = t:sub(t:find("\"")+1,-2)
		
		
		elem = LoadGUIElement(guiCreateLabel(tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4]-arg[2]),tonumber(arg[5]-arg[3]),"",false))
					
		guiSetProperty(elem,"ZOrderChangeEnabled","true")	

		loadDXDrawing("dx_text",elem)
		
	--	outputDebugString(tostring(arg[1])..","..tostring(arg[10])..","..tostring(arg[11])..","..tostring(arg[12]:sub(2,-2))..","..tostring(arg[13]:sub(2,-2))..","..tostring(arg[14]))

		dx_attributes[elem].text = arg[1]
		dx_attributes[elem].colour = loadstring("return "..arg[6]..","..arg[7]..","..arg[8]..","..arg[9])()
		dx_attributes[elem].scale = tonumber(arg[10])
		dx_attributes[elem].font = arg[11]:sub(2,-2)
		dx_attributes[elem].halign = arg[12]:sub(2,-2)
		dx_attributes[elem].valign = arg[13]:sub(2,-2)
		dx_attributes[elem].clip = loadstring("return "..arg[14])()	
		dx_attributes[elem].wordwrap = loadstring("return "..arg[15])()	
		
		local s = arg[16]:find(")",1,true)
		if s then arg[16] = arg[16]:sub(1,s-1) end
		dx_attributes[elem].postgui = loadstring("return "..arg[16])()	
	end
end