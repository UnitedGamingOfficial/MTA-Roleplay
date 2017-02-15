function firedFiddyCal(weapon, ammo, clipammo, x, y, z, element)
	if ( weapon == 34) then -- sniper
		local px, py, pz = getElementPosition(source)
		
		local sound = playSound3D("sound.wav", px, py, pz)
		setSoundMaxDistance(sound, 150)
		
		if ( element and source == getLocalPlayer() and ( getElementType(element) == "vehicle" or getElementType(element) == "player" ) ) then -- we are the shooter
					setGameSpeed(0.3)
			setTimer(setGameSpeed, 6000, 1, 1.0)

			triggerServerEvent("50cal", getLocalPlayer(), element)
		end
		
		
		if ( element and getElementType(element) == "player" ) then -- make blood
			fxAddBlood(x, y, z, 0, 0, 1, 1000, 1)
			fxAddBlood(x, y, z, 1, 0, 0, 1000, 1)
			fxAddBlood(x, y, z, 0, 1, 1, 1000, 1)
			fxAddBlood(x, y, z, 1, 1, 1, 1000, 1)
			fxAddBlood(x, y, z, 0, 1, 0, 1000, 1)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), firedFiddyCal)