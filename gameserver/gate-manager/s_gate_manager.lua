function getAllGates(thePlayer, commandName, ...)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if table.concat({...}, " ") ~= "" then
			outputChatBox("SYNTAX: /"..commandName.." - Open Gates Manager", thePlayer, 255, 194, 14)
		else
			local gatesList = {}
			local mQuery1 = nil
			mQuery1 = mysql:query("SELECT * FROM `gates` ORDER BY `createdDate` DESC")
			while true do
				local row = mysql:fetch_assoc(mQuery1)
				if not row then break end
				table.insert(gatesList, { row["id"], tostring(row["objectID"]), row["gateType"], row["gateSecurityParameters"], row["creator"], row["createdDate"], row["adminNote"], row["autocloseTime"], row["movementTime"], row["objectInterior"], row["objectDimension"], row["startX"], row["startY"], row["startZ"], row["startRX"], row["startRY"], row["startRZ"], row["endX"], row["endY"], row["endZ"], row["endRX"], row["endRY"], row["endRZ"] } )
			end
			mysql:free_result(mQuery1)
			triggerClientEvent(thePlayer, "createGateManagerWindow", thePlayer, gatesList, getElementData( thePlayer, "account:username" ))
		end
	end
end
addCommandHandler("gates", getAllGates)

