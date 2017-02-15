function updateTime()
	local offset = tonumber(get("offset")) or 0
	local realtime = getRealTime()
	hour = realtime.hour + offset
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end

	minute = realtime.minute

	setTime(hour, minute)

	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration( nextupdate )
	setTimer( setMinuteDuration, nextupdate + 5, 1, 60000 )
end

addEventHandler("onResourceStart", getResourceRootElement(), updateTime )

-- update the time every 30 minutes (correction)
setTimer( updateTime, 1800000, 0 )

function setGameTime(thePlayer, commandName, hour, minute)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if not tonumber(hour) or not tonumber(minute) or (tonumber(hour) % 1 ~= 0) or (tonumber(minute) % 1 ~= 0) or tonumber(hour) < 0 or tonumber(hour) > 23 or tonumber(minute) > 60 or tonumber(hour) < 0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [hour] [minute]", thePlayer, 255, 194, 14 )
		else
			if setTime(hour, minute) then
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminName = getElementData(thePlayer, "account:username")
				exports.global:sendMessageToAdmins("[REALTIME]: "..adminTitle.." "..adminName.." has temporarily changed game time to "..hour..":"..minute)
			end
		end
	end
end
addCommandHandler("setgametime", setGameTime, false, false)