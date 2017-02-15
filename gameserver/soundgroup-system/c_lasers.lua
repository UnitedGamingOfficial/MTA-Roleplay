--[[
	*
	* SoundGroup Corporation - System
	* File: c_lasers.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

-- Laser points are stored in a table, can only be added/removed via this script (remember to change client-side)
local laserpoints = {
	-- sx, sy, sz, ex, ey, ez, mode, red, green, blue, alpha, width, amount, lowest start z offset in mode two
	-- 1
	{-2102.53, 226.18, 52.5, -2102.53, 226.18, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2102.28, 238.1, 52.5, -2102.28, 238.1, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2102.49, 263.46, 52.5, -2102.49, 263.46, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2102.46, 275.86, 52.5, -2102.46, 275.86, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	-- 2
	{-2087.59, 276.18, 55.4, -2087.59, 276.18, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2087.44, 261.88, 55.4, -2087.44, 261.88, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2087.66, 226.46, 55.4, -2087.66, 226.46, 20, 0, 255, 0, 0, 4.5, 100, 100, 15},
	{-2087.59, 240.14, 55.4, -2087.59, 240.14, 20, 0, 255, 0, 0, 4.5, 100, 100, 15}
}

-- Render all the laser beams
addEventHandler("onClientRender", root,
	function()
		local x, y, z = getElementPosition(localPlayer)
		for i=1,#laserpoints do
			if getDistanceBetweenPoints3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], x, y, z) <= 250 then
				if laserpoints[i][7] == 0 then
					for k=1,laserpoints[i][13] do
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5]+math.random(1,35), laserpoints[i][6]-math.random(0,25), tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5]-math.random(1,35), laserpoints[i][6]-math.random(0,25), tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
					end
				elseif laserpoints[i][7] == 1 then
					for k=1,laserpoints[i][13] do
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5]+math.random(1,35), laserpoints[i][6], tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5]-math.random(1,35), laserpoints[i][6], tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
					end
				elseif laserpoints[i][7] == 2 then
					for k=1,laserpoints[i][13] do
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3]-math.random(1,laserpoints[i][14]), laserpoints[i][4], laserpoints[i][5]+math.random(1,35), laserpoints[i][6], tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3]-math.random(1,laserpoints[i][14]), laserpoints[i][4], laserpoints[i][5]-math.random(1,35), laserpoints[i][6], tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][8], laserpoints[i][9], laserpoints[i][11]), laserpoints[i][12], false)
					end
				elseif laserpoints[i][7] == 3 then
					for k=1,laserpoints[i][13] do
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5], laserpoints[i][6]+math.random(1,10), tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][11]), laserpoints[i][12], false)
						dxDrawLine3D(laserpoints[i][1], laserpoints[i][2], laserpoints[i][3], laserpoints[i][4], laserpoints[i][5], laserpoints[i][6]-math.random(1,10), tocolor(laserpoints[i][8], laserpoints[i][9], laserpoints[i][10], laserpoints[i][8], laserpoints[i][9], laserpoints[i][11]), laserpoints[i][12], false)
					end
				end
			end
		end
	end
)

-- Simple return function
function checkEverything()
	if isTransferBoxActive() then return end
	if isMainMenuActive() then return end
	if isChatBoxInputActive() then return end
	if isConsoleActive() then return end
	if not allowedUsername(localPlayer, "move") then return end
	return true
end

-- Ability to move the lasers with numpad +/-
addEventHandler("onClientKey", root,
	function(key, state)
		if state == true then
			if key == "num_add" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 1)
				end
			elseif key == "num_sub" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 2)
				end
			elseif key == "num_0" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 3)
				end
			elseif key == "num_dec" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 4)
				end
			elseif key == "home" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 5)
				end
			elseif key == "end" then
				if checkEverything() then
					triggerServerEvent("laser:move", localPlayer, 6)
				end
			elseif key == "num_div" then
				if checkEverything() then
					executeCommandHandler("speedmoveup")
				end
			elseif key == "num_mul" then
				if checkEverything() then
					executeCommandHandler("speedmovedown")
				end
			end
		end
	end
)

