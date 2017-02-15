
----------------------------[GO TO PLAYER]---------------------------------------
function gotoPlayer(thePlayer, commandName, target)
	if exports.global:isPlayerAdmin(thePlayer) then
		if commandName:lower() == "goto" then
			if not (target) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
			else
				local username = getPlayerName(thePlayer):gsub("_"," ")
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
				
				if targetPlayer then
					local logged = getElementData(targetPlayer, "loggedin")
					
					if (logged==0) then
						outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
					else
						detachElements(thePlayer)
						local x, y, z = getElementPosition(targetPlayer)
						local interior = getElementInterior(targetPlayer)
						local dimension = getElementDimension(targetPlayer)
						local r = getPedRotation(targetPlayer)
						
						-- Maths calculations to stop the player being stuck in the target
						x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
						y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
						
						setCameraInterior(thePlayer, interior)
						
						if (isPedInVehicle(thePlayer)) then
							local veh = getPedOccupiedVehicle(thePlayer)
							setVehicleTurnVelocity(veh, 0, 0, 0)
							setElementInterior(thePlayer, interior)
							setElementDimension(thePlayer, dimension)
							setElementInterior(veh, interior)
							setElementDimension(veh, dimension)
							setElementPosition(veh, x, y, z + 1)
							warpPedIntoVehicle ( thePlayer, veh ) 
							setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						else
							setElementPosition(thePlayer, x, y, z)
							setElementInterior(thePlayer, interior)
							setElementDimension(thePlayer, dimension)
						end
						outputChatBox(" You have teleported to player " .. targetPlayerName .. ".", thePlayer)
						outputChatBox(" Admin " .. username .. " has teleported to you. ", targetPlayer)
					end
				end
			end
		else
			local username = getPlayerName(thePlayer)
			local logged = getElementData(target, "loggedin")	
			if (logged==0) then
				outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
			else
				detachElements(thePlayer)
				local x, y, z = getElementPosition(target)
				local interior = getElementInterior(target)
				local dimension = getElementDimension(target)
				local r = getPedRotation(target)
				
				-- Maths calculations to stop the player being stuck in the target
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
				
				setCameraInterior(thePlayer, interior)
				
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setVehicleTurnVelocity(veh, 0, 0, 0)
					setElementInterior(thePlayer, interior)
					setElementDimension(thePlayer, dimension)
					setElementInterior(veh, interior)
					setElementDimension(veh, dimension)
					setElementPosition(veh, x, y, z + 1)
					warpPedIntoVehicle ( thePlayer, veh ) 
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
				else
					setElementPosition(thePlayer, x, y, z)
					setElementInterior(thePlayer, interior)
					setElementDimension(thePlayer, dimension)
				end
				outputChatBox(" You have accepted teleport request from " .. getPlayerName(target):gsub("_", " ") .. ".", thePlayer)
				outputChatBox(" Admin " .. username .. " has accepted your teleport request.", target)
			end
		end
	end
end
addCommandHandler("goto", gotoPlayer, false, false)

