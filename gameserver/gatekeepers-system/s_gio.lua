--[=[
local gioColSphere = createColSphere(2241.4716796875, -2159.5654296875, 13.553833007813, 1)
exports.pool:allocateElement(gioColSphere)

local count = { }

function timeCheck(res)
	hour, minutes = getTime()
	
	if (hour>=19) and (hour<=23) then
		createGio()
	else
		local minutesLeft = 60 - minutes
		local hoursLeft = 18 - hour
		local spawnTime = (hoursLeft*60) + minutesLeft
		gioSpawnTimer = setTimer ( createGio, spawnTime*60000, 1 )
		outputDebugString("Giovanni will spawn in "..spawnTime.." minutes.")
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), timeCheck)

local gioStat = 0
function createGio()
	giovanna = createPed(73, 2441.4462890625, -2532.755859375, 5095.4331054688)
	exports.pool:allocateElement(giovanna)

	setElementInterior(giovanna, 6)
	setElementDimension(giovanna, 1376)
	setElementFrozen(giovanna, true)
--	setPedAnimation(giovanna, "ped", "SEAT_idle", -1, true, false, false)
	setPedRotation(giovanna, 143.82147216797)

--[[local gioChair = createObject(1369, 2442.44140625, -2533.6845703125, 5095.03, 0, 0, 312.97503662109)
	setElementInterior(gioChair, 6)
	setElementDimension(gioChair, 1376)--]]
	
	exports['anticheat-system']:changeProtectedElementDataEx(giovanna, "rotation", getPedRotation(giovanna), false)
	exports['anticheat-system']:changeProtectedElementDataEx(giovanna, "name", "Giovanna Remini")
	exports['anticheat-system']:changeProtectedElementDataEx(giovanna, "activeConvo",  0)
	exports['anticheat-system']:changeProtectedElementDataEx(giovanna,"talk",true)
	doneDeals = 0
	exports['anticheat-system']:changeProtectedElementDataEx( getRootElement( ), "gio.done", 0, false )
	
	hours,minues = getTime()
	
	local minutesLeft = 60 - minutes
	local hoursLeft = 23 - hour
	local removeTime = (hoursLeft*60) + minutesLeft
	gioRemoveTimer = setTimer ( removeGio, removeTime*60000, 1 )
	outputDebugString("Giovanna will leave in "..removeTime.." minutes.")
	gioStat = 1
end

function removeGio()
	destroyElement(giovanna)
	outputDebugString("Giovanna was removed.")
	gioSpawnTimer = setTimer (createGio, 68400000, 1)
	gioStat = 0
end

function startUpGio(thePlayer, matchingDimension )
	if matchingDimension then
		local logged = getElementData(thePlayer, "loggedin")
		
		if (gioStat == 1) then
			if (logged==1) then
				if (isElementWithinColShape(thePlayer, gioColSphere)) then
					local theTeam = getPlayerTeam(thePlayer)
					local factionType = getElementData(theTeam, "type")
					triggerClientEvent(thePlayer, "startWGio", getRootElement(), factionType, gioStat)
				end
			end
		end
	end
end
addEventHandler("onColShapeHit", gioColSphere, startUpGio)

local allowance = nil
function showGioConvo(stage)
	if (stage) then
		local name = string.gsub(getPlayerName(source), "_", " ")
		local pf = getElementData(source, "faction")
		
		if not (count[pf]) then
			count[pf] = 0
		end
		
		if (allowance) and (allowance == "no")  then
			exports.global:sendLocalText(source, " * Nothing Happens *      (( Unknown_Player ))", 255, 51, 102)
			triggerClientEvent(source, "closeGiosWindow", getRootElement())
		else
			if (stage == 1) then
				local factionLeader = tonumber(getElementData(source, "factionleader"))
				if (factionLeader == 0) then
					exports.global:sendLocalText(source,"Little Joe shouts: Come back when you got some balls!", 255, 255, 255, 5)
					triggerClientEvent(source, "closeGiosWindow", getRootElement())
				else
					exports.global:sendLocalText(source, " *" .. name .. " begins to bang on the door.", 255, 51, 102)				
					exports.global:sendLocalText(source, "Little Joe shouts: Yeah Yeah. I'm coming. Who's there?!", 255, 255, 255, 10)
					
					exports['anticheat-system']:changeProtectedElementDataEx (giovanna, "activeConvo",  1)
					talkingToGio = source