-- Synchronization stuff...
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		triggerServerEvent("laser:sync", localPlayer)
	end
)

-- All of the events triggered from server-side...
addEvent("laser:pos", true)
addEventHandler("laser:pos", root,
	function(id, x, y, z)
		laserpoints[id][1], laserpoints[id][2], laserpoints[id][3] = x, y, z
	end
)

addEvent("laser:point", true)
addEventHandler("laser:point", root,
	function(id, x, y, z)
		laserpoints[id][4], laserpoints[id][5], laserpoints[id][6] = x, y, z
	end
)

addEvent("laser:level", true)
addEventHandler("laser:level", root,
	function(id, level)
		laserpoints[id][14] = level
	end
)

addEvent("laser:width", true)
addEventHandler("laser:width", root,
	function(id, width)
		laserpoints[id][12] = width
	end
)

addEvent("laser:mode", true)
addEventHandler("laser:mode", root,
	function(id, mode)
		laserpoints[id][7] = mode
	end
)

addEvent("laser:colors", true)
addEventHandler("laser:colors", root,
	function(id, r, g, b)
		laserpoints[id][8], laserpoints[id][9], laserpoints[id][10] = r, g, b
	end
)

addEvent("laser:amount", true)
addEventHandler("laser:amount", root,
	function(id, points)
		laserpoints[id][13] = points
	end
)

addEvent("laser:alpha", true)
addEventHandler("laser:alpha", root,
	function(id, alpha)
		laserpoints[id][11] = alpha
	end
)

