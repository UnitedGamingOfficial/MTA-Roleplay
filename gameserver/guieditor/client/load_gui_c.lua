--[[ GUI Editor - Load GUI - Client ]]--
local loadcode = {}

function LoadGUIElement(element)
	if element and isElement(element) then
		local type = getElementType(element)
		
		--outputChatBox("loaded "..type.." parent: "..getElementType(getElementParent(element)))
		
		local font = guiGetFont(element)
		local varname
		if font and font == "default-normal" then font = nil end
		if font then guiSetFont(element,font) end
		
		if type=="gui-window" then 
			GUIEditor_Window[window_count] = element
			varname = "GUIEditor_Window["..window_count.."]"
			setElementData(element,"guieditor_movable",true)
			setElementData(element,"guieditor_sizable",true)
			window_count = window_count + 1
		elseif type=="gui-button" then 
			GUIEditor_Button[button_count] = element
			varname = "GUIEditor_Button["..button_count.."]"	
			button_count = button_count + 1
		elseif type=="gui-memo" then
			GUIEditor_Memo[memo_count] = element
			varname = "GUIEditor_Memo["..memo_count.."]"
			memo_count = memo_count + 1
		elseif type=="gui-label" then 
			GUIEditor_Label[label_count] = element
			varname = "GUIEditor_Label["..label_count.."]"
			local colour = guiGetProperty(element,"TextColours")
			if colour then
				local r,g,b,a = HexToRGBA(colour:sub(4,11))
				if r and g and b then
					setElementData(element,"guieditor_colour",r..","..g..","..b)
				end
			end
			setElementData(element,"guieditor_wordwrap",false)
			setElementData(element,"guieditor_horizalign","left")
			setElementData(element,"guieditor_vertalign","top")
			label_count = label_count + 1	
		elseif type=="gui-checkbox" then 
			GUIEditor_Checkbox[checkbox_count] = element
			varname = "GUIEditor_Checkbox["..checkbox_count.."]"
			checkbox_count = checkbox_count + 1	
		elseif type=="gui-edit" then 
			GUIEditor_Edit[edit_count] = element
			varname = "GUIEditor_Edit["..edit_count.."]"
			setElementData(element,"guieditor_masked",false)
			setElementData(element,"guieditor_maxlength",nil)
			edit_count = edit_count + 1	
		elseif type=="gui-gridlist" then 
			GUIEditor_Grid[grid_count] = element
			varname = "GUIEditor_Grid["..grid_count.."]"
			guiGridListSetSelectionMode(GUIEditor_Grid[grid_count],2)
			setElementData(element,"guieditor_colcount",0)
			grid_count = grid_count + 1	
		elseif type=="gui-progressbar" then 
			GUIEditor_Progress[progress_count] = element
			varname = "GUIEditor_Progress["..progress_count.."]"
			progress_count = progress_count + 1	
		elseif type=="gui-tabpanel" then 
			GUIEditor_TabPanel[tabpanel_count] = element
			varname = "GUIEditor_TabPanel["..tabpanel_count.."]"		
			tabpanel_count = tabpanel_count + 1	
		elseif type=="gui-tab" then 
			GUIEditor_Tab[tab_count] = element
			varname = "GUIEditor_Tab["..tab_count.."]"
		--	setElementData(element,"guieditor_parent",getElementData(getElementParent(element),"guieditor_varname"))
			tab_count = tab_count + 1	
		elseif type=="gui-radiobutton" then 
			GUIEditor_Radio[radio_count] = element
			varname = "GUIEditor_Radio["..radio_count.."]"
			radio_count = radio_count + 1	
		elseif type=="gui-staticimage" then
			GUIEditor_Image[image_count] = element
			varname = "GUIEditor_Image["..image_count.."]"
			image_dir = string.gsub(image_dir,"\"","")
			setElementData(element,"guieditor_dir",image_dir)
			image_count = image_count + 1
		elseif type == "gui-scrollpane" then
			GUIEditor_Scrollpane[scrollpane_count] = element
			varname = "GUIEditor_Scrollpane["..scrollpane_count.."]"
			scrollpane_count = scrollpane_count + 1
			
			setElementData(element,"MousePassThroughEnabled",false)
			guiMoveToBack(element)
		elseif type == "gui-scrollbar" then
			GUIEditor_Scrollbar[scrollbar_count] = element
			varname = "GUIEditor_Scrollbar["..scrollbar_count.."]"
			scrollbar_count = scrollbar_count + 1

			setElementData(element,"guieditor_horizontal",guiGetProperty(element,"VerticalScrollbar") == "False")
			setElementData(element,"MousePassThroughEnabled",true)
			guiMoveToBack(element)
		end
		
		
		if varname then
			setElementData(element,"guieditor_varname",varname)
		end
		
		if not getElementData(element,"guieditor_properties") then
			setElementData(element,"guieditor_properties",{})
		--	outputDebugString("Setting properties table for "..getElementType(element))
		end
	else
		outputDebugString("GUIEditor Error: GUI element could not be loaded. Data not set. ("..tostring(element)..")",1)
	end
	
	return element
