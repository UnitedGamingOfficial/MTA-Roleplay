function testOutput(thePlayer)
	local vehinfo = getVehicleHandling(getPedOccupiedVehicle(thePlayer))
	local jsoninfo = toJSON(vehinfo)
	outputDebugString(jsoninfo)
end
addCommandHandler("vehjson", testOutput, false, false)

function clearDebug(thePlayer)
	for i=0, 30 do
		outputDebugString("")
	end
end
addCommandHandler("cls", clearDebug, false, false)

function fixCars()
	for key, value in ipairs(getElementsByType("vehicle")) do
		if getElementData(value, "dbid") then
			local handling = toJSON(getVehicleHandling(value))
			exports.mysql:query_free("UPDATE vehicles SET handling='" .. exports.mysql:escape_string(handling) .. "' WHERE id='" .. getElementData(value, "dbid") .. "'")
			outputDebugString("fixed")
		end
	end
end
addCommandHandler("lol", fixCars, false, false)