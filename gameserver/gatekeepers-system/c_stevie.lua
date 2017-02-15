--[=[
wStevie, optionOne, optionTwo, buttonClose, stevieText = nil

function createStevieGUI() 
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wStevie) then
		-- Create the window
		wStevie = guiCreateWindow(X, Y, Width, Height, "Conversation with a stranger.", false )
		
		-- Create Stevies text box
		stevieText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3,  "Do you want something, pal?", true, wStevie )
		guiLabelSetHorizontalAlign ( stevieText, "left", true )
		
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Can I take a seat?", true, wStevie )
		addEventHandler( "onClientGUIClick", optionOne, statement2, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "No. Sorry to bother you.", true, wStevie )
		addEventHandler( "onClientGUIClick", optionTwo, quickClose, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent( "stevieIntroEvent", true )
addEventHandler( "stevieIntroEvent", getRootElement(), createStevieGUI )


function destroyStevieGUI()
	-- destroy all possibly created windows
	if optionOne then
		destroyElement ( optionOne )
		optionOne = nil
	end
	
	if optionTwo then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	
	if stevieText then
		destroyElement ( stevieText )
		stevieText = nil
	end
	
	if wStevie then
		destroyElement ( wStevie )
		wStevie = nil
	end
	
	if buttonClose then
		destroyElement ( buttonClose )
		buttonClose = nil
	end

	showCursor(false)
end

-- make sure to quit the Convo GUI when player is killed
addEventHandler("onClientPlayerWasted", getLocalPlayer(), destroyStevieGUI)
addEventHandler("onClientChangeChar", getRootElement(), destroyStevieGUI)

-- Quick Close
function quickClose()
	
	triggerServerEvent( "quickCloseServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end

-- Statement 2
function statement2()
	
	triggerServerEvent( "statement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( stevieText, "Steven Pullman says: Sure, sit down. Have you tried the food here? It's f****** unbelievable" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Yeah I heard it's good. I was just about to order something.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionOne, statement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "I'm a vegetarian. The thought of those poor animals suffering for you to stuff your face makes me sick.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionTwo, statement3, false )

	buttonClose = guiCreateButton( 0.05, 0.75, 0.9, 0.2, "Is that the time? I have to go.", true, wStevie )
	addEventHandler( "onClientGUIClick", buttonClose, CloseButtonClick, false )
	
end

-- statement 3
function statement3()
	
	triggerServerEvent( "statement3ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end

-- statement 4
function statement4()
	
	triggerServerEvent( "statement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create Stevies text box
	guiSetText (stevieText, "Steven Pullman says: Get the Manhattan Strip. You won't regret it. Where's my manners... The name's Stevie." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Shake Stevie's hand.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionOne, statement6, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Refuse to shake Stevie's hand.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionTwo, statement5, false )
	
end

-- Statement 5
function statement5()
	
	triggerServerEvent( "statement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end

-- Statement 6
function statement6()
	
	triggerServerEvent( "statement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText (stevieText, "Steven Pullman says: Me and the boys from the freight depot come down here all the time. Football and steaks make a damn good combo don't ya think?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "I never really liked football.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionOne, statement8, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Are you kidding me? Ive been a Beavers fan my whole life!", true, wStevie )
	addEventHandler( "onClientGUIClick", optionTwo, statement7, false )
	
end

-- Statement 7
function statement7()
	
	triggerServerEvent( "statement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end

-- Statement 8
function statement8()
	
	triggerServerEvent( "statement8ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText ( stevieText, "Steven Pullman says: Yeah, maybe it ain't to everyone's taste. So what do you do?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "I'd rather not get into that if you don't mind.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionOne, statement5, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Over worked and underappreciated. You know how it is.", true, wStevie )
	addEventHandler( "onClientGUIClick", optionTwo, statement9, false )
	
end

-- Statement 9
function statement9()
	
	triggerServerEvent( "statement9ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	destroyElement ( buttonClose )
	optionOne = nil
	optionTwo = nil
	buttonClose = nil

	-- Create Stevies text box
	guiSetText ( stevieText, "Steven Pullman says: Tell me about it! They got me bustin' my ass at the freight yard for change. See it's people like you and me that need to help each other out. Tell you what, heres my card. You ever need anything I can help you out with, just give me a call." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.45, 0.9, 0.2, "Take the business card", true, wStevie )
	addEventHandler( "onClientGUIClick", optionOne, stevieSuccess, false )

	optionTwo = guiCreateButton( 0.05, 0.65, 0.9, 0.2, "Don't take the business card", true, wStevie )
	addEventHandler( "onClientGUIClick", optionTwo, CloseButtonClick, false )
	
end

-- Stevie Success
function stevieSuccess()
	
	triggerServerEvent( "stevieSuccessServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end

function CloseButtonClick()
	
	triggerServerEvent( "CloseButtonClickServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyStevieGUI()
end
------------------------------------------------------------------------------------
------------------------------ telephone conversation ------------------------------
------------------------------------------------------------------------------------
pwStevie, pstevieText, poptionOne, poptionTwo, poptionThree, poptionFour = nil
factionLeader = nil

function noDeal()
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (pwStevie) then
		-- Create the window
		pwStevie = guiCreateWindow(X, Y, Width, Height, "Phone Conversation with a stranger", false )
		
		-- Create Stevies text box
		pstevieText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "Hey! How you doin'? I know I said I would help you out but I've got nothing here for ya. Sorry.", true, pwStevie )
		guiLabelSetHorizontalAlign ( pstevieText, "left", true )
		
		-- Create close Button
		poptionOne = guiCreateButton( 0.05, 0.45, 0.9, 0.2, "Hang up.", true, pwStevie )
		addEventHandler( "onClientGUIClick", poptionOne, cdeclineSteviePhoneDeal, false )
		
		showCursor(true)
	end
end
addEvent("outOfDeals", true)
addEventHandler("outOfDeals",  getRootElement(), noDeal)

function createPhoneConvo( leader )
	factionLeader = leader == 1
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (pwStevie) then
		-- Create the window
		pwStevie = guiCreateWindow(X, Y, Width, Height, "Phone Conversation with a stranger", false )
		
		-- Create Stevies text box
		pstevieText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "Hey! How you doin'? I've got a couple crates that I could put aside if you're interested?", true, pwStevie )
		guiLabelSetHorizontalAlign ( pstevieText, "left", true )
			
		-- Create options
		poptionOne = guiCreateButton( 0.05, 0.45, 0.9, 0.2, "Accept the offer.", true, pwStevie )
		addEventHandler( "onClientGUIClick", poptionOne, cacceptSteviePhoneDeal, false )

		poptionTwo = guiCreateButton( 0.05, 0.65, 0.9, 0.2, "Decline the offer.", true, pwStevie )
		addEventHandler( "onClientGUIClick", poptionTwo, cdeclineSteviePhoneDeal, false )
		
		showCursor(true)
	end
end
addEvent( "showPhoneConvo", true )
addEventHandler( "showPhoneConvo", getRootElement(), createPhoneConvo )



------------------------
-- Decline phone deal --
------------------------

function cdeclineSteviePhoneDeal()
	if(poptionOne)then 
		destroyElement ( poptionOne )
		poptionOne = nil
	end
	if(poptionTwo)then 
		destroyElement ( poptionTwo )
		poptionTwo = nil
	end
	if(pstevieText)then
		destroyElement ( pstevieText )
		pstevieText = nil
	end
	if(pwStevie)then
		destroyElement ( pwStevie )
		pwStevie = nil
	end
	
	showCursor(false)
	
	triggerServerEvent( "declineSteviePhoneDeal", getLocalPlayer() )
	
end


--------------------------
-- Accepting phone deal --
--------------------------

function cacceptSteviePhoneDeal( )
	local factionType = getElementData(getPlayerTeam(getLocalPlayer()), "type")
	
	-- Create the window
	destroyElement ( poptionOne )
	destroyElement ( poptionTwo )
	poptionOne = nil
	poptionTwo = nil
		
	-- Create Stevies text box
	guiSetText ( pstevieText, "I got a couple crates here. Which one tickles ya fancy?")
	
	if false and (factionLeader and factionType==0) then -- Gang

		poptionOne = guiCreateButton(  0.05, 0.65, 0.45, 0.2, "To: Ammu-nation LTD.\
															- $7,500", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionOne,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 1)
				
			end
		end, false)
		
		poptionTwo = guiCreateButton( 0.05, 0.45, 0.45, 0.2, "From: Suny Corp., Tokyo.\
															- $1,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionTwo,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 2)
				
			end
		end, false)
		
		poptionFour = guiCreateButton( 0.5, 0.65, 0.45, 0.2, "To: RaNu Chemical Research.\
															- $2,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionFour,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 5)
				
			end
		end, false)
		
	elseif (factionLeader and factionType==1) then -- Mafia
	
		-- Create close, previous and Next Button
		poptionOne = guiCreateButton( 0.05, 0.65, 0.45, 0.2, "To: Ammu-nation LTD.\
															- $7,500", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionOne,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 1)
				
			end
		end, false)
		
		poptionTwo = guiCreateButton( 0.05, 0.45, 0.45, 0.2, "From: Suny Corp., Tokyo.\
															- $1,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionTwo,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 2)
				
			end
		end, false)
		
		poptionThree = guiCreateButton( 0.5, 0.45, 0.45, 0.2, "To: Area 69 US Military Base.\
															- $15,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionThree,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 3)
				
			end
		end, false)

		poptionFour = guiCreateButton( 0.5, 0.65, 0.45, 0.2, "To: RaNu Chemical Research.\
															- $3,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionFour,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 4)
				
			end
		end, false)
	
	else -- Other

		poptionTwo = guiCreateButton( 0.05, 0.45, 0.45, 0.2, "From: Suny Corp., Tokyo.\
															- $1,000", true, pwStevie )
		addEventHandler ( "onClientGUIClick", poptionTwo,  function(button, state)
			if(button == "left" and state == "up") then
				
				c_closePhoneGUI()
				triggerServerEvent( "acceptSteviePhoneDeal", getLocalPlayer(), 2)
				
			end
		end, false)
		
	end
end

----------------------------------
-- removing the phone convo GUI --
----------------------------------
function c_closePhoneGUI()
	if(poptionOne)then 
		destroyElement ( poptionOne )
		poptionOne = nil
	end
	if(poptionTwo)then 
		destroyElement ( poptionTwo )
		poptionTwo = nil
	end
	if(poptionThree)then 
		destroyElement ( poptionThree )
		poptionThree = nil
	end
	if(poptionFour)then 
		destroyElement ( poptionFour )
		poptionFour = nil
	end
	
	if pstevieText then
		destroyElement ( pstevieText )
		pstevieText = nil
	end
	
	if pwStevie then
		destroyElement ( pwStevie )
		pwStevie = nil
	end
	
	showCursor(false)
	
end
addEvent("closePhoneGUI")
addEventHandler("closePhoneGUI", getRootElement(), c_closePhoneGUI )
addEventHandler("onClientChangeChar", getRootElement(), c_closePhoneGUI)

--------------------
-- blip for deals --
--------------------
local stevieBlip = nil

function addBlip(x, y, z)
	removeBlip()
	stevieBlip = createBlip(x, y, z, 0, 2, 255, 127, 255)
end

function removeBlip()
	if stevieBlip then
		destroyElement(stevieBlip)
		stevieBlip = nil
	end
end

addEvent("addStevieBlip", true)
addEventHandler("addStevieBlip", getLocalPlayer(), addBlip)

addEvent("removeStevieBlip", true)
addEventHandler("removeStevieBlip", getLocalPlayer(), removeBlip)
]=]