end


function HexToRGBA(hex)
	if type(hex) ~= "string" then hex = tostring(hex) end
	
	if hex:len() ~= 8 then
		return nil,nil,nil,nil
	else
		alpha = "0x" .. hex:sub(1,2)
		red = "0x" .. hex:sub(3,4)
		green = "0x" .. hex:sub(5,6)
		blue = "0x" .. hex:sub(7,8)
	
		return tonumber(red), tonumber(green), tonumber(blue), tonumber(alpha)
	end
end


function loadGUICode()
	if not loadcode.window then
		createLoadcodeGUI()
	else
		guiSetVisible(loadcode.window,true)
	end

	triggerServerEvent("loadGUICode",getLocalPlayer())
end
addCommandHandler("loadin",loadGUICode)


addEvent("receiveLoadedCode",true)
addEventHandler("receiveLoadedCode",root,function(code)
	if code then
		guiSetText(loadcode.label,"Found "..tostring(#code).." GUI(s):")

		for i,v in ipairs(code) do
			if not loadcode.items[i] then
				loadcode.items[i] = {}
				loadcode.items[i].gui = guiCreateLabel(2,(i-1)*22,270,20,"",false,loadcode.scrollpane)
				loadcode.items[i].code = v.c
				loadcode.items[i].date = v.date
				guiLabelSetVerticalAlign(loadcode.items[i].gui,"center")
				
				setElementData(loadcode.items[i].gui,"cant_highlight",true)
				
				addEventHandler("onClientGUIClick",loadcode.items[i].gui,selectLoadedGUI,false)
			end
			
			guiSetText(loadcode.items[i].gui,tostring(i)..".   Size: "..tostring(#v.c).."  Created: ".. (v.date ~= "" and tostring(v.date) or "Unknown"))
		end
	else
		guiSetText(loadcode.label,"Found 0 GUI(s):")
	end
end)



function createLoadcodeGUI()
	loadcode.window = guiCreateWindow(sx-285,sy/2-167,290,334,"Loaded Code",false)
	loadcode.label = guiCreateLabel(5,17,285,32,"Searching...",false,loadcode.window)
	guiLabelSetVerticalAlign(loadcode.label,"center")
	guiLabelSetHorizontalAlign(loadcode.label,"center",false)
	loadcode.scrollpane = guiCreateScrollPane(5,59,285,230,false,loadcode.window)
	loadcode.inspect = guiCreateButton(8,295,77,27,"Inspect",false,loadcode.window)
	loadcode.load = guiCreateButton(104,295,77,27,"Load",false,loadcode.window)
	loadcode.exit = guiCreateButton(196,295,77,27,"Exit",false,loadcode.window)
	
	setElementData(loadcode.window,"cant_edit",true)
	setElementData(loadcode.label,"cant_edit",true)
	setElementData(loadcode.scrollpane,"cant_edit",true)
	setElementData(loadcode.inspect,"cant_edit",true)
	setElementData(loadcode.load,"cant_edit",true)
	setElementData(loadcode.exit,"cant_edit",true)
	
	setElementData(loadcode.label,"cant_highlight",true)
	
	loadcode.items = {}
	loadcode.selected = nil
	
	addEventHandler("onClientGUIClick",loadcode.exit,function(button,state)
		if button == "left" and state == "up" then
			guiSetVisible(loadcode.window,false)
			
			for i,v in ipairs(loadcode.items) do
				removeEventHandler("onClientGUIClick",v.gui,selectLoadedGUI)
				destroyElement(v.gui)
				loadcode.items[i] = nil
			end
			
			guiSetText(output_memo,"")			
			HidePrintGUI()	
		end
	end,false)
	
	addEventHandler("onClientGUIClick",loadcode.inspect,function(button,state)
		if button == "left" and state == "up" then
			if loadcode.selected then
				guiSetText(output_memo,loadcode.items[loadcode.selected].code)
			
				guiSetVisible(output_window,true)
				guiBringToFront(output_window)
				
				guiSetEnabled(output_button_output,false)
				guiSetEnabled(output_button_refresh,false)				
			end
		end
	end,false)	
	
	addEventHandler("onClientGUIClick",loadcode.load,function(button,state)
		if button == "left" and state == "up" then
			if loadcode.selected then
				guiSetText(output_memo,"")			
				guiSetVisible(output_window,false)
				
				
				
				loadCodeString(loadcode.items[loadcode.selected].code)
			end
		end
	end,false)	
end


function loadCodeString(code)
	local lines = split_(code,"\n")
	for i,v in ipairs(lines) do
		if #v > 10 then
			-- its a table
			if v:find("= {}") and not v:find("gui") then
				loadstring(v)()
			else
			--	outputChatBox("attempt: "..v)
						
				local s,e = v:find("=")
						
				local varname
							
				if s and e then				
					varname = string.gsub(v:sub(1,s-1)," ","")	

					if varname:find(".",1,true) then
						local ts = varname:find(".",1,true)
						
						local t = varname:sub(1,ts-1)
						
						if not _G[t] or type(_G[t]) ~= "table" then
							_G[t] = {}
						end
					end
				end

				if not varname then
					--assert(loadstring(v)(),"GUIEditor: Code loading failed (non-return).")
					if not v:find("addEventHandler") and not v:find("function()") and v ~= "end" and (v[1] ~= "-" or v[2] ~= "-") then
						if v:find("dxDrawText") or v:find("dxDrawRectangle") or v:find("dxDrawImage") or v:find("dxDrawLine") then
							loadDXString(v)
						else
							loadstring(v)()		
							convertFuncToData(v)
						end
					end
				else				
					if v:find("for i = ") then 
					
					else
						if v:find("guiCreateStaticImage") then
							v:gsub('".*"', function(w) image_dir = w end)
						--	outputDebugString("Dir: "..tostring(image_dir))
						end
					
						if not attemptLoad(v,varname) then
							if v:find("guiCreateStaticImage") then
								v = v:gsub('".*"','"images/mtalogo.png"')
								image_dir = "images/mtalogo.png"
								
								attemptLoad(v, varname)
							end
						end
					end
				end
			end
		end
	end
end


function attemptLoad(v, varname)
	local modify

	if v:find("guiCreateScrollPane") then
		local s,e = v:find("%(")				
		if s and e then	v = v:sub(e+1) end
		
		s,e = v:find("%)")
		if s and e then v = v:sub(0,e-1) end
		
		v = v:gsub("guiCreateScrollPane(","")
		
		local parts = split(v,string.byte(","))

		--outputDebugString(string.format("Scrollpane load: %.1f %.1f %.1f %.1f, %s [%s]",parts[1],parts[2],parts[3],parts[4],parts[5],parts[6]))
		
		v = varname .. " = guiCreateLabel("..parts[1]..","..parts[2]..","..parts[3]..","..parts[4]..",\"\","..parts[5]..(parts[6] and "," .. parts[6] .. ")" or ")")
		
		modify = LoadGUIElement(guiCreateScrollPane(tonumber(parts[1]),tonumber(parts[2]),tonumber(parts[3]),tonumber(parts[4]),parts[5] == "true",_G[parts[6]]))
	elseif v:find("guiCreateScrollBar") then
		local s,e = v:find("%(")				
		if s and e then	v = v:sub(e+1) end
		
		s,e = v:find("%)")
		if s and e then v = v:sub(0,e-1) end
		
		v = v:gsub("guiCreateScrollBar(","")
		
		local parts = split(v,string.byte(","))
		
		--outputDebugString(string.format("Scrollbar load: %.1f %.1f %.1f %.1f, %s %s [%s]",parts[1],parts[2],parts[3],parts[4],parts[5],parts[6],parts[7]))

		v = varname .. " = guiCreateLabel("..parts[1]..","..parts[2]..","..parts[3]..","..parts[4]..",\"\","..parts[6]..(parts[7] and "," .. parts[7] .. ")" or ")")

		modify = LoadGUIElement(guiCreateScrollBar(tonumber(parts[1]),tonumber(parts[2]),tonumber(parts[3]),tonumber(parts[4]),parts[5] == "true",parts[6] == "true",_G[parts[7]]))
	end

	local elem = assert(loadstring(v.." return "..varname)(),"GUIEditor: Code loading failed, suspect variable problem.")
	_G[varname] = elem
					
	if elem and isElement(elem) then
		LoadGUIElement(elem)
		
		if modify then
			setElementData(modify,"guieditor_varname",varname)
		
			setElementData(elem,"guieditor_ghost",modify)
			
			if getElementType(modify) == "gui-scrollpane" then
				setElementData(elem,"modify_menu",14)
			elseif getElementType(modify) == "gui-scrollbar" then
				setElementData(elem,"modify_menu",15)
			end
		end
		return true
	else							
		outputDebugString("GUIEditor: Failed to parse code line, "..tostring(v))
	end
	
	return false
end


function selectLoadedGUI(button,state)
	if button == "left" and state == "up" then
		guiLabelSetColor(source,0,200,50)
		
		if loadcode.selected then
			guiLabelSetColor(loadcode.items[loadcode.selected].gui,255,255,255)
		end
		
		for i,v in ipairs(loadcode.items) do
			if v.gui == source then 
				loadcode.selected = i
				break
			end
		end		
	end
end


function split_(s,d)
	local parts = {}
	
	while true do
		local b,e = s:find(d,1,true)
		
		if not b then break end
		
		parts[#parts+1] = s:sub(1,b)
		
		s = s:sub(e+1)
	end
	
	return parts
end


function convertFuncToData(func)
	local s = func:find("(",1,true)
	local _,e = func:find(",",1,true)
	
	if s and e then
		local var = func:sub(s+1,e-1)
		
		local element = _G[var]
		
		if element and isElement(element) then
			if func:find("guiWindowSetSizable") then
				local val = true
				if func:sub(e+1,func:find(")")-1) == "false" then val = false end
				setElementData(element,"guieditor_sizable",val)
			end
			
			if func:find("guiWindowSetMovable") then
				local val = true
				if func:sub(e+1,func:find(")")-1) == "false" then val = false end
				setElementData(element,"guieditor_movable",val)
			end
			
			if func:find("guiMemoSetReadOnly") then
				local val = true
				if func:sub(e+1,func:find(")")-1) == "false" then val = false end		
				setElementData(element,"guieditor_readonly",val)
			end
			
			if func:find("guiLabelSetColor") then
				setElementData(element,"guieditor_colour",func:sub(e+1,#func-2))
			end
			
			if func:find("guiLabelSetVerticalAlign") then
				setElementData(element,"guieditor_vertalign",func:sub(e+2,#func-3))
			end
			
			if func:find("guiLabelSetHorizontalAlign") then
				local e2 = func:find(",",e+1)
				local wordwrap = (func:sub(e2+2,#func-2) == "true")
				setElementData(element,"guieditor_wordwrap",wordwrap)
				setElementData(element,"guieditor_horizalign",func:sub(e+2,e2-2))
			end
			
			if func:find("guiEditSetMasked") then
				local val = true
				if func:sub(e+1,func:find(")")-1) == "false" then val = false end		
				setElementData(element,"guieditor_masked",val)
			end
			
			if func:find("guiEditSetReadOnly") then
				local val = true
				if func:sub(e+1,func:find(")")-1) == "false" then val = false end		
				setElementData(element,"guieditor_readonly",val)
			end
			
			if func:find("guieditor_maxlength") then
				setElementData(element,"guieditor_maxlength",func:sub(e+1,#func-1))
			end
			
			if func:find("guiGridListAddColumn") then
				local count = (tonumber(getElementData(element,"guieditor_colcount")) or 0) + 1
				local e2 = func:find(",",e+1)
				
				setElementData(element,"guieditor_coltitle_"..count,func:sub(e+2,e2-2))
				setElementData(element,"guieditor_colcount",count)
			end	
		else
			outputDebugString("convertFuncToData: bad variable '"..tostring(element).."' ("..tostring(var)..")")
		end
	end
end