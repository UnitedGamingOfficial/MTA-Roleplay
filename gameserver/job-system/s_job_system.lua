mysql = exports.mysql
local lockTimer = nil
chDimension = 125
chInterior = 3

-- CALL BACKS FROM CLIENT

function onEmploymentServer()
	exports.global:sendLocalText(source, "Jessie Smith says: Hello, are you looking for a new job?", nil, nil, nil, 10)
	exports.global:sendLocalText(source, " *Jessie Smith hands over a list with jobs to " .. getPlayerName(source):gsub("_", " ") .. ".", 255, 51, 102)
end

addEvent("onEmploymentServer", true)
addEventHandler("onEmploymentServer", getRootElement(), onEmploymentServer)

function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	local charID = getElementData(source, "dbid")
	mysql:query_free("DELETE FROM `jobs` WHERE `jobCharID`='"..mysql:escape_string(charID).."' ")
	mysql:query_free("INSERT INTO `jobs` SET `jobID`='"..mysql:escape_string(jobID).."', `jobCharID`='"..mysql:escape_string(charID).."' ")

	if (jobID==4) then -- CITY MAINTENANCE
		exports.global:giveItem(source, 115, "41:1:Spraycan", 2500)
		outputChatBox("Use this spray to paint over the graffiti you find.", source, 255, 194, 14)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "tag", 9, false)
		mysql:query_free("UPDATE characters SET tag=9 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
	end
	fetchJobInfoForOnePlayer(source)
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function fetchJobInfo()
	if not charID then
		for key, player in pairs(getElementsByType("player")) do
			fetchJobInfoForOnePlayer(player)
		end
	end
end
addEvent("job-system:fetchJobInfo", true)
addEventHandler("job-system:fetchJobInfo", getRootElement(), fetchJobInfo)

function fetchJobInfoForOnePlayer(thePlayer)
	local charID = getElementData(thePlayer, "dbid")
	jobInfo = mysql:query_fetch_assoc("SELECT * FROM `jobs` WHERE `jobCharID`='" .. tostring(charID) .. "' ")
	if jobInfo then
		setElementData(thePlayer, "job", tonumber(jobInfo["jobID"]) or 0, true)
		setElementData(thePlayer, "jobLevel", tonumber(jobInfo["jobLevel"]) or 0, true)
		setElementData(thePlayer, "jobProgress", tonumber(jobInfo["jobProgress"]) or 0, true)
	else
		setElementData(thePlayer, "job", 0, true)
		setElementData(thePlayer, "jobLevel", 0, true)
		setElementData(thePlayer, "jobProgress", 0, true)
	end
end
addEvent("job-system:fetchJobInfoForOnePlayer", true)
addEventHandler("job-system:fetchJobInfoForOnePlayer", getRootElement(), fetchJobInfo)

function getJobTitleFromID(jobID)
	if (tonumber(jobID)==1) then
		return "Delivery Driver"
	elseif (tonumber(jobID)==2) then
		return "Taxi Driver"
	elseif  (tonumber(jobID)==3) then
		return "Bus Driver"
	elseif (tonumber(jobID)==4) then
		return "City Maintenance"
	elseif (tonumber(jobID)==5) then
		return "Mechanic"
	elseif (tonumber(jobID)==6) then
		return "Locksmith"
	else
		return false
	end
end

function printJobInfo(thePlayer)
	outputChatBox("~-~-~-~-~-~-~-~-~-~Career Information~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
	outputChatBox("Job: "..(getJobTitleFromID(getElementData(thePlayer, "job")) or "Unemployed") , thePlayer, 255, 194, 14)
	outputChatBox("Title/Level: "..(tonumber(getElementData(thePlayer, "jobLevel")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("Progress: "..(tonumber(getElementData(thePlayer, "jobProgress")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("~-~-~-~--~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-", thePlayer, 255, 194, 14)
end
addCommandHandler("myjob", printJobInfo)

function quitJob(source)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local job = getElementData(source, "job")
		if job == 0 then
			outputChatBox("You are currently unemployed.", source, 255, 0, 0)
		else
			local charID = getElementData(source, "dbid")
			mysql:query_free("DELETE FROM `jobs` WHERE `jobCharID`='"..mysql:escape_string(charID).."' ")
			fetchJobInfoForOnePlayer(source)
			if job == 4 then
				exports['anticheat-system']:changeProtectedElementDataEx(source, "tag", 1, false)
				mysql:query_free("UPDATE characters SET tag=1 WHERE id = " .. mysql:escape_string(charID) )
			end
			triggerClientEvent(source, "quitJob", source, job)
		end
	end
end
addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)

-- PREVENT UNEMPLOYED PLAYER GETTING IN DRIVER SEAT OR JACKING JOB VEHICLES -- MAXIME
function startEnterVehJob(thePlayer, seat, jacked) 
	local vjob = tonumber(getElementData(source, "job")) or 0
	local job = getElementData(thePlayer, "job")
	local seat = getPedOccupiedVehicleSeat(thePlayer)
	if vjob>0 and job~=vjob and seat == 0 and not (getElementData(thePlayer, "adminduty") == 1) and not getElementData(thePlayer, "account:gmduty") then
		if (vjob==1) then
			outputChatBox("You are not a delivery driver. Visit city hall to obtain this job.", thePlayer, 255, 0, 0)
		elseif (vjob==2) then
			outputChatBox("You are not a taxi driver. Visit city hall to obtain this job.", thePlayer, 255, 0, 0)
		elseif (vjob==3) then
			outputChatBox("You are not a bus driver. Visit city hall to obtain this job.", thePlayer, 255, 0, 0)
		end
		if isTimer(lockTimer) then
			killTimer(lockTimer)
			lockTimer = nil
		end
		setVehicleLocked(source, true)
		lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterVehJob)

--[[ -- Removed by MAXIME  
function resetContract( thePlayer, commandName, targetPlayerName )
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = mysql:query_free("UPDATE characters SET jobcontract = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) .. " AND jobcontract > 0" )
					if result then
						outputChatBox( "Reset Job Contract for " .. targetPlayerName, thePlayer, 0, 255, 0 )
					else
						outputChatBox( "Failed to reset Job Contract Time.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		end
	end
end
--addCommandHandler("resetcontract", resetContract, false, false)
]]