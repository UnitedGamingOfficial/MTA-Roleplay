local vanna = createPed(150, 1447.3740234375, 1487.724609375, 11.077201843262)
local vmOptionMenu = nil
setPedRotation(vanna, 359.79949951172)
setElementFrozen(vanna, true)
setElementDimension(vanna, 92)
setElementInterior(vanna, 24)
setElementData(vanna, "talk", 1, false)
setElementData(vanna, "name", "Vanna Spadafora", false)

function popupvmPedMenu()
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if not vmOptionMenu then
		local width, height = 200, 150
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		vmOptionMenu = guiCreateWindow(x, y, width, height, "How can I help you?", false)

		bPhotos = guiCreateButton(0.05, 0.2, 0.87, 0.2, "I want to order a vehicle.", true, vmOptionMenu)
		addEventHandler("onClientGUIClick", bPhotos, helpButtonFunction, false)

		bAdvert = guiCreateButton(0.05, 0.5, 0.87, 0.2, "I'm here for an appointment.", true, vmOptionMenu)
		addEventHandler("onClientGUIClick", bAdvert, appointmentButtonFunction, false)
		
		bSomethingElse = guiCreateButton(0.05, 0.8, 0.87, 0.2, "I'm fine, thanks.", true, vmOptionMenu)
		addEventHandler("onClientGUIClick", bSomethingElse, otherButtonFunction, false)
		triggerServerEvent("vm:ped:start", getLocalPlayer(), getElementData(vanna, "name"))
		showCursor(true)
	end
end
addEvent("vm:popupPedMenu", true)
addEventHandler("vm:popupPedMenu", getRootElement(), popupvmPedMenu)

function closevmPedMenu()
	destroyElement(vmOptionMenu)
	vmOptionMenu = nil
	showCursor(false)
end

function helpButtonFunction()
	closevmPedMenu()
	triggerServerEvent("vm:ped:help", getLocalPlayer(), getElementData(vanna, "name"))
end

function appointmentButtonFunction()
	closevmPedMenu()
	triggerServerEvent("vm:ped:appointment", getLocalPlayer(), getElementData(vanna, "name"))
end

function otherButtonFunction()
	closevmPedMenu()
end