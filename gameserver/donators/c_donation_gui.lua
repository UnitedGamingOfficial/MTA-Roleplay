local wDonation,lSpendText,lActive,lAvailable, bClose,f7state, bRedeem = nil
local lItems = {}
local bItems = { }


local function checkF7( )
	if not f7state and getKeyState( "f7" ) then
		closeDonationGUI( )
	else
		f7state = getKeyState( "f7" )
	end
end

function openDonationGUI(obtained, available, credits)
	if wDonation ~= nil then
		return false
	end

	wDonation = guiCreateWindow(0.20, 0.20, 0.6, 0.6, "Spend donPoints", true)
	guiWindowSetSizable(wDonation, false)
		
	lSpendText = guiCreateLabel(0.015, 0.05, 0.5, 0.15, "Points to spend: " .. tostring(credits) .." donPoints", true, wDonation)
	guiSetFont(lSpendText, "default-bold-small")
	
	bClose = guiCreateButton(0.5, 0.05, 0.5, 0.075, "Close", true, wDonation)
	addEventHandler("onClientGUIClick", bClose, closeDonationGUI)
	
	bRedeem = guiCreateButton(0.2578, 0.0521, 0.2305, 0.0716, "Redeem Code", true, wDonation)
	addEventHandler("onClientGUIClick", bRedeem, openRebeemCode)
	
	lActive = guiCreateLabel(0.015, 0.15, 0.15, 0.15, "Active perks:", true, wDonation)
	guiSetFont(lActive, "default-bold-small")
	local y = 0.2
	for perkID, perkTable in ipairs(obtained) do
		local perkArr = perkTable[1]
		local expirationDate = perkTable[2] or "Unknown"
		if (perkArr[1] ~= nil) then
			lItems[perkID] = guiCreateLabel(0.015, y+0.0025, 0.4, 0.1, "- "..perkArr[1].."\n  expires at "..expirationDate, true, wDonation)
			guiSetFont(lItems[perkID], "default-bold-small")
			y = y + 0.06
		end
	end
	
	if (#obtained == 0) then
		lItems[9999] = guiCreateLabel(0.015, y+0.0015, 0.4, 0.1, "- None", true, wDonation)
		guiSetFont(lItems[9999], "default-bold-small")
	end
	
	lAvailable = guiCreateLabel(0.40, 0.15, 0.15, 0.15, "Available perks:", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	local y = 0.2
	for perkID, perkArr in ipairs(available) do
		if (perkArr[1] ~= nil) and (perkArr[2] ~= 0) then
			lItems[perkID] = guiCreateLabel(0.40, y+0.0015, 0.44, 0.1, "- "..perkArr[1] .. "\n   ".. ( perkArr[3] > 1 and (perkArr[3] .." days - ") or "") .. perkArr[2] .." donPoints", true, wDonation)
			guiSetFont(lItems[perkID], "default-bold-small")
			
			if credits >= perkArr[2] then
				bItems[perkID] = guiCreateButton(0.85, y+0.01, 0.1, 0.03, "Activate", true, wDonation)
				if perkArr[4] == 18 then
					addEventHandler("onClientGUIClick", bItems[perkID], showPhonePicker, false)
				else
					addEventHandler("onClientGUIClick", bItems[perkID], 
						function ()
							triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkArr[4])
							closeDonationGUI()
						end, false
					)
				end
			else
				guiSetText(lItems[perkID], guiGetText(lItems[perkID]) .. " - Not enough donPoints")
			end
			y = y + 0.06
		end
	end
	
	if (#available == 0) then
		lItems[9998] = guiCreateLabel(0.30, y+0.0015, 0.4, 0.1, "- None", true, wDonation)
		guiSetFont(lItems[9998], "default-bold-small")
	end
	
	guiSetInputEnabled(true)
	
	f7state = getKeyState( "f7" )
	addEventHandler("onClientRender", getRootElement(), checkF7)
end
addEvent("donation-system:GUI:open", true)
addEventHandler("donation-system:GUI:open", getRootElement(), openDonationGUI)

function closeDonationGUI()
	if (wDonation) then
		destroyElement(wDonation)
		wDonation,lSpendText,lActive,lAvailable,bClose,bRedeem  = nil
		lItems = {}
		bItems = { }
		guiSetInputEnabled(false)
		removeEventHandler("onClientRender", getRootElement(), checkF7)
		triggerServerEvent("donation-system:GUI:close", getLocalPlayer())
	end
	hideKeyValidator()
	hidePhonePicker()
end

--

local wPhone = nil
local eNumber, lNumber, bNumber

function showPhonePicker()
	local width, height = 250, 210
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wPhone = guiCreateWindow(x, y, width, height, "Spend donPoints", false)

	guiCreateLabel(0.03, 0.20, 2.0, 0.1, "Please pick your new number:", true, wPhone)
	eNumber = guiCreateEdit(0.03, 0.30, 2.0, 0.1, "", true, wPhone)
	guiSetProperty(eNumber,"ValidationString","[0-9]{0,9}")

	addEventHandler("onClientGUIChanged", eNumber, checkNumber) 
	
	lNumber = guiCreateLabel(0.03, 0.41, 2.0, 0.16, "Not a valid number", true, wPhone)
	guiLabelSetColor(lNumber, 255, 0, 0)
	
	--Buttons
	local cancel = guiCreateButton(0.15, 0.75, 0.70, 0.10, "I changed my mind", true, wPhone)
	addEventHandler("onClientGUIClick", cancel, hidePhonePicker, false)
	bNumber = guiCreateButton(0.15, 0.60, 0.70, 0.10, "Okay!", true, wPhone)
	guiSetEnabled(bNumber, false)
	addEventHandler("onClientGUIClick", bNumber,
		function()
			triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), 18, guiGetText(eNumber))
		end, false
	)
	
	guiSetEnabled(wDonation, false)
	guiWindowSetSizable(wPhone, false)
	guiWindowSetMovable(wPhone, true)
	guiSetInputEnabled(true)
