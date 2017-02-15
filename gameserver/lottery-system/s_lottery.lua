mysql = exports.mysql

local lotteryNumber = 0
local lotteryJackpot = 0

function getLotteryJackpot()
	local lotteryJackpotSQL = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name = 'lottery'") -- Fetch the lottery jackpot from MySQL
	lotteryJackpot = tonumber(lotteryJackpotSQL["value"])
	mysql:free_result(lotteryJackpotSQL)
	return lotteryJackpot
end
addEventHandler("onResourceStart", getResourceRootElement(), getLotteryJackpot)

function updateLotteryJackpot(updatedJackpot)
	local lotteryJackpotSQLUpdate = mysql:query_free("UPDATE settings SET value = " .. updatedJackpot .. " WHERE name = 'lottery'" )
end

function getLotteryNumber()
	return lotteryNumber
end

function lotteryDraw()
	exports['item-system']:deleteAll(68)
	updateLotteryJackpot(1000)
	lotteryNumber = 0
	lotteryNumber = math.random(2,48) -- Pick a random number for the lottery between 2 and 48

	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if (getElementData(value, "loggedin")==1) then
			outputChatBox("[NEWS] The lottery was drawn! Number: " .. lotteryNumber .. " Don't forget to purchase your lottery tickets!", value, 200, 100, 200)			
			--exports['global']:giveMoney(getTeamFromName("San Andreas News Network"), 10) -- wtf, why did they even get money?
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), lotteryDraw)
setTimer(lotteryDraw, 86400000, 0) -- Lottery draw every 24 hours
--setTimer(lotteryDraw, 3600000, 0) -- Lottery draw every hour

function lotteryCheckJackpot(thePlayer, commandName)
	if getLotteryJackpot() == -1 then
		outputChatBox( "Sorry, someone already won the lottery.", thePlayer, 255, 0, 0 )
	else
		outputChatBox( "Current Lottery Jackpot: $" .. getLotteryJackpot(), thePlayer, 0, 255, 0 )
	end
end
addCommandHandler("checkjackpot", lotteryCheckJackpot, false, false)

function lotteryCheckNumber(thePlayer, commandName)
	if getLotteryJackpot() == -1 then
		outputChatBox( "Sorry, someone already won the lottery.", thePlayer, 255, 0, 0 )
	else
		outputChatBox("Current Lottery Number: " .. lotteryNumber, thePlayer, 0, 255, 0)
	end
end
addCommandHandler("checknumber", lotteryCheckNumber, false, false)