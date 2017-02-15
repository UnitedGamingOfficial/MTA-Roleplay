function weaponfired (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	local paintball = getElementData(source, "paintball")
	if (paintball) then
		local r, g, b = getTeamColor( source )
		local marker = createMarker ( hitX, hitY, hitZ, "corona", 0.1, r, g, b, 255 )
		setElementInterior(marker, getElementInterior(source))
		setElementDimension(marker, getElementDimension(source))
		setTimer ( destroyElement, 7500, 1, marker )
		setElementStreamable ( marker, false )
		if (source == getLocalPlayer()) and (hitElement) and (getElementType ( hitElement ) == "player") then
			triggerServerEvent("paintball:hit", source, hitElement)
		end
	end
end
addEventHandler ( "onClientPlayerWeaponFire", getRootElement(), weaponfired )

function getTeamColor( thePlayer )
	local colors =  getElementData(thePlayer, "paintball:colors")
	if (colors) then
		return colors[1],colors[2], colors[3]
	end
	return 255,0,0
end

function stopDamage ( attacker, weapon, bodypart )
	if (attacker) and (isElement(attacker)) then
		local paintball = getElementData(attacker, "paintball")
		if (paintball) then
			if (source == getLocalPlayer()) then
				cancelEvent()
			end
		end
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), stopDamage )