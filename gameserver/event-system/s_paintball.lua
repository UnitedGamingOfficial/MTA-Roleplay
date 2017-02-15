-- paintassignteam // startpaintgame // stoppaintgame

local playersHit = { }
local resetTimer = 10000
local points = { }
local gameactive = false
local theTimer = nil
local teamName = {}
local countdown = 0
local ammogiven = 0

local playerStats = { }

table.insert(teamName, "RED") -- Team 1
table.insert(teamName, "BLUE") -- Team 2


function onPaintballHit(thePlayer)
	local attacker = client or source
	local paintball = getElementData(attacker, "paintball")
	if (paintball) and not (playersHit[thePlayer]) then
		toggleControl (thePlayer, "fire", false)
		exports['global']:sendLocalText(thePlayer, " * Got tagged by "..getPlayerName(attacker):gsub("_", " ").." *      ((" .. getPlayerName(thePlayer):gsub("_", " ") .. "))", 255, 51, 102)
		local r, g, b = getTeamColor(attacker)
		local marker1 = createMarker ( 0, 0, 0, "corona", 0.5, r, g, b, 255 )
		local marker2 = createMarker ( 0, 0, 0, "corona", 0.5, r, g, b, 255 )
		
		setElementInterior(marker1, getElementInterior(thePlayer))
		setElementInterior(marker2, getElementInterior(thePlayer))
		setElementDimension(marker1, getElementDimension(thePlayer))
		setElementDimension(marker2, getElementDimension(thePlayer))
		
		attachElements(marker1, thePlayer,0,0,0.6)
		attachElements(marker2, thePlayer)
		setElementData(thePlayer, "paintball:marker1", marker1, false)
		setElementData(thePlayer, "paintball:marker2", marker2, false)
			
		playersHit[thePlayer] = true
		setTimer ( resetPaintballPlayer, resetTimer, 1, thePlayer )
		handlePoints(attacker, thePlayer)
	end
end
addEvent("paintball:hit", true)
addEventHandler( "paintball:hit", getRootElement(), onPaintballHit)

function handlePoints(attacker, victim)
	if gameactive then
		local attackerTeam = getElementData(attacker, "paintball:team")
		local victimTeam = getElementData(victim, "paintball:team")
		if (attackerTeam) and (victimTeam) then
			if (attackerTeam == victimTeam) then -- TEAMKILL!!
				broadcastGameMessage("TEAMKILL: ".. getPlayerName(attacker):gsub("_", " ") .. " killed " .. getPlayerName(victim):gsub("_", " "),255,0,0)
				points[attackerTeam] = (points[attackerTeam] or 0) - 2
				playerStats[attacker]["teamkills"] = (playerStats[attacker]["teamkills"] or 0) + 1
				playerStats[victim]["deaths"] = (playerStats[victim]["deaths"] or 0) + 1
			else
				points[attackerTeam] = (points[attackerTeam] or 0) + 1
				playerStats[attacker]["kills"] = (playerStats[attacker]["kills"] or 0) + 1
				playerStats[victim]["deaths"] = (playerStats[victim]["deaths"] or 0) + 1
			end
		end
	end
end

function broadcastGameMessage(message, r,g,b)
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		local inPaintballGame = getElementData(thePlayer, "paintball")
		if (inPaintballGame) then
			outputChatBox(" >> ".. message, thePlayer, r, g, b)
		end
	end
end


function resetPaintballPlayer(thePlayer)
	if (playersHit[thePlayer]) then
		local marker1 = getElementData(thePlayer, "paintball:marker1")
		destroyElement(marker1)
		local marker2 = getElementData(thePlayer, "paintball:marker2")
		destroyElement(marker2)
		local marker3 = getElementData(thePlayer, "paintball:marker3")
		destroyElement(marker3)
		toggleControl(thePlayer, "fire", true)

		playersHit[thePlayer] = nil
		outputChatBox("Gogogo!", thePlayer,0,255,0)
	end
end

