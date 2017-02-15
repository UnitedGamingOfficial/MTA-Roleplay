--[[
x Debug for drug splitting
x Made by Maxime for United Gaming Roleplay
]]

local splittableItems = {[30]=" gram(s)", [31]=" gram(s)", [32]=" gram(s)", [33]=" gram(s)", [34]=" gram(s)", [35]=" ml(s)", [36]=" tablet(s)", [37]=" gram(s)", [38]=" gram(s)", [39]=" gram(s)", [40]=" ml(s)", [41]=" tab(s)", [42]=" shroom(s)", [43]=" tablet(s)", [134] = " money"}

function splitItem (player, cmd, itemID, amount)
	--if exports.global:isPlayerAdmin(player) then
		local itemID = tonumber(itemID)
		local amount = tonumber(amount)
		if itemID and amount then
			if (itemID%1 ~= 0) or (amount%1 ~= 0) then
				outputChatBox("Item ID and Amount must be integer, like 1,2,3,..", player, 255, 0, 0, false)
				return false
			end
			if itemID > 0 and splittableItems[itemID] then
				local isPlayerHasItem, itemSlot, itemValue, noIdeaWhatItis = exports.global:hasItem(player, itemID)
				if isPlayerHasItem then
					local itemValue2 = tonumber((tostring(itemValue):match("%d+")))
					--outputDebugString(exports["item-system"]:getItemName( itemID, itemValue ).." -"..itemValue)
					if not itemValue2 then
						outputChatBox("Your drug item is bugged. Please report to admin to be spawned a new one", player,255,0,0)
						return false
					end
					--outputDebugString(itemValue2)
					--local itemName = exports.global:getItemName(itemID, itemValue)
					if amount > 0 then
						if amount <= itemValue2 then
							if amount == itemValue2 then
								return false
							end
							local itemRemaining = itemValue2 - amount
							-- outputDebugString("itemID = "..itemID)
							-- outputDebugString("itemValue = "..itemValue)
							-- outputDebugString("itemValue2 = "..itemValue2)
							-- outputDebugString("amount = "..amount)
							-- outputDebugString("itemRemaining = "..itemRemaining)
							
							if exports.global:takeItem(player, itemID, itemValue) and giveItem( player, itemID, amount, false , true) and giveItem( player, itemID, itemRemaining,false ,true) then
								--It's all good
								return true
							else
								outputChatBox("Something when wrong when the system trying to split your item. Please report this to admins.", player, 255, 0, 0, false)
								return false
							end
						else
							outputChatBox("The amount cannot be higher than what you have in your inventory.", player, 255, 0, 0, false)
						end
					else
						outputChatBox("Amount must be over zero.", player, 255, 0, 0, false)
					end
				else
					outputChatBox("You do not have that item in your inventory. Type '/splits' for a list of splittable items.", player, 255, 0, 0, false)
				end
			else
				outputChatBox("ID '" .. itemID .. "' is not a splittable item. Type '/splits' for a list of splittable items.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("SYNTAX: /" .. cmd .. " [Item ID] [Amount]", player, 255, 194, 14, false)
			outputChatBox("Type '/splits' for a list of splittable items.", player, 255, 194, 14, false)
		end
	--end
end
addCommandHandler("split",splitItem, false, false )
addEvent("drugsystem:splitItem", true)
addEventHandler("drugsystem:splitItem", getRootElement(), splitItem)

function listSplittable(thePlayer, commandName)
	outputChatBox("List of splittable item's names & IDs:",thePlayer, 255, 194, 14)
	for itemID = 1, 150 do
		local itemName = false
		itemName = getItemName(itemID)
		if itemName and splittableItems[itemID] then
			outputChatBox("ID #"..tostring(itemID).." - "..itemName..".",thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("splits",listSplittable, false, false )