local mysql = exports.mysql

function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports['anticheat-system']:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end

function getAllVehs(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local vehicleList = {}
		local mQuery1 = nil
		mQuery1 = mysql:query("SELECT vehicles.id AS vID, type, name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, vehicles.adminnote AS iAdminNote, vehicles.createdDate AS iCreatedDate, vehicles.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, vehicles.x, vehicles.y, vehicles.y FROM vehicles LEFT JOIN characters ON vehicles.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id ORDER BY vehicles.createdDate DESC")
		
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			table.insert(vehicleList, { row["vID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`vehicles`.`x`"], row["`vehicles`.`y`"], row["`vehicles`.`z`"] } )
		end
		mysql:free_result(mQuery1)
		triggerClientEvent(thePlayer, "createVehManagerWindow", thePlayer, vehicleList, getElementData( thePlayer, "account:username" ))
	end
end
addCommandHandler("vehicles", getAllVehs)
addCommandHandler("vehs", getAllVehs)
addEvent("vehicleManager:openit", true)
addEventHandler("vehicleManager:openit", getRootElement(), getAllVehs)

function delVehCmd(thePlayer, vehID )
	executeCommandHandler ( "delveh", thePlayer, vehID )
end
addEvent("vehicleManager:delVeh", true)
addEventHandler("vehicleManager:delVeh", getRootElement(), delVehCmd)

function disableInt(thePlayer, vehID )
	executeCommandHandler ( "togglevehicle", thePlayer, vehID )
end
addEvent("vehicleManager:disableInt", true)
addEventHandler("vehicleManager:disableInt", getRootElement(), disableInt)

function gotoVeh(thePlayer, vehID ) 
	executeCommandHandler ( "gotocar", thePlayer, vehID )
end
addEvent("vehicleManager:gotoVeh", true)
addEventHandler("vehicleManager:gotoVeh", getRootElement(), gotoVeh)

function restoreVeh(thePlayer, vehID )
	executeCommandHandler ( "restoreveh", thePlayer, vehID )
end
addEvent("vehicleManager:restoreVeh", true)
addEventHandler("vehicleManager:restoreVeh", getRootElement(), restoreVeh)

function removeVeh(thePlayer, vehID )
	executeCommandHandler ( "removeveh", thePlayer, vehID )
end
addEvent("vehicleManager:removeVeh", true)
addEventHandler("vehicleManager:removeVeh", getRootElement(), removeVeh)
  
function forceSellInt(thePlayer, vehID )
	executeCommandHandler ( "fsell", thePlayer, vehID )
end
addEvent("vehicleManager:forceSellInt", true)
addEventHandler("vehicleManager:forceSellInt", getRootElement(), forceSellInt)

function openAdminNote(thePlayer, vehID )
	executeCommandHandler ( "checkint", thePlayer, vehID )
end
addEvent("vehicleManager:openAdminNote", true)
addEventHandler("vehicleManager:openAdminNote", getRootElement(), openAdminNote)

function vehiclesearch(thePlayer, keyword )
	if keyword and keyword ~= "" and keyword ~= "Search..." then
		local vehiclesResultList = {}
		local mQuery1 = nil
		mQuery1 = mysql:query("SELECT vehicles.id AS vID, type, name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, vehicles.adminnote AS iAdminNote, vehicles.createdDate AS iCreatedDate, vehicles.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, vehicles.x, vehicles.y, vehicles.y FROM vehicles LEFT JOIN characters ON vehicles.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id WHERE vehicles.id LIKE '%"..keyword.."%' OR name LIKE '%"..keyword.."%' OR cost LIKE '%"..keyword.."%' OR charactername LIKE '%"..keyword.."%' OR username LIKE '%"..keyword.."%' OR vehicles.adminnote LIKE '%"..keyword.."%' OR vehicles.creator LIKE '%"..keyword.."%' ORDER BY vehicles.createdDate DESC")
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			table.insert(vehiclesResultList, { row["vID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], row["iAdminNote"], row["iCreatedDate"],row["iCreator"], row["`vehicles`.`x`"], row["`vehicles`.`y`"], row["`vehicles`.`z`"] } )
		end
		mysql:free_result(mQuery1)
		triggerClientEvent(thePlayer, "vehicleManager:FetchSearchResults", thePlayer, vehiclesResultList, getElementData( thePlayer, "account:username" ))
	end
end
addEvent("vehicleManager:Search", true)
addEventHandler("vehicleManager:Search", getRootElement(), vehiclesearch)

function checkVeh(thePlayer, commandName, vehID)
	if exports.global:isPlayerAdmin( thePlayer ) then 
		if not tonumber(vehID) or (tonumber(vehID) <= 0 ) or (tonumber(vehID) % 1 ~= 0 ) then
			local veh = getPedOccupiedVehicle(thePlayer) or false
			vehID = getElementData(veh, "dbid") or false
			if not vehID then
				outputChatBox( "You must be in a vehicle.", thePlayer, 255, 194, 14)
				outputChatBox("Or use SYNTAX: /"..commandName.." [Vehicle ID]", thePlayer, 255, 194, 14)
				return false
			elseif vehID <= 0 then
				outputChatBox( "You can't /checkveh on temp vehicle.", thePlayer, 255, 0, 0)
				return false
			end
		end
		
		local mQuery1 = mysql:query("SELECT `vehicles`.`id` AS `vID`, `vehicles`.`model` AS `vModel`, `vehicles`.`currx` AS `vPosX`, `vehicles`.`curry` AS `vPosY`, `vehicles`.`currz` AS `vPosZ`, `vehicles`.`fuel` AS `vFuel`, `vehicles`.`paintjob` AS `vPaintjob`,	`vehicles`.`hp` AS `vHp`, `factions`.`name` AS `fFactionName`, `characters`.`charactername` AS `cOwner`, `vehicles`.`job` AS `vJob`, `vehicles`.`tintedwindows` AS `vTintedwindows`,	`vehicles`.`currdimension` AS `vCurrdimension`,	`vehicles`.`currinterior` AS `vCurrInterior`, `vehicles`.`impounded` AS `vImpounded`, `vehicles`.`plate` AS `vPlate`, `vehicles`.`odometer` AS `vOdometer`, `vehicles`.`suspensionLowerLimit` AS `vSuspensionLowerLimit`,	`vehicles`.`driveType` AS `vDriveType`,	`vehicles`.`note` AS `vNote`, (SELECT `username` FROM `accounts` WHERE `id` = `vehicles`.`deleted`) AS `vDeleted`,	`vehicles`.`chopped` AS `vChopped`,	`vehicles`.`stolen` AS `vStolen`,	DATEDIFF(NOW(), `vehicles`.`lastUsed`) AS `vLastUsed`,	`vehicles`.`creationDate` AS `vCreationDate`,	`accounts`.`username` AS `aCreator` FROM `vehicles` LEFT JOIN `characters` ON `vehicles`.`owner`=`characters`.`id` LEFT JOIN `accounts` ON `vehicles`.`createdBy`=`accounts`.`id` LEFT JOIN `factions` ON`vehicles`.`faction`=`factions`.`id` WHERE `vehicles`.`id`='"..vehID.."' ORDER BY `vehicles`.`creationDate` DESC") or false
		if mQuery1 then  
			local result = {}
			local row = mysql:fetch_assoc(mQuery1) or false
			mysql:free_result(mQuery1)  
			if not row then
				outputChatBox("Vehicle ID #"..vehID.." doesn't exist!", thePlayer, 255, 0, 0)
				return false
			end 
			--                            1            2              3            4             5             6              7        
			table.insert(result, { row["vID"], row["vModel"], row["vPosX"], row["vPosY"], row["vPosZ"], row["vFuel"], row["vPaintjob"], 
			--   8              9				10					11   				12					13						14
			row["vHp"], row["vPlate"], row["fFactionName"], row["cOwner"], row["vCurrdimension"], row["vCurrInterior"], row["vImpounded"],
			--		15				16				17						18						19					20		
			row["aCreator"],row["vPlate"], row["vOdometer"],  row["vSuspensionLowerLimit"], row["vDriveType"], row["vNote"], 
			--		21				22					23			24					25
			row["vDeleted"], row["vChopped"],row["vStolen"], row["vLastUsed"], row["vCreationDate"] } )
			
			local mQuery2 = mysql:query("SELECT `vehicle_logs`.`date` AS `date`, `vehicle_logs`.`vehID` as `vehID`, `vehicle_logs`.`action` AS `action`, `accounts`.`username` AS `adminname`, `vehicle_logs`.`log_id` AS `logid` FROM `vehicle_logs` LEFT JOIN `accounts` ON `vehicle_logs`.`actor` = `accounts`.`id` WHERE `vehicle_logs`.`vehID` = '"..vehID.."' ORDER BY `vehicle_logs`.`date` DESC") or false
			local result2 = {}
			while mQuery2 do
				local row2 = mysql:fetch_assoc(mQuery2) or false
				if row2 then
					table.insert(result2, { row2["date"], row2["action"], row2["adminname"], row2["logid"], row2["vehID"]} )
				else
					break
				end
			end
			mysql:free_result(mQuery2)
			triggerClientEvent(thePlayer, "createCheckVehWindow", thePlayer, result, exports.global:getPlayerAdminTitle(thePlayer), result2)
		else
			outputChatBox("Database Error!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checkveh", checkVeh)
addCommandHandler("checkvehicle", checkVeh)
addEvent("vehicleManager:checkveh", true)
addEventHandler("vehicleManager:checkveh", getRootElement(), checkVeh)

function saveAdminNote(thePlayer, adminNote, vehID )  
	local mQuery1 = false
	mQuery1 = mysql:query_free("UPDATE `vehicles` SET `note` = '"..adminNote:gsub("'","''").."' WHERE `id` = '"..vehID.."'")
	if mQuery1 then
		local possiblevehicles = getElementsByType("vehicle")
		for _, vehicle in ipairs(possiblevehicles) do
			local vehID2 = getElementData(vehicle, "dbid")
			if tonumber(vehID2) == tonumber(vehID) then
				setElementDataEx(vehicle, "note", string.sub(tostring(adminNote),1,100), true	)
				--outputDebugString("Saved admin note on Interior #"..vehID.." - '"..string.sub(tostring(adminNote),1,100).."'.")
				addVehicleLogs(vehID, "modified admin note", thePlayer)
				return true
			end
		end
	end
end
addEvent("vehicleManager:saveAdminNote", true)
addEventHandler("vehicleManager:saveAdminNote", getRootElement(), saveAdminNote)

