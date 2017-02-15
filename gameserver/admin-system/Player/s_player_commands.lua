mysql = exports.mysql
local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

--ban banPlayerSerial ( player bannedPlayer,  player responsiblePlayer = nil, string reason = nil, bool hide = false )
function banPlayerSerial(thePlayer, theAdmin, reason, hide)
	local serial = getPlayerSerial(thePlayer)
	local result = mysql:query("SELECT * FROM bannedSerials")
	if result then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			if row["serial"] == serial then
				exports.global:sendMessageToAdmins("BAN-SYSTEM: Player " .. getPlayerName(thePlayer):gsub("_", " ") .. " is already banned. Kicking the player")
				exports.gloval:sendMessageToAdmins("            Serial: " .. serial)
				kickPlayer(thePlayer, reason)
				return
			end
		end
	end
	local entry = mysql:query_free('INSERT INTO bannedSerials (serial) VALUES ("' .. mysql:escape_string(serial) .. '")' )
	if entry then
		if not hide then
			for key, value in ipairs(getElementsByType("player")) do
				outputChatBox(exports.global:getPlayerAdminTitle(theAdmin) .. " " .. getPlayerName(theAdmin):gsub("_"," ") .. " banned player " .. getPlayerName(thePlayer):gsub("_"," "), value, 255, 0, 0)
				outputChatBox("Reason: " .. reason, value, 255, 0, 0)
			end
		else
			outputChatBox("You have banned " .. getPlayerName(thePlayer):gsub("_"," ") .. " silently.", theAdmin, 0, 255, 0)
			exports.global:sendMessageToAdmins("ADM-WARN: " .. getPlayerName(theAdmin):gsub("_"," ") .. " banned player " .. getPlayerName(thePlayer):gsub("_"," ") .. " silently.")
			exports.global:sendMessageToAdmins("          Reason: " .. reason)
		end
		kickPlayer(thePlayer, theAdmin, reason)
		exports.global:updateBans()
		for key, value in ipairs(getElementsByType("player")) do
			if getPlayerSerial(value) == serial then
				kickPlayer(value, showingPlayer, reason)
			end
		end
	else
		outputDebugString("ERROR BANNING PLAYER BY SERIAL!")
	end
end
		
	

--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==0) then
						outputChatBox("Player is not restrained.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
						outputChatBox("You have uncuffed " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
						exports.global:removeAnimation(targetPlayer)
						mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports['item-system']:deleteAll(47, getElementData( targetPlayer, "dbid" ))
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local any = false
					local masks = exports['item-system']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, value[1], false, true)
						end
					end
					
					if any then
						outputChatBox("Your mask has been removed by admin "..username, targetPlayer, 255, 0, 0)
						outputChatBox("You have removed the mask from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("Player is not masked.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")
					
					if (blindfolded==0) then
						outputChatBox("Player is not blindfolded", thePlayer, 255, 0, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "blindfold", false, false)
						fadeCamera(targetPlayer, true)
						outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
						outputChatBox("You have been unblindfolded by admin " .. username .. ".", thePlayer)
						mysql:query_free("UPDATE characters SET blindfold = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local muted = getElementData(targetPlayer, "muted") or 0
					if muted == 0 then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 1, false)
						outputChatBox(targetPlayerName .. " is now muted from OOC.", thePlayer, 255, 0, 0)
						outputChatBox("You were muted by '" .. getPlayerName(thePlayer):gsub("_"," ") .. "'.", targetPlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "MUTE")
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 0, false)
						outputChatBox(targetPlayerName .. " is now unmuted from OOC.", thePlayer, 0, 255, 0)
						outputChatBox("You were unmuted by '" .. getPlayerName(thePlayer):gsub("_"," ") .. "'.", targetPlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMUTE")
					end
					mysql:query_free("UPDATE accounts SET muted=" .. mysql:escape_string(getElementData(targetPlayer, "muted")) .. " WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['item-system']:takeItem(targetPlayer, i) do
						end
					end
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer):gsub("_"," ") .. " has disarmed " .. targetPlayerName..".")
					outputChatBox("You have been disarmed by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer):gsub("_"," ")..".", targetPlayer, 255, 0, 0)
					outputChatBox(targetPlayerName .. " is now disarmed.", thePlayer, 255, 0, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminName = getPlayerName(thePlayer):gsub("_"," ")
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. adminName .. " reconnected " .. targetPlayerName )
				outputChatBox("Player '" .. targetPlayerName .. "' was forced to reconnect.", thePlayer, 255, 0, 0)
					
				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, getRootElement(), "You were forced to reconnect by "..tostring(adminTitle) .. " " .. adminName ..".")
				addEventHandler("onPlayerQuit", targetPlayer, function( ) killTimer( timer ) end)
				redirectPlayer ( targetPlayer )
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)
addCommandHandler("frec", forceReconnect, false, false)

