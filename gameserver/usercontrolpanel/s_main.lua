-- addaccount: Added account 'website' with password '1996B23166524BFEDE530CDD8B'
function reloadUserPerks( userID )
	if (userID) then
		local found = false
		local foundElement = nil
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			local accid = tonumber(getElementData(value, "account:id"))
			if (accid) then
				if (accid==tonumber(userID)) then
					found = true
					foundElement = value
					break
				end
			end
		end
		
		if (found) then
			exports.donators:loadAllPerks(foundElement)
			outputDebugString("->call('reloadUserPerks', '".. tostring(userID) .."')=200 OK")
		else
			outputDebugString("->call('reloadUserPerks', '".. tostring(userID) .."')=402 USER NOT ONLINE")
		end
	end
end


function isPlayerOnline( userID )
	local found = false
	if (userID) then
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			local accid = tonumber(getElementData(value, "account:id"))
			if (accid) then
				if (accid==tonumber(userID)) then
					found = true
					break
				end
			end
		end
	end
	return found
end

function deleteItem(itemID, itemValue)
	if not (itemID) then
		return false
	end
	
	if not (itemValue) then
		return false
	end
	
	exports['item-system']:deleteAll(itemID, itemValue)
end

function attemptedFraud(faggot, amount1, price1, itemNumber1)
	if (faggot==nil) then
		exports.global:sendMessageToAdmins(" [FRAUD ALERT] [ERR-5993-43-5315-3-FUCK-THIS-SHIT] Please notify an administrator with access to the donation system source.")
	else
		exports.global:sendMessageToAdmins("[FRAUD ALERT] " .. faggot .. " has attempted to cheat the donation system.")
		exports.global:sendMessageToAdmins("[FRAUD ALERT] Amount Expected: $" ..price1.. " USD. ")
		exports.global:sendMessageToAdmins("[FRAUD ALERT] Amount Received: $" ..amount1.." USD.")
		exports.global:sendMessageToAdmins("[FRAUD ALERT] Item ID: " ..itemNumber1..".")
		exports.logs:logMessage("[DON-FRAUD] " ..username .. " attempted donation fraud. Amount expected: " ..price1..". Amount received: " ..amount1.. ". Item number: " .. itemNumber1 ".", 5)
	end
end

function userDonated(faggot, amount1, price1, itemNumber1)
	if (faggot==nil) then
		exports.global:sendMessageToAdmins("[DONATION] [ERR-5494-254-454-WEIMY-IS-A-FAGGOT] Please notify an administrator with access to the donation system source.")
	else
		exports.global:sendMessageToAdmins("[DONATION] " .. faggot .. " has donated $" .. amount1 .. " USD for the donation package " .. itemNumber1 ..". Package Price: $" .. price1 .." USD.")
	end
end
	
function statTransfer(userID, fromCharacterID, toCharacterID)
	if (userID) and (fromCharacterID) and (toCharacterID) then
		local fromCharacterName = exports.cache:getCharacterName(fromCharacterID)
		local toCharacterName = exports.cache:getCharacterName(toCharacterID)
		exports.global:sendMessageToAdmins("AdmWrn: User "..tostring(userID).." stat transferred from " .. fromCharacterName:gsub("_", " ") .. " to ".. toCharacterName:gsub("_", " "))
		
		-- reload vehicles
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
		local owner = getElementData(value, "owner")

			if (owner) then
				if (tonumber(owner)==tonumber(fromCharacterID)) or (tonumber(owner)==tonumber(toCharacterID)) then
					local id = getElementData(value, "dbid")
					outputDebugString("* Reloading vehicle ".. tostring(id))
					exports['vehicle-system']:reloadVehicle(id)
				end
			end
		end
		
		-- reload interiors
		for key, value in ipairs( getElementsByType("interior") ) do
			local interiorStatus = getElementData(value, "status")
			local owner = interiorStatus[4]
			if (owner) then
				if (tonumber(owner)==tonumber(fromCharacterID)) or (tonumber(owner)==tonumber(toCharacterID)) then
					local id = getElementData(value, "dbid")
					outputDebugString("* Reloading interior ".. tostring(id))
					exports['interior-system']:realReloadInterior(id)
				end
			end	
		end
		outputDebugString("* Stat transfer processed")
	end
end

function retrieveWeaponDetails(serialNumber)
	return exports.global:retrieveWeaponDetails( serialNumber )
end