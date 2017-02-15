--[[
	*
	* SoundGroup Corporation - System
	* File: s_lasers.lua
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

local speed = 1.5

-- Command to control the speed of the movement commands (+)
addCommandHandler("speedmoveup",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		speed = speed+0.5
		outputChatBox("Speed increased +0.5 (speed : " .. speed .. ")", player, 0, 255, 0, false)
	end
)

-- Command to control the speed of the movement commands (-)
addCommandHandler("speedmovedown",
	function(player, cmd)
		if not allowedUsername(player, cmd) then return end
		speed = speed-0.5
		outputChatBox("Speed decreased -0.5 (speed : " .. speed .. ")", player, 0, 255, 0, false)
	end
)

-- Command to control the speed yourself
addCommandHandler("speedmove",
	function(player, cmd, change)
		if not allowedUsername(player, cmd) then return end
		local change = tonumber(change)
		if change then
			speed = change
			outputChatBox("Speed set to " .. speed .. ".", player, 0, 255, 0, false)
		else
			outputChatBox("Syntax: /" .. cmd .. " [speed]", player, 220, 180, 40, false)
		end
	end
)

-- Doing the movement of the lasers
addEvent("laser:move", true)
addEventHandler("laser:move", root,
	function(state, id)
		if state == 1 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][6] = laserpoints[i][6]+speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][6] = laserpoints[i][6]+speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		elseif state == 2 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][6] = laserpoints[i][6]-speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][6] = laserpoints[i][6]-speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		elseif state == 3 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][4] = laserpoints[i][4]+speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][4] = laserpoints[i][4]+speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		elseif state == 4 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][4] = laserpoints[i][4]-speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][4] = laserpoints[i][4]-speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		elseif state == 5 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][5] = laserpoints[i][5]+speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][5] = laserpoints[i][5]+speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		elseif state == 6 then
			for i=1,#laserpoints do
				if not id then
					laserpoints[i][5] = laserpoints[i][5]-speed
					triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
				else
					if i == id then
						laserpoints[i][5] = laserpoints[i][5]-speed
						triggerClientEvent(root, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
					end
				end
			end
		end
	end
)

-- Fetch the maximum amount of lasers spawned when resource starts
addEventHandler("onResourceStart", resourceRoot,
	function()
		setTimer(triggerClientEvent, 150, 1, root, "laser:#", root)
	end
)

-- Initialize the maximum amount of lasers ID server-side
addEvent("laser:#r", true)
addEventHandler("laser:#r", root,
	function(max)
		maxid = max
	end
)

-- Synchronize club lasers with new clients
addEvent("laser:sync", true)
addEventHandler("laser:sync", root,
	function()
		triggerEvent("club:sync", source)
	end
)

-- Synchronize club lasers with new clients
addEvent("club:sync", true)
addEventHandler("club:sync", root,
	function()
		for i=1,#laserpoints do
			triggerClientEvent(source, "laser:pos", source, i, laserpoints[i][1], laserpoints[i][2], laserpoints[i][3])
			triggerClientEvent(source, "laser:point", source, i, laserpoints[i][4], laserpoints[i][5], laserpoints[i][6])
			triggerClientEvent(source, "laser:level", source, i, laserpoints[i][14])
			triggerClientEvent(source, "laser:width", source, i, laserpoints[i][12])
			triggerClientEvent(source, "laser:mode", source, i, laserpoints[i][7])
			triggerClientEvent(source, "laser:colors", source, i, laserpoints[i][8], laserpoints[i][9], laserpoints[i][10])
			triggerClientEvent(source, "laser:amount", source, i, laserpoints[i][13])
			triggerClientEvent(source, "laser:alpha", source, i, laserpoints[i][11])
		end
	end
)

-- Set the laser start position
addCommandHandler("laserpos",
	function(player, cmd, id)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if id > 0 and id <= maxid then
				local x, y, z = getElementPosition(player)
				triggerClientEvent(root, "laser:pos", player, id, x, y, z)
				laserpoints[id][1], laserpoints[id][2], laserpoints[id][3] = x, y, z
				outputChatBox("Laser ID " .. id .. "'s position changed.", player, 220, 180, 40, false)
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id].", player, 220, 180, 40, false)
		end
	end
)

-- Set the laser end position
addCommandHandler("laserpoint",
	function(player, cmd, id)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		if id then
			if id > 0 and id <= maxid then
				local x, y, z = getElementPosition(player)
				triggerClientEvent(root, "laser:point", player, id, x, y, z)
				laserpoints[id][4], laserpoints[id][5], laserpoints[id][6] = x, y, z
				outputChatBox("Laser ID " .. id .. "'s point position changed.", player, 220, 180, 40, false)
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id].", player, 220, 180, 40, false)
		end
	end
)

-- Set the laser mode two's lowest offset level
addCommandHandler("laserlowlevel",
	function(player, cmd, id, level)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local level = tonumber(level)
		if id and level then
			if id > 0 and id <= maxid then
				triggerClientEvent(root, "laser:level", player, id, level)
				laserpoints[id][14] = level
				outputChatBox("Laser level switched to " .. level .. ".", player, 220, 180, 40, false)
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [level].", player, 220, 180, 40, false)
		end
	end
)

-- Set the width of the laser beam
addCommandHandler("laserwidth",
	function(player, cmd, id, width)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local width = tonumber(width)
		if id and width then
			if id > 0 and id <= maxid then
				if width > 0 then
					triggerClientEvent(root, "laser:width", player, id, width)
					laserpoints[id][12] = width
					outputChatBox("Laser width switched to " .. width .. ".", player, 220, 180, 40, false)
				else
					outputChatBox("Syntax: /" .. cmd .. " [laser id] [width].", player, 220, 180, 40, false)
				end
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [width].", player, 220, 180, 40, false)
		end
	end
)

-- Set the mode of the laser
addCommandHandler("lasermode",
	function(player, cmd, id, state)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local state = tonumber(state)
		if id and state then
			if id > 0 and id <= maxid then
				if state >= 0 and state <= 3 then
					triggerClientEvent(root, "laser:mode", player, id, state)
					laserpoints[id][7] = state
					outputChatBox("Laser mode switched to " .. state .. ".", player, 220, 180, 40, false)
				else
					outputChatBox("Syntax: /" .. cmd .. " [laser id] [mode: 0-3].", player, 220, 180, 40, false)
				end
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [mode: 0-3].", player, 220, 180, 40, false)
		end
	end
)

-- Set the color of the laser
addCommandHandler("lasercolor",
	function(player, cmd, id, r, g, b)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local r = tonumber(r)
		local g = tonumber(g)
		local b = tonumber(b)
		if id and r and g and b then
			if id > 0 and id <= maxid then
				if (r >= 0 and r <= 255) and (g >= 0 and g <= 255) and (b >= 0 and b <= 255) then
					triggerClientEvent(root, "laser:colors", player, id, r, g, b)
					laserpoints[id][8], laserpoints[id][9], laserpoints[id][10] = r, g, b
					outputChatBox("Laser colors switched to " .. r .. ", " .. g .. ", " .. b .. ".", player, 220, 180, 0, false)
				else
					outputChatBox("Syntax: /" .. cmd .. " [laser id] [red: 0-255] [green: 0-255] [blue: 0-255]", player, 220, 180, 40, false)
				end
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [red: 0-255] [green: 0-255] [blue: 0-255]", player, 220, 180, 40, false)
		end
	end
)