-- /MAKEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player a weapon.", thePlayer, 150, 150, 150)
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] [Quantity]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of weapons.", thePlayer, 150, 150, 150)
			outputChatBox("(Type /gunlist or hit F4 to open Weapon Creator)", thePlayer, 0, 255, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local quantity = tonumber(args[2])
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then 
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then 
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then 
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then 
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEGUN] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end
				
				if getAmmoPerClip(weaponID) == "disabled" then
						outputChatBox("[MAKEGUN] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
						return
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("[MAKEGUN] Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then		
					
					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))
					
					if quantity == nil then
						quantity = 1
					end
					
					local count = 0
					local fails = 0
					local allSerials = ""
					local give, error = ""
					for variable = 1, quantity, 1 do
						local mySerial = exports.global:createWeaponSerial( 1, adminDBID, playerDBID)
						give, error = exports.global:giveItem(targetPlayer, 115, weaponID..":"..mySerial..":"..getWeaponNameFromID(weaponID))
						if give then 
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weaponID).." "..tostring(mySerial))
							if count == 0 then
								allSerials = mySerial
							else
								allSerials = allSerials.."', '"..mySerial
							end
							count = count + 1
						else
							fails = fails + 1
						end
					end
					if count > 0 then 
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						--Inform Spawner
						outputChatBox("[MAKEGUN] You have given (x"..count..") ".. getWeaponNameFromID(weaponID).." to "..targetPlayerName..".", thePlayer, 0, 255, 0)
						--Inform Player
						outputChatBox("You've received (x"..count..") ".. getWeaponNameFromID(weaponID).." from "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
						--Send adm warning
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " (x"..count..") " .. getWeaponNameFromID(weaponID) .. " with serial '"..allSerials.."'")
					end
					if fails > 0 then
						outputChatBox("[MAKEGUN] "..fails.." weapons couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." weapons couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)
addEvent("onMakeGun", true)
addEventHandler("onMakeGun", getRootElement(), givePlayerGun)

