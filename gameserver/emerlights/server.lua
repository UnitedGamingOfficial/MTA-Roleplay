function onPlayerRequestEmerlight(value)
	triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(source), value)
end
addEvent("requestEmerlightChangeState", true)
addEventHandler("requestEmerlightChangeState", getRootElement(), onPlayerRequestEmerlight)