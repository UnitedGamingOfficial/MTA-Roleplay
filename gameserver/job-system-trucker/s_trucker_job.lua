--BY MAXIME 24/5/2013

local lockTimer = nil
local truckruns = { }
local truckwage = { }
local truckroute = { }
local currentCrates = {}
--getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table

local truckerJobVehicleInfo = {
--  Model   (1)Capacity (2)Level (3)Price/Crate (4)CrateWeight (5)Earning/Crate
	[440] = {40, 1, 15, 20, 100}, -- Rumpo
	[499] = {80, 2, 35, 50, 150}, -- Benson
	[414] = {160, 3, 55, 100, 200}, -- Mule
	[498] = {200, 4, 75, 140, 250}, -- Boxville
	[456] = {300, 5, 75, 140, 300}, -- Yankee
}

function getTruckCapacity(element)
	if truckerJobVehicleInfo[getElementModel(element)] then
		return truckerJobVehicleInfo[getElementModel(element)][1] -- Weight
	else
		return false
	end
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if text then
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end

function giveTruckingMoney(vehicle)
	outputChatBox("You earned $" .. exports.global:formatMoney( truckwage[vehicle] or 0 ) .. " on your trucking runs.", source, 255, 194, 15)
	exports.global:giveMoney(source, truckwage[vehicle] or 0)

	if (truckwage[vehicle] == nil) then
		triggerTruckCheatEvent(source, 3)
	elseif (truckwage[vehicle] > 3750) then
		triggerTruckCheatEvent(source, 2, truckwage[vehicle])
	end
	
	local refundedItems, refundedMoney = takeRemainingCratesAndRefund(source, vehicle)
	if refundedItems then
		if refundedItems ~= 0 then
			outputChatBox(" You still have "..refundedItems.." crates in the back. RS Haul has unloaded them and refunded you $"..refundedMoney..".", source, 255, 194, 15)
		end
	else
		outputChatBox(" Failed to unload remaining crates.", source, 255, 0, 0)
	end
	
	-- respawn the vehicle
	exports['anticheat-system']:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
	
	-- reset runs/wage
	truckruns[vehicle] = nil
	truckwage[vehicle] = nil
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)

function takeRemainingCratesAndRefund(thePlayer, vehicle)
	if vehicle and thePlayer then
		local count = 0
		local money = 0
		for key, item in pairs(exports["item-system"]:getItems(vehicle)) do 
			outputDebugString(item[1].." - "..item[2])
			if item[1] == 121 then
				if tonumber(item[2]) == 20 then
					if exports.global:takeItem(theVehicle, item[1], item[2]) then
						exports.global:giveMoney(thePlayer, 15)
						count = count + 1
						money = money + 15					
					end
				elseif tonumber(item[2]) == 50 then
					if exports.global:takeItem(theVehicle, item[1], item[2]) then
						exports.global:giveMoney(thePlayer, 35)
						count = count + 1
						money = money + 35
					end
				elseif tonumber(item[2]) == 100 then
					if exports.global:takeItem(theVehicle, item[1], item[2]) then
						exports.global:giveMoney(thePlayer, 55)
						count = count + 1
						money = money + 55
					end
				elseif tonumber(item[2]) == 140 then
					if exports.global:takeItem(theVehicle, item[1], item[2]) then
						exports.global:giveMoney(thePlayer, 75)
						count = count + 1
						money = money + 75
					end
				else
					-- Do nothing
				end
			end
		end
		return count, money
	else
		outputDebugString("[TRUCKER JOB] / elements not found.")
		return false
	end
end

-- PREVENT DRIVER WITH LOWER SKILL GETTING VEHICLE WITH THE HIGHER LEVEL SKILL - MAXIME
function startEnterTruck(thePlayer, seat, jacked) 
	local truckModel = getElementModel(source)
	if getElementData(source,"job") == 1 and truckerJobVehicleInfo[truckModel] then
		local truckLevelRequire = truckerJobVehicleInfo[truckModel][2]
		local playerJobLevel = getElementData(thePlayer, "jobLevel")
		if playerJobLevel < truckLevelRequire then
			local truckName = getVehicleNameFromModel(truckModel)
			outputChatBox("You're required Delivery Driver Level "..truckLevelRequire.." Certificate to drive this "..truckName..".", thePlayer, 255, 0, 0)
			if isTimer(lockTimer) then
				killTimer(lockTimer)
				lockTimer = nil
			end
			setVehicleLocked(source, true)
			lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterTruck)

