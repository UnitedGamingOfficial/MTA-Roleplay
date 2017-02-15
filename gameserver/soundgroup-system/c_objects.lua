--[[
	*
	* SoundGroup Corporation - System
	* File: c_objects.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local myobjs = {}
local effects = {}

-- Object stream effect change
addEvent("onObjectEffectChange", true)
addEventHandler("onObjectEffectChange", root,
	function(id, effect, state)
		for i,v in pairs(myobjs) do
			if i == id then
				for k,object in ipairs(getElementsByType("object")) do
					if tonumber(getElementData(object, "object:id")) == id then
						for _,attachment in ipairs(getAttachedElements(object)) do
							if isElement(attachment) then
								if state == "true" then
									setSoundEffectEnabled(attachment, effect, true)
									if not effects[effect] then
										effects[#effects+1] = effect
									end
								elseif state == "false" then
									setSoundEffectEnabled(attachment, effect, false)
									for i,v in ipairs(effects) do
										if v == effect then
											effects[i] = nil
											break
										end
									end
								end
							end
							break
						end
					end
				end
			end
		end
	end
)

-- Object stream volume change
addEvent("onObjectVolumeChange", true)
addEventHandler("onObjectVolumeChange", root,
	function(id, volume)
		for i,v in pairs(myobjs) do
			if i == id then
				for k,object in ipairs(getElementsByType("object")) do
					if tonumber(getElementData(object, "object:id")) == id then
						for _,attachment in ipairs(getAttachedElements(object)) do
							if isElement(attachment) then
								setSoundVolume(attachment, volume)
							end
							break
						end
					end
				end
			end
		end
	end
)

-- Object stream speed change
addEvent("onObjectSpeedChange", true)
addEventHandler("onObjectSpeedChange", root,
	function(id, speed)
		for i,v in pairs(myobjs) do
			if i == id then
				for k,object in ipairs(getElementsByType("object")) do
					if tonumber(getElementData(object, "object:id")) == id then
						for _,attachment in ipairs(getAttachedElements(object)) do
							if isElement(attachment) then
								setSoundSpeed(attachment, speed)
							end
							break
						end
					end
				end
			end
		end
	end
)

-- When an object is spawned, insert it to the table
addEvent("onObjectSpawned", true)
addEventHandler("onObjectSpawned", root,
	function(name)
		myobjs[#myobjs+1] = tostring(name)
		effects[#effects+1] = {}
	end
)

-- Command to see your items
addCommandHandler("myobjects",
	function(cmd)
		if not allowedUsername(localPlayer, cmd) then return end
		outputChatBox("Spawned objects:", 255, 180, 0, false)
		if #myobjs ~= 0 then
			for i,v in pairs(myobjs) do
				result = true
				outputChatBox(" » ID " .. i .. ": '" .. myobjs[i] .. "'", 255, 160, 10, false)
			end
		else
			outputChatBox(" » No items found.", 255, 160, 10, false)
		end
	end
)

-- Command to delete an item
addCommandHandler("dobject",
	function(cmd, id)
		if not allowedUsername(localPlayer, cmd) then return end
		local id = tonumber(id)
		if id then
			for i,v in pairs(myobjs) do
				if i == id then
					triggerServerEvent("onObjectDeletion", root, id, localPlayer)
					myobjs[i] = nil
					effects[i] = nil
					break
				else
					if i == #myobjs then
						outputChatBox("Couldn't find such object with ID " .. id .. ".", 255, 0, 0, false)
					end
				end
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [id]", 255, 180, 0, false)
		end
	end
)

addEvent("destroyEverything", true)
addEventHandler("destroyEverything", root,
	function()
		myobjs = {}
		effects = {}
	end
)

-- Actually stream the radio and attach it to the object
addEvent("playRadio", true)
addEventHandler("playRadio", root,
	function(object, url, volume)
		local x, y, z = getElementPosition(object)
		local radio = playSound3D(url, x, y, z, false)
		if volume then
			setSoundVolume(radio, volume)
		else
			setSoundVolume(radio, 1.0)
		end
		setElementDimension(radio, getElementDimension(object))
		setElementInterior(radio, getElementInterior(object))
		setSoundMaxDistance(radio, 120)
		attachElements(radio, object)
	end
)

-- Destroy the stream
addEvent("destroySound", true)
addEventHandler("destroySound", root,
	function(object)
		for i,v in ipairs(getAttachedElements(object)) do
			stopSound(v)
		end
	end
)