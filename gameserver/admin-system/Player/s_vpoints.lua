function givedonPoint(thePlayer, commandName, targetPlayer, donPoints, ...)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if (not targetPlayer or not donPoints or not (...)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player] [Points] [Reason]", thePlayer, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if (tplayer) then
				local loggedIn = getElementData(tplayer, "loggedin")
				if loggedIn == 1 then
					local reasonStr = table.concat({...}, " ")
					local accountID = getElementData(tplayer, "account:id")
					triggerClientEvent(tplayer, "onPlayerGetAchievement", thePlayer, "donPoints!", "donPoints!", "You just got awarded free donPoint(s) for the following reason: \n" .. reasonStr, donPoints)
					mysql:query_free("UPDATE `accounts` SET `credits`=`credits`+".. tostring(donPoints) .." WHERE `id`=".. tostring(accountID)  .."")
					exports.logs:dbLog(thePlayer, 26, tplayer, "GIVEdonPoints "..tostring(donPoints).." "..reasonStr)
					outputChatBox("You gave "..targetPlayerName.." "..donPoints.." donPoints for: ".. reasonStr, thePlayer)
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(tplayer)) .. '",' .. mysql:escape_string(tostring(getElementData(tplayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,6,'.. donPoints ..',"' .. mysql:escape_string(donPoints .. " donPoints for: " .. reasonStr) .. '")' )
				else
					outputChatBox("This player is not logged in.", thePlayer)
				end
			else
				outputChatBox("Something went wrong with picking the player.", thePlayer)
			end
		end
	end
end
addCommandHandler("givedonpoints", givedonPoint, false, false)

function takeDonPoint(thePlayer, commandName, targetPlayer, donPoints, ...)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if (not targetPlayer or not donPoints or not (...) or not tonumber(donPoints)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player] [Points] [Reason]", thePlayer, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			if (tplayer) then
				local logged = getElementData(tplayer, "loggedin")
				if logged == 1 then
					local reasonStr = table.concat({...}, " ")
					local accountID = getElementData(tplayer, "account:id")
					local playerName = getPlayerName(thePlayer)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					mysql:query_free("UPDATE `accounts` SET `credits`=`credits`-".. tostring(donPoints) .." WHERE `id`=".. tostring(accountID) .."")
					exports.logs:dbLog(thePlayer, 26, tplayer, "TAKEdonPoints ".. tostring(donPoints) .." "..reasonStr)
					outputChatBox("You took "..donPoints.." from "..targetPlayerName.." for the reason: ".. reasonStr, thePlayer)
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(tplayer)) .. '",' .. mysql:escape_string(tostring(getElementData(tplayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,6,'.. donPoints ..',"' .. mysql:escape_string(donPoints .. " took donPoints for: " .. reasonStr) .. '")' )
					if (hiddenAdmin==0) then
						outputChatBox(adminTitle.. " " .. playerName .. "took " ..donPoints.. " donPoints from your account for the reason: ".. reasonStr, targetPlayer, 255, 0, 0)
					else
						outputChatBox("An hidden administrator took " ..donPoints.. " donPoints from your account for the reason: " ..reasonStr, targetPlayer, 255, 0, 0)
					end
				else
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("takedonpoints", takeDonPoint, false, false)

function giveStatTransfer(thePlayer, commandName, targetPlayer, transfers, ...)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if not targetPlayer or not transfers or not (...) then
			outputChatBox("SYNTAX: /"..commandName.." [Partial Player Nick / ID] [Number of Transfers] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") then
					local reason = table.concat({...}, " ")
					local dbid = getElementData(targetPlayer, "account:id")
					triggerClientEvent(targetPlayer, "onPlayerGetAchievement", thePlayer, "Stat Transfers!", "Stat Transfers!", "You just got awarded stat transfer(s) for the following reason: \n" .. reason, transfers)
					mysql:query_free("UPDATE `accounts` SET `transfers`=`transfers`+".. tostring(transfers) .." WHERE `id`=".. tostring(dbid)  .."")
					exports.logs:dbLog(thePlayer, 26, targetPlayer, "GIVE STAT TRANSFER "..tostring(transfers).." "..reason)
					outputChatBox("You gave "..targetPlayerName.." "..transfers.." stat transfer(s) for: ".. reason, thePlayer)
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,6,'.. transfers ..',"' .. mysql:escape_string(transfers .. " stat transfers for: " .. reason) .. '")' )
				else
					outputChatBox("That player is not logged in", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Error with player selection", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("givestattransfer", giveStatTransfer, false, false)