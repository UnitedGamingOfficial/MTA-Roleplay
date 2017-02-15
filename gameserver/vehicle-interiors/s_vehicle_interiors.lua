local vehicles = { }

-- check all existing vehicles for interiors
addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		for key, value in ipairs( getElementsByType( "vehicle" ) ) do
			add( value )
		end
	end
)

-- cleanup code
addEventHandler( "onElementDestroy", getRootElement( ),
	function( )
		if vehicles[ source ] then
			destroyElement( vehicles[ source ] )
			vehicles[ source ] = nil
		end
	end
)

addEventHandler( "onResourceStop", getResourceRootElement( ),
	function( )
		for key, value in ipairs( getElementsByType( "vehicle" ) ) do
			if getElementData( value, "entrance" ) then
				exports['anticheat-system']:changeProtectedElementDataEx( value, "entrance" )
			end
		end
	end
)

-- code to create the pickup and set properties
local function addInterior( vehicle, targetx, targety, targetz, targetinterior )
	local intpickup = createPickup( targetx, targety, targetz, 3, 1318 )
	setElementDimension( intpickup, getElementData( vehicle, "dbid" ) + 20000 )
	setElementInterior( intpickup, targetinterior )
	
	vehicles[ vehicle ] = intpickup
	exports['anticheat-system']:changeProtectedElementDataEx( vehicle, "entrance", true )
end

-- exported, called when a vehicle is created
function add( vehicle )
	if getElementData(vehicle, "dbid") == 8726 then -- vehicle is shamal and vehid is 8726
		addInterior( vehicle, 1429, 1463, 11, 33) -- add the interior
		return true, 33 -- this is teh interior the shit was createObject'd in.
	elseif getElementModel( vehicle ) == 519 then -- Shamal
		addInterior( vehicle, 3.8, 23.1, 1199.6, 1 )
		return true, 1 -- interior id
	elseif getElementModel( vehicle ) == 508 or getElementModel( vehicle ) == 484 then
		addInterior( vehicle, 1.9, -3.2, 999.4, 2 )
		return true, 2
	--[[elseif getElementModel( vehicle ) == 435 then -- Trailer / MAXIME
		addInterior( vehicle, 1448.4056396484, 1465.1271972656, 16994.09765625, 0 )
		return true, 0 -- int]]
	else
		return false
	end
end

-- enter over right click menu
function teleportTo( player, x, y, z, dimension, interior, freeze )
	fadeCamera( player, false, 1 )
	
	setTimer(
		function( player )
			setElementDimension( player, dimension )
			setElementInterior( player, interior )
			setCameraInterior( player, interior )
			setElementPosition( player, x, y, z )
			
			triggerEvent( "onPlayerInteriorChange", player )
			
			setTimer( fadeCamera, 1000, 1, player, true, 2 )
			
			if freeze then 
				triggerClientEvent( player, "usedElevator", player ) -- DISABLED because the event was buggged for an unknown reason on client side / MAXIME
				setElementFrozen( player, true )
				setPedGravity( player, 0 )
			end
		end, 1000, 1, player
	)
end

addEvent( "enterVehicleInterior", true )
addEventHandler( "enterVehicleInterior", getRootElement( ),
	function( vehicle )
		if vehicles[ vehicle ] then
			if isVehicleLocked( vehicle ) then
				outputChatBox( "You try the door handle, but it seems to be locked.", source, 255, 0, 0 )
			else
				local exit = vehicles[ vehicle ]
				
				local x, y, z = getElementPosition( exit )
				teleportTo( source, x, y, z, getElementDimension( exit ), getElementInterior( exit ), true) 
			end
		end
	end
)

function leaveInterior( player )
	local dim = getElementDimension( player ) - 20000
	for value in pairs( vehicles ) do
		if getElementData( value, "dbid" ) == dim then
			if isVehicleLocked( value ) then
				outputChatBox( "You try the door handle, but it seems to be locked.", player, 255, 0, 0 )
			else
				local x, y, z = getElementPosition( value )
				teleportTo( player, x, y, z + 2, getElementDimension( value ), getElementInterior( value ) )
				return
			end
		end
	end
end

-- cancel picking up our pickups
function isInPickup( thePlayer, thePickup, distance )
	if not isElement(thePickup) then return false end
	
	local ax, ay, az = getElementPosition(thePlayer)
	local bx, by, bz = getElementPosition(thePickup)
	
	return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
end

function isNearExit( thePlayer, theVehicle )
	return isInPickup( thePlayer, vehicles[ theVehicle ] )
end

function checkLeavePickup( player, pickup )
	if isElement( player ) then
		if isInPickup( player, pickup ) then
			setTimer( checkLeavePickup, 500, 1, player, pickup )
		else
			unbindKey( player, "f", "down", leaveInterior )
		end
	end
end

addEventHandler( "onPickupHit", getResourceRootElement( ), 
	function( player )
		bindKey( player, "f", "down", leaveInterior )
		
		setTimer( checkLeavePickup, 500, 1, player, source )
		
		cancelEvent( )
	end
)

-- make sure we blow
addEventHandler( "onVehicleRespawn", getRootElement( ),
	function( blown )
		if blown and vehicles[ source ] then
			local dim = getElementData( source ) + 20000
			for k, v in ipairs( getElementsByType( "player" ) ) do
				if getElementDimension( v ) == dim then
					killPed( v, 0 )
				end
			end
		end
	end
)

function vehicleKnock(veh)
	local player = source
	if (player) then
		local tpd = getElementDimension(player)
		if (tpd > 20000) then
			local vid = tpd - 20000
			for key, value in ipairs( getElementsByType( "vehicle" ) ) do
				if getElementData( value, "dbid" ) == vid then
					exports.global:sendLocalText(player, " *" .. getPlayerName(player):gsub("_"," ") .. " begins to knock on the vehicle.", 255, 51, 102)
					exports.global:sendLocalText(value, " * Knocks can be heard coming from inside the vehicle. *      ((" .. getPlayerName(player):gsub("_"," ") .. "))", 255, 51, 102)
				end
			end
		else
			if vehicles[veh] then
				local exit = vehicles[veh]

				if (exit) then
					exports.global:sendLocalText(player, " *" .. getPlayerName(player):gsub("_"," ") .. " begins to knock on the vehicle.", 255, 51, 102)
					exports.global:sendLocalText(exit, " * Knocks can be heard coming from the outside. *      ((" .. getPlayerName(player):gsub("_"," ") .. "))", 255, 51, 102)
				end
			end
		end
	end
end
addEvent("onVehicleKnocking", true)
addEventHandler("onVehicleKnocking", getRootElement(), vehicleKnock)