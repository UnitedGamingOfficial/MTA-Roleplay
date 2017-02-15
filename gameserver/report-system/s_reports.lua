mysql = exports.mysql

reports = { }


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


function resourceStart(res)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		exports['anticheat-system']:changeProtectedElementDataEx(value, "adminreport", false, true)
		exports['anticheat-system']:changeProtectedElementDataEx(value, "reportadmin", false, false)
	end	
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function getAdminCount()
	local online, duty, lead, leadduty= 0, 0, 0, 0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "adminlevel" ) or 0
			if level >= 1 and level <= 4 then
				online = online + 1
				
				local aod = getElementData( value, "adminduty" ) or 0
				if aod == 1 then
					duty = duty + 1
				end
				
				if level >= 3 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end
		end
	end
	return online, duty, lead, leadduty
end

function updateReportCount()
	local open = 0
	local handled = 0
	
	local unanswered = {}
	local byadmin = {}
	
	for key, value in pairs(reports) do
		if not value[7] then
			open = open + 1
			if value[5] then
				handled = handled + 1
				if not byadmin[value[5]] then
					byadmin[value[5]] = { key }
				else
					table.insert(byadmin[value[5]], key)
				end
			else
				table.insert(unanswered, tostring(key)) 
			end
		end
	end	
	-- admstr
	local online, duty, lead, leadduty = getAdminCount()
	local admstr = ":: ".. online .." admins :: "..leadduty.."/"..lead.." leads"
	
	for key, value in ipairs(exports.global:getAdmins()) do
		triggerClientEvent( value, "updateReportsCount", value, open, handled, unanswered, byadmin[value], admstr )
	end
end

addEventHandler( "onElementDataChange", getRootElement(), 
	function(n)
		if getElementType(source) == "player" and ( n == "adminlevel" or n == "adminduty") then
			sortReports(false)
			updateReportCount()
		end
	end
)

