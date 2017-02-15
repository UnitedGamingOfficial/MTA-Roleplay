function loadAllPerks( targetPlayer )
	if isElement( targetPlayer ) then
		local logged = getElementData(targetPlayer, "account:loggedin")
		if (logged == true) then
			local gameAccountID = getElementData(targetPlayer, "account:id")
			if (gameAccountID) then
				if (gameAccountID > 0) then
					local mysqlResult = exports.mysql:query("SELECT `perkID`,`perkValue` FROM `donators` WHERE `accountID`='".. tostring(gameAccountID) .."' AND expirationDate > NOW()")
					local perksTable = { }
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, false)
					if (mysqlResult) then
						while true do
							local mysqlRow = exports.mysql:fetch_assoc(mysqlResult)
							if not mysqlRow then break end
							perksTable[ tonumber(mysqlRow["perkID"]) ] = mysqlRow["perkValue"]
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, false)
						end
					end
					exports.mysql:free_result(mysqlResult)
					return true
				end
			end
		end
	end
	return false
end

function hasPlayerPerk(targetPlayer, perkID)
	if not isElement( targetPlayer ) then
		return false
	end
	
	if not tonumber(perkID) then
		return false
	end
	
	perkID = tonumber(perkID)
	
	local perkTable = getElementData(targetPlayer, "donation-system:perks")
	if not (perkTable) then
		return false
	end
	
	if (perkTable[perkID] == nil) then
		return false
	end

	
	return true, perkTable[perkID]
end

function updatePerkValue (targetPlayer, perkID, newValue)
	newValue = tostring(newValue)
	if not tonumber(perkID) then
		return false
	end
	
	perkID = tonumber(perkID)
	
	if (hasPlayerPerk(targetPlayer, perkID)) then
		local gameAccountID = getElementData(targetPlayer, "account:id")
		if (gameAccountID) then
			if (gameAccountID > 0) then
				exports.mysql:query_free("UPDATE `donators` SET `perkValue`='" .. exports.mysql:escape_string(newValue) .. "' WHERE `accountID`='".. tostring(gameAccountID)  .."' AND `perkID`='".. exports.mysql:escape_string(tostring(perkID)) .."'")
				local perkTable = getElementData(targetPlayer, "donation-system:perks")				
				perkTable[ perkID ] = newValue
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perkTable, false)
				return true
			end
		end
	end
	return false
end

function givePlayerPerk(targetPlayer, perkID, perkValue, days, points, ...)
	if not isElement( targetPlayer ) then
		return false, "Internal script error 100.1"
	end
	
	if not tonumber(perkID) then
		return false, "Internal script error 100.2"
	end
	
	if not perkValue then
		perkValue = 1
	end
	
	if not tonumber(days) then
		return false, "Internal script error 100.3"
	end
	
	if not tonumber(points) then
		return false, "Internal script error 100.4"
	end
	
	perkValue = tostring(perkValue)
	perkID = tostring(perkID)
	points = tonumber(points)
	local logged = getElementData(targetPlayer, "account:loggedin")
	if (logged == false) then
		return false, "Player is not logged in"
	end
	
	if not points or points < 0 then
		return false, "Internal script error 100.5"
	end
	
	local gameAccountID = getElementData(targetPlayer, "account:id")
	local characterID = getElementData(targetPlayer, "account:character:id")
	if (gameAccountID) then
		if (gameAccountID > 0) then
			-- Handle the special perks first.
			if (tonumber(perkID) == 1) then
				exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
				local transfers = "?"
				local result = exports.mysql:query_fetch_assoc("SELECT transfers FROM accounts WHERE id = " .. exports.mysql:escape_string(tostring(gameAccountID)))
				if result then
					transfers = result["transfers"] or "?"
				end
				if transfers then
					exports.mysql:query_free("UPDATE `accounts` SET `transfers`='".. tonumber(transfers+1) .."' WHERE `id`='".. tostring(gameAccountID) .."'")
					outputChatBox("Perk activated: Added a stat transfer to your account. Stat Transfers: " .. tonumber(transfers+1) .. "", targetPlayer)
					return true, "Success"
				else
					return false, "Error 1337.1337: Could not add a stat transfer to your account."
				end
			elseif (tonumber(perkID) == 15) then -- Add a vehicle slot, max 10
				if (characterID and tonumber(characterID) > 0) then
					local currentMaxVehicles = tonumber( getElementData(targetPlayer, "maxvehicles") )
					
					if not currentMaxVehicles then 
						return false, "Error 103.1: Cannot load max vehicles."
					end
					
					if currentMaxVehicles >= 10 then
						return false, "You have reached the maximum of vehicle slots on this character"
					end
					
					currentMaxVehicles = currentMaxVehicles + 1
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "maxvehicles", currentMaxVehicles)
					exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
					exports.mysql:query_free("UPDATE `characters` SET `maxvehicles`='"..tostring(currentMaxVehicles).."' WHERE `id`='".. tostring(characterID) .."'")
					loadAllPerks(targetPlayer)
					outputChatBox("Perk activated: Increased max. vehicles to " .. currentMaxVehicles .. ".", targetPlayer)
					return true, "Success"
				end
			elseif (tonumber(perkID) == 18) then
				if (characterID and tonumber(characterID) > 0) then
					local parameters = {...}
					local number = tonumber(parameters[1])
					
					local valid, reason = checkValidNumber(number)
					if not valid then
						return false, reason
					end
					
					local mysqlQ = exports.mysql:query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber` = '"..number.."'")
					if exports.mysql:num_rows(mysqlQ) ~= 0 then
						return false, "Number is already taken"
					end
					
					if exports.global:giveItem(targetPlayer, 2, number) then
						exports.mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`, `boughtby`) VALUES ('"..tostring(number).."', '".. tostring(characterID) .."')")
						exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
						loadAllPerks(targetPlayer)
						
						triggerClientEvent(targetPlayer, "donation-system:phone:close", targetPlayer)
						outputChatBox("Perk activated: You received the phone with number " .. number .. ".", targetPlayer)
						return true, "Success"
					else
						return false, "Your inventory is full"
					end
				end
			else -- Handle the regular perks
				exports.mysql:query_free("INSERT INTO `donators` (accountID, perkID, perkValue, expirationDate) VALUES ('".. tostring(gameAccountID)  .."', '".. exports.mysql:escape_string(perkID) .."', '".. exports.mysql:escape_string(perkValue) .."', NOW() + interval " .. tostring(days).." day)")
				
				exports.mysql:query_free("UPDATE `accounts` SET `credits`=credits-".. tostring(points) .." WHERE `id`='".. tostring(gameAccountID) .."'")
				loadAllPerks(targetPlayer)
				exports.global:updateNametagColor(targetPlayer)
				
				outputChatBox("Perk activated", targetPlayer)
				return true, "Success"
			end
		end
	end
	return false, "Player is not logged in"
