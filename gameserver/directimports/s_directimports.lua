function makeGeneric(thePlayer, commandName, itemValue)
    local team = getPlayerTeam(thePlayer)
	if (getTeamName(team)=="Direct Imports") then
		if getElementData(thePlayer, "factionleader") == 0 then -- If the player is not the leader
			outputChatBox("You must be a faction leader to make generics.", thePlayer, 255, 0, 0)
		else
			if itemValue then
				exports.global:giveItem( thePlayer, 80, itemValue )
				outputChatBox("You've imported a '" .. itemValue .. "'.", thePlayer, 255, 0, 0)
			else
				outputChatBox("SYNTAX /" .. commandName .. " [Value]", thePlayer, 255, 184, 22)
			end
		end
	end
end
addCommandHandler("makegeneric", makeGeneric)