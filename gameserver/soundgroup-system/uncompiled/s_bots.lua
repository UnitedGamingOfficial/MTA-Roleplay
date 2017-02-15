--[[
	*
	* SoundGroup Corporation - System
	* File: s_bots.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local guards = {
	-- skin, x, y, z, rotation, interior, dimension, name, frozen
	--{217, -2108.13, 222.01, 34.68, 180, 0, 0, "", true}
}

local npcs = {
	-- name, skin, animation block, animation name, repeat, spawned)
	-- Jackson (bodyguard)
	{"Jackson", 101, "MISC", "Idle_Chat_02", true, 0},
	
	-- Type 1 bodyguards
	{"Bodyguard 1", 101, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 2", 101, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 3", 101, "PLAYIDLES", "stretch", true, 0},
	{"Bodyguard 4", 101, "ped", "car_hookertalk", true, 0},
	
	-- Type 2 bodyguards
	{"Bodyguard 5", 294, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 6", 294, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 7", 294, "PLAYIDLES", "stretch", true, 0},
	{"Bodyguard 8", 294, "ped", "car_hookertalk", true, 0},
	
	-- Type 3 bodyguards
	{"Bodyguard 9", 293, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 10", 293, "DEALER", "DEALER_IDLE", true, 0},
	
	-- Type 4 bodyguards
	{"Bodyguard 11", 302, "PLAYIDLES", "stretch", true, 0},
	{"Bodyguard 12", 302, "ped", "car_hookertalk", true, 0},
	
	-- Type 5 bodyguards
	{"Bodyguard 13", 111, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 14", 111, "DEALER", "DEALER_IDLE", true, 0},
	
	-- Type 6 bodyguards
	{"Bodyguard 15", 163, "PLAYIDLES", "stretch", true, 0},
	{"Bodyguard 16", 163, "ped", "car_hookertalk", true, 0},
	
	-- Type 7 bodyguards
	{"Bodyguard 17", 164, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 18", 164, "DEALER", "DEALER_IDLE", true, 0},
	
	-- Type 8 bodyguards
	{"Bodyguard 19", 165, "PLAYIDLES", "stretch", true, 0},
	{"Bodyguard 20", 165, "ped", "car_hookertalk", true, 0},
	
	-- Type 9 bodyguards
	{"Bodyguard 21", 166, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 22", 166, "ped", "car_hookertalk", true, 0},
	
	-- Type 10 bodyguards
	{"Bodyguard 23", 217, "DEALER", "DEALER_IDLE", true, 0},
	{"Bodyguard 24", 217, "ped", "car_hookertalk", true, 0},
	
	-- Artists
	{"Knife Party (Row Swire)", 303, "SCRATCHING", "scdrulp", true, 0},
	{"Knife Party (Gareth McGrillen)", 72, "SCRATCHING", "scdrdlp", true, 0},
	{"Hardwell", 306, "SCRATCHING", "scdlulp", true, 0},
	{"Armin van Buuren", 46, "SCRATCHING", "scdldlp", true, 0},
	
	-- Dancers
	{"Dancer 1", 178, "STRIP", "strip_G", true, 0},
	{"Dancer 2", 178, "STRIP", "STR_A2B", true, 0},
	{"Dancer 3", 237, "STRIP", "STR_B2C", true, 0},
	{"Dancer 4", 237, "STRIP", "STR_C1", true, 0},
	{"Dancer 5", 246, "STRIP", "STR_C2", true, 0},
	{"Dancer 6", 246, "STRIP", "STR_Loop_A", true, 0},
	{"Dancer 7", 63, "STRIP", "STR_Loop_B", true, 0},
	{"Dancer 8", 63, "STRIP", "STR_Loop_C", true, 0},
	{"Dancer 9", 87, "STRIP", "strip_E", true, 0},
	{"Dancer 10", 87, "STRIP", "strip_C", true, 0},
	{"Dancer 11", 85, "STRIP", "PUN_CASH", true, 0},
	{"Dancer 12", 85, "STRIP", "PUN_HOLLER", true, 0}
}

local followTimer = {}
local animTimer = {}

-- When the resource starts, load all the guards in-game
addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(guards) do
			local ped = createPed(guards[i][1], guards[i][2], guards[i][3], guards[i][4], guards[i][5])
			setElementInterior(ped, guards[i][6])
			setElementDimension(ped, guards[i][7])
			setElementFrozen(ped, guards[i][9])
			setTimer(function() if isElement(ped) then setPedAnimation(ped, "DEALER", "DEALER_IDLE", -1, true, false, false) else return end end, 1000, 1)
			animTimer[ped] = setTimer(function() if isElement(ped) then setPedAnimation(ped, "DEALER", "DEALER_IDLE", -1, true, false, false) else return end end, 300000, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(ped, "name", (guards[i][8]:gsub("_", " ") ~= "false" and guards[i][8]:gsub("_", " ") or "Event Guard"), false)
			exports['anticheat-system']:changeProtectedElementDataEx(ped, "ped:name", (guards[i][8] ~= "false" and guards[i][8] or "Event_Guard"), false)
		end
	end
)

-- When the player leaves, reset all the guards
addEventHandler("onPlayerQuit", root,
	function()
		if not allowedUsername(source, "onPlayerQuit:resetNPCs") then return end
		for i,v in ipairs(getElementsByType("ped")) do
			if getElementData(v, "npc:following") then
				if isTimer(followTimer[v]) then killTimer(followTimer[v]) end
				if isTimer(animTimer[v]) then killTimer(animTimer[v]) end
				triggerClientEvent("sync@follow", root, v, source, 0)
				removeElementData(v, "npc:following")
				removeElementData(v, "npc:following_player")
				if isPedInVehicle(v) then
					removePedFromVehicle(v)
					local x, y, z = getElementPosition(v)
					setElementPosition(v, x+2, y, z+1)
				end
				setTimer(function() if isElement(v) then setPedAnimation(v, npcs[i][3], npcs[i][4], -1, npcs[i][5], false, false) else return end end, 500, 1)
				animTimer[v] = setTimer(function() if isElement(v) then setPedAnimation(v, npcs[i][3], npcs[i][4], -1, npcs[i][5], false, false) else return end end, 300000, 0)
				setElementFrozen(v, true)
			end
		end
	end
)

-- Command to create a NPC
addCommandHandler("pmakenpc",
	function(player, cmd, id)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if npcs[id] then
				if npcs[id][6] == 0 then
					local x, y, z = getElementPosition(player)
					local ped = createPed(npcs[id][2], x, y, z, getPedRotation(player))
					setElementFrozen(ped, true)
					setElementDimension(ped, getElementDimension(player))
					setElementInterior(ped, getElementInterior(player))
					setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 1000, 1)
					animTimer[ped] = setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 300000, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(ped, "npc:id", id, true)
					exports['anticheat-system']:changeProtectedElementDataEx(ped, "name", npcs[id][1]:gsub("_", " "), true)
					exports['anticheat-system']:changeProtectedElementDataEx(ped, "ped:name", npcs[id][1], true)
					setPedWalkingStyle(ped, 121)
					outputChatBox(" " .. npcs[id][1]:gsub("_", " ") .. " (" .. id .. ") created.", player, 0, 255, 0, false)
					npcs[id][6] = 1
				else
					outputChatBox("That NPC is already spawned.", player, 255, 0, 0, false)
				end
			else
				outputChatBox("Couldn't find such NPC.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [id]", player, 255, 180, 0, false)
		end
	end
)

-- Command to delete a NPC
addCommandHandler("pdelnpc",
	function(player, cmd, id)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if npcs[id] then
				if npcs[id][6] == 1 then
					for i,v in ipairs(getElementsByType("ped")) do
						if getElementData(v, "npc:id") then
							if tonumber(getElementData(v, "npc:id")) == id then
								if isTimer(followTimer[v]) then killTimer(followTimer[v]) end
								if isTimer(animTimer[v]) then killTimer(animTimer[v]) end
								destroyElement(v)
								outputChatBox(" " .. npcs[id][1]:gsub("_", " ") .. " (" .. id .. ") deleted.", player, 0, 255, 0, false)
								npcs[id][6] = 0
								break
							end
						end
					end
				else
					outputChatBox("That NPC isn't spawned yet.", player, 255, 0, 0, false)
				end
			else
				outputChatBox("Couldn't find such NPC.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [id]", player, 255, 180, 0, false)
		end
	end
)

-- Command to fetch all NPCs
addCommandHandler("listnpcs",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		outputChatBox("NPCs:", player, 220, 180, 0, false)
		for i,v in ipairs(npcs) do
			outputChatBox("  " .. i .. " - " .. npcs[i][1]:gsub("_", " ") .. (npcs[i][6] == 1 and " #00FF00(spawned)" or " #FF0000(not spawned)"), player, 220, 180, 0, true)
		end
	end
)

addCommandHandler("togfollow",
	function(player, cmd, id)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if npcs[id] and npcs[id][6] == 1 then
				for _,v in ipairs(getElementsByType("ped")) do
					if getElementData(v, "npc:id") and tonumber(getElementData(v, "npc:id")) == id then
						if getElementData(v, "npc:following") then
							if isTimer(followTimer[v]) then killTimer(followTimer[v]) end
							if isTimer(animTimer[v]) then killTimer(animTimer[v]) end
							triggerClientEvent("sync@follow", root, v, player, 0)
							removeElementData(v, "npc:following")
							removeElementData(v, "npc:following_player")
							if isPedInVehicle(v) then
								removePedFromVehicle(v)
								local x, y, z = getElementPosition(v)
								setElementPosition(v, x+2, y, z+1)
							end
							setTimer(function() if isElement(v) then setPedAnimation(v, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 500, 1)
							animTimer[v] = setTimer(function() if isElement(v) then setPedAnimation(v, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 300000, 0)
							setElementFrozen(v, true)
							outputChatBox(getElementData(v, "name") .. " is no longer following you.", player, 40, 245, 40, false)
						else
							if not isPedInVehicle(player) and not isPedInVehicle(v) then
								exports['anticheat-system']:changeProtectedElementDataEx(v, "npc:following", true, true)
								exports['anticheat-system']:changeProtectedElementDataEx(v, "npc:following_player", getPlayerName(player), true)
								outputChatBox(getElementData(v, "name") .. " is now following you.", player, 40, 245, 40, false)
								setPedFollowing(v, player)
							else
								outputChatBox("You and the NPC has to be outside a vehicle in order for it to follow you.", player, 245, 40, 40, false)
							end
						end
						break
					end
				end
			else
				outputChatBox("That NPC is not yet spawned or was not found.", player, 245, 40, 40, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [npc id]", player, 255, 180, 40, false)
		end
	end
)

function setPedFollowing(ped, player)
	if not allowedUsername(player, "setPedFollowing") then return end
	if not isPedInVehicle(player) and not isPedInVehicle(ped) then
		local x, y, z = getElementPosition(player)
		local px, py, pz = getElementPosition(ped)
		local distance = getDistanceBetweenPoints2D(x, y, px, py)
		local id = tonumber(getElementData(ped, "npc:id"))
		if distance > 22 then
			if isTimer(followTimer[ped]) then killTimer(followTimer[ped]) end
			if isTimer(animTimer[ped]) then killTimer(animTimer[ped]) end
			triggerClientEvent("sync@follow", root, ped, player, 0)
			removeElementData(ped, "npc:following")
			removeElementData(ped, "npc:following_player")
			setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 500, 1)
			animTimer[ped] = setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 300000, 0)
			setElementFrozen(ped, true)
		elseif distance > 12 then
			triggerClientEvent("sync@follow", root, ped, player, 4)
		elseif distance > 6 then
			triggerClientEvent("sync@follow", root, ped, player, 3)
		elseif distance > 1.5 then
			triggerClientEvent("sync@follow", root, ped, player, 2)
		elseif distance < 1.5 then
			triggerClientEvent("sync@follow", root, ped, player, 1)
			setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 500, 1)
			animTimer[ped] = setTimer(function() if isElement(ped) then setPedAnimation(ped, npcs[id][3], npcs[id][4], -1, npcs[id][5], false, false) else return end end, 300000, 0)
		end
		
		if distance <= 22 then
			if isElementFrozen(ped) then setElementFrozen(ped, false) end
			followTimer[ped] = setTimer(setPedFollowing, 1000, 1, ped, player)
		end
	end
end

addEventHandler("onPlayerVehicleEnter", root,
	function(vehicle, seat, jacker)
		if not allowedUsername(source, "onPlayerVehicleEnter:npc_follow") then return end
		for i,v in ipairs(getElementsByType("ped")) do
			if getElementData(v, "npc:following") then
				if getElementData(v, "npc:following_player") == getPlayerName(source) then
					if isTimer(followTimer[v]) then killTimer(followTimer[v]) end
					if isTimer(animTimer[v]) then killTimer(animTimer[v]) end
					triggerClientEvent("sync@follow", root, v, source, 0)
					local occupants = getVehicleOccupants(vehicle)
					local seats = getVehicleMaxPassengers(vehicle)
					for seat=1,seats+1 do
						if seat <= seats then
							local occupant = occupants[seat]
							if not occupant then
								if isPedInVehicle(v) then
									removePedFromVehicle(v)
									local x, y, z = getElementPosition(v)
									setElementPosition(v, x+2, y, z+1)
								end
								warpPedIntoVehicle(v, vehicle, seat)
								break
							end
						else
							if isTimer(followTimer[v]) then killTimer(followTimer[v]) end
							if isTimer(animTimer[v]) then killTimer(animTimer[v]) end
							triggerClientEvent("sync@follow", root, v, source, 0)
							outputChatBox(getElementData(v, "name") .. " is no longer following you.", source, 40, 245, 40, false)
							removeElementData(v, "npc:following")
							removeElementData(v, "npc:following_player")
							setTimer(function() if isElement(v) then setPedAnimation(v, npcs[tonumber(getElementData(v, "npc:id"))][3], npcs[tonumber(getElementData(v, "npc:id"))][4], -1, npcs[tonumber(getElementData(v, "npc:id"))][5], false, false) else return end end, 500, 1)
							animTimer[v] = setTimer(function() if isElement(v) then setPedAnimation(v, npcs[tonumber(getElementData(v, "npc:id"))][3], npcs[tonumber(getElementData(v, "npc:id"))][4], -1, npcs[tonumber(getElementData(v, "npc:id"))][5], false, false) else return end end, 300000, 0)
							setElementFrozen(v, true)
							break
						end
					end
				end
			end
		end
	end
)

addEventHandler("onPlayerVehicleExit", root,
	function(vehicle, seat, jacker)
		if not allowedUsername(source, "onPlayerVehicleExit:npc_follow") then return end
		for _,v in ipairs(getElementsByType("ped")) do
			if getElementData(v, "npc:following") then
				if getElementData(v, "npc:following_player") == getPlayerName(source) then
					if isPedInVehicle(v) then
						removePedFromVehicle(v)
						setPedFollowing(v, source)
						local x, y, z = getElementPosition(v)
						setElementPosition(v, x+2, y, z+1)
					end
				end
			end
		end
	end
)