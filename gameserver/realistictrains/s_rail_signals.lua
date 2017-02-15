local stationNames = { }
stationNames[1] = "Unity"
stationNames[2] = "Market"
stationNames[3] = "San Fierro Central"
stationNames[4] = "Las Venturas North"
stationNames[5] = "Las Venturas East"
stationNames[6] = "Jefferson East"

function syncSignalState(id, reverse)
	for k,v in ipairs(getElementsByType("player")) do
		if ( getElementData(v, "loggedin") == 1 ) and (v~=source) then
			if (reverse) then
				triggerClientEvent(v, "syncSS", source, id, true)
			else
				triggerClientEvent(v, "syncSS", source, id)
			end
		end
	end
end
addEvent("syncSSIn", true)
addEventHandler("syncSSIn", getRootElement(), syncSignalState)

function atStation(id)
	local x, y, z = getElementPosition(source)
	for k,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)

		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 25) then
			triggerClientEvent(v, "inAtStat", source, id)
		end
	end
end
addEvent("atStat", true)
addEventHandler("atStat", getRootElement(), atStation)

function apprStation(id)
	outputDebugString(tostring(id))
	local x, y, z = getElementPosition(source)
	for k,v in ipairs(getElementsByType("player")) do
		local px, py, pz = getElementPosition(v)
		
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 25) then
			triggerClientEvent(v, "inApprStat", source, id)
		end
	end
end
addEvent("apprStat", true)
addEventHandler("apprStat", getRootElement(), apprStation)