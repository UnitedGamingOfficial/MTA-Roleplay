function makeGeneric(thePlayer, commandName, choice)
	local team = getPlayerTeam(thePlayer)
	local factionName = getTeamName(team)
	local factionID = tonumber(getElementData(thePlayer, "faction")) or -1
	if factionID ~= 18 or getElementData(thePlayer, "factionleader") == 0 then -- If the player is not the leader
		outputChatBox("You must be a 'Los Santos Homebuilding & Renovating's leader to make generics.", thePlayer, 255, 0, 0)
	else
		if not choice or not tonumber(choice) then
			outputChatBox("SYNTAX: /" .. commandName .. " [choice]", thePlayer, 255, 194, 14)
			outputChatBox("CHOICES: ", thePlayer, 255, 194, 14)
			outputChatBox("1 - 120 FPS Video Security DVR", thePlayer)
			outputChatBox("2 - Color CCTV Dome Security Camera", thePlayer)
			outputChatBox("3 - Hi-Resolution Weatherproof IR Security Camera", thePlayer)
			outputChatBox("4 - 19 inch LED Multi-Monitors", thePlayer)
			outputChatBox("5 - GeoVision Keypad with integrated Sound Sensor Alarm", thePlayer)
		else
			local itemValue = ""
			if tonumber(choice) == 1 then
				itemValue =  "120 FPS Video Security DVR:3386"
			elseif tonumber(choice) == 2 then
				itemValue = "Color CCTV Dome Security Camera:1886"
			elseif tonumber(choice) == 3 then
				itemValue = "Hi-Resolution Weatherproof IR Security Camera:1616"
			elseif tonumber(choice) == 4 then
				itemValue = "19 inch LED Multi-Monitors:2606"
			elseif tonumber(choice) == 5 then
				itemValue = "GeoVision Keypad with integrated Sound Sensor Alarm:1581"
			else
				outputChatBox("SYNTAX: /" .. commandName .. " [choice]", thePlayer, 255, 194, 14)
				outputChatBox("CHOICES: ", thePlayer, 255, 194, 14)
				outputChatBox("1 - 120 FPS Video Security DVR", thePlayer)
				outputChatBox("2 - Color CCTV Dome Security Camera", thePlayer)
				outputChatBox("3 - Hi-Resolution Weatherproof IR Security Camera", thePlayer)
				outputChatBox("4 - 19 inch LED Multi-Monitors", thePlayer)
				outputChatBox("5 - GeoVision Keypad with integrated Sound Sensor Alarm", thePlayer)
				return
			end
			
			if exports.global:giveItem( thePlayer, 80, itemValue ) then
				outputChatBox("You've imported a '" .. itemValue .. "'.", thePlayer, 0, 255, 0)
			else
				outputChatBox("Failed to import '" .. itemValue .. "'.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makegeneric", makeGeneric)