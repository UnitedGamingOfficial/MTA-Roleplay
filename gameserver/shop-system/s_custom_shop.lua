--CUSTOM SHOP / MAXIME

local mysql = exports.mysql


local warningDebtAmount, limitDebtAmount, wageRate, updateWageInterval = nil
function fetchSettings()
	warningDebtAmount = tonumber(get( "warningDebtAmount" )) or 500
	limitDebtAmount = tonumber(get( "limitDebtAmount" )) or 1000
	wageRate = tonumber(get( "wageRate" )) or 5
	updateWageInterval = tonumber(get( "updateWageInterval" )) or 60
	
	setElementData(getRootElement(), "shop:warningDebtAmount", warningDebtAmount, true)
	setElementData(getRootElement(), "shop:limitDebtAmount", limitDebtAmount, true)
	setElementData(getRootElement(), "shop:wageRate", wageRate, true)
	setElementData(getRootElement(), "shop:updateWageInterval", updateWageInterval, true)
end
addEventHandler("onResourceStart", getResourceRootElement(), fetchSettings)

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if text then
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end

addEvent("shop:saveContactInfo", true)
function saveContactInfo(shopElement, contactInfo)
	local npcID = getElementData(shopElement,"dbid")
	local sucessfullyUpdateToSQL = false
	if mysql:query_fetch_assoc("SELECT `npcID` FROM `shop_contacts_info` WHERE `npcID` = '"..tostring(npcID).."'") then
		if mysql:query_free("UPDATE `shop_contacts_info` SET `sOwner`='"..tostring(contactInfo[1]):gsub("'","''").."', `sPhone`='"..tostring(contactInfo[2]):gsub("'","''").."', `sEmail`='"..tostring(contactInfo[3]):gsub("'","''").."', `sForum`='"..tostring(contactInfo[4]):gsub("'","''").."' WHERE `npcID`='"..tostring(npcID).."'") then
			sucessfullyUpdateToSQL = true
		end
	else
		if mysql:query_free("INSERT INTO `shop_contacts_info` SET `sOwner`='"..tostring(contactInfo[1]):gsub("'","''").."', `sPhone`='"..tostring(contactInfo[2]):gsub("'","''").."', `sEmail`='"..tostring(contactInfo[3]):gsub("'","''").."', `sForum`='"..tostring(contactInfo[4]):gsub("'","''").."', `npcID`='"..tostring(npcID).."'") then
			sucessfullyUpdateToSQL = true
		end
	end
	if sucessfullyUpdateToSQL then
		setElementData(shopElement, "sContactInfo", contactInfo, true)
	end
	--outputDebugString(tostring(sucessfullyUpdateToSQL).. tostring(contactInfo[2]):gsub("'","''"))
	return sucessfullyUpdateToSQL
end
addEventHandler("shop:saveContactInfo", getRootElement(), saveContactInfo)


addEvent("shop:addItemToCustomShop", true)
function addItemToCustomShop(element, slot, event, worldItem)
	local id, itemID, itemValue, item = nil

	if slot ~= -1 then
		item = exports['item-system']:getItems( source )[ slot ]
		itemID = item[1]
		itemValue = item[2]
	elseif worldItem then
		item = {}
		id = getElementData( worldItem, "id" )
		itemID = getElementData( worldItem, "itemID" )
		item[1] = itemID
		itemValue = getElementData( worldItem, "itemValue" )
		item[2] = itemValue
	else
		triggerClientEvent( source, event or "finishItemMove", source )
		return false
	end
	
	local dbid = getElementDimension(element)
	
	if exports.global:hasItem(source, 4, dbid) or exports.global:hasItem(source, 5, dbid) then
		if element then
			local npcID = getElementData(element, "dbid") or false
			triggerClientEvent( source, "shop:addItemToShop", source, source, item, slot, worldItem, npcID, element )
			triggerClientEvent( source, event or "finishItemMove", source )
			return true
		end
		outputChatBox("You must have key to be able to restock.",source, 255,0,0)
		return false 
	end
	
	triggerClientEvent( source, event or "finishItemMove", source )
	return false
end
addEventHandler("shop:addItemToCustomShop", getRootElement(), addItemToCustomShop)

