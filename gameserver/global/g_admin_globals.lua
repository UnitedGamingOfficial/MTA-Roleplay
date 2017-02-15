function getAdmins()
	local players = exports.pool:getPoolElementsByType("player")
	
	local admins = { }
	
	for key, value in ipairs(players) do
		if isPlayerModerator(value) and getPlayerAdminLevel(value) <= 4 then
			table.insert(admins,value)
		end
	end
	return admins
end

function isPlayerModerator(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 1
end

function isPlayerGameMaster(thePlayer)
	return isPlayerModerator(thePlayer)
end

function isPlayerAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 2
end

function isPlayerFullAdmin(thePlayer)
	return isPlayerAdmin(thePlayer)
end

function isPlayerSuperAdmin(thePlayer)
	return isPlayerAdmin(thePlayer)
end

function isPlayerLeadAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 3
end

function isPlayerHeadAdmin(thePlayer)
	return isPlayerLeadAdmin(thePlayer)
end

function getPlayerAdminLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "adminlevel")) or 0
end

local adminTitles = {
	["1"] = "Game Moderator", 
	["2"] = "Game Admin", 
	["3"] = "Lead Admin",
	["4"] = "Server Owner", 
}
function getPlayerAdminTitle(thePlayer)
	local text = adminTitles[""..tostring(getPlayerAdminLevel(thePlayer))..""] or "Player"
		
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end

	return text
end

local scripters = {
	TamFire = true,
	Bean = true,
	Grif = true,
}

function isPlayerScripter(thePlayer)
	return scripters[thePlayer] or scripters[ getElementData(thePlayer, "account:username") or "nobody" ] or false
end