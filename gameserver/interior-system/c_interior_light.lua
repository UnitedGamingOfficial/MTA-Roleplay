local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()
local showShadow = {}
local darkness = 0

function updateLightStatus(status)
	showShadow[localPlayer] = status
	darkness = darkLevel()
end
addEvent("updateLightStatus", true)
addEventHandler("updateLightStatus", getRootElement(), updateLightStatus)

function drawShadow ()
	if not showShadow[localPlayer] then
		dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, darkness), false)
	end
end
addEventHandler("onClientRender",getRootElement(), drawShadow)

function darkLevel()
	local hour, minutes = getTime()
	if hour > 4 and hour < 18 then
		if hour < 6 then 
			return 240
		end
		if hour < 8 then
			return 200
		end
		if hour < 14 then
			return 50
		end
		return 100
	else
		if hour < 23 then
			return 240
		end
		return 247
	end
	return 0
end