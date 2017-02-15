local function canAccessElement( player, element )
	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function output(from, to, itemID, itemValue)
	--outputDebugString("item-system\s_move_items.lua\output To: ".. getElementType(to) .. " From: ".. getElementType(to) )
	-- player to player
	if from ~= to and getElementType(from) == "player" and getElementType(to) == "player" then
		exports.global:sendLocalMeAction( from, "gives " .. getPlayerName( to ):gsub("_", " ") .. " a " .. getItemName( itemID, itemValue ) .. "." )
	-- player to item
	elseif from ~= to and getElementType(from) == "player" then
		local name = getElementModel( to ) == 2147 and "fridge" or getElementModel(to) == 3761 and "shelf" or ( getElementType( to ) == "vehicle" and "vehicle" or ( getElementType( to ) == "player" and "player" or "safe" ) )
		if itemID == 134 then
			exports.global:sendLocalMeAction( from, "puts $" .. exports.global:formatMoney(itemValue) .. " inside the ".. name .."." )
		else
			exports.global:sendLocalMeAction( from, "puts a " .. getItemName( itemID, itemValue ) .. " inside the ".. name .."." )
		end
	-- item to player
	elseif from ~= to and getElementType(to) == "player" then
		local name = getElementModel( from ) == 2147 and "fridge" or getElementModel(from) == 3761 and "shelf" or ( getElementType( from ) == "vehicle" and "vehicle" or ( getElementType( from ) == "player" and "player" or "safe" ) )
		if itemID == 134 then
			exports.global:sendLocalMeAction( to, "takes $" .. exports.global:formatMoney(itemValue) .. " from the ".. name .."." )
		else
			exports.global:sendLocalMeAction( to, "takes a " .. getItemName( itemID, itemValue ) .. " from the ".. name .."." )
		end
	end
end
function x_output_wrapper( ... ) return output( ... ) end

--

