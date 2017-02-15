local mysql = exports.mysql

function characterList( theClient )
	
	local characters = { }
	local clientAccountID = getElementDataEx(theClient, "account:id") or -1

	local result = mysql:query("SELECT `id`, `charactername`, `cked`, `lastarea`, `age`, `weight`, `height`, `description`, `gender`, `faction_id`, `faction_rank`, `skin`, DATEDIFF(NOW(), lastlogin) AS `llastlogin` FROM `characters` WHERE `account`='" .. mysql:escape_string(clientAccountID) .. "' AND `active` = 1 ORDER BY `cked` ASC, `lastlogin` DESC")
	
	if (mysql:num_rows(result) > 0) then
		local i = 1
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
		
			characters[i] = { }
			characters[i][1] = tonumber(row["id"])
			characters[i][2] = row["charactername"]
			
			if (tonumber(row["cked"]) or 0) > 0 then
				characters[i][3] = 1
			end
			
			characters[i][4] = row["lastarea"]
			characters[i][5] = tonumber(row["age"])
			characters[i][6] = tonumber(row["gender"])
			
			local factionID = tonumber(row["faction_id"])
			local factionRank = tonumber(row["faction_rank"])
			
			if (factionID<1) or not (factionID) then
				characters[i][7] = nil
				characters[i][8] = nil
			else
				factionResult = mysql:query_fetch_assoc("SELECT name, rank_" .. mysql:escape_string(factionRank) .. " as rankname FROM factions WHERE id='" .. mysql:escape_string(tonumber(factionID)) .. "'")
				if (factionResult) then
					characters[i][7] = factionResult["name"]
					characters[i][8] = factionResult["rankname"]
						
					if (string.len(characters[i][7])>53) then
						characters[i][7] = string.sub(characters[i][7], 1, 32) .. "..."
					end
				else
					characters[i][7] = nil
					characters[i][8] = nil
				end
			end
			characters[i][9] = tonumber(row["skin"])
			characters[i][10] = tonumber(row["llastlogin"])
			characters[i][11] = tonumber(row["weight"])
			characters[i][12] = tonumber(row["height"])
			i = i + 1
		end
	end
	mysql:free_result(result)
	return characters
end

function reloadCharacters()
	local chars = characterList(source)
	setElementData(source, "account:characters", chars, true)
end
addEvent("updateCharacters", true)
addEventHandler("updateCharacters", getRootElement(), reloadCharacters)

--/LOGINTO FOR LEAD+ / MAXIME
function adminLoginToPlayerCharacter(thePlayer, commandName, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Exact Character Name]", thePlayer, 255, 194, 14, false)
			outputChatBox("Logs into player's character.", thePlayer, 255, 194, 0, false)
		else
			targetChar = table.concat({...}, "_")
			local fetchData = mysql:query_fetch_assoc("SELECT `characters`.`id` AS `targetCharID` , `characters`.`account` AS `targetUserID` , `accounts`.`admin` AS `targetAdminLevel`, `accounts`.`username` AS `targetUsername` FROM `characters` LEFT JOIN `accounts` ON `characters`.`account`=`accounts`.`id` WHERE `charactername`='"..mysql:escape_string(targetChar).."' LIMIT 1")
			local targetCharID = tonumber(fetchData["targetCharID"]) or false
			local targetUserID = tonumber(fetchData["targetUserID"]) or false
			local targetAdminLevel = tonumber(fetchData["targetAdminLevel"]) or 0
			local targetUsername = fetchData["targetUsername"] or false
			local theAdminPower = exports.global:getPlayerAdminLevel(thePlayer)
			
			if targetCharID and  targetUserID then
				if targetAdminLevel > theAdminPower then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username")
					outputChatBox("You can't log into Character of a higher rank admin than you.", thePlayer, 255,0,0)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " "..adminUsername.." attempted to log into character of higher rank admin ("..targetUsername..").")
					return false
				end
				
				spawnCharacter(targetCharID, targetUserID, thePlayer, targetUsername)	
				
			end
		end
	end
end
addCommandHandler("loginto", adminLoginToPlayerCharacter, false, false)

