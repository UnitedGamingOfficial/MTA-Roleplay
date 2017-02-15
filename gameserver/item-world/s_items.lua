local mysql = exports.mysql
function createItem(id, itemID, itemValue, ...)
	local o = createObject(...)
	if o then
		exports['anticheat-system']:changeProtectedElementDataEx(o, "id", id, false)
		exports['anticheat-system']:changeProtectedElementDataEx(o, "itemID", itemID)
		exports['anticheat-system']:changeProtectedElementDataEx(o, "itemValue", itemValue, itemValue ~= 1)
		return o
	else
		if mysql:query_free("DELETE FROM `worlditems` WHERE `id` = '" .. mysql:escape_string(id).."'" ) then
			outputDebugString("Deleted bugged Item ID #"..id)
		else
			outputDebugString("Failed to delete bugged Item ID #"..id)
		end
		return false
	end
end
