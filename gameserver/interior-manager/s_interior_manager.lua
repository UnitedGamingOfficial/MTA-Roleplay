local mysql = exports.mysql

function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports['anticheat-system']:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end

function getAllInts(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local interiorsList = {}
		local mQuery1 = nil
		mQuery1 = mysql:query("SELECT interiors.id AS iID, type, name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, interiors.adminnote AS iAdminNote, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id ORDER BY interiors.createdDate DESC")
		
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			table.insert(interiorsList, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"] } )
		end
		mysql:free_result(mQuery1)
		triggerClientEvent(thePlayer, "createIntManagerWindow", thePlayer, interiorsList, getElementData( thePlayer, "account:username" ))
	end
end
addCommandHandler("interiors", getAllInts)
addCommandHandler("ints", getAllInts)
addEvent("interiorManager:openit", true)
addEventHandler("interiorManager:openit", getRootElement(), getAllInts)

function delIntCmd(thePlayer, intID )
	executeCommandHandler ( "delint", thePlayer, intID )
end
addEvent("interiorManager:delint", true)
addEventHandler("interiorManager:delint", getRootElement(), delIntCmd)

function disableInt(thePlayer, intID )
	executeCommandHandler ( "toggleinterior", thePlayer, intID )
end
addEvent("interiorManager:disableInt", true)
addEventHandler("interiorManager:disableInt", getRootElement(), disableInt)

function gotoInt(thePlayer, intID )
	executeCommandHandler ( "gotohouse", thePlayer, intID )
end
addEvent("interiorManager:gotoInt", true)
addEventHandler("interiorManager:gotoInt", getRootElement(), gotoInt)

function restoreInt(thePlayer, intID )
	executeCommandHandler ( "restoreInt", thePlayer, intID )
end
addEvent("interiorManager:restoreInt", true)
addEventHandler("interiorManager:restoreInt", getRootElement(), restoreInt)

function removeInt(thePlayer, intID )
	executeCommandHandler ( "removeint", thePlayer, intID )
end
addEvent("interiorManager:removeInt", true)
addEventHandler("interiorManager:removeInt", getRootElement(), removeInt)
  
function forceSellInt(thePlayer, intID )
	executeCommandHandler ( "fsell", thePlayer, intID )
end
addEvent("interiorManager:forceSellInt", true)
addEventHandler("interiorManager:forceSellInt", getRootElement(), forceSellInt)

function openAdminNote(thePlayer, intID )
	executeCommandHandler ( "checkint", thePlayer, intID )
end
addEvent("interiorManager:openAdminNote", true)
addEventHandler("interiorManager:openAdminNote", getRootElement(), openAdminNote)

function interiorSearch(thePlayer, keyword )
	if keyword and keyword ~= "" and keyword ~= "Search..." then
		local interiorsResultList = {}
		local mQuery1 = nil
		mQuery1 = mysql:query("SELECT interiors.id AS iID, type, name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, interiors.adminnote AS iAdminNote, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id WHERE interiors.id LIKE '%"..keyword.."%' OR name LIKE '%"..keyword.."%' OR cost LIKE '%"..keyword.."%' OR charactername LIKE '%"..keyword.."%' OR username LIKE '%"..keyword.."%' OR interiors.adminnote LIKE '%"..keyword.."%' OR interiors.creator LIKE '%"..keyword.."%' ORDER BY interiors.createdDate DESC")
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			table.insert(interiorsResultList, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"] } )
		end
		mysql:free_result(mQuery1)
		triggerClientEvent(thePlayer, "interiorManager:FetchSearchResults", thePlayer, interiorsResultList, getElementData( thePlayer, "account:username" ))
	end
end
addEvent("interiorManager:Search", true)
addEventHandler("interiorManager:Search", getRootElement(), interiorSearch)

function checkInt(thePlayer, commandName, intID)
	if exports.global:isPlayerAdmin( thePlayer ) then 
		if not tonumber(intID) or (tonumber(intID) <= 0 ) or (tonumber(intID) % 1 ~= 0 ) then
			intID = getElementDimension(thePlayer)
			if intID == 0 then
				outputChatBox( "You must be inside an interior.", thePlayer, 255, 194, 14)
				outputChatBox("Or use SYNTAX: /"..commandName.." [Interior ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		local mQuery1 = mysql:query("SELECT interiors.id AS iID, type, name, cost, charactername, username, cked, locked, supplies, safepositionX,safepositionY, safepositionZ, disabled, deleted, interiors.adminnote AS iAdminNote, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id WHERE interiors.id = '"..intID.."' ORDER BY interiors.createdDate DESC") or false
		if mQuery1 then
			local result = {}
			local row = mysql:fetch_assoc(mQuery1) or false
			mysql:free_result(mQuery1)
			if not row then
				outputChatBox("Interior ID doesn't exist!", thePlayer, 255, 0, 0)
				return 
			end
			table.insert(result, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["safepositionY"], row["safepositionZ"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"] } )
			
			local mQuery2 = mysql:query("SELECT `interior_logs`.`date` AS `date`, `interior_logs`.`intID` as `intID`, `interior_logs`.`action` AS `action`, `accounts`.`username` AS `adminname`, `interior_logs`.`log_id` AS `logid` FROM `interior_logs` LEFT JOIN `accounts` ON `interior_logs`.`actor` = `accounts`.`id` WHERE `interior_logs`.`intID` = '"..intID.."' ORDER BY `interior_logs`.`date` DESC") or false
			local result2 = {}
			while mQuery2 do
				local row2 = mysql:fetch_assoc(mQuery2) or false
				if row2 then
					table.insert(result2, { row2["date"], row2["action"], row2["adminname"], row2["logid"], row2["intID"]} )
				else
					break
				end
			end
			mysql:free_result(mQuery2)
			triggerClientEvent(thePlayer, "createCheckIntWindow", thePlayer, result, exports.global:getPlayerAdminTitle(thePlayer), result2)
		else
			outputChatBox("Database Error!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checkint", checkInt)
addCommandHandler("checkinterior", checkInt)
addEvent("interiorManager:checkint", true)
addEventHandler("interiorManager:checkint", getRootElement(), checkInt)

function saveAdminNote(thePlayer, adminNote, intID )
	local mQuery1 = false
	mQuery1 = mysql:query_free("UPDATE `interiors` SET `adminnote` = '"..tostring(adminNote):gsub("'","''").."' WHERE `id` = '"..intID.."'")
	if mQuery1 then
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			local intID2 = getElementData(interior, "dbid")
			if tonumber(intID2) == tonumber(intID) then
				setElementDataEx(interior, "adminnote", string.sub(tostring(adminNote),1,100), true	)
				--outputDebugString("Saved admin note on Interior #"..intID.." - '"..string.sub(tostring(adminNote),1,100).."'.")
				return true
			end
		end
	end
end
addEvent("interiorManager:saveAdminNote", true)
addEventHandler("interiorManager:saveAdminNote", getRootElement(), saveAdminNote)

function restock(thePlayer, commandName, intID, amount)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not intID or not tonumber(intID) or tonumber(intID)%1~=0 then
			amount = 300
			intID = getElementDimension(thePlayer)
			if intID == 0 then
				outputChatBox( "You must be inside an interior to restock. Or use SYNTAX: /" .. commandName .. " [Interior ID] [Amount 1~300]", thePlayer, 255, 194, 14 )
				return false
			end
		else
			if not amount or not tonumber(amount) or tonumber(amount)%1~=0 or tonumber(amount) < 1 or tonumber(amount) > 300 then
				outputChatBox( "SYNTAX: /" .. commandName .. " [Interior ID] [Amount 1~300]", thePlayer, 255, 194, 14 )
				outputChatBox( "Restocks businesses with supplies.", thePlayer, 255, 100, 0 )
				return false
			end
		end
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			if tonumber(intID) == getElementData(interior, "dbid") then
				local amount2 = getElementData(interior, "status")[6] + tonumber(amount)
				local mQuery1 = mysql:query_free("UPDATE `interiors` SET `supplies` = '"..amount2.."' WHERE `id` = '"..intID.."'") or false
				if not mQuery1 then
					outputChatBox( "Failed to restock "..getElementData(interior, "name").." (ID#"..intID.."), Database error!", thePlayer, 255, 0, 0 )
					return false
				end
				--exports["interior-system"]:reloadOneInterior(tonumber(intID))
				outputChatBox( getElementData(interior, "name").." (ID#"..intID..") has been restocked with "..amount.." supplies.", thePlayer, 0, 255, 0 )
				local adminUsername = getElementData(thePlayer, "account:username")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminID = getElementData(thePlayer, "account:id")
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restocked "..getElementData(interior, "name").." (ID#"..intID..") with "..amount.." of supplies.")
				else
					exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has has restocked "..getElementData(interior, "name").." (ID#"..intID..") with "..amount.." of supplies.")
				end
				local addLog = mysql:query_free("INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(intID).."', '"..commandName:gsub("'","''").." with "..amount.." supplies', '"..adminID.."')") or false
				if not addLog then
					outputDebugString("Failed to add interior logs.")
				end
				return true
			end
		end
	end
end
addCommandHandler("restock", restock, false, false)