function setOdometer(thePlayer, theCommand, vehicleID, odometer)
	if (exports.global:isPlayerSuperAdmin(thePlayer) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullaDmin(thePlayer))) then
		if not (vehicleID) or not (odometer) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [vehicleID] [odometer]", thePlayer, 255, 194, 14)
			--outputChatBox("Remember to add three extra digits at the end. If desired odometer value is 222, write 222000", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			if theVehicle then
				local actualOdometer = tonumber(odometer) * 1000
				--outputDebugString( .. getPlayerName(thePlayer):gsub("_", " ") .. " has changed vehicle ID " .. vehicleID .. "'s milage to " .. actualOdometer .. ".")
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'odometer', actualOdometer, false )
				exports.mysql:query_free("UPDATE vehicles SET odometer='" .. exports.mysql:escape_string(actualOdometer) .. "' WHERE id = '" .. exports.mysql:escape_string(vehicleID) .. "'")
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Vehicle odometer set to " .. odometer .. ".", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("setodometer", setOdometer)
addCommandHandler("setmilage", setOdometer)

function resetAlcoholLevel(thePlayer, theCommand, targetPlayerName)
	if (exports['global']:isPlayerAdmin(thePlayer)) then
		if not (targetPlayerName) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Target Partial Name / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local charID = getElementData(targetPlayer, "dbid")
				exports['mysql']:query_free("UPDATE `characters` SET `alcohollevel`='0' WHERE `id`='" .. exports.mysql:escape_string(charID) .. "'")
				outputChatBox(getPlayerName(targetPlayer):gsub("_"," ").. "'s alcohol level has been reset.", thePlayer, 0, 255, 0)
				outputChatBox("Your alcohol level has been reset. Please relog (F10) to get it affected.", targetPlayer, 0, 255, 0)
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resetdrunk", resetAlcoholLevel)

function setAlcoholLevel(thePlayer, theCommand, targetPlayerName, level)
	if (exports['global']:isPlayerAdmin(thePlayer)) then
		if not (targetPlayerName) or not (level) or not (tonumber(level)) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Target Partial Name / ID] [Level = 0 - 3]", thePlayer, 255, 194, 14)
		else
			local level1 = tonumber(level)
			if (level1 == 0) or (level1 == 3) or (level1 == 1) or (level1 == 2) then
				local targetPlayer, targetPlayerName = exports['global']:findPlayerByPartialNick(thePlayer, targetPlayerName)
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					local charID = getElementData(targetPlayer, "dbid")
					exports['mysql']:query_free("UPDATE `characters` SET `alcohollevel`='" .. exports.mysql:escape_string(level) .. "' WHERE `id`='" .. exports.mysql:escape_string(charID) .. "'")
					outputChatBox(getPlayerName(targetPlayer):gsub("_"," ").."'s alcohol level has been set to " .. level .. ".", thePlayer, 0, 255, 0)
					outputChatBox("Your alchohol level has been set to " .. level .. ".", targetPlayer, 0, 255, 0)
				end
			else
				outputChatBox("SYNTAX: /" .. theCommand .. " [Target Partial Name / ID] [Level = 0 - 3]", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setdrunklevel", setAlcoholLevel)