function updateItemToShop(source, item, price, desc, npcID, slot, worldItem, shopElement)
	setElementData(source, "shop:NoAccess", true, true )
	item[1] = tonumber(item[1])
	item[2] = tostring(item[2])
	
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(source):gsub("_", " ")
	
	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "What about my wage??", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	
	
	if item[1] == 115 or item[1] == 116 then --weapons and ammo
		if getElementData( source, "license.gun" ) ~= 1 then
			storeKeeperSay(source, "Holyshit! Do we have license to sell this?!", getElementData(shopElement, "pedName"))
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
			return false
		end
	end
	
	if item[1] == 3 or item[1] == 4 or item[1] == 5 then --Keys , to prevent alt->alt
		exports.global:sendLocalText(source, "* "..pedName.." laughs at "..playerName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "Haha, do you really think people would buy a crappy key?", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	
	local itemName = exports["item-system"]:getItemName(item[1], item[2])
	if tonumber(price) < 0 then
		exports.global:sendLocalText(source, "* "..pedName.." doesn't agree with "..playerName.." on the price of a "..itemName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "One does not simply sell a thing for a negative price, yea?", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	local addToShop = mysql:query_free("INSERT INTO `shop_products` SET `pItemID`='"..tostring(item[1]).."', `pItemValue`='"..tostring(item[2]):gsub("'","''").."', `npcID`='"..tostring(npcID).."', `pPrice`='"..tostring(price).."', `pDesc`='"..tostring(desc):gsub("'","''").."' ") or false
	if addToShop then
		if slot == -1 and worldItem and isElement(worldItem) then 
			local id = getElementData( worldItem, "id" )
			mysql:query_free("DELETE FROM `worlditems` WHERE `id`='" .. id .. "'")
			destroyElement(worldItem)
		else
			exports['item-system']:takeItemFromSlot( source, slot )
		end
		
		exports.global:sendLocalMeAction(source, "hands "..pedName.." a "..itemName..".")
		local playerGender = getElementData(source,"gender")
		if playerGender == 0 then
			storeKeeperSay(source, "Alright, I got it, sir.", getElementData(shopElement, "pedName"))
		else
			storeKeeperSay(source, "Alright, I got it, ma'am.", getElementData(shopElement, "pedName"))
		end
		setElementData(source, "shop:NoAccess", false, true )
		local currentCap = tonumber(getElementData(shopElement, "currentCap")) + 1
		setElementData(shopElement, "currentCap", currentCap, true)
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return true
	end
end
addEvent("shop:updateItemToShop", true )
addEventHandler("shop:updateItemToShop", getRootElement(), updateItemToShop)

function editItemToShop(source, price, desc, proID, itemName, shopElement)
	setElementData(source, "shop:NoAccess", true, true )
	
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(source):gsub("_", " ")
	
	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "What about my wage??", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	
	if tonumber(price) < 0 then
		exports.global:sendLocalText(source, "* "..pedName.." doesn't agree with "..playerName.." on the price of a "..itemName..".", 255, 51, 102, 30, {}, true)
		storeKeeperSay(source, "One does not simply sell a thing for a negative price, yea?", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end 
	
	local check = mysql:query_fetch_assoc("SELECT `pID` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem = false
	if check then 
		checkingItem = check["pID"]
	end
	if checkingItem then
		local addToShop = mysql:query_free("UPDATE `shop_products` SET `pPrice`='"..tostring(price).."', `pDesc`='"..tostring(desc):gsub("'","''").."' WHERE `pID`='"..checkingItem.."'") or false
		if addToShop then
			exports.global:sendLocalMeAction(source, "discusses with "..pedName.." about a "..itemName..".")
			storeKeeperSay(source, "Sure..sure..", getElementData(shopElement, "pedName"))
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
		end
	else
		outputChatBox(" "..itemName.." is not existed in the store anymore.", source, 255,0, 0)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
	end
end
addEvent("shop:EditItemToShop", true )
addEventHandler("shop:EditItemToShop", getRootElement(), editItemToShop)

function takeOffProductFromShop(source, proID, itemI, itemV, itemName, shopElement)
	itemI = tonumber(itemI)
	itemV = tostring(itemV)
	setElementData(source, "shop:NoAccess", true, true )
	
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(source):gsub("_", " ")
	
	if tonumber(getElementData(shopElement, "sIncome")) < tonumber(getElementData(shopElement, "sPendingWage")) then
		storeKeeperSay(source, "What about my wage??", getElementData(shopElement, "pedName"))
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
		return false
	end
	
	
	if itemI == 115 or itemI == 116 then --weapons and ammo
		if getElementData( source, "license.gun" ) ~= 1 then
			storeKeeperSay(source, "Nah, sorry. I can't give you this unless you show me the license..", getElementData(shopElement, "pedName"))
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
			return false
		end
	end
	
	
	
	local check = mysql:query_fetch_assoc("SELECT `pID` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem = false
	if check then 
		checkingItem = check["pID"]
	end
	if checkingItem then 
		local success, reason = exports["item-system"]:giveItem( source, itemI, itemV, false, false )
		if success then
			exports.global:sendLocalText(source, "* "..playerName.." takes a "..itemName.." from "..pedName..".", 255, 51, 102, 30, {}, true)
			local playerGender = getElementData(source,"gender")
			if playerGender == 0 then
				storeKeeperSay(source, "There ya go, sir.", getElementData(shopElement, "pedName"))
			else
				storeKeeperSay(source, "There ya go, ma'ma.", getElementData(shopElement, "pedName"))
			end
		else
			outputChatBox(reason,source, 255, 0, 0)
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
			return false
		end
		
		local addToShop = mysql:query_free("DELETE FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
		if addToShop then
			
			setElementData(shopElement, "currentCap", tonumber(getElementData(shopElement, "currentCap")) - 1, true)
		
			setElementData(source, "shop:NoAccess", false, true )
			triggerClientEvent(source, "hideGeneralshopUI", source)
		end
	else
		outputChatBox(" "..itemName.." is not existed in the store anymore.", source, 255,0, 0)
		setElementData(source, "shop:NoAccess", false, true )
		triggerClientEvent(source, "hideGeneralshopUI", source)
	end
end
addEvent("shop:takeOffProductFromShop", true )
addEventHandler("shop:takeOffProductFromShop", getRootElement(), takeOffProductFromShop)

function customShopBuy(thePlayer,  proID, itemI, itemV, itemPrice, itemName, payByBank, shopElement)
	setElementData(thePlayer, "shop:NoAccess", true, true )
	itemI = tonumber(itemI)
	itemV = tostring(itemV)
	local logString = false
	local ownerNoti = nil
	local r = getRealTime()
	local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)
	
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(thePlayer):gsub("_", " ")
	
	
	
	if itemI == 115 or itemI == 116 then --weapons and ammo
		if getElementData( thePlayer, "license.gun" ) ~= 1 then
			storeKeeperSay(thePlayer, "Nah, sorry. I can't sell you this unless you can show me the license..", getElementData(shopElement, "pedName"))
			setElementData(thePlayer, "shop:NoAccess", false, true )
			triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
			return false
		end
	end
	
	local check = mysql:query_fetch_assoc("SELECT `pID`, `pPrice` FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
	local checkingItem, checkingPrice = false
	if check then 
		checkingItem = check["pID"]
		checkingPrice = check["pPrice"]
	end
	if checkingItem and checkingPrice and (tonumber(checkingPrice) == tonumber(itemPrice) ) then
		--outputDebugString(itemI.."-"..itemV)
		local success, reason = exports["item-system"]:giveItem( thePlayer, itemI, itemV, false, false )
		if success then
			local playerGender = getElementData(thePlayer,"gender")
			if not payByBank then
				playBuySound(shopElement)
				if playerGender == 0 then
					exports.global:sendLocalText(thePlayer, "* "..playerName.." takes out a couple of dollar notes from his wallet, hands it over to "..pedName..".", 255, 51, 102, 30, {}, true)
				else					
					exports.global:sendLocalText(thePlayer, "* "..playerName.." takes out a couple of dollar notes from her wallet, hands it over to "..pedName..".", 255, 51, 102, 30, {}, true)
				end
				
				if exports.global:takeMoney(thePlayer, itemPrice) then
					--
				else
					storeKeeperSay(thePlayer, "Well, I'm sorry but this seems not enough..", getElementData(shopElement, "pedName"))
					exports.global:takeItem( thePlayer, itemI, itemV ) 
					setElementData(thePlayer, "shop:NoAccess", false, true )
					triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
					return false
				end
				ownerNoti = "A customer bought a "..itemName.." for $"..exports.global:formatMoney(itemPrice).."."
				logString = "- "..timeString.." : A customer bought a "..itemName.." for $"..exports.global:formatMoney(itemPrice)..".\n"
			else
				playBuySound(shopElement)
				if playerGender == 0 then
					exports.global:sendLocalText(thePlayer, "* "..playerName.." takes out a credit card from his wallet, hands it over to "..pedName..".", 255, 51, 102, 30, {}, true)
				else
					exports.global:sendLocalText(thePlayer, "* "..playerName.." takes out a credit card from her wallet, hands it over to "..pedName..".", 255, 51, 102, 30, {}, true)
				end
				
				if takeBankMoney(thePlayer, itemPrice) then
					--
				else
					storeKeeperSay(thePlayer, "Well, I'm sorry but this seems not enough..", getElementData(shopElement, "pedName"))
					exports.global:takeItem( thePlayer, itemI, itemV ) 
					setElementData(thePlayer, "shop:NoAccess", false, true )
					triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
					return false
				end
				ownerNoti = getPlayerName(thePlayer):gsub("_", " ").."(Credit Card) bought a "..itemName.." for $"..exports.global:formatMoney(itemPrice).."."
				
				logString = "- "..timeString.." : "..getPlayerName(thePlayer):gsub("_", " ").."(Credit Card) bought a "..itemName.." for $"..exports.global:formatMoney(itemPrice)..".\n"
			end
			
			local additionalText = ""
			if payByBank then 
				additionalText = " and returns the credit card"
			end
			
			exports.global:sendLocalText(thePlayer, "* "..pedName.." gave "..playerName.." a "..itemName..additionalText..".", 255, 51, 102, 30, {}, true)
			
			storeKeeperSay(thePlayer, "Here you are. And..", getElementData(shopElement, "pedName"))
			if playerGender == 0 then
				storeKeeperSay(thePlayer, "Thank you sir, Have a nice day!", getElementData(shopElement, "pedName"))
			else
				storeKeeperSay(thePlayer, "Thank you ma'ma, Have a nice day!", getElementData(shopElement, "pedName"))
			end
			
		else
			outputChatBox(reason,thePlayer, 255, 0, 0)
			setElementData(thePlayer, "shop:NoAccess", false, true )
			triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
			return false
		end
		
		local addToShop = mysql:query_free("DELETE FROM `shop_products` WHERE `pID`='"..tostring(proID).."'") or false
		if addToShop then
			
			notifyAllShopOwners(shopElement, ownerNoti.." Come and collect the money when you got time ;)")
			--outputDebugString(ownerNoti)
			
			

			local previousSales = getElementData(shopElement, "sSales") or ""
			logString = string.sub(logString..previousSales,1,5000)
			setElementData(shopElement, "sSales", logString, true)
			mysql:query_free("UPDATE `shops` SET `sIncome` = `sIncome` + '" .. tostring(itemPrice) .. "', `sSales` = '"..logString:gsub("'","''").."' WHERE `id` = '"..tostring(getElementData(shopElement,"dbid")).."'")
			
			setElementData(shopElement, "sIncome", tonumber(getElementData(shopElement, "sIncome")) + tonumber(itemPrice), true)
			setElementData(shopElement, "currentCap", tonumber(getElementData(shopElement, "currentCap")) - 1, true)
			
			setElementData(thePlayer, "shop:NoAccess", false, true )
			triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
		end
	else
		outputChatBox(" "..itemName.." is not existed in the store anymore.", thePlayer, 255,0, 0)
		setElementData(thePlayer, "shop:NoAccess", false, true )
		triggerClientEvent(thePlayer, "hideGeneralshopUI", thePlayer)
	end
end
addEvent("shop:customShopBuy", true )
addEventHandler("shop:customShopBuy", getRootElement(), customShopBuy)

function solvePendingWage(thePlayer, shopElement)
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(thePlayer):gsub("_", " ")
	local sPendingWage = tonumber(getElementData(shopElement, "sPendingWage"))
	if sPendingWage > 0 then
		exports.global:sendLocalText(thePlayer, "* "..playerName.." gives "..pedName.." a couple of dollar notes.", 255, 51, 102, 30, {}, true)
		if exports.global:takeMoney(thePlayer, sPendingWage) then
			setElementData(shopElement, "sPendingWage", 0, true)
			mysql:query_free("UPDATE `shops` SET `sPendingWage`='0' WHERE id='"..tostring(getElementData(shopElement, "dbid")).."' ")
			exports.global:sendLocalText(thePlayer, "* "..pedName.." accepts the money from "..playerName..".", 255, 51, 102, 30, {}, true)
			storeKeeperSay(thePlayer, "Thank you boss!", getElementData(shopElement, "pedName"))
			--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bPayWage", thePlayer, false, shopElement)
			playPayWageSound(shopElement )
			return true
		else
			storeKeeperSay(thePlayer, "Well, sorry boss but this money is not enough..", getElementData(shopElement, "pedName"))
			--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bPayWage", thePlayer, true, shopElement)
			return false
		end
	else 
		--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bPayWage", thePlayer, false, shopElement)
		return false
	end
	return false
end
addEvent("shop:solvePendingWage", true )
addEventHandler("shop:solvePendingWage", getRootElement(), solvePendingWage)

function collectMoney(thePlayer, shopElement)
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_", " ")
	local playerName = getPlayerName(thePlayer):gsub("_", " ")
	local sPendingWage = tonumber(getElementData(shopElement, "sPendingWage"))
	local sIncome = tonumber(getElementData(shopElement, "sIncome"))
	local profit = sIncome - sPendingWage
	if profit >= 0 then
		if sIncome > 0 then
			if exports.global:giveMoney(thePlayer, sIncome) then
				setTimer(function ()
					exports.global:sendLocalText(thePlayer, "* "..pedName.." gives "..playerName.." a couple of dollar notes and a jar of coins.", 255, 51, 102, 30, {}, true)
					storeKeeperSay(thePlayer, "This is what we've got so far, boss. Keep it please.", getElementData(shopElement, "pedName"))
					setElementData(shopElement, "sIncome", 0, true)
					mysql:query_free("UPDATE `shops` SET `sIncome`='0' WHERE id='"..tostring(getElementData(shopElement, "dbid")).."' ")
					playCollectMoneySound(shopElement)
					--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bCollectProfit", thePlayer, false, shopElement)
					return true
				end, 3000, 1)
			end
		end
		
		if sPendingWage > 0 then
			if not solvePendingWage(thePlayer, shopElement) then
				--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bCollectProfit", thePlayer, true, shopElement)
				return false
			end
		end
	else
		if sPendingWage > 0 then
			if not solvePendingWage(thePlayer, shopElement) then
				--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bCollectProfit", thePlayer, true, shopElement)
				return false
			end
		end
		
		if sIncome > 0 then
			if exports.global:giveMoney(thePlayer, sIncome) then
				setTimer(function ()
					exports.global:sendLocalText(thePlayer, "* "..pedName.." gives "..playerName.." a couple of dollar notes and a jar of coins.", 255, 51, 102, 30, {}, true)
					storeKeeperSay(thePlayer, "This is what we've got so far, boss. Keep it please.", getElementData(shopElement, "pedName"))
					setElementData(shopElement, "sIncome", 0, true)
					mysql:query_free("UPDATE `shops` SET `sIncome`='0' WHERE id='"..tostring(getElementData(shopElement, "dbid")).."' ")
					playCollectMoneySound(shopElement)
					--triggerClientEvent(thePlayer, "shop:toggleGuiElement:bCollectProfit", thePlayer, false, shopElement)
					return true
				end, 3000, 1)
			end
		end
	end
	return false
end
addEvent("shop:collectMoney", true )
addEventHandler("shop:collectMoney", getRootElement(), collectMoney)

function takeBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	local money = getElementData(thePlayer, "bankmoney") - amount
	if money < 0 then
		outputChatBox("You don't have enough money in your bank account for this pal..", thePlayer, 0, 255, 0)
		return false
	else
		setElementData(thePlayer, "bankmoney", money, false)
		mysql:query_free("UPDATE characters SET bankmoney=" .. mysql:escape_string((tonumber(money) or 0)) .. " WHERE id=" .. mysql:escape_string(getElementData( thePlayer, "dbid" )))
		return true
	end
	return false
end

function expandBiz(shopID, capacity)
	mysql:query_free("UPDATE `shops` SET `sCapacity`='"..tostring(capacity).."' WHERE `id`='"..tostring(shopID).."'")
end
addEvent("shop:expand", true )
addEventHandler("shop:expand", getRootElement(), expandBiz)

function storeKeeperSay(thePlayer, content, pedName)
	local languageslot = getElementData(thePlayer, "languages.current")
	local language = getElementData(thePlayer, "languages.lang" .. languageslot)
	local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
	setTimer( function() 
		exports.global:sendLocalText(thePlayer, "["..languagename.."] "..(pedName or "The Storekeeper"):gsub("_"," ").." says: "..content, 255, 255, 255, 30, {}, true)
	end, 1000, 1)
end
addEvent("shop:storeKeeperSay", true )
addEventHandler("shop:storeKeeperSay", getRootElement(), storeKeeperSay)

function updateSaleLogs(thePlayer, shopID, content)
	--outputDebugString(shopID.."-"..content)
	content = string.sub(content, 1, 5000)
	local update = mysql:query_free("UPDATE `shops` SET `sSales`='"..tostring(content).."' WHERE `id`='"..tostring(shopID).."' ") or false
	if update and thePlayer then
		outputChatBox("Updated SaleLogs.", thePlayer, 0, 255,0)
	end
end
addEvent("shop:updateSaleLogs", true )
addEventHandler("shop:updateSaleLogs", getRootElement(), updateSaleLogs)

function notifyAllShopOwners(shopElement, content)
	local maxDebt = exports.global:formatMoney(limitDebtAmount)
	local warningDebt = exports.global:formatMoney(warningDebtAmount)
	local contentList = {
		{	-- 1. Ask for money when debt exceeds $1500
			"Hey boss, You owe me at least $"..warningDebt.." now, wanna pay me or not..?",
			"Well, I don't want to be a dick but you owe me at least $"..warningDebt.." now..",
			"Come here and solve the fucking wage.. You owe me at least $"..warningDebt.." now.",
			"If you don't come and solve my damn wage, I'll quit..",
			"Boss! solve my wage now!!!",
		},
		{ 	-- 2. Quit 
			"Hey boss, I quit my job, have fun with your empty shop..",
			"Bye bye boss, and sorry for your empty shop.. LOL",
			"I quit my job and you still owe me the fucking $"..maxDebt.."..",
			"Hey son of a bitch, you owe me fucking $"..maxDebt.." and don't wanna pay?? Say goodbye to your stuff then..",
			"Hi boss, I'm sorry that I have to quit my job, your business is just not profitable..",
		},
	}
	local contentTemp = nil
	if tonumber(content) then
		contentTemp = tonumber(content)
		content = contentList[content][math.random( 1, 5 )]
		if contentTemp == 0 then -- Temporarily disabled / MAXIME
			shopLeaveNoteOnLeave(shopElement, content)
		end
	end
	
	local pedName = (getElementData(shopElement, "pedName") or "The Storekeeper"):gsub("_"," ")
	setTimer(function()
		exports.global:sendLocalText(shopElement, "*"..pedName.." takes out a cellphone and starts sending text messages.", 255, 51, 102, 30, {}, true)
		
		local possibleOwners = getElementsByType("player")
		--local number = {"545683", "234233", "887563", "686831", "222323", "777887", "999870", "434666", "109583", "667233"}
		local effectedPlayers = 0
		for _, owner in ipairs(possibleOwners) do
			if exports.global:hasItem(owner, 2) then 
				local bizKey = getElementDimension(shopElement)
				local isBizOwner, bizName = isBizOwner(owner, bizKey)
				if isBizOwner then 
					local languageslot = getElementData(owner, "languages.current")
					local language = getElementData(owner, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					local ownerName = getPlayerName(owner):gsub("_", " ")
					
					exports.global:sendLocalText(owner, "*"..ownerName.." receives a text message.", 255, 51, 102, 30, {}, true)
					
					outputChatBox("["..languagename.."] SMS from "..pedName.." at "..bizName..": "..content, owner, 120, 255, 80)
					effectedPlayers = effectedPlayers + 1
				end
			end
		end
		if effectedPlayers == 0 then
			local r = getRealTime()
			local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)
			
			logString = "- "..timeString.." : "..content.." ("..pedName..")\n"
			local previousSales = getElementData(shopElement, "sSales") or ""
			logString = logString..previousSales
			logString = string.sub(logString, 1, 5000)
			setElementData(shopElement, "sSales", logString, true)
			mysql:query_free("UPDATE `shops` SET `sSales` = '"..logString:gsub("'","''").."' WHERE `id` = '"..tostring(getElementData(shopElement,"dbid")).."'")
		end
	end, 2000, 1)
end
addEvent("shop:notifyAllShopOwners", true )
addEventHandler("shop:notifyAllShopOwners", getRootElement(), notifyAllShopOwners)

function isBizOwner(player, bizKey)
	local key = bizKey
	local possibleInteriors = getElementsByType("interior")
	local isOwner = false
	local interiorName = false
	for _, interior in ipairs(possibleInteriors) do
		if tonumber(key) == getElementData(interior, "dbid") then
			interiorName = getElementData(interior, "name") or ""
			break		
		end
	end	
	
	if interiorName then
		if exports.global:hasItem(player, 4, key) or exports.global:hasItem(player, 5, key) then
			isOwner = true
		end
	else
		return false, false
	end

	return isOwner, interiorName
end

function resetPendingWage(thePlayer)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		local adminUsername = getElementData(thePlayer, "account:username")
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
	
		-- outputDebugString("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."")
		outputChatBox("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."", thePlayer)
	--	outputDebugString("------------START RESETING SHOP WAGES------------")
		outputChatBox("------------START RESETING SHOP WAGES------------", thePlayer)
		local count = 0
		local possibleShops = getElementsByType("ped")
		for _, shop in ipairs(possibleShops) do
			if getElementData(shop, "customshop") then
				local shopID = getElementData(shop, "dbid") or false
				if shopID then
					local sPendingWage = tonumber(getElementData(shop, "sPendingWage")) or 0
					local update = mysql:query_free("UPDATE `shops` SET `sPendingWage`='0' WHERE `id`='"..tostring(shopID).."' ") or false
					if update then
					-- 	outputDebugString("Shop ID#"..shopID.." Reset Staff Wage "..sPendingWage.." -> 0")
						outputChatBox("Shop ID#"..shopID.." Reset Staff Wage "..sPendingWage.." -> 0", thePlayer)
						if hiddenAdmin == 0 then
							notifyAllShopOwners(shop, "(("..adminTitle.." "..adminUsername.." has reset this shop's wage to $0.))")
						else
							notifyAllShopOwners(shop, "((A hidden admin has reset this shop's wage to $0.))")
						end
						count = count + 1
						setElementData(shop, "sPendingWage", 0 , true)
					else
						outputDebugString("Shop ID#"..shopID.." Reset Staff Wage Failed.")
						outputChatBox("Shop ID#"..shopID.." Reset Staff Wage Failed.", thePlayer)
					end
				end
			end
		end
		-- outputDebugString("------------RESET "..count.." SHOP WAGES------------")
		outputChatBox("------------RESET "..count.." SHOP WAGES------------", thePlayer)
			
		if hiddenAdmin == 0 then
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has reset "..count.." custom shop wages to $0.")
		else
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: A hidden admin has reset "..count.." custom shop wages to $0.")
		end
	end
end
addCommandHandler("resetshopwage", resetPendingWage)

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM worlditems AS e1 LEFT JOIN worlditems AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function shopLeaveNoteOnLeave(shopElement, content)
	local itemID = 72 -- note
	local itemValue = content
	local x, y, z = getElementPosition(shopElement)
	local dimension = getElementDimension(shopElement)
	local interior = getElementInterior(shopElement)
	local rz2 = -1
	local creator = 14652 -- The Storekeeper
	local protected = 0
	local modelid = exports['item-system']:getItemModel(itemID, itemValue)
	local rx, ry, rz, zoffset = exports['item-system']:getItemRotInfo(itemID)
	local id = SmallestID()
	local insert = mysql:query_free("INSERT INTO `worlditems` SET `id` = '"..tostring(id).."', `itemid`='"..tostring(itemID).."',`itemvalue`='"..tostring(itemValue):gsub("'","''").."', `x`='"..tostring(x).."', `y`='"..tostring(y).."', `z`='"..tostring(z).."', `dimension`='"..tostring(dimension).."', `interior`='"..tostring(interior).."', `rz`='"..tostring(rz2).."', `creator`='"..tostring(creator).."' ") or false
	
	if insert then
		local obj = exports["item-world"]:createItem(id, itemID, itemValue, modelid, x, y, z + ( zoffset or 0 ), rx, ry, rz+rz2)
		exports.pool:allocateElement(obj)
		setElementDimension(obj, dimension)
		setElementInterior(obj, interior)
		setElementData(obj, "creator", creator, false)
	end
end

function showCustomShopStatus(thePlayer)
--	outputDebugString("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."")
--	outputDebugString("------------START------------")
	if thePlayer then
		outputChatBox("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."", thePlayer)
		outputChatBox("------------START------------", thePlayer)
	end
	local count = 0
	local possibleShops = getElementsByType("ped")
	for _, shop in ipairs(possibleShops) do
		if getElementData(shop, "customshop") then
			local shopID = getElementData(shop, "dbid") or false
			if shopID then
				local sCapacity = tonumber(getElementData(shop, "sCapacity")) or 0
				local sPendingWage = tonumber(getElementData(shop, "sPendingWage")) or 0
				local sNewPendingWage = math.floor((sCapacity/wageRate)) + sPendingWage
				local sIncome = tonumber(getElementData(shop, "sIncome")) or 0
				local sProfit = sIncome-sNewPendingWage
				local currentCap = tonumber(getElementData(shop, "currentCap")) or 0
		
				-- outputDebugString("CShop ID#"..shopID..": Cap: "..currentCap.."/"..sCapacity..", Income: $"..sIncome..", Wage: $"..sPendingWage.." (->$"..sNewPendingWage.."), Profit: $"..sProfit..".")
				if thePlayer then
					outputChatBox("CShop ID#"..shopID..": Cap: "..currentCap.."/"..sCapacity..", Income: $"..sIncome..", Wage: $"..sPendingWage.." (->$"..sNewPendingWage.."), Profit: $"..sProfit..".", thePlayer)
				end
				count = count + 1
			end
		end
	end
	-- outputDebugString("------------SHOWED "..count.." CSHOPS------------")
	if thePlayer then
		outputChatBox("------------SHOWED "..count.." CSHOPS------------", thePlayer)
	end
end

function forceShowAllCustomShop(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		showCustomShopStatus(thePlayer)
	end
end
addCommandHandler("showallcustomshops", forceShowAllCustomShop)

function updateShopSalary(thePlayer)
	-- outputDebugString("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."")
	-- outputDebugString("------------START UPDATING SHOP WAGES------------")
	if thePlayer then
		outputChatBox("BIZ-SYSTEM SETTINGS: wageRate="..wageRate..", updateWageInterval="..updateWageInterval..", limitDebtAmount="..limitDebtAmount..", warningDebtAmount="..warningDebtAmount.."", thePlayer)
		outputChatBox("------------START UPDATING SHOP WAGES------------", thePlayer)
	end
	local count = 0
	local possibleShops = getElementsByType("ped")
	for _, shop in ipairs(possibleShops) do
		if getElementData(shop, "customshop") then
			local shopID = getElementData(shop, "dbid") or false
			if shopID then
				local sCapacity = tonumber(getElementData(shop, "sCapacity")) or 0
				local sPendingWage = tonumber(getElementData(shop, "sPendingWage")) or 0
				local sNewPendingWage = math.floor((sCapacity/wageRate)) + sPendingWage
				local sIncome = tonumber(getElementData(shop, "sIncome")) or 0
				local sProfit = sIncome-sNewPendingWage
				if sNewPendingWage >= warningDebtAmount then
					notifyAllShopOwners(shop, 1)
				end
				if (sProfit) >= (0-limitDebtAmount) then
					setElementData(shop, "sPendingWage", sNewPendingWage, true)
					local update = mysql:query_free("UPDATE `shops` SET `sPendingWage`='"..tostring(sNewPendingWage).."' WHERE `id`='"..tostring(shopID).."' ") or false
					if update then
						outputDebugString("Shop ID#"..shopID.." Updated Staff Wage "..sPendingWage.." -> "..sNewPendingWage)
						if thePlayer then
							outputChatBox("Shop ID#"..shopID.." Updated Staff Wage "..sPendingWage.." -> "..sNewPendingWage, thePlayer)
						end
					else
						outputDebugString("Shop ID#"..shopID.." Updated Staff Wage Failed.")
						if thePlayer then
							outputChatBox("Shop ID#"..shopID.." Updated Staff Wage Failed.", thePlayer)
						end
						count = count - 1
					end
				else
					local delete = mysql:query_free("DELETE FROM `shops` WHERE `id`='"..tostring(shopID).."' ") or false
					local delete2 = mysql:query_free("DELETE FROM `shop_products` WHERE `npcID`='"..tostring(shopID).."' ") or false
					if delete and delete2 then
						notifyAllShopOwners(shop, 2)
						outputDebugString("Shop ID#"..shopID.." Deleted itself due to the debt exceeds $"..exports.global:formatMoney(limitDebtAmount)..".")
						if thePlayer then
							outputChatBox("Shop ID#"..shopID.." Deleted itself due to the debt exceeds $"..exports.global:formatMoney(limitDebtAmount)..".", thePlayer)
						end
						destroyElement(shop)
						exports.global:sendMessageToAdmins("[BIZ-SYSTEM] Shop ID#"..shopID.." Deleted itself due to the debt exceeded $"..exports.global:formatMoney(limitDebtAmount)..".")
					else
						outputDebugString("Shop ID#"..shopID.." Failed to delete shop eventho the debt exceeded $"..exports.global:formatMoney(limitDebtAmount)..".")
						if thePlayer then
							outputChatBox("Shop ID#"..shopID.." Failed to delete shop eventho the debt exceeded $"..exports.global:formatMoney(limitDebtAmount)..".", thePlayer)
						end
						count = count - 1
					end
				end
				count = count + 1
			end
		end
	end
	outputDebugString("------------UPDATED "..count.." SHOP WAGES------------")
	if thePlayer then
		outputChatBox("------------UPDATED "..count.." SHOP WAGES------------", thePlayer)
		local adminUsername = getElementData(thePlayer, "account:username")
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		
		if hiddenAdmin == 0 then
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has forced "..count.." custom shops to take wage.")
		else
			exports.global:sendMessageToAdmins("[BIZ-SYSTEM]: A hidden admin has forced "..count.." custom shops to take wage.")
		end
	end
end

function fourceUpdateShopSalary(thePlayer)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		updateShopSalary(thePlayer)
	end
end
addCommandHandler("forceupdateshopwage", fourceUpdateShopSalary)

local TimerUpdateShopSalary = nil
function startResource()
	showCustomShopStatus()
	if TimerUpdateShopSalary and isTimer(TimerUpdateShopSalary) then 
		killTimer(TimerUpdateShopSalary)
	end
	TimerUpdateShopSalary = setTimer(updateShopSalary, 60000*updateWageInterval, 0) 
end
addEventHandler("onResourceStart", getResourceRootElement(), startResource)

function playPayWageSound(shopElement)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(shopElement)
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 20 then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(shopElement) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer, "shop:playPayWageSound", shopElement)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	return true, affectedPlayers
end

function playCollectMoneySound(shopElement)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(shopElement)
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 20 then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(shopElement) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer, "shop:playCollectMoneySound", shopElement)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	return true, affectedPlayers
end

function playBuySound(shopElement)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(shopElement)
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 20 then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(shopElement) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer, "shop:playBuySound", shopElement)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	return true, affectedPlayers
end