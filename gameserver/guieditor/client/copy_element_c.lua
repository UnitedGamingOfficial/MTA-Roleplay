--[[ GUI Editor - Copy Element - Client ]]--


function CopyGUIElement(element_source,element_parent,type,copy_children)

	if copy_children then
		local function search(element,parent)
			
			local p = CopyGUIElement(element,parent,getElementType(element),false)
		
			for _,v in ipairs(getElementChildren(element)) do
				if string.find(getElementType(v),'gui-...') then
					search(v,p)
				end
			end
		end

		search(element_source,element_parent)
		return
	end
	
	local ghost, newGhost
	ghost = getElementData(element_source,"guieditor_ghost",false)
	
	
	if type == "gui-scrollbar" or type == "gui-scrollpane" then
		return 
	end
		
	--outputChatBox("Copying "..type or tostring(nil).." Parent: "..getElementType(element_parent) or tostring(nil))

	local element = nil
	local text = guiGetText(element_source) or ""

	local font = guiGetFont(element_source)
	if font and font == "default-normal" then font = nil end
	
	-- for some reason this causes dp2.3 to crash, so we have to remove this feature for dp users
	local colour = nil	
	if getCameraMatrix then
		colour = guiGetProperty(element_source,"TextColours")
	end

	if element_parent and getElementType(element_parent)~="guiroot" then
		-- has a gui parent
		local x,y = guiGetPosition(element_source,false)
		local w,h = guiGetSize(element_source,false)
		if type=="gui-window" then outputDebugString("GUIEditor Error: Attempt to copy window with a gui parent",1)
		elseif type=="gui-button" then element = guiCreateButton(x,y,w,h,text,false,element_parent) 
		elseif type=="gui-memo" then element = guiCreateMemo(x,y,w,h,text,false,element_parent) 
		elseif type=="gui-label" then element = guiCreateLabel(x,y,w,h,text,false,element_parent) 
		elseif type=="gui-checkbox" then element = guiCreateCheckBox(x,y,w,h,text,false,false,element_parent) 
		elseif type=="gui-edit" then element = guiCreateEdit(x,y,w,h,text,false,element_parent)
		elseif type=="gui-gridlist" then element = guiCreateGridList(x,y,w,h,false,element_parent) 
		elseif type=="gui-progressbar" then element = guiCreateProgressBar(x,y,w,h,false,element_parent) 
		elseif type=="gui-radiobutton" then element = guiCreateRadioButton(x,y,w,h,text,false,element_parent) 
		elseif type=="gui-staticimage" then element = guiCreateStaticImage(x,y,w,h,false,element_parent)
		elseif type=="gui-tabpanel" then element = guiCreateTabPanel(x,y,w,h,false,element_parent)
		elseif type=="gui-tab" then element = guiCreateTab(text,element_parent)
		elseif type=="gui-scrollpane" then element = guiCreateScrollPane(x,y,w,h,false,element_parent)
		elseif type=="gui-scrollbar" then element = guiCreateScrollBar(x,y,w,h,getElementData(element_source,"guieditor_horizontal",false),false,element_parent)
		end
		
		if ghost then
			if getElementType(ghost) == "gui-scrollpane" then
				newGhost = guiCreateScrollPane(x,y,w,h,false,element_parent)
				LoadGUIElement(newGhost)
			elseif getElementType(ghost) == "gui-scrollbar" then
				newGhost = guiCreateScrollBar(x,y,w,h,getElementData(ghost,"guieditor_horizontal",false),false,element_parent)	
				LoadGUIElement(newGhost)	
			end
		end		
	else
		-- no parent 
		local x,y = guiGetPosition(element_source,false)
		local w,h = guiGetSize(element_source,false)
		if type=="gui-window" then element = guiCreateWindow(x,y,w,h,text,false)
		elseif type=="gui-button" then element = guiCreateButton(x,y,w,h,text,false)
		elseif type=="gui-memo" then element = guiCreateMemo(x,y,w,h,text,false) 
		elseif type=="gui-label" then element = guiCreateLabel(x,y,w,h,text,false)
		elseif type=="gui-checkbox" then element = guiCreateCheckBox(x,y,w,h,text,false,false) 
		elseif type=="gui-edit" then element = guiCreateEdit(x,y,w,h,text,false) 
		elseif type=="gui-gridlist" then element = guiCreateGridList(x,y,w,h,false) 
		elseif type=="gui-progressbar" then element = guiCreateProgressBar(x,y,w,h,false) 
		elseif type=="gui-radiobutton" then element = guiCreateRadioButton(x,y,w,h,text,false) 
		elseif type=="gui-staticimage" then element = guiCreateStaticImage(x,y,w,h,false)
		elseif type=="gui-tabpanel" then element = guiCreateTabPanel(x,y,w,h,false)
		elseif type=="gui-tab" then outputDebugString("GUIEditor Error: Attempt to copy tab without a parent",1)
		elseif type=="gui-scrollpane" then element = guiCreateScrollPane(x,y,w,h,false)
		elseif type=="gui-scrollbar" then element = guiCreateScrollBar(x,y,w,h,getElementData(element_source,"guieditor_horizontal",false),false)		
		end		
		
		if ghost then
			if getElementType(ghost) == "gui-scrollpane" then
				newGhost = guiCreateScrollPane(x,y,w,h,false)
				LoadGUIElement(newGhost)
			elseif getElementType(ghost) == "gui-scrollbar" then
				newGhost = guiCreateScrollBar(x,y,w,h,getElementData(ghost,"guieditor_horizontal",false),false)		
				LoadGUIElement(newGhost)	
			end
		end
	end
	
	if element then
		if ghost then
			setElementData(element,"modify_menu",getElementData(element_source,"modify_menu",false))
			setElementData(element,"guieditor_ghost",newGhost)
		end
	
		if font then guiSetFont(element,font) end
		if colour then
			local r,g,b,a = HexToRGBA(colour:sub(4,11))
			if r and g and b and getElementType(element)=="gui-label" then
				guiLabelSetColor(element,r,g,b)
			end
		end	
		
		if getElementData(element_source,"modify_menu") and getElementData(element_source,"modify_menu") >= dx_options and getElementData(element_source,"modify_menu") <= dx_options + 3 then
			copyDXItem(element_source,element)
		end	
		
		LoadGUIElement(element)
	end	
	
	return element
end
