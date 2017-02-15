function fiddycal(target)
	if ( getElementType(target) == "vehicle" ) then -- its a 50cal, it destroys cars!
		blowVehicle(target, true)
		local x, y, z = getElementPosition(target)
		createExplosion(x, y, z, 4, true, 0.5, false)
		createExplosion(x+1, y, z, 4, true, 0.5, false)
		createExplosion(x, y+1, z, 4, true, 0.5, false)
		createExplosion(x+1, y+1, z, 4, true, 0.5, false)
		createExplosion(x-1, y, z, 4, true, 0.5, false)
		createExplosion(x, y-1, z, 4, true, 0.5, false)
		createExplosion(x-1, y-1, z, 4, true, 0.5, false)
	elseif ( getElementType(target) == "player" ) then
		setElementHealth(target, 0)
		setCameraTarget(target, source)
		if ( isElement(target) ) then
			outputChatBox("You got killed by the 50cal Sniper Rifle!", target, 255, 0, 0)
		end
	end
end
addEvent("50cal", true)
addEventHandler("50cal", getRootElement(), fiddycal)

function createExplode(x, y, z)
	createExplosion(x, y, z, 2, source)
	createExplosion(x+1, y, z, 2, source)
	createExplosion(x, y+1, z, 2, source)
	createExplosion(x, y, z+1, 2, source)
	createExplosion(x+1, y+1, z, 2, source)
	createExplosion(x, y+1, z+1, 2, source)
	createExplosion(x+1, y, z+1, 2, source)
	createExplosion(x+1, y+1, z+1, 2, source)
	createExplosion(x-1, y-1, z-1, 2, source)
end
addEvent("createExplode", true)
addEventHandler("createExplode", getRootElement(), createExplode)