function checkTruckingEnterVehicle(thePlayer, seat)
	--if getElementData(source, "owner") == -1 and getElementData(source, "faction") == -1 and seat == 0 and truck[getElementModel(source)] and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
	if seat == 0 and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
		if true then --exports.global:isPlayerScripter(thePlayer) then
			local curentCrates = getCurrentCrates(source)
			triggerClientEvent(thePlayer, "job-system:trucker:showSupplySpot", thePlayer)
			if curentCrates <= 0 then
				outputChatBox("Your vehicle is empty! Please reload it at RS Haul station!", thePlayer, 255, 194, 15)
			else
				outputChatBox("Your vehicle has "..curentCrates.." crate(s) of supplies in the back. Deliver them to our customer's places!", thePlayer, 255, 194, 15)
				triggerClientEvent(thePlayer, "startTruckJob", thePlayer, truckroute[source] or -1)
			end
			if (truckruns[vehicle] ~= nil) and (truckwage[vehicle] > 0) then
				triggerClientEvent(thePlayer, "spawnFinishMarkerTruckJob", thePlayer)
			end
		else
			outputChatBox("We're upgrading trucker job system. Please try another job in the meantime.", thePlayer, 255, 0, 0)
			--triggerClientEvent(thePlayer, "startTruckJob", thePlayer, truckroute[source] or -1)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), checkTruckingEnterVehicle)

function startLoadingUp(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if getElementData(vehicle, "job") ~= 1 then
		outputChatBox("#FF9933 Man..You have to use RS Haul vehicle.", thePlayer, 255, 194, 15, true)
		triggerClientEvent(thePlayer, "job-system:trucker:leaveStationLoadup", thePlayer, thePlayer, true)
		return false
	end
	local truckModel = getElementModel(vehicle)
	local truck = truckerJobVehicleInfo[truckModel]
	if truck then
		local crateCost = truck[3]
		local crateWeight = truck[4]
		if exports.global:takeMoney(thePlayer, crateCost) then
			if exports["item-system"]:giveItem( vehicle, 121, crateWeight) then
				outputChatBox("#FF9933 Loaded up a crate of supplies("..crateWeight.." Kg) for $"..crateCost..".", thePlayer, 0, 255, 0, true)
				local curentCrates = getCurrentCrates(vehicle)
				if curentCrates <= 0 then
					outputChatBox(" Your vehicle is empty!", thePlayer, 255, 0, 0)
				else
					outputChatBox(" Your vehicle has "..curentCrates.." crate(s) of supplies in the back.", thePlayer, 0, 255, 0)
					triggerClientEvent(thePlayer, "startTruckJob", thePlayer, truckroute[vehicle] or -1)
				end
			else
				outputChatBox("#FF9933 Your truck is full and can not load anymore of supplies!", thePlayer, 255, 194, 15, true)
				outputChatBox("#FF9933 Drive to the #FFFF00yellow blips#FF9933 to complete deliveries.", thePlayer, 255, 194, 15, true)
				exports.global:giveMoney(thePlayer, 55)
				triggerClientEvent(thePlayer, "job-system:trucker:leaveStationLoadup", thePlayer, thePlayer, true)
			end
		else
			outputChatBox("Man, you don't have enough money..", thePlayer, 255,0,0)
			triggerClientEvent(thePlayer, "job-system:trucker:leaveStationLoadup", thePlayer, thePlayer)
		end
	end
end
addEvent("job-system:trucker:startLoadingUp", true)
addEventHandler("job-system:trucker:startLoadingUp", getRootElement(), startLoadingUp)

function getCurrentCrates(vehicle)
	local count = 0
	for key, item in pairs(exports["item-system"]:getItems(vehicle)) do 
		if item[1] == 121 then -- supply box
			count = count + 1
		end
	end
	return count
end

function startEnterTruck(thePlayer, seat, jacked) 
	if seat == 0 and truckerJobVehicleInfo[getElementModel(source)] and getElementData(thePlayer,"job") == 1 and jacked then -- if someone try to jack the driver stop him
		if isTimer(lockTimer) then
			killTimer(lockTimer)
			lockTimer = nil
		end
		setVehicleLocked(source, true)
		lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterTruck)

