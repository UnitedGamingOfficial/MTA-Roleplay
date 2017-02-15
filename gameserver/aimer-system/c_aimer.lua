-- Scripted by Anthony

-- Uzi, Tec-9, MP5, Colt-45, Silenced, Deagle
NoAimerWeaponIDs = { [28] = true, [32] = true, [29] = true, [22] = true, [23] = true, [24] = true, }

function disableAimer( prevSlot, newSlot )
	if NoAimerWeaponIDs[getPedWeapon(getLocalPlayer(), newSlot)] then
		showPlayerHudComponent("crosshair", false)
	else
		showPlayerHudComponent("crosshair", true)
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), disableAimer)

-- AHHH WHAT IS THIS MADNESS?????????? -Bean