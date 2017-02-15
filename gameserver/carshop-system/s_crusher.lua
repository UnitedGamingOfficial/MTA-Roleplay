-- reverse carshop
local mysql = exports.mysql
local cOutsideCol = createColCuboid(2624.419921875, -2144.0205078125, 12.6, 78.5, 77.5, 6)
local cPathwayCol = createColCuboid(2559.3515625, -2121, 12.6, 15, 7.7, 6)
local cPathwayContinueCol = createColCuboid(2576.4345703125, -2120.953125, 12.6, 15, 7.7, 6)
local saveTimer = nil
local crushable = false
local curReleasePos = 1
--local curReleaseRow
local releaseCor = {
	{
		{ 2697, -2068, 13.35 },
		{ 2697, -2072, 13.35 },
		{ 2697, -2076, 13.35 },
		{ 2697, -2080, 13.35 },
		{ 2697, -2084, 13.35 },
		{ 2697, -2088, 13.35 },
		{ 2679, -2092, 13.35 },
		{ 2679, -2096, 13.35 },
		{ 2679, -2100, 13.35 },
		{ 2679, -2104, 13.35 },
		{ 2679, -2108, 13.35 },
		{ 2679, -2112, 13.35 },
		{ 2679, -2116, 13.35 },
		{ 2679, -2120, 13.35 },
		{ 2679, -2124, 13.35 },
		{ 2679, -2128, 13.35 },
		{ 2679, -2132, 13.35 }
	}
}

function getReleaseNumber()
	local resultOne = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='releasePos' LIMIT 1")
	curReleasePos = tonumber(resultOne["value"])
	--[[local resultTwo = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='releasePosRow' LIMIT 1")
	curReleaseRow = tonumber(resultTwo["value"])]]
	saveTimer = setTimer(savePos, 180000, 1)
end
addEventHandler("onResourceStart", getRootElement(), getReleaseNumber)

function savePos(thePlayer)
	local result = mysql:query_free("UPDATE settings SET value = '" .. mysql:escape_string( curReleasePos ) .. "' WHERE name = 'releasePos'")
	--local resultTwo = mysql:query_free("UPDATE settings SET value = '" .. mysql:escape_string( curReleaseRow ) .. "' WHERE name = 'releasePosRow'")
	if not result then
		outbutDebugString("ERROR Crush-0001 while saving vehicles!", 2)
		exports.global:sendMessageToAdmins("CRITICAL SCRIPT ERROR! Error Crush-0001 has been encountered! Please notify a head+ admin!")
	end
	--[[if not resultTwo then
		outbutDebugString("ERROR Crush-0001 while saving vehicles!", 2)
		exports.global:sendMessageToAdmins("CRITICAL SCRIPT ERROR! Error Crush-0001 has been encountered! Please notify a head+ admin!")
	end]]
	if saveTimer then killTimer(saveTimer) end
	if thePlayer then
		outputChatBox("Done.", thePlayer, 0, 255, 0)
	end
	saveTimer = setTimer(savePos, 180000, 1)
end
addCommandHandler("saveCrusherPos", savePos, false, false)

function showInformation(thePlayer, matching)
	if isElement(thePlayer) and matching and getElementType(thePlayer) == "player" then
		outputChatBox("Welcome to the Sanitary Andreas vehicle crusher facility.", thePlayer, 0, 255, 0)
		outputChatBox("We'd be pleased to crush your vehicle! Please drive down the path.", thePlayer, 255, 194, 14)
	end
end
addEventHandler( "onColShapeHit", cPathwayCol, showInformation)

function resetPrice(theVehicle, matching)
	if isElement(theVehicle) and matching and getElementType(theVehicle) == "vehicle" then
		if getElementData(theVehicle, "crushing") then
			exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "crushing")
			
			local thePlayer = getVehicleOccupant(theVehicle)
			if thePlayer then
				outputChatBox("Come back when you've thought about it!", thePlayer, 255, 194, 14)
			end
		end
	end
