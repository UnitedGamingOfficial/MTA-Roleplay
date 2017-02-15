mysql = exports.mysql

-- [playerElement] = { 9mmhits, 556hits, 762hits, sniperhits, 12ghits, countryhits, mischits }
playerHits = { }
resetTimers = { }
animTimers = { }

function damageKeeper( attacker, weapon, bodypart, loss )
	if not playerHits[source] then
		playerHits[source] = { 0, 0, 0, 0, 0, 0, 0 }
	end
	local wasAttacked = false
	if trackedWeapons[weapon] then
		for k, v in pairs( weaponNames ) do
			for _,weaponID in pairs( v ) do
				if ( weapon == weaponID ) then
					local oldShots = playerHits[source][k] or 0
					playerHits[source][k] = oldShots + 1
					wasAttacked = true
					break
				end
			end
		end
	else
		if attacker and (attacker~=source) then
			local oldShots = playerHits[source][7] or 0
			playerHits[source][7] = oldShots + 1
			wasAttacked = true
		end
	end
	
	if wasAttacked then
		setElementData( source, "woundedTable", playerHits[ source ] )
		if resetTimers[source] then
			realEndTimer( source )
		end
		resetTimers[source] = setTimer( clearDamages, 120000, 1, source )
	end
end
addEventHandler( "onPlayerDamage", getRootElement( ), damageKeeper )

function clearDamages( player )
	if playerHits[player] then
		playerHits[player] = { 0, 0, 0, 0, 0, 0, 0 }
		removeElementData( player, "woundedTable" )
	end
	if resetTimers[player] then realEndTimer(player) end
end

function realEndTimer( player )
	if resetTimers[player] then
		killTimer( resetTimers[player] )
		resetTimers[player] = nil
	end
end

function checkInjuries( thePlayer, commandName, targetPlayer )
	if exports.global:isPlayerAdmin( thePlayer ) --[[ or es ]] then
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local injuryTable = getElementData( targetPlayer, "woundedTable" )
				local found = { }
				outputChatBox("Injuries for: " .. targetPlayerName:gsub("_", " ") .. " (" .. getElementData( targetPlayer, "playerid" ) .. ")", thePlayer, 0, 170, 0)
				if injuryTable then
					for i = 1, #injuryTable do
						if injuryTable[i]>0 then
							found[i] = true
						end
					end
					
					if (#found>1) then
						for injuryEntry, _ in pairs( found ) do
							outputChatBox("     " .. stringNames[injuryEntry] .. " hits: " .. injuryTable[injuryEntry] .. ".", thePlayer, 200, 255, 200)
						end
					else
						outputChatBox("     No injuries.", thePlayer, 200, 255, 200)
					end
				else
					outputChatBox("     No injuries.", thePlayer, 200, 255, 200)
				end
			end
		end
	end
end
addCommandHandler("injuries", checkInjuries)
addCommandHandler("examine", checkInjuries)

addCommandHandler("checkeverything",
	function( p, c )
		if not exports.global:isPlayerScripter( p ) then return end
		for k, v in pairs( playerHits ) do
			outputChatBox("9mm: " .. getPlayerName( k ) .. ": " .. v[1], p )
			outputChatBox("556: " .. getPlayerName( k ) .. ": " .. v[2], p )
			outputChatBox("762: " .. getPlayerName( k ) .. ": " .. v[3], p )
			outputChatBox("sniper: " .. getPlayerName( k ) .. ": " .. v[4], p )
			outputChatBox("12g: " .. getPlayerName( k ) .. ": " .. v[5], p )
			outputChatBox("country: " .. getPlayerName( k ) .. ": " .. v[6], p )
			outputChatBox("misc: " .. getPlayerName( k ) .. ": " .. v[7], p )
		end
	end
)

addCommandHandler("dofakedamage",
	function( p, c )
		if not exports.global:isPlayerScripter( p ) then return end
		triggerEvent("onPlayerDamage", p, p, 24, 3, 12)
		triggerEvent("onPlayerDamage", p, p, 24, 3, 12)
		triggerEvent("onPlayerDamage", p, p, 31, 3, 12)
	end
)

addEventHandler("onPlayerQuit", getRootElement( ), 
	function( )
		realEndTimer( source )
		playerHits[source] = nil
		
		if animTimers[source] then
			killTimer(animTimers[source])
			animTimers[source] = nil
		end
	end
)

addEventHandler("onElementDataChange", getRootElement( ), 
	function( dataName, old )
		if ( getElementType( source ) == "player" ) then
			if (dataName=="loggedin") and (old==1) then -- They just logged out.
				realEndTimer( source )
				playerHits[source] = nil
				
				if animTimers[source] then
					killTimer(animTimers[source])
					animTimers[source] = nil
				end
			end
		end
	end
)

function playerDeath( totalAmmo, killer, killerWeapon )
	if ( getElementData( source, "wounded" ) == 1 ) then
		respawnPlayer( source )
	else
		local pX, pY, pZ = getElementPosition( source )
		local _, _, pR = getElementRotation( source )
		local int, dim = getElementInterior( source ), getElementDimension( source )
		setTimer( placeWoundedPlayer, 3000, 1, source, pX, pY, pZ, pR, int, dim )
		local affected = { }
		table.insert(affected, source)
		local killstr = ' died'
		if (killer) then
			if getElementType(killer) == "player" then
				if (killerWeapon) then
					killstr = ' got killed by '..getPlayerName(killer):gsub("_", " ").. ' ('..getWeaponNameFromID ( killerWeapon )..')'
				else
					killstr = ' died'
				end
				table.insert(affected, killer)
			else
			killstr = ' got killed by an unknown source'
			table.insert(affected, "Unknown")
			end
		end
		if 	(getElementData(source, "seatbelt") == true) then
			exports['anticheat-system']:changeProtectedElementDataEx(source, "seatbelt", false, true)
		end
			
		exports.logs:dbLog(source, 34, affected, killstr)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "lastdeath", " [KILL] "..getPlayerName(source):gsub("_", " ") .. killstr, true)
		
		animTimers[source] = setTimer( function( player )
										if (getElementData(player, "wounded")==1) then
											exports.global:applyAnimation(player, "CRACK", "crckidle4", 1, false, false, true)
										end end, 3000, 0, source )
	end