-- /makeammo
function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] ", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of clips and amount of ammo in each clip.", thePlayer, 150, 150, 150)
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] [Amount/clip,-1=full clip] [quantity]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of clips and amount of ammo in each clip.", thePlayer, 150, 150, 150)
			outputChatBox("(Type /gunlist or hit F4 to open Weapon Creator)", thePlayer, 0, 255, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local ammo = tonumber(args[2]) or -1
				local quantity = tonumber(args[3]) or -1
				
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then 
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then 
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then 
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then 
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEAMMO] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end
				
				if getAmmoPerClip(weaponID) == "disabled" then --If weapon is not allowed
					outputChatBox("[MAKEAMMO] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
					return
				elseif getAmmoPerClip(weaponID) == tostring(0)  then-- if weapon doesn't need ammo to work
					outputChatBox("[MAKEAMMO] This weapon doesn't use ammo.", thePlayer, 255, 0, 0)
					return
				else
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if ammo == -1 then -- if full ammopack
						ammo = getAmmoPerClip(weaponID)
					end
					
					if quantity == -1 then
						quantity = 1
					end
					
					local maxAmountOfAmmopacks = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfAmmopacks' ))
					if quantity > maxAmountOfAmmopacks then 
						quantity = maxAmountOfAmmopacks
						outputChatBox("[MAKEAMMO] You can't give more than "..maxAmountOfAmmopacks.." magazines at a time. Trying to spawn "..maxAmountOfAmmopacks.."...", thePlayer, 150, 150, 150)
					end
					
					local count = 0
					local fails = 0
					local give, error = "" 
					for variable = 1, quantity, 1 do
						give, error = exports.global:giveItem(targetPlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
						if give then
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS "..getWeaponNameFromID(weaponID).." "..tostring(ammo))
							count = count + 1
						else
							fails = fails + 1
						end
					end
					
					if count > 0 then 
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						--Inform Spawner
						outputChatBox("[MAKEAMMO] You have given (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) to "..targetPlayerName..".", thePlayer, 0, 255, 0)
						--Inform Player
						outputChatBox("You've received (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) from "..adminTitle.." "..getPlayerName(thePlayer), targetPlayer, 0, 255, 0)
						--Send adm warning
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) to " .. targetPlayerName)
					end
					if fails > 0 then
						outputChatBox("[MAKEAMMO] "..fails.." ammopacks couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." ammopacks couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end
					
					
				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)
addEvent("onMakeAmmo", true)
addEventHandler("onMakeAmmo", getRootElement(), givePlayerGunAmmo)

function getAmmoPerClip(id)
	if id == 0 then 
		return tostring(get( getResourceName( getThisResource( ) ).. '.fist' ))
	elseif id == 1 then 
		return tostring(get( getResourceName( getThisResource( ) ).. '.brassknuckle' ))
	elseif id == 2 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.golfclub' ))
	elseif id == 3 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightstick' ))
	elseif id == 4 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.knife' ))
	elseif id == 5 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.bat' ))
	elseif id == 6 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shovel' ))
	elseif id == 7 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.poolstick' ))
	elseif id == 8 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.katana' ))
	elseif id == 9 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.chainsaw' ))
	elseif id == 10 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.dildo' ))
	elseif id == 11 then
		return tostring(get( getResourceName( getThisResource( ) ).. 'dildo2' ))
	elseif id == 12 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator' ))
	elseif id == 13 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator2' ))
	elseif id == 14 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.flower' ))
	elseif id == 15 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.cane' ))
	elseif id == 16 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.grenade' ))
	elseif id == 17 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.teargas' ))
	elseif id == 18 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.molotov' ))
	elseif id == 22 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.colt45' ))
	elseif id == 23 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.silenced' ))
	elseif id == 24 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.deagle' ))
	elseif id == 25 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shotgun' ))
	elseif id == 26 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sawed-off' ))
	elseif id == 27 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.combatshotgun' ))
	elseif id == 28 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.uzi' ))
	elseif id == 29 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.mp5' ))
	elseif id == 30 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.ak-47' ))
	elseif id == 31 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.m4' ))
	elseif id == 32 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.tec-9' ))
	elseif id == 33 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rifle' ))
	elseif id == 34 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sniper' ))
	elseif id == 35 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rocketlauncher' ))
	--elseif id == 39 then -- Satchel
	--elseif id == 40 then -- Satchel remote (Bomb)
	elseif id == 41 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.spraycan' ))
	elseif id == 42 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.fireextinguisher' ))
	elseif id == 43 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.camera' ))
	elseif id == 44 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightvision' ))
	elseif id == 45 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.infrared' ))
	--elseif id == 46 then -- Parachute
	else
		return "disabled"
	end
	return "disabled"
end
addEvent("onGetAmmoPerClip", true)
addEventHandler("onGetAmmoPerClip", getRootElement(), getAmmoPerClip)

function loadWeaponStats()
	for id = 0, 45, 1 do 
		if id ~= 19 and id ~= 20 and id ~=21 then
			local tmp = getAmmoPerClip(id)
			if tmp == "disable" then 
				setWeaponProperty( id , "std", "maximum_clip_ammo", 0)
			else
				setWeaponProperty( id , "std", "maximum_clip_ammo", tmp)
			end
		end
	end
end
addEventHandler ( "onResourceStart", getRootElement(), loadWeaponStats )


-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if ( itemID == 74 or itemID == 75 or itemID == 2 or itemID == 84) and not exports.global:isPlayerLeadAdmin(thePlayer) then
					-- Block for Bomb, Bomb Remote, cellphone, Police Radar (DEV),  from admins.
				elseif (itemID == 115 or itemID == 116 or itemID == 68 or itemID == 134 or itemID == 137) then
					outputChatBox("Sorry, you cannot use this with /giveitem.", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " has received a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has given you a " .. name .. " with value " .. itemValue .. ".", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Couldn't give " .. targetPlayerName .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if exports.global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took item " .. itemID .. " with the value of (" .. itemValue .. ") from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.global:takeItem(targetPlayer, itemID, itemValue)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))
						
						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "adminlevel" ) < getElementData( targetPlayer, "adminlevel" ) then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

-- /SETARMOR
function setPlayerArmour(thePlayer, theCommand, targetPlayer, armor)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (armor) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					if (tostring(type(tonumber(armor))) == "number") then
						local targetPlayerFaction = getElementData(targetPlayer, "faction")
						if (targetPlayerFaction == 1) then
							local setArmor = setPedArmor(targetPlayer, tonumber(armor))
							outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR " ..tostring(armor))
						elseif (targetPlayerFaction ~= 1) then
							if (exports.global:isPlayerLeadAdmin(thePlayer)) then
								local setArmor = setPedArmor(targetPlayer, tonumber(armor))
								outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, tagetPlayer, "SETARMOR " ..tostring(armor))
							else
								outputChatBox("This player is not in a law enforcement faction. Contact an administrator to set armor.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)
		

-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Skin ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0) then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)
					
					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local skin = setElementModel(targetPlayer, tonumber(skinID))
					
					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) then
						outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Player " .. targetPlayerName .. " has received skin " .. skinID .. ".", thePlayer, 0, 255, 0)
						mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string(skinID) .. " WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN "..tostring(skinID))
					end
				else
					outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if newName == targetPlayerName then
					outputChatBox( "The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					local result = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. mysql:escape_string(newName) .. "' AND id != " .. mysql:escape_string(dbid))
					
					if (mysql:num_rows(result)>0) then
						outputChatBox("This name is already in use.", thePlayer, 255, 0, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))
						
						if (name) then
							exports['cache']:clearCharacterName( dbid )
							mysql:query_free("UPDATE characters SET charactername='" .. mysql:escape_string(newName) .. "' WHERE id = " .. mysql:escape_string(dbid))
							
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							local processedNewName = string.gsub(tostring(newName), "_", " ")
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
							outputChatBox("You character's name has been changed from '"..targetPlayerName .. "' to '" .. tostring(newName) .. "' by "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							outputChatBox("You changed " .. targetPlayerName .. "'s name to '" .. processedNewName .. "'.", thePlayer, 0, 255, 0)
							
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
							
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "CHANGENAME "..targetPlayerName.." -> "..tostring(newName))
							triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
					end
					mysql:free_result(result)
				end
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)
	
