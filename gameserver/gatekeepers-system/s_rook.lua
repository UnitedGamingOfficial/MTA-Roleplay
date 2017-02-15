rook = createPed (21,  2637.9677734375, -2039.576171875, 13.582352638245)
exports.pool:allocateElement(rook)

--mysql = exports.mysql

setPedRotation(rook, 270)
setElementFrozen(rook, true)
exports['anticheat-system']:changeProtectedElementDataEx (rook, "activeConvo",  0) -- Set the convo state to 0 so people can start talking to him.
exports['anticheat-system']:changeProtectedElementDataEx(rook, "name", "Rook")
exports['anticheat-system']:changeProtectedElementDataEx(rook, "talk", true)
exports['anticheat-system']:changeProtectedElementDataEx(rook, "rotation", getPedRotation(rook), false)

function rookIntro () -- When player enters the colSphere create GUI with intro output to all local players as local chat.
	-- Give the player the "Find Hunter" achievement.
	if(getElementData( rook, "activeConvo" )==1)then
		outputChatBox("Rook doesn't want to talk to you.", source, 255, 0, 0)
	else
		local theTeam = getPlayerTeam(source)
		local factionType = getElementData(theTeam, "type")
		
		--local query = mysql:query_fetch_assoc("SELECT rook FROM characters WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .."'")
		--local rooksFriend = tonumber(query["rook"])
		local rooksFriend = 1
		local factionLeader = tonumber( getElementData(source, "factionleader") )

		if not(factionType==0) or factionLeader==0 then
			exports.global:sendLocalText(source, "Rook says: Keep on walkin'. Grown men tryin' to talk around here.", 255, 255, 255, 10)
		else
			--if(rooksFriend==1)then -- If they are already a friend.
				--exports.global:sendLocalText(source, "Rook says: Whats good, my nigga?  You gettin' that paper now, right?", 255, 255, 255, 10)
			--else -- If they are not a friend.
				triggerClientEvent( source, "rookIntroEvent", getRootElement()) -- Trigger Client side function to create GUI.
				exports.global:sendLocalText(source, "Rook says: What up, Homie? You lookin' to make some real green?", 255, 255, 255, 10)
				exports['anticheat-system']:changeProtectedElementDataEx (rook, "activeConvo", 1) -- set the NPCs conversation state to active so no one else can begin to talk to him.
				talkingToRook = source
				addEventHandler("onPlayerQuit", talkingToRook, resetRookConvoStateDelayed)
				addEventHandler("onPlayerWasted", talkingToRook, resetRookConvoStateDelayed)
			--end
		end
	end
end
addEvent( "startRookConvo", true )
addEventHandler( "startRookConvo", getRootElement(), rookIntro )

-- Statement 2
function rookStatement2_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " says: Hell yeah, I'm always lookin' for that paper.", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: Economies all fucked up, right?  There's only one market that isn't goin' down like a high school cheerleader.", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: I'm talkin' about that dope money.", 255, 255, 255, 5)
end
addEvent( "rookStatement2ServerEvent", true )
addEventHandler( "rookStatement2ServerEvent", getRootElement(), rookStatement2_S )

-- Statement 3
function rookStatement3_S()
	-- Output the text from the last option to all player in radius
	exports.global:sendLocalText(source, "Rook says: Whatever, homie. I was just tryin' to help a brother out.", 255, 255, 255, 10)
end
addEvent( "rookStatement3ServerEvent", true )
addEventHandler( "rookStatement3ServerEvent", getRootElement(), rookStatement3_S )

-- Statement 4
function rookStatement4_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " whispers: What do you know about it?", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: I know a guy that's looking to reach out. He got connects but no soldiers to push his product.", 255, 255, 255, 5)
end
addEvent( "rookStatement4ServerEvent", true )
addEventHandler( "rookStatement4ServerEvent", getRootElement(), rookStatement4_S )

-- Statement 5
function rookStatement5_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " whispers: Where's he at?", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: His names Tyrese and lives somewhere south-east where those chicanos live. Tell him Rook sent you.", 255, 255, 255, 5)
end
addEvent( "rookStatement5ServerEvent", true )
addEventHandler( "rookStatement5ServerEvent", getRootElement(), rookStatement5_S )

-- Statement 6
function rookStatement6_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " whispers: And you're just telling me this because you're feelin' charitable.", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: If a brother doesn't look out for his own who will? The white man?", 255, 255, 255, 5)
end
addEvent( "rookStatement6ServerEvent", true )
addEventHandler( "rookStatement6ServerEvent", getRootElement(), rookStatement6_S )

-- Statement 7
function rookStatement7_S()
	-- Output the text from the last option to all player in radius
	local name = string.gsub(getPlayerName(source), "_", " ")
	exports.global:sendLocalText(source, name .. " whispers: I hear that.", 255, 255, 255, 5)
	exports.global:sendLocalText(source, "Rook whispers: Peace, homie.", 255, 255, 255, 5)
	mysql:query_free("UPDATE characters SET rook='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
	resetRookConvoStateDelayed()
end
addEvent( "rookStatement7ServerEvent", true )
addEventHandler( "rookStatement7ServerEvent", getRootElement(), rookStatement7_S )

function resetRookConvoState()
	exports['anticheat-system']:changeProtectedElementDataEx(rook,"activeConvo", 0)
end

function resetRookConvoStateDelayed()
	if talkingToRook then
		removeEventHandler("onPlayerQuit", talkingToRook, resetTyConvoStateDelayed)
		removeEventHandler("onPlayerWasted", talkingToRook, resetTyConvoStateDelayed)
		talkingToRook = nil
	end
	setTimer(resetRookConvoState, 120000, 1)
end
