function saveToDescription(descriptions, theVehicle)
	local dbid = getElementData(theVehicle, "dbid")
	local acceptedQuerys = { }
	for i = 1, 5 do
		local result = exports.mysql:query_free("UPDATE vehicles SET description" .. i .. " = '" .. exports.mysql:escape_string( descriptions[i] ) .. "' WHERE id = '".. exports.mysql:escape_string(dbid) .."'")
		if result then
			exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "description:"..i, descriptions[i], true)
			acceptedQuerys[i] = true
		end
	end
	local counter = 0
	for j = 1, #acceptedQuerys do
		if acceptedQuerys[j] then
			counter = counter + 1
		end
	end
	if counter == 5 then
		outputChatBox("Description saved succesfully.", source, 0, 255, 0)
	else
		outputChatBox("ERROR-VEHDESC-0001 Please report on the mantis. Thank-you.", source, 255, 0, 0)
	end
end
addEvent("saveDescriptions", true)
addEventHandler("saveDescriptions", getRootElement(), saveToDescription)