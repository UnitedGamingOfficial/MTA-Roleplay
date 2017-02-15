--[[
	*
	* SoundGroup Corporation - System
	* File: s_props.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local smokeSpawns = {}
local smokePositions = {
	{-2089.35, 278.64, 37.19},
	{-2089.35, 260.33, 37.19},
	{-2089.34, 241.62, 37.23},
	{-2089.34, 223.17, 37.23},
	{-2107.4, 251.01, 37.23}
}

addCommandHandler("pfireboom",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		triggerClientEvent("onFireBoom", root)
		outputChatBox("Fire boom released.", player, 40, 245, 40, false)
	end
)

addCommandHandler("psmokeboom",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		if #smokeSpawns > 0 then
			for i,v in ipairs(smokeSpawns) do
				destroyElement(v)
			end
			outputChatBox("Smoke boom removed.", player, 40, 245, 40, false)
			smokeSpawns = {}
		else
			for i,v in ipairs(smokePositions) do
				smokeSpawns[i] = createObject(2780, smokePositions[i][1], smokePositions[i][2], smokePositions[i][3], 0, 0, 0)
			end
			outputChatBox("Smoke boom released.", player, 40, 245, 40, false)
		end
	end
)