function spawnCharacter(characterID, remoteAccountID, theAdmin, targetAccountName)
	if theAdmin then
		client = theAdmin
	end
	
	if not client then
		return false
	end
	
	if not characterID then
		return false
	end
	
	if not tonumber(characterID) then
		return false
	end
	characterID = tonumber(characterID)
	
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)

	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0)
	
	local timer = getElementData(client, "pd.jailtimer")
	if isTimer(timer) then
		killTimer(timer)
	end
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	-- End cleaning up
	
	local accountID = tonumber(getElementDataEx(client, "account:id"))
	
	local characterData = false
	
	if theAdmin then
		accountID = remoteAccountID
		characterData = mysql:query_fetch_assoc("SELECT * FROM `characters` LEFT JOIN `jobs` ON `characters`.`id` = `jobs`.`jobCharID` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "'")
	else
		characterData = mysql:query_fetch_assoc("SELECT * FROM `characters` LEFT JOIN `jobs` ON `characters`.`id` = `jobs`.`jobCharID` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "' AND `cked`=0")
	end
	
	if characterData then
		setElementDataEx(client, "look", fromJSON(characterData["description"]) or {"", "", "", "", characterData["description"], ""})
		
		setElementDataEx(client, "age", characterData["age"])
		setElementDataEx(client, "weight", characterData["weight"])
		setElementDataEx(client, "height", characterData["height"])
		setElementDataEx(client, "race", tonumber(characterData["skincolor"]))
		setElementDataEx(client, "maxvehicles", tonumber(characterData["maxvehicles"]))
		
		-- LANGUAGES
		local lang1 = tonumber(characterData["lang1"])
		local lang1skill = tonumber(characterData["lang1skill"])
		local lang2 = tonumber(characterData["lang2"])
		local lang2skill = tonumber(characterData["lang2skill"])
		local lang3 = tonumber(characterData["lang3"])
		local lang3skill = tonumber(characterData["lang3skill"])
		local currentLanguage = tonumber(characterData["currlang"])
		setElementDataEx(client, "languages.current", currentLanguage, false)
				
		if lang1 == 0 then
			lang1skill = 0
		end
		
		if lang2 == 0 then
			lang2skill = 0
		end
		
		if lang3 == 0 then
			lang3skill = 0
		end
		
		setElementDataEx(client, "languages.lang1", lang1, false)
		setElementDataEx(client, "languages.lang1skill", lang1skill, false)
		
		setElementDataEx(client, "languages.lang2", lang2, false)
		setElementDataEx(client, "languages.lang2skill", lang2skill, false)
		
		setElementDataEx(client, "languages.lang3", lang3, false)
		setElementDataEx(client, "languages.lang3skill", lang3skill, false)
		-- END OF LANGUAGES
		
		setElementDataEx(client, "timeinserver", tonumber(characterData["timeinserver"]), false)
		setElementDataEx(client, "account:character:id", characterID, false)
		setElementDataEx(client, "dbid", characterID, false) -- workaround
		exports['item-system']:loadItems( client, true )
		
		setElementDataEx(client, "loggedin", 1)
		
		setElementDataEx(client, "wounded", tonumber(characterData["wounded"]))
		
		-- Check his name isn't in use by a squatter
		local playerWithNick = getPlayerFromName(tostring(characterData["charactername"]))
		if isElement(playerWithNick) and (playerWithNick~=client) then
			if theAdmin then
				local adminTitle = exports.global:getPlayerAdminTitle(theAdmin)
				local adminUsername = getElementData(theAdmin, "account:username")
				kickPlayer(playerWithNick, getRootElement(), adminTitle.." "..adminUsername.." has logged into your account.")
				outputChatBox("Account "..targetAccountName.." ("..tostring(characterData["charactername"]):gsub("_"," ")..") has been kicked out of game.", theAdmin, 0, 255, 0 )
			else
				kickPlayer(playerWithNick, getRootElement(), "Someone else has logged into your character.")
			end
		end
		
		-- casual skin
		setElementDataEx(client, "casualskin", tonumber(characterData["casualskin"]), false)
		setElementDataEx(client, "bleeding", 0, false)
		
		-- Set their name to the characters
		setElementDataEx(client, "legitnamechange", 1)
		setPlayerName(client, tostring(characterData["charactername"]))
		local pid = getElementData(client, "playerid")
		local fixedName = string.gsub(tostring(characterData["charactername"]), "_", " ")

		setElementDataEx(client, "legitnamechange", 0)
	
		
		setPlayerNametagShowing(client, false)
		setElementFrozen(client, true)
		setPedGravity(client, 0)
		spawnPlayer(client, tonumber(characterData["x"]), tonumber(characterData["y"]), tonumber(characterData["z"]), tonumber(characterData["rotation"]), tonumber(characterData["skin"]))
		setElementDimension(client, tonumber(characterData["dimension_id"]))
		setElementInterior(client, tonumber(characterData["interior_id"]), tonumber(characterData["x"]), tonumber(characterData["y"]), tonumber(characterData["z"]))
		setCameraInterior(client, tonumber(characterData["interior_id"]))
		setCameraTarget(client, client)
		setElementHealth(client, tonumber(characterData["health"]))
		setPedArmor(client, tonumber(characterData["armor"]))
		
		local teamElement = nil
		if (tonumber(characterData["faction_id"])~=-1) then
			teamElement = exports.pool:getElement('team', tonumber(characterData["faction_id"]))
			if not (teamElement) then	-- Facshun does not exist?
				characterData["faction_id"] = -1
				mysql:query_free("UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. mysql:escape_string(tostring(characterID)) .. "' LIMIT 1")
			end
		end
		
		if teamElement then
			setPlayerTeam(client, teamElement)	
		else
			setPlayerTeam(client, getTeamFromName("Citizen"))
		end

		
		local adminLevel = getElementDataEx(client, "adminlevel")
		local gmLevel = getElementDataEx(client, "account:gmlevel")
		exports.global:updateNametagColor(client)
		-- ADMIN JAIL
		local jailed = getElementData(client, "adminjailed")
		local jailed_time = getElementData(client, "jailtime")
		local jailed_by = getElementData(client, "jailadmin")
		local jailed_reason = getElementData(client, "jailreason")
		
		if jailed then
			outputChatBox("You still have " .. jailed_time .. " minute(s) to serve of your admin jail sentence.", client, 255, 0, 0)
			outputChatBox(" ", client)
			outputChatBox("You were jailed by: " .. jailed_by .. ".", client, 255, 0, 0)
			outputChatBox("Reason: " .. jailed_reason, client, 255, 0, 0)
				
			local incVal = getElementData(client, "playerid")
				
			setElementDimension(client, 55000+incVal)
			setElementInterior(client, 6)
			setCameraInterior(client, 6)
			setElementPosition(client, 263.821807, 77.848365, 1001.0390625)
			setPedRotation(client, 267.438446)
						
			setElementDataEx(client, "jailserved", 0, false)
			setElementDataEx(client, "adminjailed", true)
			setElementDataEx(client, "jailreason", jailed_reason, false)
			setElementDataEx(client, "jailadmin", jailed_by, false)
			
			if jailed_time ~= 999 then
				if not getElementData(client, "jailtimer") then
					setElementDataEx(client, "jailtime", jailed_time+1, false)
					--exports['admin-system']:timerUnjailPlayer(client)
					triggerEvent("admin:timerUnjailPlayer", client, client)
				end
			else
				setElementDataEx(client, "jailtime", "Unlimited", false)
				setElementDataEx(client, "jailtimer", true, false)
			end

			
			setElementInterior(client, 6)
			setCameraInterior(client, 6)
		elseif tonumber(characterData["pdjail"]) == 1 then -- PD JAIL
			outputChatBox("You still have " .. tonumber(characterData["pdjail_time"]) .. " minute(s) to serve of your state jail sentence.", client, 255, 0, 0)
			setElementDataEx(client, "pd.jailserved", 0, false)
			setElementDataEx(client, "pd.jailtime", tonumber(characterData["pdjail_time"])+1, false)
			setElementDataEx(client, "pd.jailstation", tonumber(characterData["pdjail_station"]), false)
			exports['pd-system']:timerPDUnjailPlayer(client)
		end
		
		setElementDataEx(client, "faction", tonumber(characterData["faction_id"]), false)
		setElementDataEx(client, "factionMenu", 0)
		local factionPerks = fromJSON(characterData["faction_perks"])
		setElementDataEx(client, "factionPackages", factionPerks, false)
		setElementDataEx(client, "factionrank", tonumber(characterData["faction_rank"]), false)
		setElementDataEx(client, "factionleader", tonumber(characterData["faction_leader"]), false)
		
		-- Player is cuffed
		if (tonumber(characterData["cuffed"])==1) then
			toggleControl(client, "sprint", false)
			toggleControl(client, "fire", false)
			toggleControl(client, "jump", false)
			toggleControl(client, "next_weapon", false)
			toggleControl(client, "previous_weapon", false)
			toggleControl(client, "accelerate", false)
			toggleControl(client, "brake_reverse", false)
		end
			
		
		setElementDataEx(client, "businessprofit", 0, false)
		setElementDataEx(client, "legitnamechange", 0)
		setElementDataEx(client, "muted", tonumber(muted))
		setElementDataEx(client, "hoursplayed",  tonumber(characterData["hoursplayed"]))
		setElementDataEx(client, "alcohollevel", tonumber(characterData["alcohollevel"]) or 0, true)
		exports.global:setMoney(client, tonumber(characterData["money"]), true)
		exports.global:checkMoneyHacks(client)
		
		setElementDataEx(client, "restrain", tonumber(characterData["cuffed"]), true)
		setElementDataEx(client, "tazed", 0, false)
		setElementDataEx(client, "calling", nil, false)
		setElementDataEx(client, "calltimer", nil, false)
		setElementDataEx(client, "phonestate", 0, false)
		setElementDataEx(client, "realinvehicle", 0, false)
		
		local duty = tonumber(characterData["duty"]) or 0
		setElementDataEx(client, "duty", duty)
		
		-- Job system - MAXIME
		setElementData(client, "job", tonumber(characterData["jobID"]) or 0, true)
		setElementData(client, "jobLevel", tonumber(characterData["jobLevel"]) or 0, true)
		setElementData(client, "jobProgress", tonumber(characterData["jobProgress"]) or 0, true)
		
		setElementDataEx(client, "license.car", tonumber(characterData["car_license"]))
		setElementDataEx(client, "license.gun", tonumber(characterData["gun_license"]))
		setElementDataEx(client, "bankmoney", tonumber(characterData["bankmoney"]), false)
		setElementDataEx(client, "fingerprint", tostring(characterData["fingerprint"]), false)
		setElementDataEx(client, "tag", tonumber(characterData["tag"]))
		setElementDataEx(client, "dutyskin", tonumber(characterData["dutyskin"]), false)
		setElementDataEx(client, "blindfold", tonumber(characterData["blindfold"]), false)
		setElementDataEx(client, "gender", tonumber(characterData["gender"]))
		setElementDataEx(client, "deaglemode", 1, true) -- Default to lethal 
		setElementDataEx(client, "shotgunmode", 1, true) -- Default to lethal
		setElementDataEx(client, "clothing:id", tonumber(characterData["clothingid"]) or nil, true)
		
		if (tonumber(characterData["restrainedobj"])>0) then
			setElementDataEx(client, "restrainedObj", tonumber(characterData["restrainedobj"]), false)
		end
		
		if ( tonumber(characterData["restrainedby"])>0) then
			setElementDataEx(client, "restrainedBy",  tonumber(characterData["restrainedby"]), false)
		end
		
		if tonumber(characterData["job"]) == 1 then
			triggerClientEvent(client,"restoreTruckerJob",client)
		end
		triggerEvent("restoreJob", client)
		triggerClientEvent(client, "updateCollectionValue", client, tonumber(characterData["photos"]))
		
		-- Cleaning their old weapons
		takeAllWeapons(client)
		
		if (getElementType(client) == 'player') then
			triggerEvent("updateLocalGuns", client)
		end
		
		
		-- Weapon stats	
		for i = 69, 79 do
			setPedStat(client, i, 1000)
		end
		
		toggleAllControls(client, true, true, true)
		triggerClientEvent(client, "onClientPlayerWeaponCheck", client)
		setElementFrozen(client, false)
		
		-- blindfolds
		if (tonumber(characterData["blindfold"])==1) then
			setElementDataEx(client, "blindfold", 1)
			outputChatBox("Your character is blindfolded. If this was an OOC action, please contact an administrator via F2.", client, 255, 194, 15)
			fadeCamera(client, false)
		else
			fadeCamera(client, true, 2)
		end
		
		-- Impounded cars, old location
		
		
		setPedFightingStyle(client, tonumber(characterData["fightstyle"]))	
		triggerEvent("onCharacterLogin", client, charname, tonumber(characterData["faction_id"]))
		triggerClientEvent(client, "accounts:characters:spawn", client, fixedName, adminLevel, gmLevel, tonumber(characterData["faction_id"]), tonumber(characterData["faction_rank"]))
		triggerClientEvent(client, "item:updateclient", client)
		
		if not theAdmin then
			local motd = getElementData(getRootElement(), "account:motd") or ""
			outputChatBox("MOTD: " .. motd, source, 255, 255, 0)
		
			if ((getElementData(source, "adminlevel") or 0) > 0) then
				local amotd = getElementData(getRootElement(), "account:amotd") or ""
				outputChatBox("Admin MOTD: " .. amotd, source, 135, 206, 250)
				-- TC
				local ticketCenterQuery = mysql:query_fetch_assoc("SELECT count(*) as 'noreports' FROM `tc_tickets` WHERE `status` < 3 and `assigned`='".. mysql:escape_string(tostring(accountID)).."'")
				local unassignedTickets = mysql:query_fetch_assoc("SELECT COUNT(*) AS 'unassignedreport' FROM `tc_tickets` WHERE `status` < 3 AND `assigned` = -1")
				if (tonumber(ticketCenterQuery["noreports"]) > 0) or (tonumber(unassignedTickets["unassignedreport"]) > 0 and exports.global:isPlayerHeadAdmin(source)) then
					--outputChatBox("You have "..tostring(ticketCenterQuery["noreports"]).." report(s) assigned to you on the ticket center.", source, 135, 206, 250)
					if exports.global:isPlayerHeadAdmin(source) then
						triggerClientEvent(source, "onTipShow", source, "You have "..tostring(ticketCenterQuery["noreports"]).." report(s) assigned to you on the ticket center.\nThere are "..tostring(unassignedTickets["unassignedreport"]).." report(s) unassigned")
					else
						triggerClientEvent(source, "onTipShow", source, "You have "..tostring(ticketCenterQuery["noreports"]).." report(s) assigned to you on the ticket center.")
					end
				end
			end
		end
		
		--Impounded cars, new location by Vince
		if exports.global:hasItem(client, 2) then -- phone
			local impounded = mysql:query_fetch_assoc("SELECT COUNT(*) as 'numbr'  FROM `vehicles` WHERE `owner` = " .. mysql:escape_string(characterID) .. " and `Impounded` > 0")
			if impounded then
				local amount = tonumber(impounded["numbr"]) or 0
				if amount > 0 then
					outputChatBox("((SFT&R)) #5555 [SMS]: " .. amount .. " of your vehicles are impounded. Head over to the impound to release them.", client, 120, 255, 80)
				end
			end
		end
		
		if not theAdmin then
			mysql:query_free("UPDATE characters SET lastlogin=NOW() WHERE id='" .. mysql:escape_string(characterID) .. "'")
			exports.logs:dbLog("ac"..tostring(accountID), 27, { "ac"..tostring(accountID), source } , "Spawned" )
			local monitored = getElementData(client, "admin:monitor")
			if monitored then
				exports.global:sendMessageToAdmins("[MONITOR] ".. getPlayerName(client):gsub("_", " ") .." ("..pid.."): "..monitored)
			end
		end
		
		setTimer(setPedGravity, 2000, 1, client, 0.008)
		setElementAlpha(client, 255)
		
		-- WALKING STYLE BY ANTHONY
		local walkingstyle = characterData["walkingstyle"]
		if walkingstyle then
			if (tonumber(walkingstyle)==0) or (tonumber(walkingstyle)==54) then
				local gender = getElementData(client, "gender")
				if (gender == 0) then
					local walkingstylemale = exports.mysql:query("UPDATE characters SET walkingstyle=128 WHERE id = " .. characterID)
					if walkingstylemale then
						--outputChatBox("The CJ run has been disabled, so a walking style has been set for you.", client, 0, 255, 0)
						setElementDataEx(client, "walkingstyle", 128)
						triggerClientEvent("updateWalkingStyle", getRootElement(), 128, client)
					else
						outputDebugString("ERROR assigning male walking style to ID: " .. characterID)
					end
				elseif (gender == 1) then
					local walkingstylefemale = exports.mysql:query("UPDATE characters SET walkingstyle=129 WHERE id = " .. characterID)
					if walkingstylefemale then
						--outputChatBox("The CJ run has been disabled, so a walking style has been set for you.", client, 0, 255, 0)
						setElementDataEx(client, "walkingstyle", 129)
						triggerClientEvent("updateWalkingStyle", getRootElement(), 129, client)
					else
						outputDebugString("ERROR assigning female walking style to ID: " .. characterID)
					end
				end
			else
				triggerClientEvent("updateWalkingStyle", getRootElement(), tonumber(walkingstyle), client)
				setElementDataEx(client, "walkingstyle", tonumber(walkingstyle))
			end
		end

		-- check if the player has the duty package
		if duty > 0 then
			local foundPackage = false
			for key, value in ipairs(factionPerks) do
				if value == duty then
					foundPackage = true
					break
				end
			end
			
			if not foundPackage then
				triggerEvent("duty:offduty", client)
				outputChatBox("You don't have access to the duty you are using anymore - thus, removed.", client, 255, 0, 0)
			end
		end
		triggerEvent("social:character", client)
		exports.global:removeAnimation(client)
		
		local theTeam = getPlayerTeam( client )
		local factionType = getElementData( theTeam, "type" )
		if not theTeam or (factionType~=2) or (factionType~=3) then 
			if (factionType==2) or (factionType==3) then
				-- do nothing?
			else
				local restrictedSkins = exports['clothing']:getRestrictedSkins()
				local count = 0
				for testSkin, _ in pairs( restrictedSkins ) do
					local check, slot = exports.global:hasItem( client, 16, testSkin, true )
					while check and slot do
						local takeItem, error = exports.global:takeItemFromSlot( client, slot )
						if not takeItem then
							break
						else
							count = count + 1
						end
					end
				end
				if (count>0) then
					outputChatBox("[SERVER:] " .. count - 1 .. " clothing items were removed from your inventory because they were restricted.", client, 255, 0, 0)
				end
			end
		end
		
		if (getElementData( client, "wounded" )==1) then
			local x, y, z = getElementPosition( client )
			local _, _, rot = getElementRotation( client )
			local int, dim = getElementInterior( client ), getElementDimension( client )
			triggerEvent("es:woundedPlayer", client, client, x, y, z, rot, int, dim, true )
		end

		if theAdmin then
			local adminTitle = exports.global:getPlayerAdminTitle(theAdmin)
			local adminUsername = getElementData(theAdmin, "account:username")
			outputChatBox("You've logged into player's character successfully!", theAdmin, 0, 255, 0 )
			local hiddenAdmin = getElementData(theAdmin, "hiddenadmin")
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " "..adminUsername.." logged into an other account ("..targetAccountName..") "..tostring(characterData["charactername"]):gsub("_"," ")..".")
			end
		end
	end
end
--addEvent("accounts:characters:spawn", true)
addEventHandler("accounts:characters:spawn", getRootElement(), spawnCharacter)

function Characters_onCharacterChange()
	triggerEvent("updateCharacters", client) -- Refresh the character selection screen, perhaps? 
	triggerEvent("savePlayer", client, "Change Character")
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)
	
	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0)
	setElementDataEx(client, "bankmoney", 0)
	setElementDataEx(client, "account:character:id", false)
	setElementAlpha(client, 0)
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	exports.global:updateNametagColor(client)
	local clientAccountID = getElementDataEx(client, "account:id") or -1
	
	setElementInterior(client, 0)
	setElementDimension(client, 1)
	setElementPosition(client, -26.8828125, 2320.951171875, 24.303373336792)
	exports.logs:dbLog("ac"..tostring(clientAccountID), 27, { "ac"..tostring(clientAccountID), client } , "Went to character selection" )
end
addEventHandler("accounts:characters:change", getRootElement(), Characters_onCharacterChange)

function removeMasksAndBadges(client)
	for k, v in ipairs({exports['item-system']:getMasks(), exports['item-system']:getBadges()}) do
		for kx, vx in pairs(v) do
			if getElementData(client, vx[1]) then
				setElementDataEx(client, vx[1], false, true)
			end
		end
	end
end