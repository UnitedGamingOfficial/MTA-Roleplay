local l_beer = { }
local r_beer = { }
local deagle = { }
local isLocalPlayerdrinkingBool = false
function setdrinking(player, state, hand)
	setElementData(player,"drinking",state, false)
	if not (hand) or (hand == 0) then
		setElementData(player, "drinking:hand", 0, false)
	else
		setElementData(player, "drinking:hand", 1, false)
	end

	if (isElement(player)) then
		if (state) then
			playerExitsVehicle(player)
		else
			playerEntersVehicle(player)
		end
	end
end

function playerExitsVehicle(player)
	if (getElementData(player, "drinking")) then
		playerEntersVehicle(player)
		if (getElementData(player, "drinking:hand") == 1) then
			r_beer[player] = createbeerModel(player, 1543)
		else
			l_beer[player] = createbeerModel(player, 1543)
		end
	end
end

function playerEntersVehicle(player)
	if (l_beer[player]) then
		if (isElement( l_beer[player] )) then
			destroyElement( l_beer[player] )
		end
		l_beer[player] = nil
	end
	if (r_beer[player]) then
		if (isElement( r_beer[player] )) then
			destroyElement( r_beer[player] )
		end
		r_beer[player] = nil
	end
end

function removeSigOnExit()
	playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

function syncbeerette(state, hand)
	if (isElement(source)) then
		if (state) then
			setdrinking(source, true, hand)
		else
			setdrinking(source, false, hand)
		end
	end
end
addEvent( "realism:drinkingsync", true )
addEventHandler( "realism:drinkingsync", getRootElement(), syncbeerette, righthand )

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function ( startedRes )
		triggerServerEvent("realism:drinking.request", getLocalPlayer())
	end
);

function createbeerModel(player, modelid)
	if (l_beer[player] ~= nil) then
		local currobject = l_beer[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_beer[player] = nil
		end
	end
	
	local object = createObject(modelid, 0,0,0)

	setElementCollisionsEnabled(object, false)
	return object
end

function updateBeer()
	isLocalPlayerdrinkingBool = false
	-- left hand
	for thePlayer, theObject in pairs(l_beer) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerdrinkingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 36)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 170
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
			--moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end

	-- right hand
	for thePlayer, theObject in pairs(r_beer) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerdrinkingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 26)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 100
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
			--moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), updateBeer)
addCommandHandler("mdri", createbeerModel)
addCommandHandler("dri", updateBeer)

function isLocalPlayerdrinking()
	return isLocalPlayerdrinkingBool
end