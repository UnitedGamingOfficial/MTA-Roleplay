--[[
	*
	* SoundGroup Corporation - System
	* File: c_screen.lua
	* Author: Socialz, Cazomino05
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local startx = -2087.35
local starty = 250.98
local startz = 46
local screenStartX = guiGetScreenSize()
local SPECWIDTH = screenStartX
local screenStartX = screenStartX * 0
local SPECHEIGHT = (SPECWIDTH / 16) * 7
local screenStartY = SPECHEIGHT / 2
local BANDS = 40
local use_dx = true
local effects = {}
local volume = 0.8
local speed = 1.0

local peakData, ticks, maxbpm, startTime, release, peak, peaks
function reset()
	peaks = {}
	for k=0, BANDS - 1 do
		peaks[k] = {}
	end
	peakData = {}
	ticks = getTickCount()
	maxbpm = 1
	bpmcount = 1
	startTime = 0
	release = {}
	peak = 0
end

addEvent("onEffectChange", true)
addEventHandler("onEffectChange", root,
	function(effect, state)
		if isElement(stream) then
			if state == "true" then
				setSoundEffectEnabled(stream, effect, true)
				if not effects[effect] then
					effects[#effects+1] = effect
				end
			elseif state == "false" then
				setSoundEffectEnabled(stream, effect, false)
				for i,v in ipairs(effects) do
					if v == effect then
						effects[i] = nil
						break
					end
				end
			end
		end
	end
)

addEvent("onVolumeChange", true)
addEventHandler("onVolumeChange", root,
	function(nvolume)
		if isElement(stream) then
			setSoundVolume(stream, nvolume)
			volume = nvolume
		end
	end
)

addEvent("onSpeedChange", true)
addEventHandler("onSpeedChange", root,
	function(nspeed)
		if isElement(stream) then
			setSoundSpeed(stream, nspeed)
			speed = nspeed
		end
	end
)

addEvent("screen:play", true)
addEventHandler("screen:play", root,
	function(url, x, y, z)
		if x and y and z then
			startx = x
			starty = y
			startz = z
		end
		
		if stream then
			destroyElement(stream)
		end
		
		-- Initializing the music
		stream = playSound3D(url, startx, starty, startz, true)
		setSoundMinDistance(stream, 60)
		setSoundMaxDistance(stream, 100)
		setSoundVolume(stream, volume)
		setSoundSpeed(stream, speed)
		
		if #effects > 0 then
			for _,v in ipairs(effects) do
				setSoundEffectEnabled(stream, v, true)
			end
		end
		
		setTimer(setSoundPanningEnabled, 1000, 1, stream, false)
		startTicks = getTickCount()
		ticks = getTickCount()
		reset()

		-- Initializing the shader
		shader_screen, tec = dxCreateShader("shaders/screen.fx")
		if not shader_screen then return end
		dxSetShaderValue(shader_screen, "gBrighten", -0.25)
		local radian = math.rad(0)
		dxSetShaderValue(shader_screen, "gRotAngle", radian)
		dxSetShaderValue(shader_screen, "gGrayScale", 0)
		dxSetShaderValue(shader_screen, "gRedColor", 0)
		dxSetShaderValue(shader_screen, "gGrnColor", 0)
		dxSetShaderValue(shader_screen, "gBluColor", 0)
		dxSetShaderValue(shader_screen, "gAlpha", 1)
		dxSetShaderValue(shader_screen, "gScrRig",  0)
		dxSetShaderValue(shader_screen, "gScrDow", 0)
		dxSetShaderValue(shader_screen, "gHScale", 1)
		dxSetShaderValue(shader_screen, "gVScale", 1)
		dxSetShaderValue(shader_screen, "gHOffset", 0)
		dxSetShaderValue(shader_screen, "gVOffset", 0)
		
		if not shader_screen then
			return
		else
			tar = dxCreateRenderTarget(SPECWIDTH, SPECHEIGHT)
			SPECWIDTH = SPECWIDTH - 6
			engineApplyShaderToWorldTexture(shader_screen, "drvin_screen")
		end
		
		addEventHandler("onClientRender", root,
			function ()
				local fftData = getSoundFFTData(stream, 2048, BANDS)
				local w, h = guiGetScreenSize()
				if fftData == false then
					return
				end
				calc(fftData, stream)
			end
		)
	end
)

function timetostring(input, input2)
	local minutes = input / 60
	local seconds = input % 60
	local minutes2 = input2 / 60
	local seconds2 = input2 % 60
	return string.format("%2.2i:%2.2i", minutes2, seconds2)
end

function avg(num)
	return maxbpm / bpmcount
end

function avg2(num1, num2, num)
	return (num1+num2)/num
end

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function getAverageBPM()
	return maxbpm / bpmcount
end
function min(num1, num2) 
	return num1 <= num2 and num1 or num2
end

function max(num1, num2) 
	return num1 >= num2 and num1 or num2
end

function calc(fft, stream)
	dxSetRenderTarget(tar, true)
	math.randomseed(getTickCount())
	local bpm = getSoundBPM(stream)
	
	if bpm == false or bpm == nil or bpm == 0 then
		bpm = 1
	end
	
	local calced = {}
	local y = 0
	local bC = 0
	local specbuf = 0
	local w, h = guiGetScreenSize()
	r, g, b = 0, 0, 0
	local var = bpm + 37
	
	if var <= 56 then
		r, g, b = 99, 184, 255
	end
	
	if var >= 57 and var < 83 then
		r, g, b = 238, 174, 238
	end
	
	if var >= 83 and var < 146 then
		r, g, b = 238, 174, 238
	end
	
	if var >= 146 and var < 166 then
		r, g, b = 99, 184, 255
	end
	
	if var > 166 and var <= 200 then
		r, g, b = 238, 201, 0
	end
	
	if var >= 200 then
		r, g, b = var, 0, 0
	end
	
	local tags = getSoundMetaTags(stream)
	local bSpawnParticles = true
	
	if (bpm <= 1) and (getSoundBPM(stream) == false) and (getSoundPosition(stream) <= 20) then
		r, g, b = 255, 255, 255
		dxDrawImage(0, 00, SPECWIDTH, SPECHEIGHT+100, "images/bg.png", 0, 0,0, tocolor(r, g, b, 255))
		bSpawnParticles = false
	else
		local var = 600
		local var2 = 400
		dxDrawImage(-var2, -var, SPECWIDTH+(var2*2), SPECHEIGHT+(var*2)+100, "images/bg.png", 0, 0,0, tocolor(r, g, b, 255))
	end
	
	local movespeed = (1 * (bpm / 180)) + 1
	local dir = bpm <= 100 and "down" or "up"
	local prevcalced = calced
	
	for x, peak in ipairs(fft) do
		local posx = x - 1
		peak = fft[x]
		y=math.sqrt(peak)*3*(SPECHEIGHT-4)
		
		if (y > 200+SPECHEIGHT) then
			y=SPECHEIGHT+200
		end
		
		calced[x] = y
		y = y - 1
		
		if y >= -1 then
			dxDrawRectangle((posx*(SPECWIDTH/BANDS))+10+screenStartX, screenStartY, 10, max((y+1)/4, 1), tocolor(r, g, b, 255 ))
		end
		
		if bSpawnParticles == true then
			for key = 0, 40 do
				if peaks[x][key] == nil then
					if (#peaks[x] <= 20 and prevcalced[x] <= calced[x]) and (release[x] == true or release[x] == nil) and (y > 1) then
						local rnd = math.random(0, 0)
						peaks[x][key] = {}
						
						if dir == "up" then
							peaks[x][key]["pos"] = screenStartY
						else
							peaks[x][key]["pos"] = screenStartY+((y+1)/4)
						end
						
						peaks[x][key]["posx"] = (posx*(SPECWIDTH/BANDS))+12+screenStartX+(2-key)
						peaks[x][key]["alpha"] = 128
						peaks[x][key]["dirx"] = 0
						release[x] = false
						setTimer(function() release[x] = true end, 100, 1)
					end
				else
					if bpm > 0 then
						local maxScreenPos = 290
						local AlphaMulti = 255 / maxScreenPos
						value = peaks[x][key]
						
						if value ~= nil then
							local sX = value.posx
							dxDrawRectangle(value.posx, value.pos, 2, 2, tocolor(r, g, b, value.alpha))
							value.pos = dir == "down" and value.pos + movespeed or value.pos - movespeed
							value.posx = value.posx + (movespeed <= 2 and math.random(-movespeed, movespeed) or math.random(-1, 1))
							value.alpha = value.alpha - (AlphaMulti) - math.random(1, 4)
							
							if value.alpha <= 0 then
								peaks[x][key] = nil
							end
						end
					end
				end
			end
		end
	end
	
	dxSetRenderTarget()
	dxSetShaderValue(shader_screen, "gTexture", tar)
end