--[[
		GUI Editor - Undo / Redo
		
		Each undo/redo group is defined as a series of 'actions'
		
		Basic action structure:

		action = {
			{
				ufunc = guiSetText,
				uvalues = {gui-element, newText},
			
				rfunc = guiSetText,
				rvalues = {gui-element, oldText}
			}
			
			{
				ufunc = guiSetAlpha,
				uvalues = {gui-element, newAlpha},
			
				rfunc = guiSetAlpha,
				rvalues = {gui-element, oldAlpha}
			}			
		}
		
		When the group is undone, ufunc will be called with the uvalues arguments for each action going sequentially forwards through the group
		When the group is redone, rfunc will be called with the rvalues arguments for each action, going sequentially backwards through the group

		
		There is also the option to link function return values to other areas of the action.
		When each action of the group is processed, it is checked for links. 
		Links are structured as {action_index, action_type, value_index}:
		
		action = {
			...
			
			rlink = { {1,"u",1} }
		}
		
		This example will set action[1].uvalues[1] to the return value of rfunc when it is run
		
		This allows us to create and destroy elements through this system, while preserving any 
		other functions within the group that rely on a working pointer to the element	
--]]					

local undoList, redoList = {},{}


local storedChanges = 5
local currentChange = 1

currentAction = {}


function insertAction(type,action,redo)
	if type == "undo" then
		if not redo then
			clearList("redo")
		end
		
		if #undoList == storedChanges then
			table.remove(undoList,storedChanges)
		end
		
		table.insert(undoList,1,action)
	elseif type == "redo" then
		if #redoList == storedChanges then
			table.remove(redoList,storedChanges)
		end
		
		table.insert(redoList,1,action)		
	end
end


function insertAndClearAction(type,action,redo)
	insertAction(type,action,redo)
	currentAction = {}
end


function clearList(type)
	if type == "undo" then
		undoList = {}
	elseif type == "redo" then
		redoList = {}
	end
end


function undoPrevious()
	undoAction(undoList[1],1)
end

function redoPrevious()
	redoAction(redoList[1],1)
end


function undoAction(action,index)
	for i,v in ipairs(action) do
		local ret 
		
		if v.ufunc then
		--	ret = assert(v.ufunc(unpack(v.uvalues or {})),"Call failed to ufunc ("..tostring(v.ufunc)..")")
			ret = v.ufunc(unpack(v.uvalues or {}))
		end
		
		if v.ulink then
			for k,link in pairs(v.ulink) do
				if link[2] == "r" then
					action[link[1]].rvalues[link[3]] = ret
				elseif link[2] == "u" then
					action[link[1]].uvalues[link[3]] = ret
				end
			end
		end		
	end

	insertAction("redo",action)
	
	table.remove(undoList,index)
end


function redoAction(action,index)
	for i = #action, 1, -1 do
		local ret
		
		if action[i].rfunc then
		--	ret = assert(action[i].rfunc(unpack(action[i].rvalues or {})),"Call failed to rfunc ("..tostring(action[i].rfunc)..")")
			ret = action[i].rfunc(unpack(action[i].rvalues or {}))
		end
		
		if action[i].rlink then
			for k,link in pairs(action[i].rlink) do
				if link[2] == "r" then
					action[link[1]].rvalues[link[3]] = ret
				elseif link[2] == "u" then
					action[link[1]].uvalues[link[3]] = ret
				end
			end
		end
	end
	
	insertAction("undo",action,true)
	
	table.remove(redoList,index)
end



function generateUndo(type,element,index)
	index = index or 1
	
	if not currentAction[index] then currentAction[index] = {} end
	
	if type == "position" then
		local x,y = guiGetPosition(element,false)
		currentAction[index].ufunc = guiSetPosition
		currentAction[index].uvalues = {element,x,y,false}
	elseif type == "size" then
		local w,h = guiGetSize(element,false)
		currentAction[index].ufunc = guiSetSize
		currentAction[index].uvalues = {element,w,h,false}
	elseif type == "create" then
	--	currentAction[index].ufunc = gui
	--	currentAction[index].uvalues = {element}
	end
end


function generateRedo(type,element,index)
	index = index or 1
	
	if not currentAction[index] then currentAction[index] = {} end
	
	if type == "position" then
		local x,y = guiGetPosition(element,false)
		currentAction[index].rfunc = guiSetPosition
		currentAction[index].rvalues = {element,x,y,false}
	elseif type == "size" then
		local w,h = guiGetSize(element,false)
		currentAction[index].rfunc = guiSetSize
		currentAction[index].rvalues = {element,w,h,false}
	elseif type == "create" then
	--	currentAction[index].rfunc = 
	--	currentAction[index].rvalues = {currentAction[index].uvalues[1]}
	end
