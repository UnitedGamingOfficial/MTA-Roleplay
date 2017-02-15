
function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					outputChatBox("   #" .. dbid .. (getElementData(theObject, "protected") and ("(" .. getElementData(theObject, "protected").. ")") or "") .. " by " .. ( exports['cache']:getCharacterName( getElementData(theObject, "creator"), true ) or "?" ) .. " - " .. ( getItemName( getElementData(theObject, "itemID") ) or "?" ) .. "(" .. getElementData(theObject, "itemID") .. "): " .. tostring( getElementData(theObject, "itemValue") or 1 ), thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyitems", getNearbyItems, false, false)

function delItem(thePlayer, commandName, targetID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
			targetID = tonumber( targetID )
			
			for key, value in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
				local dbid = getElementData(value, "id")
				if dbid and dbid == targetID then
					object = value
					break
				end
			end
			
			if object then
				local id = getElementData(object, "id")
				local result = mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
						
				outputChatBox("Item #" .. id .. " deleted.", thePlayer)
				destroyElement(object)
			else
				outputChatBox("Invalid item ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delitem", delItem, false, false)

function delNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					local id = getElementData(theObject, "id")
					mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
					destroyElement(theObject)
					count = count + 1
				end
			end
		end
		
		outputChatBox( count .. " Items deleted.", thePlayer, 255, 126, 0)
	end
end
addCommandHandler("delnearbyitems", delNearbyItems, false, false)

function delAllItemInstances(thePlayer,commandName, itemID, itemValue )
	if exports.global:isPlayerHeadAdmin( thePlayer ) then
		if not tonumber(itemID) or tonumber(itemID)%1 ~=0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Item ID] [Item Value]", thePlayer, 255, 194, 14 )
			outputChatBox( "Deletes all the item instances from everywhere in game.", thePlayer, 150, 150, 50 )
		else
			local theResource2 = getResourceFromName("item-world")
			if theResource2 and deleteAll( itemID, itemValue ) then
				if not itemValue or itemValue == "" then itemValue = "<Any value>" end
				local theResource1 = getThisResource()
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				restartResource(theResource2)
				setTimer(function () 
					restartResource(theResource1)
					outputChatBox( "All the item instances (Item ID #"..itemID..", ItemValue: "..itemValue..") have been deleted.", thePlayer, 0, 255, 0)
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("AdmWrn: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has deleted all the item instances (Item ID #"..itemID..", ItemValue: "..itemValue..") from everywhere in game.")
					else
						exports.global:sendMessageToAdmins("AdmWrn: A hidden admin has deleted all the item instances (Item ID #"..itemID..", ItemValue: "..itemValue..") from everywhere in game.")
					end
				end, 5000, 1)
			else
				outputChatBox( "Failed to delete all item instances (Item ID #"..itemID..", Value: "..itemValue.."). 'item-world' resource required.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delallitems", delAllItemInstances, false, false)

function deleteAllItemsFromAnInterior(thePlayer, commandName, intID , dayOld, restartRes)
	if exports.global:isPlayerFullAdmin( thePlayer ) then
		if not tonumber(intID) or tonumber(intID) < 0 or tonumber(intID)%1 ~=0 or  not tonumber(dayOld) or tonumber(dayOld) < 0 or tonumber(dayOld)%1 ~=0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Int ID] [Day old of Items]", thePlayer, 255, 194, 14 )
			outputChatBox( "Deletes all the items within a specified interior that older than an interval of item's day old.", thePlayer, 150, 150, 50 )
			if exports.global:isPlayerHeadAdmin( thePlayer ) then
				outputChatBox( "SYNTAX: /" .. commandName .. " [Int ID] [Day old of Items]", thePlayer, 255, 194, 14 )
				outputChatBox( "Deletes all the items within a specified interior or world map that older than an interval of item's day old.", thePlayer, 150, 150, 50 )
			end
		else
			if tonumber(intID) == 0 and not exports.global:isPlayerHeadAdmin( thePlayer ) then
				outputChatBox("Only Head+ Admins can delete all item instances from world map.", thePlayer, 255, 0, 0)
				return false
			end
			
			-- if tonumber(intID) == 0 and exports.global:isPlayerHeadAdmin( thePlayer ) then
				-- restartRes = 1
			-- end
			
			if deleteAllItemsWithinInt(intID, dayOld) then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				outputChatBox( "All the item instances that is older than "..dayOld.." days wthin interior ID #"..intID.." have been deleted.", thePlayer, 0, 255, 0)
				--outputChatBox( " However, the items still exist temporarily in game. It's strongly recommended to lock or delete this interior ASAP after executing this command.", thePlayer, 255, 255, 0)
				if restartRes == 1 and getResourceFromName("item-world") then
					executeCommandHandler("saveall", thePlayer)
					setTimer(function () 
						outputChatBox( " Server is cleaning up world items, please standby!", root)
						restartResource(getResourceFromName("item-world"))
					end, 10000, 1)
				end
				
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmWrn: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has deleted all item instances that is older than "..dayOld.." days within interior ID #"..intID..".")
				else
					exports.global:sendMessageToAdmins("AdmWrn: A hidden admin has deleted all item instances that is older than "..dayOld.." days within interior ID #"..intID..".")
				end
				return true
			else
				outputChatBox( "Failed to delete items within a specified interior ID #"..intID..".", thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addCommandHandler("delitemsfromint", deleteAllItemsFromAnInterior, false, false)