end
addEventHandler( "onPlayerWasted", getRootElement( ), playerDeath )

function placeWoundedPlayer( player, x, y, z, rotation, interior, dimension, logged )
	exports['anticheat-system']:changeProtectedElementDataEx( player, "wounded", 1, true, false )
	exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false )
	local dbid = getElementData( player, "account:character:id" )
	local query = exports.mysql:query_free("UPDATE characters SET wounded='1' WHERE id='" .. dbid .. "'")
	spawnPlayer( player, x, y, z, rotation, getPedSkin( player ), interior, dimension, getPlayerTeam( player ) )
	toggleAllControls( player, false, true, false)
	setElementFrozen( player, true)
	triggerClientEvent( player, "onClientPlayerWeaponCheck", player)
	exports.global:applyAnimation( player, "CRACK", "crckidle4", 1, false, false, true)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "injuriedanimation", true, false)
	setElementHealth( player, 5 )
	exports.global:sendMessageToAdmins("[KILL] " .. getPlayerName( player ):gsub("_", " ") .. " was killed and is currently brutally wounded.")
	if logged then
		exports.global:sendMessageToAdmins("[KILL] They logged in wounded, placing them into the system.")
	end
	outputChatBox("You were brutally wounded, if you're not saved you will die.", player, 220, 0, 0)
	outputChatBox("You can type /acceptdeath in order to respawn, or you can continue to RP.", player, 220, 40, 0) 
end
addEvent("es:woundedPlayer")
addEventHandler("es:woundedPlayer", getRootElement( ), placeWoundedPlayer)

function redoAnimation()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if getElementData(value, "death:injured") then
			
		end
	end
end
setTimer(redoAnimation, 3000, 0)

