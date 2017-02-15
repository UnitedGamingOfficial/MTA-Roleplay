function stopHeadshot( attacker, weapon, bodypart )
	if bodypart == 9 then
		if weapon == 25 or weapon == 26 or weapon == 27 or weapon == 30 or weapon == 31 or weapon == 33 or weapon == 34 or weapon == 35 or weapon == 36 or weapon == 38 then			
		else
			if weapon == 24 then
				local deagleMode = getElementData(attacker, "deaglemode")
				if deagleMode == 1 then
					local headHitPlayer = getLocalPlayer()
					triggerServerEvent("doHeadHit", getRootElement(), headHitPlayer)
					cancelEvent()
				else
					return
				end
			else
				local headHitPlayer = getLocalPlayer()
				triggerServerEvent("doHeadHit", getRootElement(), headHitPlayer)
				cancelEvent()
			end
		end
	end
end
addEventHandler( "onClientPlayerDamage", getLocalPlayer(), stopHeadshot )