-- Set the color of the laser
addCommandHandler("lasercolorauto",
	function(player, cmd, speed)
		if not allowedUsername(player, cmd) then return end
		local speed = tonumber(speed)
		if isTimer(autochange) then killTimer(autochange); st = 0; end
		if speed then
			if speed == 0 then return end
			if speed >= 50 then
				st = 0
				autochange = setTimer(function()
					if st == 0 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 0, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 0
						end
						st = st+1
					elseif st == 1 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 0, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 255
						end
						st = st+1
					elseif st == 2 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 255, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 255
						end
						st = st+1
					elseif st == 3 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 255, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 0
						end
						st = st+1
					elseif st == 4 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 0, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 0, 255
						end
						st = st+1
					elseif st == 5 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 255, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 0
						end
						st = st+1
					elseif st == 6 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 255, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 255
						end
						st = 0
					end
				end, speed, 0)
			else
				st = 0
				autochange = setTimer(function()
					if st == 0 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 0, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 0
						end
						st = st+1
					elseif st == 1 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 0, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 255
						end
						st = st+1
					elseif st == 2 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 255, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 255
						end
						st = st+1
					elseif st == 3 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 255, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 0
						end
						st = st+1
					elseif st == 4 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 0, 0, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 0, 255
						end
						st = st+1
					elseif st == 5 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 255, 0)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 0
						end
						st = st+1
					elseif st == 6 then
						for i=1,#laserpoints do
							triggerClientEvent(root, "laser:colors", player, i, 255, 255, 255)
							laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 255
						end
						st = 0
					end
				end, 468.75, 0)
			end
		else
			st = 0
			autochange = setTimer(function()
				if st == 0 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 255, 0, 0)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 0
					end
					st = st+1
				elseif st == 1 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 255, 0, 255)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 0, 255
					end
					st = st+1
				elseif st == 2 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 0, 255, 255)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 255
					end
					st = st+1
				elseif st == 3 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 0, 255, 0)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 255, 0
					end
					st = st+1
				elseif st == 4 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 0, 0, 255)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 0, 0, 255
					end
					st = st+1
				elseif st == 5 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 255, 255, 0)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 0
					end
					st = st+1
				elseif st == 6 then
					for i=1,#laserpoints do
						triggerClientEvent(root, "laser:colors", player, i, 255, 255, 255)
						laserpoints[i][8], laserpoints[i][9], laserpoints[i][10] = 255, 255, 255
					end
					st = 0
				end
			end, 468.75, 0)
		end
		outputChatBox("Laser colors switched to automatic.", player, 220, 180, 0, false)
	end
)

-- Set the amount of lasers spawned
addCommandHandler("laseramount",
	function(player, cmd, id, amount)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local amount = tonumber(amount)
		if id and amount then
			if id > 0 and id <= maxid then
				if amount >= 0 then
					triggerClientEvent(root, "laser:amount", player, id, amount)
					laserpoints[id][13] = amount
					outputChatBox("Amount of points is now " .. amount .. ".", player, 220, 180, 40, false)
				else
					outputChatBox("Syntax: /" .. cmd .. " [laser id] [amount of points: 0+]", player, 220, 180, 40, false)
				end
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [amount of points: 0+]", player, 220, 180, 40, false)
		end
	end
)

-- Set the alpha amount of the laser beam
addCommandHandler("laseralpha",
	function(player, cmd, id, alpha)
		if not allowedUsername(player, cmd) then return end
		local id = tonumber(id)
		local alpha = tonumber(alpha)
		if id and alpha then
			if id > 0 and id <= maxid then
				if alpha >= 0 and alpha <= 255 then
					triggerClientEvent(root, "laser:alpha", player, id, alpha)
					laserpoints[id][11] = alpha
					outputChatBox("Alpha of the laser beam is now " .. alpha .. ".", player, 220, 180, 40, false)
				else
					outputChatBox("Syntax: /" .. cmd .. " [laser id] [alpha: 0-255]", player, 220, 180, 40, false)
				end
			else
				outputChatBox("Invalid laser ID.", player, 255, 0, 0, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [laser id] [alpha: 0-255]", player, 220, 180, 40, false)
		end
	end
)

-- Events to handle all the stuff from client-side to server...
addEvent("laser:level", true)
addEventHandler("laser:level", root,
	function(id, level)
		laserpoints[id][14] = level
		triggerClientEvent(root, "laser:level", source, id, level)
	end
)

addEvent("laser:width", true)
addEventHandler("laser:width", root,
	function(id, width)
		laserpoints[id][12] = width
		triggerClientEvent(root, "laser:width", source, id, width)
	end
)

addEvent("laser:mode", true)
addEventHandler("laser:mode", root,
	function(id, mode)
		laserpoints[id][7] = mode
		triggerClientEvent(root, "laser:mode", source, id, mode)
	end
)

addEvent("laser:colors", true)
addEventHandler("laser:colors", root,
	function(id, r, g, b)
		laserpoints[id][8], laserpoints[id][9], laserpoints[id][10] = r, g, b
		triggerClientEvent(root, "laser:colors", source, id, r, g, b)
	end
)

addEvent("laser:amount", true)
addEventHandler("laser:amount", root,
	function(id, points)
		laserpoints[id][13] = points
		triggerClientEvent(root, "laser:amount", source, id, points)
	end
)

addEvent("laser:alpha", true)
addEventHandler("laser:alpha", root,
	function(id, alpha)
		laserpoints[id][11] = alpha
		triggerClientEvent(root, "laser:alpha", source, id, alpha)
	end
)