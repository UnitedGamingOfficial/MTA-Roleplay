local mysql = exports.mysql

function getElementDataEx(theElement, theParameter)
	return getElementData(theElement, theParameter)
end

function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	if syncToClient == nil then
		syncToClient = false
	end
	
	if noSyncAtall == nil then
		noSyncAtall = false
	end
	
	if tonumber(theValue) then
		theValue = tonumber(theValue)
	end
	
	exports['anticheat-system']:changeProtectedElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	return true
end

function resourceStart(resource)
	setWaveHeight ( 0 )
	setGameType("Roleplay")
	--setGameType("")
	setMapName("Los Santos")
	setRuleValue("Script Version", scriptVersion)
	setRuleValue("Author", "UnitedGaming MTA Scripting Team")
	
	local motdresult = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='motd' LIMIT 1")
	exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:motd", motdresult["value" ], false )
	local amotdresult = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='amotd' LIMIT 1")
	exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:amotd", amotdresult["value" ], false )
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("playerJoinResourceStart", value, resource)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
	
function onJoin()
	local skipreset = false
	local loggedIn = getElementData(source, "loggedin")
	if loggedIn == 1 then
		local accountID = getElementData(source, "account:id")
		local seamlessHash = getElementData(source, "account:seamlesshash")
		local mQuery1 = mysql:query("SELECT `id` FROM `accounts` WHERE `id`='"..mysql:escape_string(accountID).."' AND `loginhash`='".. mysql:escape_string(seamlessHash) .."'")
		if mysql:num_rows(mQuery1) == 1 then
			skipreset = true
			setElementDataEx(source, "account:seamless:validated", true, false, true)
		end
		mysql:free_result(mQuery1)
	end
	if not skipreset then 
		-- Set the user as not logged in, so they can't see chat or use commands
		exports['anticheat-system']:changeProtectedElementDataEx(source, "loggedin", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "account:loggedin", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "account:username", "", false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "account:id", "", false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "dbid", false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "adminlevel", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "hiddenadmin", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "globalooc", 1, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "muted", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "loginattempts", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "timeinserver", 0, false)
		setElementData(source, "chatbubbles", 0, false)
		setElementDimension(source, 9999)
		setElementInterior(source, 0)
	end
	
	exports.global:updateNametagColor(source)
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)
addEvent("playerJoinResourceStart", false)
addEventHandler("playerJoinResourceStart", getRootElement(), onJoin)

function changePlayerPassword(thePlayer, commandName, newPass, newPassConfirm)
	if getElementData(thePlayer, "loggedin") then
		if not newPass or not newPassConfirm then
			outputChatBox("SYNTAX: /" .. commandName .. " [New Password] [Confirm Pass]", thePlayer, 125, 125, 125)
		else
			if (newPass ~= newPassConfirm) then
				triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "The passwords do not match.")
			elseif (string.len(newPass)<6) then
				triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Your password is too short. \n You must enter 6 or more characters.")
			elseif (string.len(newPass)>=30) then
				triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Your password is too long. \n You must enter less than 30 characters.")
			elseif (string.find(newPass, ";", 0)) or (string.find(newPass, "'", 0)) or (string.find(newPass, "@", 0)) or (string.find(newPass, ",", 0)) then
				triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Your password cannot contain ;,@'.")
			else
				callRemote("http://localhost/server/changepass.php", verifyPasswordChange, getElementData(thePlayer, "account:username"), newPass, thePlayer)
			end
		end
	end
end
addCommandHandler("changeaccountpassword", changePlayerPassword, false, false)

function verifyPasswordChange(success, thePlayer)
	if success then
		triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Your password was sussesfully changed.")
	else
		triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Error please try again later.")
	end
end

function resetNick(oldNick, newNick)
	exports['anticheat-system']:changeProtectedElementDataEx(client, "legitnamechange", 1)
	setPlayerName(client, oldNick)
	exports['anticheat-system']:changeProtectedElementDataEx(client, "legitnamechange", 0)
	--exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(oldNick) .. " tried to change their name to " .. tostring(newNick) .. ".")
end
addEvent("resetName", true )
addEventHandler("resetName", getRootElement(), resetNick)