function updateNametagColor(thePlayer)
	if getElementData(thePlayer, "loggedin") ~= 1 then -- Not logged in
		setPlayerNametagColor(thePlayer, 127, 127, 127)
	elseif isPlayerAdmin(thePlayer) and getElementData(thePlayer, "adminduty") == 1 then -- Admin duty
		setPlayerNametagColor(thePlayer, 0, 128, 191)
	elseif isPlayerModerator(thePlayer) and getElementData(thePlayer, "adminduty") == 1 then 
		setPlayerNametagColor(thePlayer, 153, 0, 0)
	elseif exports.donators:hasPlayerPerk(thePlayer, 11) then -- Donator
		setPlayerNametagColor(thePlayer, 167, 133, 63)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end

for key, value in ipairs( getElementsByType( "player" ) ) do
	updateNametagColor( value )
end	