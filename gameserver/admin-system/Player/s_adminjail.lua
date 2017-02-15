----------------------[JAIL]--------------------
function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Minutes(>=1) 999=Perm] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account:id")
				
				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(targetPlayer)) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)
				
				if (minutes>=999) then
					mysql:query_free("UPDATE accounts SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='1', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
					minutes = 9999999
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailtimer", true, false)
				else
					mysql:query_free("UPDATE accounts SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='0', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE id='" .. mysql:escape_string(tonumber(accountID)) .. "'")
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailserved", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailtimer", theTimer, false)
				end
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminjailed", true, false)
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailreason", reason, false)
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailtime", minutes, false)
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)
				
				outputChatBox("You jailed " .. targetPlayerName .. " for " .. minutes .. " Minutes.", thePlayer, 255, 0, 0)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local res = mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',0,' .. mysql:escape_string(( minutes == 999 and 0 or minutes )) .. ',"' .. mysql:escape_string(reason) .. '")' )
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData( thePlayer, "account:username" )
				outputChatBox("AdmJail: " .. adminTitle .. " " .. playerName .. " jailed you for " .. minutes .. " Minutes.", targetPlayer, 255, 0, 0)
				outputChatBox("AdmJail: Reason: " .. reason, targetPlayer, 255, 0, 0)
				exports.global:sendMessageToAdmins("AdmJail: " .. adminTitle .. " " .. playerName .. " ("..adminUsername..") jailed " .. playerName .. " for " .. minutes .. " minutes.")
				exports.global:sendMessageToAdmins("AdmJail: Reason: " .. reason)
				setElementDimension(targetPlayer, 65400+getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				
				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)

--OFFLINE JAIL BY MAXIME--------------------
function offlineJailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Exact Username] [Minutes(>=1) 999=Perm] [Reason]", thePlayer, 255, 194, 14)
		else
			-- If player is still online
			local reason = table.concat({...}, " ")
			local onlinePlayers = getElementsByType("player")
			for _, player in ipairs(onlinePlayers) do
				if who:lower() == getElementData(player, "account:username"):lower() then
					jailPlayer(thePlayer, "jail", getPlayerName(player):gsub(" ", "_"), minutes, reason)
					return true
				end
			end
			-- if player is acutally offline.
			local mQuery1 = mysql:query("SELECT `id`, `username`, `mtaserial`, `admin`, `banned`, `banned_by`, `banned_reason` FROM `accounts` WHERE `username`='".. mysql:escape_string( who ) .."'")
			local row = {}
			if mQuery1 then
				row = mysql:fetch_assoc(mQuery1) or false
				mysql:free_result(mQuery1)
			end
			local accountID = false
			local accountUsername = false
			if row then
				accountID = row["id"] 
				accountUsername = row["username"] 
			else
				outputChatBox("Username not found!", thePlayer, 255, 0, 0)
				return false
			end
			
			local playerName = getPlayerName(thePlayer)
			
			if (minutes>=999) then
				mysql:query_free("UPDATE accounts SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='1', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				minutes = 9999999
			else
				mysql:query_free("UPDATE accounts SET adminjail='1', adminjail_time='" .. mysql:escape_string(minutes) .. "', adminjail_permanent='0', adminjail_by='" .. mysql:escape_string(playerName) .. "', adminjail_reason='" .. mysql:escape_string(reason) .. "' WHERE id='" .. mysql:escape_string(tonumber(accountID)) .. "'")
			end
			
			outputChatBox("You jailed " .. accountUsername .. " for " .. minutes .. " minutes.", thePlayer, 255, 0, 0)
			
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local res = mysql:query_free("INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ('N/A','"..accountID.."','"..mysql:escape_string(getPlayerName(thePlayer)).."', '"..mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)).."','"..mysql:escape_string(hiddenAdmin).."', '0', '"..mysql:escape_string(( minutes == 999 and 0 or minutes )).."', '"..mysql:escape_string(reason).."')")
			exports.global:sendMessageToAdmins("OfflineJail: " .. adminTitle .. " " .. playerName .. " ("..adminUsername..") jailed " .. accountUsername .. " for " .. minutes .. " minutes.")
			exports.global:sendMessageToAdmins("OfflineJail: Reason: " .. reason)
		end
	end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account:id")
		if (timeServed) then
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailserved", timeServed+1, false)
			local timeLeft = timeLeft - 1
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailtime", timeLeft, false)
		
			if (timeLeft<=0) then
				local query = mysql:query_free("UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailtimer", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "adminjailed", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailreason", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailtime", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "jailadmin", false, false)
				setElementPosition(jailedPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
				setPedRotation(jailedPlayer, 303)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				outputChatBox("Your time has been served, behave next time!", jailedPlayer, 0, 255, 0)
				
				local gender = getElementData(jailedPlayer, "gender")
				local genderm = "his"
				if (gender == 1) then
					genderm = "her"
				end
				exports.global:sendMessageToAdmins("AdmJail: " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " has served " .. genderm .. " jail time.")
			else
				local query = mysql:query_free("UPDATE accounts SET adminjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer, false)
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", getRootElement(), timerUnjailPlayer)

function unjailPlayer(thePlayer, commandName, who)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				if not (jailed) then
					outputChatBox(targetPlayerName .. " is not jailed.", thePlayer, 255, 0, 0)
				else
					local query = mysql:query_free("UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. mysql:escape_string(accountID) .. "'")

					if isTimer(jailed) then
						killTimer(jailed)
					end
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailtimer", false, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminjailed", false, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailreason", false, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailtime", false, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "jailadmin", false, false)
					setElementPosition(targetPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
					setPedRotation(targetPlayer, 303)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					toggleControl(targetPlayer,'next_weapon',true)
					toggleControl(targetPlayer,'previous_weapon',true)
					toggleControl(targetPlayer,'fire',true)
					toggleControl(targetPlayer,'aim_weapon',true)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					if hiddenAdmin == 0 then
						outputChatBox("You were unjailed by " .. username .. ", behave next time!", targetPlayer, 0, 255, 0)
						exports.global:sendMessageToAdmins("AdmJail: " .. targetPlayerName .. " was unjailed by " .. username .. ".")
					else
						outputChatBox("You were unjailed by a Hidden Admin, behave next time!", targetPlayer, 0, 255, 0)
						exports.global:sendMessageToAdmins("AdmJail: " .. targetPlayerName .. " was unjailed by a Hidden Admin.")
					end
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("----- Jailed -----", thePlayer, 255, 194, 15)
		local players = exports.pool:getPoolElementsByType("player")
		local count = 0
		for key, value in ipairs(players) do
			if getElementData(value, "adminjailed") then
				outputChatBox("[JAIL] " .. getPlayerName(value) .. ", jailed by " .. tostring(getElementData(value, "jailadmin")) .. ", served " .. tostring(getElementData(value, "jailserved")) .. " minutes, " .. tostring(getElementData(value,"jailtime")) .. " minutes left", thePlayer, 255, 194, 15)
				outputChatBox("[JAIL] Reason: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				count = count + 1
			elseif getElementData(value, "pd.jailtimer") then
				outputChatBox("[ARREST] " .. getPlayerName(value) .. ", served " .. tostring(getElementData(value, "pd.jailserved")) .. " minutes, " .. tostring(getElementData(value, "pd.jailtime")) .. " minutes left", thePlayer, 0, 102, 255)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("There is no one jailed.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)