function showReports(thePlayer)
	if exports.global:isPlayerModerator(thePlayer) then
		outputChatBox("~~~~~~~~~ Reports ~~~~~~~~~", thePlayer, 255, 194, 15)
		local count = 0
		for i = 1, 300 do
			local report = reports[i]
			if report then
				local reporter = report[1]
				local reported = report[2]
				local timestring = report[4]
				local admin = report[5]
				
				local handler = ""
				
				if (isElement(admin)) then
					local adminName = getElementData(admin, "account:username")
					handler = tostring(getPlayerName(admin)).." ("..adminName..")"
				else
					handler = "None."
				end
				outputChatBox("Admin Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. ".", thePlayer, 255, 195, 15) 
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("None.", thePlayer, 255, 194, 15)
		else
			outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
			outputChatBox("Type /ri [id] to obtain more information about the report.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("reports", showReports, false, false)

function sortReports(showMessage)
	-- reports[slot] = { }
	-- reports[slot][1] = source -- Reporter
	-- reports[slot][2] = reportedPlayer -- Reported Player
	-- reports[slot][3] = reportedReason -- Reported Reason
	-- reports[slot][4] = timestring -- Time reported at
	-- reports[slot][5] = nil -- Admin dealing with the report
	-- reports[slot][6] = alertTimer -- Alert timer of the report
	-- reports[slot][7] = isGMreport -- No Longer Used (UG 2.0 Update)
	-- reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime
	local sortedReports = {}
	local adminNotice = ""
	local gmNotice = ""
	local unsortedReports = reports
	
	for key , report in pairs(reports) do  
		table.insert(sortedReports, report)
	end
	
	reports = sortedReports
	
	for key , report in pairs(reports) do 
		if report[8] ~= key then
			adminNotice = adminNotice.."#"..report[8]..", "
			if showMessage then 
				outputChatBox("Your report ID#"..report[8].." has been shifted up to ID#"..key.." .", report[1], 255, 195, 15) 
			end
			report[8] = key
		end
	end
	if showMessage then
		if adminNotice ~= "" then
			adminNotice = string.sub(adminNotice, 1, (string.len(adminNotice) - 2))
			local admins = exports.global:getAdmins()
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "adminduty")
				if (adminduty==1) then
					outputChatBox(" Reports with ID "..adminNotice.." have been shifted up.", value, 255, 195, 15) 
				end
			end
		end		
	end
end

function reportInfo(thePlayer, commandName, id)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				
				local playerID = getElementData(reporter, "playerid") or "Unknown"
				local reportedID = getElementData(reported, "playerid") or "Unknown"
				outputChatBox(" [ADM #" .. id .."] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " at " .. timestring .. ".", thePlayer, 255, 126, 0)--200, 240, 120)
				outputChatBox("Reason: " .. reason, thePlayer, 200, 240, 120)		
				local handler = ""
				if (isElement(admin)) then
					local adminName = getElementData(admin, "account:username")
					outputChatBox(" [#" .. id .."] This report is being handled by " .. getPlayerName(admin) .. " ("..adminName..").", thePlayer, 255, 126, 0)--200, 240, 120)
				else
					outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
					outputChatBox("   Type /ar " .. id .. " to accept this report. Type /togautocheck to turn on/off auto-check when accepting reports.", thePlayer, 255, 194, 15)
				end
			else
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function playerQuit()
	local report = getElementData(source, "adminreport")
	local update = false
	
	if report and reports[report] then
		local theAdmin = reports[report][5]
		
		if (isElement(theAdmin)) then
				outputChatBox(" [ADM #" .. report .."] Player " .. getPlayerName(source) .. " left the game.", theAdmin, 255, 126, 0)--200, 240, 120)
		else
			for key, value in ipairs(exports.global:getAdmins()) do
				local adminduty = getElementData(value, "adminduty")
				if adminduty == 1 then
					outputChatBox(" [ADM #" .. report .."] Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)--200, 240, 120)
					update = true
				end
			end
		end
		
		local alertTimer = reports[report][6]
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		reports[report] = nil -- Destroy any reports made by the player
		update = true
	end
	
	-- check for reports assigned to him, unassigned if neccessary
	for i = 1, 300 do -- Support 128 reports at any one time, since each player can only have one report
		if reports[i] then
			if reports[i][5] == source then
				reports[i][5] = nil
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "adminduty")
					if adminduty == 1 then
						local adminName = getElementData(source, "account:username")
						outputChatBox(" [#" .. i .."] Report is unassigned (" .. adminName .. " left the game)", value, 255, 126, 0)--200, 240, 120)
						update = true
					end
				end
			end
			if reports[i][2] == source then
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "adminduty")
					if adminduty == 1 then
						outputChatBox(" [#" .. i .."] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)--200, 240, 120)
						update = true
					end
				end
					
				local reporter = reports[i][1]
				if reporter ~= source then
					local adminName = getElementData(source, "account:username")
					outputChatBox("Your report #" .. i .. " has been closed (" .. adminName .. " left the game)", reporter, 255, 126, 0)--200, 240, 120)
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "adminreport", false, true)
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
				end
				
				local alertTimer = reports[i][6]

				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end

				reports[i] = nil -- Destroy any reports made by the player
			end
		end
	end	
	
	if update then
		sortReports(true)
		updateReportCount()
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
	

