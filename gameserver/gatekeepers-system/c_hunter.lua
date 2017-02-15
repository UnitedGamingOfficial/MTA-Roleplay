wHunter, optionOne, optionTwo, hunterText = nil

function createhunterGUI() 
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wHunter) then
		-- Create the window
		wHunter = guiCreateWindow(X, Y, Width, Height, "Conversation with a stranger.", false )
		
		-- Create Stevies text box
		hunterText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3,  "*A muscular man works under the car's hood.", true, wHunter )
		guiLabelSetHorizontalAlign ( hunterText, "left", true )
		
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Hey. I'm looking for a mechanic to change some spark plugs.", true, wHunter )
		addEventHandler( "onClientGUIClick", optionOne, hunterStatement2, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Nice ride. Is it yours?", true, wHunter )
		addEventHandler( "onClientGUIClick", optionTwo, hunterStatement3, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent( "hunterIntroEvent", true )
addEventHandler( "hunterIntroEvent", getRootElement(), createhunterGUI )

function destroyHunterGUI()
	-- destroy all possibly created windows
	if optionOne then
		destroyElement ( optionOne )
		optionOne = nil
	end
	
	if optionTwo then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	
	if hunterText then
		destroyElement ( hunterText )
		hunterText = nil
	end
	
	if wHunter then
		destroyElement ( wHunter )
		wHunter = nil
	end

	showCursor(false)
end

-- make sure to quit the Convo GUI when player is killed
addEventHandler("onClientPlayerWasted", getLocalPlayer(), destroyHunterGUI)
addEventHandler("onClientChangeChar", getRootElement(), destroyHunterGUI)

-- statement 2
function hunterStatement2()
	
	triggerServerEvent( "hunterStatement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
end

-- Statement 3
function hunterStatement3()
	
	triggerServerEvent( "hunterStatement3ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( hunterText, "Hunter says: It sure is." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "What are you running under there?", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "I like the paint job.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement5, false )
	
end

-- statement 4
function hunterStatement4()
	
	triggerServerEvent( "hunterStatement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create Stevies text box
	guiSetText (hunterText, "Hunter says: Sport air intake, NOS, fogger system and a T4 turbo. But you wouldn't know much about that, would you?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Looks like all show and no go to me.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement6, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Is that an AIC controller? .. And direct port nitrous injection?!", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement7, false )
	
end

-- statement 5
function hunterStatement5()
	
	triggerServerEvent( "hunterStatement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
end

-- statement 6
function hunterStatement6()
	
	triggerServerEvent( "hunterStatement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
	
end

-- Statement 7
function hunterStatement7()
	
	triggerServerEvent( "hunterStatement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText (hunterText, "Hunter says: You almost sound like you know what you're talking about." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "There's nothing better than living a quarter mile at a time.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement8, false )
	
end



-- Statement 8
function hunterStatement8()
	
	triggerServerEvent( "hunterStatement8ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	optionOne = nil
	
	-- Create Stevies text box
	guiSetText ( hunterText, "Hunter says: Oh, you're a racer? They call me Hunter. I got a real name but unless you're the government you don't need to know it." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "You work here alone?", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement9, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "My mother taught me never to trust a man that won't even tell you his name.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement10, false )
	
end

-- Statement 9
function hunterStatement9()
	
	triggerServerEvent( "hunterStatement9ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end

-- Statement 10
function hunterStatement10()
	
	triggerServerEvent( "hunterStatement10ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText ( hunterText, "Hunter says: Well here's the thing. One of my usual guys got busted a couple days ago. If you're looking to make some money I could use a new go to guy. See running a car like this isn't cheap so we ...borrow from other cars if you know what I'm saying." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.45, 0.9, 0.2, "Sounds like easy money. Give me a call.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement11, false )

	optionTwo = guiCreateButton( 0.05, 0.65, 0.9, 0.2, "I'd rather not get involved in all that.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement12, false )
	
end

-- Hunter Success
function hunterStatement11()
	
	triggerServerEvent( "hunterStatement11ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end

-- Hunter Decline
function hunterStatement12()
	
	triggerServerEvent( "hunterStatement12ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end
