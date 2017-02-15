local myadminWindow = nil
local listsGMCmds = {}
function gmhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerGameMaster(sourcePlayer) or exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			myadminWindow = guiCreateWindow (0.15, 0.15, 0.7, 0.7, "Index of GM commands (Updated on 21/5/2013)",	true)
			guiWindowSetSizable(myadminWindow, false)
			
			guiCreateLabel(0.02, 0.05, 0.6, 0.05,"Double click to copy command to clipboard.", true, myadminWindow)
			
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			
			local tabGMsRules = guiCreateTab( "Gamemaster Rules & Recent Updates", tabPanel )
			local memoGMRules = guiCreateMemo (  0.02, 0.02, 0.96, 0.96, getElementData(getResourceRootElement(getResourceFromName("account-system")), "gmrules:text") or "Error fetching...", true, tabGMsRules ) 
			guiMemoSetReadOnly(memoGMRules, true)
			
			
			for level = 1, 5 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				listsGMCmds[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (listsGMCmds[level], "Command", 0.15)
				guiGridListAddColumn (listsGMCmds[level], "Syntax", 0.35)
				guiGridListAddColumn (listsGMCmds[level], "Explanation", 1.3)
			end
			
			
			
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level -1: Trainee GM
				{
					-- player/*
					{ "/showadminreports",  "Subscribes to admin reports." },
					{ "/ads",  "Shows all pending adverts." },
					{ "/freezead",  "Freeze an advert." },
					{ "/unfreezead",  "Unfreeze an advert" },
					{ "/deletead",  "Delete an advert" },
					{ "/togautocheck", "Toogles auto opening player /check on /ar reports." },
					{ "/gmlounge", "/gmlounge", "Teleports you to the GM lounge." },
					{ "/g", "/g [Text]", "Talk in GM chat for communication with admins." },
					{ "/ar", "/ar [Report ID]", "Accept a report." },
					{ "/cr", "/cr [Report ID]", "Close a report." },
					{ "/dr", "/dr [Report ID]", "Drop a report, leaving it unanswered." },
					{ "/fr", "/fr [Report ID]", "Mark a report false" },
					{ "/ur", "/ur", "Shows all unanswered reports." },
					{ "/gmduty", "/gmduty", "Toggles GM duty (On/off)" },
					{ "/goto", "/goto [player]", "Teleport to a player's location." },
					{ "/gotoplace", "/gotoplace [LV/SF/LS/ASH/BANK/IGS/PC]", "Teleport to a pre-determined place." },
					{ "/mark", "/mark [Mark name]", "Create a mark for you to teleport to (doing /mark without a name will create a temporary one)" },
					{ "/gotomark", "/gotomark [Mark Name]", "Teleport to a pre-made mark (/gotomark without a mark name teleports to a temporary one)" },
					{ "/setjob  ", "/setjob [Player Partial Nick / ID] [Job ID]", "Sets player job." },
					{ "/deljob  ", "/deljob [Player Partial Nick / ID] [Job ID]", "Deletes player job." },
					{ "/resetcontract", "/resetcontract [Player]", "Resets the hours limit for the person" }
				},
				-- level -2: Game Master
				{
					{ "/freeze", "/freeze [Player]", "Freeze a player." },
					{ "/unfreeze", "/unfreeze [Player]", "Unfreeze a frozen player." },
					{ "/gethere", "/gethere [Player]", "Teleports a player to your location." },
					{ "/togpm", "/togpm", "Disables your pm's." }

					
				},
				-- level -3: Senior GameMaster
				{
					--{ "/nearbyvehicles", "/nearbyvehicles", "Checks near by vehicles, their owners and ID's" }, -- Not working
					--{ "/respawnveh", "/respawnveh [ID]", "Respawns a vehicle." }, -- Not working
					--{ "/forceapp", "/forceapp [Player] [Reason]", "Sets the player back in the application stage." }, -- Not working, not allowed to do forceapps.
				},
				{ -- level 4 gms
				  -- { "/recon", "/recon [player]", "recons the specified player" }, -- Removed for GMs
				  -- { "/stoprecon", "/stoprecon", "incase recon bugs out" }, -- Removed for GMs
				},
				{ -- level 5 gms
					{ "/makeadmin", "/makeadmin [player] [rank]", "gives the player an gm rank" },
				}
			
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( listsGMCmds[level] )
					guiGridListSetItemText ( listsGMCmds[level], row, 1, "-", false, false)
					guiGridListSetItemText ( listsGMCmds[level], row, 2, "-", false, false)
					guiGridListSetItemText ( listsGMCmds[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( listsGMCmds[level] )
						guiGridListSetItemText ( listsGMCmds[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( listsGMCmds[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( listsGMCmds[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			addEventHandler("onClientGUIDoubleClick", listsGMCmds[1] , GMcopyToClipboard1 , false)
			addEventHandler("onClientGUIDoubleClick", listsGMCmds[2] , GMcopyToClipboard2 , false)
			addEventHandler("onClientGUIDoubleClick", listsGMCmds[3] , GMcopyToClipboard3 , false)
			addEventHandler("onClientGUIDoubleClick", listsGMCmds[4] , GMcopyToClipboard4 , false)
			addEventHandler("onClientGUIDoubleClick", listsGMCmds[5] , GMcopyToClipboard5 , false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("gh", gmhelp)

function GMcopyToClipboard1(button,state)
	local row, col = guiGridListGetSelectedItem(listsGMCmds[1])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(listsGMCmds[1], guiGridListGetSelectedItem(listsGMCmds[1]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function GMcopyToClipboard2(button,state)
	local row, col = guiGridListGetSelectedItem(listsGMCmds[2])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(listsGMCmds[2], guiGridListGetSelectedItem(listsGMCmds[2]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function GMcopyToClipboard3(button,state)
	local row, col = guiGridListGetSelectedItem(listsGMCmds[3])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(listsGMCmds[3], guiGridListGetSelectedItem(listsGMCmds[3]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function GMcopyToClipboard4(button,state)
	local row, col = guiGridListGetSelectedItem(listsGMCmds[4])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(listsGMCmds[4], guiGridListGetSelectedItem(listsGMCmds[4]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function GMcopyToClipboard5(button,state)
	local row, col = guiGridListGetSelectedItem(listsGMCmds[5])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(listsGMCmds[5], guiGridListGetSelectedItem(listsGMCmds[5]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end