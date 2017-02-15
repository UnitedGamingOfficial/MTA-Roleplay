local mysql = exports.mysql

fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }
bikes = { [448]=true, [461]=true, [462]=true, [463]=true, [468]=true, [471]=true, [521]=true, [522]=true, [581]=true, [586]=true }
sportscar = { [402]=true, [411]=true, [415]=true, [429]=true, [451]=true, [477]=true, [494]=true, [502]=true, [503]=true, [506]=true, [541]=true, [559]=true, [560]=true, [587]=true, [603]=true, [602]=true }
lowclasscar = { [400]=true, [401]=true, [404]=true }
mediumclasscar = { }
highclasscar = { }
	
FUEL_PRICE = 2.2
MAX_FUEL = 100

function syncFuelOnEnter(thePlayer)
	local fuel = getElementData(source, "fuel")

	if (fuel ~= 100) then
		triggerClientEvent(thePlayer, "syncFuel", source, fuel)
	else
		triggerClientEvent(thePlayer, "syncFuel", source)
	end
end
addEventHandler("onVehicleEnter", getRootElement(), syncFuelOnEnter)

function fuelDepleting()
	local players = getElementsByType("player")
	for k, v in ipairs(players) do
		if isPedInVehicle(v) then
			local veh = getPedOccupiedVehicle(v)
			if (veh) then
				local seat = getPedOccupiedVehicleSeat(v)	
				if (seat==0) then
					local model = getElementModel(veh)
					if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
						local engine = getElementData(veh, "engine")
						if engine == 1 then
							local fuel = getElementData(veh, "fuel")
							if fuel >= 1 then
								local oldx = getElementData(veh, "oldx")
								local oldy = getElementData(veh, "oldy")
								local oldz = getElementData(veh, "oldz")
								
								local x, y, z = getElementPosition(veh)
								
								local zdiff = oldz - z
								local ignore = false
								
								if zdiff >= 50 then
									ignore = true
								elseif zdiff <= -50 then
									ignore = true
								end
								
								if not ignore then
									local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
									if (distance < 10) then
										distance = 10  -- fuel leaking away when not moving
									end
								------------- Fuel deplation based on milage - start ------------------------
								--[[local dbid = getElementData(veh, "dbid")
								local query = mysql:query("SELECT `odometer` FROM `vehicles` WHERE id ='" .. mysql:escape_string(dbid) .. "'")
								local result = false
								result = mysql:fetch_assoc(query)
								if result then
									odometer = result["odometer"]
								else
									return false
								end
								mysql:free_result(query) --this will free RAM memory on query.
								if dbid == 1 or dbid == "1" then --Chuevo's car
									outputDebugString("odometer = "..odometer)
								end
								
								local actualOdometer = tonumber(odometer) / 1000
								--outputDebugString(actualOdometer)
								if (actualOdometer > 0) and (actualOdometer < 99) then
									newFuel = fuel - (distance/400)
								elseif (actualOdometer >= 99) and (actualOdometer < 275) then
									newFuel = fuel - (distance/375)
								elseif (actualOdometer >= 275) and (actualOdometer < 420) then
									newFuel = fuel - (distance/350)
								elseif (actualOdometer >= 420) and (actualOdometer < 629) then
									newFuel = fuel - (distance/325)
								elseif (actualOdometer >= 629) and (actualOdometer < 1000) then
									newFuel = fuel - (distance/300)
								elseif (actualOdometer >= 1000) then
									newFuel = fuel - (distance/275)
								else
									newFuel = fuel - (distance/400)
								end
								exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", newFuel, false)
								triggerClientEvent(v, "syncFuel", veh, newFuel)
								
								
								--------------- Fuel deplated based on milage - end -----------------]]

									newFuel = fuel - (distance/400)
									exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", newFuel, false)
									triggerClientEvent(v, "syncFuel", veh, newFuel)
									
									if newFuel < 1 then
										setVehicleEngineState(veh, false)
										exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 0, false)
										toggleControl(v, 'brake_reverse', false)
									end
								end
								exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldx", x, false)
								exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldy", y, false)
								exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldz", z, false)	
							end
						end
					end
				end
			end
		end
	end
end
setTimer(fuelDepleting, 20000, 0)

function FuelDepetingEmptyVehicles()
	local vehicles = exports.pool:getPoolElementsByType("vehicle")
	for ka, theVehicle in ipairs(vehicles) do
		local enginestatus = getElementData(theVehicle, "engine")
		if (enginestatus == 1) then
			local driver = getVehicleOccupant(theVehicle)
			if (driver == false) then
				local fuel = getElementData(theVehicle, "fuel")
				if fuel >= 1 then
					local newFuel = fuel - 0.9 -- (120/200)
					exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "fuel", newFuel, false)
					if (newFuel<1) then
						setVehicleEngineState(theVehicle, false)
						exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "engine", 0, false)
					end
				end
			end
		end
	end
end
setTimer(FuelDepetingEmptyVehicles, 240000,0)

function randomizeFuelPrice()
	FUEL_PRICE = math.random(30, 50) / 30
end
setTimer(randomizeFuelPrice, 3600000, 0)

