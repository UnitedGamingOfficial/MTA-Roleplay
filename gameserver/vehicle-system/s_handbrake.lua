function toggleHandbrake( player, vehicle )
	local handbrake = getElementData(player, "handbrake") or isElementFrozen(vehicle) and 1 or 0
	if (handbrake == 0) then
		if isVehicleOnGround(vehicle) or getVehicleType(vehicle) == "Boat" or getVehicleType(vehicle) == "Helicopter" or getElementDimension(vehicle) ~= 0 or getElementModel(vehicle) == 573 then -- 573 = Dune
		local speedx, speedy, speedz = getElementVelocity (vehicle)
		local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
			--outputDebugString(actualspeed)
			if actualspeed < 0.2 then
				setElementFrozen(vehicle, true)
				outputChatBox("Handbrake has been applied.", player, 0, 255, 0)
				exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 1, false)
			else
				setControlState ( player, "brake_reverse", true )
				setTimer(function ()
					setElementFrozen(vehicle, true)
					outputChatBox("Handbrake has been applied.", player, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 1, false)
					setControlState ( player, "brake_reverse", false )
				end, actualspeed*2500, 1)
			end
		else
			outputChatBox("You can only apply the handbrake when your vehicle is on the ground.", player, 255, 0, 0)
		end
	else
		exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 0, false)
		setElementFrozen(vehicle, false) 
		outputChatBox("Handbrake has been released.", player, 0, 255, 0)
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
	end
	
end

function cmdHandbrake(sourcePlayer)
	if isPedInVehicle ( sourcePlayer ) and (getElementData(sourcePlayer,"realinvehicle") == 1)then
		local playerVehicle = getPedOccupiedVehicle ( sourcePlayer )
		if (getVehicleOccupant(playerVehicle, 0) == sourcePlayer) then
			toggleHandbrake( sourcePlayer, playerVehicle )
		else
			outputChatBox("You need to be the driver to control the handbrake...", sourcePlayer, 255, 0, 0)
		end
	else
		outputChatBox("You are not in a vehicle.", sourcePlayer, 255, 0, 0)
	end
end
addCommandHandler("handbrake", cmdHandbrake)

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler( "vehicle:handbrake", root, function( ) if getVehicleType( source ) == "Trailer" then toggleHandbrake( client, source ) end end )
