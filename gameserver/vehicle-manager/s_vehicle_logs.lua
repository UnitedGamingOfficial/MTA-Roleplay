local mysql = exports.mysql
	
function addVehicleLogs(vehID, action, actor, clearPreviousLogs)
	if vehID and action and actor then
		if clearPreviousLogs then
			if not mysql:query_free("DELETE FROM `vehicle_logs` WHERE `vehID`='"..tostring(vehID).. "'") or not mysql:query_free("DELETE FROM `logtable` WHERE `affected`='ve"..tostring(vehID).. ";'") then
				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs.")
				return false
			end
		end
		-- local adminUsername = getElementData(actor, "account:username")
		-- local hiddenAdmin = getElementData(actor, "hiddenadmin")
		-- local adminTitle = exports.global:getPlayerAdminTitle(actor)
		local adminID = getElementData(actor, "account:id") or false
		if adminID then 
			local addLog = mysql:query_free("INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('"..tostring(vehID).."', '"..action.."', '"..tostring(adminID).."')") or false
			if not addLog then
				outputDebugString("[VEHICLE MANAGER] Failed to add vehicle logs.")
				return false
			else
				return true
			end
		else
			outputDebugString("[VEHICLE MANAGER] Lack of agruments #3 for the function addVehicleLogs().")
			return false
		end
	else
		outputDebugString("[VEHICLE MANAGER] Lack of agruments #1 or #2 for the function addVehicleLogs().")
		return false
	end
end