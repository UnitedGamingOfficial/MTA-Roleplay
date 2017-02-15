function nudgeNoise()
   local sound = playSound("Player/nudge.wav")   
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("playNudgeSound", true)
addEventHandler("playNudgeSound", getLocalPlayer(), nudgeNoise)
addCommandHandler("playthenoise", nudgeNoise)

function doEarthquake()
	local x, y, z = getElementPosition(getLocalPlayer()) 
	createExplosion(x, y, z, -1, false, 3.0, false)
end
addEvent("doEarthquake", true)
addEventHandler("doEarthquake", getLocalPlayer(), doEarthquake)

function streamASound(link)
	playSound(link)
end
addEvent("playSound", true)
addEventHandler("playSound", getRootElement(), streamASound)