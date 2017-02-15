wRook, optionOne, optionTwo, rookText = nil

function createRookGUI() 
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wRook) then
	
		-- Create the window
		wRook = guiCreateWindow(X, Y, Width, Height, "Conversation with a stranger.", false )
		
		-- Create Stevies text box
		rookText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "What up, Homie? You lookin' to make some real green?", true, wRook )
		guiLabelSetHorizontalAlign ( rookText, "left", true )
		
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Hell yeah, I'm always lookin' for that paper.", true, wRook )
		addEventHandler( "onClientGUIClick", optionOne, rookStatement2, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Shit. I'm paid as a mother fucker. I don't need no crack head givin' me hand outs. ", true, wRook )
		addEventHandler( "onClientGUIClick", optionTwo, rookStatement3, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent( "rookIntroEvent", true )
addEventHandler( "rookIntroEvent", getRootElement(), createRookGUI )

function destroyRookGUI()
	-- destroy all possibly created windows
	if optionOne then
		destroyElement ( optionOne )
		optionOne = nil
	end
	
	if optionTwo then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	
	if rookText then
		destroyElement ( rookText )
		rookText = nil
	end
	
	if wRook then
		destroyElement ( wRook )
		wRook = nil
	end

	showCursor(false)
end

-- make sure to quit the Convo GUI when player is killed
addEventHandler("onClientPlayerWasted", getLocalPlayer(), destroyRookGUI)
addEventHandler("onClientChangeChar", getRootElement(), destroyRookGUI)

-- Statement 2
function rookStatement2()
	
	triggerServerEvent( "rookStatement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "Rook says: Economies all fucked up, right? There's only one market that isn't goin' down like a high school cheerleader. I'm talkin' about that dope money." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "What do you know about it?", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Only thing guaranteed to dope slangers is jail time.", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement3, false )
	
end

-- statement 3
function rookStatement3()
	
	triggerServerEvent( "rookStatement3ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyRookGUI()
end

-- Statement 4
function rookStatement4()
	
	triggerServerEvent( "rookStatement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "Rook says: I know a guy that's looking to reach out. He got connects but no soldiers to push his product." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Sounds shady, bruh. ", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Where's he at?", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement5, false )
	
end

-- Statement 5
function rookStatement5()
	
	triggerServerEvent( "rookStatement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "Rook says: His name's Ty and lives over in Kennedy Apartments on Panoptican Avenue, apartment 3. Tell him Rook sent you.")
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Nah, this shits a setup. Probably got your crack head homies ready to jump me for my shoes.", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "And you're just telling me this because you're feelin' charitable. ", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement6, false )
	
end

-- Statement 6
function rookStatement6()
	
	triggerServerEvent( "rookStatement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "Rook says: If a brother doesn't look out for his own who will? The white man?")
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Now you some kinda black panther mother fucker.", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "I hear that.", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookClose, false )
	
end

-- close
function rookClose()
	
	triggerServerEvent( "rookStatement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyRookGUI()
end