local function moveToElement( element, slot, ammo, event )
	if not canAccessElement( source, element ) then
		outputChatBox("You cannot access this inventory at the moment.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end 
	
	local name = getElementModel( element ) == 2147 and "fridge" or getElementModel(source) == 3761 and "shelf" or ( getElementType( element ) == "vehicle" and "vehicle" or ( getElementType( element ) == "player" and "player" or "safe" ) )
			
	if not ammo then  
		local item = getItems( source )[ slot ]
		if item then
				if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
					if item[1] == 121 and not getElementData(element,"customshop") then-- supplies box
						triggerEvent("shop:handleSupplies", source, element, slot, event)
						return true
					end 
					if getElementData(element,"customshop") then
						if item[1] == 134 then -- money
							triggerClientEvent( source, event or "finishItemMove", source )
							return false
						end
						triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
						return true
					end
					return false
					--triggerClientEvent( source, event or "finishItemMove", source )
				end
				
			if not hasSpaceForItem( element, item[1], item[2] ) then
				outputChatBox( "The inventory is full.", source, 255, 0, 0 )
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
						outputChatBox("You can't put your duty weapon in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 116) then -- Ammo
					local ammoDetails = exports.global:explode( ":", item[2]  )
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then -- /duty
						outputChatBox("You can't put your duty ammo in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				end
				
				if (string.find(item[2], "(D)")) and not (item[1]==72) then -- Just in case a goober made a note. *shrug*
					outputChatBox("You can't drop your duty items.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				end
				
				if (item[1] == 137) then -- Snake cam
					outputChatBox("You cannot move this item.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				end
				
				if (item[1] == 134) then
					local hoursPlayed = getElementData( source, "hoursplayed" )
					--outputDebugString("Check")
					if hoursPlayed < 10 then
						outputChatBox("You require 10 hours of playing time to drop money.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				end
				
				if item[1] == 138 then
					if not exports.global:isPlayerLeadAdmin(source) then
						outputChatBox("Only a Lead+ admin can move this item.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				end
				
				if item[1] == 139 then
					if not exports.global:isPlayerSuperAdmin(source) then
						outputChatBox("Only a Super+ administrator can move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end
				
				if (item[1] == 134) then -- Money
					if (getElementType(element) == "player") and (getElementType(source) == "player") then
						exports.global:sendLocalMeAction(source, "hands " .. getPlayerName( element ):gsub("_", " ") .. " $" .. exports.global:formatMoney(item[2]) .. "." )
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. "hands " .. getPlayerName( element ):gsub("_", " ") .. " $" .. exports.global:formatMoney(item[2]) .. "." )
						exports.global:takeMoney(source, tonumber(item[2]))
						exports.global:giveMoney(element, tonumber(item[2]))
					elseif (getElementType(element) == "vehicle") and (getElementType(source) == "player") then
						exports.global:sendLocalMeAction(source, "puts $" .. exports.global:formatMoney(item[2]) .. " inside the ".. name .."." ) -- temp fix
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - Money - " .. exports.global:formatMoney(item[2]), 17) -- Added by le bean, the damn money wasn't being logged you narbs.
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " puts $" .. exports.global:formatMoney(item[2]) .. " inside the ".. getElementType(element) .."." )
						exports.global:takeMoney(source, tonumber(item[2]))
						exports.global:giveItem(element, 134, tonumber(item[2]))
					elseif (getElementType(element) == "object") and (getElementType(source) == "player") then
						exports.global:sendLocalMeAction(source, "puts $" .. exports.global:formatMoney(item[2]) .. " inside the ".. name .."." ) -- temp fix
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved $" .. exports.global:formatMoney(item[2]) )
						exports.global:takeMoney(source, tonumber(item[2]))
						exports.global:giveItem(element, 134, tonumber(item[2]))
					end
				else
			
					if getElementType( element ) == "object" then -- safe
						if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
							if countItems( source, item[1], item[2] ) < 2 then
								outputChatBox("You can't place your only key to that safe in the safe.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return
							end
						end
					end
				
					local success, reason = moveItem( source, element, slot )
					if not success then
						outputDebugString( "Item Moving failed: " .. tostring( reason ))
					else
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
						exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
						doItemGiveawayChecks( source, item[1] )
						output(source, element, item[1], item[2])
					end
				end
			end
		end
	else
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("You can't put your weapons in a " .. name .. " while being on duty.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("You can't put this spray can into a " .. name .. ".", source, 255, 0, 0)
			else
				if slot == -100 then 	
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.global:sendMessageToAdmins("[items\moveToElement] Possible duplication of gun from '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo .. " BLOCKED DUE POSSIBLE DUPING", 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " -  #" .. getElementID(element) .. " - BLOCKED DUE POSSIBLE DUPING" )
						return
					end
					exports.global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -slot)
					end
				end
			end
		end
	end
	triggerClientEvent( source, event or "finishItemMove", source )
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end
	
	local id = getElementData( item, "id" )
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
		-- BUGGED
		-- if id == 121 and not getElementData(element, "customshop") then -- supplies box
			-- triggerEvent("shop:handleSupplies", source, element, -1 , nil , item) --"worldItemMoveFinished", item)
			-- return true
		-- elseif getElementData(element, "customshop") then 
			-- if id == 138 then -- money
				-- return false
			-- end
			-- triggerEvent("shop:addItemToCustomShop", source, element, -1 , nil , item)--"worldItemMoveFinished", item)
			-- return true
		-- end 
		-- return false
	end
	
	
	local name = getElementModel( element ) == 2147 and "Fridge" or getElementModel(source) == 3761 and "Shelf" or ( getElementType( element ) == "vehicle" and "Vehicle" or ( getElementType( element ) == "player" and "Player " .. getPlayerName( element )  or "Safe" ) )
	
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	if (itemID == 134) and (getElementType(element) == "player") then
		outputChatBox("No don't.", source, 255, 0, 0)
		return
	end
	
	if itemID == 138 then
		if not exports.global:isPlayerLeadAdmin(source) then
			outputChatBox("Only a Lead+ admin can move this item.", source, 255, 0, 0)
			return
		end
	end
	
	if giveItem( element, itemID, itemValue ) then
		output(source, element, itemID, itemValue)
		--exports.logs:logMessage( getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element), 17)
		exports.logs:dbLog( source, 39, source, getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element))
		mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
		
		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )
	else
		outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if not canAccessElement( source, element ) then
		return
	end
	
	local name = getElementModel( element ) == 2147 and "Fridge" or getElementModel(source) == 3761 and "Shelf" or ( getElementType( element ) == "vehicle" and "Vehicle" or "Safe" )
	
	local item = getItems( element )[slot]
	if item and item[3] == index then
		if not exports.global:isPlayerAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117) then
			outputChatBox( "Please contact an admin via F2 to move this item.", source, 255, 0, 0 )
		elseif not exports.global:isPlayerLeadAdmin(source) and (item[1] == 138) then
			outputChatBox("Only a Lead+ admin can move this item.", source, 255, 0, 0)
		elseif not exports.global:isPlayerSuperAdmin(source) and (item[1] == 139) then
			outputChatBox("A Super+ administrator can move this item.", source, 255, 0, 0)
		elseif item[1] > 0 then			
			output( element, source, item[1], item[2])
			moveItem( element, source, slot )
			--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
			exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
			-- Money
			if item[1] == 134 then	
				exports.global:giveMoney(source, item[2])
			end
			
		elseif item[1] == -100 then
			local armor = math.max( 0, ( ( getElementData( source, "faction" ) == 1 or ( getElementData( source, "faction" ) == 3 and ( getElementData( source, "factionrank" ) == 4 or getElementData( source, "factionrank" ) == 5 or getElementData( source, "factionrank" ) == 13 ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )
			
			if armor == 0 then
				outputChatBox( "You can't wear any more armor.", source, 255, 0, 0 )
			else
				output( element, source, item[1])
				takeItemFromSlot( element, slot )
				
				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end
				
				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ))
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1])
			if ammo < item[2] then
				exports.global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ))
			else
				exports.global:giveWeapon( source, -item[1], item[2] )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
				exports.logs:dbLog(source, 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	elseif item then
		outputDebugString( "Index mismatch: " .. tostring( item[3] ) .. " " .. tostring( index ) )
	end
	triggerClientEvent( source, "finishItemMove", source )
end

addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )
