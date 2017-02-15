local localPlayer = getLocalPlayer()
local root = getRootElement()
local vehList1 = {}
local vehTabPanel = false
local sx, sy = guiGetScreenSize()

function createVehManagerWindow(vehList)
	if gWin then
		closeVehManager()
	end
	if (vehList) then
		showCursor(true)
		--guiSetInputEnabled(true)
		--vehList1 = vehList
		gWin = guiCreateWindow(sx/2-400,sy/2-300,800,600,"Vehicle Manager v1.0 © Maxime - UnitedGaming",false)
			guiWindowSetSizable(gWin,false)
			--guiSetProperty(gWin,"TitlebarEnabled","false")
		vehTabPanel = guiCreateTabPanel(0.0113,0.1417,0.9775,0.8633,true,gWin)
			
		bDelVeh = guiCreateButton(0.0113,0.035,0.0938,0.045,"DELETE INT",true,gWin)
			guiSetFont(bDelVeh,"default-bold-small")
		bRestoreVeh = guiCreateButton(0.0113,0.085,0.0938,0.045,"RESTORE INT",true,gWin)
			guiSetFont(bRestoreVeh,"default-bold-small")
		
		bToggleInt = guiCreateButton(0.1175,0.035,0.1,0.045,"TOGGLE INT",true,gWin)
			guiSetFont(bToggleInt,"default-bold-small")
		bGotoVeh = guiCreateButton(0.1175,0.085,0.1,0.045,"GO TO INT",true,gWin)
			guiSetFont(bGotoVeh,"default-bold-small")

		bForceSell = guiCreateButton(0.23,0.035,0.1,0.045,"FORCE-SELL",true,gWin)
			guiSetFont(bForceSell,"default-bold-small")
		bRemoveVeh = guiCreateButton(0.23,0.085,0.1,0.045,"REMOVE INT",true,gWin)
			guiSetFont(bRemoveVeh,"default-bold-small")
			
		bAdminNote = guiCreateButton(0.3425,0.035,0.1,0.045,"ADMIN NOTE",true,gWin)
			guiSetFont(bAdminNote,"default-bold-small")
		bSearch = guiCreateButton(0.3425,0.085,0.1,0.045,"SEARCH INT",true,gWin)
			guiSetFont(bSearch,"default-bold-small")
		
		bClose = guiCreateButton(0.455,0.035,0.1,0.09,"CLOSE",true,gWin)
			guiSetFont(bClose,"default-bold-small")
		
		local lTotal = guiCreateLabel(460,25,164,17,"Total Interiors: ",false,gWin)
		local lActive = guiCreateLabel(460,42,164,17,"Active Interiors: ",false,gWin)
		local lDisableInts = guiCreateLabel(628,25,159,17,"Disabled Interiors: ",false,gWin)
		local lInactive = guiCreateLabel(628,42,159,17,"Inactive Interiors: ",false,gWin)
		local lOwnedbyCKs = guiCreateLabel(460,59,164,17,"Ints owned by CK-ed's: ",false,gWin)
		local lDeletedInts = guiCreateLabel(628,59,159,17,"Deleted Interiors: ",false,gWin)
		
		local targetTab = {}
		local targetList = {}
		local colID = {}
		local colPlate = {}
		local colName = {}
		local colMileageAndHP = {}
		local colOwner = {}
		local colLastUsed = {}
		local colCarHP = {}
		local colDriveType = {}
		local colSafeInstalled = {}
		local colStolenAndChopped = {}
		local colDeleted = {}
		local colCreatedBy = {}
		local colCreatedDate = {}
		local colAdminNote = {}
		
		targetTab[1] = guiCreateTab( "Active Interiors", vehTabPanel ) 
		targetTab[2] = guiCreateTab( "Inactive Interiors", vehTabPanel ) 
		targetTab[3] = guiCreateTab( "Disabled Interiors", vehTabPanel ) 
		targetTab[4] = guiCreateTab( "Interiors owned by CK-ed chars", vehTabPanel ) 
		targetTab[5] = guiCreateTab( "Deleted Interiors", vehTabPanel ) 
		targetTab[6] = guiCreateTab( "Search Results", vehTabPanel ) 
		
		targetList[1] = guiCreateGridList(0,0,1,1,true,targetTab[1])
		targetList[2] = guiCreateGridList(0,0,1,1,true,targetTab[2])
		targetList[3] = guiCreateGridList(0,0,1,1,true,targetTab[3])
		targetList[4] = guiCreateGridList(0,0,1,1,true,targetTab[4])
		targetList[5] = guiCreateGridList(0,0,1,1,true,targetTab[5])
		targetList[6] = guiCreateGridList(0,0,1,1,true,targetTab[6])
		
		for i = 1,6 do
			colID[i] = guiGridListAddColumn(targetList[i],"ID",0.07)
			colPlate[i] = guiGridListAddColumn(targetList[i],"Type",0.1)	
			colName[i] = guiGridListAddColumn(targetList[i],"Name",0.25)
			colMileageAndHP[i] = guiGridListAddColumn(targetList[i],"Price",0.07)
			colOwner[i] = guiGridListAddColumn(targetList[i],"Owner",0.2)
			--local colPosition = guiGridListAddColumn(targetList[i],"Location",0.07)
			colLastUsed[i] = guiGridListAddColumn(targetList[i],"Last Used",0.08)
			colCarHP[i] = guiGridListAddColumn(targetList[i],"Locked",0.06)
			colDriveType[i] = guiGridListAddColumn(targetList[i],"Supplies",0.06)
			colSafeInstalled[i] = guiGridListAddColumn(targetList[i],"Safe Installed",0.06)
			colStolenAndChopped[i] = guiGridListAddColumn(targetList[i],"Disabled",0.06)
			colDeleted[i] = guiGridListAddColumn(targetList[i],"Deleted",0.08)
			colCreatedBy[i] = guiGridListAddColumn(targetList[i],"Created By",0.1)
			colCreatedDate[i] = guiGridListAddColumn(targetList[i],"Created Date",0.17)
			colAdminNote[i] = guiGridListAddColumn(targetList[i],"Admin Note",1)
		end	
		local count = {[1]=0, [2] = 0, [3] = 0, [4] = 0, [5] = 0}
		for _, record in ipairs(vehList) do
			local lastUsed, isInteriorInactive = formartDays(record[8])
			local i = 1 -- active ints
			if record[13] ~= "0" then --deleted ints
				i = 5 
				count[5] = count[5] + 1
			elseif isInteriorInactive then -- inactive ints
				i = 2
				count[2] = count[2] + 1
			elseif record[12] == "1" then --disabled ints
				i = 3 
				count[3] = count[3] + 1
			elseif record[7] == "1" then -- owned by CKed's
				i = 4
				count[4] = count[4] + 1
			else
				count[1] = count[1] + 1
			end
			
			local row = guiGridListAddRow(targetList[i])
			guiGridListSetItemText(targetList[i], row, colID[i], record[1] or "", false, true)
			guiGridListSetItemText(targetList[i], row, colPlate[i], intTypeName(record[2]), false, false)
			guiGridListSetItemText(targetList[i], row, colName[i], record[3] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colMileageAndHP[i], record[4], false, true)
			guiGridListSetItemText(targetList[i], row, colOwner[i], charName(record[5])..cked(record[7])..accountName(record[6]), false, false) 
			guiGridListSetItemText(targetList[i], row, colLastUsed[i],lastUsed , false, false)
			guiGridListSetItemText(targetList[i], row, colCarHP[i], record[9] == "0" and "Unlocked" or "Locked", false, false)
			guiGridListSetItemText(targetList[i], row, colDriveType[i], record[10] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colSafeInstalled[i], record[11] and "Yes" or "No", false, false)
			guiGridListSetItemText(targetList[i], row, colStolenAndChopped[i], record[12] == "1" and "Yes" or "No", false, false)
			guiGridListSetItemText(targetList[i], row, colDeleted[i], record[13] == "0" and "No" or "by "..record[13], false, false)
			guiGridListSetItemText(targetList[i], row, colCreatedBy[i], record[16] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colCreatedDate[i], record[15] or "", false, false)
			guiGridListSetItemText(targetList[i], row, colAdminNote[i], record[14] or "", false, false)
			
			--IntsSearchList[i] = {record[1] or "", intTypeName(record[2]), record[3] or "", record[4], charName(record[5])..cked(record[7])..accountName(record[6]), lastUsed, record[9] == "0" and "Unlocked" or "Locked", record[10] or "",  record[11] and "Yes" or "No", record[12] == "1" and "Yes" or "No", record[13] == "0" and "No" or "by "..record[13], record[16] or "", record[15] or "", record[14] or ""}
			--outputDebugString("IntsSearchList["..i.."] = "..IntsSearchList[i][1])   
		end
		
		--fetching stats
		guiSetText( lTotal , "Total Interiors: "..count[1]+count[2]+count[3]+count[4]+count[5])
		guiSetText( lActive , "Active Interiors: "..count[1])
		guiSetText( lDisableInts , "Disabled Interiors: "..count[3])
		guiSetText( lInactive , "Inactive Interiors: "..count[2])
		guiSetText( lOwnedbyCKs , "Ints owned by CK-ed's: "..count[4])
		guiSetText( lDeletedInts , "Deleted Interiors: "..count[5])
		
		function getListFromActiveTab(vehTabPanel)
			if vehTabPanel then
				if guiGetSelectedTab (vehTabPanel ) == targetTab[1] then
					return targetList[1], 1
				elseif guiGetSelectedTab (vehTabPanel ) == targetTab[2] then
					return targetList[2], 2
				elseif guiGetSelectedTab (vehTabPanel ) == targetTab[3] then
					return targetList[3], 3
				elseif guiGetSelectedTab (vehTabPanel ) == targetTab[4] then
					return targetList[4], 4
				elseif guiGetSelectedTab (vehTabPanel ) == targetTab[5] then
					return targetList[5], 5
				elseif guiGetSelectedTab (vehTabPanel ) == targetTab[6] then
					return targetList[6], 6
				else
					return false, false
				end
			else
				return false, false
			end
		end
		
		addEventHandler("onClientGUIClick", bClose, singleClickedGate)
		
		addEventHandler( "onClientGUIClick", bSearch,
			function( button )
				if button == "left" then
					showCursor(true)
					guiSetInputEnabled(true)
					wInteriorSearch = guiCreateWindow(sx/2-176,sy/2-52,352,104,"Interior Search",false)
					guiWindowSetSizable(wInteriorSearch,false)
					local lText = guiCreateLabel(10,22,341,16,"Input any related information about an interior (ID, Name, Owner, Price,...) :",false,wInteriorSearch)
					guiSetFont(lText,"default-small")
					local eSearch = guiCreateEdit(10,38,331,31,"Search...",false,wInteriorSearch)
					addEventHandler("onClientGUIFocus", eSearch, function ()
						guiSetText(eSearch , "")
					end, false)
					local bCancel = guiCreateButton(10,73,169,22,"CANCEL",false,wInteriorSearch)
					guiSetFont(bCancel,"default-bold-small")
					addEventHandler( "onClientGUIClick", bCancel, function( button )
						if button == "left" and wInteriorSearch then
							destroyElement(wInteriorSearch)
							wInteriorSearch = nil
							-- showCursor(false)
							-- guiSetInputEnabled(false)
						end
					end, false)
					local bGo = guiCreateButton(179,73,162,22,"GO",false,wInteriorSearch)
					guiSetFont(bGo,"default-bold-small")
					addEventHandler( "onClientGUIClick", bGo, function( button )
						if button == "left" and wInteriorSearch then
							triggerServerEvent("vehicleManager:Search", getLocalPlayer(), getLocalPlayer(), guiGetText(eSearch))
							destroyElement(wInteriorSearch)
							wInteriorSearch = nil
							-- showCursor(false)
							-- guiSetInputEnabled(false)
						end
					end, false)
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bDelVeh,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:delVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
								-- closeVehManager()
								-- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer()) 
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bToggleInt,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:disableInt", getLocalPlayer(), getLocalPlayer(), gridID) then
								-- closeVehManager()
								-- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer()) 
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bGotoVeh,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:gotoVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
								--closeVehManager()
								--triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer()) 
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bRestoreVeh,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:restoreVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
								-- closeVehManager()
								-- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer()) 
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bRemoveVeh,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:removeVeh", getLocalPlayer(), getLocalPlayer(), gridID) then
								-- closeVehManager()
								-- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bForceSell,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:forceSellInt", getLocalPlayer(), getLocalPlayer(), gridID) then
								-- closeVehManager()
								-- triggerServerEvent("vehicleManager:openit", getLocalPlayer(), getLocalPlayer())
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
		addEventHandler( "onClientGUIClick", bAdminNote,
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local activeList = getListFromActiveTab(vehTabPanel)
					if activeList then
						local row, col = guiGridListGetSelectedItem(activeList)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( activeList , row, 1 )
							if triggerServerEvent("vehicleManager:openAdminNote", getLocalPlayer(), getLocalPlayer(), gridID) then
								--guiGridListRemoveRow ( activeList, row )
							end
						else
							guiSetText(gWin, "You need to select an interior from the list below first.")
						end
					end
				end
			end,
		false)
		
	function fetchSearchResults(interiorsResultList)
		if interiorsResultList then
			local i = 6
			guiGridListClear ( targetList[i] )
			local activeList, index = getListFromActiveTab(vehTabPanel)
			if index ~= i then
				guiSetSelectedTab ( vehTabPanel, targetTab[i] )
			end
			for _, record in ipairs(interiorsResultList) do
				local row = guiGridListAddRow(targetList[i])
				guiGridListSetItemText(targetList[i], row, colID[i], record[1] or "", false, true)
				guiGridListSetItemText(targetList[i], row, colPlate[i], intTypeName(record[2]), false, false)
				guiGridListSetItemText(targetList[i], row, colName[i], record[3] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colMileageAndHP[i], record[4], false, true)
				guiGridListSetItemText(targetList[i], row, colOwner[i], charName(record[5])..cked(record[7])..accountName(record[6]), false, false) 
				local lastUsed, isInteriorInactive = formartDays(record[8]) 
				guiGridListSetItemText(targetList[i], row, colLastUsed[i],lastUsed , false, false)
				guiGridListSetItemText(targetList[i], row, colCarHP[i], record[9] == "0" and "Unlocked" or "Locked", false, false)
				guiGridListSetItemText(targetList[i], row, colDriveType[i], record[10] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colSafeInstalled[i], record[11] and "Yes" or "No", false, false)
				guiGridListSetItemText(targetList[i], row, colStolenAndChopped[i], record[12] == "1" and "Yes" or "No", false, false)
				guiGridListSetItemText(targetList[i], row, colDeleted[i], record[13] == "0" and "No" or "by "..record[13], false, false)
				guiGridListSetItemText(targetList[i], row, colCreatedBy[i], record[16] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colCreatedDate[i], record[15] or "", false, false)
				guiGridListSetItemText(targetList[i], row, colAdminNote[i], record[14] or "", false, false)
			end
		end
	end
	addEvent("vehicleManager:FetchSearchResults", true)
	addEventHandler("vehicleManager:FetchSearchResults", localPlayer, fetchSearchResults)
	end