function addGate(thePlayer, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21)
	local mQuery1 = nil
	mQuery1 = mysql:query("INSERT INTO `gates` (`objectID`, `startX`, `startY`, `startZ`, `startRX`, `startRY`, `startRZ`, `endX`, `endY`, `endZ`, `endRX`, `endRY`, `endRZ`, `gateType`, `gateSecurityParameters`, `autocloseTime`, `movementTime`, `objectInterior`, `objectDimension`, `creator`, `adminNote`) VALUES ('".. mysql:escape_string(a1) .."', '".. mysql:escape_string(a2) .."', '".. mysql:escape_string(a3) .."', '".. mysql:escape_string(a4) .."', '".. mysql:escape_string(a5) .."', '".. mysql:escape_string(a6) .."', '".. mysql:escape_string(a7) .."', '".. mysql:escape_string(a8) .."', '".. mysql:escape_string(a9) .."', '".. mysql:escape_string(a10) .."', '".. mysql:escape_string(a11) .."', '".. mysql:escape_string(a12) .."', '".. mysql:escape_string(a13) .."', '".. mysql:escape_string(a14) .."', '".. mysql:escape_string(a15) .."', '".. mysql:escape_string(a16) .."', '".. mysql:escape_string(a17) .."', '".. mysql:escape_string(a18) .."', '".. mysql:escape_string(a19) .."', '".. mysql:escape_string(a20) .."', '".. mysql:escape_string(a21) .."')")
	
	if mQuery1 then 
		outputChatBox("[GATEMANAGER] Sucessfully added gate!", thePlayer, 0,255,0)
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		local theResource = getThisResource()
		if restartResource(theResource) then
			outputChatBox("[GATEMANAGER] All gates have been reloaded successfully!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("[GATEMANAGER]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has added a new gate.")
			else
				exports.global:sendMessageToAdmins("[GATEMANAGER]: A hidden admin has added a new gate.")
			end
		else
			outputChatBox("[GATEMANAGER]: Error! Failed to restart resource. Please notify scripters!", thePlayer, 255, 0, 0)
		end
		getAllGates(thePlayer, "gates")
	else
		outputChatBox("[GATEMANAGER] Failed to add gate. Please check the inputs again.", thePlayer, 255,0,0)
	end
end
addEvent("addGate", true)
addEventHandler("addGate", getRootElement(), addGate)

function saveGate(thePlayer, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22)
		local mQuery1 = nil
		mQuery1 = mysql:query("UPDATE `gates` SET `objectID` = '".. mysql:escape_string(a1) .."', `startX` = '".. mysql:escape_string(a2) .."', `startY` = '".. mysql:escape_string(a3) .."', `startZ` = '".. mysql:escape_string(a4) .."', `startRX` = '".. mysql:escape_string(a5) .."', `startRY` = '".. mysql:escape_string(a6) .."', `startRZ` = '".. mysql:escape_string(a7) .."', `endX` = '".. mysql:escape_string(a8) .."', `endY` = '".. mysql:escape_string(a9) .."', `endZ` = '".. mysql:escape_string(a10) .."', `endRX` = '".. mysql:escape_string(a11) .."', `endRY` = '".. mysql:escape_string(a12) .."', `endRZ`= '".. mysql:escape_string(a13) .."', `gateType` = '".. mysql:escape_string(a14) .."', `gateSecurityParameters`= '".. mysql:escape_string(a15) .."', `autocloseTime` = '".. mysql:escape_string(a16) .."', `movementTime` = '".. mysql:escape_string(a17) .."', `objectInterior` = '".. mysql:escape_string(a18) .."', `objectDimension` = '".. mysql:escape_string(a19) .."', `creator` = '".. mysql:escape_string(a20) .."', `adminNote` = '".. mysql:escape_string(a21) .."' WHERE `id` = '".. mysql:escape_string(a22) .."'")
		
		if mQuery1 then 
			outputChatBox("[GATEMANAGER] Sucessfully saved gate!", thePlayer, 0,255,0)
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			local theResource = getThisResource()
			if restartResource(theResource) then
				outputChatBox("[GATEMANAGER] All gates have been reloaded successfully!", thePlayer, 0, 255, 0)
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("[GATEMANAGER]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has modified gate ID #"..a22..".")
				else
					exports.global:sendMessageToAdmins("[GATEMANAGER]: A hidden admin has modified gate ID #"..a22..".")
				end
			else
				outputChatBox("[GATEMANAGER]: Error! Failed to restart resource. Please notify scripters!", thePlayer, 255, 0, 0)
			end
			getAllGates(thePlayer, "gates")
		else
			outputChatBox("[GATEMANAGER] Failed to modify gate. Please check the inputs again.", thePlayer, 255,0,0)
		end
end
addEvent("saveGate", true)
addEventHandler("saveGate", getRootElement(), saveGate)

function delGate(thePlayer, commandName, gateID)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not tonumber(gateID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Gate ID]", thePlayer, 255, 194, 14)
		else
			local mQuery1 = nil
			mQuery1 = mysql:query("DELETE FROM `gates` WHERE `id` = '".. mysql:escape_string(gateID) .."'")
			
			if mQuery1 then 
				outputChatBox("[GATEMANAGER] Sucessfully deleted gate!", thePlayer, 0,255,0)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local theResource = getThisResource()
				if restartResource(theResource) then
					outputChatBox("[GATEMANAGER] All gates have been reloaded successfully!", thePlayer, 0, 255, 0)
					if hiddenAdmin == 0 then
						exports.global:sendMessageToAdmins("[GATEMANAGER]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has deleted gate ID #"..gateID..".")
					else
						exports.global:sendMessageToAdmins("[GATEMANAGER]: A hidden admin has deleted gate ID #"..gateID..".")
					end
				else
					outputChatBox("[GATEMANAGER]: Error! Failed to restart resource. Please notify scripters!", thePlayer, 255, 0, 0)
				end
				getAllGates(thePlayer, "gates")
			else
				outputChatBox("[GATEMANAGER] Gate doesn't exist.", thePlayer, 255,0,0)
			end
		end
	end
end
addEvent("delGate", true)
addEventHandler("delGate", getRootElement(), delGate)
addCommandHandler("delgate",delGate)

function reloadGates(thePlayer)
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		local theResource = getThisResource()
		if restartResource(theResource) then
			outputChatBox("[GATEMANAGER] All gates have been reloaded successfully!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("[GATEMANAGER]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has reloaded all gates.")
			else
				exports.global:sendMessageToAdmins("[GATEMANAGER]: A hidden admin has has reloaded all gates.")
			end
			--getAllGates(thePlayer, "gates")
		else
			outputChatBox("[GATEMANAGER]: Error! Failed to restart resource. Please notify scripters!", thePlayer, 255, 0, 0)
		end
end
addEvent("reloadGates", true)
addEventHandler("reloadGates", getRootElement(), reloadGates)

function gotoGate(thePlayer, commandName, gateID, x, y, z , rot, int, dim)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not tonumber(gateID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Gate ID]", thePlayer, 255, 194, 14)
		else
			local gateID1, x1, y1, z1, rot1, int1, dim1 = nil
			if not tonumber(dim) then
				local mQuery1 = mysql:query("SELECT `startX` , `startY`, `startZ` , `startRX`, `objectInterior`, `objectDimension` FROM `gates` WHERE `id` = '".. mysql:escape_string(gateID) .."'")
				local row = mysql:fetch_assoc(mQuery1)
				if not row then
					outputChatBox("[GATEMANAGER]: Gate doesn't exist.", thePlayer, 255, 0, 0)
					return
				else
					x1 = row["startX"]
					y1 = row["startY"]
					z1 = row["startZ"]
					rot1 = row["startRX"]
					int1 = row["objectInterior"]
					dim1 = row["objectDimension"]
					startGoingToGate(thePlayer, x1,y1,z1,rot1,int1,dim1, gateID)
					mysql:free_result(mQuery1)
				end
			else
				--To be continued.
			end
		end
	end
end
addEvent("gotoGate", true)
addEventHandler("gotoGate", getRootElement(), gotoGate)
addCommandHandler("gotogate", gotoGate)

function startGoingToGate(thePlayer, x,y,z,r,interior,dimension,gateID)
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
	outputChatBox(" You have teleported to gate ID#"..gateID, thePlayer)
end