local roadblocksarr = { }
local maxroadblocks = 100

function roadblockCreateWorldObject(objectid, tempObjectPosX, tempObjectPosY, tempObjectPosZ, tempObjectPosRot)
	if(isRoadblockEditAllowed(client)) then
		local slot = 0
		for i = 1, maxroadblocks do
			if (roadblocksarr[i]==nil) then
				roadblocksarr[i] = createObject ( objectid, tempObjectPosX, tempObjectPosY, tempObjectPosZ, 0, 0, tempObjectPosRot )
				exports['anticheat-system']:changeProtectedElementDataEx(roadblocksarr[i], "roadblock", "1", false)
				setElementInterior ( roadblocksarr[i], getElementInterior ( client ) )
				setElementDimension ( roadblocksarr[i], getElementDimension ( client ) )
				slot = i
				
				if (objectid == 1593) then -- Spikestrip
					local shape = createColCuboid ( tempObjectPosX, tempObjectPosY, tempObjectPosZ, 2.0, 2.0, 2.5)
					exports.pool:allocateElement(shape)
					exports['anticheat-system']:changeProtectedElementDataEx(shape, "type", "spikes")
					exports['anticheat-system']:changeProtectedElementDataEx(roadblocksarr[i], "spike:shape1", shape, false)
				end
				
				break
			end
		end
		if not (slot == 0) then
			outputChatBox("Roadblock spawned with ID #" .. slot.. ".", client, 0, 255, 0)
			exports['logs']:dbLog(client, 28, client, "Spawned Roadblock ID "..tostring(slot))
		else
			outputChatBox("Too many roadblocks are already spawned, please remove some.", client, 0, 255, 0)
		end
	end
end
addEvent( "roadblockCreateWorldObject", true )
addEventHandler( "roadblockCreateWorldObject", getRootElement(), roadblockCreateWorldObject )

function getNearbyRoadblocks(thePlayer, commandName)
	if(isRoadblockEditAllowed(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Roadblocks:", thePlayer, 255, 126, 0)
		local found = false
		
		for i = 1, maxroadblocks do
			if not (roadblocksarr[i]==nil) then
				local x, y, z = getElementPosition(roadblocksarr[i])
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					outputChatBox("   Roadblock with ID " .. i .. ".", thePlayer, 255, 126, 0)
					found = true
				end
			end
		end
		
		if not (found) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyrb", getNearbyRoadblocks, false, false)

function removeRoadblock(thePlayer, commandName, id)
	if(isRoadblockEditAllowed(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Roadblock ID]", thePlayer, 255, 194, 15)
		else
			id = tonumber(id)
			if (roadblocksarr[id]==nil) then
				outputChatBox("No roadblock was found with this ID.", thePlayer, 255, 0, 0)
			else
				local object = roadblocksarr[id]
				
				-- Remove any possible spike shape
				local getPossibleShape = getElementData(object, "spike:shape1")
				if (getPossibleShape) then
					destroyElement(getPossibleShape)
				end
				
				local getPossibleShape2 = getElementData(object, "spike:shape2")
				if (getPossibleShape2) then
					destroyElement(getPossibleShape2)
				end
				
				destroyElement(object)
				roadblocksarr[id] = nil
				exports['logs']:dbLog(thePlayer, 28, thePlayer, "Removed roadblock ID "..tostring(id))
				outputChatBox("Removed roadblock with ID #" .. id .. ".", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("delrb", removeRoadblock, false, false)
addCommandHandler("delroadblock", removeRoadblock, false, false)

function removeAllRoadblocks(thePlayer, commandName)
	if(exports.global:isPlayerAdmin(thePlayer)) then
		for i = 1, maxroadblocks do
			if not (roadblocksarr[i]==nil) then
				local object = roadblocksarr[i]
				
				-- Remove any possible spike shape
				local getPossibleShape = getElementData(object, "spike:shape1")
				if (getPossibleShape) then
					destroyElement(getPossibleShape)
				end
				
				local getPossibleShape2 = getElementData(object, "spike:shape2")
				if (getPossibleShape2) then
					destroyElement(getPossibleShape2)
				end
				
				destroyElement(object)
			end
		end
		roadblocksarr = { }
		exports['logs']:dbLog(thePlayer, 28, thePlayer, "Removed all roadblocks")
		outputChatBox("All roadblocks are removed.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("delallrbs", removeAllRoadblocks, false, false)
addCommandHandler("delallroadblocks", removeAllRoadblocks, false, false)

function onRoadblockStart(thePlayer, commandName, parameter)
	if(isRoadblockEditAllowed(thePlayer)) then
		triggerClientEvent(thePlayer, "enableRoadblockGUI", getRootElement(), true)
	end
end
addCommandHandler("rbs", onRoadblockStart, false, false)

function isRoadblockEditAllowed(thePlayer)
	local factionType = getElementData(getPlayerTeam(thePlayer), "type")
	local factionID = getElementData(getPlayerTeam(thePlayer), "id")
	return factionType == 2 or factionType == 3 or factionType == 4 or factionID == 4
end