end

function checkNumber()
	local valid, reason = checkValidNumber(tonumber(guiGetText(eNumber)))
	if valid then
		guiSetText(lNumber, "Valid number, click 'Okay' to\nsee if it is available.")
		guiLabelSetColor(lNumber, 0, 255, 0)
		
		guiSetEnabled(bNumber, true)
	else
		guiSetText(lNumber, reason)
		guiLabelSetColor(lNumber, 255, 0, 0)
		
		guiSetEnabled(bNumber, false)
	end
end

function hidePhonePicker()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end
	
	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end
addEvent("donation-system:phone:close", true)
addEventHandler("donation-system:phone:close", getRootElement(), closeDonationGUI)

local wValidate, tCode, lTitle, lValid, bClose, bValidate = nil
function openRebeemCode()
	wValidate = guiCreateWindow(0.407,0.3359,0.2219,0.2253,"Validate Code",true)
	tCode = guiCreateEdit(0.0352,0.3699,0.9261,0.1676,"",true,wValidate)
		addEventHandler("onClientGUIChanged", tCode, checkCodeLength)
	lTitle = guiCreateLabel(0.0423,0.1387,0.8908,0.1965,"Please enter the code you received\nin the your donation E-Mail here.",true,wValidate)
		guiLabelSetVerticalAlign(lTitle,"center")
		guiLabelSetHorizontalAlign(lTitle,"center",false)
	lValid = guiCreateLabel(0.0423,0.5723,0.9155,0.104,"This is not a valid code.",true,wValidate)
		guiLabelSetColor(lValid,255,0,0)
		guiLabelSetHorizontalAlign(lValid,"center",false)
	bClose = guiCreateButton(0.0352,0.7225,0.4437,0.2081,"Close",true,wValidate)
		addEventHandler("onClientGUIClick", bClose, hideKeyValidator)
	bValidate = guiCreateButton(0.5106,0.7225,0.4542,0.2139,"Validate",true,wValidate)
		guiSetEnabled(bValidate, false)
		addEventHandler("onClientGUIClick", bValidate,
			function(k, s)
				if k == "left" and s == "up" then
					triggerServerEvent("validateCode", getLocalPlayer(), guiGetText(tCode))
				end
			end
		)
	guiSetInputEnabled(true)
end

function hideKeyValidator()
	if wValidate then
		destroyElement(wValidate)
		wValidate = nil
	end
	
	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end

function checkCodeLength()
	if tonumber(string.len(guiGetText(source))) == 40 then
		guiSetText(lValid, "This code seems valid.")
		guiLabelSetColor(lValid, 0, 255, 0)
		guiSetEnabled(bValidate, true)
	else
		guiSetText(lValid, "This code is not valid.")
		guiLabelSetColor(lValid, 255, 0, 0)
		guiSetEnabled(bValidate, false)
	end
end