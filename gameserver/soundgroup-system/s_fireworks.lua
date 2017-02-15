--[[
	*
	* SoundGroup Corporation - System
	* File: s_fireworks.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local f_trailer1 = createVehicle(591, -2102.29, 241.63, 54.74, 0, 0, 0)
local f_trailer2 = createVehicle(591, -2102.29, 260.3, 54.74, 0, 0, 0)
setElementFrozen(f_trailer1, true)
setElementFrozen(f_trailer2, true)
setVehicleColor(f_trailer1, 0, 0, 0, 0)
setVehicleColor(f_trailer2, 0, 0, 0, 0)

addCommandHandler("pfireworkz",
	function(player, cmd)
		if isElement(f_trailer1) and isElement(f_trailer2) then
			triggerClientEvent("onClientCreateFireworks", root, f_trailer1, 1)
			triggerClientEvent("onClientCreateFireworks", root, f_trailer2, 2)
			outputChatBox("The fireworks has started.", player, 40, 245, 40, false)
		else
			outputChatBox("The fireworks truck must be spawned.", player, 245, 40, 40, false)
		end
	end
)