function assignTeam(theSource, commandName, maybeThePlayer, teamID)
	if not (teamID) then
		return
	end
	
	teamID = tonumber(teamID)
	if not (teamID) then
		return
	end
	
	local thePlayer, targetPlayerName = exports.global:findPlayerByPartialNick(theSource, maybeThePlayer)
	if not thePlayer then 
		return
	end
	
	if (getElementDimension(thePlayer) == 725) then -- in briefing room or game field	
		setElementData(thePlayer, "paintball",true, true )
		if (teamID == 1) then -- team red
			setElementData(thePlayer, "paintball:colors", {255, 0, 0}, true )
			outputChatBox("You are assigned to team RED.", thePlayer, 0, 255, 0)		
		elseif (teamID == 2) then -- team blue
			setElementData(thePlayer, "paintball:colors", {0, 0, 255}, true )
			outputChatBox("You are assigned to team BLUE.", thePlayer, 0, 255, 0)
		else-- F4A team
			setElementData(thePlayer, "paintball:colors", {math.random(0,255), math.random(0,255), math.random(0,255)}, true )
			outputChatBox("You are assigned to the paintball game.", thePlayer, 0, 255, 0)
		end
		exports['global']:sendLocalText(thePlayer, " * Got assigned to team "..(teamName[teamID] or teamID).." *      ((" .. getPlayerName(thePlayer):gsub("_", " ") .. "))", 255, 51, 102)
		
		setElementData(thePlayer, "paintball:team", teamID, false )
	end
	
	playerStats[thePlayer] = { }
	
	if (gameactive) then
		exports.global:takeWeapon(thePlayer, 33)
		local give = exports.global:giveWeapon(thePlayer, 33, 15 * timetake, true)	
	end
	
end
addCommandHandler("paintassignteam", assignTeam, false, false)

function startGame(theSource, commandName, timetake)
	if not (timetake) then
		return
	end
	
	timetake = tonumber(timetake)
	if not (timetake) then
		return
	end
	
	if (gameactive) then
		return
	end
	
	playerStats = { }
	
	broadcastGameMessage("Game has been started by ".. getPlayerName(theSource):gsub("_", " "), 0, 255, 0)
	broadcastGameMessage("This is a ".. timetake .." minutes game.", 0, 255, 0)
	broadcastGameMessage("Starting in 10 seconds!.", 0, 255, 0)
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		local inPaintballGame = getElementData(thePlayer, "paintball")
		if (inPaintballGame) then
			triggerClientEvent(thePlayer, "paintball:countdown", theSource, 10)
		end
	end
	setTimer(startGameReal, 10000, 1, timetake)
end
addCommandHandler("startpaintgame", startGame, false, false)

function startGameReal( timetake )
	points = { }
	gameactive = true
	ammogiven = timetake * 15
	theTimer = setTimer ( stopGame, timetake * 60000, 1 )
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		local inPaintballGame = getElementData(thePlayer, "paintball")
		if (inPaintballGame) then
			if (getElementDimension(thePlayer) == 725) then
				exports.global:takeWeapon(thePlayer, 33)
				local give = exports.global:giveWeapon(thePlayer, 33, 15 * timetake, true)
			end
		end
	end
end

function stopGame()
	if (gameactive) then 
		gameactive = false
		broadcastGameMessage("Game is over!!", 0, 255, 0)
		broadcastGameMessage("Points:", 0, 255, 0)
		for teamID, pointsInTotal in ipairs(points) do
			broadcastGameMessage("TEAM ".. (teamName[teamID] or teamID) .." - "..pointsInTotal, 0, 255, 0)
		end
		
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local inPaintballGame = getElementData(thePlayer, "paintball")
			if (inPaintballGame) then
				exports.global:takeWeapon(thePlayer, 33)
				setElementData(thePlayer, "paintball", false, true)
				setElementData(thePlayer, "paintball:team", false, false)
				setElementData(thePlayer, "paintball:colors", false, true)
			end
		end
		
		
		
		-- playerStats[player]["teamkills"] ["kills"] ["deaths"]
	end
end
addCommandHandler("stoppaintgame", stopGame, false, false)

function getTeamColor( thePlayer )
	local colors =  getElementData(thePlayer, "paintball:colors")
	if (colors) then
		return colors[1],colors[2], colors[3]
	end
	return 255,0,0
end