-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("You cannot slap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)
					
					if (isPedInVehicle(targetPlayer)) then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)
					
					setElementPosition(targetPlayer, x, y, z+5)
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " slapped " .. targetPlayerName .. ".")
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- HEADS Hidden OOC
function hiddenOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local players = exports.pool:getPoolElementsByType("player")
			local message = table.concat({...}, " ")
			
			for index, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
			
				if (logged==1) and getElementData(arrayPlayer, "globalooc") == 1 then
					outputChatBox("(( Hidden Admin: " .. message .. " ))", arrayPlayer, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ho", hiddenOOC, false, false)

-- HEADS Hidden Whisper
function hiddenWhisper(thePlayer, command, who, ...)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==1) then
					local playerName = getPlayerName(thePlayer)
					outputChatBox("PM From Hidden Admin: " .. message, targetPlayer, 255, 194, 14)
					outputChatBox("Hidden PM Sent to " .. targetPlayerName .. ": " .. message, thePlayer, 255, 194, 14)
				elseif (logged==0) then
					outputChatBox("Player is not logged in yet.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("hw", hiddenWhisper, false, false)

-- Kick
function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower < thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',1,0,"' .. mysql:escape_string(reason) .. '")' )
				
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox("AdmKick: " .. adminTitle .. " " .. playerName .. " kicked " .. targetPlayerName .. ".", getRootElement(), 255, 0, 51)
					outputChatBox("AdmKick: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
					kickPlayer(targetPlayer, thePlayer, reason)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the kick command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)