end
addEventHandler( "onColShapeLeave", cOutsideCol, resetPrice)
--

local vehiclecount = { }
function countVehicles( )
	vehiclecount = {}
	for key, value in pairs( getElementsByType( "vehicle" ) ) do
		if isElement( value ) then
			local model = getElementModel( value )
			if vehiclecount[ model ] then
				vehiclecount[ model ] = vehiclecount[ model ] + 1
			else
				vehiclecount[ model ] = 1
			end
		end
	end
end

function getVehiclePrice(theVehicle)
	local model = getElementModel(theVehicle)
	for k, v in ipairs(shops) do
		local veek = v["prices"]
		for key, value in ipairs(veek) do
			if getVehicleModelFromName(value[1]) == model then
				return math.ceil(tonumber( value[2] or 0 + ( vehiclecount[ model ] * 600 )) / 300) * 100 -- 1/3 of the price, round to $100
				--return value[2] -- 100%
			end
		end
	end
	return 0
end

function getPriceFromModel(model)
	--local model = getElementModel(theVehicle)
	for k, v in ipairs(shops) do
		local veek = v["prices"]
		for key, value in ipairs(veek) do
			if getVehicleModelFromName(value[1]) == model then
				return value[2]
			end
		end
	end
	return false
end

--
--[[
local cRampDown = createColSphere(2189.283203125, -1979.375, 13.552169799805, 3)
local pRampDown = createPickup(2189.283203125, -1979.375, 13.552169799805, 3, 1239)]]

