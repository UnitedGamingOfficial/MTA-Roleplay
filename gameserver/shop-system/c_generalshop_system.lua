--CUSTOM SHOP / MAXIME

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

wGeneralshop, iClothesPreview, bShrink  = nil

shop = nil
shop_type = nil

BizNoteFont = guiCreateFont( ":interior-system/BizNote.ttf", 30 )
BizNoteFont18 = guiCreateFont( ":interior-system/BizNote.ttf", 18 )
BizNoteFont2 = guiCreateFont( "seguisb.ttf", 11 )

warningDebtAmount = getElementData(getRootElement(), "shop:warningDebtAmount") or 500
limitDebtAmount = getElementData(getRootElement(), "shop:limitDebtAmount") or 1000
wageRate = getElementData(getRootElement(), "shop:wageRate") or 5

coolDownSend = 1 -- Minutes

-- returns [item index in current shop], [actual item]
function getSelectedItem( grid )
	if grid then
		local row, col = guiGridListGetSelectedItem( grid )
		if row > -1 and col > -1 then
			local index = tonumber( guiGridListGetItemData( grid, row, 1 ) ) -- 1 = cName
			if index then
				local item = getItemFromIndex( shop_type, index )
				return index, item
			end
		end
	end
end

-- creates a shop window, hooray.
function showGeneralshopUI(shop_type, race, gender, discount, products)
	local ped = source
	if not wCustomShop and not wAddingItemsToShop and not wGeneralshop and not getElementData(getLocalPlayer(), "shop:NoAccess" ) then
		if not products then
			shop = g_shops[ shop_type ]

			if not shop or #shop == 0 then
				outputChatBox("This is no store. Go away.")
				return
			end
			_G['shop_type'] = shop_type
			updateItems( shop_type, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
			
			--setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
			
			local screenwidth, screenheight = guiGetScreenSize()
			
			local Width = 500
			local Height = 350
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2

			
			wGeneralshop = guiCreateWindow( X, Y, Width, Height, shop.name, false )
			guiWindowSetSizable(wGeneralshop,false)
			
			local lInstruction = guiCreateLabel( 0, 20, 500, 15, "Double click on an item to buy it.", false, wGeneralshop )
			guiLabelSetHorizontalAlign( lInstruction,"center" )
			
			local lIntro = guiCreateLabel( 0, 40, 500, 15, shop.description, false, wGeneralshop )
			guiLabelSetHorizontalAlign( lIntro,"center" )
			guiBringToFront (lIntro)
			guiSetFont ( lIntro, "default-bold-small" )
			
			local iImage =  guiCreateStaticImage ( 400, 20, 90, 80,"images/" .. shop.image, false,wGeneralshop )
			
			tabpanel = guiCreateTabPanel ( 15, 60, 470, 240, false,wGeneralshop )
			-- create the tab panel with all shoppy items
			local counter = 1
			for _, category in ipairs( shop ) do
				local tab = guiCreateTab( category.name, tabpanel )
				local grid =  guiCreateGridList ( 0.02, 0.05, 0.96, 0.9, true, tab)
				
				local cName = guiGridListAddColumn( grid, "Name", 0.25 )
				local cPrice = guiGridListAddColumn( grid, "Price", 0.1 )
				local cDescription = guiGridListAddColumn( grid, "Description", 0.62 )
				
				local hasSkins = false
				for _, item in ipairs( category ) do
					local row = guiGridListAddRow( grid )
					guiGridListSetItemText( grid, row, cName, item.name, false, false )
					guiGridListSetItemData( grid, row, cName, tostring( counter ) )
					
					guiGridListSetItemText( grid, row, cPrice, "$" .. tostring(exports.global:formatMoney(math.ceil(discount * item.price))), false, false )
					guiGridListSetItemText( grid, row, cDescription, item.description or "", false, false )
					
					if item.itemID == 16 then
						hasSkins = true
					end
					
					counter = counter + 1
				end
				
				if hasSkins then -- event handler for skin preview
					addEventHandler( "onClientGUIClick", grid, function( button, state )
						if button == "left" then
							local index, item = getSelectedItem( source )
							
							if iClothesPreview then
								destroyElement(iClothesPreview)
								iClothesPreview = nil
							end
							
							if item.itemID == 16 then
								iClothesPreview = guiCreateStaticImage( 320, 20, 100, 100, ":account-system/img/" .. ("%03d"):format( item.itemValue or 1 ) .. ".png", false, source)
							end
						end
					end, false )
				end
				
				addEventHandler( "onClientGUIDoubleClick", grid, function( button, state )
					if button == "left" then
						local index, item = getSelectedItem( source )
						if index then
							triggerServerEvent( "shop:buy", ped, index )
						end
					end
				end, false )
			end
			
			guiSetInputEnabled(true)
			guiSetVisible(wGeneralshop, true)
			
			bClose = guiCreateButton(200, 315, 100, 25, "Close", false, wGeneralshop)
			addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
		else
			--CUSTOM SHOP / MAXIME
			guiSetInputEnabled(true)
			showCursor(true)
		
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 432
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			local isClientBizOwner, bizName, bizNote = isBizOwner(getLocalPlayer())
			
			wCustomShop = guiCreateWindow(X,Y,Width,Height,bizName.." - Custom Shop v1.3[16/5/13] © Maxime | UnitedGaming",false)
			guiWindowSetSizable(wCustomShop,false)
			
			local shopTabPanel = guiCreateTabPanel(9,26,738,396,false,wCustomShop)
			local tProducts = guiCreateTab ( "Products" , shopTabPanel )
			local gProducts = guiCreateGridList ( 0, 0, 1, 0.9, true, tProducts)
			
			local lWelcomeText = guiCreateLabel(0,0.89,1,0.1,'"Welcome to '..bizName..'!" Double click on an item to buy it!',true,tProducts)
			
			guiLabelSetVerticalAlign(lWelcomeText,"center")
			guiLabelSetHorizontalAlign(lWelcomeText,"center",false)
			guiSetFont(lWelcomeText, BizNoteFont18)
			
			local colName = guiGridListAddColumn(gProducts,"Name",0.2)
			local colAmount = guiGridListAddColumn(gProducts,"Details",0.2)
			local colPrice = guiGridListAddColumn(gProducts,"Price",0.1)
			local colDesc = guiGridListAddColumn(gProducts,"Description",0.36)
			--local colDate = guiGridListAddColumn(gProducts,"Published Date",0.15)
			local colProductID = guiGridListAddColumn(gProducts,"Product ID",0.1)
			local currentCap = 0
			for _, record in ipairs(products) do
				local row = guiGridListAddRow(gProducts)
				local itemName = exports["item-system"]:getItemName( tonumber(record[2]), tostring(record[3]) ) 
				local itemValue = exports["item-system"]:getItemValue( tonumber(record[2]), tostring(record[3]) )
				local itemPrice = "$"..exports.global:formatMoney(math.ceil(tonumber(record[5] or 0))) or false
				guiGridListSetItemText(gProducts, row, colName, itemName or "Unknown", false, false)
				guiGridListSetItemText(gProducts, row, colAmount, itemValue or "Unknown", false, false)
				guiGridListSetItemText(gProducts, row, colPrice, itemPrice, false, true)
				guiGridListSetItemText(gProducts, row, colDesc, record[4] or "Unknown", false, false)
				--guiGridListSetItemText(gProducts, row, colDate, record[6], false, false)
				guiGridListSetItemText(gProducts, row, colProductID, record[7] or "Unknown", false, true)
				currentCap = currentCap + 1
				setElementData(ped, "currentCap", currentCap, true)
			end
			
			
			
			local bClose, bSend, tBizManagement, tGoodBye = nil
			
			if isClientBizOwner then
				----------------------START EDIT CONTACT-------------------------------------------------------
				tGoodBye = guiCreateTab ( "Edit Contact Info" , shopTabPanel )
				
				local lTitle1 = guiCreateLabel(11,19,716,56,("Edit Contact Info - "..bizName),false,tGoodBye)
					--guiLabelSetVerticalAlign(lTitle1[1],"center")
					guiLabelSetHorizontalAlign(lTitle1,"center",false)
					guiSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = guiCreateLabel(11,75,100,20,"- Owner:",false,tGoodBye)
				local eOwner = guiCreateEdit(111,75,600,20,sOwner,false,tGoodBye)
				local lPhone = guiCreateLabel(11,95,100,20,"- Phone Number:",false,tGoodBye)
				local ePhone = guiCreateEdit(111,95,600,20,sPhone,false,tGoodBye)
				local lEmail = guiCreateLabel(11,115,100,20,"- Email Address:",false,tGoodBye)
				local eEmail = guiCreateEdit(111,115,600,20,sEmail,false,tGoodBye)
				local lForums = guiCreateLabel(11,135,100,20,"((Forums Name)):",false,tGoodBye)
				local eForums = guiCreateEdit(111,135,600,20,sForum,false,tGoodBye)
				
				guiEditSetMaxLength ( eOwner, 100 )
				guiEditSetMaxLength ( ePhone, 100 )
				guiEditSetMaxLength ( eEmail, 100 )
				guiEditSetMaxLength ( eForums, 100 )
				
				local lBizNote = guiCreateLabel(0.01,0.5,1,0.1,"- Biz Note:",true,tGoodBye)
				
				local eBizNote = guiCreateEdit ( 0.01, 0.58, 0.98, 0.1,bizNote, true, tGoodBye)
				guiEditSetMaxLength ( eBizNote, 100 )
				
				bSend = guiCreateButton(0.01, 0.88, 0.49, 0.1, "Save", true, tGoodBye)	
				local contactName, contactContent = nil
				
				addEventHandler( "onClientGUIClick", bSend, function()
					if guiGetText(eBizNote) ~= "" then
						triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(),getLocalPlayer(), "setbiznote", guiGetText(eBizNote))
					end
					
					if guiGetText(ePhone) ~= "" and not tonumber(guiGetText(ePhone)) then
						guiSetText(ePhone, "Invalid Number")
					else
						triggerServerEvent("shop:saveContactInfo", getLocalPlayer(), ped, {guiGetText(eOwner),guiGetText(ePhone),guiGetText(eEmail),guiGetText(eForums)})
						hideGeneralshopUI()
					end
					
					
				end, false ) 
			
				bClose = guiCreateButton(0.5, 0.88, 0.49, 0.1, "Close", true, tGoodBye)
				addEventHandler( "onClientGUIClick", bClose, function ()
					hideGeneralshopUI()
				end, false )
			
			
				----------------------START BIZ MANAGEMENT-------------------------------------------------------
				local GUIEditor_Memo = {}
				local GUIEditor_Label = {}
				
				tBizManagement = guiCreateTab ( "Business Management & Exit" , shopTabPanel )
				
				GUIEditor_Label[1] = guiCreateLabel(11,19,716,56,"Business Management - "..bizName or "",false,tBizManagement)
					--guiLabelSetVerticalAlign(GUIEditor_Label[1],"center")
					guiLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)
					guiSetFont(GUIEditor_Label[1], BizNoteFont)
			
				local sCapacity = tonumber(getElementData(ped, "sCapacity")) or 0
				local sIncome = tonumber(getElementData(ped, "sIncome")) or 0
				local sPendingWage = tonumber(getElementData(ped, "sPendingWage")) or 0
				local sSales = getElementData(ped, "sSales") or ""
				local sProfit = sIncome-sPendingWage
				
				guiSetText(lWelcomeText,'"Welcome boss! How are you doing?" || '..currentCap..'/'..sCapacity..' products , Total Income: $'..exports.global:formatMoney(sIncome)..'.')
				
				GUIEditor_Label[2] = guiCreateLabel(11,75,716,20,"- Capacity: "..sCapacity.." (Max number of products the shop can hold, you have to pay $1/hour more for 5 additional products)",false,tBizManagement)
				GUIEditor_Label[3] = guiCreateLabel(11,95,716,20,"- Income: $"..exports.global:formatMoney(sIncome),false,tBizManagement)
				GUIEditor_Label[4] = guiCreateLabel(11,115,716,20,"- Staff Payment: $"..exports.global:formatMoney(sPendingWage).." ($"..exports.global:formatMoney(sCapacity/wageRate).."/hour)",false,tBizManagement)
				GUIEditor_Label[5] = guiCreateLabel(11,135,716,20,"- Profit: $"..exports.global:formatMoney(sProfit),false,tBizManagement)
				GUIEditor_Label[6] = guiCreateLabel(11,155,57,19,"- Sales: ",false,tBizManagement)
				GUIEditor_Memo[1] = guiCreateMemo(11,179,498,184,sSales,false,tBizManagement)
				guiMemoSetReadOnly(GUIEditor_Memo[1], true)
				
				if sProfit < 0 then
					guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
					if sProfit < (0 - warningDebtAmount) then 
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (WARNING: If you're in debt of more than $"..exports.global:formatMoney(limitDebtAmount)..", your staff will quit job)." )
						guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
						
					end
				elseif sProfit == 0 then
				else
					if sProfit < 500 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Average).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 255, 0)
					elseif sProfit >= 500 and sProfit < 1000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Good!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 245, 0)
					elseif sProfit >= 1000 and sProfit < 2000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Very Good!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 235, 0)
					elseif sProfit >= 2000 and sProfit < 4000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Excellent!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 225, 0)
					elseif sProfit >= 4000 and sProfit < 8000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Outstanding!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 215, 0)
					elseif sProfit >= 8000 and sProfit < 20000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Awesome!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 205, 0)
					elseif sProfit >= 20000 then
						guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.global:formatMoney(sProfit).." (Mother of business!!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 195, 0)
					end
				end
				---------------------
				local bExpand = guiCreateButton(0.695, 0.48, 0.15, 0.1, "Expand Biz", true, tBizManagement)
				guiSetFont(bExpand, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bExpand, function ()
					setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) + 1, true)
					triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
					guiSetText(GUIEditor_Label[2], "- Capacity: "..tostring(getElementData(ped, "sCapacity")).." (Max number of products the shop can hold, you have to pay $1/hour more for "..wageRate.." additional products)")
					guiSetText(GUIEditor_Label[4] , "- Staff Payment: $"..exports.global:formatMoney(sPendingWage).." ($"..exports.global:formatMoney(getElementData(ped, "sCapacity")/wageRate).."/hour)")
					if tonumber(getElementData(ped, "sCapacity")) <= tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) <= 10 then
						guiSetEnabled(bShrink, false)
					else
						guiSetEnabled(bShrink, true)
					end
				end, false )
				-------------------------
				bShrink = guiCreateButton(0.845, 0.48, 0.15, 0.1, "Shrink Biz", true, tBizManagement)
				guiSetFont(bShrink, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bShrink, function ()
					if tonumber(getElementData(ped, "sCapacity")) > tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) > 10 then
						guiSetEnabled(bShrink, true)
						setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) - 1, true)
						triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
						guiSetText(GUIEditor_Label[2], "- Capacity: "..tostring(getElementData(ped, "sCapacity")).." (Max number of products the shop can hold, you have to pay $1/hour more for "..wageRate.." additional products)")
						guiSetText(GUIEditor_Label[4] , "- Staff Payment: $"..exports.global:formatMoney(sPendingWage).." ($"..exports.global:formatMoney(getElementData(ped, "sCapacity")/wageRate).."/hour)")
					else
						guiSetEnabled(bShrink, false)
					end
				end, false )
				---------------------------
				local bClearSaleLogs = guiCreateButton(0.695, 0.58, 0.3, 0.1, "Clear SaleLogs", true, tBizManagement)
				guiSetFont(bClearSaleLogs, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bClearSaleLogs, function ()
					guiSetText(GUIEditor_Memo[1],"")
					setElementData(ped, "sSales", "", true)
					triggerServerEvent("shop:updateSaleLogs", getLocalPlayer(), getLocalPlayer(), getElementData(ped, "dbid") , "")
				end, false )
				
				--------------------------------
				
				local bPayWage = guiCreateButton(0.695, 0.68, 0.3, 0.1, "Pay Staff", true, tBizManagement)
				guiSetFont(bPayWage, BizNoteFont2)
				if sPendingWage > 0 then
					addEventHandler( "onClientGUIClick", bPayWage, function ()
						guiSetVisible(wCustomShop, false)
						triggerServerEvent("shop:solvePendingWage", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					guiSetEnabled(bPayWage, false)
				end
				
				--------------------------------
				local bCollectProfit = guiCreateButton(0.695, 0.78, 0.3, 0.1, "Collect Profit", true, tBizManagement)
				guiSetFont(bCollectProfit, BizNoteFont2)
				if (sPendingWage > 0) or (sIncome > 0) then
					addEventHandler( "onClientGUIClick", bCollectProfit, function ()
						guiSetVisible(wCustomShop, false)
						triggerServerEvent("shop:collectMoney", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					guiSetEnabled(bCollectProfit, false)
				end
				
				bClose = guiCreateButton(0.695, 0.88, 0.3, 0.1, "Close", true, tBizManagement)
				guiSetFont(bClose, BizNoteFont2)
			else
				-----------------------------------------CUSTOMER PANEL-----------------------------------------------------------------
				
				tGoodBye = guiCreateTab ( "Contact Info & Exit" , shopTabPanel )
				
				local lTitle1 = guiCreateLabel(11,19,716,56,(bizName.." - See you again!"),false,tGoodBye)
					--guiLabelSetVerticalAlign(lTitle1[1],"center")
					guiLabelSetHorizontalAlign(lTitle1,"center",false)
					guiSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = guiCreateLabel(11,75,716,20,"- Owner: "..sOwner.."",false,tGoodBye)
				local lPhone = guiCreateLabel(11,95,716,20,"- Phone Number: "..sFormatedPhone.."",false,tGoodBye)
				local lEmail = guiCreateLabel(11,115,716,20,"- Email Address: "..sEmail.."",false,tGoodBye)
				local lForums = guiCreateLabel(11,135,716,20,"- ((Forums Name: "..sForum.."))",false,tGoodBye)
				local lGuide = guiCreateLabel(0.01,0.5,1,0.1,"        'Hey, I can pass your message to my bosses if you want': ",true,tGoodBye)
				
				local eBargainName = guiCreateEdit ( 0.01, 0.58, 0.19, 0.1,"your identity", true, tGoodBye)
				addEventHandler( "onClientGUIClick", eBargainName, function()
					guiSetText(eBargainName, "")
				end, false )
				
				local eContent = guiCreateEdit ( 0.2, 0.58, 0.79, 0.1,"content", true, tGoodBye)
				guiEditSetMaxLength ( eContent, 95 )
				addEventHandler( "onClientGUIClick", eContent, function()
					guiSetText(eContent, "")
				end, false )
				
				bSend = guiCreateButton(0.01, 0.88, 0.49, 0.1, "Send", true, tGoodBye)	
				local contactName, contactContent = nil
				if not getElementData(getLocalPlayer(), "shop:coolDown:contact") then
					guiSetText(bSend, "Send")
					guiSetEnabled(bSend, true)
				else
					guiSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
					guiSetEnabled(bSend, false)
				end	
				
				addEventHandler( "onClientGUIClick", bSend, function()
					contactContent = guiGetText(eContent)
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = guiGetText(eBargainName):gsub("_"," ") 
						if contactName == "" or contactName == "your identity" then 
							contactName = "A Customer" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Mr. "..contactName
							else
								contactName = "Mrs. "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Hey boss! Read this '"..contactContent.."', said "..contactName..".")
						
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								guiSetText(bSend, "Send")
								guiSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) 
						
						guiSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
						guiSetEnabled(bSend, false)
						
						guiSetText(eContent, "")
					end 
					
					
					
				end, false ) 
				
				addEventHandler( "onClientGUIAccepted", eContent,function()
					contactContent = guiGetText(eContent):gsub("_"," ") 
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = guiGetText(eBargainName) 
						if contactName == "" or contactName == "your identity" then 
							contactName = "A Customer" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Mr. "..contactName
							else
								contactName = "Mrs. "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Hey boss! Read this '"..contactContent.."', said "..contactName..".")
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								guiSetText(bSend, "Send")
								guiSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) -- 5 minutes
						
						guiSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
						guiSetEnabled(bSend, false)
						
						guiSetText(eContent, "")
						
					end 
					
					
				end, false )
			
				bClose = guiCreateButton(0.5, 0.88, 0.49, 0.1, "Close", true, tGoodBye)
			end
			
			addEventHandler( "onClientGUIClick", bClose, function ()
				guiSetVisible(wCustomShop, false)
				hideGeneralshopUI()
			end, false )
			
			addEventHandler("onClientGUIDoubleClick", gProducts, function () 
				if products then 
					local row, col = guiGridListGetSelectedItem(gProducts)
					if (row==-1) or (col==-1) then
						--do nothing
					else  
						local proID = tostring(guiGridListGetItemText(gProducts, row, 5))
						if isClientBizOwner then
							triggerEvent("shop:ownerProductView", root,  products, proID, ped)
						else
							triggerEvent("shop:customShopBuy", root,  products, proID, ped)
						end
						
					end
				end
			end, false)
			
		end
	end
end
addEvent("showGeneralshopUI", true )
addEventHandler("showGeneralshopUI", getResourceRootElement(), showGeneralshopUI)

function isBizOwner(player)
	local key = getElementDimension(player)
	local possibleInteriors = getElementsByType("interior")
	local isOwner = false
	local interiorName = false
	local interiorBizNote = nil
	for _, interior in ipairs(possibleInteriors) do
		if tonumber(key) == getElementData(interior, "dbid") then
			interiorName = getElementData(interior, "name") or ""
			interiorBizNote = getElementData(interior, "business:note") or ""
			break		
		end
	end	
	
	if interiorName then
		if exports.global:hasItem(player, 4, key) or exports.global:hasItem(player, 5, key) then
			isOwner = true
		end
	else
		return false, false, false
	end

	return isOwner, interiorName, interiorBizNote
end


function hideGeneralshopUI()
	
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	guiSetInputEnabled(false)
	showCursor(false)
	if wGeneralshop then
		destroyElement(wGeneralshop)
		wGeneralshop = nil
	end
	if wCustomShop then
		destroyElement(wCustomShop)
		wCustomShop = nil
	end
	closeOwnerProductView()
	closeAddingItemWindow()
	closeCustomShopBuy()
end
addEvent("hideGeneralshopUI", true )
addEventHandler("hideGeneralshopUI", getRootElement(), hideGeneralshopUI)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function() 
	if wGeneralshop ~= nil then 
		hideGeneralshopUI() 
	end 
	setElementData(getLocalPlayer(), "shop:NoAccess", false, true)
	setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
end)
