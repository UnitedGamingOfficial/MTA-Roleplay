--[[
	*
	* SoundGroup Corporation - System
	* File: s_objects.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local maxlimit = 60
local effects = {["gargle"]=true, ["compressor"]=true, ["echo"]=true, ["i3dl2reverb"]=true, ["distortion"]=true, ["chorus"]=true, ["parameq"]=true, ["reverb"]=true, ["flanger"]=true}

-- Spawn an item with specified details
addCommandHandler("sobject",
	function(player, cmd, id, collisions, frozen, alpha, url, volume)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if getElementData(player, "object:amount") and getElementData(player, "object:amount") == maxlimit then
				outputChatBox("Max limit object exceeded, clear objects with /clear.", player, 255, 0, 0, false)
				return
			end
			
			local x, y, z = getElementPosition(player)
			local rx, ry, rz = getElementRotation(player)
			
			if id == 2232 then
				object = createObject(id, x, y, z - 0.4, rx, ry, rz - 180)
				setElementPosition(player, x, y, z + 0.6)
			else
				object = createObject(id, x, y, z - 0.93, rx, ry, rz)
				setElementPosition(player, x, y, z + 0.1)
			end
			
			setElementInterior(object, getElementInterior(player))
			setElementDimension(object, getElementDimension(player))
			
			if tonumber(collisions) then
				if tonumber(collisions) == 1 then
					setElementCollisionsEnabled(object, true)
				elseif tonumber(collisions) == 2 then
					setElementCollisionsEnabled(object, false)
				end
			else
				setElementCollisionsEnabled(object, false)
			end
			
			if tonumber(frozen) then
				if tonumber(frozen) == 1 then
					setElementFrozen(object, true)
				elseif tonumber(frozen) == 2 then
					setElementFrozen(object, false)
				end
			else
				setElementFrozen(object, true)
			end
			
			if tonumber(alpha) then
				if tonumber(alpha) >= 0 and tonumber(alpha) <= 255 then
					setElementAlpha(object, tonumber(alpha))
				end
			else
				setElementAlpha(object, 255)
			end
			
			if url then
				local volume = tonumber(volume)
				if volume then
					if volume >= 0 and volume <= 1 then
						triggerClientEvent(root, "playRadio", player, object, url, volume)
					else
						triggerClientEvent(root, "playRadio", player, object, url, 1.0)
					end
				else
					triggerClientEvent(root, "playRadio", player, object, url)
				end
			end
			
			exports['anticheat-system']:changeProtectedElementDataEx(object, "object:owner", getPlayerName(player), true)
			exports['anticheat-system']:changeProtectedElementDataEx(object, "object:type", 2, true)
			
			if getElementData(player, "object:amount") then
				exports['anticheat-system']:changeProtectedElementDataEx(object, "object:id", tonumber(getElementData(player, "object:amount"))+1, true)
				exports['anticheat-system']:changeProtectedElementDataEx(player, "object:amount", tonumber(getElementData(player, "object:amount"))+1, true)
			else
				exports['anticheat-system']:changeProtectedElementDataEx(player, "object:amount", 1, true)
				exports['anticheat-system']:changeProtectedElementDataEx(object, "object:id", 1, true)
			end
			outputChatBox("Spawned an object 'Object' with ID " .. getElementData(object, "object:id") .. " (total amount: " .. getElementData(player, "object:amount") .. "/" .. maxlimit .. ").", player, 255, 180, 0, false)
			triggerClientEvent(player, "onObjectSpawned", player, "Object")
		else
			outputChatBox("Syntax: /" .. cmd .. " [id] <[collisions]> <[frozen]> <[alpha]> <[radio]> <[volume]>", player, 255, 180, 0, false)
			outputChatBox(" * Required: ID: Object model you'd like to spawn.", player, 255, 100, 0, false)
			outputChatBox(" * Optional: Collisions: 1 = true, 2 = false - Default: false", player, 255, 100, 0, false)
			outputChatBox(" * Optional: Frozen: 1 = true, 2 = false - Default: true", player, 255, 100, 0, false)
			outputChatBox(" * Optional: Alpha: 0-255 Default: 255", player, 255, 100, 0, false)
			outputChatBox(" * Optional: Radio: URL address of audio file.", player, 255, 100, 0, false)
			outputChatBox(" * Optional: Volume: 0-1.", player, 255, 100, 0, false)
		end
	end
)

-- Set the effect of the sound
addCommandHandler("pstreameffect",
	function(player, cmd, id, effect, state)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id and effect and state then
			for i,v in ipairs(getElementsByType("object")) do
				if getElementData(v, "object:id") == id then
					local effect = effect:lower()
					local state = state:lower()
					if effects[effect] then
						if state == "true" or state == "false" then
							triggerClientEvent(root, "onObjectEffectChange", root, id, effect, state)
							outputChatBox("Effect '" .. effect .. "' set to '" .. state .. "' on object ID " .. id .. ".", player, 40, 245, 40, false)
						else
							outputChatBox("State '" .. state .. "' is unknown, please use 'true' or 'false'.", player, 245, 40, 40, false)
						end
					else
						outputChatBox("Effect '" .. effect .. "' doesn't exist.", player, 245, 40, 40, false)
					end
					break
				end
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [object id] [effect] [state]", player, 255, 180, 40, false)
		end
	end
)

-- Set the volume of the sound
addCommandHandler("pstreamvolume",
	function(player, cmd, id, volume)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local volume = tonumber(volume)
		if id and volume then
			for i,v in ipairs(getElementsByType("object")) do
				if getElementData(v, "object:id") == id then
					if volume >= 0 and volume <= 1 then
						triggerClientEvent(root, "onObjectVolumeChange", root, id, volume)
						outputChatBox("Volume set to '" .. volume .. "' on object ID " .. id .. ".", player, 40, 245, 40, false)
					else
						outputChatBox("The volume must range from 0.0 to 1.0.", player, 245, 40, 40, false)
					end
					break
				end
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [object id] [value]", player, 255, 180, 40, false)
		end
	end
)

-- Set the speed of the sound
addCommandHandler("pstreamspeed",
	function(player, cmd, id, speed)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local speed = tonumber(speed)
		if id and speed then
			for i,v in ipairs(getElementsByType("object")) do
				if getElementData(v, "object:id") == id then
					if speed > 0 then
						triggerClientEvent(root, "onObjectSpeedChange", root, id, speed)
						outputChatBox("Speed set to '" .. speed .. "' on object ID " .. id .. ".", player, 40, 245, 40, false)
					else
						outputChatBox("The speed must be more than 0.", player, 245, 40, 40, false)
					end
					break
				end
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [object id] [value]", player, 255, 180, 40, false)
		end
	end
)

-- Clear all your items
addCommandHandler("clear",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		for i,v in ipairs(getElementsByType("object")) do
			if getElementData(v, "object:owner") then
				if getElementData(v, "object:owner") == getPlayerName(player) then
					if tonumber(getElementData(v, "object:type")) == 2 then
						triggerClientEvent(root, "destroySound", player, v)
					end
					destroyElement(v)
					triggerClientEvent(player, "destroyEverything", player)
				end
			end
		end
		removeElementData(player, "object:amount")
		outputChatBox("Your objects have been cleared off.", player, 0, 255, 0, false)
	end
)

-- Remove all player items as they quit
addEventHandler("onPlayerQuit", root,
	function()
		for i,v in ipairs(getElementsByType("object")) do
			if getElementData(v, "object:owner") then
				if getElementData(v, "object:owner") == getPlayerName(source) then
					destroyElement(v)
				end
			end
		end
	end
)

-- Remove all object amount data from players when the resource stops
addEventHandler("onResourceStop", resourceRoot,
	function()
		for i,v in ipairs(getElementsByType("player")) do
			if getElementData(v, "object:amount") then
				removeElementData(v, "object:amount")
			end
		end
	end
)

-- Command to check your current object limit
addCommandHandler("mylimit",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		if getElementData(player, "object:amount") then
			outputChatBox("Objects in total: " .. getElementData(player, "object:amount") .. "/" .. maxlimit .. ".", player, 255, 180, 0, false)
		else
			outputChatBox("Objects in total: 0/" .. maxlimit .. ".", player, 255, 180, 0, false)
		end
	end
)

-- When object is being deleted, do the following
addEvent("onObjectDeletion", true)
addEventHandler("onObjectDeletion", root,
	function(id, player)
		for i,v in ipairs(getElementsByType("object")) do
			if getElementData(v, "object:id") then
				if tonumber(getElementData(v, "object:id")) == id then
					if tonumber(getElementData(v, "object:type")) == 2 then
						triggerClientEvent(root, "destroySound", player, v)
					end
					destroyElement(v)
					outputChatBox("Object with ID " .. id .. " deleted.", player, 0, 255, 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(player, "object:amount", tonumber(getElementData(player, "object:amount"))-1, true)
					break
				end
			end
		end
	end
)