function makePlayerAdmin(thePlayer, commandName, who, rank)
	if exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer) then
		if not (who) or not (tonumber(rank)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Rank]", thePlayer, 255, 194, 14)
			outputChatBox("Rank 1 = Game Moderator", thePlayer, 255, 194, 14)
			outputChatBox("Rank 2 = Game Administrator", thePlayer, 255, 194, 14)
			outputChatBox("Rank 3 = Lead Administrator", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			local username = false
			local targetUsername = false
			rank = tonumber(rank)	
			if (targetPlayer) then
				targetUsername = getElementData(targetPlayer, "account:username")
			else
				targetUsername = who
				local mQuery1 = mysql:query("SELECT * FROM `accounts` WHERE `username`='".. mysql:escape_string( targetUsername ) .."'")
				if mysql:fetch_assoc(mQuery1)["username"] then
					mysql:free_result(mQuery1)
				else
					outputChatBox("Partial Player Name/ID or Username not found!", thePlayer, 255, 194, 14)
					return
				end
			end
			
			username = getPlayerName(thePlayer)
			local query = mysql:query_free("UPDATE accounts SET admin='" .. mysql:escape_string(rank) .. "', adminduty='0' WHERE username='" .. mysql:escape_string(targetUsername) .. "'")
			
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			if targetPlayer then
				if (rank > 0) or (rank == -999999999) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
				else
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				end
				if rank == 0 then
					outputChatBox(adminTitle .. " " .. username .. " removed your staff rank.", targetPlayer, 255, 194, 14)
					outputChatBox("You set " .. targetPlayerName .. " to Player.", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				else
					outputChatBox(adminTitle .. " " .. username .. " set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
					outputChatBox("You set " .. targetPlayerName .. "'s Admin rank to " .. tostring(rank) .. ".", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", rank, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
				end
								
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "MAKEADMIN " .. rank)
				exports.global:updateNametagColor(targetPlayer)
			end
			exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " set " .. targetPlayerName .. "'s admin level to " .. rank .. ".")
		end
	end
end
addCommandHandler("makeadmin", makePlayerAdmin, false, false)

function setMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)
				exports.global:setMoney(targetPlayer, money)
				outputChatBox(targetPlayerName .. " has received " .. exports.global:formatMoney(money) .. " $.", thePlayer)
				outputChatBox("Admin " .. username .. " set your money to " .. exports.global:formatMoney(money) .. " $.", targetPlayer)
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function giveMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEMONEY " ..money)
				exports.global:giveMoney(targetPlayer, money)
				outputChatBox("You have given " .. targetPlayerName .. " $" .. exports.global:formatMoney(money) .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you: $" .. exports.global:formatMoney(money) .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

function freezePlayer(thePlayer, commandName, target)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local adminName = getPlayerName(thePlayer):gsub("_"," ")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by ".. adminTitle .." " .. adminName .. ". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by ".. adminTitle .." " .. adminName .. ". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end
				
				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /unfreeze [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local adminName = getPlayerName(thePlayer):gsub("_"," ")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by ".. adminTitle .." " .. adminName .. ". Thanks for your co-operation.", targetPlayer)
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", false, false)
					outputChatBox(" You have been unfrozen by ".. adminTitle .." " .. adminName .. ". Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function adminDuty(thePlayer, commandName)
	if exports.global:isPlayerModerator(thePlayer) then
		local adminduty = getElementData(thePlayer, "adminduty")
		local username = getPlayerName(thePlayer)
		
		if (adminduty==0) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 1, false)
			outputChatBox("You went on admin duty.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " came on duty.")
		elseif (adminduty==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 0, false)
			outputChatBox("You went off admin duty.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " went off duty.")
		end
		mysql:query_free("UPDATE accounts SET adminduty=" .. mysql:escape_string(getElementData(thePlayer, "adminduty")) .. " WHERE id = '" .. mysql:escape_string(getElementData(thePlayer, "account:id")).."'" )
		exports.global:updateNametagColor(thePlayer)
	end
end
addCommandHandler("adminduty", adminDuty, false, false)

----------------------------[SET MOTD]---------------------------------------
function setMOTD(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: " .. commandName .. " [message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local query = mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(message) .. "' WHERE name='motd'")
			triggerClientEvent("updateMOTD", thePlayer, message)
			
			if (query) then
				outputChatBox("MOTD set to '" .. message .. "'.", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "SETMOTD "..message)
				exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:motd", message, false )
			else
				outputChatBox("Failed to set MOTD.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setmotd", setMOTD, false, false)

function getMOTD(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local motd = getElementData(getRootElement(), "account:motd") or ""
		outputChatBox("MOTD: " .. motd, thePlayer, 255, 194, 14)
	end
end
addCommandHandler("motd", getMOTD, false, false)


----------------------------[SET ADMIN MOTD]---------------------------------------
function setAdminMOTD(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: " .. commandName .. " [message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local query = mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(message) .. "' WHERE name='amotd'")
			
			if (query) then
				outputChatBox("Admin MOTD set to '" .. message .. "'.", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "SETADMINMOTD "..message)
				exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:amotd", message, false )
			else
				outputChatBox("Failed to set MOTD.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setamotd", setAdminMOTD, false, false)

function getAdminMOTD(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local amotd = getElementData(getRootElement(), "account:amotd") or ""
		outputChatBox("Admin MOTD: " .. amotd, thePlayer, 135, 206, 250)
		local accountID = tonumber(getElementData(thePlayer, "account:id"))
		local ticketCenterQuery = mysql:query_fetch_assoc("SELECT count(*) as 'noreports' FROM `tc_tickets` WHERE `status` < 3 and `assigned`='".. mysql:escape_string(accountID).."'")
		if (tonumber(ticketCenterQuery["noreports"]) > 0) then
			outputChatBox("You have "..tostring(ticketCenterQuery["noreports"]).." report(s) assigned to you on the ticket center.", thePlayer, 135, 206, 250)
		end
	end
end
addCommandHandler("amotd", getAdminMOTD, false, false)

-- GET PLAYER ID
function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
		
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s ID is " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			
			if (seat~=0) then
				outputChatBox("You must be the driver to eject.", thePlayer, 255, 0, 0)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
				
				if not (targetPlayer) then
				elseif (targetPlayer==thePlayer) then
					outputChatBox("You cannot eject yourself.", thePlayer, 255, 0, 0)
				else
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)
					
					if targetvehicle~=vehicle and not exports.global:isPlayerAdmin(thePlayer) then
						outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						triggerEvent("removeTintName", targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)

-- RESET CHARACTER
function resetCharacter(thePlayer, commandName, ...)
    if exports.global:isPlayerLeadAdmin(thePlayer) then
        if not (...) then
            outputChatBox("SYNTAX: /" .. commandName .. " [exact character name]", thePlayer, 255, 0, 0)
        else
            local character = table.concat({...}, "_")
            if getPlayerFromName(character) then
				kickPlayer(getPlayerFromName(character), "Character Reset")
            end                    
            local result = mysql:query_fetch_assoc("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(character) .. "'")
            local charid = tonumber(result["id"])
            local account = tonumber(result["account"])
            if charid then
                -- delete all in-game vehicles
                for key, value in pairs( getElementsByType( "vehicle" ) ) do
                    if isElement( value ) then
                        if getElementData( value, "owner" ) == charid then
                            call( getResourceFromName( "item-system" ), "deleteAll", 3, getElementData( value, "dbid" ) )
                            destroyElement( value )
                        end
                    end
                end
                mysql:query_free("DELETE FROM vehicles WHERE owner = " .. mysql:escape_string(charid) )
                -- un-rent all interiors
                local old = getElementData( thePlayer, "dbid" )
                exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "dbid", charid, false )
                local result = mysql:query("SELECT id FROM interiors WHERE owner = " .. mysql:escape_string(charid) .. " AND type != 2" )
                if result then
                    local continue = true
                    while continue do
                        local row = mysql:fetch_assoc(result)
                        if not row then break end
                        local id = tonumber(row["id"])
                        call( getResourceFromName( "interior-system" ), "publicSellProperty", thePlayer, id, false, false )
                    end
                end
                exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "dbid", old, false )
                -- get rid of all items, give him default items back
                mysql:query_free("DELETE FROM items WHERE type = 1 AND owner = " .. mysql:escape_string(charid) )
                -- get the skin
                local skin = 264
                local skinr = mysql:query_fetch_assoc("SELECT skin FROM characters WHERE id = " .. mysql:escape_string(charid) )
                if skinr then
                    skin = tonumber(skinr["skin"]) or 264
                end
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 16, " .. mysql:escape_string(skin) .. ")" )
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 17, 1)" )
                mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 18, 1)" )
                -- delete wiretransfers
                mysql:query_free("DELETE FROM wiretransfers WHERE `from` = " .. mysql:escape_string(charid) .. " OR `to` = " .. mysql:escape_string(charid) )
                -- set spawn at unity, strip off money etc
                mysql:query_free("UPDATE characters SET x=1742.1884765625, y=-1861.3564453125, z=13.577615737915, rotation=0, faction_id=-1, faction_rank=0, faction_leader=0, car_license=0, gun_license=0, lastarea='El Corona', lang1=1, lang1skill=100, lang2=0, lang2skill=0, lang3=0, lang3skill=0, currLang=1, money=250, bankmoney=500, interior_id=0, dimension_id=0, health=100, armor=0, fightstyle=0, pdjail=0, pdjail_time=0, restrainedobj=0, restrainedby=0, fish=0, truckingruns=0, truckingwage=0, blindfold=0 WHERE id = " .. mysql:escape_string(charid) )
                outputChatBox("You stripped " .. character .. " off their possession.", thePlayer, 0, 255, 0)
                local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
                exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has reset " .. character .. ".")
                exports.logs:dbLog(thePlayer, 4, "ch"..tostring(charid), "RESETCHARACTER")
            else
                outputChatBox("Couldn't find " .. character, thePlayer, 255, 0, 0)
            end
        end
	end
end
addCommandHandler("resetcharacter", resetCharacter)

function resetCharacterPosition(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin(thePlayer) then
		local spawnPoints ={ 
			igs = {1949.7724609375, -1793.298828125, 13.546875},
			unity = { 1792.423828125, -1861.041015625, 13.578001022339},
			cityhall = { 1481.7568359375, -1739.0322265625, 13.546875},
			bank = { 594.1728515625, -1239.8916015625, 17.976270675659},
		}
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [exact character name]", thePlayer, 255, 0, 0)
		else
			local character = table.concat({...}, "_")
			if getPlayerFromName(character) then
				kickPlayer(getPlayerFromName(character), "Character Position Reset")
			end
				
			local result = mysql:query_fetch_assoc("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(character) .. "'")
			local charid = false
			local account = false
			if result then 
				charid = tonumber(result["id"])
				account = tonumber(result["account"])	
			end
			if charid then
				
				mysql:query_free("UPDATE characters SET x = 1949.7724609375, y = -1793.298828125, z = 13.546875 WHERE id = " .. mysql:escape_string(charid) )
				outputChatBox("You reset " .. character .. "'s position.", thePlayer, 0, 255, 0)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if hiddenAdmin == 0 then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has reset " .. character .. "'s spawn position.")
				else
					exports.global:sendMessageToAdmins("AdmCmd: A hidden admin has reset " .. character .. "'s spawn position.")
				end
				exports.logs:dbLog(thePlayer, 4, "ch"..tostring(charid), "RESETPOS")
			else
				outputChatBox("Couldn't find " .. character, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resetpos", resetCharacterPosition)

function nudgePlayer(thePlayer, commandName, targetPlayer)
   if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
      if not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
         
         if targetPlayer then
            local logged = getElementData(targetPlayer, "loggedin")
            
            if (logged==0) then
               outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
            else                     
               triggerClientEvent ( "playNudgeSound", targetPlayer)
               outputChatBox("You have nudged " .. targetPlayerName .. ".", thePlayer)
			   if exports.global:isPlayerAdmin(thePlayer) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox("You have been nudged by "..tostring(adminTitle).." " .. getPlayerName(thePlayer) .. ".", targetPlayer)
			   end
            end
         end
      end
   end
end
addCommandHandler("nudge", nudgePlayer, false, false)

    --/SETAGE
    function asetPlayerAge(thePlayer, commandName, targetPlayer, age)
       if (exports.global:isPlayerAdmin(thePlayer)) then
          if not (age) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Age]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local ageint = tonumber(age)
             if (ageint>99) or (ageint<16) then
                outputChatBox("You cannot set the age to that.", thePlayer, 255, 0, 0)
             else
                mysql:query_free("UPDATE characters SET age='" .. mysql:escape_string(age) .. "' WHERE id = " .. mysql:escape_string(dbid))
             exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "age", age, true)
                outputChatBox("You changed " .. targetPlayerName .. "'s age to " .. age .. ".", thePlayer, 0, 255, 0)
                outputChatBox("Your age was set to " .. age .. ".", targetPlayer, 0, 255, 0)   
             end
          end
       end
    end
    addCommandHandler("setage", asetPlayerAge)
	
    --/SETHEIGHT
    function asetPlayerHeight(thePlayer, commandName, targetPlayer, height)
       if (exports.global:isPlayerAdmin(thePlayer)) then
          if not (height) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Height (150 - 200)]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local heightint = tonumber(height)
             if (heightint>200) or (heightint<150) then
                outputChatBox("You cannot set the height to that.", thePlayer, 255, 0, 0)
             else
                mysql:query_free("UPDATE characters SET height='" .. mysql:escape_string(height) .. "' WHERE id = " .. mysql:escape_string(dbid))
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "height", height, true)
                outputChatBox("You changed " .. targetPlayerName .. "'s height to " .. height .. " cm.", thePlayer, 0, 255, 0)
                outputChatBox("Your height was set to " .. height .. " cm.", targetPlayer, 0, 255, 0)   
             end
          end
       end
    end
    addCommandHandler("setheight", asetPlayerHeight)
	
    --/SETRACE
    function asetPlayerRace(thePlayer, commandName, targetPlayer, race)
       if (exports.global:isPlayerAdmin(thePlayer)) then
          if not (race) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [0= Black, 1= White, 2= Asian]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local raceint = tonumber(race)
             if (raceint>2) or (raceint<0) then
                outputChatBox("Error: Please chose either 0 for black, 1 for white, or 2 for asian.", thePlayer, 255, 0, 0)
             else
             mysql:query_free("UPDATE characters SET skincolor='" .. mysql:escape_string(race) .. "' WHERE id = " .. mysql:escape_string(dbid))
				if (raceint==0) then
				    outputChatBox("You changed " .. targetPlayerName .. "'s race to black.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to black.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==1) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to white.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to white.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==2) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to asian.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to asian.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				end  
             end
          end
       end
    end
    addCommandHandler("setrace", asetPlayerRace)

    --/SETGENDER
    function asetPlayerGender(thePlayer, commandName, targetPlayer, gender)
       if (exports.global:isPlayerAdmin(thePlayer)) then
          if not (gender) or not (targetPlayer) then
             outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [0= Male, 1= Female]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local genderint = tonumber(gender)
             if (genderint>1) or (genderint<0) then
                outputChatBox("Error: Please choose either 0 for male, or 1 for female.", thePlayer, 255, 0, 0)
             else
             mysql:query_free("UPDATE characters SET gender='" .. mysql:escape_string(gender) .. "' WHERE id = " .. mysql:escape_string(dbid))
			 exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "gender", gender, true)
				if (genderint==0) then
				    outputChatBox("You changed " .. targetPlayerName .. "'s gender to Male.", thePlayer, 0, 255, 0)
				    outputChatBox("Your gender was set to Male.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (genderint==1) then
					outputChatBox("You changed " .. targetPlayerName .. "'s gender to Female.", thePlayer, 0, 255, 0)
				    outputChatBox("Your gender was set to Female.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				end  
             end
          end
       end
    end
    addCommandHandler("setgender", asetPlayerGender)
	
	
function unRecovery(thePlayer, commandName, targetPlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	if exports.global:isPlayerAdmin(thePlayer) or (factionType==4) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			setElementFrozen(targetPlayer, false)
			mysql:query_free("UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
			mysql:query_free("UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
			exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(targetPlayer):gsub("_"," ") .. " was removed from recovery by " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
			outputChatBox("You are no longer in recovery!", targetPlayer, 0, 255, 0) -- Let them know about it!
			exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNRECOVERY")
		end
	end
end
addCommandHandler("unrecovery", unRecovery)

function checkSkin ( thePlayer, commandName)
	outputChatBox ( "Your skin ID is: " .. getPedSkin ( thePlayer ), thePlayer)
end
addCommandHandler ( "checkskin", checkSkin )

--/SETINTERIOR, /SETINT
function setPlayerInterior(thePlayer, commandName, targetPlayer, interiorID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local interiorID = tonumber(interiorID)
		if (not targetPlayer) or (not interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Interior ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0, false)
				else
					if (interiorID >= 0 and interiorID <= 255) then
						local username = getPlayerName(thePlayer)
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementInterior(targetPlayer, interiorID)
						outputChatBox(adminTitle .. " " .. username .. " has changed your interior ID to " .. tostring(interiorID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " interior ID to " .. tostring(interiorID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETINTERIOR " .. tostring(interiorID))
					else
						outputChatBox("Invalid interior ID (0-255).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setint", setPlayerInterior, false, false)
addCommandHandler("setinterior", setPlayerInterior, false, false)

--/SETDIMENSION, /SETDIM
function setPlayerDimension(thePlayer, commandName, targetPlayer, dimensionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local dimensionID = tonumber(dimensionID)
		if (not targetPlayer) or (not dimensionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Dimension ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0, false)
				else
					if (dimensionID >= 0 and dimensionID <= 65535) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementDimension(targetPlayer, dimensionID)
						outputChatBox(adminTitle .. " " .. username .. " has changed your dimension ID to " .. tostring(dimensionID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " dimension ID to " .. tostring(dimensionID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETDIMENSION " .. tostring(dimensionID))
					else
						outputChatBox("Invalid dimension ID (0-65535).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setdim", setPlayerDimension, false, false)
addCommandHandler("setdimension", setPlayerDimension, false, false)