end
addEvent("createVehManagerWindow", true)
addEventHandler("createVehManagerWindow", localPlayer, createVehManagerWindow)

function formartDays(days)
	if not days then
		return "Unknown", false
	elseif tonumber(days) == 0 then
		return "Today", false
	elseif tonumber(days) >= 14 then
		return days.." days ago (inactive)", true
	else
		return days.." days ago", false
	end
end

function intTypeName(intType)
	local intTypeName = "Unknown" 
	if intType == "0" then 
		intTypeName = "House" 
	elseif intType == "1" then 
		intTypeName = "Business"
	elseif intType == "2" then
		intTypeName = "Government"
	elseif intType == "3" then
		intTypeName = "Rentable"
	end
	return intTypeName
end

function cked(ckStatus)
	local cked = ""
	if ckStatus == "1" then 
		cked = " - CKed" 
	end
	return cked
end

function charName(name)
	local charName = ""
	if name then
		charName = name:gsub("_", " ")
	end
	return charName
end

function accountName(name)
	local accountName = ""
	if name then
		accountName = " ("..name..")"
	end
	return accountName
end

function closeVehManager()
	if gWin then
		removeEventHandler("onClientGUIClick", root, singleClickedGate)
		destroyElement(gWin)
		gWin = nil
		if wInteriorSearch then
			destroyElement(wInteriorSearch)
			wInteriorSearch = nil
		end
		showCursor(false)
		guiSetInputEnabled(false)
		vehTabPanel = nil
	end
