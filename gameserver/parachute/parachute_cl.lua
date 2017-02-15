FALL_VELOCITY = 0.9
MIN_GROUND_HEIGHT = 20 -- how high above the ground
local y_turn_offset = 15
local rotation_accelerate = 0.5
root = getRootElement ()
localPlayer = getLocalPlayer ()
slowfallspeed = -0.09
fallspeed = -0.15
haltspeed = 0.02
movespeed = 0.3
lastspeed = 0
opentime = 1000
local lastAnim = {}
local lastTick

local function onResourceStart ( resource )
  bindKey ( "fire", "down", onFire )
  bindKey ( "enter_exit", "down", onEnter )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement (), onResourceStart )

local function onRender ( )
	lastTick = lastTick or getTickCount()
	local currentTick = getTickCount()
	local tickDiff =  currentTick - lastTick
	lastTick = currentTick
	if tickDiff > 0 then
		if ( getElementData ( localPlayer, "parachuting" ) ) and ( changeVelocity ) then
			velX, velY, velZ = getElementVelocity ( localPlayer )  
			if ( not isPedOnGround ( localPlayer ) and not getPedContactElement ( localPlayer ) and velZ ~= 0 ) then
				
				_,rotY,rotZ = getElementRotation ( localPlayer )
				rotZ = -rotZ
				local currentfallspeed = s(fallspeed)
				if ( getMoveState ( "backwards" ) ) then 
					currentfallspeed = s(slowfallspeed)
				end
				if ( velZ < currentfallspeed ) then
					if ( lastspeed < 0 ) then
						if ( lastspeed > currentfallspeed or lastspeed == currentfallspeed ) then
							velZ = currentfallspeed
						else
							velZ = lastspeed + s(haltspeed)
						end
					end 
				-- going slower than the slowest falling speed (or up)
				elseif ( velZ >= slowfallspeed ) then
					velZ = currentfallspeed
				end
				lastspeed = velZ
				local dirX = math.sin ( math.rad ( rotZ ) )
				local dirY = math.cos ( math.rad ( rotZ ) )
				velX = dirX * s(movespeed)
				velY = dirY * s(movespeed)
				if ( velZ == currentfallspeed ) then
					--
					if ( getMoveState ( "backwards" ) ) then 
						setPedNewAnimation ( localPlayer, "animation_state", "PARACHUTE", "PARA_decel", -1, false, true, false )
						if  getMoveState ( "left" ) then 
							rotZ = rotZ - a(1,tickDiff)
							if y_turn_offset > rotY then
								rotY = rotY + a(rotation_accelerate,tickDiff)
							end
						elseif getMoveState ( "right" ) then
							rotZ = rotZ + a(1 ,tickDiff)
							if -y_turn_offset < rotY then
								rotY = rotY - a(rotation_accelerate,tickDiff)
							end					
						elseif 0 > math.floor(rotY) then
							rotY = rotY + a(rotation_accelerate,tickDiff)
						elseif 0 < math.floor(rotY) then
							rotY = rotY - a(rotation_accelerate,tickDiff)
						end
					elseif ( getMoveState ( "left" ) ) then 
						rotZ = rotZ - a(1,tickDiff)
						if y_turn_offset > rotY then
							rotY = rotY + a(rotation_accelerate,tickDiff)
						end
						setPedNewAnimation ( localPlayer, "animation_state", "PARACHUTE", "PARA_steerL", -1, false, true, false )
					elseif ( getMoveState ( "right" ) ) then 
						rotZ = rotZ + a(1 ,tickDiff)
						if -y_turn_offset < rotY then
							rotY = rotY - a(rotation_accelerate,tickDiff)
						end
						setPedNewAnimation ( localPlayer, "animation_state", "PARACHUTE", "PARA_steerR", -1, false, true, false )
					else
						setPedNewAnimation ( localPlayer, "animation_state", "PARACHUTE", "PARA_float", -1, false, true, false )
						if 0 > math.floor(rotY) then
							rotY = rotY + a(rotation_accelerate,tickDiff)
						elseif 0 < math.floor(rotY) then
							rotY = rotY - a(rotation_accelerate,tickDiff)
						end
					end		
					--
					setPedRotation ( localPlayer, -rotZ )
					setElementRotation ( localPlayer, 0,rotY, rotZ )
				end
				setElementVelocity ( localPlayer, velX, velY, velZ )    
			else
				if velZ >= FALL_VELOCITY then --they're going to have to fall down at this speed
					removeParachute(localPlayer,"land")
					setPedAnimation(localPlayer,"PARACHUTE","FALL_skyDive_DIE", t(3000), false, true, true)
				else
					removeParachute(localPlayer,"land")
					setPedNewAnimation ( localPlayer, nil, "PARACHUTE", "PARA_Land", t(3000), false, true, false )
				end
			end
			local posX,posY,posZ = getElementPosition(localPlayer)
			if ( testLineAgainstWater ( posX,posY,posZ,posX,posY,posZ + 5 ) ) then --Shoot a small line to see if in water
			  removeParachute(localPlayer,"water")
			  setPedNewAnimation ( localPlayer, nil, "PARACHUTE", "PARA_Land_Water", t(3000), false, true, true )
			end
		end
	end
	--Render remote players
	for k,player in ipairs(getElementsByType"player") do
		if player ~= localPlayer and getElementData ( player, "parachuting" ) and isElementStreamedIn(player) then
			local velX,velY,velZ = getElementVelocity ( player )
			local rotz = 6.2831853071796 - math.atan2 ( ( velX ), ( velY ) ) % 6.2831853071796
			local animation = getElementData ( player, "animation_state" )
			setPedNewAnimation ( player, nil, "PARACHUTE", animation, -1, false, true, false )
			local _,rotY = getElementRotation(player)
			--Sync the turning rotation
			if animation == "PARA_steerL" then
				if y_turn_offset > rotY then
					rotY = rotY + rotation_accelerate
				end
			elseif animation == "PARA_steerR" then
				if -y_turn_offset < rotY then
					rotY = rotY - rotation_accelerate
				end
			else
				if 0 > math.floor(rotY) then
					rotY = rotY + rotation_accelerate
				elseif 0 < math.floor(rotY) then
					rotY = rotY - rotation_accelerate
				end
			end
			setElementRotation ( player, 0, rotY, -math.deg(rotz) )
		end
	end
