wTy, optionOne, optionTwo, optionThree, optionFour, bTyClose, tyText = nil

function createTyGUI ()
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wTy) then
		-- Create the window
		wTy = guiCreateWindow(X, Y, Width, Height, "Conversation with a stranger.", false )
	
		tyText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "", true, wTy )
		guiLabelSetHorizontalAlign ( tyText, "left", true )
	
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Knock on the door.", true, wTy )
		addEventHandler( "onClientGUIClick", optionOne, tyRequest, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Walk away.", true, wTy )
		addEventHandler( "onClientGUIClick", optionTwo, tyStatement3, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent("startTy_c", true)
addEventHandler("startTy_c", getRootElement(), createTyGUI)

function tyRequest ()
	triggerServerEvent( "startTyConvo", getLocalPlayer() ) -- Trigger Server Event to output previous option
end

-- Statement 2
function tyStatement2( rooksFriend, tysFriend )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( tyText, "Ty shouts: Yo', who is it?." )
	
	if(tonumber(tysFriend) == 0) then
		-- Create the new options
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Yo', c'mon open the fuckin' door, homie.", true, wTy )
		addEventHandler( "onClientGUIClick", optionOne, tyStatement4, false )
		
		if (tonumber(rooksFriend) == 1) then
			optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Rook sent me. He said you needed some help with some business.", true, wTy )
			addEventHandler( "onClientGUIClick", optionTwo, tyStatement5, false )
		end
		
	else
		-- Create the new options
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Yo', it's me. Open up.", true, wTy )
		addEventHandler( "onClientGUIClick", optionOne, tyFriendStatement2, false )
	end
end
addEvent("callback", true)
addEventHandler("callback", getRootElement(), tyStatement2)

-- statement 3
function tyStatement3()

	tyClose()
	
end

-- statement 4
function tyStatement4()

	triggerServerEvent( "tyStatement4ServerEvent", getLocalPlayer() )
	tyClose()
	
end

-- Statement 5
function tyStatement5( )

	triggerServerEvent( "tyStatement5ServerEvent", getLocalPlayer() )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( tyText, "Ty shouts: A'ight, hold up.\
						 *The door unlocks.\
						 Ty says: Only you. Anyone else is gonna have to wait outside.\
						 So you talked to Rook, right? What did he tell you?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "He said you had connects but needed someone to put it all to use.", true, wTy )
	addEventHandler( "onClientGUIClick", optionOne, tyStatement6, false )
	
	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "He said you had connects but didn't know what you were doin'. ", true, wTy )
	addEventHandler( "onClientGUIClick", optionTwo, tyStatement7, false )
	
end

-- Statement 6
function tyStatement6( )
	
	triggerServerEvent( "tyStatement6ServerEvent", getLocalPlayer() )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( tyText, "Yeah that's right. So you down? Here's how it'll work. I got some people's I can call up on when I need that produce. I'll act as middle man and sell to you at wholesale. You then can do whatever you want with it." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Wholesale? I thought we were partners.", true, wTy )
	addEventHandler( "onClientGUIClick", optionOne, tyStatement9, false )
	
	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Sounds a'ight.", true, wTy )
	addEventHandler( "onClientGUIClick", optionTwo, tyStatement8, false )
	
end

-- statement 7
function tyStatement7()
	
	triggerServerEvent( "tyStatement7ServerEvent", getLocalPlayer() )
	tyClose()
		
end

-- Statement 8
function tyStatement8( )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( tyText, "Ty says: You ever need the shit just come by. Here's some on the house." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "We gonna make that paper now.", true, wTy )
	addEventHandler( "onClientGUIClick", optionOne, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent( "tyStatement8ServerEvent", getLocalPlayer())
			
		end
	end, false)
	
end

-- Statement 9
function tyStatement9( )
	
	triggerServerEvent( "tyStatement9ServerEvent", getLocalPlayer() )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( tyText, "Ty says: If you ain't down I can find some other niggas." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Yeah you do that. ", true, wTy )
	addEventHandler( "onClientGUIClick", optionOne, tyStatement11, false )
	
	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Na, it's cool. We got a deal.", true, wTy )
	addEventHandler( "onClientGUIClick", optionTwo, tyStatement8, false )
	
end

-- statement 10
function tyStatement10()

	triggerServerEvent( "tyStatement10ServerEvent", getLocalPlayer() )
	tyClose()
	
end

-- statement 11
function tyStatement11()
	
	triggerServerEvent( "tyStatement11ServerEvent", getLocalPlayer() )
	tyClose()
	
end


---------------- Ty's Friends ----------------------

function tyFriendStatement2 ()
	
	triggerServerEvent( "tyFriendStatement2ServerEvent", getLocalPlayer() )
	
	-- Destroy the old options
	destroyElement ( optionOne )
	optionOne = nil
		
	-- Create new Stevies text box
	guiSetText ( tyText, "Ty shoust: A'ight hold up.\
						 Ty says: So what you looking for this time?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.45, 0.2, "Cannabis - $10", true, wTy )
	addEventHandler( "onClientGUIClick", optionOne, function(button, state)
		if(button == "left" and state == "up") then

			triggerServerEvent( "tyGiveItem", getLocalPlayer(), 1)
			guiSetText(tyText, "You want anything else?")

		end
	end, false)
	
	optionTwo = guiCreateButton( 0.05, 0.55, 0.45, 0.2, "Lysergic Acid - $20", true, wTy )
	addEventHandler( "onClientGUIClick", optionTwo, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent( "tyGiveItem", getLocalPlayer(), 2)
			guiSetText(tyText, "You want anything else?")
			
		end
	end, false)
	
	optionThree = guiCreateButton( 0.5, 0.35, 0.45, 0.2, "PCP - $20", true, wTy )
	addEventHandler( "onClientGUIClick", optionThree, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent( "tyGiveItem", getLocalPlayer(), 3)
			guiSetText(tyText, "You want anything else?")
			
		end
	end, false)
	
	--optionFour = guiCreateButton( 0.5, 0.55, 0.45, 0.2, "Coke - $25", true, wTy )
	--addEventHandler( "onClientGUIClick", optionFour, function(button, state)
	--	if(button == "left" and state == "up") then
			
	--		triggerServerEvent( "tyGiveItem", getLocalPlayer(), 4)
	--		guiSetText(tyText, "You want anything else?")
			
	--	end
	--end, false)
	
	bTyClose = guiCreateButton( 0.05, 0.85, 0.9, 0.2, "I'm set.", true, wTy )
	addEventHandler( "onClientGUIClick", bTyClose, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent("tyFriendClose", getLocalPlayer())
			tyClose()
			
		end
	end, false)
	
end

function tyClose()
		
	-- Destroy the old options
	if(optionOne)then
		destroyElement ( optionOne )
		optionOne = nil
	end
	if(optionTwo)then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	if(optionThree)then
		destroyElement ( optionThree )
		optionThree = nil
	end
	if(optionFour)then
		destroyElement ( optionFour )
		optionFour = nil
	end
	if(bTyClose)then
		destroyElement ( bTyClose )
		bTyClose = nil
	end
	if(tyText)then
		destroyElement ( tyText )
		tyText = nil
	end
	if(wTy)then
		destroyElement ( wTy )
		wTy = nil
	end
	
	showCursor(false)
	
end
addEvent("closeTyWindow", true)
addEventHandler("closeTyWindow", getRootElement(), tyClose)
addEventHandler("onClientChangeChar", getRootElement(), tyClose)