-- MAXIME

function givePlayerJob(thePlayer, commandName, targetPlayer, jobID)
	jobID = tonumber(jobID)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		local jobTitle = getJobTitleFromID(jobID)
		if not (targetPlayer) or not (jobTitle) then
			printSetJobSyntax(thePlayer, commandName)
			return
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					if (jobID==4) then -- CITY MAINTENANCE
						exports.global:giveItem(targetPlayer, 115, "41:1:Spraycan", 2500)
						outputChatBox("Use this spray to paint over the graffiti you find.", targetPlayer, 255, 194, 14)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "tag", 9, true)
						mysql:query_free("UPDATE characters SET tag=9 WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")) )
					end
					
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "job", jobID, true)
					mysql:query_free("UPDATE characters SET job='" .. mysql:escape_string(jobID) .. "', jobcontract = '3' WHERE id = '" .. mysql:escape_string(getElementData(targetPlayer, "dbid")).."'" )
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					if hiddenAdmin == 0 then
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". ", targetPlayer, 0, 255,0)
					else
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by a hidden admin. ", targetPlayer, 0, 255,0)
					end
					outputChatBox("You have set " .. targetPlayerName .. "'s job to '"..jobTitle.."'.", thePlayer)
				end
			end
		end
	end
end
addCommandHandler("setjob", givePlayerJob, false, false)

function printSetJobSyntax(thePlayer, commandName)
	outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Job ID]", thePlayer, 255, 194, 14)
	outputChatBox("ID#1: Delivery Driver", thePlayer)
	outputChatBox("ID#2: Taxi Driver", thePlayer)
	outputChatBox("ID#3: Bus Driver", thePlayer)
	outputChatBox("ID#4: City Maintenance", thePlayer)
	outputChatBox("ID#5: Mechanic", thePlayer)
	outputChatBox("ID#6: Locksmith", thePlayer)
end

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

function delJob( thePlayer, commandName, targetPlayerName )
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = mysql:query_free("UPDATE characters SET jobcontract = 0 , job = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )))
					
					exports['anticheat-system']:changeProtectedElementDataEx(source, "job", 0, true)
					if result then
						outputChatBox( "Deleted job for " .. targetPlayerName..".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							outputChatBox("Your job has been deleted by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". Please relog (F10) to get it affected.", targetPlayer, 0, 255,0)
						else
							outputChatBox("Your job has been deleted by a hidden admin.", targetPlayer, 0, 255,0)
						end
					else
						outputChatBox( "Failed to delete job.", thePlayer, 255, 0, 0 )
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
addCommandHandler("deljob", delJob, false, false)


