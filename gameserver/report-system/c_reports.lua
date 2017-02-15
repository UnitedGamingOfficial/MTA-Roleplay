wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, lLengthCheck, bSubmitAdminReport, bSubmitGMReport , lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage, bGMHelp = nil

function resourceStop()
	guiSetInputEnabled(false)
	showCursor(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

function resourceStart()
	bindKey("F2", "down", toggleReport)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

function toggleReport()
	executeCommandHandler("report")
	if wHelp then
	guiSetInputEnabled(false)
	showCursor(false)
	destroyElement(wHelp)
	wHelp = nil
	end
end

function checkBinds()
	if ( exports.global:isPlayerAdmin(getLocalPlayer()) or getElementData( getLocalPlayer(), "account:gmlevel" )  ) then
		if getBoundKeys("ar") or getBoundKeys("acceptreport") then
			triggerServerEvent("arBind", getLocalPlayer())
		end
	end
end
setTimer(checkBinds, 60000, 0)

local function scale(w)
	local width, height = guiGetSize(w, false)
	local screenx, screeny = guiGetScreenSize()
	local minwidth = math.min(700, screenx)
	if width < minwidth then
		guiSetSize(w, minwidth, height / width * minwidth, false)
		local width, height = guiGetSize(w, false)
		guiSetPosition(w, (screenx - width) / 2, (screeny - height) / 2, false)
	end
end

function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	if (logged==1) then
		if (wReportMain==nil) and (wHelp==nil) then
			reportedPlayer = nil
			wReportMain = guiCreateWindow(0.2, 0.2, 0.2, 0.175, "UnitedGaming - Contact Staff", true)
			scale(wReportMain)

			-- Controls within the window
			bClose = guiCreateButton(0.85, 0.9, 0.2, 0.1, "Close", true, wReportMain)
			addEventHandler("onClientGUIClick", bClose, clickCloseButton)
			
			-- Admin help related
			lHelp = guiCreateLabel(0.125, 0.10, 1.0, 0.1, "Contact Server Staff", true, wReportMain)
			guiSetFont(lHelp, "default-bold-small")
			lHelpAbout = guiCreateLabel(0.125, 0.15, 0.75, 0.6, "Not sure where something is or how to do something? Need an administrator? Click the button below to contact the server staff.", true, wReportMain)
			guiLabelSetHorizontalAlign(lHelpAbout, "left", true)
			bHelpAdmin = guiCreateButton(0.125, 0.280, 0.75, 0.10, "Contact Staff", true, wReportMain)
			addEventHandler("onClientGUIClick", bHelpAdmin, adminReportUI)
			-- Other Help
			lGMHelp = guiCreateLabel(0.125, 0.40, 1.0, 0.1, "Other Help", true, wReportMain)
			guiSetFont(lGMHelp, "default-bold-small")
			lGMHelpAbout = guiCreateLabel(0.125, 0.45, 0.75, 0.6, "Any other reports regarding possible death matching, loss of weapons, bugs, glitches, player and staff reports should be made on the forums. ", true, wReportMain)
			guiLabelSetHorizontalAlign(lGMHelpAbout, "left", true)
			--  
			guiWindowSetSizable(wReportMain, false)
			--guiBringToFront(wReportMain)
			showCursor(true)
		elseif (wReportMain~=nil) then
			guiSetVisible(wReportMain, false)
			destroyElement(wReportMain)
			
			wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp = nil
			guiSetInputEnabled(false)
			showCursor(false)
		end
	end
end
addCommandHandler("report", showReportMainUI)

-- Admin Report UI
function adminReportUI(button, state)
	if source == bHelpAdmin then
		local adminreport = getElementData(getLocalPlayer(), "adminreport")
		if adminreport or gmreport then
			guiSetText(wReportMain, "Your report ID #" .. adminreport .. " is still pending. Please wait or /er before submitting another.")
		else
			if (source==bHelpAdmin) and (button=="left") and (state=="up") then
				if (wHelp==nil) then
					destroyElement(wReportMain)
					wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelpAdmin, reportedPlayer = nil
					guiSetInputEnabled(true)
					
					wHelp = guiCreateWindow(0.2, 0.2, 0.2, 0.175, "Administrator Report", true)
					guiWindowSetSizable(wHelp, false)
					scale(wHelp)
					--guiSetAlpha(wHelp, 0.6)
					
					-- Controls within the window
					bClose = guiCreateButton(0.85, 0.9, 0.2, 0.1, "Close", true, wHelp)
					guiSetEnabled(bClose, true)
					addEventHandler("onClientGUIClick", bClose, clickCloseButton)
					
					lPlayerName = guiCreateLabel(0.025, 0.12, 1.0, 0.3, "Player you wish to report (Optional):", true, wHelp)
					guiSetFont(lPlayerName, "default-bold-small")
					
					tPlayerName = guiCreateEdit(0.425, 0.11, 0.25, 0.08, "Player Partial Name / ID", true, wHelp)
					addEventHandler("onClientGUIClick", tPlayerName, function()
						guiSetText(tPlayerName,"")
					end, false)
					
					lNameCheck = guiCreateLabel(0.425, 0.2, 1.0, 0.3, "You're reporting yourself.", true, wHelp)
					guiSetFont(lNameCheck, "default-bold-small")
					guiLabelSetColor(lNameCheck, 0, 255, 0)
					addEventHandler("onClientGUIChanged", tPlayerName, checkNameExists)
					
					lReport = guiCreateLabel(0.025, 0.3, 1.0, 0.3, "Report Information:", true, wHelp)
					guiSetFont(lPlayerName, "default-bold-small")
					
					tReport = guiCreateMemo(0.225, 0.29, 0.75, 0.5, "", true, wHelp)
					--guiMemoSetReadOnly(tReport, true)
					addEventHandler("onClientGUIChanged", tReport, checkReportLength)
					
					lLengthCheck = guiCreateLabel(0.4, 0.81, 0.4, 0.3, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.", true, wHelp)
					guiLabelSetColor(lLengthCheck, 0, 255, 0)
					guiSetFont(lLengthCheck, "default-bold-small")
					
					bSubmitAdminReport = guiCreateButton(0.4, 0.875, 0.2, 0.1, "Submit Report", true, wHelp)
					addEventHandler("onClientGUIClick", bSubmitAdminReport, submitAdminReport)
					guiSetEnabled(bSubmitAdminReport, false)
					bSubmitGMReport = nil
				end
			end
		end
	end
end

function submitAdminReport(button, state)
	if (source==bSubmitAdminReport) and (button=="left") and (state=="up") then
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer or getLocalPlayer(), tostring(guiGetText(tReport))) 
		
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelpAdmin, wHelp, lNameCheck, bSubmitAdminReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	guiSetText(lLengthCheck, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.")

	if (tonumber(string.len(tostring(guiGetText(tReport))))-1>150) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		if bSubmitAdminReport then
			guiSetEnabled(bSubmitAdminReport, false)
		end
		if bSubmitGMReport then
			guiSetEnabled(bSubmitGMReport, false)
		end
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1<3) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		if bSubmitAdminReport then
			guiSetEnabled(bSubmitAdminReport, false)
		end
		if bSubmitGMReport then
			guiSetEnabled(bSubmitGMReport, false)
		end
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1>130) then
		guiLabelSetColor(lLengthCheck, 255, 255, 0)
		if bSubmitAdminReport then
			guiSetEnabled(bSubmitAdminReport, true)
		end
		if bSubmitGMReport then
			guiSetEnabled(bSubmitGMReport, true)
		end
	else
		guiLabelSetColor(lLengthCheck,0, 255, 0)
		if bSubmitAdminReport then
			guiSetEnabled(bSubmitAdminReport, true)
		end
		if bSubmitGMReport then
			guiSetEnabled(bSubmitGMReport, true)
		end
	end
end
	

function checkNameExists(theEditBox)
	local found = nil
	local count = 0
	
	
	local text = guiGetText(theEditBox)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			for key, value in ipairs(players) do
				local username = string.lower(tostring(getPlayerName(value)))
				if string.find(username, string.lower(text)) then
					count = count + 1
					found = value
					break
				end
			end
		end
	end
	
	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found - Will take yourself to submit.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
	elseif (count==1) then
		guiSetText(lNameCheck, "Player Found: " .. getPlayerName(found) .. " (ID #" .. getElementData(found, "playerid") .. ")")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
	elseif (count==0) then
		guiSetText(lNameCheck, "Player not found - Will take yourself to submit.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitAdminReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function onOpenCheck(playerID)
	executeCommandHandler ( "check", tostring(playerID) )
end
addEvent("report:onOpenCheck", true)
addEventHandler("report:onOpenCheck", getRootElement(), onOpenCheck)