end

function singleClickedGate()
	if source == bClose then
		closeVehManager()
	end
end

function createCheckVehWindow(result, adminTitle, history)
	if checkVehWindow then
		closeCheckVehWindow()
	end
	showCursor(true)
	guiSetInputEnabled(true)
	checkVehWindow = guiCreateWindow(sx/2-300,sy/2-233,600,466,"Vehicle Manager - Vehicle Admin Note - "..adminTitle.." "..getElementData( getLocalPlayer(), "account:username" ),false)
	guiWindowSetSizable(checkVehWindow,false)
	local lVehModelID = guiCreateLabel(12,27,365,17,"Vehicle Name/ID: ",false,checkVehWindow)
	local lOwner = guiCreateLabel(12,44,365,17,"Owner: ",false,checkVehWindow)
	local lLastUsed = guiCreateLabel(12,112,365,17,"Last Used: ",false,checkVehWindow)
	local lCarHP = guiCreateLabel(12,78,365,17,"Engine: ",false,checkVehWindow)
	local lDriveType = guiCreateLabel(372,95,365,17,"Drive Type: ",false,checkVehWindow)
	local lDeleted = guiCreateLabel(372,27,365,17,"Deleted: ",false,checkVehWindow)	
	local lMileageAndHP = guiCreateLabel(372,61,365,17,"Mileage: ",false,checkVehWindow)
	local lPlate = guiCreateLabel(12,61,365,17,"Plate: ",false,checkVehWindow)
	local lStolenAndChopped = guiCreateLabel(372,44,365,17,"Stolen: ",false,checkVehWindow)
	local lSuspensionHeight = guiCreateLabel(372,78,365,17,"Suspension Height: ",false,checkVehWindow)
	local lCreateDate = guiCreateLabel(372,112,365,17,"Created Date: ",false,checkVehWindow)
	local lCreateBy = guiCreateLabel(372,129,365,17,"Created By: ",false,checkVehWindow)
	local lPosition = guiCreateLabel(12,95,365,17,"Position: ",false,checkVehWindow)
	local lAdminNote = guiCreateLabel(12,133,80,17,"Admin Note: ",false,checkVehWindow)
		guiSetFont(lAdminNote,"default-bold-small")  
	local checkIntTabPanel = guiCreateTabPanel(12,156,576,269,false,checkVehWindow) 
	local tabAdminNote = guiCreateTab( "Admin Note", checkIntTabPanel ) 
	local mAdminNote = guiCreateMemo(0,0,1,1,"",true,tabAdminNote) 
	local bCopyAdminInfo = guiCreateButton(110,133,220,20,"Copy Your Admin Name & Current Date",false,checkVehWindow)
	
	local tabHistory = guiCreateTab( "History", checkIntTabPanel ) 
	local gHistory = guiCreateGridList(0,0,1,1,true,tabHistory)
	local colDate = guiGridListAddColumn(gHistory,"Date",0.25)
	local colAction = guiGridListAddColumn(gHistory,"Action",0.5)
	local colActor = guiGridListAddColumn(gHistory,"Actor",0.1)
	local colLogID = guiGridListAddColumn(gHistory,"Log Entry",0.1)  
	
	--fetching shit 
	guiSetText(lVehModelID, "Vehicle Name/ID: "..(getVehicleNameFromModel(result[1][2]) or "Unknown").." (ID #"..(result[1][1] or "Unknown")..")")
	guiSetText(lOwner, "Owner: "..(result[1][10] or result[1][11]:gsub("_"," "))..(result[1][14] == "1" and " - Impounded" or "") )
	guiSetText(lLastUsed, "Last Used: "..formartDays(result[1][24] or 0))
	guiSetText(lCarHP, "HP: "..math.floor(tonumber(result[1][8])/10).."% ("..math.floor(tonumber(result[1][8]))..")".."     ".."Fuel: "..(result[1][6].."%" or "Unknown").."     ".."Paintjob: "..(result[1][7] == "0" and "None" or result[1][7]))
	guiSetText(lDriveType, "Drive Type: "..(result[1][19] or "Default"))
	guiSetText(lDeleted, "Deleted: By "..(result[1][21] or "None") )
	guiSetText(lMileageAndHP, "Mileage: "..(math.floor(tonumber(result[1][17])/1000) or "0").." KM")   
	guiSetText(lPlate, "Plate: "..(result[1][9] or ""))
	guiSetText(lStolenAndChopped, "Stolen: "..(result[1][23] == "1" and "Yes" or "No").."           Chopped: "..(result[1][22] == "1" and "Yes" or "No"))
	guiSetText(lSuspensionHeight, "Suspension Height: "..(result[1][18] or "Default"))
	guiSetText(lCreateDate, "Created Date: "..(result[1][25] or "Unknown"))
	guiSetText(lCreateBy, "Created By: "..(result[1][15] or ""))
	guiSetText(lPosition, "Position: "..(result[1][3])..", "..(result[1][4])..", "..(result[1][5]).." (Int "..(result[1][13])..", Dim "..(result[1][12])..")")
	-- Fetching history
	if history then
		for _, h in ipairs(history) do
			local row = guiGridListAddRow(gHistory)
			guiGridListSetItemText(gHistory, row, colDate, h[1] or "N/A", false, true)
			guiGridListSetItemText(gHistory, row, colAction, h[2] or "N/A", false, false)
			guiGridListSetItemText(gHistory, row, colActor, h[3] or "N/A", false, false)
			guiGridListSetItemText(gHistory, row, colLogID, h[4] or "N/A", false, false)
		end
		-- guiGridListAutoSizeColumn ( gHistory, 1 )
		-- guiGridListAutoSizeColumn ( gHistory, 2 )
		-- guiGridListAutoSizeColumn ( gHistory, 3 )
		-- guiGridListAutoSizeColumn ( gHistory, 4 )
	end
	
	guiSetText(mAdminNote, result[1][20] or "\n")
	
	local bToggleInt1 = guiCreateButton(212,430,90,28,"TOGGLE INT",false,checkVehWindow)
		guiSetFont(bToggleInt1,"default-bold-small")
	addEventHandler( "onClientGUIClick", bToggleInt1,
		function( button )
			if button == "left" then
				triggerServerEvent("vehicleManager:disableInt", getLocalPlayer(), getLocalPlayer(), result[1][1])
			end
		end,
	false)
	
	local bGotoSafe = guiCreateButton(312,430,90,28,"GO TO SAFE",false,checkVehWindow)
		guiSetFont(bGotoSafe,"default-bold-small")
		guiSetEnabled(bGotoSafe, false)
	
	local bGotoVeh1, bRestoreVeh1, bDelVeh1 = nil
	if result[1][21] then --deleted
		bRestoreVeh1 = guiCreateButton(12,430,90,28,"RESTORE VEH",false,checkVehWindow)
		guiSetFont(bRestoreVeh1,"default-bold-small") 
		addEventHandler( "onClientGUIClick", bRestoreVeh1,
			function( button )
				if button == "left" then
					if triggerServerEvent("vehicleManager:restoreVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
						--setTimer(function ()
							triggerServerEvent("vehicleManager:checkveh", getLocalPlayer(), getLocalPlayer(), "checkveh", result[1][1])
						--end, 50, 1)
					end
				end
			end,
		false)
		bRemoveVeh1 = guiCreateButton(112,430,90,28,"REMOVE VEH",false,checkVehWindow)
		guiSetFont(bRemoveVeh1,"default-bold-small")
		addEventHandler( "onClientGUIClick", bRemoveVeh1,
			function( button )
				if button == "left" then
					if triggerServerEvent("vehicleManager:removeVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
						closeCheckVehWindow()
					end 
				end
			end,
		false)
		if getElementData(localPlayer, "adminlevel") < 6 then
			guiSetEnabled(bRemoveVeh1, false)
		end
		guiSetEnabled(bToggleInt1, false)
	else
		bGotoVeh1 = guiCreateButton(12,430,90,28,"GO TO VEH",false,checkVehWindow)
		guiSetFont(bGotoVeh1,"default-bold-small") 
		addEventHandler( "onClientGUIClick", bGotoVeh1,
			function( button )
				if button == "left" then
					triggerServerEvent("vehicleManager:gotoVeh", getLocalPlayer(), getLocalPlayer(), result[1][1])
				end
			end,
		false)
		bDelVeh1 = guiCreateButton(112,430,90,28,"DEL VEH",false,checkVehWindow)
		guiSetFont(bDelVeh1,"default-bold-small")
		addEventHandler( "onClientGUIClick", bDelVeh1,
			function( button )
				if button == "left" then
					if triggerServerEvent("vehicleManager:delVeh", getLocalPlayer(), getLocalPlayer(), result[1][1]) then
						triggerServerEvent("vehicleManager:checkveh", getLocalPlayer(), getLocalPlayer(), "checkveh", result[1][1])
					end
				end
			end,
		false)
	end
	
	local bSave = guiCreateButton(412,430,90,28,"SAVE",false,checkVehWindow)
		guiSetFont(bSave,"default-bold-small")
	local bClose = guiCreateButton(509,430,79,28,"CLOSE",false,checkVehWindow)
		guiSetFont(bClose,"default-bold-small")
	
	addEventHandler( "onClientGUIClick", bClose,
		function( button )
			if button == "left" then
				closeCheckVehWindow()
			end
		end,
	false)
	
	addEventHandler( "onClientGUIClick", bCopyAdminInfo,
		function( button )
			if button == "left" then
				local time = getRealTime()
				local date = time.monthday
				local month = time.month+1
				local year = time.year+1900
				local adminUsername = getElementData( getLocalPlayer(), "account:username" )
				local content = " ("..adminTitle.." "..adminUsername.." on "..date.."/"..month.."/"..year..")"
				if setClipboard(content) then
					guiSetText(checkVehWindow, "Copied: '"..content.."'")
				end
			end
		end,
	false)
	
	addEventHandler( "onClientGUIClick", bSave,
		function( button )
			if button == "left" then
				if triggerServerEvent("vehicleManager:saveAdminNote", getLocalPlayer(), getLocalPlayer(), guiGetText(mAdminNote),result[1][1] ) then  
					outputChatBox("Admin Note on '"..(getVehicleNameFromModel(result[1][2]) or "Unknown").." (ID #"..(result[1][1] or "Unknown")..")' has been successfully saved!", 0,255,0)
				end
			end
		end,
	false)
end
addEvent("createCheckVehWindow", true)
addEventHandler("createCheckVehWindow", localPlayer, createCheckVehWindow)

function closeCheckVehWindow()
	if checkVehWindow then
		destroyElement(checkVehWindow)
		checkVehWindow = nil
		showCursor(false)
		guiSetInputEnabled(false)
	end
end