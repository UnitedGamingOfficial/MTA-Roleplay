local l_cellphone = { }
local r_cellphone = { }
local deagle = { }
local isLocalPlayerCellphonePool = false
function setCellphone(player, state, hand)
	setElementData(player,"smoking",state, false)
	if not (hand) or (hand == 0) then
		setElementData(player, "smoking:hand", 0, false)
	else
		setElementData(player, "smoking:hand", 1, false)
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
	if (getElementData(player, "smoking")) then
		playerEntersVehicle(player)
		if (getElementData(player, "smoking:hand") == 1) then
			r_cellphone[player] = createCigarModel(player, 330)
		else
			l_cellphone[player] = createCigarModel(player, 330)
		end
	end
end

function playerEntersVehicle(player)
	if (l_cellphone[player]) then
		if (isElement( l_cellphone[player] )) then
			destroyElement( l_cellphone[player] )
		end
		l_cellphone[player] = nil
	end
	if (r_cellphone[player]) then
		if (isElement( r_cellphone[player] )) then
			destroyElement( r_cellphone[player] )
		end
		r_cellphone[player] = nil
	end
end

function removeSigOnExit()
	playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

function syncCellphone(state, hand)
	if (isElement(source)) then
		if (state) then
			setCellphone(source, true, hand)
		else
			setCellphone(source, false, hand)
		end
	end
end
addEvent( "realism:phonesync", true )
addEventHandler( "realism:phonesync", getRootElement(), syncCellphone, righthand )

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function ( startedRes )
		triggerServerEvent("realism:smoking.request", getLocalPlayer())
	end
);

function createCigarModel(player, modelid)
	if (l_cellphone[player] ~= nil) then
		local currobject = l_cellphone[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_cellphone[player] = nil
		end
	end
	
	local object = createObject(modelid, 0,0,0)

	setElementCollisionsEnabled(object, false)
	return object
end

function updatePhone()
	isLocalPlayerCellphonePool = false
	-- left hand
	for thePlayer, theObject in pairs(l_cellphone) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerCellphonePool = true
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
			--setElementPosition(theObject, bx - 0.04, by + 0.06, bz - 0.06)
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 270, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end

	-- right hand
	for thePlayer, theObject in pairs(r_cellphone) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerCellphonePool = true
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
			setElementPosition(theObject, bx + 0.01, by + 0.09, bz + 0.05)
			setElementRotation(theObject, 180, 360, r - 40)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), updatePhone)

function isLocalPlayerSmoking()
	return isLocalPlayerCellphonePool
end
--[[
addEventHandler("onClientPreRender",root,
  function ()
    daBlock, daAnim = getPedAnimation(getLocalPlayer())
    setElementData(root,"blockz",daBlock)
    setElementData(root,"animz",daAnim)
  end )]]