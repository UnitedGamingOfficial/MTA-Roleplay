--[[
--	Copyright (C) Bean - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Calvin Doyle <calvin.doyle@outlook.com>, February 2016
]]--

radarActive = false
radarScanning = false
screenX, screenY = guiGetScreenSize( )
targetCache = { }
cacheLimit = 10
lastDeleted = 0
currentCacheListing = -1
speedTextData = "000"
localPlayer = getLocalPlayer( )
localVehicle = getPedOccupiedVehicle( localPlayer )
lockedTextData = localVehicle and getElementData( localVehicle, "lockedRadar" ) or "000"
upArrowStatus, downArrowStatus = false

function toggleRadarGUI( closeOnly )
	if closeOnly and not radarActive then return end
	if not radarActive then
		bToggle = guiCreateButton(screenX - 466, screenY - 262, 75, 22, "TOGGLE", false)
		guiSetFont(bToggle, "default-bold-small")
		guiSetProperty(bToggle, "NormalTextColour", "FFAAAAAA")
		addEventHandler ( "onClientGUIClick", bToggle, 
			function(button, state)
				if(button == "left") then
					triggerServerEvent("radarButtonToggle", localPlayer, localPlayer)
					if not radarScanning then
						radarScanning = true
					else
						radarScanning = false
						upArrowStatus, downArrowStatus = false
					end
				end
			end )

		bLock = guiCreateButton(screenX - 381, screenY - 262, 75, 22, "LOCK", false)
		guiSetFont(bLock, "default-bold-small")
		guiSetProperty(bLock, "NormalTextColour", "FFAAAAAA")
		addEventHandler( "onClientGUIClick", bLock,
			function( button, state )
				if( button=="left" ) then
					lockedTextData = speedTextData
					triggerServerEvent( "applyLockedEntryToVehicle", localPlayer, getPedOccupiedVehicle( localPlayer ), lockedTextData )
				end
			end )

		bReset = guiCreateButton(screenX - 296, screenY - 262, 75, 22, "RESET", false)
		guiSetFont(bReset, "default-bold-small")
		guiSetProperty(bReset, "NormalTextColour", "FFAAAAAA")
		addEventHandler( "onClientGUIClick", bReset,
			function( button, state )
			if( button=="left" ) then
				targetCache = { }
				speedTextData = "000"
				lockedTextData = "000"
				lastDeleted = 0
				currentCacheListing = -1
				upArrowStatus, downArrowStatus = false
				radarScanning = false
				triggerServerEvent( "applyLockedEntryToVehicle", localPlayer, getPedOccupiedVehicle( localPlayer ), nil, true )
			end
		end )

		bModeSwitch = guiCreateButton(screenX - 381, screenY - 292, 75, 22, "MODE", false)
		guiSetFont(bModeSwitch, "default-bold-small")
		guiSetProperty(bModeSwitch, "NormalTextColour", "FFAAAAAA")
		addEventHandler( "onClientGUIClick", bModeSwitch,
			function( button, state )
			if( button=="left" ) then
				outputChatBox("(( Functionality not yet implemented, check back soon(ish). ))", 255, 255, 255 )
			end
		end )

		bGoLeft = guiCreateButton(screenX - 466, screenY - 292, 75, 22, "<<", false)
		guiSetFont(bGoLeft, "default-bold-small")
		guiSetProperty(bGoLeft, "NormalTextColour", "FFAAAAAA")
		addEventHandler( "onClientGUIClick", bGoLeft,
			function( button, state )
			if( button=="left" ) then
				if not radarScanning then
					if (#targetCache>0) then
						if ( currentCacheListing == -1 ) or ( currentCacheListing == 1 ) then
							currentCacheListing = #targetCache
						elseif( currentCacheListing == #targetCache ) or ( currentCacheListing > 1 ) then
							local nextListing = currentCacheListing - 1
							currentCacheListing = ( nextListing ~= lastDeleted ) and nextListing or nextListing - 1
						end
						
						outputDebugString("RADAR: Checking cache listing #" .. currentCacheListing)
						speedTextData = targetCache[currentCacheListing][1]
						upArrowStatus, downArrowStatus = false
						if ( targetCache[currentCacheListing][2] == 1 ) then
							upArrowStatus = true
						elseif( targetCache[currentCacheListing][2] == 2 ) then
							downArrowStatus = true
						end
					else
						outputChatBox( "You have no records cached.", 255, 0, 0 )
					end
				else
					outputChatBox( "You must stop scanning to go back in the cache.", 255, 0, 0 )
				end
			end
		end )

		bGoRight = guiCreateButton(screenX - 296, screenY - 292, 75, 22, ">>", false)
		guiSetFont(bGoRight, "default-bold-small")
		guiSetProperty(bGoRight, "NormalTextColour", "FFAAAAAA")
		addEventHandler( "onClientGUIClick", bGoRight,
			function( button, state )
			if( button=="left" ) then
				if not radarScanning then
					if (#targetCache>0) then
						if ( currentCacheListing == -1 ) then
							currentCacheListing = 1
						elseif( currentCacheListing == #targetCache ) then
							currentCacheListing = ( lastDeleted ~= 1 and 1 ) or 2
						elseif( currentCacheListing < #targetCache ) then
							local nextListing = currentCacheListing + 1
							currentCacheListing = ( nextListing ~= lastDeleted ) and nextListing or nextListing + 1
						end
						
						outputDebugString("RADAR: Checking cache listing #" .. currentCacheListing)
						speedTextData = targetCache[currentCacheListing][1]
						upArrowStatus, downArrowStatus = false
						if ( targetCache[currentCacheListing][2] == 1 ) then
							upArrowStatus = true
						elseif( targetCache[currentCacheListing][2] == 2 ) then
							downArrowStatus = true
						end
					else
						outputChatBox( "You have no records cached.", 255, 0, 0 )
					end
				else
					outputChatBox( "You must stop scanning to go back in the cache.", 255, 0, 0 )
				end
			end
		end )

		addEventHandler( "onClientRender", getRootElement( ), renderDxElements )
		radarActive = true
	else
		radarActive = false
		clearRadarGUI( )
	end
end
addEvent("displayPoliceRadar", true)
addEventHandler("displayPoliceRadar", getRootElement( ), toggleRadarGUI )

function renderDxElements( )
	if not getPedOccupiedVehicle( localPlayer ) then
		clearRadarGUI ( )
	end
	dxDrawRectangle(screenX - 489, screenY - 362, 299, 126, tocolor(0, 0, 0, 114), true)
	dxDrawRectangle(screenX - 471, screenY - 335, 80, 34, tocolor(91, 0, 0, 254), true)
	dxDrawRectangle(screenX - 381, screenY - 335, 80, 34, tocolor(91, 0, 0, 254), true)
	dxDrawRectangle(screenX - 291, screenY - 335, 80, 34, tocolor(91, 0, 0, 254), true)
	dxDrawText("TARGET", screenX - 471, screenY - 363, screenX - 394, screenY - 336, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
	dxDrawText("MODE", screenX - 381, screenY - 361, screenX - 301, screenY - 335, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
	dxDrawText("LOCKED", screenX - 291, screenY - 361, screenX - 211, screenY - 335, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
	speedText = dxDrawText( speedTextData, screenX - 471, screenY - 335, screenX - 392, screenY - 304, tocolor(203, 0, 0, 254), 1, "bankgothic", "center", "center", false, false, true, false, false)
	modeText = dxDrawText("01", screenX - 381, screenY - 335, screenX - 302, screenY - 304, tocolor(203, 0, 0, 254), 0.75, "bankgothic", "center", "center", false, false, true, false, false)
	lockedText = dxDrawText( lockedTextData, screenX - 291, screenY - 335, screenX - 212, screenY - 304, tocolor(203, 0, 0, 254), 1, "bankgothic", "center", "center", false, false, true, false, false)
	if upArrowStatus then
		dxDrawImage(screenX - 381, screenY - 335, 26, 36, "radarMedia/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end
	if downArrowStatus then
		dxDrawImage(screenX - 328, screenY - 335, 26, 36, "radarMedia/arrow.png", 180, 0, 0, tocolor(255, 255, 255, 255), true)
	end
end

function clearRadarGUI( )
	removeEventHandler("onClientRender", getRootElement( ), renderDxElements)
	if ( bToggle and isElement( bToggle ) ) then destroyElement(bToggle) end
	if ( bModeSwitch and isElement( bModeSwitch ) ) then destroyElement(bModeSwitch) end
	if ( bLock and isElement( bLock ) ) then destroyElement(bLock) end
	if ( bGoLeft and isElement( bGoLeft ) ) then destroyElement(bGoLeft) end
	if ( bGoRight and isElement( bGoRight ) ) then destroyElement(bGoRight) end
	if ( bReset and isElement( bReset ) ) then destroyElement(bReset) end
end

function updateVisualInformation( speedInformation, lockedInformation, radarInformation )
	if ( #targetCache>=cacheLimit ) then
		local toDelete = lastDeleted + 1
		if ( toDelete > #targetCache ) then
			toDelete = 1
		end
		targetCache[toDelete] = nil
		lastDeleted = toDelete
	end
	if (speedInformation~="000") then
		for i = 1, cacheLimit do
			foundInt = false
			if not targetCache[i] then
				foundInt = i
				break
			end
		end
		targetCache[foundInt] = { speedInformation, radarInformation }
		speedTextData = speedInformation
	end
	
	if radarInformation then
		upArrowStatus, downArrowStatus = false
		if( radarInformation == 1 ) then
			upArrowStatus = true
		elseif( radarInformation == 2 ) then
			downArrowStatus = true
		else
			upArrowStatus, downArrowStatus = false
		end
	else
		upArrowStatus, downArrowStatus = false
	end
end
addEvent( "updateRadarInformation", true )
addEventHandler( "updateRadarInformation", getRootElement( ), updateVisualInformation )

addCommandHandler("listcache",
	function( )
		if not exports.global:isPlayerScripter( localPlayer ) then return end
		for k, v in pairs( targetCache ) do
			outputChatBox("k: " .. k .. ", v[1]: " .. v[1] .. ", v[2]: " .. v[2])
		end
		
		if (#targetCache==0) then
			outputChatBox("no things there")
		end
	end
);