end
addEventHandler ( "onClientRender", root, onRender )

function onFire ( key, keyState )
	if ( not getElementData ( localPlayer, "parachuting" ) ) and getElementData(localPlayer,"skydiving") then
		local x,y,z = getElementPosition(localPlayer)
		if not processLineOfSight ( x,y,z, x,y,z-MIN_GROUND_HEIGHT, true, true,false,true,true,false,false,false,localPlayer ) then
		  stopSkyDiving()
		  addLocalParachute()
		  addEventHandler ( "onClientPlayerWasted", localPlayer, onWasted )
		end
	end
end

function onEnter ()
	if ( getElementData ( localPlayer, "parachuting" ) ) then
		removeParachute(localPlayer,"water")
		setPedAnimation(localPlayer)
	end
end
bindKey("space", "down", onEnter)

function onWasted()
	removeParachute(localPlayer,"water")
	setPedAnimation(localPlayer)
	setPedAnimation(localPlayer,"PARACHUTE","FALL_skyDive_DIE", t(3000), false, true, false)
end

function addLocalParachute()
	if not getElementData( localPlayer, "superman:flying" ) then
		local x,y,z = getElementPosition ( localPlayer )
		local chute = createObject ( 3131, x,y,z )
		setElementStreamable(chute, false )
		openChute ( chute, localPlayer, opentime )
		setElementData ( localPlayer, "parachuting", true )
		triggerServerEvent ( "requestAddParachute", localPlayer )
	end
end

function removeParachute(player,type)
	local chute = getPlayerParachute ( player )
	 setTimer ( setPedAnimation, t(3000), 1, player )
	 openingChutes[chute] = nil
	 if chute then
		if type == "land" then
			Animation.createAndPlay(
			  chute,
			  {{ from = 0, to = 100, time = t(2500), fn = animationParachute_land }}
			)
			setTimer ( function()
				detachElements ( chute, player )
				setTimer ( destroyElement, t(3000), 1, chute )
			end,
			t(2500),
			1
			)
		elseif type == "water" then
			Animation.createAndPlay(
			  chute,
			  {{ from = 0, to = 100, time = t(2500), fn = animationParachute_landOnWater }}
			)
			setTimer ( destroyElement, t(2500), 1, chute )
		end
	end
	lastAnim[player] = nil
	if player == localPlayer then
		lastspeed = math.huge
		toggleControl ( "next_weapon", true )
		toggleControl ( "previous_weapon", true )
		changeVelocity = false
		setElementData ( localPlayer, "animation_state", nil )
		setTimer ( setElementData, 1000, 1, localPlayer, "parachuting", false )
		removeEventHandler ( "onClientPlayerWasted", localPlayer, onWasted )
		triggerServerEvent ( "requestRemoveParachute", localPlayer )
	end
end

function animationParachute_land(chute,xoff)
	setElementAttachedOffsets ( chute, offset[1],offset[2],offset[3], math.rad(xoff), 0, 0 )
end

function animationParachute_landOnWater(chute,xoff)
	setElementAttachedOffsets ( chute, offset[1],offset[2],-xoff/10, math.rad(xoff), 0, 0 )
end

addEvent ( "doAddParachuteToPlayer", true)
addEventHandler ( "doAddParachuteToPlayer", root,
	function()
		local x,y,z = getElementPosition ( source )
		local chute = createObject ( 3131, x, y, z )
		setElementStreamable(chute, false )
		openChute ( chute, source, opentime )

	end
)


addEvent ( "doRemoveParachuteFromPlayer", true)
addEventHandler ( "doRemoveParachuteFromPlayer", root,
	function()
		if not isPedOnGround ( source ) or not getPedContactElement ( source ) then
			setPedNewAnimation ( source, nil, "PARACHUTE", "PARA_Land", t(3000), false, true, false )
			removeParachute(source, "land" )
		else
			setPedNewAnimation ( source, nil, "PARACHUTE", "PARA_Land_Water", t(3000), false, true, true )
			removeParachute(source, "water" )
		end
	end
)

function setPedNewAnimation ( ped, elementData, animgroup, animname, ... )
	if animname ~= lastAnim[ped] then
		lastAnim[ped] = animname
		if elementData ~= nil then
			setElementData ( ped, elementData, animname )
		end
		return setPedAnimation ( ped, animgroup, animname, ... )
	end
	return true
end

function getPlayerParachute ( player ) --Lazy, but im assuming no other resource will attach parachutes to the player
	for k,object in ipairs(getAttachedElements(player)) do
		if getElementType(object)=="object" then
			if getElementModel(object) == 3131 then
				return object
			end
		end
	end
	return false
end