end



function generateCreation(element)
	if not element or not isElement(element) then return {} end
	
	local a = {}
	
	local x,y = guiGetPosition(element,false)
	local w,h = guiGetSize(element,false)
	
	local type = getElementType(element)
	
	if type=="gui-window" then
		a[1] = {ufunc = guiCreateWindow, uvalues = {x,y,w,h,guiGetText(element),false},
				rfunc = destroyElement,  rvalues = {element}}
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}
	elseif type=="gui-button" then
		a[1] = {ufunc = guiCreateButton, uvalues = {x,y,w,h,guiGetText(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}		
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}
	elseif type=="gui-memo" then
		a[1] = {ufunc = guiCreateMemo, uvalues = {x,y,w,h,guiGetText(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}		
								
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}
	elseif type=="gui-label" then
		a[1] = {ufunc = guiCreateLabel, uvalues = {x,y,w,h,guiGetText(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}	
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-checkbox" then
		a[1] = {ufunc = guiCreateCheckBox, uvalues = {x,y,w,h,guiGetText(element),guiCheckBoxGetSelected(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}	
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-edit" then
		a[1] = {ufunc = guiCreateEdit, uvalues = {x,y,w,h,guiGetText(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}	
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-gridlist" then
		a[1] = {ufunc = guiCreateGridList, uvalues = {x,y,w,h,false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}		
								
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}
	elseif type=="gui-progressbar" then
		a[1] = {ufunc = guiCreateProgressBar, uvalues = {x,y,w,h,false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}	
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-tabpanel" then
		a[1] = {ufunc = guiCreateTabPanel, uvalues = {x,y,w,h,false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}		
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-tab" then
		a[1] = {ufunc = guiCreateTab, uvalues = {guiGetText(element),getElementParent(element)},
				rfunc = guiDeleteTab,  rvalues = {element,getElementParent(element)}}	
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-radiobutton" then
		a[1] = {ufunc = guiCreateRadioButton, uvalues = {x,y,w,h,guiGetText(element),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}		
				
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}				
	elseif type=="gui-staticimage" then
		a[1] = {ufunc = guiCreateStaticImage, uvalues = {x,y,w,h,getElementData(element,"guieditor_dir"),false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil},
				rfunc = destroyElement,  rvalues = {element}}	
								
		a[2] = {ufunc = LoadGUIElement, uvalues = {element}}
	elseif type=="gui-scrollpane" then
		a[1] = {ufunc = guiCreateScrollPane, uvalues = {x,y,w,h,false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil}, ulink = {{1,"r",1}, {2,"u",1}, {5,"u",3}},
				rfunc = destroyElement,  rvalues = {element}}
			 
		a[2] = {ufunc = LoadGUIElement, uvalues = {nil}}
		
		a[3] = {ufunc = guiCreateLabel, uvalues = {x,y,w,h,"",false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil}, ulink = {{3,"r",1}, {4,"u",1}, {5,"u",1}, {6,"u",1}},
				rfunc = destroyElement,  rvalues = {element}}	
				
		a[4] = {ufunc = LoadGUIElement, uvalues = {nil}}

		a[5] = {ufunc = setElementData, uvalues = {nil, "guieditor_ghost", nil}}					
					
		a[6] = {ufunc = setElementData, uvalues = {nil, "modify_menu", 15}}			
	elseif type=="gui-scrollbar" then
		a[1] = {ufunc = guiCreateScrollBar, uvalues = {x,y,w,h,guiGetProperty(element,"VerticalScrollbar") ~= "True",false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil}, ulink = {{1,"r",1}, {2,"u",1}, {5,"u",3}},
				rfunc = destroyElement,  rvalues = {element}}
			 
		a[2] = {ufunc = LoadGUIElement, uvalues = {nil}}
		
		a[3] = {ufunc = guiCreateLabel, uvalues = {x,y,w,h,"",false,DoesElementHaveGUIParent(element) and getElementParent(element) or nil}, ulink = {{3,"r",1}, {4,"u",1}, {5,"u",1}, {6,"u",1}},
				rfunc = destroyElement,  rvalues = {element}}
				
		a[4] = {ufunc = LoadGUIElement, uvalues = {nil}}

		a[5] = {ufunc = setElementData, uvalues = {nil, "guieditor_ghost", nil}}
					
		a[6] = {ufunc = setElementData, uvalues = {nil, "modify_menu", 15}}
	end		
	
	return a
end


function generateMiscSettings(element,index)
	if not element or not isElement(element) then return {} end
	
	index = index or 1
	
	local a = {}
	
	local prop_table = getElementData(element,"guieditor_properties")
	if prop_table then
		a[index] = {ufunc = setElementData, uvalues = {element,"guieditor_properties",prop_table}}
		index = index + 1	
		
		for k,v in pairs(prop_table) do
			a[index] = {ufunc = guiSetProperty, uvalues = {element,k,v}}
			index = index + 1
		end
	end
	
	-- settings that cover all elements
	if getElementData(element,"guieditor_alpha") then 
		a[index] = {ufunc = guiSetAlpha, uvalues = {element,guiGetAlpha(element)}}
		index = index + 1
	end
	
	if guiGetFont(element) and guiGetFont(element) ~= "default-normal" then 
		a[index] = {ufunc = guiSetFont, uvalues = {element,guiGetFont(element)}}
		index = index + 1
	end
	
	if not UsingDefaultVariable(element) then
		a[index] = {ufunc = setElementData, uvalues = {element,"guieditor_varname",getElementData(element,"guieditor_varname")}}
		index = index + 1
	end
	
	
	
	local type = getElementType(element)
	
	if type=="gui-window" then
		if getElementData(element,"guieditor_sizable") == false then 
			a[index] = {ufunc = guiWindowSetSizable, uvalues = {element,false}}
			index = index + 1
		end
		
		if getElementData(element,"guieditor_movable") == false then
			a[index] = {ufunc = guiWindowSetMovable, uvalues = {element,false}}
			index = index + 1
		end
	elseif type=="gui-button" then
		-- nothing to see here
	elseif type=="gui-memo" then
		if getElementData(element,"guieditor_readonly") == true then 
			a[index] = {ufunc = guiMemoSetReadOnly, uvalues = {element,true}}
			index = index + 1
		end		
	elseif type=="gui-label" then
		if getElementData(element,"guieditor_colour") then 
			a[index] = {ufunc = guiLabelSetColor, uvalues = {element,getElementData(element,"guieditor_colour")}}
			index = index + 1
		end				
		
		if getElementData(element,"guieditor_vertalign") then
			a[index] = {ufunc = guiLabelSetVerticalAlign, uvalues = {element,getElementData(element,"guieditor_vertalign")}}
			index = index + 1
		end					

		local wordwrap = false
		local hora = "left"
		if getElementData(element,"guieditor_wordwrap") or getElementData(element,"guieditor_horizalign") then 			
			a[index] = {ufunc = guiLabelSetHorizontalAlign, uvalues = {element,getElementData(element,"guieditor_horizalign") or hora,getElementData(element,"guieditor_wordwrap") or wordwrap}}
			index = index + 1
		end			
	elseif type=="gui-checkbox" then
		-- move along
	elseif type=="gui-edit" then
		if getElementData(element,"guieditor_masked") then 
			a[index] = {ufunc = guiEditSetMasked, uvalues = {element,true}}
			index = index + 1
		end			

		if getElementData(element,"guieditor_readonly") then 
			a[index] = {ufunc = guiEditSetReadOnly, uvalues = {element,true}}
			index = index + 1
		end					
		
		if getElementData(element,"guieditor_maxlength") then 
			a[index] = {ufunc = guiEditSetMaxLength, uvalues = {element,tonumber(getElementData(element,"guieditor_maxlength"))}}
			index = index + 1
		end			
	elseif type=="gui-gridlist" then
		local row_c = guiGridListGetRowCount(element)
		if row_c~=false and row_c>0 then
			for i=1, row_c do
				a[index] = {ufunc = guiGridListAddRow, uvalues = {element}}
				index = index + 1				
			end
		end
			
		local col_c = getElementData(element,"guieditor_colcount")
		if col_c>0 then
			for i=1, col_c do
				a[index] = {ufunc = guiGridListAddColumn, uvalues = {element,getElementData(element,"guieditor_coltitle_"..i),0.2}}
				index = index + 1				
			end
		end	
	elseif type=="gui-progressbar" then
		if guiProgressBarGetProgress(element)>0 then
			a[index] = {ufunc = guiProgressBarSetProgress, uvalues = {element,guiProgressBarGetProgress(element)}}
			index = index + 1
		end				
	elseif type=="gui-tabpanel" then
		-- you too pal
	elseif type=="gui-tab" then
		-- yea, keep moving
	elseif type=="gui-radiobutton" then
		if guiRadioButtonGetSelected(element) then
			a[index] = {ufunc = guiRadioButtonSetSelected, uvalues = {element,true}}
			index = index + 1
		end				
	elseif type=="gui-staticimage" then
		-- alright that's it, you're coming with me
	end	
	
	return a
end


function generateDXSettings(e,dx,action)
	action[3] = {ufunc = loadDXDrawing, uvalues = {getDXNameFromID(dx),e},
				 rfunc = removeDXDrawing, rvalues = {e}}
							 
	action[4] = {ufunc = guiSetProperty, uvalues = {e,"ZOrderChangeEnabled","true"}}		

	if dx == 14 then -- text
		action[5] = {ufunc = setDXAttribute, uvalues = {"text",e,dx_attributes[e].text}}
		action[6] = {ufunc = setDXAttribute, uvalues = {"colour",e,dx_attributes[e].colour}}
		action[7] = {ufunc = setDXAttribute, uvalues = {"scale",e,dx_attributes[e].scale}}
		action[8] = {ufunc = setDXAttribute, uvalues = {"font",e,dx_attributes[e].font}}
		action[9] = {ufunc = setDXAttribute, uvalues = {"valign",e,dx_attributes[e].valign}}
		action[10] = {ufunc = setDXAttribute, uvalues = {"halign",e,dx_attributes[e].halign}}
		action[11] = {ufunc = setDXAttribute, uvalues = {"clip",e,dx_attributes[e].clip}}
		action[12] = {ufunc = setDXAttribute, uvalues = {"wordwrap",e,dx_attributes[e].wordwrap}}
		action[13] = {ufunc = setDXAttribute, uvalues = {"postgui",e,dx_attributes[e].postgui}}
		
	elseif dx == 15 then -- line
		action[3] = {ufunc = loadDXDrawing, uvalues = {getDXNameFromID(dx),e,dx_attributes[e].sx,dx_attributes[e].sy,dx_attributes[e].ex,dx_attributes[e].ey},
							 rfunc = removeDXDrawing, rvalues = {e}}
				
		action[5] = {ufunc = setElementData, uvalues = {e,"cant_highlight",true}}
				
		action[6] = {ufunc = HideBorder}
		
		action[7] = {ufunc = setDXAttribute, uvalues = {"colour",e,dx_attributes[e].colour}}
		action[8] = {ufunc = setDXAttribute, uvalues = {"width",e,dx_attributes[e].width}}
		action[9] = {ufunc = setDXAttribute, uvalues = {"postgui",e,dx_attributes[e].postgui}}	
	elseif dx == 16 then -- rectangle
		action[5] = {ufunc = setDXAttribute, uvalues = {"colour",e,dx_attributes[e].colour}}
		action[6] = {ufunc = setDXAttribute, uvalues = {"postgui",e,dx_attributes[e].postgui}}
	elseif dx == 17 then -- image
		action[3] = {ufunc = loadDXDrawing, uvalues = {getDXNameFromID(dx),e,dx_attributes[e].image},
					rfunc = removeDXDrawing, rvalues = {e}}	
	
		action[5] = {ufunc = setDXAttribute, uvalues = {"rotation",e,dx_attributes[e].rotation}}
		action[6] = {ufunc = setDXAttribute, uvalues = {"rxoffset",e,dx_attributes[e].rxoffset}}
		action[7] = {ufunc = setDXAttribute, uvalues = {"ryoffset",e,dx_attributes[e].ryoffset}}
		action[8] = {ufunc = setDXAttribute, uvalues = {"colour",e,dx_attributes[e].colour}}
		action[9] = {ufunc = setDXAttribute, uvalues = {"postgui",e,dx_attributes[e].postgui}}	 
	end
	
	return action
end
	


function table.merge(t1, t2)
	local l = #t1
	for i,v in ipairs(t2) do
		t1[l+i] = v
	end
	return t1
end


--[[
addCommandHandler("ia",function(cmd,t,v1,v2,v3,v4,v5)
	outputChatBox("cmd: "..tostring(t))
	insertAction(t,{{ufunc = outputChatBox, uvalues = {v1,v2,v3,v4,v5}, rfunc = outputChatBox, rvalues = {v1,v2,v3,v4,v5}}})
end)

addCommandHandler("undo",undoPrevious)
addCommandHandler("redo",redoPrevious)
]]