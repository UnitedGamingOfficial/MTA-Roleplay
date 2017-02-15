--[[
	*
	* SoundGroup Corporation - System
	* File: s_screen.lua
	* Author: Socialz, Cazomino05
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local effects = {["gargle"]=true, ["compressor"]=true, ["echo"]=true, ["i3dl2reverb"]=true, ["distortion"]=true, ["chorus"]=true, ["parameq"]=true, ["reverb"]=true, ["flanger"]=true}

addCommandHandler("pscreen",
	function(player, cmd, url, pos)
		if not allowedUsername(player, cmd) then return end
		if url then
			if pos and tostring(pos) == "true" then
				local x, y, z = getElementPosition(player)
				triggerClientEvent(root, "screen:play", root, url, x, y, z)
			else
				triggerClientEvent(root, "screen:play", root, url)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [stream url] <[current position]>", player, 220, 180, 40, false)
		end
	end
)

addCommandHandler("setstreameffect",
	function(player, cmd, effect, state)
		if not allowedUsername(player, cmd) then return end
		if effect and state then
			local effect = effect:lower()
			local state = state:lower()
			if effects[effect] then
				if state == "true" or state == "false" then
					triggerClientEvent(root, "onEffectChange", root, effect, state)
					outputChatBox("Effect '" .. effect .. "' set to '" .. state .. "'.", player, 40, 245, 40, false)
				else
					outputChatBox("State '" .. state .. "' is unknown, please use 'true' or 'false'.", player, 245, 40, 40, false)
				end
			else
				outputChatBox("Effect '" .. effect .. "' doesn't exist.", player, 245, 40, 40, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [effect] [state]", player, 255, 180, 40, false)
		end
	end
)

addCommandHandler("setstreamvolume",
	function(player, cmd, volume)
		if not allowedUsername(player, cmd) then return end
		local volume = tonumber(volume)
		if volume then
			if volume >= 0 and volume <= 1 then
				triggerClientEvent(root, "onVolumeChange", root, volume)
				outputChatBox("Volume set to '" .. volume .. "'.", player, 40, 245, 40, false)
			else
				outputChatBox("The volume must range from 0.0 to 1.0.", player, 245, 40, 40, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [value]", player, 255, 180, 40, false)
		end
	end
)

addCommandHandler("setstreamspeed",
	function(player, cmd, speed)
		if not allowedUsername(player, cmd) then return end
		local speed = tonumber(speed)
		if speed then
			if speed > 0 then
				triggerClientEvent(root, "onSpeedChange", root, speed)
				outputChatBox("Speed set to '" .. speed .. "'.", player, 40, 245, 40, false)
			else
				outputChatBox("The speed must be more than 0.", player, 245, 40, 40, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [value]", player, 255, 180, 40, false)
		end
	end
)