--[[
	*
	* SoundGroup Corporation - System
	* File: g_globals.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

-- Creating a table with all the streams in it
local playernames = {["Josh_Paddington"]=true, ["Paul_Trevor"]=true, ["Holly_Parker"]=true, ["Jennifer_Lopez"]=true, ["Justin_Timberlake"]=true, ["Danny_Parker"]=true, ["Socialz"]=true}
local debugs = false

-- Check if the username is allowed
function allowedUsername(player, cmd)
	if isElement(player) then
		if getElementData(player, "loggedin") then
			if (playernames[getPlayerName(player)] or exports.global:isPlayerScripter(player)) and (tonumber(getElementData(player, "loggedin")) == 1) then
				return true
			else
				if debugs == true then
					for i,v in pairs(playernames) do
						if getPlayerFromName(i) then
							outputConsole("[SOUNDGROUP] " .. getPlayerName(player) .. " tried to execute /" .. cmd .. " but the player name is not whitelisted.", getPlayerFromName(i))
						end
					end
				end
				return false
			end
		else
			if debugs == true then
				for i,v in pairs(playernames) do
					if getPlayerFromName(i) then
						outputConsole("[SOUNDGROUP] " .. getPlayerName(player) .. " tried to execute /" .. cmd .. " but isn't logged in.", getPlayerFromName(i))
					end
				end
			end
			return false
		end
	else
		if debugs == true then
			for i,v in pairs(playernames) do
				if getPlayerFromName(i) then
					outputConsole("[SOUNDGROUP] " .. getPlayerName(player) .. " tried to execute /" .. cmd .. " but isn't in the game.", getPlayerFromName(i))
				end
			end
		end
		return false
	end
end

addCommandHandler("pdebug",
	function(player, cmd)
		debugs = not debugs
		outputChatBox("System debug is now " .. (debugs and "on" or "off") .. ".", player, 16, 245, 16, false)
	end
)