function showMoreInformation(thePlayer, matching, theVehicle)
	if isElement(thePlayer) and matching and getElementType(thePlayer) == "player" then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle and getVehicleOccupant(theVehicle) == thePlayer then -- player is driver
			if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
				local price = getVehiclePrice(theVehicle)
				if getElementData(theVehicle, "requires.vehpos") then
					outputChatBox("I'm busy at the moment, come back later.", thePlayer, 255, 0, 0)
				elseif price == 0 then
					outputChatBox("This " .. getVehicleName(theVehicle) .. " ain't worth anything.", thePlayer, 255, 0, 0 )
					outputChatBox("(( Contact an admin to sell your special vehicle. ))", thePlayer, 255, 194, 14)
					crushable = false
				else
					if getElementData(theVehicle, "crushing") then
						outputChatBox("My Price still stands - $" .. exports.global:formatMoney(getElementData(theVehicle, "crushing")) .. " for it.", thePlayer, 0, 255, 0)
						crushable = true
					else
						outputChatBox("Hey, nice " .. getVehicleName(theVehicle) .. ", I could give you $" .. exports.global:formatMoney(price) .. " for it, alright?", thePlayer, 0, 255, 0)
						setElementData(theVehicle, "crushing", price, false)
						crushable = true
					end
					outputChatBox("(( Drive the " .. getVehicleName(theVehicle) .. " into the courtyard to delete it. ))", thePlayer, 255, 194, 14)
					outputChatBox("(( This will permanently delete your vehicle. ))", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Got the Registration for that? Sorry, Bro', can't touch it then.", thePlayer, 255, 0, 0)
				crushable = false
			end
		else
			outputChatBox("Come back when you've got a car to crush!", thePlayer, 255, 0, 0)
			crushable = false
		end
	end
end
addEventHandler( "onColShapeHit", cPathwayContinueCol, showMoreInformation)

function crushCar(theVehicle, thePlayer)
	if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
		local price = getElementData(theVehicle, "crushing")
		if price and price > 0 then
			local dbid = getElementData(theVehicle, "dbid")			
			local result = mysql:query_free("UPDATE `vehicles` SET `owner`='-1', `faction`='5', `enginebroke`='1', `locked`='0', `engine`='0', `lights`='0', `wheelStates`='[ [ 2, 2, 2, 2 ] ]', `panelStates`='[ [ 3, 3, 3, 3, 3, 3, 3 ] ]', `doorStates`='[ [ 4, 4, 4, 4, 4, 4 ] ]' WHERE id = '" .. mysql:escape_string(dbid) .. "'")
			if result then				
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "owner", -1, true)
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "faction", 5, true)
				exports.global:giveMoney(thePlayer, price)
				call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
				call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
				exports['global']:takeItem(veh, 3, vehID)
				outputChatBox("You crushed your " .. getVehicleName(theVehicle) .. " for $" .. exports.global:formatMoney(price) .. ".", thePlayer, 0, 255, 0)	
				exports.global:sendMessageToAdmins("Removing vehicle #" .. dbid .. " (Crushed by " .. getPlayerName(thePlayer):gsub("_", " ") .. ").")	
				exports.logs:dbLog(thePlayer, 6, (theVehicle), "CRUSHERDELETED ".. price)
				removePedFromVehicle(thePlayer)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0)		
				local rotX, rotY, rotZ = getElementRotation(theVehicle)
				setElementRotation(theVehicle, rotX, rotY, 270)
				setElementPosition(theVehicle, releaseCor[1][curReleasePos][1], releaseCor[1][curReleasePos][2], releaseCor[1][curReleasePos][3])
				setElementFrozen(theVehicle, true)
				curReleasePos = curReleasePos + 1
				if curReleasePos > 17 then
					curReleasePos = 1
					--curReleaseRow = curReleaseRow + 1
				end
				local x, y, z = getElementPosition(theVehicle)
				local rx, ry, rz = getElementRotation(theVehicle)
				local parkPositionUpdate = mysql:query_free("UPDATE `vehicles` SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "' WHERE id = '" .. mysql:escape_string(dbid) .. "'")
				if not parkPositionUpdate then
					outputChatBox("Error 9002 - Report on Forums.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Error 9004 - Report on Forums.", thePlayer, 255, 0, 0)
			end
		end
	end
end

function Crusher(element, matchingDimension, theVehicle)
	if isElement(element) then
		if getElementType(element) == "player" then
			local triggerPlayer = player
			return
		end
		if getElementType(element) == "vehicle" then
			local theVehicle = element
			if matchingDimension then
				local occupants = getVehicleOccupants(theVehicle)
				local thePlayer = occupants[0]
				if theVehicle then
					if crushable then
						local dbid = getElementData(theVehicle, "dbid")
						setVehicleDoorState(theVehicle, 0, 4)
						setVehicleDoorState(theVehicle, 1, 4)
						setVehicleDoorState(theVehicle, 2, 4)						
						setVehicleDoorState(theVehicle, 3, 4)
						setVehicleDoorState(theVehicle, 4, 4)
						setVehicleDoorState(theVehicle, 5, 4)
						setVehiclePanelState(theVehicle, 0, 3)
						setVehiclePanelState(theVehicle, 1, 3)	
						setVehiclePanelState(theVehicle, 2, 3)	
						setVehiclePanelState(theVehicle, 3, 3)	
						setVehiclePanelState(theVehicle, 4, 3)	
						setVehiclePanelState(theVehicle, 5, 3)	
						setVehiclePanelState(theVehicle, 6, 3)							
						setVehicleWheelStates(theVehicle, 2, 2, 2, 2)
						setVehicleLocked(theVehicle, false)
						setVehicleDamageProof(theVehicle, false)
						setVehicleLightState(theVehicle, 0, 1)
						setVehicleLightState(theVehicle, 1, 1)
						setVehicleLightState(theVehicle, 2, 1)	
						setVehicleLightState(theVehicle, 3, 1)	
					    setVehicleEngineState(theVehicle, false)
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "enginebroke", 1, true)						
						crushCar(theVehicle, thePlayer)
					else
						--outputChatBox("I already told you that I cannot crush that car.", triggerPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end		   
addEventHandler("onColShapeHit", cOutsideCol, Crusher)