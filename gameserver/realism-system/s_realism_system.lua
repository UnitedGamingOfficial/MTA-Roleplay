function onStealthKill(targetPlayer)
	--exports.global:sendMessageToAdmins("[ANTIDM] Blocked stealth kill from "..getPlayerName(source) .." against " .. getPlayerName(targetPlayer))
    cancelEvent(true)
end
addEventHandler("onPlayerStealthKill", getRootElement(), onStealthKill)