addEvent("laser:#", true)
addEventHandler("laser:#", root,
	function()
		triggerServerEvent("laser:#r", root, #laserpoints)
	end
)

-- The GUI for the main controls
function showLaserControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(controls_window) then
		controls = {
			gridlist = {},
			button = {}
		}
		
		controls_window = guiCreateWindow(10, 10, 579, 275, "Laser Controls", false)
		guiWindowSetSizable(controls_window, false)
		guiSetAlpha(controls_window, 0.70)
		
		controls.gridlist[1] = guiCreateGridList(10, 29, 558, 158, false, controls_window)
		ctrl1 = guiGridListAddColumn(controls.gridlist[1], "ID", 0.08)
		ctrl2 = guiGridListAddColumn(controls.gridlist[1], "Mode", 0.08)
		ctrl3 = guiGridListAddColumn(controls.gridlist[1], "Red", 0.08)
		ctrl4 = guiGridListAddColumn(controls.gridlist[1], "Green", 0.08)
		ctrl5 = guiGridListAddColumn(controls.gridlist[1], "Blue", 0.08)
		ctrl6 = guiGridListAddColumn(controls.gridlist[1], "Alpha", 0.08)
		ctrl7 = guiGridListAddColumn(controls.gridlist[1], "Width", 0.08)
		ctrl8 = guiGridListAddColumn(controls.gridlist[1], "Amount", 0.09)
		ctrl9 = guiGridListAddColumn(controls.gridlist[1], "Lowest offset", 0.3)
		guiGridListSetSelectionMode(controls.gridlist[1], 0)
		
		for i=1,#laserpoints do
			row = guiGridListAddRow(controls.gridlist[1])
			guiGridListSetItemText(controls.gridlist[1], row, ctrl1, i, false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl2, laserpoints[i][7], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl3, laserpoints[i][8], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl4, laserpoints[i][9], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl5, laserpoints[i][10], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl6, laserpoints[i][11], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl7, laserpoints[i][12], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl8, laserpoints[i][13], false, false)
			guiGridListSetItemText(controls.gridlist[1], row, ctrl9, laserpoints[i][14], false, false)
		end
		
		controls.button[1] = guiCreateButton(10, 193, 132, 31, string.upper("Raise laser"), false, controls_window)
		guiSetFont(controls.button[1], "default-small")
		
		controls.button[2] = guiCreateButton(152, 193, 132, 31, string.upper("Lower laser"), false, controls_window)
		guiSetFont(controls.button[2], "default-small")
		
		controls.button[3] = guiCreateButton(294, 193, 132, 31, string.upper("Set color"), false, controls_window)
		guiSetFont(controls.button[3], "default-small")
		
		controls.button[4] = guiCreateButton(436, 193, 132, 31, string.upper("Set alpha"), false, controls_window)
		guiSetFont(controls.button[4], "default-small")
		
		controls.button[5] = guiCreateButton(10, 234, 132, 31, string.upper("Set width"), false, controls_window)
		guiSetFont(controls.button[5], "default-small")
		
		controls.button[6] = guiCreateButton(152, 234, 132, 31, string.upper("Set amount"), false, controls_window)
		guiSetFont(controls.button[6], "default-small")
		
		controls.button[7] = guiCreateButton(294, 234, 132, 31, string.upper("Set lowest offset"), false, controls_window)
		guiSetFont(controls.button[7], "default-small")
		
		controls.button[8] = guiCreateButton(436, 234, 132, 31, string.upper("Close window"), false, controls_window)
		guiSetFont(controls.button[8], "default-small")
		
		showCursor(true)
		
		addEventHandler("onClientGUIClick", controls.button[1], moveUpControl, false)
		addEventHandler("onClientGUIClick", controls.button[2], moveDownControl, false)
		addEventHandler("onClientGUIClick", controls.button[3], showColorControls, false)
		addEventHandler("onClientGUIClick", controls.button[4], showAlphaControls, false)
		addEventHandler("onClientGUIClick", controls.button[5], showWidthControls, false)
		addEventHandler("onClientGUIClick", controls.button[6], showAmountControls, false)
		addEventHandler("onClientGUIClick", controls.button[7], showOffsetControls, false)
		addEventHandler("onClientGUIClick", controls.button[8], closeAllControls, false)
	else
		closeAllControls()
	end
end
addCommandHandler("sctrl", showLaserControls, false, false)

-- Move the laser upwards
function moveUpControl()
	if not allowedUsername(localPlayer) then return end
	local row, column = guiGridListGetSelectedItem(controls.gridlist[1])
	if row ~= -1 and column ~= -1 then
		triggerServerEvent("laser:move", localPlayer, 1, row+1)
	else
		triggerServerEvent("laser:move", localPlayer, 1)
	end
end

-- Move the laser downwards
function moveDownControl()
	if not allowedUsername(localPlayer) then return end
	local row, column = guiGridListGetSelectedItem(controls.gridlist[1])
	if row ~= -1 and column ~= -1 then
		triggerServerEvent("laser:move", localPlayer, 2, row+1)
	else
		triggerServerEvent("laser:move", localPlayer, 2)
	end
end

-- Colors controls
function showColorControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(colors_window) then
		local crow, column = guiGridListGetSelectedItem(controls.gridlist[1])
		if crow ~= -1 and column ~= -1 then
			guiSetEnabled(controls_window, false)
			
			colors = {
				button = {},
				edit = {}
			}
			
			colors_window = guiCreateWindow(802, 448, 281, 152, "Colors", false)
			guiWindowSetSizable(colors_window, false)
			guiSetAlpha(colors_window, 0.70)

			colors.edit[1] = guiCreateEdit(9, 28, 81, 35, guiGridListGetItemText(controls.gridlist[1], crow, ctrl3), false, colors_window)
			colors.edit[2] = guiCreateEdit(100, 28, 81, 35, guiGridListGetItemText(controls.gridlist[1], crow, ctrl4), false, colors_window)
			colors.edit[3] = guiCreateEdit(191, 28, 81, 35, guiGridListGetItemText(controls.gridlist[1], crow, ctrl5), false, colors_window)
			
			colors.button[1] = guiCreateButton(9, 69, 263, 34, string.upper("Accept & Close"), false, colors_window)
			guiSetFont(colors.button[1], "default-small")
			
			colors.button[2] = guiCreateButton(10, 108, 262, 34, string.upper("Cancel & Close"), false, colors_window)
			guiSetFont(colors.button[2], "default-small")
			
			addEventHandler("onClientGUIClick", colors.button[1], function() triggerServerEvent("laser:colors", localPlayer, tonumber(crow)+1, tonumber(guiGetText(colors.edit[1])), tonumber(guiGetText(colors.edit[2])), tonumber(guiGetText(colors.edit[3]))) end, false)
			addEventHandler("onClientGUIClick", colors.button[2], function() closeAllControls() showLaserControls() end, false)
			
			showCursor(true, true)
		else
			outputChatBox("Select a laser from the list.", 255, 0, 0, false)
		end
	else
		guiSetEnabled(controls_window, true)
		destroyElement(colors_window)
		showCursor(false, false)
	end
end

-- Alpha controls
function showAlphaControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(alpha_window) then
		local arow, column = guiGridListGetSelectedItem(controls.gridlist[1])
		if arow ~= -1 and column ~= -1 then
			guiSetEnabled(controls_window, false)
			
			alpha = {
				button = {},
				edit = {}
			}
			
			alpha_window = guiCreateWindow(874, 440, 142, 152, "Alpha", false)
			guiWindowSetSizable(alpha_window, false)
			guiSetAlpha(alpha_window, 0.70)

			alpha.edit[1] = guiCreateEdit(9, 28, 124, 35, guiGridListGetItemText(controls.gridlist[1], arow, ctrl6), false, alpha_window)
			
			alpha.button[1] = guiCreateButton(9, 69, 124, 34, string.upper("Accept & Close"), false, alpha_window)
			guiSetFont(alpha.button[1], "default-small")
			
			alpha.button[2] = guiCreateButton(10, 108, 123, 34, string.upper("Cancel & Close"), false, alpha_window)
			guiSetFont(alpha.button[2], "default-small")
			
			addEventHandler("onClientGUIClick", alpha.button[1], function() triggerServerEvent("laser:alpha", localPlayer, tonumber(arow)+1, guiGetText(alpha.edit[1])) end, false)
			addEventHandler("onClientGUIClick", alpha.button[2], function() closeAllControls() showLaserControls() end, false)
			
			showCursor(true, true)
		else
			outputChatBox("Select a laser from the list.", 255, 0, 0, false)
		end
	else
		guiSetEnabled(controls_window, true)
		destroyElement(alpha_window)
		showCursor(false, false)
	end
end

-- Width controls
function showWidthControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(width_window) then
		local wrow, column = guiGridListGetSelectedItem(controls.gridlist[1])
		if wrow ~= -1 and column ~= -1 then
			guiSetEnabled(controls_window, false)
			
			width = {
				button = {},
				edit = {}
			}
			
			width_window = guiCreateWindow(874, 440, 142, 152, "Width", false)
			guiWindowSetSizable(width_window, false)
			guiSetAlpha(width_window, 0.70)

			width.edit[1] = guiCreateEdit(9, 28, 124, 35, guiGridListGetItemText(controls.gridlist[1], wrow, ctrl7), false, width_window)
			
			width.button[1] = guiCreateButton(9, 69, 124, 34, string.upper("Accept & Close"), false, width_window)
			guiSetFont(width.button[1], "default-small")
			
			width.button[2] = guiCreateButton(10, 108, 123, 34, string.upper("Cancel & Close"), false, width_window)
			guiSetFont(width.button[2], "default-small")
			
			addEventHandler("onClientGUIClick", width.button[1], function() triggerServerEvent("laser:width", localPlayer, tonumber(wrow)+1, guiGetText(width.edit[1])) end, false)
			addEventHandler("onClientGUIClick", width.button[2], function() closeAllControls() showLaserControls() end, false)
			
			showCursor(true, true)
		else
			outputChatBox("Select a laser from the list.", 255, 0, 0, false)
		end
	else
		guiSetEnabled(controls_window, true)
		destroyElement(width_window)
		showCursor(false, false)
	end
end

-- Amount controls
function showAmountControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(amount_window) then
		local amrow, column = guiGridListGetSelectedItem(controls.gridlist[1])
		if amrow ~= -1 and column ~= -1 then
			guiSetEnabled(controls_window, false)
			
			amount = {
				button = {},
				edit = {}
			}
			
			amount_window = guiCreateWindow(874, 440, 142, 152, "Amount", false)
			guiWindowSetSizable(amount_window, false)
			guiSetAlpha(amount_window, 0.70)

			amount.edit[1] = guiCreateEdit(9, 28, 124, 35, guiGridListGetItemText(controls.gridlist[1], amrow, ctrl8), false, amount_window)
			
			amount.button[1] = guiCreateButton(9, 69, 124, 34, string.upper("Accept & Close"), false, amount_window)
			guiSetFont(amount.button[1], "default-small")
			
			amount.button[2] = guiCreateButton(10, 108, 123, 34, string.upper("Cancel & Close"), false, amount_window)
			guiSetFont(amount.button[2], "default-small")
			
			addEventHandler("onClientGUIClick", amount.button[1], function() triggerServerEvent("laser:amount", localPlayer, tonumber(amrow)+1, guiGetText(amount.edit[1])) end, false)
			addEventHandler("onClientGUIClick", amount.button[2], function() closeAllControls() showLaserControls() end, false)
			
			showCursor(true, true)
		else
			outputChatBox("Select a laser from the list.", 255, 0, 0, false)
		end
	else
		guiSetEnabled(controls_window, true)
		destroyElement(amount_window)
		showCursor(false, false)
	end
end

-- Offset controls
function showOffsetControls()
	if not allowedUsername(localPlayer) then return end
	if not isElement(offset_window) then
		local orow, column = guiGridListGetSelectedItem(controls.gridlist[1])
		if orow ~= -1 and column ~= -1 then
			guiSetEnabled(controls_window, false)
			
			offset = {
				button = {},
				edit = {}
			}
			
			offset_window = guiCreateWindow(874, 440, 142, 152, "Offset", false)
			guiWindowSetSizable(offset_window, false)
			guiSetAlpha(offset_window, 0.70)

			offset.edit[1] = guiCreateEdit(9, 28, 124, 35, guiGridListGetItemText(controls.gridlist[1], orow, ctrl9), false, offset_window)
			
			offset.button[1] = guiCreateButton(9, 69, 124, 34, string.upper("Accept & Close"), false, offset_window)
			guiSetFont(offset.button[1], "default-small")
			
			offset.button[2] = guiCreateButton(10, 108, 123, 34, string.upper("Cancel & Close"), false, offset_window)
			guiSetFont(offset.button[2], "default-small")
			
			addEventHandler("onClientGUIClick", offset.button[1], function() triggerServerEvent("laser:offset", localPlayer, tonumber(orow)+1, guiGetText(offset.edit[1])) end, false)
			addEventHandler("onClientGUIClick", offset.button[2], function() closeAllControls() showLaserControls() end, false)
			
			showCursor(true, true)
		else
			outputChatBox("Select a laser from the list.", 255, 0, 0, false)
		end
	else
		guiSetEnabled(controls_window, true)
		destroyElement(offset_window)
		showCursor(false, false)
	end
end

-- Function to close all windows
function closeAllControls()
	if isElement(controls_window) then destroyElement(controls_window) end
	if isElement(colors_window) then destroyElement(colors_window) end
	if isElement(alpha_window) then destroyElement(alpha_window) end
	if isElement(width_window) then destroyElement(width_window) end
	if isElement(amount_window) then destroyElement(amount_window) end
	if isElement(offset_window) then destroyElement(offset_window) end
	showCursor(false, false)
end