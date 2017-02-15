addEventHandler("onClientGUIMove",root,
	function()
		if getElementData(source,"guieditor_ghost",false) then
			local x,y = guiGetPosition(source,false)
			guiSetPosition(getElementData(source,"guieditor_ghost",false),x,y,false)
		end
	end
)


addEventHandler("onClientGUISize",root,
	function()
		if getElementData(source,"guieditor_ghost",false) then
			local w,h = guiGetSize(source,false)
			guiSetSize(getElementData(source,"guieditor_ghost",false),w,h,false)
		end
	end
)


addEventHandler("onClientElementDestroy",root,
	function()
		local ghost = getElementData(source,"guieditor_ghost",false)
		if ghost and isElement(ghost) then		
			destroyElement(ghost)
		end
	end
)