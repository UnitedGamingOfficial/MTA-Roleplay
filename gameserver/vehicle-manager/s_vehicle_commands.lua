local mysql = exports.mysql

armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar
totalTempVehicles = 0
respawnTimer = nil
local bikeCol = createColPolygon(1861.970703125, -1835.9697265625, 1861.97265625, -1854.5107421875, 1883.892578125, -1854.5595703125, 1883.744140625, -1863.375,1901.1484375, -1858.3095703125, 1890.7646484375, -1840.1259765625, 1861.9765625, -1835.958984375)
local wangs1Col = createColPolygon(2110.2470703125, -2124.2861328125, 2160.1142578125, -2141.283203125, 2143.494140625, -2162.3798828125, 2134.7724609375, -2173.365234375, 2111.951171875, -2165.77734375, 2110.306640625, -2124.455078125)
local wangs2Col = createColPolygon(2138.9677734375, -1125.140625, 2138.65234375, -1155.388671875, 2124.37890625, -1155.615234375, 2123.4560546875, -1160.6806640625, 2114.5341796875, -1160.771484375,  2117.6103515625, -1119.68359375, 2138.9677734375, -1125.140625)
local wangs3Col = createColPolygon(563.21484375, -1256.9873046875, 571.3759765625, -1294.1748046875, 511.19921875, -1295.34375, 549.2548828125, -1261.8525390625, 563.1650390625, -1257.6083984375)

-- EVENTS
addEvent("onVehicleDelete", false)

function spinCarOut(thePlayer, commandName, targetPlayer, round)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not targetPlayer then 
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Rounds]", thePlayer, 255, 194, 14)
		else
			if not round or not tonumber(round) or tonumber( round ) % 1 ~= 0 or tonumber( round ) > 100 then
				round = 1
			end
			local targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if targetVehicle == false then
				outputChatBox("This player isn't in a vehicle!", thePlayer, 255, 0, 0)
			else
				outputChatBox("You've spun out "..getPlayerName(targetPlayer).."'s vehicle "..tostring(round).." round(s).", thePlayer)
				local delay = 50
				setTimer(function()
					setVehicleTurnVelocity ( targetVehicle, 0, 0, 0.2 )
					delay = delay + 50
				end, delay, tonumber(round))
			end
		end
	end
end
addCommandHandler("spinout", spinCarOut, false, false)

