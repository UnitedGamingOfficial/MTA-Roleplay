
-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
-- setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
		handler = nil
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////


function loadWorldItems(res)
	local ticks = getTickCount( )
	checkMySQL()
	
	-- delete items too old
	--exports.mysql:query_free("DELETE FROM `worlditems` WHERE DATEDIFF(NOW(), creationdate) > 30 AND `itemID` != 80 AND `itemID` != 81 AND `itemID` != 103 AND protected = 0" )
	
	exports.mysql:query_free("DELETE FROM `worlditems` WHERE DATEDIFF(NOW(), creationdate) > 7 AND `itemID` = 72 AND protected = 0" )
	
	-- actually load items
	local result = mysql_query(handler, "SELECT id, itemid, itemvalue, x, y, z, dimension, interior, rz, creator, protected FROM worlditems")
	local count = 0
	for result, row in mysql_rows(result) do
		local id = tonumber(row[1])
		local itemID = tonumber(row[2])
		local itemValue = tonumber(row[3]) or row[3]
		local x = tonumber(row[4])
		local y = tonumber(row[5])
		local z = tonumber(row[6])
		local dimension = tonumber(row[7])
		local interior = tonumber(row[8])
		local rz2 = tonumber(row[9])
		local creator = tonumber(row[10])
		local protected = tonumber(row[11])
		
		if itemID < 0 then -- weapon
			itemID = -itemID
			local modelid = 2969
			-- MODEL ID
			if itemValue == 100 then
				modelid = 1242
			elseif itemValue == 42 then
				modelid = 2690
			else
				modelid = weaponmodels[itemID]
			end
		
			local obj = createItem(id, -itemID, itemValue, modelid, x, y, z - 0.1, 75, -10, rz2)
			exports.pool:allocateElement(obj)
			setElementDimension(obj, dimension)
			setElementInterior(obj, interior)
			exports['anticheat-system']:changeProtectedElementDataEx(obj, "creator", creator, false)
			
			if protected and protected ~= 0 then
				exports['anticheat-system']:changeProtectedElementDataEx(obj, "protected", protected, false)
			end
		else
			local modelid = exports['item-system']:getItemModel(itemID, itemValue)
			
			if (itemID==80) then
				local text = tostring(itemValue)
				local pos = text:find( ":" )
				if (text) and (pos) then
					text = text:sub( pos+1 )
					if tonumber(text) then
						modelid = tonumber(text)
					else
						modelid = 1241
					end
				end
			end
			
			local rx, ry, rz, zoffset = exports['item-system']:getItemRotInfo(itemID)
			local obj = createItem(id, itemID, itemValue, modelid, x, y, z + ( zoffset or 0 ), rx, ry, rz+rz2)
			
			if isElement(obj) then
				exports.pool:allocateElement(obj)
				setElementDimension(obj, dimension)
				setElementInterior(obj, interior)
				exports['anticheat-system']:changeProtectedElementDataEx(obj, "creator", creator, false)
			
				if protected and protected ~= 0 then
					exports['anticheat-system']:changeProtectedElementDataEx(obj, "protected", protected, false)
				end
			else
				outputDebugString(id .. "/" .. itemID .. "/" .. itemValue .. "/" .. modelid)
			end
		end
		count = count + 1
	end
	mysql_free_result(result)
	closeMySQL()
	
	outputDebugString("Loaded "..count.." world items in " .. ( getTickCount( ) - ticks ) .. "ms")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadWorldItems)
