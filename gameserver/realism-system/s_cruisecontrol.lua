local ccEnabled = false

function ccOn(speed)
	local theVehicle = getPedOccupiedVehicle(source)
	
	if theVehicle then
		setVehicleHandling(theVehicle, "maxVelocity", speed)
		ccEnabled = true
	end
end
addEvent("cruisecontrol:on", true)
addEventHandler("cruisecontrol:on", getRootElement(), ccOn)

function ccOff()
	local theVehicle = getPedOccupiedVehicle(source)
	if theVehicle then
		setVehicleHandling(theVehicle, "maxVelocity", nil, false)
		ccEnabled = false
	end
end
addEvent("cruisecontrol:off", true)
addEventHandler("cruisecontrol:off", getRootElement(), ccOff)

function ccQuit()
	local theVehicle = getPedOccupiedVehicle(source)
	
	if (theVehicle) and (ccEnabled) then
		setVehicleHandling(theVehicle, "maxVelocity", nil, false)
	end
end
addEventHandler("onPlayerQuit", getRootElement(), ccQuit)