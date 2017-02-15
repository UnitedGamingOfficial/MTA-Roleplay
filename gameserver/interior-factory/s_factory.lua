--Globals
mysql = exports.mysql

--Loading the factories will be done in the interior system when interiors are loaded.
--Admin Commands
function createFactory(thePlayer, commandName, type, maxSupplies, factionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if not type or not maxSupplies or not isTypeValid(type) or not tonumber(maxSupplies) or not factionID or not tonumber(factionID) then
			outputChatBox("SYNTAX: /"..commandName.." [Type 1=Weapon 2=Drug] [Max Supplies] [Faction ID]", thePlayer, 255, 194, 14)
		else
			local dbid, entrance, exit, interiorType, theInterior = exports['interior-system']:findProperty(thePlayer)
			if exit then
				if not getElementData(theInterior, "factory") then
					local id = mysql:query_insert_free("INSERT INTO `factories` (`INT_ID`, `Type`, `Max_Supplies`, `Curr_Supplies`, `Ordered_Supplies`, `Date_Of_Arrival`, `Order_Claimed`, `Authorized_Faction`) VALUES (" .. dbid .."," .. mysql:escape_string(type) .."," .. mysql:escape_string(maxSupplies) .. ",0,0,NULL,0," .. mysql:escape_string(factionID) .. ")")
					if id then
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory", dbid)
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:type", type)
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:max", tonumber(maxSupplies))
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:curr", 0)
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:order", false)
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:date", false)
						exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:faction", tonumber(factionID))
						local typeString
						if tonumber(type) == 1 then typeString = "Weapon" else typeString = "Drug" end
						exports.logs:dbLog(thePlayer, 40, theInterior, "Created " .. typeString .. " factory in interior.")
						outputChatBox(typeString .. " factoy has been created with an ID of " .. id, thePlayer, 0, 255, 0)
					else
						outputChatBox("There was a database error while creating the factory.", thePlayer, 255,0,0)
					end
				else
					outputChatBox("This interior already has a factory in it.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You must be in the interior you wish to create the factory.", thePlayer, 255,0,0)
			end
		end
	end
end
addCommandHandler("addfactory", createFactory, false, false)

function removeFactory(thePlayer)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		local dbid, entrance, exit, interiorType, theInterior = exports['interior-system']:findProperty(thePlayer)
		if exit then
			if getElementData(theInterior, "factory") then
				local facdbid = tonumber(getElementData(theInterior, "factory"))
				local result = mysql:query_free("DELETE FROM `factories` WHERE ID = " .. facdbid)
				if result then
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory", nil)
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:type", nil)
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:max", nil)
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:curr", nil)
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:order", nil)
					exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:date", nil)
					exports.logs:dbLog(thePlayer, 40, theInterior, "Removed factory from the interior.")
					outputChatBox("The factory was removed from the interior.", thePlayer, 0, 255, 0)
				else
					outputChatBox("There was a database error while removing the factory", thePlayer, 255,0,0)
				end
			else
				outputChatBox("There is no factory in this interior.", thePlayer, 255,0,0)
			end
		else
			outputChatBox("You are not in an interior.", thePlayer, 255,0,0)
		end
	end
end
addCommandHandler("delfactory", removeFactory, false, false)
addCommandHandler("deletefactory", removeFactory, false, false)
addCommandHandler("removefactory", removeFactory, false, false)

function isTypeValid(theType)
	if theType then
		if tonumber(theType) then
			local number = tonumber(theType)
			if number == 1 then
				return true
			elseif number == 2 then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function hasPlayerAccessOverFaction(theElement, factionID)
	if (isElement(theElement)) then	-- Is the player online?
		local realFactionID = getElementData(theElement, "faction") or -1
		local factionLeaderStatus = getElementData(theElement, "factionleader") or 0
		if tonumber(realFactionID) == tonumber(factionID) then -- Is the player in the specific faction
			if tonumber(factionLeaderStatus) == 1 then -- Is the player a faction leader?
				return true
			end
		end
	end
	return false
end	

function showSupplies(thePlayer)
	local dbid, entrance, exit, interiorType, theInterior = exports['interior-system']:findProperty(thePlayer)
	if exit then
		if getElementData(theInterior, "factory") then
			if hasPlayerAccessOverFaction(thePlayer, getElementData(theInterior, "factory:faction")) or exports.global:isPlayerLeadAdmin(thePlayer) then
				local supplyCount = getElementData(theInterior, "factory:curr")
				local type = getElementData(theInterior, "factory:type")
				local typeString
				if tonumber(type) == 1 then typeString = "weapon" else typeString = "drug" end
				outputChatBox("This " .. typeString .. " factory currently has " .. supplyCount .. " supplies.", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("This interior does not have a factory.", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("You are not in an interior.", thePlayer, 255,0,0)
	end
end
addCommandHandler("getsupplies", showSupplies, false, false)

function addSupplies(thePlayer, commandName, supplies)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if not supplies or not tonumber(supplies) then
			outputChatBox("SYNTAX: /"..commandName.." [Number of Supplies]", thePlayer, 255, 194, 14)
			outputChatBox("NOTE: Negative values can be used to remove supplies.", thePlayer, 255, 194, 14)
		else
			supplies = tonumber(supplies)
			local dbid, entrance, exit, interiorType, theInterior = exports['interior-system']:findProperty(thePlayer)
			if exit then
				if getElementData(theInterior, "factory") then
					local facdbid = getElementData(theInterior, "factory")
					local currSupplies = tonumber(getElementData(theInterior, "factory:curr"))
					local maxSupplies = tonumber(getElementData(theInterior, "factory:max"))
					if ((currSupplies + supplies) <= maxSupplies) and ((currSupplies + supplies) > 0) then
						local newSupplies = currSupplies + supplies
						local result = mysql:query_free("UPDATE `factories` SET `Curr_Supplies` = " .. mysql:escape_string(tostring(newSupplies)) .. " WHERE ID = " .. mysql:escape_string(tostring(facdbid)))
						if result then
							exports.logs:dbLog(thePlayer, 40, theInterior, "Added " .. supplies .. " supplies to the factory.")
							exports['anticheat-system']:changeProtectedElementDataEx(theInterior, "factory:curr", newSupplies)
							outputChatBox("You have moddifed supplies by " .. supplies .. " to this factory. Total Supplies: " .. newSupplies, thePlayer, 0,255,0)
						else
							outputChatBox("There was an SQL error while processing the request.",thePlayer,255,0,0)
						end
					else
						outputChatBox("The supplies could not be added. Possibly over max or results in negative supplies.", thePlayer, 255,0,0)
					end
				else
					outputChatBox("There is no factory in this interior.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You are not in an interior.", thePlayer, 255,0,0)
			end
		end
	end
end
addCommandHandler("addsupplies", addSupplies, false, false)

-- Gun Creation
local weaponList = {
	[4]  = 2
	[8]  = 2
	[22] = 5
	[23] = 6
	[24] = 8
	[25] = 8
	[26] = 7
	[27] = 10
	[28] = 10
	[29] = 10
	[32] = 10
	[30] = 13
	[31] = 13
	[33] = 15
	[34] = 15
	[16] = 7
	[17] = 10
	[18] = 7
}

function createWeapon(thePlayer, commandName, weaponName)
	if not weaponName then
		outputChatBox("SYNTAX: /" .. commandName .. " [Weapon Name or ID]", thePlayer, 255, 194, 14)
	else
		local weaponID = tonumber(args[1])
		local weaponName = args[1]
		if weaponID == nil then
			local cWeaponName = weaponName:lower()
			if cWeaponName == "colt45" then 
				weaponID = 22
			elseif cWeaponName == "combatshotgun" then 
				weaponID = 27
			else
				if not getWeaponIDFromName(cWeaponName) then
					outputChatBox("Invalid Weapon Name/ID. Type /gunlist for a list of weapon names and IDs.", thePlayer, 255, 0, 0)
					return
				else
					weaponID = getWeaponIDFromName(cWeaponName)
				end
			end
		end