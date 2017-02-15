addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: Hello, how can I help you today?", 255, 255, 255, 10)
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['global']:sendLocalText(client, pedName.." says: Really?! One moment!", 255, 255, 255, 10)
	exports['global']:sendLocalText(client, pedName.." [RADIO]: Someone needs assistance at the hospital reception!", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Emergency Services") ) ) do
		outputChatBox("[RADIO] This is dispatch, we've got an incident, over.", value, 0, 183, 239)
		outputChatBox("[RADIO] Situation: Someone needs assistance!, over.  ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: All Saints General Hospital, at the reception desk, over.", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: I'll notify who I can, please take a seat while waiting.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Emergency Services") ) ) do
		outputChatBox("[RADIO] Reception here, we've got someone here for an appointment, over. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: Los Santos Medical Center, at the reception desk, over.", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)