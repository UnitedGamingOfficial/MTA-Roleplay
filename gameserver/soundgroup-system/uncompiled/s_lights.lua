--[[
	*
	* SoundGroup Corporation - System
	* File: s_lights.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local bpm = 128
local counted = bpm*3.5
local sMarkers = { {}, {}, {} }
local dr, dg, db, da = 255, 255, 255, 255
local markers = {
	{
		{-2109.24, 224.53, 46.07, 255, 255, 255, 155},
		{-2109.36, 232.18, 46.07, 255, 255, 255, 155},
		{-2109.56, 240.27, 46.07, 255, 255, 255, 155},
		{-2109.54, 259.08, 46.07, 255, 255, 255, 155},
		{-2109.34, 242.95, 46.07, 255, 255, 255, 155},
		{-2109.14, 250.76, 46.07, 255, 255, 255, 155},
		{-2109.3, 261.75, 46.07, 255, 255, 255, 155},
		{-2109.35, 277.85, 46.07, 255, 255, 255, 155},
		{-2109.42, 269.71, 46.07, 255, 255, 255, 155}
	},
	
	{
		{-1492.12, 722.17, 18.58, 255, 255, 255, 255},
		{-1492.28, 708.60, 18.58, 255, 255, 255, 255},
		{-1501.10, 698.97, 18.58, 255, 255, 255, 255},
		{-1514.79, 698.87, 18.58, 255, 255, 255, 255},
		{-1524.19, 707.91, 18.58, 255, 255, 255, 255},
		{-1524.11, 721.77, 18.58, 255, 255, 255, 255}
	},
	
	{
		{-1492.12, 722.17, 26.58, 255, 255, 255, 255},
		{-1492.28, 708.60, 26.58, 255, 255, 255, 255},
		{-1501.10, 698.97, 26.58, 255, 255, 255, 255},
		{-1514.79, 698.87, 26.58, 255, 255, 255, 255},
		{-1524.19, 707.91, 26.58, 255, 255, 255, 255},
		{-1524.11, 721.77, 26.58, 255, 255, 255, 255}
	}
}

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i,v in ipairs(markers[1]) do
			sMarkers[1][i] = createMarker(markers[1][i][1], markers[1][i][2], markers[1][i][3], "corona", 4, markers[1][i][4], markers[1][i][5], markers[1][i][6], markers[1][i][7])
		end

		for i,v in ipairs(markers[2]) do
			sMarkers[2][i] = createMarker(markers[2][i][1], markers[2][i][2], markers[2][i][3], "corona", 4, markers[2][i][4], markers[2][i][5], markers[2][i][6], markers[2][i][7])
		end

		for i,v in ipairs(markers[3]) do
			sMarkers[3][i] = createMarker(markers[3][i][1], markers[3][i][2], markers[3][i][3], "corona", 4, markers[3][i][4], markers[3][i][5], markers[3][i][6], markers[3][i][7])
		end
	end
)

addCommandHandler("psetbpm",
	function(player, cmd, nbpm)
		if not allowedUsername(player, cmd) then return end
		local nbpm = tonumber(nbpm)
		if nbpm then
			if nbpm >= 15 then
				bpm = nbpm
				counted = bpm*3.5
				outputChatBox("The BPM is now '" .. nbpm .. "'.", player, 40, 245, 40, false)
			else
				outputChatBox("BPM must be at least 15.", player, 245, 40, 40, false)
			end
		else
			outputChatBox("Syntax: /" .. cmd .. " [bpm]", player, 245, 180, 40, false)
		end
	end
)

addCommandHandler("psetcolors",
	function(player, cmd, r, g, b, a)
		if not allowedUsername(player, cmd) then return end
		local r = tonumber(r)
		local g = tonumber(g)
		local b = tonumber(b)
		local a = tonumber(a)
		if r and g and b and a then
			dr, dg, db, da = r, g, b, a
			for i,v in ipairs(sMarkers) do
				local mr, mg, mb, ma = getMarkerColor(v)
				if mr == 255 and mg == 255 and mb == 255 then
					return
				else
					setMarkerColor(sMarkers[i][1], dr, dg, db, da)
					setMarkerColor(sMarkers[i][2], dr, dg, db, da)
					setMarkerColor(sMarkers[i][3], dr, dg, db, da)
					setMarkerColor(sMarkers[i][4], dr, dg, db, da)
					setMarkerColor(sMarkers[i][5], dr, dg, db, da)
					setMarkerColor(sMarkers[i][6], dr, dg, db, da)
				end
			end
			outputChatBox("The default colors are now '" .. r .. ", " .. g .. ", " .. b .. ", " .. a .. "'.", player, 40, 245, 40, false)
		else
			outputChatBox("Syntax: /" .. cmd .. " [red] [green] [blue] [alpha]", player, 245, 180, 40, false)
		end
	end
)

function beginSurround(player, cmd, mode)
	if player ~= nil and cmd ~= nil then
		if not allowedUsername(player, cmd) then
			return
		end
	end
	local mode = tonumber(mode)
	if mode then
		if mode == 1 then
			if transitions[1][5] == false then
				transitions[1][5] = true
				mode1t = setTimer(function()
					setMarkerColor(sMarkers[1][6], dr, dg, db, da)
					setMarkerColor(sMarkers[2][6], dr, dg, db, da)
					setMarkerColor(sMarkers[3][6], dr, dg, db, da)
					setMarkerColor(sMarkers[1][1], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
					setMarkerColor(sMarkers[2][1], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
					setMarkerColor(sMarkers[3][1], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
					mode1t = setTimer(function()
						setMarkerColor(sMarkers[1][1], dr, dg, db, da)
						setMarkerColor(sMarkers[2][1], dr, dg, db, da)
						setMarkerColor(sMarkers[3][1], dr, dg, db, da)
						setMarkerColor(sMarkers[1][2], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
						setMarkerColor(sMarkers[2][2], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
						setMarkerColor(sMarkers[3][2], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
						mode1t = setTimer(function()
							setMarkerColor(sMarkers[1][2], dr, dg, db, da)
							setMarkerColor(sMarkers[2][2], dr, dg, db, da)
							setMarkerColor(sMarkers[3][2], dr, dg, db, da)
							setMarkerColor(sMarkers[1][3], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
							setMarkerColor(sMarkers[2][3], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
							setMarkerColor(sMarkers[3][3], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
							mode1t = setTimer(function()
								setMarkerColor(sMarkers[1][3], dr, dg, db, da)
								setMarkerColor(sMarkers[2][3], dr, dg, db, da)
								setMarkerColor(sMarkers[3][3], dr, dg, db, da)
								setMarkerColor(sMarkers[1][4], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
								setMarkerColor(sMarkers[2][4], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
								setMarkerColor(sMarkers[3][4], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
								mode1t = setTimer(function()
									setMarkerColor(sMarkers[1][4], dr, dg, db, da)
									setMarkerColor(sMarkers[2][4], dr, dg, db, da)
									setMarkerColor(sMarkers[3][4], dr, dg, db, da)
									setMarkerColor(sMarkers[1][5], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
									setMarkerColor(sMarkers[2][5], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
									setMarkerColor(sMarkers[3][5], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
									mode1t = setTimer(function()
										setMarkerColor(sMarkers[1][5], dr, dg, db, da)
										setMarkerColor(sMarkers[2][5], dr, dg, db, da)
										setMarkerColor(sMarkers[3][5], dr, dg, db, da)
										setMarkerColor(sMarkers[1][6], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
										setMarkerColor(sMarkers[2][6], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
										setMarkerColor(sMarkers[3][6], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
										transitions[1][5] = false
										beginSurround(nil, nil, mode)
									end, counted, 1)
								end, counted, 1)
							end, counted, 1)
						end, counted, 1)
					end, counted, 1)
				end, counted, 1)
			else
				transitions[1][5] = false
				if isTimer(mode1t) then killTimer(mode1t) end
				for i,v in ipairs(sMarkers) do
					setMarkerColor(sMarkers[i][1], dr, dg, db, da)
					setMarkerColor(sMarkers[i][2], dr, dg, db, da)
					setMarkerColor(sMarkers[i][3], dr, dg, db, da)
					setMarkerColor(sMarkers[i][4], dr, dg, db, da)
					setMarkerColor(sMarkers[i][5], dr, dg, db, da)
					setMarkerColor(sMarkers[i][6], dr, dg, db, da)
				end
			end
		elseif mode == 2 then
			if transitions[2][5] == false then
				transitions[2][5] = true
				mode2t = setTimer(function()
					for i,v in ipairs(sMarkers[1]) do
						setMarkerColor(sMarkers[1][i], dr, dg, db, da)
					end
					for i,v in ipairs(sMarkers[3]) do
						setMarkerColor(sMarkers[3][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
					end
					mode2t = setTimer(function()
						for i,v in ipairs(sMarkers[3]) do
							setMarkerColor(sMarkers[3][i], dr, dg, db, da)
						end
						for i,v in ipairs(sMarkers[2]) do
							setMarkerColor(sMarkers[2][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
						end
						mode2t = setTimer(function()
							for i,v in ipairs(sMarkers[2]) do
								setMarkerColor(sMarkers[2][i], dr, dg, db, da)
							end
							for i,v in ipairs(sMarkers[1]) do
								setMarkerColor(sMarkers[1][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
							end
							transitions[2][5] = false
							beginSurround(nil, nil, mode)
						end, counted, 1)
					end, counted, 1)
				end, counted, 1)
			else
				transitions[2][5] = false
				if isTimer(mode2t) then killTimer(mode2t) end
				for i,v in ipairs(sMarkers) do
					setMarkerColor(sMarkers[i][1], dr, dg, db, da)
					setMarkerColor(sMarkers[i][2], dr, dg, db, da)
					setMarkerColor(sMarkers[i][3], dr, dg, db, da)
					setMarkerColor(sMarkers[i][4], dr, dg, db, da)
					setMarkerColor(sMarkers[i][5], dr, dg, db, da)
					setMarkerColor(sMarkers[i][6], dr, dg, db, da)
				end
			end
		elseif mode == 3 then
			if transitions[3][5] == false then
				transitions[3][5] = true
				mode3t = setTimer(function()
					setMarkerColor(sMarkers[1][1], dr, dg, db, da)
					setMarkerColor(sMarkers[2][1], dr, dg, db, da)
					setMarkerColor(sMarkers[3][1], dr, dg, db, da)
					setMarkerColor(sMarkers[1][6], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
					setMarkerColor(sMarkers[2][6], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
					setMarkerColor(sMarkers[3][6], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
					mode3t = setTimer(function()
						setMarkerColor(sMarkers[1][6], dr, dg, db, da)
						setMarkerColor(sMarkers[2][6], dr, dg, db, da)
						setMarkerColor(sMarkers[3][6], dr, dg, db, da)
						setMarkerColor(sMarkers[1][5], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
						setMarkerColor(sMarkers[2][5], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
						setMarkerColor(sMarkers[3][5], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
						mode3t = setTimer(function()
							setMarkerColor(sMarkers[1][5], dr, dg, db, da)
							setMarkerColor(sMarkers[2][5], dr, dg, db, da)
							setMarkerColor(sMarkers[3][5], dr, dg, db, da)
							setMarkerColor(sMarkers[1][4], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
							setMarkerColor(sMarkers[2][4], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
							setMarkerColor(sMarkers[3][4], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
							mode3t = setTimer(function()
								setMarkerColor(sMarkers[1][4], dr, dg, db, da)
								setMarkerColor(sMarkers[2][4], dr, dg, db, da)
								setMarkerColor(sMarkers[3][4], dr, dg, db, da)
								setMarkerColor(sMarkers[1][3], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
								setMarkerColor(sMarkers[2][3], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
								setMarkerColor(sMarkers[3][3], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
								mode3t = setTimer(function()
									setMarkerColor(sMarkers[1][3], dr, dg, db, da)
									setMarkerColor(sMarkers[2][3], dr, dg, db, da)
									setMarkerColor(sMarkers[3][3], dr, dg, db, da)
									setMarkerColor(sMarkers[1][2], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
									setMarkerColor(sMarkers[2][2], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
									setMarkerColor(sMarkers[3][2], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
									mode3t = setTimer(function()
										setMarkerColor(sMarkers[1][2], dr, dg, db, da)
										setMarkerColor(sMarkers[2][2], dr, dg, db, da)
										setMarkerColor(sMarkers[3][2], dr, dg, db, da)
										setMarkerColor(sMarkers[1][1], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
										setMarkerColor(sMarkers[2][1], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
										setMarkerColor(sMarkers[3][1], transitions[3][1], transitions[3][2], transitions[3][3], transitions[3][4])
										transitions[3][5] = false
										beginSurround(nil, nil, mode)
									end, counted, 1)
								end, counted, 1)
							end, counted, 1)
						end, counted, 1)
					end, counted, 1)
				end, counted, 1)
			else
				transitions[3][5] = false
				if isTimer(mode3t) then killTimer(mode3t) end
				for i,v in ipairs(sMarkers) do
					setMarkerColor(sMarkers[i][1], dr, dg, db, da)
					setMarkerColor(sMarkers[i][2], dr, dg, db, da)
					setMarkerColor(sMarkers[i][3], dr, dg, db, da)
					setMarkerColor(sMarkers[i][4], dr, dg, db, da)
					setMarkerColor(sMarkers[i][5], dr, dg, db, da)
					setMarkerColor(sMarkers[i][6], dr, dg, db, da)
				end
			end
		elseif mode == 4 then
			if transitions[4][5] == false then
				transitions[4][5] = true
				mode4t = setTimer(function()
					for i,v in ipairs(sMarkers[3]) do
						setMarkerColor(sMarkers[3][i], dr, dg, db, da)
					end
					for i,v in ipairs(sMarkers[1]) do
						setMarkerColor(sMarkers[1][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
					end
					mode4t = setTimer(function()
						for i,v in ipairs(sMarkers[1]) do
							setMarkerColor(sMarkers[1][i], dr, dg, db, da)
						end
						for i,v in ipairs(sMarkers[2]) do
							setMarkerColor(sMarkers[2][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
						end
						mode4t = setTimer(function()
							for i,v in ipairs(sMarkers[2]) do
								setMarkerColor(sMarkers[2][i], dr, dg, db, da)
							end
							for i,v in ipairs(sMarkers[3]) do
								setMarkerColor(sMarkers[3][i], transitions[4][1], transitions[4][2], transitions[4][3], transitions[4][4])
							end
							transitions[4][5] = false
							beginSurround(nil, nil, mode)
						end, counted, 1)
					end, counted, 1)
				end, counted, 1)
			else
				transitions[4][5] = false
				if isTimer(mode4t) then killTimer(mode4t) end
				for i,v in ipairs(sMarkers) do
					setMarkerColor(sMarkers[i][1], dr, dg, db, da)
					setMarkerColor(sMarkers[i][2], dr, dg, db, da)
					setMarkerColor(sMarkers[i][3], dr, dg, db, da)
					setMarkerColor(sMarkers[i][4], dr, dg, db, da)
					setMarkerColor(sMarkers[i][5], dr, dg, db, da)
					setMarkerColor(sMarkers[i][6], dr, dg, db, da)
				end
			end
		end
	else
		if player ~= nil then
			outputChatBox("Syntax: /" .. cmd .. " [mode]", player, 245, 180, 40, false)
		end
	end
end
addCommandHandler("psetsurround", beginSurround)

transitions = {
	-- red, green, blue, alpha, state
	{255, 255, 255, 100, false},
	{255, 255, 255, 100, false},
	{255, 255, 255, 100, false},
	{255, 255, 255, 100, false}
}