function saveDeliveryProgress(vehicle)
	if (truckruns[vehicle] == nil) then
		truckruns[vehicle] = 0
		truckwage[vehicle] = 0
	end
	
	if getElementData(vehicle, "job") ~= 1 then
		outputChatBox(" Man..You have to use RS Haul vehicle.", source, 255,0,0)
		return false
	end
	
	local truckModel = getElementModel(vehicle)
	local truck = truckerJobVehicleInfo[truckModel]
	if truck then
		local earned = math.ceil(truck[5]*(getElementHealth(vehicle)/1000)) or 0
		local crateWeight = truck[4]
		
		if exports["item-system"]:takeItem(vehicle, 121, crateWeight) then	
			truckruns[vehicle] = truckruns[vehicle] + 1
			truckwage[vehicle] = truckwage[vehicle] + earned
			
			outputChatBox("You completed your " .. truckruns[vehicle] .. ".  trucking run in this truck and earned $" .. exports.global:formatMoney(earned) .. ".", client, 0, 255, 0)
			outputChatBox("#FF9933You can now either return to the #CC0000warehouse #FF9933and obtain your wage", client, 0, 0, 0, true)
			outputChatBox("#FF9933or continue onto the next #FFFF00drop off point#FF9933 and increase your wage.", client, 0, 0, 0, true)
			triggerClientEvent( client, "loadNewCheckpointTruckJob",  client)
			triggerEvent("updateGlobalSupplies", client, math.random(10,20))
		else
			outputChatBox("#FF9933Your trunk is empty! Return to the #CC0000warehouse #FF9933first.", client, 0, 0, 0, true)
		end
	else
		outputChatBox(" You must be in the Delivery Truck to complete deliverys.", 255, 0, 0, true ) -- Wrong car type.
	end
end
addEvent("saveDeliveryProgress", true)
addEventHandler("saveDeliveryProgress", getRootElement(), saveDeliveryProgress)

function triggerTruckCheatEvent(thePlayer, cheatType, value1)
	--[[local cheatStr = ""
	if (cheatType == 1) then
		cheatStr = "Too much earned on one trucking run, (c:"..value1..", max 150)"
	elseif (cheatType == 2) then
		cheatStr = "Too much earned in total. (c:"..value1..", max 3750)"
	else
		cheatStr = "unknown triggerTruckCheatEvent (".. cheatType .."/"..value1..")"
	end
	local finalstr = "[trucking\saveDeliveryProgress]".. getPlayerName(thePlayer) .. " " .. getPlayerIP(thePlayer) .. " ".. cheatStr  
	exports.logs:logMessage(finalstr, 32)
	exports.global:sendMessageToAdmins(finalstr)
	]]
end

function updateNextCheckpoint(vehicle, pointid)
	truckroute[vehicle] = pointid
end
addEvent("updateNextCheckpoint", true)
addEventHandler("updateNextCheckpoint", getRootElement(), updateNextCheckpoint)

function restoreTruckingJob()
	if getElementData(source, "job") == 1 then
		triggerClientEvent(source, "restoreTruckerJob", source)
	end
end
addEventHandler("restoreJob", getRootElement(), restoreTruckingJob)

--[[
function resumeJob()
	setTimer(function()
		for key, player in pairs(getElementsByType("player")) do 
			checkTruckingEnterVehicle(player, 0)
		end
	end, 1000, 1)
end
addEventHandler("onResourceStart", getRootElement(), resumeJob)
]]


