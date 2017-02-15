wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getRootElement(), pedDamage)

function clickPed(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") and (sent==false) and (element~=getLocalPlayer()) then
		if (isPedDoingGangDriveby(getLocalPlayer()) == true) then
			setPedWeaponSlot(getLocalPlayer(), 0)
			setPedDoingGangDriveby(getLocalPlayer(), false)
		end
		local gatekeeper = getElementData(element, "talk")
		if (gatekeeper) then
			local x, y, z = getElementPosition(getLocalPlayer())
			
			if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
				if (wPedRightClick) then
					hidePlayerMenu()
				end
				
				showCursor(true)
				ax = absX
				ay = absY
				player = element
				closing = false
				
				wPedRightClick = guiCreateWindow(ax, ay, 150, 75, getElementData(element, "name"), false)
				
				bTalkToPed = guiCreateButton(0.05, 0.3, 0.87, 0.25, "Talk", true, wPedRightClick)
				addEventHandler("onClientGUIClick", bTalkToPed,  function (button, state)
					if(button == "left" and state == "up") then
					
						hidePedMenu()
						
						local ped = getElementData(element, "name")
						local isFuelped = getElementData(element,"ped:fuelped")
						local isTollped = getElementData(element,"ped:tollped")
						if (ped=="Steven Pullman") then
							triggerServerEvent( "startStevieConvo", getLocalPlayer())
							if (getElementData(element, "activeConvo")~=1) then
								triggerEvent ( "stevieIntroEvent", getLocalPlayer()) -- Trigger Client side function to create GUI.
							end
						elseif (ped=="Hunter") then
							triggerServerEvent( "startHunterConvo", getLocalPlayer())
						elseif (ped=="Rook") then
							triggerServerEvent( "startRookConvo", getLocalPlayer())
						elseif (ped=="Victoria Greene") then
							triggerEvent("cPhotoOption", getLocalPlayer(), ax, ay)
						elseif (ped=="Jessie Smith") then
							triggerEvent("onEmployment", getLocalPlayer())
						elseif (ped=="Carla Cooper") then
							triggerEvent("onLicense", getLocalPlayer())
						elseif (ped=="Mr. Clown") then
							triggerServerEvent("electionWantVote", getLocalPlayer())
						elseif (ped=="Johnny Johnson") then
							triggerServerEvent("onTowMisterTalk", getLocalPlayer())
						elseif (ped=="Guard Jenkins") then
							triggerServerEvent("gateCityHall", getLocalPlayer())
						elseif (ped=="Airman Connor") then
							triggerServerEvent("gateAngBase", getLocalPlayer())
						elseif (ped=="Rosie Jenkins") then
							triggerEvent("lses:popupPedMenu", getLocalPlayer())
						--[[elseif (ped=="Jacob Greenaway") then
							triggerEvent("lses:popupPedMenu", getLocalPlayer())]]
						elseif (ped=="Gabrielle McCoy") then
							triggerEvent("cBeginPlate", getLocalPlayer())
						elseif (ped=="Vanna Spadafora") then
							triggerEvent("vm:popupPedMenu", getLocalPlayer())
						elseif (isFuelped == true) then
							triggerServerEvent("fuel:startConvo", element)
						elseif (ped=="Clothing Lady") then
							triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("clothing")))
						elseif (isTollped == true) then
							triggerServerEvent("toll:startConvo", element)
						elseif (ped=="Novella Iadanza") then
							triggerServerEvent("onSpeedyTowMisterTalk", getLocalPlayer())
						else
							outputChatBox("Error: Unknown ped.", 255, 0, 0)
						end
					end
				end, false)
				
				bClosePedMenu = guiCreateButton(0.05, 0.6, 0.87, 0.25, "Close Menu", true, wPedRightClick)
				addEventHandler("onClientGUIClick", bClosePedMenu, hidePedMenu, false)
				sent=true
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPed, true)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil
	
	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil
	
	ax = nil
	ay = nil
	sent=false
	showCursor(false)
	
end