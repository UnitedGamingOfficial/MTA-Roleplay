local vehiculars = { }
local descriptionLines = { }

function bindVD()
  bindKey ( "lalt", "down", showNearbyVehicleDescriptions )
  bindKey ( "lalt", "up", removeVD )
  bindKey ( "ralt", "down", showNearbyVehicleDescriptions )
  bindKey ( "ralt", "up", removeVD )
end
addEventHandler ( "onClientResourceStart", resourceRoot, bindVD )

function removeVD ( key, keyState )
	removeEventHandler ( "onClientRender", getRootElement(), showText )
end

function showNearbyVehicleDescriptions()
	for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
		if isElement(nearbyVehicle) then
			vehiculars[index] = nearbyVehicle
		end
	end
	addEventHandler("onClientRender", getRootElement(), showText)
end

function showText()
	for i = 1, #vehiculars, 1 do
		if isElement(vehiculars[i]) then
		if getElementModel(vehiculars[i]) == 481 or getElementModel(vehiculars[i]) == 509 or getElementModel(vehiculars[i]) == 510 then
		local descriptions = {}
		for j = 1, 5 do
			descriptions[j] = getElementData(vehiculars[i], "description:"..j)
		end
		local x,y,z = getElementPosition(vehiculars[i])			
        local cx,cy,cz = getCameraMatrix()
		if descriptions[1] and descriptions[2] and descriptions[3] and descriptions[4] and descriptions[5] then
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 40 then
				local px,py,pz = getScreenFromWorldPosition(x,y,z+1,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
					dxDrawText(descriptions[1].."\n"..descriptions[2].."\n"..descriptions[3].."\n"..descriptions[4].."\n"..descriptions[5], px, py, px, py, tocolor(0, 255, 0, 255), 1, "default-bold", "center", "center", false, false)
				end
			end
		end
		elseif isElement(vehiculars[i]) then
		local plate
		local vin = getElementData(vehiculars[i], "dbid")
		if vin < 0 then
			plate = getVehiclePlateText(vehiculars[i])
		else
			plate = getElementData(vehiculars[i], "plate")
		end
		local descriptions = {}
		for j = 1, 5 do
			descriptions[j] = getElementData(vehiculars[i], "description:"..j)
		end
		local x,y,z = getElementPosition(vehiculars[i])			
        local cx,cy,cz = getCameraMatrix()
		if descriptions[1] and descriptions[2] and descriptions[3] and descriptions[4] and descriptions[5] then
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 40 then
				local px,py,pz = getScreenFromWorldPosition(x,y,z+1,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
					dxDrawText("(PLATE: "..plate..")\n(VIN: "..vin..")\n"..descriptions[1].."\n"..descriptions[2].."\n"..descriptions[3].."\n"..descriptions[4].."\n"..descriptions[5], px, py, px, py, tocolor(0, 255, 0, 255), 1, "default-bold", "center", "center", false, false)
				end
			end
		else
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 40 then
				local px,py,pz = getScreenFromWorldPosition(x,y,z+1,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
					dxDrawText("(PLATE: "..plate..")\n(VIN: "..vin..")\n", px, py, px, py, tocolor(0, 255, 0, 255), 1, "default-bold", "center", "center", false, false)
				end
			end
		end
		end
		end
	end
end

function showEditDescription()
	if getPedOccupiedVehicle(getLocalPlayer()) then
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		local dbid = getElementData(theVehicle, "dbid")
		local factionid = getElementData(theVehicle, "faction")
		if exports.global:hasItem(getLocalPlayer(), 3, dbid) or exports.global:hasItem(theVehicle, 3, dbid) or getElementData(getLocalPlayer(), "faction") == factionid or exports.global:isPlayerSuperAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "adminduty") == 1 then
			if dbid > 0 then
				local scrWidth, scrHeight = guiGetScreenSize()
				local x = scrWidth/2 - (441/2)
				local y = scrHeight/2 - (212/2)
				showCursor(true)
				wEditDescription = guiCreateWindow(x,y,441,212,"Edit Vehicle Description",false)
				guiWindowSetSizable(wEditDescription, false)
				guiSetInputEnabled(true)
				description1 = getElementData(theVehicle, "description:1")
				description2 = getElementData(theVehicle, "description:2")
				description3 = getElementData(theVehicle, "description:3")
				description4 = getElementData(theVehicle, "description:4")
				description5 = getElementData(theVehicle, "description:5")
				descriptionLines[1] = guiCreateEdit(10,23,422,26,description1,false,wEditDescription)
				descriptionLines[2] = guiCreateEdit(9,51,422,26,description2,false,wEditDescription)
				descriptionLines[3] = guiCreateEdit(9,79,422,26,description3,false,wEditDescription)
				descriptionLines[4] = guiCreateEdit(9,107,422,26,description4,false,wEditDescription)
				descriptionLines[5] = guiCreateEdit(9,135,422,26,description5,false,wEditDescription)
				bSave = guiCreateButton(10,165,210,40,"Save",false,wEditDescription)
				bClose = guiCreateButton(220,165,210,40,"Close",false,wEditDescription)
				addEventHandler("onClientGUIClick", bSave, saveEditDescription)
				addEventHandler("onClientGUIClick", bClose, closeEditDescription)
			else
				outputChatBox("You cannot set descriptions on temporary vehicles.", 255, 0, 0)
			end
		else
			outputChatBox("You are not the owner of this vehicle.", 255, 0, 0)
		end
	else
		outputChatBox("You must be in the vehicle you wish to change the description of.", 255, 0, 0)
	end
end
addCommandHandler("ed", showEditDescription, false, false)
addCommandHandler("editdescription", showEditDescription, false, false)

function saveEditDescription(button, state)
	if (source==bSave) and (button=="left") then
		local savedDescriptions = { }
		savedDescriptions[1] = guiGetText(descriptionLines[1])
		savedDescriptions[2] = guiGetText(descriptionLines[2])
		savedDescriptions[3] = guiGetText(descriptionLines[3])
		savedDescriptions[4] = guiGetText(descriptionLines[4])
		savedDescriptions[5] = guiGetText(descriptionLines[5])
		triggerServerEvent("saveDescriptions", getLocalPlayer(), savedDescriptions, getPedOccupiedVehicle(getLocalPlayer()))
		closeEditDescription()
	end
end

function closeEditDescription()
	destroyElement(wEditDescription)
	eLine1, eLine2, eLine3, eLine4, eLine5, bSave, bClose, wEditDescription = nil, nil, nil, nil, nil, nil, nil
	showCursor(false)
	guiSetInputEnabled(false)
end

