function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "vehicle:radio", station, true)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "vehicle:radio:volume", vol, true)
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", getRootElement(), syncRadio)

function stopRadio()
	exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "vehicle:radio", 0, true)
end
addEvent("car:radio:stop", true)
addEventHandler("car:radio:stop", getRootElement(), syncRadio)

function stopAllRadios()
	for _, theVehicle in ipairs(getElementsByType("vehicle")) do
		exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), stopAllRadios)
addCommandHandler("turnoffallradio", stopAllRadios, false, false)

function turnOffDistrictVehicles(thePlayer, commandName)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local zoneName = exports.global:getElementZoneName(thePlayer)
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		for k, theVehicle in ipairs(vehicles) do
			local vehicleZoneName = exports.global:getElementZoneName(theVehicle)
			if (zoneName == vehicleZoneName) then
				if getElementData(theVehicle, "vehicle:radio") ~= 0 then
					exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
					counter = counter + 1
				end
			end
		end
		exports.global:sendMessageToAdmins("AdmWrn: ".. getPlayerName(thePlayer) .." turned the radio off for " .. counter .. " district vehicles in '"..zoneName.."'.")
	end
end
addCommandHandler("stopradiodistrict", turnOffDistrictVehicles, false, false)