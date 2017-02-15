mysql = exports.mysql
local useShopsWithNoItems = false

-- respawn dead npcs after two minute
addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		setTimer(
			function( source )
				local x,y,z = getElementPosition(source)
				local rotation = getElementData(source, "rotation")
				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)
				local dbid = getElementData(source, "dbid")
				local shoptype = getElementData(source, "shoptype")
				local skin = getElementModel(source)
				local sPendingWage = getElementData(source, "sPendingWage") 
				local sIncome = getElementData(source, "sIncome") 
				local sCapacity = getElementData(source, "sCapacity") 
				local currentCap = getElementData(source, "currentCap") 
				local sSales = getElementData(source, "sSales") 
				local pedName = getElementData(source, "pedName") 
				destroyElement(source)
				createShopKeeper(x,y,z,interior,dimension,dbid,shoptype,rotation,skins, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName)
			end,
			120000, 1, source
		)
	end
)

local skins = { { 211, 217 }, { 179 }, false, { 178 }, { 82 }, { 80, 81 }, { 28, 29 }, { 169 }, { 171, 172 }, { 142 }, { 171 }, { 171, 172 }, {71}, { 50 }, { 1 }, { 118 }, {118} }

function createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation, skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo)
	if not g_shops[shoptype] then
		outputDebugString("Trying to locate shop #" .. id .. " with invalid shoptype " .. shoptype)
		return
	end
	
	if not skin then
		skin = 0
		
		if shoptype == 3 then
			skin = 168
			-- needs differences for burgershot etc
			if interior == 5 then
				skin = 155
			elseif interior == 9 then
				skin = 167
			elseif interior == 10 then
				skin = 205
			end
			-- interior 17 = donut shop
		elseif shoptype == 16 then
			skin = 27
		else
			-- clothes, interior 5 = victim
			-- clothes, interior 15 = binco
			-- clothes, interior 18 = zip
			skin = skins[shoptype][math.random( 1, #skins[shoptype] )]
		end
	end 
	
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementDimension(ped, dimension)
	setElementInterior(ped, interior)
	exports.pool:allocateElement(ped)
	
	if shoptype == 17 then
		setElementData(ped, "customshop", true)
		setElementData(ped, "pedName", pedName, true) 
	end 
	setElementData(ped, "shopkeeper", true)
		
	setElementFrozen(ped, true)
	
	setElementData(ped, "dbid", id, true)
	setElementData(ped, "type", "shop", false)
	setElementData(ped, "shoptype", shoptype, false)
	setElementData(ped, "rotation", rotation, false)
	setElementData(ped, "sPendingWage", sPendingWage, true)
	setElementData(ped, "sIncome", sIncome, true)
	setElementData(ped, "sCapacity", sCapacity, true)
	setElementData(ped, "currentCap", currentCap, true) 
	setElementData(ped, "sSales", sSales, true) 
	setElementData(ped, "sContactInfo", sContactInfo, true) 
end

function delNearbyGeneralshops(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Deleting Nearby shops:", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
			local pedType = getElementData(thePed, "type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						if deleteGeneralShop(thePlayer, "delshop" , dbid) then
							--outputChatBox("   Deleted Shop with ID #" .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
							count = count + 1
						end
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   Deleted None.", thePlayer, 255, 126, 0)
		else
			outputChatBox("   Deleted "..count.." None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyshops", delNearbyGeneralshops, false, false)
addCommandHandler("delnearbypeds", delNearbyGeneralshops, false, false)
addCommandHandler("delnearbynpcs", delNearbyGeneralshops, false, false)

-- function createDynamic(x,y,z,interior,dimension,id,rotation,skin ~= -1 and skin, products)
	-- if not skin then
		-- skin = skins[8][math.random( 1, #skins[8] )]
	-- end
	-- local ped = createPed(skin, x, y, z)
	-- setElementDimension(ped, dimension)
	-- setElementInterior(ped, interior)
	-- exports.pool:allocateElement(ped)
	
	-- setElementData(ped, "shopkeeper", true)
	-- setElementFrozen(ped, true)
	-- setElementData(ped, "dbid", id, false)
	-- setElementData(ped, "type", "shop", false)
	-- setElementData(ped, "shoptype", 0, false)
	-- setElementData(ped, "rotation", rotation, false)
-- end

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local result1 = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM shops AS e1 LEFT JOIN shops AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result1 then
		local id1 = tonumber(result1["nextID"]) or 1
		return id1
	end
	return false
end

function createGeneralshop(thePlayer, commandName, shoptype, skin, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local shoptype = tonumber(shoptype)
		if shoptype and g_shops[shoptype] then
			local skin = tonumber(skin)
			if shoptype == 17 then
				if not skin or not (...) then
					outputChatBox("SYNTAX: /" .. commandName .. " 17 [skin] [Firstname Lastname]", thePlayer, 255, 194, 14)
					outputChatBox("[skin] and [Firstname Lastname] are required for shop ID 17.", thePlayer, 255, 194, 14)
					return false
				end
			end
			if skin then
				local ped = createPed(skin, 0, 0, 3)
				if not ped then
					outputChatBox("Invalid Skin.", thePlayer, 255, 0, 0)
					return
				else
					destroyElement(ped)
				end
			else
				skin = -1
			end
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interior = getElementInterior(thePlayer)
			local rotation = math.ceil(getPedRotation(thePlayer) / 30)*30
			
			local pedName = false
			if (...) then
				pedName = table.concat({...}, "_")
				if not string.find(pedName, "_") then
					outputChatBox("SYNTAX: /" .. commandName .. " 17 [skin] [Firstname Lastname]", thePlayer, 255, 194, 14)
					outputChatBox("[skin] and [Firstname Lastname] are required for shop ID 17.", thePlayer, 255, 194, 14)
					return false
				end
				local checkName = mysql:query("SELECT `id` FROM `characters` WHERE `charactername`='".. mysql:escape_string( pedName ) .."'")
				local row3 = {}
				if checkName then
					row3 = mysql:fetch_assoc(checkName) or false
					mysql:free_result(checkName)
				end
				if row3 then
					outputChatBox("An other player's character has already used this name '"..pedName.."'.", thePlayer, 255,0,0)
					return false
				end
				
				local checkName2 = mysql:query("SELECT `id` FROM `shops` WHERE `pedName`='".. mysql:escape_string( pedName ) .."'")
				local row33 = {}
				if checkName2 then
					row33 = mysql:fetch_assoc(checkName2) or false
					mysql:free_result(checkName2)
				end
				if row33 then
					outputChatBox("An other shop has already used this name '"..pedName.."'.", thePlayer, 255,0,0)
					return false
				end
			end
			
			local id = false
			if pedName then
				id = mysql:query_insert_free("INSERT INTO shops SET pedName='"..pedName:gsub("'","''").."', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "', shoptype='" .. mysql:escape_string(shoptype) .. "', rotation='" .. mysql:escape_string(rotation) .. "', skin='".. mysql:escape_string(skin).."' ")
			else
				id = mysql:query_insert_free("INSERT INTO shops SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "', shoptype='" .. mysql:escape_string(shoptype) .. "', rotation='" .. mysql:escape_string(rotation) .. "', skin='".. mysql:escape_string(skin).."' ")
			end
			
			if (id) then
				if pedName then
					createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation,skin ~= -1 and skin, 0, 0, 10, 0, "", pedName)
				else
					createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation,skin ~= -1 and skin, 0, 0, 10, 0, "")
				end
				outputChatBox("General shop created with ID #" .. id .. " and type "..shoptype..".", thePlayer, 0, 255, 0)
				exports.logs:logMessage("[/makeshop] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." did make shop id " .. id .. " with type " .. shoptype, 4)
			else
				outputChatBox("Error creating shop.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [shop type] [optional skin]", thePlayer, 255, 194, 14)
			for k, v in ipairs(g_shops) do
				outputChatBox("TYPE " .. k .. " = " .. v.name, thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("makeshop", createGeneralshop, false, false)

function getNearbyGeneralshops(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby shops:", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
			local pedType = getElementData(thePed, "type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						outputChatBox("   Shop with ID " .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyshops", getNearbyGeneralshops, false, false)
addCommandHandler("nearbypeds", getNearbyGeneralshops, false, false)
addCommandHandler("nearbynpcs", getNearbyGeneralshops, false, false)

function gotoShop(thePlayer, commandName, shopID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not tonumber(shopID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Shop ID]", thePlayer, 255, 194, 14)
		else
			local possibleShops = getElementsByType("ped")
			local foundShop = false
			for _, shop in ipairs(possibleShops) do
				if getElementData(shop,"shopkeeper") and (tonumber(getElementData(shop, "dbid")) == tonumber(shopID)) then
					foundShop = shop
					break
				end
			end
			
			if not foundShop then
				outputChatBox("No shop founded with ID #"..shopID, thePlayer, 255, 0, 0)
				return false
			end
				
			local x, y, z = getElementPosition(foundShop)
			local dim = getElementDimension(foundShop)
			local int = getElementInterior(foundShop)
			local rot = getElementRotation(foundShop)
			startGoingToShop(thePlayer, x,y,z,rot,int,dim,shopID)
		end
	end
end
addCommandHandler("gotoshop", gotoShop, false, false)
addCommandHandler("gotoped", gotoShop, false, false)
addCommandHandler("gotonpc", gotoShop, false, false)

function startGoingToShop(thePlayer, x,y,z,r,interior,dimension,shopID)
	-- Maths calculations to stop the player being stuck in the target
	x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
	y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
	
	setCameraInterior(thePlayer, interior)
	
	if (isPedInVehicle(thePlayer)) then
		local veh = getPedOccupiedVehicle(thePlayer)
		setVehicleTurnVelocity(veh, 0, 0, 0)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
		setElementInterior(veh, interior)
		setElementDimension(veh, dimension)
		setElementPosition(veh, x, y, z + 1)
		warpPedIntoVehicle ( thePlayer, veh ) 
		setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
	else
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
	end
	outputChatBox(" You have teleported to shop ID#"..shopID, thePlayer)
end

function restoreGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
			if not id then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		local dbid = id
	
		local checkExist = mysql:query("SELECT `id` FROM `shops` WHERE `id`='"..tostring(dbid).."' AND `deletedBy` != '0'")
		
		local row = exports.mysql:fetch_assoc(checkExist)
		if not (row) then
			outputChatBox("Shop ID #" .. dbid .. " isn't found in deleted shop database.", thePlayer, 255, 0, 0)
			return false
		end
		
		mysql:query_free("UPDATE `shops` SET `deletedBy` = '0' WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
		loadOneShop(dbid)
		outputChatBox("Restored shop with ID #" .. dbid .. ".", thePlayer, 0, 255, 0)
			
	end
end
addCommandHandler("restoreshop", restoreGeneralShop, false, false)
addCommandHandler("restorenpc", restoreGeneralShop, false, false)
addCommandHandler("restoreped", restoreGeneralShop, false, false)


function deleteGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			
			for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
				local pedType = getElementData(thePed, "type")
				if (pedType) then
					if (pedType=="shop") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							local adminID = getElementData(thePlayer,"account:id")
							mysql:query_free("UPDATE `shops` SET `deletedBy` = '"..tostring(adminID).."' WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
							--mysql:query_free("DELETE FROM shop_products WHERE npcID='" .. mysql:escape_string(dbid) .. "' ")
							--mysql:query_free("DELETE FROM shop_contacts_info WHERE npcID='" .. mysql:escape_string(dbid) .. "' ")
							outputChatBox("      Deleted shop with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
							setElementData(thePlayer, "shop:mostRecentDeleteShop",dbid, true )
						end
					end
				end
			end
			
			if (counter==0) then
				outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
				return false
			end
			return true
		end
	end
end
addCommandHandler("delshop", deleteGeneralShop, false, false)
addCommandHandler("delnpc", deleteGeneralShop, false, false)
addCommandHandler("delped", deleteGeneralShop, false, false)

function removeGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (id) then
			id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
			if not id then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		local dbid = id
		
		local checkExist = mysql:query("SELECT `id` FROM `shops` WHERE `id`='"..tostring(dbid).."' AND `deletedBy` != '0'")
		
		local row = exports.mysql:fetch_assoc(checkExist) 
		if not (row) then
			outputChatBox("Shop ID #" .. dbid .. " isn't found in deleted shop database, /delshop first.", thePlayer, 255, 0, 0)
			return false
		end
		
		
		if mysql:query_free("DELETE FROM shops WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1") and	mysql:query_free("DELETE FROM shop_products WHERE npcID='" .. mysql:escape_string(dbid) .. "' ") and mysql:query_free("DELETE FROM shop_contacts_info WHERE npcID='" .. mysql:escape_string(dbid) .. "' ") then
			outputChatBox("Removed shop ID #" .. dbid .. " from SQL.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "shop:mostRecentDeleteShop",false, true )
		else
			outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
		end
		
	end
end
addCommandHandler("removeshop", removeGeneralShop, false, false)
addCommandHandler("removenpc", removeGeneralShop, false, false)
addCommandHandler("removeped", removeGeneralShop, false, false)

function loadAllGeneralshops(res)
	local result = mysql:query("SELECT `shops`.`id` AS `id`, `x`, `y`, `z`, `dimension`, `interior`, `shoptype`, `rotation`, `skin`, `sPendingWage`, `sIncome`, `sCapacity`, `sSales`, `pedName`, `sOwner`, `sPhone`, `sEmail`, `sForum` FROM `shops` LEFT JOIN `shop_contacts_info` ON `shops`.`id` = `shop_contacts_info`.`npcID` WHERE `shops`.`deletedBy` = '0'")
	
	while true do
		local row = exports.mysql:fetch_assoc(result)
		if not (row) then
			break
		end
		
		local id = tonumber(row["id"])
		local x = tonumber(row["x"])
		local y = tonumber(row["y"])
		local z = tonumber(row["z"])
			
		local dimension = tonumber(row["dimension"])
		local interior = tonumber(row["interior"])
		local shoptype = tonumber(row["shoptype"])
		local rotation = tonumber(row["rotation"])
		local skin = tonumber(row["skin"])
		local sPendingWage = tonumber(row["sPendingWage"])
		local sIncome = tonumber(row["sIncome"])
		local sCapacity = tonumber(row["sCapacity"])
		local currentCap = 0
		local sSales = row["sSales"]
		local pedName = row["pedName"]
		
		local result1 = mysql:query("SELECT COUNT(*) as `currentCap` FROM `shop_products` WHERE `npcID` = '"..tostring(id).."' ") or false
		if result1 then
			local row1 = exports.mysql:fetch_assoc(result1)
			currentCap = tonumber(row1["currentCap"]) or 0
			mysql:free_result(result1)
		end 
		
		local sContactInfo = {row["sOwner"],row["sPhone"],row["sEmail"],row["sForum"]}
		
		createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo)
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllGeneralshops)

function loadOneShop(shopID)
	local result = mysql:query("SELECT `shops`.`id` AS `id`, `x`, `y`, `z`, `dimension`, `interior`, `shoptype`, `rotation`, `skin`, `sPendingWage`, `sIncome`, `sCapacity`, `sSales`, `pedName`, `sOwner`, `sPhone`, `sEmail`, `sForum` FROM `shops` LEFT JOIN `shop_contacts_info` ON `shops`.`id` = `shop_contacts_info`.`npcID` WHERE `shops`.`deletedBy` = '0' AND `shops`.`id` = '"..tostring(shopID).."' LIMIT 1")
	
	
	local row = exports.mysql:fetch_assoc(result)
	if not (row) then
		return false
	end
	
	local id = tonumber(row["id"])
	local x = tonumber(row["x"])
	local y = tonumber(row["y"])
	local z = tonumber(row["z"])
		
	local dimension = tonumber(row["dimension"])
	local interior = tonumber(row["interior"])
	local shoptype = tonumber(row["shoptype"])
	local rotation = tonumber(row["rotation"])
	local skin = tonumber(row["skin"])
	local sPendingWage = tonumber(row["sPendingWage"])
	local sIncome = tonumber(row["sIncome"])
	local sCapacity = tonumber(row["sCapacity"])
	local currentCap = 0
	local sSales = row["sSales"]
	local pedName = row["pedName"]
	
	local result1 = mysql:query("SELECT COUNT(*) as `currentCap` FROM `shop_products` WHERE `npcID` = '"..tostring(id).."' ") or false
	if result1 then
		local row1 = exports.mysql:fetch_assoc(result1)
		currentCap = tonumber(row1["currentCap"]) or 0
		mysql:free_result(result1)
	end 
	
	local sContactInfo = {row["sOwner"],row["sPhone"],row["sEmail"],row["sForum"]}
	
	createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo)
	
	mysql:free_result(result)
	return true
end

function reloadGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
			if not id then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		if loadOneShop(id) then
			outputChatBox("Reloaded shop ID#"..id..".",thePlayer, 0,255,0)
		else
			outputChatBox("Reloaded shop ID#"..id..".",thePlayer, 255,0,0)
		end
	end
end
addCommandHandler("reloadshop", reloadGeneralShop, false, false)
addCommandHandler("reloadnpc", reloadGeneralShop, false, false)
addCommandHandler("reloadped", reloadGeneralShop, false, false)

-- end of loading shops, this be store keeper thing below --
local function getDiscount( player, shoptype )
	local discount = 1
	if shoptype == 7 and tonumber( getElementData( player, "faction" ) ) == 125 then
		discount = discount * 0.5
	elseif shoptype == 14 and tonumber( getElementData( player, "faction" ) ) == 30 then
		discount = discount * 0.5
	end
	
	if exports.donators:hasPlayerPerk( player, 8 ) then
		discount = discount * 0.8
	end
	return discount
end

function clickStoreKeeper()
	local shoptype = getElementData(source, "shoptype")
	local id = getElementData(source, "dbid")
	
	local race, gender = nil, nil
	if(shoptype == 5) then -- if its a clothes shop, we also need the players race
		gender = getElementData(client,"gender")
		race = getElementData(client,"race")
	end
	
	if tonumber(shoptype) == 17 then
		local products = {}
		local shopProducts = mysql:query("SELECT * FROM `shop_products` WHERE `npcID`='"..id.."' ORDER BY `pDate` DESC")
		while true do
			local pRow = mysql:fetch_assoc(shopProducts)
			if not pRow then break end
			table.insert(products, { id, pRow["pItemID"], pRow["pItemValue"], pRow["pDesc"], pRow["pPrice"], pRow["pDate"], pRow["pID"] } )
		end
		mysql:free_result(shopProducts) 
		--[[
		local shopInfo = {}
		local shopInfos = mysql:query("SELECT `sPendingWage`, `sIncome`, `sCapacity`, `sSales` FROM `shops` WHERE `id`='"..id.."' LIMIT 1")
		local pRow1 = mysql:fetch_assoc(shopInfos) or false
		if pRow1 then
			table.insert(shopInfo, { id, pRow1["sPendingWage"], pRow1["sIncome"], pRow1["sCapacity"], pRow1["sSales"] } )
			mysql:free_result(shopInfos) 
		end]]
		triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, 0, products)
	else
		-- perk 8 = 20% discount in shops
		triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, getDiscount(client, shoptype))
	end
end
addEvent("shop:keeper", true)
addEventHandler("shop:keeper", getResourceRootElement(), clickStoreKeeper)


function calcSupplyCosts(thePlayer, itemID, isWeapon, supplyCost)
	if not isweapon and id ~= 68 then
		if exports.donators:hasPlayerPerk(thePlayer, 8) then
			return math.ceil( 0.8 * supplyCost )
		end
	end
	return supplyCost
end

function getInteriorOwner( dimension )
	if dimension == 0 then
		return nil, nil
	end
	
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["interior-system"]:findProperty(source)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

-- source = the ped clicked
-- client = the player
-- this has no code for the out-of-date lottery.
addEvent("shop:buy", true)
addEventHandler( "shop:buy", resourceRoot, function( index )
	local shoptype = getElementData( source, "shoptype")
	local error = "S-" .. tostring( shoptype ) .. "-" .. tostring( getElementData( source, "dbid") )

	local shop = g_shops[ shoptype or -1 ]
	_G['shop'] = shop
	if not shop then
		outputChatBox("Error " .. error .. "-NE, report at www.unitedgaming.org/mantis.", client, 255, 0, 0 )
		return
	end
	
	local race = getElementData( client, "race" )
	local gender = getElementData( client, "gender" )
	updateItems( shoptype, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
	
	-- fetch the selected item
	local item = getItemFromIndex( shoptype, index )
	if not item then
		outputChatBox("Error " .. error .. "-NEI-" .. index .. ", report at www.unitedgaming.org/mantis.", client, 255, 0, 0 )
		return
	end
	
	-- random old checks. Why do we limit everyone to have one backpack again?
	if item.itemID == 48 and exports.global:hasItem( client, 48 ) and getPlayerName(client) ~= "Tyrone_Lawrence" and getPlayerName(client) ~= "April_Hayes" then
		outputChatBox( "You already have one " .. item.name .. " and it's unique.", client, 255, 0, 0 )
		return
	end
	
		--[[Check if its a generic, and if they have approval yet
	if item.name == "Other" and item.itemID == 80 and not getElementData(client, "shop:generic:pending") then
		triggerClientEvent(client, "shop:generic:buy", client, index)
		return
	end]]
	
	-- check for monies
	local price = math.ceil( getDiscount( client, shoptype ) * item.price )
	if not exports.global:hasMoney( client, price ) then
		outputChatBox( "You lack the money to buy this " .. item.name .. ".", client, 255, 0, 0 )
		return
	end
	
	-- @@ -- 
	-- do some item-specific stuff, such as assigning a serial.
	-- @@ -- 
	local itemID, itemValue = item.itemID, item.itemValue or 1
	if itemID == 2 then
		local attempts = 0
		while true do
			-- generate a larger phone number if we're totally out of numbers and/or too lazy to perform more than 20+ checks.
			attempts = attempts + 1
			itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
			
			local mysqlQ = mysql:query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber` = '" .. itemValue .. "'")
			if mysql:num_rows(mysqlQ) == 0 then
				mysql:free_result(mysqlQ)
				break
			end
			mysql:free_result(mysqlQ)
		end
	--[[elseif itemID == 68 then -- Lottery Tickets by Anthony
		local lotteryJackpot = exports['lottery-system']:getLotteryJackpot()
		if tonumber(lotteryJackpot) == -1 then
			outputChatBox( "Sorry, someone already won the lottery.", client, 255, 0, 0 )
			return
		else
			local updatedJackpot = tonumber(lotteryJackpot) + 10
			exports['lottery-system']:updateLotteryJackpot(tonumber(updatedJackpot))
		
			local lotteryTicketNumber = 0
			local lotteryTicketNumber = math.random(2,48) -- Pick a random number for the lottery ticket number between 2 and 48
			itemValue = tonumber(lotteryTicketNumber)
			
			if tonumber(lotteryTicketNumber) == tonumber(exports['lottery-system']:getLotteryNumber()) then
				exports['global']:giveMoney(client, exports['lottery-system']:getLotteryJackpot())
				outputChatBox( "You won! Jackpot: " .. exports['lottery-system']:getLotteryJackpot(), client, 0, 255, 0 )
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						outputChatBox("[NEWS] " .. getPlayerName(client):gsub("_"," ") .. " won the lottery jackpot of $" .. exports['lottery-system']:getLotteryJackpot() .. ". The lottery will be redrawn soon.", value, 200, 100, 200)
						exports['global']:giveMoney(getTeamFromName("San Andreas News Network"), 10)
					end
				end
				exports['lottery-system']:updateLotteryJackpot(-1)
			else
				outputChatBox( "Sorry, your number did not get picked. You lost. You got number: " .. lotteryTicketNumber, client, 255, 0, 0 )
			end
			lotteryTicketNumber = 0
		end]]
	elseif itemID == 115 or itemID == 116 then -- now here's the trick. If item.license is set, it checks for a gun license, if item.ammo is set it gives as much ammo
		if item.license and getElementData( client, "license.gun" ) ~= 1 then
			outputChatBox( "You lack a weapon license.", client, 255, 0, 0 )
			return
		else
			if itemID == 115 then
				local serial = "1"
				if item.license then -- licensed weapon, thus needs a serial
					local characterDatabaseID = getElementData(client, "account:character:id")
					serial = exports.global:createWeaponSerial( 3, characterDatabaseID, characterDatabaseID )
				end
				itemValue = itemValue .. ":" .. serial .. ":" .. getWeaponNameFromID( itemValue )
			elseif itemID == 116 then
				itemValue = itemValue .. ":" .. ( item.ammo or exports.weaponcap:getGTACap( itemValue ) or 1 ) .. ":" .. getWeaponNameFromID( itemValue )
			end
		end
	end
	
	
	
	-- at this time le weapon stuff should be done, we're doing some magic with supplies now - namely, high item weight * 3.5 = supplies.
	-- Or supplies = item.supplies if any; this should prolly be done for electronics stuff
	local dimension = getElementDimension( source )
	local suppliesToTake = 0
	if dimension > 0 then -- is even in any interior
		-- check for any owner. unowned shops don't care for supplies.
		local ownerID, ownerPlayer = getInteriorOwner( dimension )
		if ownerID ~= 0 then
			-- calculate the supplies amount
			suppliesToTake = item.supplies or math.ceil( 3.5 * exports['item-system']:getItemWeight( itemID, itemValue ) )
			if not suppliesToTake then
				outputChatBox( "Error " .. error .. "-SE-I" .. index .. "-" .. tostring( suppliesToTake ) )
				return
			end
			
			-- get the current supply count and check for enough supplies
			local result = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id=" .. mysql:escape_string(dimension) .. " LIMIT 1")
			actualSupplies = tonumber(result["supplies"])
			
			if suppliesToTake > actualSupplies then
				outputChatBox( "This item is out of stock.", client, 255, 0, 0 )
				return
			elseif ownerPlayer and actualSupplies - suppliesToTake < 10 then -- low on supplies, just give a warning and continue
				outputChatBox( "Supplies in your business #" .. dimension .. " are low. Fill 'em up.", ownerPlayer, 255, 194, 14 )
			end
		end
	end
	
	
	if exports.global:giveItem( client, itemID, itemValue ) then
		-- Money
		local playerMoney = getElementData(client, "money")
		for i = 134, 134 do
			while exports['item-system']:takeItem(client, i) do
			end
		end
		if tonumber(playerMoney) > 0 then
			exports.global:giveItem(client, 134, tonumber(playerMoney)-tonumber(price))
		end
		exports.global:takeMoney( client, price ) -- this is assumed not to fail as we checked with :hasMoney before.
		-- and now for what happens after buying?
		outputChatBox( "You bought this " .. item.name .. " for $" .. exports.global:formatMoney( price ) .. ".", client, 0, 255, 0 )
		
		-- take the outstanding supplies
		if suppliesToTake > 0 then
			mysql:query_free("UPDATE interiors SET supplies = supplies - " .. mysql:escape_string(suppliesToTake) .. " WHERE id = " .. mysql:escape_string(dimension))
		end
		
		
		
		-- some post-buying things, item-specific
		if itemID == 2 then
			mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`, `boughtby`) VALUES ('"..tostring(itemValue).."', '"..mysql:escape_string(tostring(getElementData(client, "account:character:id") or 0)).."')")
			outputChatBox("Your number is #" .. itemValue .. ".", client, 255, 194, 14 )
		elseif itemID == 16 and item.fitting then -- it's a skin, so set it.
			setElementModel( client, itemValue )
			mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string( itemValue ) .. " WHERE id = " .. mysql:escape_string(getElementData( client, "dbid" )) )
			if setElementData( client, "casualskin", itemValue, false ) then
				mysql:query_free("UPDATE characters SET casualskin = " .. mysql:escape_string( itemValue ) .. " WHERE id = " .. mysql:escape_string(getElementData(client, "dbid")) )
			end
		elseif itemID == 114 then -- vehicle mods
			outputChatBox("To add this item to any vehicle, go into a garage and double-click the item while sitting inside.", client, 255, 194, 14 )
		elseif itemID == 115 then -- log weapon purchases
			exports.logs:dbLog( client, 36, client, "bought WEAPON - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		elseif itemID == 116 then -- log weapon purchases
			exports.logs:dbLog( client, 36, client, "bought AMMO - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		end
		
		
		
		-- What's left undone? Giving shop owner money!
		if price > 0 and dimension > 0 then
			local ownerID, ownerPlayer = getInteriorOwner( dimension )
			if ownerID > 0 then -- someone even owns it
				if ownerPlayer then
					local profits = getElementData(ownerPlayer, "businessprofit")
					setElementData(ownerPlayer, "businessprofit", profits + price, false)
				else
					mysql:query_free( "UPDATE characters SET bankmoney=bankmoney + " .. mysql:escape_string(price) .. " WHERE id = " .. mysql:escape_string(ownerID) .. " LIMIT 1")
				end
			end
		end
	else
		outputChatBox( "You do not have enough space to carry this " .. item.name .. ".", client, 255, 0, 0 )
	end
end )

-- TADA. End of buying items.

globalSupplies = 0

function updateGlobalSupplies(value)
	globalSupplies = globalSupplies + value
	mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(tostring(globalSupplies)) .. "' WHERE name='globalsupplies'")
end
addEvent("updateGlobalSupplies", true)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

function checkSupplies(thePlayer)
	local dbid, entrance, exit, inttype,interiorElement = exports['interior-system']:findProperty( thePlayer )
	
	if (dbid==0) then
		outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
	else
		local interiorStatus = getElementData(interiorElement, "status")
		local owner = interiorStatus[4]
		
		if (tonumber(owner)==getElementData(thePlayer, "dbid") or exports.global:hasItem(thePlayer, 4, dbid) or exports.global:hasItem(thePlayer, 5, dbid)) and (inttype==1) then
			local query = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
			local supplies = query["supplies"]
			outputChatBox("This business has " .. supplies .. " supplies.", thePlayer, 255, 194, 14)
		else
			outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checksupplies", checkSupplies, false, false)

		--triggerEvent("shop:handleSupplies", source, element, slot, event)
		--triggerClientEvent( source, event or "finishItemMove", source )

addEvent("shop:handleSupplies", true)
function handleSupplies(element, slot, event, worldItem)
	local id, itemID, itemValue, item = nil
	
	if worldItem then
		id = getElementData( worldItem, "id" )
		itemID = getElementData( worldItem, "itemID" )
		itemValue = getElementData( worldItem, "itemValue" )
	end	

	if slot ~= -1 then
		item = exports['item-system']:getItems( source )[ slot ]
	end
	
	if (item and item [1] ~= 121) and (itemID and itemID ~= 121) then
		outputChatBox("You cannot use this item for restocking, sorry.", source, 255,0,0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local dbid, entrance, exit, inttype,interiorElement = exports['interior-system']:findProperty( source )
	if (dbid==0) then
		outputChatBox("You are not in a business.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	if not (inttype==1) then -- ((tonumber(owner)==getElementData(source, "dbid") or exports.global:hasItem(source, 4, dbid) or exports.global:hasItem(source, 5, dbid)) and (inttype==1)) then
		outputChatBox("You can not restock a non-business property.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	amount = item and tonumber(item[2]) or itemValue and tonumber(itemValue) or 0
	if not amount or amount < 1 then
		outputChatBox("This item is not compatible, please contact an admin.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local result = mysql:query_free("UPDATE interiors SET supplies= supplies + " .. mysql:escape_string(amount) .. " where id='" .. mysql:escape_string(dbid) .. "'")
	if result then
		
		if slot == -1 and worldItem and id and isElement(worldItem) then
			outputChatBox("You've added ".. amount .." supplies to this business.", source, 0, 240, 0)
			
			mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
			destroyElement(worldItem)
		else
			outputChatBox("You've added ".. amount .." supplies to this business.", source, 0, 240, 0)
			exports['item-system']:takeItemFromSlot( source, slot )
		end
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	return false
end
addEventHandler("shop:handleSupplies", getRootElement(), handleSupplies)

function resStart()
	local result = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
	globalSupplies = tonumber(result["value"])
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)