--[[
	*
	* SoundGroup Corporation - System
	* File: s_admin.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

-- Command to reload the whole resource in case of a bug or so
addCommandHandler("preloadsystem",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		restartResource(getThisResource())
	end
)

-- Command to stop the whole resource in case of a bug or so
addCommandHandler("pstopsystem",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		stopResource(getThisResource())
	end
)