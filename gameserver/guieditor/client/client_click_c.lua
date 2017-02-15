--[[ GUI Editor - Client Click - Client ]]--

min_size = {5,5} -- minimum size an element can be, prevents accidental creation of 0x0 elements that you then cant remove

function sizeHandler() end


-- sadly, the enormous contents of this handler cannot be reliably split due to the ordering in which each section needs to be checked
function OnClientClick(button,state,absx,absy,x,y,z,worldentity)
	--outputChatBox("Button: "..button.." state: "..state.." absx: "..absx.." absy: "..absy.." x: "..x.." y: "..y.." z: "..z)
	
	if state=="down" then
		if button=="left" then
			-- manipulating a gui element, not trying to cancel and not trying to align (using control)
			if creating~=nil and cancel==false and vert_control==false and horiz_control==false and offset_active==false then 
				if current_menu and current_menu~="Screen" then 
					local ghost = getElementData(current_menu,"guieditor_ghost")
					if ghost and isElement(ghost) then
					--	current_menu = ghost
					end
				end
				
				if creating=="window" then
					LoadGUIElement(guiCreateWindow(absx,absy,0,0,"",false))
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Window[window_count-1]},
										rfunc = guiCreateWindow, rvalues = {0,0,0,0,"",false}, rlink = {{1,"r",1},{2,"u",1}}}
					
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Window[window_count-1]) end
					addEventHandler("onClientRender",root,sizeHandler)						
				elseif creating=="button" then
					if current_menu and current_menu~="Screen" then 
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateButton(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateButton(absx,absy,min_size[1],min_size[2],"",false))
					end	
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Button[button_count-1]},
										rfunc = guiCreateButton, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}					
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Button[button_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)					
				elseif creating=="checkbox" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateCheckBox(absx-x,absy-y,min_size[1],min_size[2],"",false,false,current_menu))
					else 
						LoadGUIElement(guiCreateCheckBox(absx,absy,min_size[1],min_size[2],"",false,false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Checkbox[checkbox_count-1]},
										rfunc = guiCreateCheckBox, rvalues = {0,0,0,0,"",false,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Checkbox[checkbox_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating=="radio" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateRadioButton(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateRadioButton(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Radio[radio_count-1]},
										rfunc = guiCreateRadioButton, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}			
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)	
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Radio[radio_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)					
				elseif creating=="memo" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateMemo(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateMemo(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Memo[memo_count-1]},
										rfunc = guiCreateMemo, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Memo[memo_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating=="label" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateLabel(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateLabel(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Label[label_count-1]},
										rfunc = guiCreateLabel, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Label[label_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating=="edit" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateEdit(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateEdit(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Edit[edit_count-1]},
										rfunc = guiCreateEdit, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)	
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Edit[edit_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating=="grid" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateGridList(absx-x,absy-y,min_size[1],min_size[2],false,current_menu))
					else
						LoadGUIElement(guiCreateGridList(absx,absy,min_size[1],min_size[2],false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Grid[grid_count-1]},
										rfunc = guiCreateGridList, rvalues = {0,0,0,0,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)	
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Grid[grid_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)			
				elseif creating=="progress" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateProgressBar(absx-x,absy-y,min_size[1],min_size[2],false,current_menu))
					else
						LoadGUIElement(guiCreateProgressBar(absx,absy,min_size[1],min_size[2],false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Progress[progress_count-1]},
										rfunc = guiCreateProgressBar, rvalues = {0,0,0,0,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}				
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)	
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Progress[progress_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)		
				elseif creating=="tabpanel" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateTabPanel(absx-x,absy-y,0,0,false,current_menu))
					else
						LoadGUIElement(guiCreateTabPanel(absx,absy,0,0,false))
					end
					
					local ret = LoadGUIElement(guiCreateTab("Tab",GUIEditor_TabPanel[tabpanel_count-1]))
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = guiDeleteTab, uvalues = {ret,GUIEditor_TabPanel[tabpanel_count-1]},
										rfunc = guiCreateTab, rvalues = {"Tab",GUIEditor_TabPanel[tabpanel_count-1]}, rlink = {{2,"u",1}}}					
					
					currentAction[3] = {ufunc = destroyElement, uvalues = {GUIEditor_TabPanel[tabpanel_count-1]},
										rfunc = guiCreateTabPanel, rvalues = {0,0,0,0,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = { {1,"r",1}, {2,"r",2}, {2,"u",2}, {3,"u",1} }}				
										
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)		
					function sizeHandler() UpdateGUIElementSize(GUIEditor_TabPanel[tabpanel_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating == "scrollpane" then
					local ghost
					
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						ghost = LoadGUIElement(guiCreateScrollPane(absx-x,absy-y,0,0,false,current_menu))
						LoadGUIElement(guiCreateLabel(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))		
					else
						ghost = LoadGUIElement(guiCreateScrollPane(absx,absy,0,0,false))
						LoadGUIElement(guiCreateLabel(absx,absy,min_size[1],min_size[2],"",false))						
					end
					
					currentAction[1] = {rfunc = setElementData, rvalues = {nil, "guieditor_ghost", nil}}					
					
					currentAction[2] = {rfunc = setElementData, rvalues = {nil, "modify_menu", 14}}						
					
					currentAction[3] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[4] = {ufunc = destroyElement, uvalues = {GUIEditor_Scrollpane[scrollpane_count-1]},
										rfunc = guiCreateScrollPane, rvalues = {0,0,0,0,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{3,"r",1}, {4,"u",1}, {1,"r",3}}}
					
					currentAction[5] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[6] = {ufunc = destroyElement, uvalues = {GUIEditor_Label[label_count-1]},
										rfunc = guiCreateLabel, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{5,"r",1}, {6,"u",1}, {1,"r",1}, {2,"r",1}}}	
					
					setElementData(GUIEditor_Label[label_count-1],"guieditor_ghost",ghost)
					setElementData(GUIEditor_Label[label_count-1],"modify_menu",14)					
					
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Label[label_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)
				elseif creating == "vertical_scrollbar" or creating == "horizontal_scrollbar" then	
					local ghost
				
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						ghost = LoadGUIElement(guiCreateScrollBar(absx-x,absy-y,0,0,creating == "horizontal_scrollbar",false,current_menu))
						LoadGUIElement(guiCreateLabel(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))						
					else
						ghost = LoadGUIElement(guiCreateScrollBar(absx,absy,0,0,creating == "horizontal_scrollbar",false))
						LoadGUIElement(guiCreateLabel(absx,absy,min_size[1],min_size[2],"",false))					
					end
					
					currentAction[1] = {rfunc = setElementData, rvalues = {nil, "guieditor_ghost", nil}}					
					
					currentAction[2] = {rfunc = setElementData, rvalues = {nil, "modify_menu", 15}}						
					
					currentAction[3] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[4] = {ufunc = destroyElement, uvalues = {GUIEditor_Scrollbar[scrollbar_count-1]},
										rfunc = guiCreateScrollBar, rvalues = {0,0,0,0,creating == "horizontal_scrollbar",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{3,"r",1}, {4,"u",1}, {1,"r",3}}}
					
					currentAction[5] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[6] = {ufunc = destroyElement, uvalues = {GUIEditor_Label[label_count-1]},
										rfunc = guiCreateLabel, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{5,"r",1}, {6,"u",1}, {1,"r",1}, {2,"r",1}}}		
					
					
					setElementData(GUIEditor_Label[label_count-1],"guieditor_ghost",ghost)
					setElementData(GUIEditor_Label[label_count-1],"modify_menu",15)
					
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Label[label_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)
				elseif creating=="pre_image" then
					creating = "image"
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateStaticImage(absx-x,absy-y,min_size[1],min_size[2],image_dir,false,current_menu))
					else
						LoadGUIElement(guiCreateStaticImage(absx,absy,min_size[1],min_size[2],image_dir,false))
					end
					
					currentAction[1] = {rfunc = LoadGUIElement, rvalues = {nil}}
					
					currentAction[2] = {ufunc = destroyElement, uvalues = {GUIEditor_Image[image_count-1]},
										rfunc = guiCreateStaticImage, rvalues = {0,0,0,0,image_dir,false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",1},{2,"u",1}}}			
					
					--addEventHandler("onClientRender",root,UpdateCurrentGUIElementSize)	
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Image[image_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating=="pre_move" or creating == "pre_move_x" or creating == "pre_move_y" then
					if creating == "pre_move" then
						creating = "move"
					elseif creating == "pre_move_x" then
						creating = "move_x"
					elseif creating == "pre_move_y" then
						creating = "move_y"
					end	
					
					if captured==true then
						for i,v in ipairs(captured_elements) do
							-- get the tab panel rather than the tab itself
							if getElementType(v)=="gui-tab" then v = getElementParent(v) end 
							local gx,gy = guiGetPosition(v,false)
							-- if you arent moving an element whose parent is the screen
							if DoesElementHaveGUIParent(v)==true then
								local gx2,gy2 = GetAbsolutePositionAndSizeOfElement(getElementParent(v))
								gx = gx+gx2
								gy = gy+gy2
							end
							--outputChatBox("x:"..gx.." y: "..gy.." absx: "..absx.." absy: "..absy)
							captured_move_offset_x[i] = absx-gx
							captured_move_offset_y[i] = absy-gy	

							generateUndo("position",v,i)
						end
						HideDragBox()		
					else
						local element = move
						-- get the tab panel rather than the tab itself
						if getElementType(element)=="gui-tab" then element = getElementParent(element) end 
						local gx,gy = guiGetPosition(element,false)
						-- if you arent moving an element whose parent is the screen
						if DoesElementHaveGUIParent(element)==true then
							local gx2,gy2 = GetAbsolutePositionAndSizeOfElement(getElementParent(element))
							gx = gx+gx2
							gy = gy+gy2
						end
					--	outputChatBox("x:"..gx.." y: "..gy.." absx: "..absx.." absy: "..absy)
						move_offset_x = absx-gx
						move_offset_y = absy-gy
						
						generateUndo("position",move)
					end
					
					
					addEventHandler("onClientRender",root,UpdateCurrentGUIElementPosition)
					HideBorder()
					addEventHandler("onClientMouseWheel",root,divideElement)
					divider_element = (captured == true and captured_elements[1] or move)
				elseif creating=="pre_resize" or creating == "pre_resize_width" or creating == "pre_resize_height" then
					if creating == "pre_resize" then
						creating = "resize"
					elseif creating == "pre_resize_width" then
						creating = "resize_width"
					elseif creating == "pre_resize_height" then
						creating = "resize_height"
					end
					
					if captured==true then
						for i,v in ipairs(captured_elements) do
							-- get the tab panel rather than the tab itself
							if getElementType(v)=="gui-tab" then v = getElementParent(v) end 
							local gx,gy = guiGetPosition(v,false)
							-- if you arent sizing an element whose parent is the screen
							if DoesElementHaveGUIParent(v)==true then
								local gx2,gy2 = GetAbsolutePositionAndSizeOfElement(getElementParent(v))
								gx = gx+gx2
								gy = gy+gy2
							end
							local eWidth, eHeight = guiGetSize(v,false)
							captured_move_offset_x[i] = absx-gx-eWidth
							captured_move_offset_y[i] = absy-gy-eHeight		

							generateUndo("size",v,i)
						end
						HideDragBox()	
					else
						generateUndo("size",current_menu)
					end
					
					if not captured and isElement(current_menu) and getElementData(current_menu,"modify_menu") == (dx_options + 1) then
						HideBorder()
						setElementData(current_menu,"cant_highlight",true)
				
						clicked_mx = dx_attributes[current_menu].sx
						clicked_my = dx_attributes[current_menu].sy
					
						local width,height = false,false
						if creating == "resize_width" then width = true elseif creating == "resize_height" then height = true end
						
						function sizeHandler() UpdateOmnidirectionalSize("dx_line",width,height) end
						addEventHandler("onClientRender",root,sizeHandler)					
					else			
						function sizeHandler() UpdateGUIElementSize(current_menu) end
						addEventHandler("onClientRender",root,sizeHandler)		
					end
				elseif creating=="load" then				
					local function search(grabbed_element)
						--outputChatBox("Loading "..getElementType(grabbed_element))
						
						--if getElementType(grabbed_element) == "gui-scrollpane" or getElementType(grabbed_element) == "gui-scrollbar" then
						--	outputChatBox("GUI Editor cannot currently load " .. getElementType(grabbed_element) .. "'s")
						--end
						
						LoadGUIElement(grabbed_element)
						for i,v in ipairs(getElementChildren(grabbed_element)) do
							search(v)
						end
					end		
					if current_cursor_element and isElement(current_cursor_element) then		
						if getElementType(current_cursor_element)=="gui-tab" then current_cursor_element = getElementParent(current_cursor_element) end
						search(current_cursor_element)
						outputChatBox("Successfully loaded "..getElementType(current_cursor_element).." and its children")
					end					
				elseif creating=="parent" then
				--	if not setElementParent(parent,current_cursor_element) then outputChatBox("false") end
				--	outputChatBox("c_type: "..getElementType(parent).." p_type: "..getElementType(current_cursor_element)) 
				--	parent = nil
				elseif creating == "dx_text" or creating == "dx_rectangle" or creating == "dx_pre_image" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateLabel(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateLabel(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					guiSetProperty(GUIEditor_Label[label_count-1],"ZOrderChangeEnabled","true")
					
					loadDXDrawing(creating,GUIEditor_Label[label_count-1],image_dir)
					
					
	--				if creating == "dx_text" then
	--					setElementData(GUIEditor_Label[label_count-1],"modify_menu",14)
	--				elseif creating == "dx_rectangle" then
	--					setElementData(GUIEditor_Label[label_count-1],"modify_menu",16)
	--				elseif creating == "dx_pre_image" then
	--					setElementData(GUIEditor_Label[label_count-1],"modify_menu",17)
	--					dx_attributes[GUIEditor_Label[label_count-1]].image = image_dir
	--					creating = "dx_image"
	--				end
					
					
					currentAction[1] = {rfunc = loadDXDrawing, rvalues = {creating,GUIEditor_Label[label_count-1]},
										ufunc = removeDXDrawing, uvalues = {GUIEditor_Label[label_count-1]}}
					
					currentAction[2] = {rfunc = guiSetProperty, rvalues = {GUIEditor_Label[label_count-1],"ZOrderChangeEnabled","true"}}
					
					currentAction[3] = {ufunc = destroyElement, uvalues = {GUIEditor_Label[label_count-1]},
										rfunc = guiCreateLabel, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{1,"r",2},{1,"u",1},{2,"r",1}}}				

					
					function sizeHandler() UpdateGUIElementSize(GUIEditor_Label[label_count-1]) end	
					addEventHandler("onClientRender",root,sizeHandler)	
				elseif creating == "dx_line" then
					if current_menu and current_menu~="Screen" then
						local x,y = GetAbsolutePositionAndSizeOfElement(current_menu)
						LoadGUIElement(guiCreateLabel(absx-x,absy-y,min_size[1],min_size[2],"",false,current_menu))
					else
						LoadGUIElement(guiCreateLabel(absx,absy,min_size[1],min_size[2],"",false))
					end
					
					guiSetProperty(GUIEditor_Label[label_count-1],"ZOrderChangeEnabled","true")
					
					HideBorder()
					
					setElementData(GUIEditor_Label[label_count-1],"cant_highlight",true)
					
					setElementData(GUIEditor_Label[label_count-1],"modify_menu",dx_options + 1)
					
					loadDXDrawing(creating,GUIEditor_Label[label_count-1],absx,absy,absx,absy)	

					
	--				dx_attributes[GUIEditor_Label[label_count-1]].sx = absx
	--				dx_attributes[GUIEditor_Label[label_count-1]].sy = absy
	--				dx_attributes[GUIEditor_Label[label_count-1]].ex = absx
	--				dx_attributes[GUIEditor_Label[label_count-1]].ey = absy			
					
					currentAction[1] = {rfunc = loadDXDrawing, rvalues = {creating,GUIEditor_Label[label_count-1],absx,absy,absx,absy},
										ufunc = removeDXDrawing, uvalues = {GUIEditor_Label[label_count-1]}}
					
					currentAction[2] = {rfunc = setElementData, rvalues = {GUIEditor_Label[label_count-1],"cant_highlight",true}}
					
					currentAction[3] = {rfunc = HideBorder}
					
					currentAction[4] = {rfunc = guiSetProperty, rvalues = {GUIEditor_Label[label_count-1],"ZOrderChangeEnabled","true"}}
					
					currentAction[5] = {ufunc = destroyElement, uvalues = {GUIEditor_Label[label_count-1]},
										rfunc = guiCreateLabel, rvalues = {0,0,0,0,"",false,(current_menu and current_menu ~= "Screen") and current_menu or nil}, rlink = {{4,"r",1},{2,"r",1},{1,"r",2},{1,"u",1}}, rtag = "dxline"}			
					
					clicked_mx = absx
					clicked_my = absy
				
					function sizeHandler() UpdateOmnidirectionalSize("dx_line",false,false) end
					addEventHandler("onClientRender",root,sizeHandler)
				end
			end
		end
	end
	
	if state=="up" then
		if button=="right" then 
			-- loading the right click menu
			if gui_editor==true and vert_control==false and horiz_control==false and offset_active==false then
			--	if current_cursor_element==nil or (current_cursor_element~=right_click_menu and current_cursor_element~=right_click_sub_menu and getElementParent(current_cursor_element)~=right_click_menu and getElementParent(current_cursor_element)~=right_click_sub_menu) then
				if current_cursor_element == nil or (not isElement(current_cursor_element)) or ((not getElementData(current_cursor_element,"cant_edit")) and (not getElementData(getElementParent(current_cursor_element),"cant_edit"))) then
					guiSetVisible(right_click_sub_menu,false)
					LoadRightClickMenu(absx,absy)
				end
			end
			if offset_active==true then
				if guieditor_tutorial and guieditor_tutorial_waiting["set offset"] then
					progressTutorial("set offset")
				end
				offset_active = false
				offset_element = nil
				SetInstruction("Right click to begin - /guihelp for feature details")
			end
		elseif button=="left" then
			if offset_active==true then
				if offset_element then
					if current_cursor_element and isElement(current_cursor_element) then
						if getElementParent(current_cursor_element)==getElementParent(offset_element) then
							local x,y = guiGetPosition(offset_element,false)

							local cx,cy = guiGetPosition(current_cursor_element,false)
							currentAction[1] = {ufunc = guiSetPosition, uvalues = {current_cursor_element,cx,cy,false},
												rfunc = guiSetPosition, rvalues = {current_cursor_element,x+offset_x,y+offset_y,false}}
							
							insertAndClearAction("undo",currentAction)
							
							guiSetPosition(current_cursor_element,x+offset_x,y+offset_y,false)
							
							HideBorder()
							
							offset_element = current_cursor_element
						end
					end
				end
			end
		end
	end
	
	-- control alignment
	if vert_control==true then
		VerticalControl(state,button)
	end
	
	if horiz_control==true then
		HorizontalControl(state,button)
	end
	
	-- clicking the screen
	if current_cursor_element==nil or (not isElement(current_cursor_element)) then 
		if state=="up" then
			if button=="left" then
				if creating~=nil and not offset_active then
					if guieditor_tutorial and guieditor_tutorial_waiting[creating] then
						progressTutorial(creating)
					end
					
					if creating == "move" or creating == "move_x" or creating == "move_y" then
						removeEventHandler("onClientMouseWheel",root,divideElement)
						hideElementDivide()
						dividing_count = false
						
						if move then
							if captured then
								for i,capture in ipairs(captured_elements) do
									generateRedo("position",capture,i)
								end
							else
								generateRedo("position",move)
							end
							
							insertAndClearAction("undo",currentAction)
						end
					end			

				--	if type(creating) == "string" and creating:find("dx") then
				--		loadDXDrawing(creating,GUIEditor_Label[label_count-1])
				--	end	
				
					if type(creating) == "string" and (creating == "dx_line" or (creating == "resize" or creating == "resize_width" or creating == "resize_height")) then
						local element = GUIEditor_Label[label_count-1]
						
						if creating:find("resize") then element = move end
						
						if captured then
							for i,capture in ipairs(captured_elements) do
								if getElementData(capture,"modify_menu") == (dx_options + 1) then
									setElementData(capture,"cant_highlight",nil)
						
									plotCorrectMaskPosition(dx_attributes[capture].sx,dx_attributes[capture].sy,dx_attributes[capture].ex,dx_attributes[capture].ey,capture)								
									plotCorrectDXPosition(capture)
								end
							end
						elseif getElementData(element,"modify_menu") == (dx_options + 1) then						
							setElementData(element,"cant_highlight",nil)
						
							plotCorrectMaskPosition(dx_attributes[element].sx,dx_attributes[element].sy,dx_attributes[element].ex,dx_attributes[element].ey,element)
							plotCorrectDXPosition(element)
						end
					end
					

					-- moving something
					if removeEventHandler("onClientRender",root,UpdateCurrentGUIElementPosition) then
						
					end
					-- (re)sizing something
					if removeEventHandler("onClientRender",root,sizeHandler) then
						-- resizing
						if creating and creating:find("resize") then
							if captured then
								for i,capture in ipairs(captured_elements) do
									generateRedo("size",capture,i)
								end
							else
								generateRedo("size",currentAction[1].uvalues[1])
							end
						-- creating + sizing
						else
							if creating and creating:find("dx") then
								local index = 3
								if creating:find("line") then 
									index = 5 
									local current_mx, current_my = getCursorPosition()
									local x,y = guiGetScreenSize()
									
									currentAction[1].rvalues[5] = current_mx * x
									currentAction[1].rvalues[6] = current_my * y
								end
								currentAction[index].rvalues[1],currentAction[index].rvalues[2] = guiGetPosition(currentAction[index].uvalues[1],false)
								currentAction[index].rvalues[3],currentAction[index].rvalues[4] = guiGetSize(currentAction[index].uvalues[1],false)					
							else						
								if currentAction[2] and currentAction[2].uvalues and isElement(currentAction[2].uvalues[1]) and getElementType(currentAction[2].uvalues[1]) == "gui-tab" then
									currentAction[3].rvalues[1],currentAction[3].rvalues[2] = guiGetPosition(currentAction[3].uvalues[1],false)
									currentAction[2].rvalues[3],currentAction[3].rvalues[4] = guiGetSize(currentAction[3].uvalues[1],false)	
								elseif currentAction[4] and currentAction[4].uvalues and isElement(currentAction[4].uvalues[1]) and 
									(getElementType(currentAction[4].uvalues[1]) == "gui-scrollbar" or getElementType(currentAction[4].uvalues[1]) == "gui-scrollpane") then
									currentAction[6].rvalues[1],currentAction[6].rvalues[2] = guiGetPosition(currentAction[6].uvalues[1],false)
									currentAction[6].rvalues[3],currentAction[6].rvalues[4] = guiGetSize(currentAction[6].uvalues[1],false)		
									currentAction[4].rvalues[1],currentAction[4].rvalues[2] = guiGetPosition(currentAction[6].uvalues[1],false)
									currentAction[4].rvalues[3],currentAction[4].rvalues[4] = guiGetSize(currentAction[6].uvalues[1],false)
								else
									currentAction[2].rvalues[1],currentAction[2].rvalues[2] = guiGetPosition(currentAction[2].uvalues[1],false)
									currentAction[2].rvalues[3],currentAction[2].rvalues[4] = guiGetSize(currentAction[2].uvalues[1],false)
								end
							end
						end
						
						insertAndClearAction("undo",currentAction)			
					end
					
					creating = nil
					
					SetInstruction("Right click to begin - /guihelp for feature details")
					HideBorder()
				end
				
				if captured==true and guiGetVisible(text_input_window)==false then
					captured = false
					SetInstruction("Right click to begin - /guihelp for feature details")
					HideDragBox()		
				end
			end
		end
	-- clicking a gui element
	else 
		if state=="up" then
			if button=="left" then
				-- clicking an option on the right click menu
				if creating==nil or cancel==true and vert_control==false and horiz_control==false and not offset_active then
					for i=1, max_options do
						if current_cursor_element==right_click_labels[i] then
							PerformRightClickOption(i,current_menu,"menu")
					--	elseif current_cursor_element==extra_right_click_labels[i] then
					--		PerformRightClickOption(i,current_menu,"extra")
					--	elseif current_cursor_element==resize_extra_right_click_labels[i] then
					--		PerformRightClickOption(i,current_menu,"resize_extra")
					--	elseif current_cursor_element==set_data_extra_right_click_labels[i] then
					--		PerformRightClickOption(i,current_menu,"set_data_extra")		
						elseif current_cursor_element==right_click_sub_menu_labels[i] then
							if guiGetVisible(right_click_parent_menu) then
								current_menu = getElementParent(current_menu)
								if getElementType(current_menu) == "guiroot" then
									current_menu = "Screen" 
								end
							end
							PerformRightClickOption(i,current_menu,"sub")
						elseif current_cursor_element==right_click_parent_menu_labels[i] then
							PerformRightClickOption(i,getElementParent(current_menu),"sub_parent")
						end
					end
				elseif creating and (not creating:find("image") or (creating == "image" or creating == "dx_image")) then
					if guieditor_tutorial and guieditor_tutorial_waiting[creating] then
						progressTutorial(creating)
					end				
					if creating == "move" or creating == "move_x" or creating == "move_y" then
						removeEventHandler("onClientMouseWheel",root,divideElement)
						hideElementDivide()
						dividing_count = false
						
						if move then
							generateRedo("position",move)				
							insertAndClearAction("undo",currentAction)
						end
					end

					
				--	if type(creating) == "string" and creating:find("dx") then
				--		loadDXDrawing(creating,GUIEditor_Label[label_count-1])
				--	end	
					
					if type(creating) == "string" and (creating == "dx_line" or (creating == "resize" or creating == "resize_width" or creating == "resize_height")) then
						local element = GUIEditor_Label[label_count-1]
						
						if creating:find("resize") then element = move end
						
						if captured then
							for i,capture in ipairs(captured_elements) do
								if getElementData(capture,"modify_menu") == (dx_options + 1) then
									setElementData(capture,"cant_highlight",nil)
						
									plotCorrectMaskPosition(dx_attributes[capture].sx,dx_attributes[capture].sy,dx_attributes[capture].ex,dx_attributes[capture].ey,capture)								
									plotCorrectDXPosition(capture)
								end
							end
						elseif getElementData(element,"modify_menu") == (dx_options + 1) then						
							setElementData(element,"cant_highlight",nil)
							
							plotCorrectMaskPosition(dx_attributes[element].sx,dx_attributes[element].sy,dx_attributes[element].ex,dx_attributes[element].ey,element)
							plotCorrectDXPosition(element)
						end
					end				
					
					-- moving something
					if removeEventHandler("onClientRender",root,UpdateCurrentGUIElementPosition) then
						
					end
					-- (re)sizing something
					if removeEventHandler("onClientRender",root,sizeHandler) then			
						-- resizing
						if creating and creating:find("resize") then
							if captured then
								for i,capture in ipairs(captured_elements) do
									generateRedo("size",capture,i)
								end
							else
								generateRedo("size",currentAction[1].uvalues[1])
							end
						-- creating + resizing
						else
							if creating and creating:find("dx") then
								local index = 3
								if creating:find("line") then 
									index = 5 
									
									local current_mx, current_my = getCursorPosition()
									local x,y = guiGetScreenSize()
									
									currentAction[1].rvalues[5] = current_mx * x
									currentAction[1].rvalues[6] = current_my * y							
								end
								currentAction[index].rvalues[1],currentAction[index].rvalues[2] = guiGetPosition(currentAction[index].uvalues[1],false)
								currentAction[index].rvalues[3],currentAction[index].rvalues[4] = guiGetSize(currentAction[index].uvalues[1],false)							
							else
								if currentAction[2] and currentAction[2].uvalues and isElement(currentAction[2].uvalues[1]) and getElementType(currentAction[2].uvalues[1]) == "gui-tab" then
									currentAction[3].rvalues[1],currentAction[3].rvalues[2] = guiGetPosition(currentAction[3].uvalues[1],false)
									currentAction[2].rvalues[3],currentAction[3].rvalues[4] = guiGetSize(currentAction[3].uvalues[1],false)	
								elseif currentAction[4] and currentAction[4].uvalues and isElement(currentAction[4].uvalues[1]) and 
									(getElementType(currentAction[4].uvalues[1]) == "gui-scrollbar" or getElementType(currentAction[4].uvalues[1]) == "gui-scrollpane") then
									currentAction[6].rvalues[1],currentAction[6].rvalues[2] = guiGetPosition(currentAction[6].uvalues[1],false)
									currentAction[6].rvalues[3],currentAction[6].rvalues[4] = guiGetSize(currentAction[6].uvalues[1],false)	
									currentAction[4].rvalues[1],currentAction[4].rvalues[2] = guiGetPosition(currentAction[6].uvalues[1],false)
									currentAction[4].rvalues[3],currentAction[4].rvalues[4] = guiGetSize(currentAction[6].uvalues[1],false)	
								else
									currentAction[2].rvalues[1],currentAction[2].rvalues[2] = guiGetPosition(currentAction[2].uvalues[1],false)
									currentAction[2].rvalues[3],currentAction[2].rvalues[4] = guiGetSize(currentAction[2].uvalues[1],false)
								end
							end
						end					
						
						insertAndClearAction("undo",currentAction)			
					end	

					creating = nil
					
					SetInstruction("Right click to begin - /guihelp for feature details")
					HideBorder()
					captured = false
					HideDragBox()		
				elseif captured==true then
					captured = false
					SetInstruction("Right click to begin - /guihelp for feature details")
					HideDragBox()		
				end	
				
				-- clicking the help menu				
				if current_cursor_element and isElement(current_cursor_element) then 
					if getElementParent(current_cursor_element)==help_list_scrollpane then
						ClickedHelpMenu()
					end
				end	
				
				-- clicking the cegui property widgets menu
				if current_cursor_element and isElement(current_cursor_element) then
					if getElementParent(current_cursor_element)==property_widget_scrollpane then
						ClickedPropertiesWidget()
					end
				end
				
				-- clicking the cegui property properties menu
				if current_cursor_element and isElement(current_cursor_element) then
					if getElementParent(current_cursor_element)==property_properties_scrollpane then
						ClickedPropertiesProperty()
					end
				end
			
			end		
		end
	end
	
	if state=="up" then
		if button=="left" then 
			-- hiding the right click menu
			if guiGetVisible(right_click_menu)==true then
				local gx,gy = guiGetPosition(right_click_menu,false)
			--	if ((absx<gx or absx>(gx+right_click_dimensions[1][1])) or (absy<gy or absy>(gy+right_click_dimensions[1][2]))) then
				local id = 1
				if isElement(current_menu) then
					if getElementData(current_menu,"modify_menu") then
						id = getElementData(current_menu,"modify_menu")
					else
						id = GetIDFromType(getElementType(current_menu))
					end
				end
				if ((absx<gx or absx>(gx+right_click_dimensions[id][1])) or (absy<gy or absy>(gy+right_click_dimensions[id][2]))) then
					guiSetVisible(right_click_menu,false)
				end
			end
		end
	end
	
	if button=="middle" then
		SelectGUIElements(state,absx,absy)
	end
end
addEventHandler("onClientClick",root,OnClientClick)

