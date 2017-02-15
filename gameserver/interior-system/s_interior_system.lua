addEvent("onPlayerInteriorChange", true)
intTable = {}
safeTable = {}
mysql = exports.mysql
-- to check:
-- payday

-- to test
-- /sell

--[[
Interior types:
TYPE 0: House
TYPE 1: Business
TYPE 2: Government (Unbuyable)
TYPE 3: Rentable
--]]

-- Small hack
function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports['anticheat-system']:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end
-- End small hack



function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM interiors AS e1 LEFT JOIN interiors AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function findProperty(thePlayer, dimension)
	local dbid = dimension or (thePlayer and getElementDimension( thePlayer ) or 0)
	if dbid > 0 then
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			local intID = getElementData(interior, "dbid")
			if intID == dbid then
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				local interiorStatus = getElementData(interior, "status")
				
				return dbid, interiorEntrance, interiorExit, interiorStatus[INTERIOR_TYPE], interior
			end
		end
	end
	return 0
end

function cleanupProperty( id, donotdestroy)
	if id > 0 then
		if exports.mysql:query_free( "DELETE FROM dancers WHERE dimension = " .. mysql:escape_string(id) ) then
			local res = getResourceRootElement( getResourceFromName( "dancer-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "ped", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
		
		if exports.mysql:query_free( "DELETE FROM shops WHERE dimension = " .. mysql:escape_string(id) ) then
			local res = getResourceRootElement( getResourceFromName( "shop-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "ped", res ) ) do
					if getElementDimension( value ) == id then
						local npcID = getElementData( value, "dbid" )
						exports.mysql:query_free( "DELETE FROM `shop_products` WHERE `npcID` = " .. mysql:escape_string(npcID) )
						destroyElement( value )
					end
				end
			end
		end
		
		
		
		if exports.mysql:query_free( "DELETE FROM atms WHERE dimension = " .. mysql:escape_string(id) ) then
			local res = getResourceRootElement( getResourceFromName( "bank-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "object", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
		local resE = getResourceRootElement( getResourceFromName( "elevator-system" ) )
		if resE then
			call( getResourceFromName( "elevator-system" ), "delElevatorsFromInterior", "MAXIME" , "PROPERTYCLEANUP",  id ) 
		end
		
		if not donotdestroy then
			local res1 = getResourceRootElement( getResourceFromName( "object-system" ) )
			if res1 then
				exports['object-system']:removeInteriorObjects( tonumber(id) )
			end
		end
		
		if safeTable[id] then
			local safe = safeTable[id]
			call( getResourceFromName( "item-system" ), "clearItems", safe )
			destroyElement(safe)
			safeTable[id] = nil
		end
		
		setTimer ( function () 
			call( getResourceFromName( "item-system" ), "deleteAllItemsWithinInt", id, 0, "CLEANUPINT" ) 
		end, 3000, 1)
		
	end
end

function sellProperty(thePlayer, commandName, bla)
	if bla then
		outputChatBox("Use /sell to sell this place to another player.", thePlayer, 255, 0, 0)
		return
	end
	  
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
	if dbid > 0 then
		if interiorType == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif interiorType ~= 3 and commandName == "unrent" then
			outputChatBox("You do not rent this property.", thePlayer, 255, 0, 0)
		else
			local interiorStatus = getElementData(interiorElement, "status")
			if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") then
				
				publicSellProperty(thePlayer, dbid, true, true, false)
				cleanupProperty(dbid, true)
				exports.logs:dbLog(thePlayer, 37, { "in"..tostring(dbid) } , "SELLPROPERTY "..dbid)
				local addLog = mysql:query_free("INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(dbid).."', '"..commandName.."', '"..getElementData(thePlayer, "account:id").."')") or false
				if not addLog then
					outputDebugString("Failed to add interior logs.")
				end
			else
				outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
			end
		end
	else 
		outputChatBox("You are not in a property.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)
addCommandHandler("unrent", sellProperty, false, false)

function publicSellProperty(thePlayer, dbid, showmessages, givemoney, CLEANUP)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer, dbid )
	local query = mysql:query_free("UPDATE interiors SET owner=-1, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL WHERE id='" .. dbid .. "'")
	if query then
		local interiorStatus = getElementData(interiorElement, "status")
		if getElementDimension(thePlayer) == dbid and not CLEANUP then
			setElementInterior(thePlayer, entrance[INTERIOR_INT])
			setCameraInterior(thePlayer, entrance[INTERIOR_INT])
			setElementDimension(thePlayer, entrance[INTERIOR_DIM])
			setElementPosition(thePlayer, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
		end

		if safeTable[dbid] then
			local safe = safeTable[dbid]
			if safe then
			exports['item-system']:clearItems(safe)
			destroyElement(safe)
			safeTable[dbid] = nil
			else
			end
		end
		
		if interiorType == 0 or interiorType == 1 then
			if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") then
				local money = math.ceil(interiorStatus[INTERIOR_COST] * 2/3)		
				if givemoney then
					exports.global:giveMoney(thePlayer, money)
					exports.global:takeMoney(getTeamFromName("Government of Los Santos"), money, true)
				end
				
				if showmessages then
					if CLEANUP == "FORCESELL" then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account:username")
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
						end
					else
						outputChatBox("You sold your property for " .. exports.global:formatMoney(money) .. "$.", thePlayer, 0, 255, 0)
					end
				end
				
				-- take all keys
				call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
				call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
				
				triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
			else
				if showmessages then
					if CLEANUP == "FORCESELL" then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account:username")
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
						end
					else
						outputChatBox("You set this property to unowned.", thePlayer, 0, 255, 0)
					end
				end
			end
		else
			if showmessages then
				if CLEANUP == "FORCESELL" then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username")
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
					end
				else
					outputChatBox("You are no longer renting this property.", thePlayer, 0, 255, 0)
				end
			end
			call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
			call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
			triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
		end	
		realReloadInterior(dbid)
	else
		outputChatBox("Error 504914 - Report on forums.", thePlayer, 255, 0, 0)
	end
end

function sellTo(thePlayer, commandName, targetPlayerName)
	-- only works in dimensions
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
	if dbid > 0 and not isPedInVehicle( thePlayer ) then
		local interiorStatus = getElementData(interiorElement, "status")
		if interiorStatus[INTERIOR_TYPE] == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif not targetPlayerName then
			outputChatBox("SYNTAX: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sells the Property you're in to that Player.", thePlayer, 255, 194, 14)
			outputChatBox("Ask the buyer to use /pay to recieve the money for the Property.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 10 and getElementDimension(targetPlayer) == getElementDimension(thePlayer) then
					if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") or exports.global:isPlayerFullAdmin(thePlayer) then
						if getElementData(targetPlayer, "dbid") ~= interiorStatus[INTERIOR_OWNER] then
							if exports.global:hasSpaceForItem(targetPlayer, 4, dbid) then
								local query = mysql:query_free("UPDATE interiors SET owner = '" .. getElementData(targetPlayer, "dbid") .. "' WHERE id='" .. dbid .. "'")
								if query then
																		
									local keytype = 4
									if interiorType == 1 then
										keytype = 5
									end

									call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
									call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
									exports.global:giveItem(targetPlayer, keytype, dbid)
									
									triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
									triggerClientEvent(targetPlayer, "createBlipAtXY", targetPlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])

									if interiorType == 0 or interiorType == 1 then
										outputChatBox("You've successfully sold your property to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
										outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " sold you this property.", targetPlayer, 0, 255, 0)
									else
										outputChatBox(targetPlayerName .. " has taken over your rent contract.", thePlayer, 0, 255, 0)
										outputChatBox("You did take over " .. getPlayerName(thePlayer):gsub("_", " ") .. "'s renting contract.",  targetPlayer, 0, 255, 0)
									end
									exports.logs:dbLog(thePlayer, 37, { targetPlayer, "in"..tostring(dbid) } , "SELLPROPERTY "..getPlayerName(thePlayer).." => "..targetPlayerName)
									local adminID = getElementData(thePlayer, "account:id")
									local addLog = mysql:query_free("INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(dbid).."', '"..commandName.." to "..targetPlayerName.."', '"..adminID.."')") or false
									if not addLog then
										outputDebugString("Failed to add interior logs.")
									end
									realReloadInterior(dbid)
								else
									outputChatBox("Error 09002 - Report on Forums.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox(targetPlayerName .. " has no space for the property keys.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You can't sell your own property to yourself.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("This property is not yours.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("sell", sellTo)

function realReloadInterior(interiorID)
	local dbid, entrance, exit, inttype, interiorElement = exports['interior-system']:findProperty( false, interiorID )
	if dbid > 0 then

		if safeTable[dbid] then
			destroyElement(safeTable[dbid])
			safeTable[dbid] = false
		end	
		triggerClientEvent("deleteInteriorElement", interiorElement, tonumber(dbid))
		destroyElement(interiorElement)
		reloadOneInterior(tonumber(dbid), false)
	else
		--outputChatBox("You suck")
		--outputDebugString("Tried to reload interior without ID.")
	end
end

local stats_numberOfInts = 0

-- CONVERTED
function reloadOneInterior(id)	
	local row = mysql:query_fetch_assoc("SELECT * FROM `interiors` LEFT JOIN `interior_business` ON `interiors`.`id` = `interior_business`.`intID` WHERE `id` = '" .. id .."' AND `deleted` = '0'")
	if row then
		for k, v in pairs( row ) do
			if v == null then
				row[k] = nil
			else
				row[k] = tonumber(v) or v
			end
		end
		
		local interiorElement = createElement("interior", "int"..tostring(row.id))
		setElementDataEx(interiorElement, "dbid", 	row.id, true)
		setElementDataEx(interiorElement, "entrance", {	row.x, row.y, row.z, row.interiorwithin, row.dimensionwithin, row.angle, 0 }, true)
		setElementDataEx(interiorElement, "exit", {row.interiorx, row.interiory, row.interiorz,	row.interior, row.id, row.angleexit, 0	}, true	)
		setElementDataEx(interiorElement, "status",  {	row.type,	row.disabled == 1, 	row.locked == 1, row.owner,		row.cost,	row.supplies}, true	)
		setElementDataEx(interiorElement, "name", row.name, true	)
		setElementDataEx(interiorElement, "adminnote", string.sub(tostring(row.adminnote),1,100) , true	)
		--Factory Information
		local factoryCheck = mysql:query_fetch_assoc("SELECT * FROM `factories` WHERE `INT_ID` = "..row.id)
		if factoryCheck then
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory", factoryCheck["ID"])
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:type", factoryCheck["Type"])
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:max", factoryCheck["Max_Supplies"])
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:curr", factoryCheck["Curr_Supplies"])
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:factsion", factoryCheck["Authorized_Faction"])
			--Check pickup status
			if tonumber(factoryCheck["Order_Claimed"]) == 1 then
				exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:order", factoryCheck["Ordered_Supplies"])
				exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:date", factoryCheck["Date_Of_Arrival"])
			else
				exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:order", false)
				exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory:date", false)
			end
		else
			exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "factory", false)
		end
		mysql:free_result(factoryCheck)
		if row.safepositionX and row.safepositionY and row.safepositionZ ~= mysql_null() and row.safepositionRZ then
			setElementDataEx(interiorElement, "safe", {row.safepositionX, row.safepositionY, row.safepositionZ, 0, 0, row.safepositionRZ}, false)
			
			local tempobject = createObject(2332, row.safepositionX,  row.safepositionY, row.safepositionZ, 0, 0, row.safepositionRZ)
			setElementInterior(tempobject, row.interior)
			setElementDimension(tempobject, row.id)
			safeTable[row.id] = tempobject
		else
			setElementDataEx(interiorElement, "safe", false, true)
		end
		
		if row.businessNote then
			setElementDataEx(interiorElement, "business:note", 	row.businessNote , true)
		end
		-- outputDebugString( "[INTERIOR] LOADED INT #" .. id.." ("..row.name..")" )
		return true
	else
		outputDebugString( "[INTERIOR] LOADING FAILED Invalid Int #" .. id )
		return false
	end
end

function loadAllInteriors()
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
	end
	local timerDelay = 100
	local result = mysql:query("SELECT `id` FROM `interiors` WHERE `deleted` = '0'")
	if (result) then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			setTimer(reloadOneInterior, timerDelay, 1, row.id)
			timerDelay = timerDelay + 100
			stats_numberOfInts = stats_numberOfInts + 1
		end
		mysql:free_result(result)
		setTimer(function () 
			triggerClientEvent("interior:showLoadingProgress" ,getRootElement(), stats_numberOfInts, timerDelay) 
		end, 5000, 1)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadAllInteriors)

function buyInterior(player, pickup, cost, isHouse, isRentable)
	if isRentable then
		local result = mysql:query_fetch_assoc( "SELECT COUNT(*) as 'cntval' FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" )
		if result then
			local count = tonumber(result['cntval'])
			if count ~= 0 then
				outputChatBox("You are already renting another house.", player, 255, 0, 0)
				return
			end
		end
	elseif not exports.global:hasSpaceForItem(player, 4, 1) then
		outputChatBox("You do not have the space for the keys.", player, 255, 0, 0)
		return
	end
	
	if exports.global:takeMoney(player, cost) then
		if (isHouse) then
			outputChatBox("Congratulations! You have just bought this house for $" .. exports.global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.global:giveMoney( getTeamFromName("Government of Los Santos"), cost )
		elseif (isRentable) then
			outputChatBox("Congratulations! You are now renting this property for $" .. exports.global:formatMoney(cost) .. ".", player, 255, 194, 14)
		else
			outputChatBox("Congratulations! You have just bought this business for $" .. exports.global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.global:giveMoney( getTeamFromName("Government of Los Santos"), cost )
		end
		
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		mysql:query_free( "UPDATE interiors SET owner='" .. charid .. "', locked=0 WHERE id='" .. pickupid .. "'") 
		
		local interiorEntrance = getElementData(pickup, "entrance")
		
		-- make sure it's an unqiue key
		call( getResourceFromName( "item-system" ), "deleteAll", 4, pickupid )
		call( getResourceFromName( "item-system" ), "deleteAll", 5, pickupid )
		
		if (isHouse) or (isRentable) then
			exports.global:giveItem(player, 4, pickupid)
		else
			exports.global:giveItem(player, 5, pickupid)
		end
		exports.logs:dbLog(thePlayer, 37, { "in"..tostring(pickupid) } , "BUYPROPERTY $"..cost)
		realReloadInterior(tonumber(pickupid))
		triggerClientEvent(player, "createBlipAtXY", player, interiorEntrance[INTERIOR_TYPE], interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y])
	else
		outputChatBox("Sorry, you cannot afford to purchase this property.", player, 255, 194, 14)
	end
end

function vehicleStartEnter(thePlayer) -- Fix for interior bug (Bean)
	local marker = getElementData(thePlayer, "interiormarker")
	local x, y, z = getElementPosition(thePlayer)
	if marker then
		for key, value in ipairs(getElementsByType("pickup")) do
			vx, vy, vz = getElementPosition(value)
			if (getDistanceBetweenPoints3D(x, y, z, vx, vy, xz) < 4) then
				foundMarker = false
			else
				foundMarker = true
				break
			end
		end
		if foundMarker then
			cancelEvent()
		else
			removeElementData(thePlayer, "interiormarker")
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), vehicleStartEnter)
addEventHandler("onVehicleStartExit", getRootElement(), vehicleStartEnter)
 

function enterInterior(  )
	if source and client then
		local canEnter, errorCode, errorMsg = canEnterInterior(source)	-- Checks for disabled and locked ints.
		if canEnter then
			setPlayerInsideInterior( source, client )
		elseif isInteriorForSale(source) then
			local interiorStatus = getElementData(source, "status")
			local cost = interiorStatus[INTERIOR_COST]
			local isHouse = interiorStatus[INTERIOR_TYPE] == 0
			local isRentable = interiorStatus[INTERIOR_TYPE] == 3
			buyInterior(client, source, cost, isHouse, isRentable)
		else
			outputChatBox(errorMsg, client, 255, 0, 0)
		end
	end
end
addEvent("interior:enter", true)
addEventHandler("interior:enter", getRootElement(), enterInterior)

-- NOT CONVERTED 
function setPlayerInsideInterior(theInterior, thePlayer)
	local teleportTo = nil
	-- does the player want to go in?
	local pedCurrentDimension = getElementDimension( thePlayer )
	local interiorEntrance = getElementData(theInterior, "entrance")
	local interiorExit = getElementData(theInterior, "exit")
	local interiorStatus = getElementData(theInterior, "status")
	if (interiorEntrance[INTERIOR_DIM] == pedCurrentDimension) then
		--[[ We want to go inside, Check for a fee ***REMOVED.***
		if getElementData( thePlayer, "adminduty" ) ~= 1 and not exports.global:hasItem( thePlayer, 5, getElementData( theInterior, "dbid" ) ) and not (getElementData(thePlayer,"ESbadge")) and not (getElementData(thePlayer,"PDbadge"))and not (getElementData(thePlayer,"SheriffBadge")) and not (getElementData(thePlayer,"GOVbadge")) and not (getElementData(thePlayer,"SANbadge")) then
			local fee = interiorEntrance[INTERIOR_FEE]
			if fee and fee > 0 then
				if not exports.global:takeMoney( thePlayer, fee ) then
					outputChatBox( "You don't have enough money with you to enter this interior.", thePlayer, 255, 0, 0 )
					return
				else
					local ownerid = interiorStatus[INTERIOR_OWNER]
					local query = mysql:query_free( "UPDATE characters SET bankmoney = bankmoney + " .. fee .. " WHERE id = " .. ownerid )
					if query then
						for k, v in pairs( getElementsByType( "player" ) ) do
							if isElement( v ) then
								if getElementData( v, "dbid" ) == ownerid then
									exports['anticheat-system']:changeProtectedElementDataEx( v, "businessprofit", getElementData( v, "businessprofit" ) + fee, false )
									break
								end
							end
						end
					else
						outputChatBox( "Error 100.6 - Report on Forums.", thePlayer, 255, 0, 0 )
					end
				end
			end
		end]]
		-- We've passed the feecheck, yet we still want to go inside.
		teleportTo = interiorExit
	else
		-- We'd like to leave this building, kthxhopefullybye.
		if (getElementData(thePlayer, "snake")==true) then
			return
		end
		teleportTo = interiorEntrance
	end
	
	if teleportTo then 
		triggerClientEvent(thePlayer, "setPlayerInsideInterior", theInterior, teleportTo, theInterior)
		doorGoThru(theInterior)
		local dbid = getElementData(theInterior, "dbid") 
		mysql:query_free("UPDATE `interiors` SET `lastused`=NOW() WHERE `id`='" .. mysql:escape_string(dbid) .. "'")
	end
end

--[[ SAFES ]]
function addSafeAtPosition( thePlayer, x, y, z, rotz )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if dbid == 0 then
		return 2
	elseif dbid >= 20000 then -- Vehicle Interiors
		local vid = dbid - 20000
		if exports['vehicle-system']:getSafe( vid ) then
			outputChatBox("There is already a safe in this property. Type /movesafe to move it.", thePlayer, 255, 0, 0)
			return 1
		elseif exports.global:hasItem( thePlayer, 3, vid ) then
			z = z - 0.5
			rotz = rotz + 180
			if exports.mysql:query_free( "UPDATE vehicles SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. vid .. "'") then
				if exports['vehicle-system']:addSafe( vid, x, y, z, rotz, interior ) then
					return 0
				end
			end
			return 1
		end
	elseif dbid >= 19000 then -- temp vehicle interiors
		return 2
	elseif ((exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) then
		if safeTable[dbid] then
			outputChatBox("There is already a safe in this property. Type /movesafe to move it.", thePlayer, 255, 0, 0)
			return 1
		else
			z = z - 0.5
			rotz = rotz + 180
			mysql:query_free( "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'")
			local tempobject = createObject(2332, x, y, z, 0, 0, rotz)
			setElementInterior(tempobject, interior)
			setElementDimension(tempobject, dbid)
			safeTable[dbid] = tempobject
			call( getResourceFromName( "item-system" ), "clearItems", tempobject )
			return 0
		end
	end
	return 3
end
function moveSafe ( thePlayer, commandName )
	local x,y,z = getElementPosition( thePlayer )
	local rotz = getPedRotation( thePlayer )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if (dbid < 19000 and (exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) or (dbid >= 20000 and exports.global:hasItem(thePlayer, 3, dbid - 20000)) then
		z = z - 0.5
		rotz = rotz + 180
		if dbid >= 20000 and exports['vehicle-system']:getSafe(dbid-20000) then
			local safe = exports['vehicle-system']:getSafe(dbid-20000)
			exports.mysql:query_free("UPDATE vehicles SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. (dbid-20000) .. "'")
			setElementPosition(safe, x, y, z)
			setObjectRotation(safe, 0, 0, rotz)
		elseif dbid > 0 and safeTable[dbid] then
			local safe = safeTable[dbid]
			exports.mysql:query_free("UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
			setElementPosition(safe, x, y, z)
			setObjectRotation(safe, 0, 0, rotz)
		else
			outputChatBox("You need a safe to move!", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("You need the keys of this interior to move the Safe.", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("movesafe", moveSafe)


local function hasKey( source, key )
	if exports.global:hasItem(source, 4, key) or exports.global:hasItem(source, 5,key) then
		return true, false
	else
		if getElementData(source, "adminduty") == 1 then
			return true, true
		else
			return false, false
		end
	end
	return false, false
end


function lockUnlockHouseEvent(player, checkdistance)
	if (player) then
		source = player
	end
	local itemValue = nil
	local found = nil
	local foundpoint = nil
	local minDistance = 5
	local interiorName = ""
	local pPosX, pPosY, pPosZ = getElementPosition(source)
	local dimension = getElementDimension(source)
	
	local canEnter, byAdmin = nil
	
	local possibleInteriors = getElementsByType("interior")
	for _, interior in ipairs(possibleInteriors) do
		local interiorEntrance = getElementData(interior, "entrance")
		local interiorExit = getElementData(interior, "exit")
		for _, point in ipairs( { interiorEntrance, interiorExit } ) do
			if (point[INTERIOR_DIM] == dimension) then
				
				
				local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
				if (distance < minDistance) then
					local interiorID = getElementData(interior, "dbid")
					canEnter, byAdmin = hasKey(source, interiorID)
					if canEnter then -- house found
						found = interior
						foundpoint = point
						itemValue = interiorID
						minDistance = distance
						interiorName = getElementData(interior, "name")
					end
				end
			end
		end
	end

	-- For elevators already
	local possibleElevators = getElementsByType("elevator")
	for _, elevator in ipairs(possibleElevators) do
		local elevatorEntrance = getElementData(elevator, "entrance")
		local elevatorExit = getElementData(elevator, "exit")
		
		for _, point in ipairs( { elevatorEntrance, elevatorExit } ) do
			if (point[INTERIOR_DIM] == dimension) then
				local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
				if (distance < minDistance) then
					if hasKey(source, elevatorEntrance[INTERIOR_DIM]) and elevatorEntrance[INTERIOR_DIM] ~= 0 then
						found = elevator
						foundpoint = point
						itemValue = elevatorEntrance[INTERIOR_DIM]
						minDistance = distance
					elseif hasKey(source, elevatorExit[INTERIOR_DIM]) and elevatorExit[INTERIOR_DIM] ~= 0  then
						found = elevator
						foundpoint = point
						itemValue = elevatorExit[INTERIOR_DIM]
						minDistance = distance
					end
				end
			end
		end
	end
	
	if (checkdistance) then
		return found, minDistance
	end
	if found and itemValue then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( source, itemValue )
		local interiorStatus = getElementData(interiorElement, "status")
		local locked = interiorStatus[INTERIOR_LOCKED] and 1 or 0

		locked = 1 - locked -- Invert status
		
		
		local newRealLockedValue = false
		mysql:query_free("UPDATE interiors SET locked='" .. mysql:escape_string(locked) .. "' WHERE id='" .. mysql:escape_string(itemValue) .. "' LIMIT 1") 
		if locked == 0 then
			doorUnlockSound(interiorElement)
			if byAdmin then
				if getElementData(source, "hiddenadmin") == 0 then
					local adminTitle = exports.global:getPlayerAdminTitle(source)
					local adminUsername = getElementData(source, "account:username")
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has unlocked Interior ID #"..itemValue.." without key.")
					exports.global:sendLocalText(source, " * The door should be now open *", 255, 51, 102, 30, {}, true)
					exports["interior-manager"]:addInteriorLogs(itemValue, "unlock without key", source)
				end
			else
				exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
			end
			exports.logs:dbLog(source, 31, {  "in"..tostring(itemValue) }, "UNLOCK INTERIOR")
		else --shit
			doorLockSound(interiorElement)
			newRealLockedValue = true
			if byAdmin then
				local adminTitle = exports.global:getPlayerAdminTitle(source)
				local adminUsername = getElementData(source, "account:username")
				exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has locked Interior ID #"..itemValue.." without key.")
				exports.global:sendLocalText(source, " * The door should be now locked *", 255, 51, 102, 30, {}, true)
				exports["interior-manager"]:addInteriorLogs(itemValue, "lock without key", source)
			else 
				exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
			end
			exports.logs:dbLog(source, 31, {  "in"..tostring(itemValue) }, "LOCK INTERIOR")
		end
		
		interiorStatus[INTERIOR_LOCKED] = newRealLockedValue
		exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)	
	else
		cancelEvent( )
	end
end
addEvent( "lockUnlockHouse",false )
addEventHandler( "lockUnlockHouse", getRootElement(), lockUnlockHouseEvent)

function doorUnlockSound(house)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if isElement(nearbyPlayer) then
					if ((getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorEntrance[INTERIOR_DIM]) or ((getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorExit[INTERIOR_DIM]) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if logged == 1 then
							triggerClientEvent(nearbyPlayer, "doorUnlockSound", source)
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = getElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorUnlockSound", source, found)
		end
	end
end

function doorLockSound(house)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if isElement(nearbyPlayer) then
					if ((getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorEntrance[INTERIOR_DIM]) or ((getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorExit[INTERIOR_DIM]) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if logged == 1 then
							triggerClientEvent(nearbyPlayer, "doorLockSound", source)
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = getElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorLockSound", source, found)
		end
	end
end

function doorGoThru(house)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if isElement(nearbyPlayer) then
					if ((getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorEntrance[INTERIOR_DIM]) or ((getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorExit[INTERIOR_DIM]) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if logged == 1 then
							triggerClientEvent(nearbyPlayer, "doorGoThru", source)
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = getElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorGoThru", source, found)
		end
	end
end

addEvent( "lockUnlockHouseID",true )
addEventHandler( "lockUnlockHouseID", getRootElement(),
	function( id )
		local hasKey1, byAdmin = hasKey(source, id)
		if id and tonumber(id) and hasKey1 then
			local result = mysql:query_fetch_assoc( "SELECT 1-locked as 'val' FROM interiors WHERE id = " .. id)
			local locked = 0
			if result then
				locked = tonumber( result["val"] )
			end
			local newRealLockedValue = false
			mysql:query_free("UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. id .. "' LIMIT 1")
			if locked == 0 then
				if byAdmin then
					local adminTitle = exports.global:getPlayerAdminTitle(source)
					local adminUsername = getElementData(source, "account:username")
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has unlocked Interior ID #"..id.." without key.")
					exports.global:sendLocalText(source, " * The door should be now open *", 255, 51, 102, 30, {}, true)
					exports["interior-manager"]:addInteriorLogs(id, "unlock without key", source)
				else
					exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
				end
				exports.logs:dbLog(source, 31, {  "in"..tostring(id) }, "UNLOCK INTERIOR")
			else
				newRealLockedValue = true
				if byAdmin then
					local adminTitle = exports.global:getPlayerAdminTitle(source)
					local adminUsername = getElementData(source, "account:username")
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has locked Interior ID #"..id.." without key.")
					exports.global:sendLocalText(source, " * The door should be now closed *", 255, 51, 102, 30, {}, true)
					exports["interior-manager"]:addInteriorLogs(id, "lock without key", source)
				else
					exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
				end
				exports.logs:dbLog(source, 31, {  "in"..tostring(id) }, "LOCK INTERIOR")
			end

			local dbid, entrance, exit, interiorType, interiorElement = findProperty( source, id )
			if interiorElement then
				local interiorStatus = getElementData(interiorElement, "status")
				interiorStatus[INTERIOR_LOCKED] = newRealLockedValue
				exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
			end
		else
			cancelEvent( )
		end
	end
)


function findParent( element, dimension )
	local dbid, entrance, exit, type, interiorElement = findProperty( element, dimension )
	return interiorElement
end

addEventHandler("onPlayerInteriorChange", getRootElement( ),
	function( a, b, toDimension, toInterior)	
		if toDimension then
			setElementDimension(source, toDimension)
		end
		if toInterior then
			setElementInterior(source, toInterior)
		end
		local vehicle = getPedOccupiedVehicle( source )
		if not vehicle then
			--setPedGravity(source, 0)
		end
	end
)

function playerKnocking(house)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if isElement(nearbyPlayer) then
					if ((getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorEntrance[INTERIOR_DIM]) or ((getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], getElementPosition(nearbyPlayer)) < 20) and getElementDimension(nearbyPlayer) == interiorExit[INTERIOR_DIM]) then
						local logged = getElementData(nearbyPlayer, "loggedin")
						if logged == 1 then
							triggerClientEvent(nearbyPlayer, "playerKnock", source)
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = getElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("onKnocking", source, found)
		end
	end
end
addEvent("onKnocking", true)
addEventHandler("onKnocking", getRootElement(), playerKnocking)

function client_requestHUDinfo()
	-- Client = client
	-- Source = interior element
	if not isElement(source) or (getElementType(source) ~= "interior" and getElementType(source) ~= "elevator") then
		return
	end
	exports['anticheat-system']:changeProtectedElementDataEx( client, "interiormarker", true, false, false )
	
	local interiorID, interiorName, interiorStatus, interiorEntrance, interiorExit = nil
	if getElementType(source) == "elevator" then
		local playerDimension = getElementDimension(client)
		local elevatorEntranceDimension = getElementData(source, "entrance")[INTERIOR_DIM]
		local elevatorExitDimension = getElementData(source, "exit")[INTERIOR_DIM]
		if playerDimension ~= elevatorEntranceDimension and elevatorEntranceDimension ~= 0 then
			local dbid, entrance, exit, type, interiorElement = findProperty( client, elevatorEntranceDimension )
			if dbid and interiorElement then
				interiorID = getElementData(interiorElement, "dbid")
				interiorName = getElementData(interiorElement,"name")
				interiorStatus = getElementData(interiorElement, "status")
				interiorEntrance = getElementData(interiorElement, "entrance")
				interiorExit = getElementData(interiorElement, "exit")
			end
		elseif elevatorExitDimension ~= 0 then
			local dbid, entrance, exit, type, interiorElement = findProperty( client, elevatorExitDimension )
			if dbid and interiorElement then
				interiorID = getElementData(interiorElement, "dbid")
				interiorName = getElementData(interiorElement,"name")
				interiorStatus = getElementData(interiorElement, "status")
				interiorEntrance = getElementData(interiorElement, "entrance")
				interiorExit = getElementData(interiorElement, "exit")
			end
		end
		if not dbid then
			interiorID = -1
			interiorName = "None"
			interiorStatus = { }
			interiorEntrance = { }
			interiorStatus[INTERIOR_TYPE] = 2
			interiorStatus[INTERIOR_COST] = 0
			interiorStatus[INTERIOR_OWNER] = -1
			interiorEntrance[INTERIOR_FEE] = 0
		end
	else
		interiorName = getElementData(source,"name")
		interiorStatus = getElementData(source, "status")
		interiorEntrance = getElementData(source, "entrance")
		interiorExit = getElementData(source, "exit")
	end
	
	local interiorOwnerName = exports['cache']:getCharacterName(interiorStatus[INTERIOR_OWNER]) or "None"
	local interiorType = interiorStatus[INTERIOR_TYPE] or 2
	local interiorCost = interiorStatus[INTERIOR_COST] or 0
	local interiorBizNote = getElementData(source, "business:note") or false
		
	
	triggerClientEvent(client, "displayInteriorName", source, interiorName or "Elevator", interiorOwnerName, interiorType or 2, interiorCost or 0, interiorID or -1, interiorBizNote)
end
addEvent("interior:requestHUD", true)
addEventHandler("interior:requestHUD", getRootElement(), client_requestHUDinfo)

addEvent("int:updatemarker", true)
addEventHandler("int:updatemarker", getRootElement(), 
	function( newState )
		exports['anticheat-system']:changeProtectedElementDataEx(client, "interiormarker", newState, false, true) -- No sync at all: function is only called from client thusfar has the actual state itself
	end
)



--INTERIOR LIGHT BY MAXIME
--[[function toggleInteriorLights(thePlayer, commandName)
	local playerInterior = getElementInterior(thePlayer)
	if (playerInterior==0) then
		outputChatBox("There is no light out here.", thePlayer, 255, 0, 0)
	else
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			if getElementData(interior, "dbid") == playerInterior then
				if getElementData(interior, "isLightOn") then
					setElementDataEx(interior, "isLightOn", false, true	) 
					updateLight(false, playerInterior)
					exports.global:sendLocalText(thePlayer, "*"..getPlayerName(thePlayer):gsub("_", " ").." turns off the lights.", 255, 51, 102, 30, {}, true) 
					local mQuery1 = mysql:query_free("UPDATE `interiors` SET `isLightOn` = '0' WHERE `id` = '"..tostring(playerInterior).."'")
					if not mQuery1 then outputDebugString("[SQL] Failed to update interior light status") end
					break	
				else
					setElementDataEx(interior, "isLightOn", true, true	) 
					updateLight(true, playerInterior)
					exports.global:sendLocalText(thePlayer, "*"..getPlayerName(thePlayer):gsub("_", " ").." turns on the lights.", 255, 51, 102, 30, {}, true)
					local mQuery1 = mysql:query_free("UPDATE `interiors` SET `isLightOn` = '1' WHERE `id` = '"..tostring(playerInterior).."'")
					if not mQuery1 then outputDebugString("[SQL] Failed to update interior light status") end
					break
				end
			end
		end
	end
end
addCommandHandler("toglight", toggleInteriorLights)
addCommandHandler("togglelight", toggleInteriorLights)

function updateLight(status, playerInterior)
	local possiblePlayers = getElementsByType("player")
	for _, player in ipairs(possiblePlayers) do
		if getElementInterior(player) == playerInterior then
			triggerClientEvent ( player, "updateLightStatus", player, status ) 
		end
	end
end
addEvent("setInteriorLight", true)
addEventHandler("setInteriorLight", getRootElement(), updateLight)
]]

