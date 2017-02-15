
function getNearbyInteriors(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Nearby Interiors:", thePlayer, 255, 126, 0)
		local count = 0
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			local interiorEntrance = getElementData(interior, "entrance")
			local interiorExit = getElementData(interior, "exit")
			
			for _, point in ipairs( { interiorEntrance, interiorExit } ) do
				if (point[INTERIOR_DIM] == dimension) then
					local distance = getDistanceBetweenPoints3D(posX, posY, posZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
					if (distance <= 11) then
						local dbid = getElementData(interior, "dbid")
						local interiorName = getElementData(interior, "name")
						outputChatBox(" ID " .. dbid .. ": " .. interiorName, thePlayer, 255, 126, 0)
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
addCommandHandler("nearbyinteriors", getNearbyInteriors, false, false)
addCommandHandler("nearbyints", getNearbyInteriors, false, false)

function delNearbyInteriors(thePlayer, commandName)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Deleting Nearby Interiors:", thePlayer, 255, 126, 0)
		local count = 0
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			local interiorEntrance = getElementData(interior, "entrance")
			local interiorExit = getElementData(interior, "exit")
			
			for _, point in ipairs( { interiorEntrance, interiorExit } ) do
				if (point[INTERIOR_DIM] == dimension) then
					local distance = getDistanceBetweenPoints3D(posX, posY, posZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
					if (distance <= 6) then
						local dbid = getElementData(interior, "dbid")
						local interiorName = getElementData(interior, "name")
						if deleteInterior(thePlayer, "delint" , dbid) then	
							count = count + 1
						end
					end
				end
			end
		end
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
		
		if (count==0) then
			outputChatBox("   None was deleted", thePlayer, 255, 126, 0)
		else
			outputChatBox("   "..count.." interiors have been deleted!", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyinteriors", delNearbyInteriors, false, false)
addCommandHandler("delnearbyints", delNearbyInteriors, false, false)

--Removed for use in Alt-to-Alt and Power Gaming.
--[[function setFee( thePlayer, commandName, theFee )
	if not theFee or not tonumber( theFee ) then
		outputChatBox( "SYNTAX: /" .. commandName .. " [Fee]", thePlayer, 255, 194, 14 )
	else
		local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
		if entrance then
			local interiorEntrance = getElementData(interiorElement, "entrance")
			local interiorStatus = getElementData(interiorElement, "status")
			local interiorName = getElementData(interiorElement, "name")
			local theFee = tonumber( theFee )
			if theFee >= 0 then
				if interiorStatus[INTERIOR_TYPE] == 1 then
					if exports.global:isPlayerAdmin( thePlayer ) or interiorStatus[INTERIOR_OWNER] == getElementData( thePlayer, "dbid" ) then
						
						local canHazFee, intID = false
						if exports.global:isPlayerSuperAdmin( thePlayer ) then
							canHazFee = true
						elseif interiorEntrance[INTERIOR_FEE] then
							canHazFee = true
						end
						
						if canHazFee then
							local query = mysql:query_free("UPDATE interiors SET fee = " .. theFee .. " WHERE id = " .. dbid )
							if query then
								interiorEntrance[INTERIOR_FEE] = theFee
								exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "entrance", interiorEntrance, true)
								outputChatBox( "The entrance fee for '" .. interiorName .. "' is now $" .. exports.global:formatMoney(theFee) .. ".", thePlayer, 0, 255, 0 )
								exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETFEE "..theFee)
								
							else
								outputChatBox( "Error 9017 - Report on Forums.", thePlayer, 255, 0, 0 )
							end
						else
							outputChatBox( "You can't charge a fee for this business. Please consult an admin first.", thePlayer, 255, 0, 0 )
						end
					else
						outputChatBox( "This business is not yours.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "This interior is no business.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You can only use positive values!", thePlayer, 255, 0, 0 )
			end
		else
			outputChatBox( "You are not in an interior!", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "setfee", setFee )]]


function gotoHouse( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
			if entrance then
				if triggerClientEvent(thePlayer, "setPlayerInsideInterior", interiorElement, entrance, interiorElement)	then
					outputChatBox( "Teleported to House #" .. houseID, thePlayer, 0, 255, 0 )
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName, thePlayer)
					
					return true
				else
					return false
				end
			else
				outputChatBox( "Invalid House.", thePlayer, 255, 0, 0 )
				return false
			end
		end
	end
end
addCommandHandler( "gotohouse", gotoHouse )
addCommandHandler( "gotoint", gotoHouse )

function gotoHouseInside( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
			if entrance then
				if triggerClientEvent(thePlayer, "setPlayerInsideInterior", interiorElement, exit, interiorElement) then
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName, thePlayer)
					
					outputChatBox( "Teleported inside House #" .. houseID, thePlayer, 0, 255, 0 )
					return true
				else
					return false
				end
			else
				outputChatBox( "Invalid House.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "gotointi", gotoHouseInside )

function setInteriorID( thePlayer, commandName, interiorID )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local interiors = exports["official-interiors"].getInteriorsList() --/MAXIME
		interiorID = tonumber( interiorID )
		if not interiorID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [interior id] - changes the house interior", thePlayer, 255, 194, 14 )
		elseif not interiors[interiorID] then
			outputChatBox( "Invalid ID.", thePlayer, 255, 0, 0 )
			return false
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				local interior = interiors[interiorID]
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local query = mysql:query_free( "UPDATE interiors SET interior=" .. interiorw .. ", interiorx=" .. ix .. ", interiory=" .. iy .. ", interiorz=" .. iz .. ", angle=" .. optAngle .. " WHERE id=" .. dbid)
				if query then
					--setInteriorObjects(dbid, interiorID)
					--removeInteriorObjects(dbid)
					cleanupProperty( dbid )
					realReloadInterior(dbid)		

					for key, value in pairs( getElementsByType( "player" ) ) do
						if isElement( value ) and getElementDimension( value ) == dbid then
							setElementPosition( value, ix, iy, iz )
							setElementInterior( value, interiorw )
							setCameraInterior( value, interiorw )
						end
					end
					
					outputChatBox( "You have sucessfully changed interior of house #"..dbid.." to ID "..interiorw..".", thePlayer, 0, 255, 0 )
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORID "..interiorID)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username")
					
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has changed interior of house #"..dbid.." to ID "..interiorID..".")
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has changed interior of house #"..dbid.." to ID "..interiorID..".")
					end
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName.." "..interiorID, thePlayer)
					
					return true
				else
					outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
					return false
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
				return false
			end
		end
	end
end
addCommandHandler( "setinteriorid", setInteriorID )
addCommandHandler( "setintid", setInteriorID )

function setInteriorPrice( thePlayer, commandName, cost )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		cost = tonumber( cost )
		if not cost then
			outputChatBox( "SYNTAX: /" .. commandName .. " [price]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
			if exit then
				local query = mysql:query_free("UPDATE interiors SET cost=" .. cost .. " WHERE id=" .. dbid)
				if query then
					local interiorStatus = getElementData(interiorElement, "status")
					interiorStatus[INTERIOR_COST] = cost
					exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
					exports.logs:logMessage("[/SETINTERIORPRICE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." set the interiorprice of ".. dbid .." to ".. cost , 4)
					outputChatBox( "Interior cost is now $" .. exports.global:formatMoney(cost) .. ".", thePlayer, 0, 255, 0 )
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORPRICE "..cost)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					local adminUsername = getElementData(thePlayer, "account:username")
					
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has changed interior price of house #"..dbid.." to $"..cost..".")
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has changed interior price of house #"..dbid.." to $"..cost..".")
					end
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName.." "..tostring(cost), thePlayer)
					
					return true
				else
					outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorprice", setInteriorPrice )
addCommandHandler( "setintprice", setInteriorPrice )

function getInteriorPrice( thePlayer )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
		if exit then
			local interiorStatus = getElementData(interiorElement, "status")
			outputChatBox( "This Interior costs $" .. exports.global:formatMoney(interiorStatus[INTERIOR_COST]) .. ".", thePlayer, 255, 194, 14 )
		else
			outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "getinteriorprice", getInteriorPrice )
addCommandHandler( "getintprice", getInteriorPrice )

function setInteriorType( thePlayer, commandName, type )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		type = math.ceil( tonumber( type ) or -1 )
		if not type or type < 0 or type > 3 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [type (0-3)]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
			if exit then
				if type ~= interiorType then
					local query = mysql:query_free("UPDATE interiors SET type=" .. type .. " WHERE id='" .. mysql:escape_string(dbid) .."'")
					if query then
						local interiorStatus = getElementData(interiorElement, "status")
						interiorStatus[INTERIOR_TYPE] = type
						outputChatBox( "Interior type is now " .. type .. ".", thePlayer, 0, 255, 0 )
						exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORTYPE "..type .. " (was "..interiorType.." / ".. interiorStatus[INTERIOR_OWNER] ..")")
						if type == 2 then
							local query2 = mysql:query_free("UPDATE interiors SET owner=0 WHERE id='" .. mysql:escape_string(dbid) .."'")
							if query2 then
								interiorStatus[INTERIOR_OWNER] = 0
								outputChatBox( "Set the interior type to no-one due interior type 2.", thePlayer, 0, 255, 0 )
							end
						end
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account:username")
						
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has changed interior type of house #"..dbid.." to type "..type..".")
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has changed interior type of house #"..dbid.." to type "..type..".")
						end
						exports['anticheat-system']:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
						
						exports["interior-manager"]:addInteriorLogs(dbid, commandName.." "..tostring(type), thePlayer)
						
						return true
					else
						outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Interior has this type already.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriortype", setInteriorType )
addCommandHandler( "setinttype", setInteriorType )

function getInteriorType( thePlayer )
	if exports.global:isPlayerAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
		if exit then
			outputChatBox( "This Interior's type is " .. interiorType .. ".", thePlayer, 255, 194, 14 )
		else
			outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "getinteriortype", getInteriorType )
addCommandHandler( "getinttype", getInteriorType )

function getInteriorID( thePlayer, commandName )
	local c = 0
	local interior = getElementInterior( thePlayer )
	local x, y, z = getElementPosition( thePlayer )
	local interiors = exports["official-interiors"].getInteriorsList() --/MAXIME
	for k, v in pairs( interiors ) do
		if interior == v[1] and getDistanceBetweenPoints3D( x, y, z, v[2], v[3], v[4] ) < 10 then
			outputChatBox( "Interior ID: " .. k, thePlayer )
			c = c + 1
		end
	end
	if c == 0 then
		outputChatBox( "Interior ID not found.", thePlayer )
	end
end
addCommandHandler( "getinteriorid", getInteriorID )
addCommandHandler( "getintid", getInteriorID )

function toggleInterior( thePlayer, commandName, id )
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		id = tonumber( id )
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, inttype, interiorElement = findProperty( thePlayer, id )
			if entrance then
				local interiorStatus = getElementData(interiorElement, "status")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username")
				
				if interiorStatus[INTERIOR_DISABLED] then
					mysql:query_free("UPDATE interiors SET disabled = 0 WHERE id = " .. dbid ) 
					outputChatBox("Interior "..dbid.." is now enabled", thePlayer)
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has enabled Interior #"..dbid..".")
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has enabled Interior #"..dbid..".")
					end
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName.." on", thePlayer)
				else
					mysql:query_free("UPDATE interiors SET disabled = 1 WHERE id = " .. dbid )
					outputChatBox("Interior "..dbid.." is now disabled", thePlayer)
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").." ("..adminUsername..") has disabled Interior #"..dbid..".")
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has disabled Interior #"..dbid..".")
					end
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName.." off", thePlayer)
				end
				realReloadInterior(dbid)
				exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "TOGGLEINTERIOR "..dbid)
			end
		end
	end
