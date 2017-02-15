--[[
	*
	* SoundGroup Corporation - System
	* File: c_props.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local fireSpawns = {}
local firePoints = {
	{-2089.35, 233.06, 36.21},
	{-2089.35, 233.06, 40.21},
	{-2089.35, 268.87, 36.21},
	{-2089.35, 268.87, 40.21},
	{-2107.95, 241.67, 36.23},
	{-2107.95, 241.67, 40.23},
	{-2107.95, 260.47, 36.23},
	{-2107.95, 260.47, 40.23},
	{-2089.35, 260.35, 36.19},
	{-2089.35, 260.35, 40.19},
	{-2089.34, 241.63, 36.19},
	{-2089.34, 241.63, 40.19},
}

addEvent("onFireBoom", true)
addEventHandler("onFireBoom", root,
	function()
		if #fireSpawns > 0 then
			fireSpawns = {}
		else
			for i,v in ipairs(firePoints) do
				fireSpawns[i] = createFire(firePoints[i][1], firePoints[i][2], firePoints[i][3], 10)
			end
			setTimer(function()
				triggerEvent("onFireBoom", localPlayer)
			end, 1000, 1)
		end
	end
)