function getPlayer(thePlayer, commandName, from, to)
	if exports.global:isPlayerAdmin(thePlayer) then
		if(not from or not to) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Sending Player] [To Player]", thePlayer, 255, 194, 14)
		else
			local admin = getPlayerName(thePlayer):gsub("_"," ")
			local fromplayer, targetPlayerName1 = exports.global:findPlayerByPartialNick(thePlayer, from)
			local toplayer, targetPlayerName2 = exports.global:findPlayerByPartialNick(thePlayer, to)
			
			if(fromplayer and toplayer) then
				local logged1 = getElementData(fromplayer, "loggedin")
				local logged2 = getElementData(toplayer, "loggedin")
				
				if(not logged1 or not logged2) then
					outputChatBox("At least one of the players is not logged in.", thePlayer, 255, 0 , 0)
				else
					detachElements(fromplayer)
					local x, y, z = getElementPosition(toplayer)
					local interior = getElementInterior(toplayer)
					local dimension = getElementDimension(toplayer)
					local r = getPedRotation(toplayer)
					
					-- Maths calculations to stop the target being stuck in the player
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )

					if (isPedInVehicle(fromplayer)) then
						local veh = getPedOccupiedVehicle(fromplayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						
					else
						setElementPosition(fromplayer, x, y, z)
						setElementInterior(fromplayer, interior)
						setElementDimension(fromplayer, dimension)
					end
					
					outputChatBox(" You have teleported player " .. targetPlayerName1:gsub("_"," ") .. " to " .. targetPlayerName2:gsub("_"," ") .. ".", thePlayer)
					outputChatBox(" An admin " .. admin .. " has teleported you to " .. targetPlayerName2:gsub("_"," ") .. ". ", fromplayer)
					outputChatBox(" An admin " .. admin .. " has teleported " .. targetPlayerName1:gsub("_"," ") .. " to you.", toplayer)
				end
			end
		end
	end
end
addCommandHandler("sendto", getPlayer, false, false)

----------------------------[GET PLAYER HERE]---------------------------------------
function getPlayer(thePlayer, commandName, target)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not target then
			outputChatBox("SYNTAX: /" .. commandName .. " /gethere [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0 , 0)
				else
					if (getElementData( thePlayer, "adminlevel" ) < getElementData( targetPlayer, "adminlevel" )) then
						outputChatBox("Sending "..targetPlayerName.." teleporting request as they're higher rank than you.", thePlayer, 255, 194, 14)
						outputChatBox(getPlayerName(thePlayer):gsub("_", " ").." wants to teleport you to them. /atp to accept, /dtp to deny.", targetPlayer, 255, 194, 14)
						setElementData(targetPlayer, "teleport:targetPlayer", thePlayer)
						return
					end
					
					detachElements(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local r = getPedRotation(thePlayer)
					setCameraInterior(targetPlayer, interior)
					
					-- Maths calculations to stop the target being stuck in the player
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					outputChatBox(" You have teleported player " .. targetPlayerName .. " to you.", thePlayer)
					outputChatBox(" Admin " .. username .. " has teleported you to them. ", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("gethere", getPlayer, false, false)

function acceptTeleport(thePlayer)
	local targetPlayer = false
	targetPlayer = getElementData(thePlayer, "teleport:targetPlayer")
	if not targetPlayer then
		outputChatBox("You don't have any teleport request pending.",thePlayer,255,0,0)
	else
		gotoPlayer(thePlayer, "LOL" , targetPlayer)
		removeElementData(thePlayer, "teleport:targetPlayer")
	end
end
addCommandHandler("atp", acceptTeleport, false, false)

function denyTeleport(thePlayer)
	local targetPlayer = false
	targetPlayer = getElementData(thePlayer, "teleport:targetPlayer")
	if not targetPlayer then
		outputChatBox("You don't have any teleport request pending.",thePlayer,255,0,0)
	else
		outputChatBox(" You have deny teleport request from " .. getPlayerName(targetPlayer):gsub("_", " ").. ".", thePlayer)
		outputChatBox(" "..getPlayerName(thePlayer):gsub("_", " ").." has deny your teleport request.", targetPlayer)
		removeElementData(thePlayer, "teleport:targetPlayer")
	end
end
addCommandHandler("dtp", denyTeleport, false, false)

local teleportLocations = {
	-- 			x					y					z			int dim	rot
	ls = { 1520.0029296875, 	-1701.2425537109, 	13.546875, 	0, 	0,	275	},
	sf = { -1988.5693359375, 507.0029296875, 35.171875,	0, 	0,	90	},
	sfia = { -1689.0689697266, 	-536.7919921875, 	14.254997, 	0, 	0,	252	},
	lv = { 1691.6801757813, 	1449.1293945313, 	10.765375,	0, 	0,	268	},
	pc = { 2253.66796875, 		-85.0478515625, 	28.086093,	0, 	0,	180	},
	bank = { 596.82421875, -1245.7109375, 18.19867515564, 0, 0, 24 },
	cityhall = { 1481.578125, -1768.6279296875, 18.795755386353, 0, 0, 3 },
	crusher = { 2438.7314453125, -2092.6240234375, 13.546875, 0, 0, 267 },
	bayside = {  -2620.103515625, 2271.232421875, 8.1442451477051, 0, 0, 360 },
	sfpd = {  -1607.71875, 722.9853515625, 12.368106842041, 0, 0, 360 },
	igs = {  1968.3681640625, -1764.0224609375, 13.546875, 0, 0, 120 },
	lsia = { 1967.7998046875, -2180.470703125, 13.546875, 0, 0, 165 },
	ash = { 1178.9794921875, -1324.212890625, 14.146828651428, 0, 0, 268 },
	dmv = { 1094.306640625, -1791.857421875, 13.617427825928, 0, 0, 255 },
	lstr = { 2168.2294921875, -2704.216796875, 13.546875, 0, 0, 6 },
	vgs = { 996.34375, -920.4052734375, 42.1796875, 0, 0, 6 },
}

function showValidTeleportLocations(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		outputChatBox("----- VALID /GOTOPLACE PLACES -----", thePlayer)
		outputChatBox("ls sf lv pc bank cityhall igs vgs lstr sfm crusher dmv bayside sfpd sfia ash", thePlayer)
	end
end
addCommandHandler("places", showValidTeleportLocations, false, false)

function teleportToPresetPoint(thePlayer, commandName, target)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [place]", thePlayer, 255, 194, 14)
			showValidTeleportLocations(thePlayer, "places")
		else
			local target = string.lower(tostring(target))
			
			if (teleportLocations[target] ~= nil) then
				if (isPedInVehicle(thePlayer)) then
					local veh = getPedOccupiedVehicle(thePlayer)
					setVehicleTurnVelocity(veh, 0, 0, 0)
					setElementPosition(veh, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setVehicleRotation(veh, 0, 0, teleportLocations[target][6])
					setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
					
					setElementDimension(veh, teleportLocations[target][5])
					setElementInterior(veh, teleportLocations[target][4])

					setElementDimension(thePlayer, teleportLocations[target][5])
					setElementInterior(thePlayer, teleportLocations[target][4])
					setCameraInterior(thePlayer, teleportLocations[target][4])
				else
					detachElements(thePlayer)
					setElementPosition(thePlayer, teleportLocations[target][1], teleportLocations[target][2], teleportLocations[target][3])
					setPedRotation(thePlayer, teleportLocations[target][6])
					setElementDimension(thePlayer, teleportLocations[target][5])
					setCameraInterior(thePlayer, teleportLocations[target][4])
					setElementInterior(thePlayer, teleportLocations[target][4])
				end
			else
				outputChatBox("Invalid Place Entered!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotoplace", teleportToPresetPoint, false, false)

------------- [gotoMark]
addEvent( "gotoMark", true )
addEventHandler( "gotoMark", getRootElement( ),
	function( x, y, z, interior, dimension, name )
		if type( x ) == "number" and type( y ) == "number" and type( z ) == "number" and type( interior ) == "number" and type( dimension ) == "number" then
			if getElementData ( client, "loggedin" ) == 1 and ( exports.global:isPlayerAdmin(client) or exports.global:isPlayerGameMaster(client) ) then
				local vehicle = nil
				local seat = nil
			
				if(isPedInVehicle ( client )) then
					 vehicle =  getPedOccupiedVehicle ( client )
					seat = getPedOccupiedVehicleSeat ( client )
				end
				detachElements(client)
				
				if(vehicle and (seat ~= 0)) then
					removePedFromVehicle (client )
					exports['anticheat-system']:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
					setElementPosition(client, x, y, z)
					setElementInterior(client, interior)
					setElementDimension(client, dimension)
				elseif(vehicle and seat == 0) then
					removePedFromVehicle (client )
					exports['anticheat-system']:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
					setElementPosition(vehicle, x, y, z)
					setElementInterior(vehicle, interior)
					setElementDimension(vehicle, dimension)
					warpPedIntoVehicle ( client, vehicle, 0)
				else
					setElementPosition(client, x, y, z)
					setElementInterior(client, interior)
					setElementDimension(client, dimension)
				end
				
				outputChatBox( "Teleported to Mark" .. ( name and " '" .. name .. "'" or "" ) .. ".", client, 0, 255, 0 )
			end
		end
	end
)
