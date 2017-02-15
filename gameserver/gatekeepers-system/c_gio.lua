--[=[
gio_Window,gio_text,button1,button2,button3,button4,closeB = nil

function startGiovannaT(ft, gs)
	if (gs == 1) then
		if (ft == 0) then
			local Width = 400
			local Height = 250
			local screenwidth, screenheight = guiGetScreenSize()
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			if not (gioWindow) then
				-- Create the window
				gioWindow = guiCreateWindow(X, Y, Width, Height, "Abandon Warehouse: What to do?", false )
			
				gio_Text = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "", true, gioWindow )
				guiLabelSetHorizontalAlign ( gio_text, "left", true )
			
				-- Create close, previous and Next Button
				button1 = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Bang on the door.", true, gioWindow )
				addEventHandler( "onClientGUIClick", button1, sGioD, false )

				button2 = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Walk away.", true, gioWindow )
				addEventHandler( "onClientGUIClick", button2, sGioC, false )
				
				showCursor(true)
			end
		end
	end
end
addEvent("startWGio", true)
addEventHandler("startWGio", getRootElement(), startGiovannaT)

function sGioD()
	triggerServerEvent("showGioConvo", getLocalPlayer(), 1)
end

function gioPhase2()
	destroyElement(button1)
	destroyElement(button2)
	button1 = nil
	button2 = nil
	
	-- Create new Stevies text box
	guiSetText ( gio_text, "Little Joe shouts: Yeah Yeah. I'm coming. Who's there?!" )
	
	button1 = guiCreateButton(0.05, 0.35, 0.9, 0.2, "I came here for some guns. Got any supplies?", true, gioWindow)
	addEventHandler("onClientGUIClick", button1, sGioS1, false)

	button2 = guiCreateButton(0.05, 0.55, 0.9, 0.2, "It's me. I came here for some business.", true, gioWindow )
	addEventHandler( "onClientGUIClick", button2, sGioS2, false )
end
addEvent("startGioP2", true)
addEventHandler("startGioP2", getRootElement(), gioPhase2)

function sGioS1()
	triggerServerEvent("showGioConvo", getLocalPlayer(), 2)
	closeGiosWindow()
end

function sGioS2()
	triggerServerEvent("showGioConvo", getLocalPlayer(), 3)
	
	destroyElement(button1)
	destroyElement(button2)
	button1 = nil
	button2 = nil
	
	guiSetText(gio_Text, "Giovanna Remini says: I'm all ears. The name is Giovanna, what are you looking for bud?")
	
	button1 = guiCreateButton( 0.05, 0.35, 0.45, 0.2, "9mm w/ 150 Rounds - $4,000", true, gioWindow )
	addEventHandler( "onClientGUIClick", button1, function(button, state)
		if(button == "left" and state == "up") then

			triggerServerEvent( "gioGiveItem", getLocalPlayer(), 1)
			guiSetText(gio_text, "You want anything else brother?")

		end
	end, false)
	
	button2 = guiCreateButton( 0.05, 0.55, 0.45, 0.2, "Tec-9 w/ 150 Rounds - $6,000", true, gioWindow )
	addEventHandler( "onClientGUIClick", button2, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent( "gioGiveItem", getLocalPlayer(), 2)
			guiSetText(gio_text, "You want anything else brother?")
			
		end
	end, false)
	
--[[	button3 = guiCreateButton( 0.5, 0.35, 0.45, 0.2, "PCP - $20", true, gioWindow )
	addEventHandler( "onClientGUIClick", button3, function(button, state)
		if(button == "left" and state == "up") then
			
			triggerServerEvent( "tyGiveItem", getLocalPlayer(), 3)
			guiSetText(gio_text, "You want anything else?")
			
		end
	end, false)--]]
	
	closeB = guiCreateButton( 0.05, 0.85, 0.9, 0.2, "I have all I need.", true, gioWindow )
	addEventHandler( "onClientGUIClick", closeB, function(button, state)
		if(button == "left" and state == "up") then
			triggerServerEvent("showGioConvo", getLocalPlayer(), 4)
			triggerEvent("closeGiosWindow", getLocalPlayer())
		end
	end, false)

end

function sGioC()
	eleminateGio()
end

function eleminateGio()
	if(button1)then
		destroyElement ( button1 )
		button1 = nil
	end
	if(button2)then
		destroyElement ( button2 )
		button2 = nil
	end
	if(button3)then
		destroyElement ( button3 )
		button3 = nil
	end
	if(closeB)then
		destroyElement ( closeB )
		closeB = nil
	end
	if(gio_text)then
		destroyElement ( gio_text )
		gio_text = nil
	end
	if(gioWindow)then
		destroyElement ( gioWindow )
		gioWindow = nil
	end
	
	showCursor(false)
end
addEvent("closeGiosWindow", true)
addEventHandler("closeGiosWindow", getRootElement(), eleminateGio)
addEventHandler("onClientChangeChar", getRootElement(), eleminateGio)
]=]
