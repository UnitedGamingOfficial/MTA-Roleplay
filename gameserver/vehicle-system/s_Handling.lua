MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

function settableAttribute(theAttribue)
	local unsettables = {"centerOfMass", "monetary", "headLight", "tailLight", "animGroup", "ABS", "" }
	for _, value in ipairs(unsettables) do
		if theAttribue == value then
			return false
		end
	end
	return true
end

function changeVehicleHandling(thePlayer, commandName, veh)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not veh and getPedOccupiedVehicle(thePlayer) then
			veh = getPedOccupiedVehicle(thePlayer)
		elseif veh then
			if exports.pool:getElement("vehicle", tonumber(veh)) then
				veh = exports.pool:getElement("vehicle", tonumber(veh))
			else
				outputChatBox("Vehicle not found.", thePlayer, 255, 0, 0)
				return
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 255, 194, 14)
			outputChatBox("SYNTAX: /" .. commandName .. " - While in the vehicle.", thePlayer, 255, 194, 14)
			return
		end
		
		triggerClientEvent(thePlayer, "openHandlingGUI", thePlayer, veh)
	end
end
addCommandHandler("handling", changeVehicleHandling, false, false)

function saveVehicleHandling(newVehicleHandling)
	local hasFailed = false
	for attribute, value in pairs(newVehicleHandling) do
		if settableAttribute(attribute) then
			local result = setVehicleHandling(source, attribute, value)
			if not result then
				outputChatBox(attribute .. " has an invalid value. Please re-set the attribue.")
				hasFailed = true
			end
		end
	end
	local handling = toJSON( getVehicleHandling(source) )
	exports.mysql:query_free('UPDATE `vehicles` SET `handling` = \'' .. handling .. '\' WHERE id = \'' .. getElementData(source, "dbid") .. '\'')
	if not hasFailed then
		outputChatBox("Vehicle handling has been saved.", client, 0, 255, 0)
	end
end
addEvent("saveVehicleHandlingGUI", true)
addEventHandler("saveVehicleHandlingGUI", getRootElement(), saveVehicleHandling)