--					addEventHandler("onPlayerQuit", talkingToGio, resetGioConvoStateDelayed)
--					addEventHandler("onPlayerWasted", talkingToGio, resetGioConvoStateDelayed)

					triggerClientEvent(source, "startGioP2", getRootElement())
				end
			elseif (stage == 2) then
				exports.global:sendLocalText(source, name .. " shouts: I came here for some guns. Got any supplies?", 255, 255, 255, 5)
				exports.global:sendLocalText(source, "Little Joe shouts: Woooah Brother! You got the wrong guy!", 255, 255, 255, 5)

				exports['anticheat-system']:changeProtectedElementDataEx (giovanna, "activeConvo",  0)
				triggerClientEvent(source, "closeGiosWindow", getRootElement())
				
				allowance = "no"
				setTimer(resetGioConvoStateDelayed, 300000, 1)
			elseif (stage == 3) then
				exports.global:sendLocalText(source, name .. " says: It's me. I came here for some business.", 255, 255, 255, 5)
				exports.global:sendLocalText(source, "Giovanna Remini says: I'm all ears. The name is Giovanna, what are you looking for bud?", 255, 255, 255, 5)
			elseif (stage == 4) then
				exports.global:sendLocalText(source, name .. " says: I have all I need.", 255, 255, 255, 5)
				exports.global:sendLocalText(source, "Giovanna Remini says: May the lord be with you my friend.", 255, 255, 255, 5)

				setTimer(resetGioConvoStateDelayed, 600000, 1)
			elseif (stage == 5) then
				exports.global:sendLocalText(source, "Giovanna Remini says: You heard that? It's getting hot around here, I gotta go man. Peace!", 255, 255, 255, 5)
				allowance = "no"
			end
		end
	end
end
addEvent("showGioConvo", true)
addEventHandler("showGioConvo", getRootElement(), showGioConvo)

local itemID, cost, ammo = nil
function giveGioItems(weapon)
	local pfaction = getElementData(source, "faction")
	if(weapon == 1)then
		itemID = 22
		cost = 4000
		ammo = 150
	elseif (weapon == 2)then
		itemID = 32
		cost = 6000
		ammo = 150
	end
	
	if not (count[pfaction]) then
		count[pfaction] = 0
	end
	
	if (count[pfaction] >= 6) then
		triggerEvent("showGioConvo", source, 5)
		triggerClientEvent(source, "closeGiosWindow", getRootElement())
		setTimer(resetGioConvoStateDelayed, 300000, 1)
	else
		if not exports.global:takeMoney(source, cost) then
			exports.global:sendLocalText(source, "Giovanna Remini says: Sorry brother, I'm just not in a charity mood. Come back with the cash.", 255, 255, 255, 5)
			triggerClientEvent(source, "closeGiosWindow", getRootElement())

			setTimer(resetGioConvoStateDelayed, 600000, 1)
		else
			count[pfaction] = count[pfaction] + 1
			if not exports.global:giveWeapon(source, itemID, ammo, true) then 
				outputChatBox("Error giving guns!", source)
			else
				outputChatBox("You have bought some protection from Giovanna for $" .. cost .. ".", source)
				itemID = nil
				cost = nil
				ammo = nil
			end
		end
	end
end
addEvent("gioGiveItem", true)
addEventHandler("gioGiveItem", getRootElement(), giveGioItems)

function resetGioConvoState()
	exports['anticheat-system']:changeProtectedElementDataEx(giovanna,"activeConvo", 0)
end

function resetGioConvoStateDelayed()
	if talkingToGio then
		removeEventHandler("onPlayerQuit", talkingToGio, resetGioConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToGio, resetGioConvoStateDelayed)
		triggerClientEvent(talkingToGio, "closeGioWindow", getRootElement())
		talkingToGio = nil
		count = { }
		allowance = nil
	end
	setTimer(resetGioConvoState, 120000, 1)
end
]=]
