local huntersCar = createVehicle ( 506, 618.575193, -74.190429, 997.69464, 0, 0, 110, "D34M0N")
exports.pool:allocateElement(huntersCar)
setVehicleLocked(huntersCar, true)
setElementFrozen(huntersCar, true)
setVehicleDamageProof(huntersCar, true)
setElementDimension(huntersCar, 1001)
setElementInterior(huntersCar, 2)

hunter = createPed (250, 616.162109, -75.3720, 997.99)
exports.pool:allocateElement(hunter)
setPedRotation (hunter, 300)
exports['anticheat-system']:changeProtectedElementDataEx(hunter, "rotation", getPedRotation(hunter), false)
setElementFrozen(hunter, true)
setElementInterior (hunter, 2)
setElementDimension (hunter, 1001)

setPedAnimation(hunter, "CAR_CHAT", "car_talkm_loop", -1, true, false, true) -- Set the Peds Animation.
exports['anticheat-system']:changeProtectedElementDataEx (hunter, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
exports['anticheat-system']:changeProtectedElementDataEx(hunter, "name", "Hunter")
exports['anticheat-system']:changeProtectedElementDataEx(hunter, "talk", true)

function hunterIntro () -- When player enters the colSphere create GUI with intro output to all local players as local chat.
	-- Give the player the "Find Hunter" achievement.
		
	if(getElementData(hunter, "activeConvo")==1)then
		outputChatBox("Hunter doesn't want to talk to you.", source, 255, 0, 0)
	else
		local query = mysql:query_fetch_assoc("SELECT hunter FROM characters WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .."'")
		local huntersFriend = tonumber(query["hunter"])
		
		if(huntersFriend==1)then -- If they are already a friend.
			exports.global:sendLocalText( hunter, "Hunter says: Hey, man.  I'll call you when I got some work for you.", 255, 255, 255, 10 )
		else -- If they are not a friend.
		
			triggerClientEvent ( source, "hunterIntroEvent", getRootElement()) -- Trigger Client side function to create GUI.
			
			exports.global:sendLocalText( hunter, "* A muscular man works under the car's hood.", 255, 51, 102, 10 )
			exports['anticheat-system']:changeProtectedElementDataEx (hunter, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
			talkingToHunter = source
			addEventHandler("onPlayerQuit", source, resetHunterConvoStateDelayed)
			addEventHandler("onPlayerWasted", source, resetHunterConvoStateDelayed)
		end
	end
end
addEvent( "startHunterConvo", true )
addEventHandler( "startHunterConvo", getRootElement(), hunterIntro )

-- Statement 2
function statement2_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Hey. I'm looking for a mechanic to change a spark plug.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: I'm busy. There's a place on ... that can do it.", 255, 255, 255, 10) -- Hunter's next question
	resetHunterConvoStateDelayed()
end
addEvent( "hunterStatement2ServerEvent", true )
addEventHandler( "hunterStatement2ServerEvent", getRootElement(), statement2_S )

-- Statement 3
function statement3_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Nice ride. Is it yours?", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: It sure is.", 255, 255, 255, 10) -- Hunter's next question
end
addEvent( "hunterStatement3ServerEvent", true )
addEventHandler( "hunterStatement3ServerEvent", getRootElement(), statement3_S )

-- Statement 4
function statement4_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Whatcha running under there?", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Sport air intake, NOS, fogger system and a T4 turbo. But you wouldn't know much about that, would you?", 255, 255, 255, 10) -- Hunter's next question
end
addEvent( "hunterStatement4ServerEvent", true )
addEventHandler( "hunterStatement4ServerEvent", getRootElement(), statement4_S )

-- Statement 5
function statement5_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: I like the paint job.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: It's not about how it looks, man. This car will rip your insides out and throw ‘em at you, rookie.", 255, 255, 255, 10) -- Hunter's next question
	resetHunterConvoStateDelayed()
end
addEvent( "hunterStatement5ServerEvent", true )
addEventHandler( "hunterStatement5ServerEvent", getRootElement(), statement5_S )

-- Statement 6
function statement6_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Looks like all show and no go to me.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Just goes to show you aren't a real gear head. Come back when you have a clue.", 255, 255, 255, 10) -- Hunter's next question
	resetHunterConvoStateDelayed()
end
addEvent( "hunterStatement6ServerEvent", true )
addEventHandler( "hunterStatement6ServerEvent", getRootElement(), statement6_S )

-- Statement 7
function statement7_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Is that an AIC controller? ...And direct port nitrous injection?", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: You almost sound like you know what you're talking about.", 255, 255, 255, 10) -- Hunter's next question
end
addEvent( "hunterStatement7ServerEvent", true )
addEventHandler( "hunterStatement7ServerEvent", getRootElement(), statement7_S )

-- Statement 8
function statement8_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: There's nothing better than living a quarter mile at a time.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Oh, you're a racer? They call me Hunter. I got a real name but unless you're the government you don't need to know it.", 255, 255, 255, 10) -- Hunter's next question
end
addEvent( "hunterStatement8ServerEvent", true )
addEventHandler( "hunterStatement8ServerEvent", getRootElement(), statement8_S )

-- Statement 9
function statement9_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: You work here alone?", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Yeah so I got work to do. Nice talkin' to ya.", 255, 255, 255, 10) -- Hunter's next question
	resetHunterConvoStateDelayed()
end
addEvent( "hunterStatement9ServerEvent", true )
addEventHandler( "hunterStatement9ServerEvent", getRootElement(), statement9_S )

-- Statement 10
function statement10_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: My mother taught me never to trust a man that won't even tell you his name.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Well here's the thing. One of my usual guys got busted a couple days ago.", 255, 255, 255, 10) -- Hunter's next question
	exports.global:sendLocalText(source, "If you're looking to make some money I could use a new go to guy.", 255, 255, 255, 10)
	exports.global:sendLocalText(source, "Hunter says: See running a car like this isn't cheap so we ...borrow from other cars if you know what I'm saying.", 255, 255, 255, 10) -- Hunter's next question
end
addEvent( "hunterStatement10ServerEvent", true )
addEventHandler( "hunterStatement10ServerEvent", getRootElement(), statement10_S )

-- Statement 11
function statement11_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Sounds like easy money. Give me a call.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: You can expect my call. I might see you on the circuit some time too.", 255, 255, 255, 10) -- Hunter's next question
	exports.global:sendLocalMeAction( source,"jots down their number on a scrap of paper and hands it to Hunter.")
	resetHunterConvoStateDelayed()
	mysql:query_free("UPDATE characters SET hunter='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
end
addEvent( "hunterStatement11ServerEvent", true )
addEventHandler( "hunterStatement11ServerEvent", getRootElement(), statement11_S )

-- Statement 12
function statement12_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: . I'd rather not get involved in all that.", 255, 255, 255, 10) -- Players response to last question
	exports.global:sendLocalText(source, "Hunter says: Whatever. I got work to do.", 255, 255, 255, 10) -- Hunter's next question
	resetHunterConvoStateDelayed()
end
addEvent( "hunterStatement12ServerEvent", true )
addEventHandler( "hunterStatement12ServerEvent", getRootElement(), statement12_S )

function resetHunterConvoState()
	exports['anticheat-system']:changeProtectedElementDataEx(hunter, "activeConvo", 0)
end

function resetHunterConvoStateDelayed()
	if talkingToHunter then
		removeEventHandler("onPlayerQuit", talkingToHunter, resetHunterConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToHunter, resetHunterConvoStateDelayed)
		talkingToHunter = nil
	end
	setTimer(resetHunterConvoState, 360000, 1)
end
