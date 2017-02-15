function vehInteriorGUI(ownerName)
	outputDebugString("vehInteriorGUI()")
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end

		destroyElement(gInteriorName)
		gInteriorName = nil

		destroyElement(gOwnerName)
		gOwnerName = nil
		
		unbindKey("f", "down", useVehicleInterior)
	end
	local px,py,pz = getElementPosition(getLocalPlayer())
	local x,y,z = getElementPosition(source)
	--[[if(getDistanceBetweenPoints3D(px,py,pz,x,y,z) > 2) then
		outputDebugString("distance too far")
		unbindKey("f", "down", triggerLiftGUI)
		return
	end--]]

	gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(getVehiclePlateText(source)), true)
	guiSetFont(gInteriorName, "sa-header")
	guiLabelSetHorizontalAlign(gInteriorName, "center", true)
	guiSetAlpha(gInteriorName, 0.0)

	gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Press F to enter "..tostring(getVehicleName(source)), true)
	guiSetFont(gOwnerName, "default-bold-small")
	guiLabelSetHorizontalAlign(gOwnerName, "center", true)
	guiSetAlpha(gOwnerName, 0.0)

	timer = setTimer(fadeMessage, 50, 20, true)

	--outputDebugString("source: "..tostring(source))
	bindKey("f", "down", useVehicleInterior, source)

end
addEvent("vehicle-interiors:showInteriorGUI", true)
addEventHandler("vehicle-interiors:showInteriorGUI", getRootElement(), vehInteriorGUI)
function hideVehInteriorGUI()
	unbindKey("f", "down", useVehicleInterior)
	hideIntName()
end
addEvent("vehicle-interiors:hideInteriorGUI", true)
addEventHandler("vehicle-interiors:hideInteriorGUI", getRootElement(), hideVehInteriorGUI)


function changeTexture(model)
	outputDebugString("applying texture ("..tostring(model)..")")
	if(model == 577) then --AT-400
		local txd = engineLoadTXD("files/at400_interior.txd")
		engineImportTXD(txd,14548)
	elseif(model == 592) then --Andromada
		--restore
		local txd = engineLoadTXD("files/ab_cargo_int.txd")
		engineImportTXD(txd,14548)			
	else
		--restore
		local txd = engineLoadTXD("files/ab_cargo_int.txd")
		engineImportTXD(txd,14548)		
	end
end
addEvent("vehicle-interiors:changeTextures", true)
addEventHandler("vehicle-interiors:changeTextures", getRootElement(), changeTexture)

function fadeMessage(fadein)
	if gInteriorName and gOwnerName then
		local alpha = guiGetAlpha(gInteriorName)

		if (fadein) and (alpha) then
			local newalpha = alpha + 0.05
			guiSetAlpha(gInteriorName, newalpha)
			guiSetAlpha(gOwnerName, newalpha)

			if(newalpha>=1.0) then
				timer = setTimer(hideIntName, 4000, 1)
			end
		elseif (alpha) then
			local newalpha = alpha - 0.05
			guiSetAlpha(gInteriorName, newalpha)
			guiSetAlpha(gOwnerName, newalpha)

			if (gBuyMessage) then
				guiSetAlpha(gBuyMessage, newalpha)
			end

			if(newalpha<=0.0) then
				destroyElement(gInteriorName)
				gInteriorName = nil

				destroyElement(gOwnerName)
				gOwnerName = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

function useVehicleInterior(key, keyState, vehicle)
	if(key == "f" and keyState == "down") then
		unbindKey("f", "down", useVehicleInterior)
		hideIntName()
		triggerServerEvent("enterVehicleInterior", getLocalPlayer(), vehicle)
		cancelEvent()
	end
end