function handleReport(reportedPlayer, reportedReason)
	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("The player you are reporting is not logged in.", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil
	
	sortReports(false)

	for i = 1, 300 do 
		if not reports[i] then
			slot = i
			break
		end
	end
	
	local hours, minutes = getTime()
	
	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end
	
	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end
	
	local timestring = hours .. ":" .. minutes
	
	
	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime
	
	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	
	exports['anticheat-system']:changeProtectedElementDataEx(source, "adminreport", slot, true)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "reportadmin", false)
	local count = 0
	local nigger = 0
	local skipadmin = false	
	
	local admins = exports.global:getAdmins()
	local count = 0
	local faggots = 0
	-- Show to admins
	for key, value in ipairs(admins) do
		local adminduty = getElementData(value, "adminduty")
		if (adminduty==1) then
			faggots = faggots + 1
			outputChatBox(" [ADM #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 255, 126, 0)--200, 240, 120)
			outputChatBox("Reason: " .. reportedReason, value, 200, 240, 120)
			if getElementData(value, "hiddenadmin") ~= 1 then
				count = count + 1
			end
		end
	end
	outputChatBox("Thank you for submitting your admin report. (Report ID: #" .. tostring(slot) .. ").", source, 200, 240, 120)
	outputChatBox("You reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. ". Reason: ", source, 237, 145, 33 )
	outputChatBox(reportedReason, source, 200, 240, 120)
	outputChatBox("An admin will respond to your report ASAP. Currently there are " .. faggots .. " admin" .. ( count == 1 and "" or "s" ) .. " available.", source, 200, 240, 120)
	outputChatBox("You can close this report at any time by typing /er.", source, 200, 240, 120)
	updateReportCount()
end
addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)

function alertPendingReport(id)
	if (reports[id]) then
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")

		local admins = exports.global:getAdmins()
		-- Show to admins
		local reason1 = reportedReason:sub( 0, 70 )
		local reason2 = reportedReason:sub( 71 )
		for key, value in ipairs(admins) do
			local adminduty = getElementData(value, "adminduty")
			if (adminduty==1) then
				outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 200, 240, 120)
			end
		end
	end
end


function falseReport(thePlayer, commandName, id)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					
					outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. " ("..getElementData(reportHandler,"account:username")..")", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					
					if reportedPlayer == thePlayer and not exports.global:isPlayerScripter(thePlayer) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
					end
					
					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					local isGMreport = reports[id][7]
					
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username")
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					reports[id] = nil
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local timestring = hours .. ":" .. minutes
					exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "adminreport", false, true)
					exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", true, true)
				
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - "..adminTitle.." ".. getPlayerName(thePlayer) .. " ("..adminUsername..") has marked report #" .. id .. " as false. -", value, 255, 126, 0)--200, 240, 120)
						end
					end
					outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") was marked as false by "..adminTitle.." ".. getPlayerName(thePlayer) .. " ("..adminUsername..").", reportingPlayer, 255, 126, 0)--200, 240, 120)
					local accountID = getElementData(thePlayer, "account:id")
					sortReports(true)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

function arBind()
	if exports.global:isPlayerModerator(client) then
		for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if (logged) then
				if exports.global:isPlayerLeadAdmin(arrayPlayer) then
					outputChatBox( "LeadAdmWarn: " .. getPlayerName(client) .. " has accept report bound to keys. ", arrayPlayer, 200, 240, 120)
				end
			end
		end
	end
end
addEvent("arBind", true)
addEventHandler("arBind", getRootElement(), arBind)

