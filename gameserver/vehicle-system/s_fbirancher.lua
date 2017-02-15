function enterFBIRancher(thePlayer, seat, jacked)
	if (seat == 0) then
		local tV = getPedOccupiedVehicle(thePlayer)
		if (getElementModel(tV) == 490 and isControlEnabled(thePlayer, "horn") == true) then
			toggleControl(thePlayer, "horn", false)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), enterFBIRancher)

