local limitSpeed = { }
table.insert(limitSpeed, 510, 40) -- Mountain bike
table.insert(limitSpeed, 509, 30) -- Bike
table.insert(limitSpeed, 481, 35) -- BMX
table.insert(limitSpeed, 522, 160) -- NRG-500
table.insert(limitSpeed, 468, 110) -- Sanchez
table.insert(limitSpeed, 581, 140) -- BF-400
table.insert(limitSpeed, 521, 150) -- FCR-900
table.insert(limitSpeed, 461, 145) -- PCJ-600
table.insert(limitSpeed, 463, 130) -- Freeway
table.insert(limitSpeed, 586, 125) -- Wayfarer
table.insert(limitSpeed, 448, 80) -- Pizzaboy
table.insert(limitSpeed, 462, 90) -- Faggio
table.insert(limitSpeed, 471, 110) -- Quadbike
table.insert(limitSpeed, 523, 160) -- HPV1000
table.insert(limitSpeed, 449, 45) -- Tram
table.insert(limitSpeed, 414, 80) -- Mule
table.insert(limitSpeed, 431, 80) -- Bus

local ccEnabled = false
local theVehicle = nil
local targetSpeed = 0
local driver = false

function cruiseControlSeat(player, seat)
	if seat == 0 then 
		driver = true
	else
		driver = false
	end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, cruiseControlSeat)

function cruiseControlExit(player)
	driver = false
	ccEnabled = false
	setControlState("accelerate", false)
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, cruiseControlExit)

function cruiseControl()
	local theVehicle = getPedOccupiedVehicle(localPlayer)
	
	if theVehicle and driver then
		local speed = exports.global:getVehicleVelocity(theVehicle)
		
		if (speed > 5) then
			if (getVehicleType(theVehicle) == "Automobile" or getVehicleType(theVehicle) == "Bike" or getVehicleType(theVehicle) =="Boat" or getVehicleType(theVehicle) =="Monster Truck" or getVehicleType(theVehicle) == "Train") then
			if (ccEnabled) then
				triggerServerEvent("cruisecontrol:off", localPlayer)
				setControlState("accelerate", false)
				ccEnabled = false
			
				outputChatBox("Cruise Control disabled", 255,0,0)
				deactivateCC()
				--outputDebugString("Cruise Control disabled, speed set to original")
			
				targetSpeed = 0
			else
				triggerServerEvent("cruisecontrol:on", localPlayer, speed)
				setControlState("accelerate", true)
				ccEnabled = true
			
				outputChatBox("Cruise Control enabled", 0,255,0)
				--outputDebugString("Cruise Control enabled at ".. math.floor(speed) .." KM/H")
			
				targetSpeed = speed
			end
			end
			else
			outputChatBox("You need to be going a little faster to engage cruise control.", 255,0,0)
			end
		end
	end
addCommandHandler("cc", cruiseControl, false, false)
addCommandHandler("cruisecontrol", cruiseControl, false, false)

function deactivateCC()
	triggerServerEvent("cruisecontrol:off", localPlayer)
	setControlState("accelerate",false)
	ccEnabled = false
	outputChatBox("Cruise Control disabled", 255,0,0)
end

function startCC()
	if (ccEnabled) then
		deactivateCC()
		ccEnabled = false
	end
end

function stopCC()
	if (ccEnabled) then
		deactivateCC()
		ccEnabled = false
	end
end

function increaseCC()
	if (ccEnabled) and driver then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		targetSpeed = targetSpeed + 5
		triggerServerEvent("cruisecontrol:on", localPlayer, targetSpeed)
		
			local maxSpeed = limitSpeed[getElementModel(tV)]
			if maxSpeed then 
				if targetSpeed > maxSpeed then
					targetSpeed = maxSpeed
				end
			end
		outputDebugString("Speed set to ".. math.floor(targetSpeed) .."")
	end
end

function decreaseCC()
	if (ccEnabled) and driver then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		targetSpeed = targetSpeed - 5
		if targetSpeed > 5 then
		triggerServerEvent("cruisecontrol:on", localPlayer, targetSpeed)
		else
		triggerServerEvent("cruisecontrol:off", localPlayer)
		setControlState("accelerate", false)
		ccEnabled = false
		end
	end
end

function bindMe()
	bindKey("brake_reverse", "down", stopCC)
	bindKey("accelerate", "down", startCC)
	bindKey("enter_exit", "down", startCC)
	
	bindKey("-", "down", decreaseCC)
	bindKey("num_sub", "down", decreaseCC)
	bindKey("=", "down", increaseCC)
	bindKey("num_add", "down", increaseCC)
end

function loadMe( startedRes )
	outputDebugString("CControl V1.1 Loaded")
	
	addEventHandler("onClientRender", getRootElement(), restrictVehs)
	bindMe()
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()) , loadMe)

function restrictVehs(manual) 
	local tV = getPedOccupiedVehicle(getLocalPlayer()) 
	if (tV) then
		local maxSpeed = limitSpeed[getElementModel(tV)]
		if maxSpeed then 
			tS = exports.global:getVehicleVelocity(tV) 
			if tS > maxSpeed then 
				toggleControl("accelerate",false) 
			else 
				toggleControl("accelerate", true) 
			end 
		end
	end 
end