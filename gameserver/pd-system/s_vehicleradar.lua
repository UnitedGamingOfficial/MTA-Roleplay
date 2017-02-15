--[[
--	Copyright (C) Bean - All Rights Reserved
--  Developed for the MTA roleplay community United Gaming
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Calvin Doyle <calvin.doyle@outlook.com>, February 2016
]]--

activeVehicles = { } -- All vehicles that are currently running and have a driver.
radarScanning = { } -- Stores the data of players who are using radar - helps with server usage.
lockedEntries = { } -- Used to sync the locked text specific to the vehicle.
radarTimer = { } -- Stores each timer to scan individually specific to the player who initiated it.
radarActive = false
radarFOV = 30 -- How far in degrees the radar can see. (field of view)
radarDistanceMax = 70 -- Maximum distance for radar detection.
radarDistanceMin = 20 -- Minimum distance for radar detection.
zDistance = 10 -- How much of a Z-axis difference is allowed for the vehicle to pick up another one. (hills etc)
scanFrequency = 500 -- Time between ticks in milliseconds.
leoVehicles = { [596] = true, [427] = true, [490] = true, [599] = true, [601] = true, [523] = true, [597] = true, [598] = true }
leoFactions = { [1] = true }

local function populateActiveTable( )
	activeVehicles = { }
	local vehList = exports.pool:getPoolElementsByType("vehicle")
	for _,theVehicle in ipairs(vehList) do
		local engineState = getElementData( theVehicle, "engine" )
		local hasDriver = getVehicleOccupant( theVehicle, 0 )
		if (engineState==1) and hasDriver then
			table.insert( activeVehicles, theVehicle )
		end
	end
end
addEvent( "reloadScanableVehicles", true )
addEventHandler( "reloadScanableVehicles", getRootElement( ), populateActiveTable )
addEventHandler( "onResourceStart", getResourceRootElement( ), populateActiveTable )

local function updateStatus( player, seat, jacker )
	local theVehicle = source
	if not removeVehicleFromScan( theVehicle ) then
		if ( getVehicleOccupant( theVehicle, 0 ) ) and ( getElementData( theVehicle, "engine" ) == 1 ) then
			addVehicleToScan( theVehicle )
		end
	end
end
addEventHandler( "onVehicleEnter", getRootElement( ), updateStatus )
addEventHandler( "onVehicleExit", getRootElement( ), updateStatus )

addEventHandler( "onVehicleEnter", getRootElement( ), 
	function( player )
		if radarScanning[player] then
			toggleRadar( player )
			return
		end
		if canUseRadar( player ) then
			toggleRadar( player )
		end
	end
);

addEventHandler("onResourceStart", getResourceRootElement( ),
	function( )
		for key, value in ipairs( getElementsByType("player") ) do
			setTimer( 
			function( )
				if canUseRadar( value ) then
					toggleRadar( value )
				end
			end, 500, 1 ) -- Need to add this weird delay because the client events don't load fast enough.
		end
	end
);

addEventHandler( "onVehicleExit", getRootElement( ),
	function( player )
		toggleRadar( player, true, "yes" )
	end
);


function clearTimers( )
	local allTimers = getTimers( 420 )
	for k, v in ipairs(allTimers) do
		killTimer( v )
	end
	
	for k2, v2 in pairs( radarTimer ) do
		k2 = nil
	end
end
addEventHandler( "onResourceStart", getResourceRootElement( ), clearTimers )
addEventHandler( "onResourceStop", getResourceRootElement( ), clearTimers )

