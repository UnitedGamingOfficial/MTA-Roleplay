local mysql = exports.mysql
	
function addInteriorLogs(intID, action, actor, clearPreviousLogs)
	if intID and action and actor then
		if clearPreviousLogs then
			if not mysql:query_free("DELETE FROM `interior_logs` WHERE `intID`='"..tostring(intID).. "'") then
				outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..intID.." from `interior_logs`.")
				return false
			end
			if not mysql:query_free("DELETE FROM `logtable` WHERE `affected`='in"..tostring(intID).. ";'") then
				outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..intID.." from `logtable`.")
				return false
			end
		end
		
		local adminID = getElementData(actor, "account:id") or false
		if adminID then 
			local addLog = mysql:query_free("INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(intID).."', '"..action:gsub("'","''").."', '"..tostring(adminID).."')") or false
			if not addLog then
				outputDebugString("[INTERIOR MANAGER] Failed to add interior logs.")
				return false
			else
				return true
			end
		else
			outputDebugString("[INTERIOR MANAGER] Lack of agruments #3 for the function addInteriorLogs().")
			return false
		end
	else
		outputDebugString("[INTERIOR MANAGER] Lack of agruments #1 or #2 for the function addInteriorLogs().")
		return false
	end
end