function acceptReport(thePlayer, commandName, id)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
				else
					
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					
					if reportingPlayer == thePlayer and not exports.global:isPlayerScripter(thePlayer) then
						outputChatBox("You can not accept your own report.",thePlayer, 255,0,0)
						return false
					elseif reportedPlayer == thePlayer and not exports.global:isPlayerScripter(thePlayer) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
					end
					
					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					--local timeoutTimer = reports[id][7]
					local isGMreport = reports[id][7]
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					
					--[[if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end]]
					
					reports[id][5] = thePlayer -- Admin dealing with this report
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local adminreports = getElementData(thePlayer, "adminreports")
					exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminreports", adminreports+1, false)
					mysql:query_free("UPDATE accounts SET adminreports=adminreports+1 WHERE id = " .. mysql:escape_string(getElementData( thePlayer, "account:id" )) )
					exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", thePlayer, false)
					
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					
					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has accepted report #" .. id .. " -", value, 255,126, 0)--200, 240, 120)
						end
					end	
						
					outputChatBox(adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") has accepted your report (#" .. id .. ") at "..timestring..", Please wait for him/her to contact you.", reportingPlayer, 255,126, 0)--200, 240, 120)
					outputChatBox("You accepted report #" .. id .. ". Contact the player ID #" .. playerID .. " (" .. getPlayerName(reportingPlayer) .. ").", thePlayer, 255,126, 0)--200, 240, 120)

					if getElementData(thePlayer, "report:autocheck") then
						triggerClientEvent( thePlayer, "report:onOpenCheck", thePlayer, tostring(playerID) )
					end
					
					setElementData(thePlayer, "targetPMer", getPlayerName(reportingPlayer):gsub(" ","_"), false)
					
					local accountID = getElementData(thePlayer, "account:id")
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function acceptAdminReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID] [Adminname]", thePlayer, 255, 194, 14)
		else
			local targetAdmin, username = exports.global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
				else
					local reportHandler = reports[id][5]
					
					if (reportHandler) then
						outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
					else
						local reportingPlayer = reports[id][1]
						local reportedPlayer = reports[id][2]
						local reason = reports[id][3]
						local alertTimer = reports[id][6]
						if isTimer(alertTimer) then
							killTimer(alertTimer)
						end
						
						--[[if isTimer(timeoutTimer) then
							killTimer(timeoutTimer)
						end]]
						
						reports[id][5] = targetAdmin -- Admin dealing with this report
						
						local hours, minutes = getTime()
						
						-- Fix hours
						if (hours<10) then
							hours = "0" .. hours
						end
						
						-- Fix minutes
						if (minutes<10) then
							minutes = "0" .. minutes
						end
						
						local adminreports = getElementData(targetAdmin, "adminreports")
						exports['anticheat-system']:changeProtectedElementDataEx(targetAdmin, "adminreports", adminreports+1, false)
						mysql:query_free("UPDATE accounts SET adminreports=adminreports+1 WHERE id = " .. mysql:escape_string(getElementData( targetAdmin, "account:id" )) )
						exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", targetAdmin, false)
						
						local timestring = hours .. ":" .. minutes
						local playerID = getElementData(reportingPlayer, "playerid")
						outputChatBox("[" .. timestring .. "] Administrator " .. getPlayerName(targetAdmin) .. " has accepted your report (#" .. id .. "), Please wait for them to contact you.", reportingPlayer, 200, 240, 120)
						outputChatBox("A lead admin assigned report #" .. id .. " to you. Please proceed to contact the player ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 200, 240, 120)
						
						local admins = exports.global:getAdmins()
							for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "adminduty")
							if (adminduty==1) then
								outputChatBox(" [#" .. id .. "] - " .. getPlayerName(theAdmin) .. " has accepted report #" .. id .. " (Assigned) -", value, 200, 240, 120)
							end
						end
						local accountID = getElementData(thePlayer, "account:id")
						sortReports(false)
						updateReportCount()
					end
				end
			end
		end
	end
end
addCommandHandler("ara", acceptAdminReport, false, false)


function transferReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID] [Adminname]", thePlayer, 200, 240, 120)
		else
			local targetAdmin, username = exports.global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
				elseif (reports[id][5] ~= thePlayer) and not (exports.global:isPlayerLeadAdmin(thePlayer)) then
					outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local report = reports[id][3]
					local isGMreport = reports[id][7]
					reports[id][5] = targetAdmin -- Admin dealing with this report
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
							
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					
					outputChatBox("[" .. timestring .. "] " .. getPlayerName(thePlayer) .. " handed your report to ".. getPlayerName(targetAdmin) .." (#" .. id .. "), Please wait for him/her to contact you.", reportingPlayer, 200, 240, 120)
					outputChatBox(getPlayerName(thePlayer) .. " handed report #" .. id .. " to you. Please proceed to contact the player ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 200, 240, 120)
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " handed report #" .. id .. " over to  ".. getPlayerName(targetAdmin) , value, 200, 240, 120)
						end
					end
					local accountID = getElementData(thePlayer, "account:id")
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function closeReport(thePlayer, commandName, id)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (id) then
			closeAllReports(thePlayer)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			elseif (reports[id][5] ~= thePlayer) then
				outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local alertTimer = reports[id][6]
				
				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end
				
				reports[id] = nil
				
				local adminName = getElementData(thePlayer,"account:username")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				
				if (isElement(reporter)) then
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "adminreport", false, true)
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					outputChatBox(adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has closed your report.", reporter, 255, 126, 0)
				end
				
				local admins = exports.global:getAdmins()
				for key, value in ipairs(admins) do
					local adminduty = getElementData(value, "adminduty")
					if (adminduty==1) then
						outputChatBox(" [ADM #" .. id .. "] - "..adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") has closed the report #" .. id .. ". -", value, 255, 126, 0)--200, 240, 120)
					end
				end					
				local accountID = getElementData(thePlayer, "account:id")
				sortReports(true)
				updateReportCount()
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function closeAllReports(thePlayer)
	if exports.global:isPlayerModerator(thePlayer)then
		local count = 0
		for i = 1, 300 do
			local report = reports[i]
			if report then
				local admin = report[5]
				if isElement(admin) and admin == thePlayer then
					closeReport(thePlayer, "cr" , i)
					count = count + 1
				end
			end
		end
		
		if count == 0 then
			outputChatBox(" None were closed.", thePlayer, 255, 126, 0)--255, 194, 15)
		else
			outputChatBox(" You have closed "..count.." of your reports.", thePlayer, 255, 126, 0)--255, 194, 15)
		end
	end
end
addCommandHandler("closeallreports", closeAllReports, false, false)
addCommandHandler("car", closeAllReports, false, false)

function dropReport(thePlayer, commandName, id)
	if exports.global:isPlayerModerator(thePlayer) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id] == nil) then
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			else
				if (reports[id][5] ~= thePlayer) then
					outputChatBox("You are not handling this report.", thePlayer, 255, 0, 0)
				else
					--local alertTimer = setTimer(alertPendingReport, 123500, 2, id)
					--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, id)
					
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local reason = reports[id][3]
					reports[id][5] = nil
					reports[id][6] = alertTimer
					
					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					
					local reporter = reports[id][1]
					if (isElement(reporter)) then
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "adminreport", true, true)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
						outputChatBox(adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has released your report. Please wait until another Admin accepts your report.", reporter, 210, 105, 50)
					end
					
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [ADM #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has dropped report #" .. id .. ". -", value, 255, 126, 0)--200, 240, 120)
						end
					end
					local accountID = getElementData(thePlayer, "account:id")
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)

function endReport(thePlayer, commandName)
	local adminreport = getElementData(thePlayer, "adminreport")

	local report = false
	for i=1,50 do 
		if reports[i] and (reports[i][1] == thePlayer) then
			report = i 
			break
		end
	end
	
	if not adminreport or not report then
		outputChatBox("You have no pending reports. Press F2 to create one.", thePlayer, 255, 0, 0)
	else
		local hours, minutes = getTime()
		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end
					
		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end
					
		local timestring = hours .. ":" .. minutes
		local reportedPlayer = reports[report][2]
		--local reason = reports[report][3]
		local reportHandler = reports[report][5]
		local alertTimer = reports[report][6]
		--local timeoutTimer = reports[report][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
	
		reports[report] = nil
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminreport", false, true)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)
		
		outputChatBox("[" .. timestring .. "] You have closed your submitted report ID #"..report, thePlayer, 200, 240, 120)
		local otherAccountID = nil
		if (isElement(reportHandler)) then
			outputChatBox(getPlayerName(thePlayer) .. " has closed their report (#" .. report .. ").", reportHandler, 255, 126, 0)--200, 240, 120)
			otherAccountID = getElementData(reportHandler, "account:id")
		end
		sortReports(true)
		updateReportCount()
	end
end
addCommandHandler("endreport", endReport, false, false)
addCommandHandler("er", endReport, false, false)