addEventHandler( "onPlayerQuit", getRootElement( ),
	function( )
		if radarScanning[ source ] then
			radarScanning[ source ] = nil
			if (#radarScanning==0) then
				radarActive = false
				terminateScanning( source )
			end
		end
		
		if radarTimer[ source ] then
			killTimer( radarTimer[ source ] )
			radarTimer[ source ] = nil
		end
	end
)

function addVehicleToScan( vehicle )
	for i = 0, #activeVehicles do
		if not ( activeVehicles[ i ] == vehicle ) then
			table.insert( activeVehicles, vehicle )
		end
	end
end

function removeVehicleFromScan( vehicle )
	for i = 0, #activeVehicles do
		if ( activeVehicles[ i ] == vehicle ) then
			activeVehicles[ i ] = nil
			return true
		end
	end
	return false
end

local function getRotationDifference( rotation1, rotation2 )
	if ( ( rotation1 - rotation2 ) > 180 ) then
		rotation1 = rotation1 - 360
	elseif ( ( rotation1 - rotation2 ) < -180 ) then
		rotation1 = rotation1 + 360
	end
	return math.abs( rotation1-rotation2 )
end

local function getInverseRotation( rotation )
	local rotation = rotation - 180
	if ( rotation > 180 ) then
		rotation = rotation - 360
	elseif ( rotation < 0 ) then
		rotation = rotation + 360
	end
	return math.abs( rotation )
end
		
function isCarScannable( scannerVehicle, scannedVehicle )
	if scannerVehicle~=scannedVehicle then
		local sVX, sVY, sVZ = getElementPosition( scannerVehicle )
		local sdVX, sdVY, sdVZ = getElementPosition( scannedVehicle )
		local distanceBetweenVehicles = getDistanceBetweenPoints3D( sVX, sVY, sVZ, sdVX, sdVY, sdVZ )
		if (distanceBetweenVehicles>=radarDistanceMin) and (distanceBetweenVehicles<=radarDistanceMax) then
			if ( math.abs( sVZ - sdVZ ) <= zDistance ) then
				local _, _, sRot = getElementRotation( scannerVehicle )
				local _, _, sdRot = getElementRotation( scannedVehicle )
				if ( getRotationDifference( sRot, sdRot ) <= radarFOV ) then
					return true, 1
				end
				if ( getRotationDifference( getInverseRotation( sRot ), sdRot ) <= radarFOV ) then
					return true, 2
				end
			else
				return false, false
			end
		else
			return false, false
		end
	else
		return false, false
	end
end

function canUseRadar( player )
	if isPedInVehicle( player ) then
		local occupiedVehicle = getPedOccupiedVehicle( player )
		local vehFaction = getElementData( occupiedVehicle, "faction" )
		if leoFactions[ vehFaction ] and leoVehicles[ getElementModel( occupiedVehicle ) ] then
			if ( player == getVehicleOccupant( occupiedVehicle, 0 ) or getVehicleOccupant( occupiedVehicle, 1 ) ) then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function radarDoScan( player )
	if radarActive then
		local playerVehicle = getPedOccupiedVehicle( player )
		if playerVehicle then
			local detectedVehicle = false
			for _, scannedVehicle in pairs(activeVehicles) do
				local carScanning, radarLocation = isCarScannable( playerVehicle, scannedVehicle )
				if carScanning then
					detectedVehicle = true
					local realSpeed = math.floor( exports.global:getVehicleVelocity( scannedVehicle ) + 0.5 )
					radarScanning[player] = realSpeed
					sendInformationToClient( player, playerVehicle, realSpeed, radarLocation or 0, getElementData( playerVehicle, "lockedRadar") )
				end
			end

			if not detectedVehicle then
				sendInformationToClient( player, playerVehicle, "000", 0, getElementData( playerVehicle, "lockedRadar" ) )
			end
		end
	end
end

function applyLockedEntryToVehicle( vehicle, entry, reset )
	if ( reset==true ) then
		lockedEntries[vehicle] = nil
		removeElementData( vehicle, "lockedRadar" )
		return
	else
		lockedEntries[vehicle] = entry
		setElementData( vehicle, "lockedRadar", entry )
	end
end
addEvent( "applyLockedEntryToVehicle", true )
addEventHandler( "applyLockedEntryToVehicle", getRootElement( ), applyLockedEntryToVehicle )

function sendInformationToClient( player, vehicle, speedInfo, radarLocation, lockedRadar )
	if speedInfo then
		speedInfo = speedInfo
	elseif radarScanning[player] then
		speedInfo = radarScanning[player]
	end
	
	if radarLocation then
		radarLocation = radarLocation
	else
		radarLocation = 0
	end
	triggerClientEvent( player, "updateRadarInformation", player, speedInfo, lockedEntries[vehicle], radarLocation )
end

function initiateScanning( player )
	if not radarTimer[player] then
		radarTimer[player] = setTimer( radarDoScan, scanFrequency, 0, player )
	end
end

function terminateScanning( player )
	if (#radarScanning==0) then
		if radarTimer[player] then
			if killTimer( radarTimer[player] ) then
				radarActive = false
				radarTimer[player] = nil
			end
		end
	end
end

function toggleRadar( player, command, closeOnly )
	triggerClientEvent( player, "displayPoliceRadar", player, closeOnly )
	vehicle = getPedOccupiedVehicle( player )
	sendInformationToClient( player, nil, "000", 0, nil )
end

function buttonToggleRadar( player )
	if radarScanning[ player ] then
		radarScanning[ player ] = nil
		outputChatBox("Stopped radar scanning.", player, 255, 0, 0)
		if (#radarScanning==0) then
			radarActive = false
			terminateScanning( player )
		end
	else
		if canUseRadar( player ) then
			radarScanning[ player ] = { }
			if not radarActive then
				radarActive = true
				initiateScanning( player )
			end
			outputChatBox("Started radar scanning.", player, 0, 255, 0)
		end
	end
end
addEvent( "radarButtonToggle", true )
addEventHandler( "radarButtonToggle", getRootElement( ), buttonToggleRadar )

addCommandHandler( "checktimers", 
	function( p, c )
		if not exports.global:isPlayerScripter( p ) then return end
		local timerTable = getTimers( 420 )
		for key, value in ipairs( timerTable ) do
			if isTimer( value ) then
				local thing1, thing2, thing3 = getTimerDetails( value )
				outputChatBox("1: " .. thing1 .. ", 2: " .. thing2 .. ", 3: " .. thing3, p)
			end
		end
		if #timerTable==0 then
			outputChatBox("no timers ;o", p)
		end
	end
);

addCommandHandler("testlocked", 
	function( p, c )
		if not exports['global']:isPlayerScripter( p ) then return end
		local veh = getPedOccupiedVehicle( p )
		local data = getElementData( veh, "lockedRadar" )
		if data then
			outputChatBox("It's there, the data is: " .. data, p, 200, 200, 200)
		else
			outputChatBox("it's not there!", p, 255, 0, 0 )
		end
	end
);


addCommandHandler( "radarstatus",
	function( p, c )
	if not exports.global:isPlayerScripter( p ) then return end
		if radarActive then
			outputChatBox("The radar is active.", p, 0, 255, 0)
		elseif not radarActive then
			outputChatBox("The radar is inactive.", p, 255, 255, 0)
		else
			outputChatBox("Something VERY weird happened.", p, 255, 0, 0)
		end
	end
);

addCommandHandler("checkdata",
	function( p, c )
		if not exports.global:isPlayerScripter( p ) then return end
		local vehData = getElementData( getPedOccupiedVehicle( p ), "lockedRadar" )
		if vehData then
			outputChatBox("yes ->" .. vehData, p)
			if not lockedEntries[ getPedOccupiedVehicle( p ) ] then
				outputChatBox("its not in the thing.", p)
			end
		else
			outputChatBox("nope", p)
		end
	end
);

addCommandHandler("testtable",
	function( p, c )
		if exports.global:isPlayerScripter( p ) then
			local found = false
			for key, value in pairs( activeVehicles ) do
				local elementID = getElementData( value, "dbid" )
				outputChatBox("K: " .. key .. ", V: " .. tostring( elementID ), p)
				found = true
			end
			if not found then
				outputChatBox("theres nothing in the table!", p)
			end
		end
	end
);

addCommandHandler("getinverse",
	function( p, c, rot )
		if not exports.global:isPlayerScripter( p ) then return end
		outputChatBox( getInverseRotation( rot ), p )
	end
);

addCommandHandler("getdifference",
	function( p, c, rot1, rot2 )
		if not exports.global:isPlayerScripter( p ) then return end
		outputChatBox( getRotationDifference( rot1, rot2 ), p )
	end
);