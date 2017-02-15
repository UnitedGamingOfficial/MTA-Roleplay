function stopHeadshots( attacker, weapon, bodypart )
	if bodypart == 9 then
		if weapon == 24 then
			local deagleMode = getElementData(attacker, "deaglemode")
			if deagleMode == 1 then -- Tazer cancel headshot
				setElementHealth(source, math.max(0, getElementHealth(source) - 50))
				cancelEvent()
			else
				cancelEvent()
			end
		else
			setElementHealth(source, math.max(0, getElementHealth(source) - 50))
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopHeadshots)