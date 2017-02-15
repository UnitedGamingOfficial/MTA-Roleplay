--[[
	*
	* SoundGroup Corporation - System
	* File: c_fireworks.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local number = 130
local height = 2.8
local randomness = 0.55
local maxsize = 28
local resetdelay = number * 200
local status1 = false
local status2 = false

addEvent("onClientCreateFireworks", true)
addEventHandler("onClientCreateFireworks", root,
	function(trailer, mode)
		if mode == 1 then
			if not status1 then
				status1 = true
				setTimer(function()
					delay = math.random(350, 750)
					setTimer(function()
						local fx, fy, fz = getElementPosition(trailer)
						fz = fz+2
						local shell = createVehicle(594, fx, fy, fz)
						if isElement(shell) then
							setElementAlpha(shell,0)
							local flair = createMarker(fx, fy, fz, "corona", 1, 255, 255, 255, 255)
							attachElements(flair, shell)
							local smoke = createObject(2780, 0, 0, 0)
							setElementCollidableWith(smoke, shell, false)
							setElementAlpha(smoke, 0)
							attachElements (smoke, shell)
							setElementVelocity(shell, math.random(-2,2)*randomness, math.random(-2,2)*randomness, height)
							setTimer(function(shell, flair, smoke)
								local ex, ey, ez = getElementPosition(shell)
								createExplosion(ex, ey, ez, 11)
								setMarkerColor(flair, math.random(0,255), math.random(0,255), math.random(0,255), 155)
								sizetime = math.random(7, maxsize)
								setTimer (function(shell, flair, smoke)
									if isElement(flair) then
										local size = getMarkerSize(flair)
										setMarkerSize(flair, size+5)
									end
									setTimer(function(shell, flair, smoke)
										if isElement(flair)then
											destroyElement(flair)
										end
										if isElement(shell) then
											destroyElement(shell)
										end
										if isElement(smoke) then
											destroyElement(smoke)
										end
									end, sizetime*100,1, shell, flair, smoke)
								end, 100, sizetime, shell, flair, smoke)
							end, 1400, 1, shell, flair, smoke)
						end
					end, delay, 1, trailer)
				end, 230, number, trailer)
				setTimer(function()
					status1 = false
				end, resetdelay, 1)
			end
		elseif mode == 2 then
			if not status2 then
				status2 = true
				setTimer(function()
					delay = math.random(350, 750)
					setTimer(function()
						local fx, fy, fz = getElementPosition(trailer)
						fz = fz
						local shell = createVehicle(594, fx, fy, fz)
						if isElement(shell) then
							setElementAlpha(shell,0)
							local flair = createMarker(fx, fy, fz, "corona", 1, 255, 255, 255, 255)
							attachElements(flair, shell)
							local smoke = createObject(2780, 0, 0, 0)
							setElementCollidableWith(smoke, shell, false)
							setElementAlpha(smoke, 0)
							attachElements (smoke, shell)
							setElementVelocity(shell, math.random(-2,2)*randomness, math.random(-2,2)*randomness, height)
							setTimer(function(shell, flair, smoke)
								local ex, ey, ez = getElementPosition(shell)
								createExplosion(ex, ey, ez, 11)
								setMarkerColor(flair, math.random(0,255), math.random(0,255), math.random(0,255), 155)
								sizetime = math.random(7, maxsize)
								setTimer (function(shell, flair, smoke)
									if isElement(flair) then
										local size = getMarkerSize(flair)
										setMarkerSize(flair, size+5)
									end
									setTimer(function(shell, flair, smoke)
										if isElement(flair)then
											destroyElement(flair)
										end
										if isElement(shell) then
											destroyElement(shell)
										end
										if isElement(smoke) then
											destroyElement(smoke)
										end
									end, sizetime*100,1, shell, flair, smoke)
								end, 100, sizetime, shell, flair, smoke)
							end, 1400, 1, shell, flair, smoke)
						end
					end, delay, 1, trailer)
				end, 230, number, trailer)
				setTimer(function()
					status2 = false
				end, resetdelay, 1)
			end
		end
	end
)