-- /unflip
function unflipCar(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or getTeamName(getPlayerTeam(thePlayer)) == "Los Santos Towing & Recovery") then
		if not targetPlayer or not exports.global:isPlayerAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in vehicle.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox("Your car was unflipped!", thePlayer, 0, 255, 0)
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("Your car was unflipped by a Hidden Admin.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Your car was unflipped by " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("You unflipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)
						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

-- /flip
function flipCar(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or getTeamName(getPlayerTeam(thePlayer)) == "Los Santos Towing & Recovery") then -- SFTR, working on motorbikes etc
		if not targetPlayer or not exports.global:isPlayerAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 180, ry, rz)
				fixVehicle (veh)
				outputChatBox("Your car was flipped!", thePlayer, 0, 255, 0)
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 180, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("Your car was flipped by a Hidden Admin.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Your car was flipped by " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("You flipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)
						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("flip", flipCar, false, false)

-- /unlockcivcars
function unlockAllCivilianCars(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local count = 0
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			if (isElement(value)) and (getElementType(value)) then
				local id = getElementData(value, "dbid")
				
				if (id) and (id>=0) then
					local owner = getElementData(value, "owner")
					if (owner==-2) then
						setVehicleLocked(value, false)
						addVehicleLogs(id, commandName, thePlayer)
						count = count + 1
					end
				end
			end
		end
		outputChatBox("Unlocked " .. count .. " civilian vehicles.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)

-- /veh
local leadplus = { [425] = true, [520] = true, [447] = true, [432] = true, [444] = true, [556] = true, [557] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [476] = true }
function createTempVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		local args = {...}
		if (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id/name] [color1] [color2]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1 = #args ~= 1 and tonumber(args[#args - 1]) or -1
			local col2 = #args ~= 1 and tonumber(args[#args]) or -1
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = #args
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd - 1
				until vehicleID or vehicleEnd == -1
				if vehicleEnd == -1 then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				elseif vehicleEnd == #args - 2 then
					col2 = -1
				elseif vehicleEnd == #args - 1 then
					col1 = -1
					col2 = -1
				end
			end
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			if vehicleID then
				local plate = tostring( getElementData(thePlayer, "account:id") )
				if #plate < 8 then
					plate = " " .. plate
					while #plate < 8 do
						plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
						if #plate < 8 then
						end
					end
				end
				
				if leadplus[ vehicleID ] and not exports.global:isPlayerLeadAdmin(thePlayer) then
					outputChatBox( "Insufficient access.", thePlayer, 255, 0, 0)
					return
				end
				
				local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)
				
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
				else
					if (armoredCars[vehicleID]) then
						setVehicleDamageProof(veh, true)
					end

					totalTempVehicles = totalTempVehicles + 1
					local dbid = (-totalTempVehicles)
					exports.pool:allocateElement(veh, dbid)
					
					setVehicleColor(veh, col1, col2, col1, col2)
					
					setElementInterior(veh, getElementInterior(thePlayer))
					setElementDimension(veh, getElementDimension(thePlayer))
					
					setVehicleOverrideLights(veh, 1)
					setVehicleEngineState(veh, false)
					setVehicleFuelTankExplodable(veh, false)
					setVehicleVariant(veh, exports['vehicle-system']:getRandomVariant(getElementModel(veh)))
					
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "dbid", dbid)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", 0)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldx", x, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldy", y, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldz", z, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "faction", -1)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "owner", -1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "job", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
					outputChatBox(getVehicleName(veh) .. " spawned with TEMP ID " .. dbid .. ".", thePlayer, 255, 194, 14)
					
					exports['vehicle-interiors']:add( veh )
					exports.logs:dbLog(thePlayer, 6, thePlayer, "VEH ".. vehicleID .. " created with ID " .. dbid)
				end
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("veh", createTempVehicle, false, false)
	
-- /oldcar
function getOldCarID(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.global:isPlayerAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end

	local oldvehid = getElementData(thePlayer, "lastvehid")
	
	if not (oldvehid) then
		outputChatBox("You have not been in a vehicle yet.", showPlayer, 255, 0, 0)
	else
		outputChatBox("Old Vehicle ID: " .. tostring(oldvehid) .. ".", showPlayer, 255, 194, 14)
		exports['anticheat-system']:changeProtectedElementDataEx(showPlayer, "vehicleManager:oldCar", oldvehid, false)
	end
end
addCommandHandler("oldcar", getOldCarID, false, false)

-- /thiscar
function getCarID(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	
	if (veh) then
		local dbid = getElementData(veh, "dbid")
		outputChatBox("Current Vehicle ID: " .. dbid, thePlayer, 255, 194, 14)
		exports['anticheat-system']:changeProtectedElementDataEx(showPlayer, "vehicleManager:oldCar", dbid, false)
	else
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("thiscar", getCarID, false, false)

-- /gotocar
function gotoCar(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )
				
				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rz)
				setElementInterior(thePlayer, getElementInterior(theVehicle))
				setElementDimension(thePlayer, getElementDimension(theVehicle))
				
				exports.logs:dbLog(thePlayer, 6, theVehicle, "GOTOCAR")
				
				addVehicleLogs(id, commandName, thePlayer)
				
				outputChatBox("Teleported to vehicles location.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)

-- /getcar
function getCar(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
				
				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end
				
				setElementInterior(theVehicle, getElementInterior(thePlayer))
				setElementDimension(theVehicle, getElementDimension(thePlayer))

				exports.logs:dbLog(thePlayer, 6, theVehicle, "GETCAR")
				
				addVehicleLogs(id, commandName, thePlayer)
				
				outputChatBox("Vehicle teleported to your location.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)

function getNearbyVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		outputChatBox("Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0
		
		for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(thePlayer, "vehicle") ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1
				
				local ownerName = ""
				
				if faction then
					if (faction>0) then
						local theTeam = exports.pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else 
					ownerName = "Car Dealership"
				end
				
				if (thisvehid) then
					outputChatBox("   " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyvehicles", getNearbyVehicles, false, false)
addCommandHandler("nearbyvehs", getNearbyVehicles, false, false)

function delNearbyVehicles(thePlayer, commandName)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		outputChatBox("Deleting Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0
		
		for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(thePlayer, "vehicle") ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1
				
				local ownerName = ""
				
				if faction then
					if (faction>0) then
						local theTeam = exports.pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else 
					ownerName = "Car Dealership"
				end
				
				if (thisvehid) then
					deleteVehicle(thePlayer, "delveh", thisvehid)
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None was deleted.", thePlayer, 255, 126, 0)
		elseif count == 1 then
			outputChatBox("   One vehicle were deleted.", thePlayer, 255, 126, 0)
		else
			outputChatBox("   "..count.." vehicles were deleted.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyvehs", delNearbyVehicles, false, false)
addCommandHandler("delnearbyvehicles", delNearbyVehicles, false, false)

function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /respawnveh [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				if isElementAttached(theVehicle) then
					detachElements(theVehicle)
				end
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
				local dbid = getElementData(theVehicle,"dbid")
				if (dbid<0) then -- TEMP vehicle
					fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
					if armoredCars[ getElementModel( theVehicle ) ] then
						setVehicleDamageProof(theVehicle, true)
					else
						setVehicleDamageProof(theVehicle, false)
					end
					setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
				else
					exports.logs:dbLog(thePlayer, 6, theVehicle, "RESPAWN")
					
					addVehicleLogs(id, commandName, thePlayer)
					
					respawnVehicle(theVehicle)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
						setVehicleLocked(theVehicle, false)
					end
				end
				outputChatBox("Vehicle respawned.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("There is already a Vehicle Respawn active, /respawnstop to stop it first.", thePlayer, 255, 0, 0)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
					local logged = getElementData(arrayPlayer, "loggedin")
					if (logged) then
						if exports.global:isPlayerLeadAdmin(arrayPlayer) then
							outputChatBox( "LeadAdmWarn: " .. getPlayerName(thePlayer) .. " executed a vehicle respawn.", arrayPlayer, 255, 194, 14)
						end
					end
				end
				
				outputChatBox("*** All vehicles will be respawned in "..timeToRespawn.." seconds! ***", getRootElement(), 255, 194, 14)
				outputChatBox("You can stop it by typing /respawnstop!", thePlayer)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local tick = getTickCount()
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local radioCounter = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		local notmoved = 0
		local deleted = 0
		
		local dimensions = { }
		for k, p in ipairs(getElementsByType("player")) do
			dimensions[ getElementDimension( p ) ] = true
		end
		
		for k, theVehicle in ipairs(vehicles) do
			if isElement( theVehicle ) then
				local dbid = getElementData(theVehicle, "dbid")
				if not (dbid) or (dbid<0) then -- TEMP vehicle
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dbid and dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						tempoccupied = tempoccupied + 1
					else
						destroyElement(theVehicle)
						tempcounter = tempcounter + 1
					end
				else
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						occupiedcounter = occupiedcounter + 1
					else
						if isVehicleBlown(theVehicle) then --or isElementInWater(theVehicle) then
							fixVehicle(theVehicle)
							if armoredCars[ getElementModel( theVehicle ) ] then
								setVehicleDamageProof(theVehicle, true)
							else
								setVehicleDamageProof(theVehicle, false)
							end
							for i = 0, 5 do
								setVehicleDoorState(theVehicle, i, 4) -- all kind of stuff missing
							end
							setElementHealth(theVehicle, 300) -- lowest possible health
							exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 1, false)
						end
						
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
						if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0 then
							if isElementAttached(theVehicle) then
								detachElements(theVehicle)
							end
							respawnVehicle(theVehicle)
							setVehicleLocked(theVehicle, false)
							unlockedcivs = unlockedcivs + 1
						else 
							local checkx, checky, checkz = getElementPosition( theVehicle )
							if getElementData(theVehicle, "respawnposition") then
								local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
							
								if (round(checkx, 6) == x) and (round(checky, 6) == y) then
									notmoved = notmoved + 1
								else
									if isElementAttached(theVehicle) then
										detachElements(theVehicle)
									end
									if getElementData(theVehicle, "vehicle:radio") ~= 0 then
										exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
										radioCounter = radioCounter + 1
									end
									setElementPosition(theVehicle, x, y, z)
									setVehicleRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
									if not getElementData(theVehicle, "carshop") then
										if isElementWithinColShape(theVehicle, wangs1Col) or isElementWithinColShape(theVehicle, wangs2Col) or isElementWithinColShape(theVehicle, wangs3Col) or isElementWithinColShape(theVehicle, bikeCol) then
											triggerEvent("onVehicleDelete", theVehicle)
											mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
											call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
											call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
											exports.logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
											destroyElement(theVehicle)
											deleted = deleted + 1
										else
											counter = counter + 1
										end
									end
								end
							else
								exports.global:sendMessageToAdmins("[RESPAWN-ALL] Vehicle #" .. dbid .. " has not been /park'ed!")
								triggerEvent("onVehicleDelete", theVehicle)
								mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
								call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
								call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
								exports.logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
								destroyElement(theVehicle)
								deleted = deleted + 1
							end
						end
						-- fix faction vehicles
						if getElementData(theVehicle, "faction") ~= -1 then
							fixVehicle(theVehicle)
							if (getElementData(theVehicle, "Impounded") == 0) then
								exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
								exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
								setTimer(setElementFrozen, 2000, 1, theVehicle, true)
								if armoredCars[ getElementModel( theVehicle ) ] then
									setVehicleDamageProof(theVehicle, true)
								else
									setVehicleDamageProof(theVehicle, false)
								end
							end
						end
					end
				end
			end
		end
		local timeTaken = (getTickCount() - tick)/1000
		outputChatBox(" =-=-=-=-=-=- All Vehicles Respawned =-=-=-=-=-=-=", getRootElement(), 255, 194, 14)
		outputChatBox("Respawned " .. counter .. "/" .. counter + notmoved .. " vehicles. (" .. occupiedcounter .. " Occupied) .", thePlayer)
		outputChatBox("Deleted " .. tempcounter .. " temporary vehicles. (" .. tempoccupied .. " Occupied).", thePlayer)
		outputChatBox("Reset " .. radioCounter .. " car radios.", thePlayer)
		outputChatBox("Unlocked and Respawned " .. unlockedcivs .. " civilian vehicles.", thePlayer)
		outputChatBox("Deleted " .. deleted .. " vehicles parked in carshops.", thePlayer)
		outputChatBox("All that in " .. timeTaken .." seconds.", thePlayer)
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			local name = getPlayerName(thePlayer):gsub("_", " ")
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				name = "Hidden Admin"
			end
			outputChatBox( "*** " .. name .. " cancelled the vehicle respawn ***", getRootElement(), 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function respawnAllCivVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if dbid and dbid > 0 then
				if getElementData(theVehicle, "owner") == -2 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then				
						if isElementAttached(theVehicle) then
							detachElements(theVehicle)
						end
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, 'i:right')
						respawnVehicle(theVehicle)
						setVehicleLocked(theVehicle, false)
						setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
						setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
						counter = counter + 1
					end
				end
			end
		end
		outputChatBox(" =-=-=-=-=-=- All Civilian Vehicles Respawned =-=-=-=-=-=-=", getRootElement(), 255, 194, 14)
		outputChatBox("Respawned " .. counter .. " civilian vehicles.", thePlayer)
	end
end
addCommandHandler("respawnciv", respawnAllCivVehicles, false, false)

function respawnAllInteriorVehicles(thePlayer, commandName, repair)
	local repair = tonumber( repair ) == 1 and exports.global:isPlayerAdmin( thePlayer )
	local dimension = getElementDimension(thePlayer)
	if dimension > 0 and ( exports.global:hasItem(thePlayer, 4, dimension) or exports.global:hasItem(thePlayer, 5, dimension) ) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			if getElementData(theVehicle, "dimension") == dimension then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						if getElementData(theVehicle, "respawnposition") then
						
						
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
							
							if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								if repair then
									respawnVehicle(theVehicle)
									
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								else
									setElementPosition(theVehicle, x, y, z)
									setVehicleRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								end
								counter = counter + 1
							end
						else
							exports.global:sendMessageToAdmins("[Respawn] There's something wrong with vehicle "..dbid)
						end
					end
				end
			end
		end
		outputChatBox("Respawned " .. counter .. " district vehicles.", thePlayer)
	else
		outputChatBox( "Ain't your place, is it?", thePlayer, 255, 0, 0 )
	end
end
addCommandHandler("respawnint", respawnAllInteriorVehicles, false, false)


function respawnDistrictVehicles(thePlayer, commandName)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local zoneName = exports.global:getElementZoneName(thePlayer)
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local deleted = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local vehicleZoneName = exports.global:getElementZoneName(theVehicle)
			if (zoneName == vehicleZoneName) then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						if getElementData(theVehicle, "respawnposition") then
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
						
							if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								setElementPosition(theVehicle, x, y, z)
								setVehicleRotation(theVehicle, rx, ry, rz)
								setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
								setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
								if not getElementData(theVehicle, "carshop") then
									if isElementWithinColShape(theVehicle, wangs1Col) or isElementWithinColShape(theVehicle, wangs2Col) or isElementWithinColShape(theVehicle, wangs3Col) or isElementWithinColShape(theVehicle, bikeCol) then
										triggerEvent("onVehicleDelete", theVehicle)
										mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
										call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
										call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
										exports.logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
										destroyElement(theVehicle)
										deleted = deleted + 1
									else
										counter = counter + 1
									end
								end
							end
						else
							triggerEvent("onVehicleDelete", theVehicle)
							mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
							call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
							call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
							exports.logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
							destroyElement(theVehicle)
							deleted = deleted + 1
						end
					end
				end
			end
		end
		exports.global:sendMessageToAdmins("AdmWrn: ".. getPlayerName(thePlayer) .." respawned " .. counter .. " and deleted " .. deleted .. " district vehicles in '"..zoneName.."'.", thePlayer)
	end
end
addCommandHandler("respawndistrict", respawnDistrictVehicles, false, false)

function addUpgrade(thePlayer, commandName, target, upgradeID)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		if not (target) or not (upgradeID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Upgrade ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					local success = addVehicleUpgrade(theVehicle, upgradeID)
					
					if not (success == false) then
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "ADDUPGRADE ".. upgradeID .. " "..	getVehicleUpgradeSlotName(upgradeID))
						
						addVehicleLogs(getElementData(theVehicle,"dbid"), commandName.." "..upgradeID, thePlayer)
						
						outputChatBox(getVehicleUpgradeSlotName(upgradeID) .. " upgrade added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Admin " .. username .. " added upgrade " .. getVehicleUpgradeSlotName(upgradeID) .. " to your vehicle.", targetPlayer)
						exports['savevehicle-system']:saveVehicleMods(theVehicle)
					else
						outputChatBox("Invalid Upgrade ID, or this vehicle doesn't support this upgrade.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("addupgrade", addUpgrade, false, false)

-- START of Vehicle Customization by Anthony

--suspensionLowerLimits
function setsuspensionLowerLimit(thePlayer, commandName, limit)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if (limit) then
			if tonumber(limit) <= 0.1 and tonumber(limit) >= -0.35 then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				if theVehicle then
				local dbid = getElementData(theVehicle, "dbid")
				exports.mysql:query_free("UPDATE vehicles SET suspensionLowerLimit = '" .. exports.mysql:escape_string( tonumber(limit) ) .. "' WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
				setVehicleHandling(theVehicle, "suspensionLowerLimit", tonumber(limit) or nil)
				outputChatBox("Vehicle suspension lower limit set to: "..tonumber(limit), thePlayer, 0, 255, 0)
				else
				outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
				end
			else
			outputChatBox("SYNTAX: /" .. commandName .. " [Limit: 0.1 to -0.35]", thePlayer, 255, 194, 14)
			end
		else
		outputChatBox("SYNTAX: /" .. commandName .. " [Limit: 0.1 to -0.35]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("sll", setsuspensionLowerLimit, false, false)

function getsuspensionLowerLimit(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
		local currentHandling = getVehicleHandling(theVehicle)
		local suspensionHeight = currentHandling["suspensionLowerLimit"]
		outputChatBox("This vehicle's lower suspension limit is: "..tonumber(suspensionHeight), thePlayer, 0, 255, 0)
		else
		outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gsll", getsuspensionLowerLimit, false, false)
addCommandHandler("getsll", getsuspensionLowerLimit, false, false)

function resetsuspensionLowerLimit(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
		local dbid = getElementData(theVehicle, "dbid")
		local model = getElementModel(theVehicle)
		local originalHandling = getOriginalHandling(model)
		local defaultLimit = originalHandling["suspensionLowerLimit"]
		--exports.mysql:query_free("UPDATE vehicles SET suspensionLowerLimit = '" .. exports.mysql:escape_string( tonumber(defaultLimit) ) .. "' WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
		exports.mysql:query_free("UPDATE vehicles SET suspensionLowerLimit = NULL WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
		setVehicleHandling(theVehicle, "suspensionLowerLimit", tonumber(defaultLimit) or nil)
		outputChatBox("Successfully reset the vehicle's lower suspension limit to: "..tonumber(defaultLimit), thePlayer, 0, 255, 0)
		else
		outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("resetsll", resetsuspensionLowerLimit, false, false)

--driveTypes
function setdriveType(thePlayer, commandName, driveType)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if (driveType) then
			if driveType == "awd" or driveType == "fwd" or driveType == "rwd" then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				if theVehicle then
				local dbid = getElementData(theVehicle, "dbid")
				exports.mysql:query_free("UPDATE vehicles SET driveType = '" .. exports.mysql:escape_string( tostring(driveType) ) .. "' WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
				setVehicleHandling(theVehicle, "driveType", tostring(driveType) or nil)
				outputChatBox("Vehicle drive type set to: "..tostring(driveType), thePlayer, 0, 255, 0)
				else
				outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
				end
			else
			outputChatBox("SYNTAX: /" .. commandName .. " [awd/fwd/rwd]", thePlayer, 255, 194, 14)
			end
		else
		outputChatBox("SYNTAX: /" .. commandName .. " [awd/fwd/rwd]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("sdt", setdriveType, false, false)

function getdriveType(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
		local currentHandling = getVehicleHandling(theVehicle)
		local driveType = currentHandling["driveType"]
		outputChatBox("This vehicle's drive type is: "..tostring(driveType), thePlayer, 0, 255, 0)
		else
		outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gdt", getdriveType, false, false)
addCommandHandler("getsdt", getdriveType, false, false)
addCommandHandler("getdt", getdriveType, false, false)

function resetdriveType(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
		local dbid = getElementData(theVehicle, "dbid")
		local model = getElementModel(theVehicle)
		local originalHandling = getOriginalHandling(model)
		local defaultType = originalHandling["driveType"]
		--exports.mysql:query_free("UPDATE vehicles SET suspensionLowerLimit = '" .. exports.mysql:escape_string( tonumber(defaultLimit) ) .. "' WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
		exports.mysql:query_free("UPDATE vehicles SET driveType = NULL WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
		setVehicleHandling(theVehicle, "driveType", tostring(defaultType) or nil)
		outputChatBox("Successfully reset the vehicle's drive type to: "..tostring(defaultType), thePlayer, 0, 255, 0)
		else
		outputChatBox("You are not in a vehicle!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("resetdt", resetdriveType, false, false)

-- END of Vehicle Customization by Anthony

function addPaintjob(thePlayer, commandName, target, paintjobID)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		if not (target) or not (paintjobID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Paintjob ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					paintjobID = tonumber(paintjobID)
					if paintjobID == getVehiclePaintjob(theVehicle) then
						outputChatBox("This Vehicle already has this paintjob.", thePlayer, 255, 0, 0)
					else
						local success = setVehiclePaintjob(theVehicle, paintjobID)
						
						if (success) then
							
							addVehicleLogs(getElementData(theVehicle,"dbid"), commandName.." "..paintjobID, thePlayer)
						
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "PAINTJOB ".. paintjobID )
							outputChatBox("Paintjob #" .. paintjobID .. " added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
							outputChatBox("Admin " .. username .. " added Paintjob #" .. paintjobID .. " to your vehicle.", targetPlayer)
							exports['savevehicle-system']:saveVehicleMods(theVehicle)
						else
							outputChatBox("Invalid Paintjob ID, or this vehicle doesn't support this paintjob.", thePlayer, 255, 0, 0)
						end
					end
				end
			end
		end
	end

end
addCommandHandler("setpaintjob", addPaintjob, false, false)

function resetUpgrades(thePlayer, commandName, target)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "RESETUPGRADES" )
					
					addVehicleLogs(getElementData(theVehicle,"dbid"), commandName, thePlayer)
					
					for key, value in ipairs(getVehicleUpgrades(theVehicle)) do
						removeVehicleUpgrade(theVehicle, value)
					end
					setVehiclePaintjob(theVehicle, 3)
					outputChatBox("Removed all upgrades from " .. targetPlayerName .. "'s vehicle.", thePlayer, 0, 255, 0)
					exports['savevehicle-system']:saveVehicleMods(theVehicle)
				end
			end
		end
	end
end
addCommandHandler("resetupgrades", resetUpgrades, false, false)

function deleteUpgrade(thePlayer, commandName, target, id)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16)  then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "DELETEUPGRADE ".. id )
					
					addVehicleLogs(getElementData(theVehicle,"dbid"), commandName.." "..id, thePlayer)
					
					local result = removeVehicleUpgrade(theVehicle, id)
					if result then
						outputChatBox("Removed upgrade ".. id .." from " .. targetPlayerName .. "'s vehicle.", thePlayer, 0, 255, 0)
						exports['savevehicle-system']:saveVehicleMods(theVehicle)
					else
						outputChatBox("Something went wrong with removing upgrade ".. id .." from " .. targetPlayerName .. "'s vehicle.", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("deleteupgrade", deleteUpgrade, false, false)
addCommandHandler("delupgrade", deleteUpgrade, false, false)

function setVariant(thePlayer, commandName, target, variant1, variant2)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16)  then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Variant 1] [Variant 2]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					variant1 = tonumber(variant1) or 255
					variant2 = tonumber(variant2) or 255
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					
					if exports['vehicle-system']:isValidVariant(getElementModel(theVehicle), variant1, variant2) then
						local a, b = getVehicleVariant(theVehicle)
						if a == variant1 and b == variant2 then
							outputChatBox("This Vehicle already has this variant.", thePlayer, 255, 0, 0)
						else
							local success = setVehicleVariant(theVehicle, variant1, variant2)
							
							if (success) then
								exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "VARIANT ".. variant1 .. " " .. variant2 )
								outputChatBox("Variant " .. variant1 .. "/" .. variant2.. " added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
								outputChatBox("Admin " .. username .. " added Variant " .. variant1 .. "/" .. variant2 .. " to your vehicle.", targetPlayer)
								exports['savevehicle-system']:saveVehicleMods(theVehicle)
								
								addVehicleLogs(getElementData(theVehicle,"dbid"), commandName.." "..variant1 or ""..variant2 or "", thePlayer)
							else
								outputChatBox("Invalid Variant ID, or this vehicle doesn't support this paintjob.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox(variant1 .. "/" .. variant2 .. " is not a valid variant for this " .. getVehicleName(theVehicle) .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end

end
addCommandHandler("setvariant", setVariant, false, false)

function findVehID(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Name]", thePlayer, 255, 194, 14)
	else
		local vehicleName = table.concat({...}, " ")
		local carID = getVehicleModelFromName(vehicleName)
		
		if (carID) then
			local fullName = getVehicleNameFromModel(carID)
			outputChatBox(fullName .. ": ID " .. carID .. ".", thePlayer)
		else
			outputChatBox("Vehicle not found.", thePlayer, 255, 0 , 0)
		end
	end
end
addCommandHandler("findvehid", findVehID, false, false)
	
-----------------------------[FIX VEH]---------------------------------
function fixPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						if (getElementData(veh, "Impounded") == 0) then
							exports['anticheat-system']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
							if armoredCars[ getElementModel( veh ) ] then
								setVehicleDamageProof(veh, true)
							else
								setVehicleDamageProof(veh, false)
							end
						end
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEH")
						
						addVehicleLogs(getElementData(veh,"dbid"), commandName, thePlayer)
						
						outputChatBox("You repaired " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Your vehicle was repaired by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)

-----------------------------[FIX VEH VIS]---------------------------------
function fixPlayerVehicleVisual(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local health = getElementHealth(veh)
						fixVehicle(veh)
						setElementHealth(veh, health)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEHVIS" )
						outputChatBox("You repaired " .. targetPlayerName .. "'s vehicle visually.", thePlayer)
						outputChatBox("Your vehicle was visually repaired by admin " .. username .. ".", targetPlayer)
						
						addVehicleLogs(getElementData(veh,"dbid"), commandName, thePlayer)
						
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixvehvis", fixPlayerVehicleVisual, false, false)

-----------------------------[BLOW CAR]---------------------------------
function blowPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						blowVehicle(veh)
						outputChatBox("You blew up " .. targetPlayerName .. "'s vehicle.", thePlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "BLOWVEH" )
						
						addVehicleLogs(getElementData(veh,"dbid"), commandName, thePlayer)
						
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("blowveh", blowPlayerVehicle, false, false)

-----------------------------[SET CAR HP]---------------------------------
function setCarHP(thePlayer, commandName, target, hp)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Health]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))
						
						if (sethp) then
							outputChatBox("You set " .. targetPlayerName .. "'s vehicle health to " .. hp .. ".", thePlayer)
							--exports.logs:logMessage("[/SETCARHP] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." set ".. targetPlayerName .. "his car to hp: " .. hp , 4)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHHP ".. hp )
							
							addVehicleLogs(getElementData(veh,"dbid"), commandName.." "..hp, thePlayer)
						else
							outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)

function fixAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
			if (not getElementData(value, "Impounded")) then
				exports['anticheat-system']:changeProtectedElementDataEx(value, "enginebroke", 0, false)
				if armoredCars[ getElementModel( value ) ] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
		end
		--outputChatBox("All vehicles repaired by Admin " .. username .. ".")
		executeCommandHandler("ann", thePlayer, "All vehicles repaired by Admin " .. username .. ".")
		exports.logs:dbLog(thePlayer, 6, { targetPlayer }, "FIXALLVEHS")
	end
end
addCommandHandler("fixvehs", fixAllVehicles)

-----------------------------[FUEL VEH]---------------------------------
function fuelPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
						triggerClientEvent(targetPlayer, "syncFuel", veh)
						outputChatBox("You refueled " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Your vehicle was refueled by admin " .. username .. ".", targetPlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FUELVEH")
						
						addVehicleLogs(getElementData(veh,"dbid"), commandName, thePlayer)
						
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			exports['anticheat-system']:changeProtectedElementDataEx(value, "fuel", 100, false)
		end
		--outputChatBox("All vehicles refuelled by Admin " .. username .. ".")
		executeCommandHandler("ann", thePlayer, "All vehicles refuelled by Admin " .. username .. ".")
		exports.logs:dbLog(thePlayer, 6, { thePlayer  }, "FUELVEHS" )
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)

-----------------------------[SET COLOR]---------------------------------
function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Colors ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						-- parse colors
						local colors = {...}
						local col = {}
						for i = 1, math.min( 4, #colors ) do
							local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
							if r and g and b then
								col[i] = {r=r, g=g, b=b}
							elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
								col[i] = math.floor(tonumber(colors[i]))
							else
								outputChatBox("Invalid color: " .. colors[i], thePlayer, 255, 0, 0)
								return
							end
						end
						if not col[2] then col[2] = col[1] end
						if not col[3] then col[3] = col[1] end
						if not col[4] then col[4] = col[2] end
						
						local set = false
						if type( col[1] ) == "number" then
							set = setVehicleColor(veh, col[1], col[2], col[3], col[4])
						else
							set = setVehicleColor(veh, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
						end
						
						if set then
							outputChatBox("Vehicle's color was set.", thePlayer, 0, 255, 0)
							exports['savevehicle-system']:saveVehicleMods(veh)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHICLECOLOR ".. table.concat({...}, " ") )
							
							addVehicleLogs(getElementData(veh,"dbid"), commandName..table.concat({...}, " "), thePlayer)
							
						else
							outputChatBox("Invalid Color ID.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)
-----------------------------[GET COLOR]---------------------------------
function getAVehicleColor(thePlayer, commandName, carid)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (carid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Car ID]", thePlayer, 255, 194, 14)
		else
			local acar = nil
			for i,c in ipairs(getElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(carid)) then
					acar = c
				end
			end
			if acar then
				local col =  { getVehicleColor(acar, true) }
				outputChatBox("Vehicle's colors are:", thePlayer)
				outputChatBox("1. " .. col[1].. "," .. col[2] .. "," .. col[3] .. " = " .. ("#%02X%02X%02X"):format(col[1], col[2], col[3]), thePlayer)
				outputChatBox("2. " .. col[4].. "," .. col[5] .. "," .. col[6] .. " = " .. ("#%02X%02X%02X"):format(col[4], col[5], col[6]), thePlayer)
				outputChatBox("3. " .. col[7].. "," .. col[8] .. "," .. col[9] .. " = " .. ("#%02X%02X%02X"):format(col[7], col[8], col[9]), thePlayer)
				outputChatBox("4. " .. col[10].. "," .. col[11] .. "," .. col[12] .. " = " .. ("#%02X%02X%02X"):format(col[10], col[11], col[12]), thePlayer)
			else
				outputChatBox("Invalid Car ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("getcolor", getAVehicleColor, false, false)

function removeVehicle(thePlayer, commandName, id)
	if exports.global:isPlayerHeadAdmin(thePlayer) then
		local dbid = tonumber(id)
		if not dbid or dbid%1~=0 or dbid <=0 then
			dbid = getElementData(thePlayer, "vehicleManager:deletedVeh") or false
			if not dbid then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		local query1 = mysql:query("SELECT `deleted` FROM `vehicles` WHERE id='" .. mysql:escape_string(dbid) .. "'") 
		local row = {}
		if query1 then
			row = mysql:fetch_assoc(query1) or false
			mysql:free_result(query1)
		end
		if not row then 
			outputChatBox(" No such vehicle with ID #"..dbid.." found in Database.", thePlayer, 255, 0, 0)
			return false
		elseif row["deleted"] == "0" then
			outputChatBox(" Please use /delveh "..dbid.." first.", thePlayer, 255, 0, 0)
			return false
		else
			local theVehicle = exports["vehicle-system"]:loadOneVehicle(dbid, false, true)
			if theVehicle then
				outputChatBox("Deleted "..(clearVehicleInventory(theVehicle) or "0").." item(s) from vehicle's inventory.",thePlayer)
			else
				outputChatBox("Failed to clear vehicle's inventory.",thePlayer, 255,0,0)
				outputDebugString("[VEH MANAGER] Failed to clear vehicle's inventory.")
			end
			
			triggerEvent("onVehicleDelete", theVehicle)
			destroyElement(theVehicle)
			mysql:query_free("DELETE FROM `vehicles` WHERE `id`='" .. mysql:escape_string(dbid) .. "'")
			mysql:query_free("DELETE FROM `vehicle_logs` WHERE `vehID`='" .. mysql:escape_string(dbid) .. "'")
			call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )				
			
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has removed vehicle ID: #" .. dbid .. " completely from SQL.")
			else
				exports.global:sendMessageToAdmins("[VEHICLE]: A hidden admin has removed vehicle ID: #" .. dbid .. " completely from SQL.")
			end
			return true
		end
	else
		outputChatBox("You don't have permission to remove vehicles from SQL.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("removeveh", removeVehicle, false, false)
addCommandHandler("removevehicle", removeVehicle, false, false)

function clearVehicleInventory(theVehicle)
	if theVehicle then
		local count = 0
		for key, item in pairs(exports["item-system"]:getItems(theVehicle)) do 
			exports.global:takeItem(theVehicle, item[1], item[2])
			count = count + 1
		end
		return count
	else
		outputDebugString("[VEH MANAGER] / vehicle commands / clearVehicleInventory() / element not found.")
		return false
	end
end

function adminClearVehicleInventory(thePlayer, commandName, vehicle)
	if exports.global:isPlayerAdmin(thePlayer) then
		vehicle = tonumber(vehicle)
		if vehicle and (vehicle%1==0) then
			for _, theVehicle in pairs(getElementsByType("vehicle")) do
				if getElementData(theVehicle, "dbid") == vehicle then
					vehicle = theVehicle
					break
				end
			end
		end
		
		if not isElement(vehicle) then
			vehicle = getPedOccupiedVehicle(thePlayer) or false
		end
		
		if not vehicle then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]     -> Clear all items in a vehicle inventory.", thePlayer, 255, 194, 14)
			outputChatBox("SYNTAX: /" .. commandName .. "          -> Clear all items in current vehicle inventory.", thePlayer, 255, 194, 14)
			return false
		end
		
		outputChatBox("Deleted "..(clearVehicleInventory(vehicle) or "0").." item(s) from vehicle's inventory.",thePlayer)
		
	else
		outputChatBox("Only Admins can perform this command. Operation cancelled.", thePlayer, 255,0,0)
	end
end
addCommandHandler("clearvehinv", adminClearVehicleInventory, false, false)
addCommandHandler("clearvehicleinventory", adminClearVehicleInventory, false, false)

function restoreVehicle(thePlayer, commandName, id)
	if exports.global:isPlayerFullAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16)	then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account:id")
			if not theVehicle then
				if mysql:query_free("UPDATE `vehicles` SET `deleted`='0', `chopped`='0' WHERE `id`='" .. mysql:escape_string(dbid) .. "'") then
					call( getResourceFromName( "vehicle-system" ), "loadOneVehicle", dbid )
					outputChatBox("   Restoring vehicle ID #"..dbid.."...", thePlayer)
					setTimer(function()
						outputChatBox("   Restoring vehicle ID #"..dbid.."...Done!", thePlayer)
						local theVehicle1 = exports.pool:getElement("vehicle", dbid)
						exports.logs:dbLog(thePlayer, 6, { theVehicle1 }, "RESTOREVEH" )
						addVehicleLogs(dbid, commandName, thePlayer)
						
						local vehicleID = getElementModel(theVehicle1)
						local vehicleName = getVehicleNameFromModel(vehicleID)
						local owner = getElementData(theVehicle1, "owner")
						local faction = getElementData(theVehicle1, "faction")
						local ownerName = ""
						if faction then
							if (faction>0) then
								local theTeam = exports.pool:getElement("team", faction)
								if theTeam then
									ownerName = getTeamName(theTeam)
								end
							elseif (owner==-1) then
								ownerName = "Admin Temp Vehicle"
							elseif (owner>0) then
								ownerName = exports['cache']:getCharacterName(owner, true)
							else
								ownerName = "Civilian"
							end
						else 
							ownerName = "Car Dealership"
						end
						
						if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						else
							exports.global:sendMessageToAdmins("[VEHICLE]: A hidden admin has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						end
					end, 2000,1)
					
				else
					outputChatBox(" Database Error!", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox(" Vehicle ID #"..dbid.." is existed in game, please use /delveh first.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restoreveh", restoreVehicle, false, false)
addCommandHandler("restorevehicle", restoreVehicle, false, false)

function deleteVehicle(thePlayer, commandName, id)
	if exports.global:isPlayerFullAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16)	then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account:id")
			if theVehicle then
				local vehicleID = getElementModel(theVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(theVehicle, "owner")
				local faction = getElementData(theVehicle, "faction")
				local ownerName = ""
				if faction then
					if (faction>0) then
						local theTeam = exports.pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else 
					ownerName = "Car Dealership"
				end
				
				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					mysql:query_free("UPDATE `vehicles` SET `deleted`='"..tostring(adminID).."' WHERE `id`='" .. mysql:escape_string(dbid) .. "'")
					exports.logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
					destroyElement(theVehicle)
					
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
					else
						exports.global:sendMessageToAdmins("[VEHICLE]: A hidden admin has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
					end
					addVehicleLogs(dbid, commandName, thePlayer)
					
					exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "vehicleManager:deletedVeh", dbid, false)
				end
				outputChatBox("   Deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").", thePlayer, 255, 126, 0)
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)
addCommandHandler("deletevehicle", deleteVehicle, false, false)

-- DELTHISVEH
function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.global:isPlayerFullAdmin(thePlayer)) or exports.donators:hasPlayerPerk(thePlayer, 16)	then
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			if dbid > 0 then
				deleteVehicle(thePlayer, "delveh", dbid)
			end
		end
	else
		outputChatBox("You do not have the permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
	return
	end
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)

function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		if not (vehicleID) or not (factionID) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [vehicleID] [factionID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local factionElement = exports.pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
						return
					end
				end
			
				mysql:query_free("UPDATE `vehicles` SET `owner`='".. mysql:escape_string(owner) .."', `faction`='" .. mysql:escape_string(factionID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
				
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Done.", thePlayer)
				
				
				addVehicleLogs(vehicleID, theCommand.." "..factionID, thePlayer)
			else
				outputChatBox("No vehicle with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)
addCommandHandler("setvehfaction", setVehicleFaction)

--Adding/Removing tint
function setVehTint(admin, command, target, status)
	if exports.global:isPlayerSuperAdmin(admin) or exports.donators:hasPlayerPerk(admin, 16) then
		if not (target) or not (status) then
			outputChatBox("SYNTAX: /" .. command .. " [player] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, target)
			
			if (targetPlayer) then
				local pv = getPedOccupiedVehicle(targetPlayer)
				if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if (stat == 1) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("setTintName", pv, player)
							end
						end
						
						exports['anticheat-system']:changeProtectedElementDataEx(pv, "tinted", true, true)
						triggerClientEvent("tintWindows", pv)
						outputChatBox("You have added tint to vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " added tint to vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						
						exports.logs:dbLog(admin, 6, {pv, targetPlayer}, "SETVEHTINT 1" )
						
						addVehicleLogs(vid, command.." on", admin)
						
					elseif (stat == 0) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("resetTintName", pv, player)
							end
						end
						exports['anticheat-system']:changeProtectedElementDataEx(pv, "tinted", false, true)
						triggerClientEvent("tintWindows", pv)
						outputChatBox("You have removed tint from vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " removed tint from vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						exports.logs:dbLog(admin, 4, {pv, targetPlayer}, "SETVEHTINT 0" )
						addVehicleLogs(vid, command.." off", admin)
					end
				else
					outputChatBox("Player not in a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("setvehtint", setVehTint)

function setVehiclePlate(thePlayer, theCommand, vehicleID, ...)
	if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
		if not (vehicleID) or not (...) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [vehicleID] [Text]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			if theVehicle then
				if exports['vehicle-system']:hasVehiclePlates(theVehicle) then
					local plateText = table.concat({...}, " ")
					if (exports['vehicle-plate-system']:checkPlate(plateText)) then
						local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(plateText).."'")
						if (tonumber(cquery["no"]) == 0) then
							local insertnplate = mysql:query_free("UPDATE vehicles SET plate='" .. mysql:escape_string(plateText) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports['vehicle-system']:reloadVehicle(tonumber(vehicleID))
							local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							outputChatBox("Done.", thePlayer)
							
							addVehicleLogs(vehicleID, theCommand.." "..plateText, thePlayer)
						else
							outputChatBox("This plate is already in use! =( umadbro?", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid plate text specified.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("This vehicle doesn't have any plates.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehicleplate", setVehiclePlate)
addCommandHandler("setvehplate", setVehiclePlate)

--[[
function deleteVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			if theVehicle then
				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
						mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
						call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
						call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
						exports.logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
						destroyElement(theVehicle)
						--exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					else
						outputChatBox("You do not have permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
						return
					end
				end
				outputChatBox("Vehicle deleted.", thePlayer)
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)

]]

-- /entercar
function warpPedIntoVehicle2(player, car, ...)
	local dimension = getElementDimension(player)
	local interior = getElementInterior(player)
	
	setElementDimension(player, getElementDimension(car))
	setElementInterior(player, getElementInterior(car))
	if warpPedIntoVehicle(player, car, ...) then
		exports['anticheat-system']:changeProtectedElementDataEx(player, "realinvehicle", 1, false)
		return true
	else
		setElementDimension(player, dimension)
		setElementInterior(player, interior)
	end
	return false
end

function enterCar(thePlayer, commandName, targetPlayerName, targetVehicle, seat)
	if exports.global:isPlayerAdmin(thePlayer) then
		targetVehicle = tonumber(targetVehicle)
		seat = tonumber(seat)
		if targetPlayerName and targetVehicle then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				local theVehicle = exports.pool:getElement("vehicle", targetVehicle)
				if theVehicle then
					if seat then
						local occupant = getVehicleOccupant(theVehicle, seat)
						if occupant then
							removePedFromVehicle(occupant)
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has put " .. targetPlayerName .. " onto your seat.", occupant)
							exports['anticheat-system']:changeProtectedElementDataEx(occupant, "realinvehicle", 0, false)
						end
						
						if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
							
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
							outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
						else
							outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
						end
					else
						local found = false
						local maxseats = getVehicleMaxPassengers(theVehicle) or 2
						for seat = 0, maxseats  do
							local occupant = getVehicleOccupant(theVehicle, seat)
							if not occupant then
								found = true
								if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
									outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
									outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
								else
									outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
								end
								break
							end
						end
						
						if not found then
							outputChatBox("No free seats.", thePlayer, 255, 0, 0)
						end
					end
					
					addVehicleLogs(targetVehicle, commandName.." "..targetPlayerName, thePlayer)
				else
					outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [player] [car ID] [seat]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("entercar", enterCar, false, false)
addCommandHandler("enterveh", enterCar, false, false)
addCommandHandler("entervehicle", enterCar, false, false)

function switchSeat(thePlayer, commandName, seat)
	if not tonumber(seat) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Seat]" ,thePlayer, 255, 194, 14)
	else
		seat = tonumber(seat)
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local maxSeats = getVehicleMaxPassengers(theVehicle)
			if seat <= maxSeats then
				local occupant = getVehicleOccupant(theVehicle, seat)
				if not occupant then
					warpPedIntoVehicle2(thePlayer, theVehicle, seat)
					outputChatBox("You switched into seat "..seat..".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
		end
	end						
end
addCommandHandler("switchseat", switchSeat, false, false)