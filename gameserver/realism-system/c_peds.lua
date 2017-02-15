function setNearbyWalkingStyles()
	for key, value in pairs(getElementsByType("player", getRootElement(), true)) do
		local walkingStyle = getElementData(value, "walkingstyle")
		if walkingStyle then
			setPedWalkingStyle(value, tonumber(walkingStyle))
		end
	end
end
addEventHandler("onClientRender", getRootElement(), setNearbyWalkingStyles)

function updateWalkingStyle(walkingStyle, thePlayer)
	setPedWalkingStyle(thePlayer, tonumber(walkingStyle))
end
addEvent("updateWalkingStyle", true)
addEventHandler("updateWalkingStyle", getRootElement(), updateWalkingStyle)
	