function revivePlayer( thePlayer, commandName, targetPlayer )
	if not targetPlayer then
		outputChatBox("SYNTAX: /".. commandName .. " [Player Parial Nick / ID]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		
		if targetPlayer then
			if (getElementData(targetPlayer, "wounded")==1) then
				exports.global:removeAnimation( targetPlayer )
				setElementFrozen( targetPlayer, false)
				toggleAllControls( targetPlayer, true, true, true)
				triggerClientEvent( targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
				clearDamages( targetPlayer )
				setElementHealth( targetPlayer, 100 ) 
				local x, y, z = getElementPosition(targetPlayer)
				setElementPosition( targetPlayer, x, y, z + 1 )
				local dbid = getElementData( targetPlayer, "account:character:id" )
				local query = exports.mysql:query_free("UPDATE characters SET wounded='0' WHERE id='" .. dbid .. "'")
				exports.global:sendMessageToAdmins("AdmCmd: " .. getPlayerName(thePlayer):gsub("_", " ") .. " has revived " .. getPlayerName(targetPlayer):gsub("_", " ") .. ".")
				exports['anticheat-system']:changeProtectedElementDataEx( targetPlayer, "wounded", 0, true, false )
				exports['anticheat-system']:changeProtectedElementDataEx( targetPlayer, "freeze", false, false )
				if animTimers[targetPlayer] then
					killTimer(animTimers[targetPlayer])
					animTimers[targetPlayer] = nil
				end
			else
				outputChatBox(getPlayerName(targetPlayer):gsub("_", " ") .. " is not currently brutally wounded.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Invalid ID.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("revive", revivePlayer)

addCommandHandler("acceptdeath",
	function(p, c)
		if (getElementData(p, "wounded")==1) then
			respawnPlayer( p )
		end
	end
)

function respawnPlayer(thePlayer)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
		
		local cost = math.random(175, 500)		
		local tax = exports.global:getTaxAmount()
		
		exports.global:giveMoney( getTeamFromName("Los Santos Emergency Services"), math.ceil((1-tax)*cost) )
		exports.global:takeMoney( getTeamFromName("Government of Los Santos"), math.ceil((1-tax)*cost) )
			
		mysql:query_free("UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. mysql:escape_string(getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)

		outputChatBox("You have recieved treatment from Los Santos Emergency Services.", thePlayer, 255, 255, 0)
		local dbid = getElementData( thePlayer, "account:character:id" )
		local query = exports.mysql:query_free("UPDATE characters SET wounded='0' WHERE id='" .. dbid .. "'")
		clearDamages( thePlayer )
		
		-- take all drugs
		local count = 0
		for i = 30, 43 do
			while exports.global:hasItem(thePlayer, i) do
				local number = exports['item-system']:countItems(thePlayer, i)
				exports.global:takeItem(thePlayer, i)
				exports.logs:logMessage("[LSES Death] " .. getElementData(thePlayer, "account:username") .. "/" .. getPlayerName(thePlayer) .. " lost "..number.."x item "..tostring(i), 28)
				exports.logs:dbLog(thePlayer, 34, thePlayer, "lost "..number.."x item "..tostring(i))
				count = count + 1
			end
		end
		if count > 0 then
			outputChatBox("LSES Employee: We handed your drugs over to the LSPD.", thePlayer, 255, 194, 14)
		end
		
		-- take guns
		local gunlicense = tonumber(getElementData(thePlayer, "license.gun"))
		local team = getPlayerTeam(thePlayer)
		local factiontype = getElementData(team, "type")
		local items = exports['item-system']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		local removedWeapons
		local formatedWeapons
		local correction = 0
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
				-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
				local itemCheckExplode = exports.global:explode(":", itemCheck[2])
				local weapon = tonumber(itemCheckExplode[1])
				local ammountOfAmmo
				if (((weapon >= 16 and weapon <= 40 and gunlicense == 0) or weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34) and factiontype ~= 2) or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
					exports['item-system']:takeItemFromSlot(thePlayer, itemSlot - correction)
					correction = correction + 1
					
					if (itemCheck[1] == 115) then
						exports.logs:dbLog(thePlayer, 34, thePlayer, "lost a weapon (" ..  itemCheck[2] .. ")")
					else
						exports.logs:dbLog(thePlayer, 34, thePlayer, "lost a magazine of ammo (" ..  itemCheck[2] .. ")")
						local splitArray = split(itemCheck[2], ":")
						ammountOfAmmo = splitArray[2]
					end
					
					if (removedWeapons == nil) then
						if ammountOfAmmo then
							removedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
							formatedWeapons = ammountOfAmmo .. " " .. itemCheckExplode[3]
						else
							removedWeapons = itemCheckExplode[3]
							formatedWeapons = itemCheckExplode[3]
						end
					else
						if ammountOfAmmo then
							removedWeapons = removedWeapons .. ", " .. ammountOfAmmo .. " " .. itemCheckExplode[3]
							formatedWeapons = formatedWeapons .. "\n" .. ammountOfAmmo .. " " .. itemCheckExplode[3]
						else
							removedWeapons = removedWeapons .. ", " .. itemCheckExplode[3]
							formatedWeapons = formatedWeapons .. "\n" .. itemCheckExplode[3]
						end
					end
				end
			end
		end
		
		if (removedWeapons~=nil) then
			if gunlicense == 0 and factiontype ~= 2 then
				outputChatBox("LSES Employee: We have taken away weapons which you did not have a license for. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			else
				outputChatBox("LSES Employee: We have taken away weapons which you are not allowed to carry. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			end
		end
		
		local death = getElementData(thePlayer, "lastdeath")
		if removedWeapons ~= nil then
			logMe(death)
			exports.global:sendMessageToAdmins("/showkills to view lost weapons.")
			logMeNoWrn("#FF0033 Lost Weapons: " .. removedWeapons)
		else
			logMe(death)
		end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "wounded", 0, true, false )
		exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "freeze", false, false )
		exports['anticheat-system']:changeProtectedElementDataEx(source, "forcedanimation", 0, false)
		 
		spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275, theSkin, 0, 0, theTeam)
		
		if animTimers[targetPlayer] then
			killTimer(animTimers[targetPlayer])
			animTimers[targetPlayer] = nil
		end
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerEvent("updateLocalGuns", thePlayer)
	end
end

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function logMeNoWrn( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer, 205, 201, 165)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer, 205, 201, 165, true)
		end
		outputChatBox("  END", thePlayer, 205, 201, 165)
	end
end
addCommandHandler("showkills", readLog)

--[[ ALTER TABLE `characters`
	ADD COLUMN `wounded` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0' AFTER `active`; ]]
-- Executed this in-game. 3-1-2015 (bean)