found = false
lastDistance = 5
possibleInteriors = getElementsByType("interior")

addEvent( "startSnakeCam", true )
addEventHandler( "startSnakeCam", getRootElement(),
function (source)
	for _, interior in ipairs(possibleInteriors) do
		local interiorEntrance = getElementData(interior, "entrance")
		local interiorExit = getElementData(interior, "exit")	
		local posX, posY, posZ = getElementPosition(source)
		local dimension = getElementDimension(source)
		for _, point in ipairs( { interiorEntrance, interiorExit } ) do
			if (point[5] == dimension) then
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, point[1], point[2], point[3])
				if (distance < lastDistance) then
					found = interior
					lastDistance = distance
				end
			end
		end
	end			
	if not (found) then
		outputChatBox("You are not near a door, you cannot use the snake cam.", source, 255, 0, 0)
	else
		local dbid = getElementData(found, "dbid")
		local query = mysql:query_fetch_assoc("SELECT `interiorx`, `interiory`, `interiorz`, `interior` FROM interiors WHERE id=" .. dbid .. "")		
			if query then 
			local px, py, pz = getElementPosition(source)
				setElementData(source, "snakex", px) 
				setElementData(source, "snakey", py)
				setElementData(source, "snakez", pz) 
			local pdim = getElementDimension(source)
				setElementData(source, "snakedim", pdim)
			local pint = getElementInterior(source)
				setElementData(source, "snakeint", pint)
			local x = tonumber(query["interiorx"])
			local y = tonumber(query["interiory"])
			local z = tonumber(query["interiorz"])
			local interior = tonumber(query["interior"])
				setElementDimension(source, dbid)
				setElementInterior(source, interior)
				setElementPosition(source, x, y, z)
				setPedWeaponSlot(source, 0)
				setElementAlpha(source, 0)
				setElementFrozen(source, true)
				setElementData(source, "snake", true)
			outputChatBox("You have started snake camming.", source, 0, 255, 0) 
		end
	end
end
)

addEvent( "stopSnakeCam", true )
addEventHandler( "stopSnakeCam", getRootElement(), 
function (source)
	if (getElementData(source, "snake")==true) or not (getElementData(source, "snakex")==nil) then
		local yx = getElementData(source, "snakex")
		local yy = getElementData(source, "snakey")
		local yz = getElementData(source, "snakez")
		local ydim = getElementData(source, "snakedim")
		local yint = getElementData(source, "snakeint")
		setElementPosition(source, yx, yy, yz)
		setElementAlpha(source, 255)
		setElementInterior(source, yint)
		setElementDimension(source, ydim)
		setElementFrozen(source, false) -- Return them to their position.
		setElementData(source, "snakex", nil)
		setElementData(source, "snakey", nil)
		setElementData(source, "snakez", nil)
		setElementData(source, "snakedim", nil)
		setElementData(source, "snakeint", nil)
		setElementData(source, "snake", nil) -- Clear these so they can be reused.
		outputChatBox("You have stopped snake camming.", source, 0, 255, 0)
		found = nil -- Fix?
		lastDistance = 5
	end
end
)