end 

function onCharacterSpawn(characterName, factionID)
	loadAllPerks(source)
	--[[		
	local togPMperk, togPMstatus = hasPlayerPerk(source, 1)
	if (togPMperk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pmblocked", tonumber(togPMstatus), false)
	end]]
				
	local togADperk, togADstatus = hasPlayerPerk(source, 2)
	if (togADperk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "disableAds", tonumber(togadminsADstatus) == 1, false)
	end
			
	local togNewsPerk, togNewsStatus = hasPlayerPerk(source, 3)
	if (togNewsPerk) then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "tognews", tonumber(togNewsStatus), false)
	end

	exports.global:updateNametagColor(source)
end
addEventHandler("onCharacterLogin", getRootElement(), onCharacterSpawn)

local packages = {
	--Template: Transfers, donPoints, Vehicle ID
	{ 1, 0, 0 },	 --$4.00	1 Stat Transfer
	{ 0, 5, 0 },     --$5.00    5 donPoints
	{ 1, 5, 0 },	 --$9.00	1 Stat Transfer, 5 donPoints
	{ 1, 15, 0 },	 --$13.00	1 Stat Transfer, 15 donPoints
	{ 2, 15, 0 },	 --$20.00	2 Stat Transfers, 15 donPoints
	{ 0, 20, 0 },	 --$20.00	20 donPoints
	{ 3, 20, 0 },	 --$25.00	3 Stat Transfers, 20 donPoints
	{ 4, 35, 0 },	 --$38.00	4 Stat Transfers, 35 donPoint
	{ 0, 50, 0 },	 --$40.00	50 donPoints
	{ 5, 65, 0 },	 --$70.00	5 Stat Transfers, 65 donPoints
	{ 10, 85, 0 },	 --$100.00	10 Stat Transfers, 85 donPoints
	{ 16, 200, 0 },  --$200.00	16 Stat Transfers, 200 donPoints
	{ 0, 0, 411 },   --$25      Infernus
    { 0, 0, 580 },   --$20      Stafford
    { 0, 0, 541 },   --$25      Bullet
    { 0, 0, 415},    --$17      Cheetah
    { 0, 0, 506},    --$17      Super GT
    { 0, 0, 451},    --$25      Turismo
    { 0, 0, 429},    --$17      Banshee
    { 5, 50, 0},    --$50      Promotional
	{ 0, 1, 448},  -- troll package
	{ 2, 10, 0}, -- birthday package
	{ 0, 0, 594}, -- fuck you package
}
	
