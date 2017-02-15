function responce()
	triggerClientEvent(source, "legitimateResponceRecived", source)
end
addEvent("tintDemWindows", true)
addEventHandler("tintDemWindows", getRootElement(), responce)

--forrest's vehicles
function setHandling()
  for key,veh in ipairs(getElementsByType("vehicle")) do
   if (getElementData(veh, "dbid") == 8799) or (getElementData(veh, "dbid") == 587) or (getElementData(veh, "dbid") == 9197) then
    setVehicleHandling(veh, "engineAcceleration", 20)
    setVehicleHandling(veh, "maxVelocity", 165)
    setVehicleHandling(veh, "steeringLock", 45)
   end
   if (getElementData(veh, "dbid") == 491) or (getElementData(veh, "dbid") == 9311) or (getElementData(veh, "dbid") == 9312) then
    setVehicleHandling(veh, "engineAcceleration", 22)
    setVehicleHandling(veh, "maxVelocity", 200)
    setVehicleHandling(veh, "steeringLock", 50)
   end
   if (getElementData(veh, "dbid") == 331) then
	setVehicleHandling(veh, "engineAcceleration", 15)
	setVehicleHandling(veh, "maxVelocity", 180)
	setVehicleHandling(veh, "brakeDeceleration", 1000)
	setVehicleHandling(veh, "tractionMultiplier", 0.8)
	end
	if (getElementData(veh, "dbid") == 386) then
	setVehicleHandling(veh, "engineAcceleration", 22)
	setVehicleHandling(veh, "maxVelocity", 200)
	setVehicleHandling(veh, "steeringLock", 50)
	setVehicleHandling(veh, "brakeDeceleration", 1000)
	end
  end
end
addEventHandler("onResourceStart", getRootElement(), setHandling)