end
addCommandHandler( "toggleinterior", toggleInterior )
addCommandHandler( "togint", toggleInterior )

function reloadInterior(thePlayer, commandName, interiorID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14)
		else
			local dbid, entrance, exit, interiorType = findProperty( thePlayer, tonumber(interiorID) )
			if dbid ~= 0 then			
				realReloadInterior(dbid)
				outputChatBox("Reloaded Interior #" .. dbid, thePlayer, 0, 255, 0)
			else
				if reloadOneInterior(tonumber(interiorID), false) then
					outputChatBox("Loaded Interior #" .. tonumber(interiorID), thePlayer, 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("reloadinterior", reloadInterior, false, false)
addCommandHandler("reloadint", reloadInterior, false, false)

function deleteInterior(thePlayer, commandName, houseID)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		if not showLoadingProgressTimer then	
			houseID = tonumber( houseID )
			if not houseID then
				outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
				return false
			else
				local dbid, entrance, exit = findProperty( thePlayer,  tonumber(houseID) )
				if dbid ~= 0 then
					-- move all players outside
					for key, value in pairs( getElementsByType( "player" ) ) do
						if isElement( value ) and getElementDimension( value ) == dbid then
							setElementInterior( value, entrance[INTERIOR_INT] )
							setCameraInterior( value, entrance[INTERIOR_INT] )
							setElementDimension( value, entrance[INTERIOR_DIM] )
							setElementPosition( value, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z] )
							--exports['anticheat-system']:changeProtectedElementDataEx( value, "interiormarker" )
							exports['anticheat-system']:changeProtectedElementDataEx(value, "interiormarker", false, false, false)
							triggerEvent("onPlayerInteriorChange", value, exit, entrance)
						end
					end
					local adminUsername = getElementData(thePlayer, "account:username")
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					
					local query = mysql:query_free("UPDATE `interiors` SET `deleted` = '"..adminUsername.."' WHERE id='" .. dbid .. "'")
					if (query) then
						setElementData(thePlayer, "mostRecentDeletedInterior", dbid)
						-- destroy the entrance and exit
						realReloadInterior(dbid)
						outputChatBox("[DELINT] Interior #" .. dbid .. " has been deleted!", thePlayer, 0, 255, 0)
						outputChatBox("To restore this interior, do '/restoreint " .. dbid .. "'.", thePlayer, 255, 194, 14 )
						exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "DELETEINTERIOR "..dbid)
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has deleted Interior #"..dbid..".")
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has deleted Interior #"..dbid..".")
						end
						
						exports["interior-manager"]:addInteriorLogs(dbid, commandName, thePlayer)
						
						return true
					else
						outputChatBox("[DELINT] Database Error!", thePlayer, 255, 0, 0)
						return false
					end
				else
					return false
				end
			end
		else
			outputChatBox("Please wait until the interior system loading is done..", thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("delinterior", deleteInterior, false, false)
addCommandHandler("delint", deleteInterior, false, false)

function restoreInt(thePlayer, commandName, houseID)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		if not showLoadingProgressTimer then	
			houseID = tonumber( houseID )
			if not houseID then
				outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
			else
				if houseID ~= 0 then
					local query = mysql:query("SELECT `deleted` FROM interiors WHERE id='" .. houseID .. "'")
					local row = false
					if (query) then
						row = mysql:fetch_assoc(query)
						mysql:free_result(query)
					else
						outputChatBox("[RESTOREINT] Int #"..houseID.." not found in Database!", thePlayer, 255, 0 ,0)
						return
					end
					
					if not row then
						outputChatBox("[RESTOREINT] Int #"..houseID.." not found in Database!", thePlayer, 255, 0 ,0)
						return
					else
						if row["deleted"] == "0" then
							outputChatBox("[RESTOREINT] Interior #"..houseID.." isn't deleted!", thePlayer, 255, 0 ,0)
							return
						end
					end
					
					local query = mysql:query_free("UPDATE `interiors` SET `deleted` = '0' WHERE id='" .. houseID .. "' ")
					if (query) then
						reloadOneInterior(houseID)
						outputChatBox("[RESTOREINT] Interior #" .. houseID .. " has been restored!", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, { "in"..tostring(houseID) } , "RESTOREINT "..houseID)
						local adminUsername = getElementData(thePlayer, "account:username")
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restored Interior #"..houseID..".")
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has restored Interior #"..houseID..".")
						end
						
						exports["interior-manager"]:addInteriorLogs(houseID, commandName, thePlayer)
						
						return true
					else
						outputChatBox("[RESTOREINT] Database Error!", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("Please wait until the interior system loading is done..", thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("restoreint", restoreInt, false, false)
addCommandHandler("restoreinterior", restoreInt, false, false)

function removeInterior(thePlayer, commandName, houseID)
	if exports.global:isPlayerHeadAdmin( thePlayer ) or commandName == "MOVETOLS" then
		if not showLoadingProgressTimer then	
			houseID = tonumber( houseID ) or getElementData(thePlayer, "mostRecentDeletedInterior")
			if not houseID then
				outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
			else
				if houseID ~= 0 then
					if commandName ~= "MOVETOLS" then 
						local query = mysql:query("SELECT `deleted` FROM interiors WHERE id='" .. houseID .. "'")
						local row = false
						if (query) then
							row = mysql:fetch_assoc(query)
							mysql:free_result(query)
						else
							outputChatBox("[REMOVEINT] Int #"..houseID.." not found in Database!", thePlayer, 255, 0 ,0)
							return
						end
						
						if not row then
							outputChatBox("[REMOVEINT] Int #"..houseID.." not found in Database!", thePlayer, 255, 0 ,0)
							return
						else
							if row["deleted"] == "0" then
								outputChatBox("[REMOVEINT] To remove this Interior permanently from Database, please use '/delint "..houseID.."' first.", thePlayer, 255, 0 ,0)
								return
							end
						end
					end
					
					local safe = safeTable[houseID]
					local query = mysql:query_free("DELETE FROM `interiors` WHERE `id`='" .. houseID .. "' ")
					if (query) then
						local safe = safeTable[houseID]
						if safe then
							call( getResourceFromName( "item-system" ), "clearItems", safe )
							destroyElement(safe)
							safeTable[houseID] = nil
						end 
						-- destroy the entrance and exit
						--realReloadInterior(houseID)
						intTable[houseID] = nil
						cleanupProperty(houseID)
						outputChatBox("[REMOVEINT] Interior #" .. houseID .. " has been removed completely from Database!", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, { "in"..tostring(houseID) } , "REMOVEINT "..houseID)
						local adminUsername = getElementData(thePlayer, "account:username")
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						local adminID = getElementData(thePlayer, "account:id")
						if hiddenAdmin == 0 then
							exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has removed Interior #"..houseID.." permanently from database.")
						else
							exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has removed Interior #"..houseID.." permanently from database.")
						end
						
						if not mysql:query_free("DELETE FROM `interior_logs` WHERE `intID`='"..tostring(houseID).. "'") then
							outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..houseID.." from `interior_logs`.")
						end
						-- if not mysql:query_free("DELETE FROM `logtable` WHERE `affected`='in"..tostring(houseID).. ";'") then
							-- outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..houseID.." from `logtable`.")
						-- end -- Lags server as hell, I won't touch that shit then / MAXIME
						if not mysql:query_free("DELETE FROM `interior_business` WHERE `intID`='"..tostring(houseID).. "'") then
							outputDebugString("[INTERIOR MANAGER] Failed to clean previous logs #"..houseID.." from `interior_business`.")
						end
						
						if commandName == "MOVETOLS" then 
							realReloadInterior(houseID) 
						end
						
						local mQuery1 = mysql:query("SELECT id FROM `interiors` WHERE `dimensionwithin`='".. mysql:escape_string(houseID) .."'")
						while true do
							local row = mysql:fetch_assoc(mQuery1)
							if not row then break end
							removeInterior(thePlayer, "MOVETOLS", row["id"])
						end
						mysql:free_result(mQuery1)
					else
						outputChatBox("[REMOVEINT] Database Error!", thePlayer, 255, 0, 0)
					end
				end
			end
		else
			outputChatBox("Please wait until the interior system loading is done..", thePlayer, 255, 0, 0)
			return false
		end
	end
end
addCommandHandler("removeint", removeInterior, false, false)
addCommandHandler("removeinterior", removeInterior, false, false)

function removeDeletedInteriors(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin( thePlayer ) then	
		if not getElementData(thePlayer, "confirm:removeDeletedInteriors") then
			outputChatBox( "Removes all deleted interiors completely and permanently from SQL.", thePlayer, 255, 194, 14 )
			outputChatBox( "And there will be no way to recover them, /"..commandName.." again to start it. /cancelremovedeletedints to cancel.", thePlayer, 255, 194, 14 )
			setElementData(thePlayer, "confirm:removeDeletedInteriors", true)
		else
			removeElementData(thePlayer, "confirm:removeDeletedInteriors")
			local mQuery1 = mysql:query("SELECT `id` FROM `interiors` WHERE `deleted` != '0'")
			local count = 0 
			if mQuery1 then
				while true do
					local row = mysql:fetch_assoc(mQuery1)
					if not row then break end
					removeInterior(thePlayer, "MOVETOLS", row["id"])
					count = count + 1
				end
				mysql:free_result(mQuery1)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username")
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has executed a massive int remove command on "..count.." deleted interiors permanently from database.", root, 255,0,0)
				else
					exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has executed a massive int remove command on "..count.." deleted interiors permanently from database.", root, 255,0,0)
				end
			end
		end
	end
end
addCommandHandler("removedeletedints", removeDeletedInteriors, false, false)
addCommandHandler("removedeletedinteriors", removeDeletedInteriors, false, false)

function forceSellAllInactiveInteriors(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin( thePlayer ) then	
		if not getElementData(thePlayer, "confirm:forceSellAllInactiveInteriors") then
			outputChatBox( "Force-sell all inactive houses and businesses owned by players.", thePlayer, 255, 194, 14 )
			outputChatBox( "And there will be no way to recover them, /"..commandName.." again to start it. /cancelforcesellinactiveints to cancel.", thePlayer, 255, 194, 14 )
			setElementData(thePlayer, "confirm:forceSellAllInactiveInteriors", true)
		else
			removeElementData(thePlayer, "confirm:forceSellAllInactiveInteriors")
			local mQuery1 = mysql:query("SELECT `id` FROM `interiors` WHERE DATEDIFF(NOW(), lastused) >= '14' AND `owner` != '-1' AND `owner` != '0'")
			local count = 0 
			if mQuery1 then
				while true do
					local row = mysql:fetch_assoc(mQuery1)
					if not row then break end
					publicSellProperty(thePlayer, tonumber(row["id"]), false , false, true)
					count = count + 1
				end
				mysql:free_result(mQuery1)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username")
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has executed a massive int force-sell command on "..count.." inactive interiors.")
				else
					exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has executed a massive int force-sell command on "..count.." inactive interiors.")
				end
			end
		end
	end
end
addCommandHandler("forcesellactiveints", forceSellAllInactiveInteriors, false, false)
addCommandHandler("forcesellactiveinteriors", forceSellAllInactiveInteriors, false, false)

function removeForSaleInteriors(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin( thePlayer ) then	
		if not getElementData(thePlayer, "confirm:removeForSaleInteriors") then
			outputChatBox( "Removes all for-sale interiors completely and permanently from SQL.", thePlayer, 255, 194, 14 )
			outputChatBox( "And there will be no way to recover them, /"..commandName.." again to start it. /cancelremoveforsaleints to cancel.", thePlayer, 255, 194, 14 )
			setElementData(thePlayer, "confirm:removeForSaleInteriors", true)
		else
			removeElementData(thePlayer, "confirm:removeForSaleInteriors")
			local mQuery1 = mysql:query("SELECT `id` FROM `interiors` WHERE `owner` = '-1'")
			local count = 0 
			if mQuery1 then
				while true do
					local row = mysql:fetch_assoc(mQuery1)
					if not row then break end
					removeInterior(thePlayer, "MOVETOLS", row["id"])
					count = count + 1
				end
				mysql:free_result(mQuery1)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username")
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has executed a massive int remove command on "..count.." for-sale interiors permanently from database.", root, 255,0,0)
				else
					exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has executed a massive int remove command on "..count.." for-sale interiors permanently from database.")
				end
			end
		end
	end
end
addCommandHandler("removeforsaleints", removeForSaleInteriors, false, false)
addCommandHandler("removeforsaleinteriors", removeForSaleInteriors, false, false)

function removeInactiveInteriors(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin( thePlayer ) then	
		if not getElementData(thePlayer, "confirm:removeInactiveInteriors") then
			outputChatBox( "Removes All inactive interiors completely and permanently from SQL.", thePlayer, 255, 194, 14 )
			outputChatBox( "And there will be no way to recover them, /"..commandName.." again to start it. /cancelremoveinactiveints to cancel.", thePlayer, 255, 194, 14 )
			setElementData(thePlayer, "confirm:removeInactiveInteriors", true)
		else
			removeElementData(thePlayer, "confirm:removeInactiveInteriors")
			local mQuery1 = mysql:query("SELECT `id` FROM `interiors` WHERE DATEDIFF(NOW(), lastused) >= '14'")
			local count = 0 
			if mQuery1 then
				while true do
					local row = mysql:fetch_assoc(mQuery1)
					if not row then break end
					removeInterior(thePlayer, "MOVETOLS", row["id"])
					count = count + 1
				end
				mysql:free_result(mQuery1)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminUsername = getElementData(thePlayer, "account:username")
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has executed a massive int remove command on "..count.." inactive interiors permanently from database.")
				else
					exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has executed a massive int remove command on "..count.." inactive interiors permanently from database.")
				end
			end
		end
	end
end
addCommandHandler("removeinactiveints", removeInactiveInteriors, false, false)
addCommandHandler("removeinactiveinteriors", removeInactiveInteriors, false, false)


function cancelRemoveDeletedInts(thePlayer)
	if exports.global:isPlayerHeadAdmin( thePlayer ) and getElementData(thePlayer, "confirm:removeDeletedInteriors") then	
		if removeElementData(thePlayer, "confirm:removeDeletedInteriors") then
			outputChatBox("Request to remove all deleted interiors has been cancelled.", thePlayer)
		end
	end
end
addCommandHandler("cancelremovedeletedints", cancelRemoveDeletedInts, false, false)
addCommandHandler("cancelremovedeletedints", cancelRemoveDeletedInts, false, false)

function cancelForceSellAllInactiveInteriors(thePlayer)
	if exports.global:isPlayerHeadAdmin( thePlayer ) and getElementData(thePlayer, "confirm:forceSellAllInactiveInteriors") then	
		if removeElementData(thePlayer, "confirm:forceSellAllInactiveInteriors") then
			outputChatBox("Request to force-sell all inactive interiors has been cancelled.", thePlayer)
		end
	end
end
addCommandHandler("cancelforcesellinactiveints", cancelForceSellAllInactiveInteriors, false, false)
addCommandHandler("cancelforcesellinactiveints", cancelForceSellAllInactiveInteriors, false, false)

function cancelRemoveForSaleInts(thePlayer)
	if exports.global:isPlayerHeadAdmin( thePlayer ) and getElementData(thePlayer, "confirm:removeForSaleInteriors") then	
		if removeElementData(thePlayer, "confirm:removeForSaleInteriors") then
			outputChatBox("Request to remove all for-sale interiors has been cancelled.", thePlayer)
		end
	end
end
addCommandHandler("cancelremoveforsaleints", cancelRemoveForSaleInts, false, false)
addCommandHandler("cancelremoveforsaleints", cancelRemoveForSaleInts, false, false)

function cancelRemoveInactiveInteriors(thePlayer)
	if exports.global:isPlayerHeadAdmin( thePlayer ) and getElementData(thePlayer, "confirm:removeInactiveInteriors") then	
		if removeElementData(thePlayer, "confirm:removeInactiveInteriors") then
			outputChatBox("Request to remove all inactive interiors has been cancelled.", thePlayer)
		end
	end
end
addCommandHandler("cancelremoveinactiveints", cancelRemoveInactiveInteriors, false, false)
addCommandHandler("cancelremoveinactiveints", cancelRemoveInactiveInteriors, false, false)

---

function deleteThisInterior(thePlayer, commandName)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14)  then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			deleteInterior(thePlayer, "delint" , dbid)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
		end
	end
end
addCommandHandler("delthisint", deleteThisInterior, false, false)
addCommandHandler("delthisinterior", deleteThisInterior, false, false)

function updateInteriorEntrance(thePlayer, commandName, intID)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local intID = tonumber(intID)
		if not (intID) then
			outputChatBox( "SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty(thePlayer, intID)
			if entrance then
				local dw = getElementDimension(thePlayer)
				local iw = getElementInterior(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local rot = getPedRotation(thePlayer)
				local query = mysql:query_free("UPDATE interiors SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', angle='" .. rot .. "', dimensionwithin='" .. dw .. "', interiorwithin='" .. iw .. "' WHERE id='" .. dbid .. "'")
				
				if (query) then
					realReloadInterior(dbid)
					
					outputChatBox("Interior Entrance #" .. dbid .. " has been Updated!", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORENTRANCE ("..dw.."/"..iw..") "..x.."/"..y.."/"..z)
					local adminUsername = getElementData(thePlayer, "account:username")
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has moved Interior #"..dbid.." to new location.")
					else
						exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has moved Interior #"..dbid.." to new location.")
					end
					
					
					exports["interior-manager"]:addInteriorLogs(dbid, commandName, thePlayer)
					
					return true
				else
					outputChatBox("Error with the query.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox( "Invalid Interior ID.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("setinteriorentrance", updateInteriorEntrance, false, false)
addCommandHandler("setintentrance", updateInteriorEntrance, false, false)

function createInterior(thePlayer, commandName, interiorId, inttype, cost, ...)
	if exports.global:isPlayerAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) or exports.global:isPlayerScripter(thePlayer) then
		local cost = tonumber(cost)
		if (not (interiorId) or not (inttype) or not (cost) or not (...) or ((tonumber(inttype)<0) or (tonumber(inttype)>3))) and (commandName:lower() == "addint" or commandName:lower() == "addinterior") then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [TYPE] [Cost] [Name]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 0: House", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1: Business", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2: Government (Unbuyable)", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3: Rentable", thePlayer, 255, 194, 14)
			outputChatBox("/addnewint to create an interior quickly.", thePlayer, 255, 194, 0)
		elseif not exports.global:takeMoney(getTeamFromName("Government of Los Santos"), cost) then
			outputChatBox("The government can't afford this property.", thePlayer, 255, 0, 0)
		else
			local owner, locked = nil, nil
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interiorwithin = getElementInterior(thePlayer)
			
			if commandName:lower() == "addnewint" then
				name = "Garage"
				inttype = 0
				owner = -1
				locked = 1
				cost = 8000
				interiorId = 119
			else
				name = table.concat({...}, " ")
				
				
				inttype = tonumber(inttype)
				owner = nil
				locked = nil
				
				if (inttype==2) then
					owner = 0
					locked = 0
				else
					owner = -1
					locked = 1
				end
				
			end
			local interiors = exports["official-interiors"].getInteriorsList() --/MAXIME
			interior = interiors[tonumber(interiorId)]
			if interior then
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local rot = getPedRotation(thePlayer)
				local id = SmallestID()
				local query = mysql:query_free("INSERT INTO interiors SET creator='"..getElementData( thePlayer, "account:username" ).."', id=" .. id .. ",x='" .. x .. "', y='" .. y .."', z='" .. z .."', type='" .. inttype .. "', owner='" .. owner .. "', locked='" .. locked .. "', cost='" .. cost .. "', name='" .. mysql:escape_string( name) .. "', interior='" .. interiorw .. "', interiorx='" .. ix .. "', interiory='" .. iy .. "', interiorz='" .. iz .. "', dimensionwithin='" .. dimension .. "', interiorwithin='" .. interiorwithin .. "', angle='" .. optAngle .. "', angleexit='" .. rot .. "', createdDate=NOW()")
				
				if (query) then
					if tonumber(inttype) == 1 then
						mysql:query_free("INSERT INTO `interior_business` SET `intID`='"..id.."' ")
					end
					
					outputChatBox("Created Interior with ID " .. id .. ".", thePlayer, 255, 194, 14)
					exports.logs:dbLog(thePlayer, 4, { "in"..tostring(id) } , "ADDINTERIOR T:".. inttype .." I:"..interiorId.." C:"..cost)
					reloadOneInterior(id, false, false)	
					local adminUsername = getElementData(thePlayer, "account:username")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				
					exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has created Interior #"..id.." with name '"..name.."', type "..inttype..", price: $"..cost..").")
					
					exports["interior-manager"]:addInteriorLogs(id, commandName.." - id "..interiorId.." - price $"..cost.." - name "..name, thePlayer)
					
					return true
				else
					outputChatBox("Failed to create interior - Invalid characters used in name of the interior.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Failed to create interior - There is no such interior (" .. ( interiorID or "??" ) .. ").", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addinterior", createInterior, false, false)
addCommandHandler("addint", createInterior, false, false)
addCommandHandler("addnewint", createInterior, false, false)

function updateInteriorExit(thePlayer, commandName)
	if exports.global:isPlayerFullAdmin( thePlayer ) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		local dimension = getElementDimension(thePlayer)
		
		if (dimension==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local rot = getPedRotation(thePlayer)
			local query = mysql:query_free("UPDATE interiors SET interiorx='" .. x .. "', interiory='" .. y .. "', interiorz='" .. z .. "', angle='" .. rot .. "', `interior`='".. tostring(interior) .."' WHERE id='" .. dbid .. "'")
			outputChatBox("Interior Exit Position Updated!", thePlayer, 0, 255, 0)
			exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIOREXIT "..x.."/"..y.."/"..z)
			
			exports["interior-manager"]:addInteriorLogs(dbid, commandName, thePlayer)
			
			realReloadInterior(dbid)
			return true
		end
	end
end
addCommandHandler("setinteriorexit", updateInteriorExit, false, false)
addCommandHandler("setintexit", updateInteriorExit, false, false)

function changeInteriorName( thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then -- Is the player an admin?
		local id = getElementDimension(thePlayer)
		if not (...) then -- is the command complete?
			outputChatBox("SYNTAX: /" .. commandName .." [New Name]", thePlayer, 255, 194, 14) -- if command is not complete show the syntax.
		elseif (dimension==0) then
			outputChatBox("You are not inside an interior.", thePlayer, 255, 0, 0)
		else
			name = table.concat({...}, " ")
		
			mysql:query_free("UPDATE interiors SET name='" .. mysql:escape_string( name) .. "' WHERE id='" .. id .. "'") -- Update the name in the sql.
			outputChatBox("Interior name changed to ".. name ..".", thePlayer, 0, 255, 0) -- Output confirmation.
			exports.logs:dbLog(thePlayer, 4, { "in"..tostring(dbid) } , "SETINTERIORNAME '"..name.."'")
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has changed Interior #"..id.."'s name to '"..name.."'.")
			else
				exports.global:sendMessageToAdmins("[INTERIOR]: A hidden admin has changed Interior #"..id.."'s name to '"..name.."'.")
			end
			
			
			exports["interior-manager"]:addInteriorLogs(id, commandName.." "..name, thePlayer)
			
			realReloadInterior(id)
			return true
		end
	end
end
addCommandHandler("setinteriorname", changeInteriorName, false, false) -- the command "/setInteriorName".
addCommandHandler("setintname", changeInteriorName, false, false)

function forceSellProperty(thePlayer, commandName, intID)
	if exports.global:isPlayerFullAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 14) then
		if not intID or not tonumber(intID) or (tonumber(intID)%1 ~= 0) or (tonumber(intID) <= 0) then
			outputChatBox("SYNTAX: /" .. commandName .." [ID]", thePlayer, 255, 194, 14)
			outputChatBox("Force sells a property.", thePlayer, 200, 194, 14)
			return
		end
		local possibleInteriors = getElementsByType("interior")
		local foundInt = false
		for _, interior in ipairs(possibleInteriors) do				
			if getElementData(interior, "dbid") == tonumber(intID) then
				foundInt = interior
				break
			end
		end
		if not foundInt then
			outputChatBox("Interior ID not found in game.", thePlayer, 255, 0,0)
			return
		end
		local interiorEntrance = getElementData(foundInt, "entrance")
		local interiorExit = getElementData(foundInt, "exit")
		local interiorStatus = getElementData(foundInt, "status")
		 
		if interiorStatus[INTERIOR_TYPE] == 2 then
			outputChatBox("You cannot force-sell a government property.", thePlayer, 255, 0, 0)
		else
			publicSellProperty(thePlayer, tonumber(intID), true, false, "FORCESELL")
			cleanupProperty(tonumber(intID), true)
			exports.logs:dbLog(thePlayer, 37, { "in"..tostring(intID) } , "FORCESELL "..intID)
			
			
			exports["interior-manager"]:addInteriorLogs(intID, commandName, thePlayer)
		end
	end
end
addCommandHandler("forcesell", forceSellProperty, false, false)
addCommandHandler("fsell", forceSellProperty, false, false)