function validateCode(code)
	if string.len(code) == 40 then
		local result, itemNumber, transation = checkCode(code)
		if result then
			if packages[itemNumber] then
				if packages[itemNumber][1] ~= 0 then --Stat Transfers
					exports.mysql:query_free("UPDATE accounts SET transfers = transfers + "..packages[itemNumber][1].." WHERE id = '"..getElementData(source, "account:id").."'")
				end
				if packages[itemNumber][2] ~= 0 then
					exports.mysql:query_free("UPDATE accounts SET credits = credits + "..packages[itemNumber][2].." WHERE id = '"..getElementData(source, "account:id").."'")
				end
				if packages[itemNumber][3] ~= 0 then
					local r = getPedRotation(source)
					local x, y, z = getElementPosition(source)
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
					local letter1 = string.char(math.random(65,90))
					local letter2 = string.char(math.random(65,90))
					local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
					local dimension = getElementDimension(source)
					local interior = getElementInterior(source)
					local var1, var2 = exports['vehicle-system']:getRandomVariant(id)
					local insertid = exports.mysql:query_insert_free("INSERT INTO vehicles SET model='" .. exports.mysql:escape_string(packages[itemNumber][3]) .. "', x='" .. exports.mysql:escape_string(x) .. "', y='" .. exports.mysql:escape_string(y) .. "', z='" .. exports.mysql:escape_string(z) .. "', rotx='0', roty='0', rotz='" .. exports.mysql:escape_string(r) .. "', color1='[ [ 0, 0, 0 ] ]', color2='[ [ 0, 0, 0 ]]', color3='[ [ 0, 0, 0 ] ] ', color4='[ [ 0, 0, 0 ] ]', faction='-1', owner='"..getElementData(source, "dbid").."', plate='" .. exports.mysql:escape_string(plate) .. "', currx='" .. exports.mysql:escape_string(x) .. "', curry='" .. exports.mysql:escape_string(y) .. "', currz='" .. exports.mysql:escape_string(z) .. "', currrx='0', currry='0', currrz='" .. exports.mysql:escape_string(r) .. "', locked=1, interior='" .. exports.mysql:escape_string(interior) .. "', currinterior='" .. exports.mysql:escape_string(interior) .. "', dimension='" .. exports.mysql:escape_string(dimension) .. "', currdimension='" .. exports.mysql:escape_string(dimension) .. "', tintedwindows='0',variant1="..var1..",variant2="..var2)
					exports['vehicle-system']:loadOneVehicle(insertid)
					exports['item-system']:giveItem(source, 3, insertid)
				end
				if itemNumber == 1 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("1 stat transfer has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 2 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("5 doPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 3 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("1 stat transfer and 5 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 4 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("1 stat transfer and 15 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 5 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("2 stat transfers and 15 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 6 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("20 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 7 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("3 stat transfers and 20 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 8 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("4 stat transfers and 35 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 9 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("50 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 10 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("5 stat transfers and 65 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 11 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("10 stat transfers and 85 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 12 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("16 stat transfers and 200 donPoints has been added to your account.", source, 0, 255, 0)
				elseif itemNumber == 13 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Infernus has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 14 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Stafford has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 15 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Bullet has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 16 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Cheetah has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 17 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Super GT has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 18 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Turismo has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 19 then
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
					outputChatBox("A Banshee has been added to your character. Don't forget to /park.", source, 0, 255, 0)
				elseif itemNumber == 20 then
					outputChatBox("You have successfully redeemed the promotional donation package!", source, 0, 255, 0)
				elseif itemNumber == 21 then
					outputChatBox("Uhh.. Enjoy that faggio.. I guess..", source, 0, 255, 0)
				elseif itemNumber == 22 then
					outputChatBox("Happy birthday! Here, have two free stat transfers and 10 donPoints :3", source, 0, 255, 0)
				else
					outputChatBox("You have successfully redeemed your donation package!", source, 0, 255, 0)
				end
				for k, value in ipairs(exports.global:getAdmins()) do
					if getElementData(value, "adminlevel") >= 5 then
						outputChatBox("[LEAD-ADM-WRN] " .. getPlayerName(source) .. " has succesfully redeemed package ID " .. itemNumber, value, 16, 130, 156)
					end
				end
				exports.mysql:query_free("UPDATE don_transactions SET validated = 1 WHERE transaction_id = '"..transation.."'")
			else
				outputDebugString("No Package Found?")
			end
		else
			--outputChatBox("This is not a valid code. test", source, 255, 0, 0)
			outputChatBox(itemNumber, source, 255, 0, 0)
		end
	else
		outputChatBox("This is not a valid code.", source, 255, 0, 0)
	end
end
addEvent("validateCode", true)
addEventHandler("validateCode", getRootElement(), validateCode)

local salt = "61e55578ef9402c969fd802d4499f66d0c9ef602"
function checkCode(theCode)
	if theCode then
		local result = exports.mysql:query("SELECT * FROM don_transactions")
		if result then
			local validated = false
			while true do
				local row = exports.mysql:fetch_assoc(result)
				if not row then break end
				local transactionID = row["transaction_id"]
				local hash =  string.upper(sha1(sha1(transactionID)..sha1(salt)))
				if hash == theCode then
					if row["validated"] == "0" then
						return true, tonumber(row["item_number"]), transactionID
					else
						return false, "That code has already been used.", nil
					end
				end
			end
			return false, "This code seems to be invalid. Please try again.", nil
		else
			outputDebugString("Fatel error validating a donation code. DON-002-MYSQL")
			return false, "Something went worng! Please try again later!", nil
		end
	else
		outputDebugString("Fatel error validating a donation code. DON-001-NOCODE")
		return false, "Something went worng! Please try again later!", nil
	end
end