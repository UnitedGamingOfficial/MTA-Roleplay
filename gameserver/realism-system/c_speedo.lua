fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

enginelessVehicle = { [510]=true, [509]=true, [481]=true }
local active = true
local fuel = 0

function drawSpeedo()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then

			speed = exports.global:getVehicleVelocity(vehicle)
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
			
			-- street names
			local streetname = getElementData(getLocalPlayer(), "speedo:street" )
			if streetname and getVehicleType(vehicle) ~= "Boat" and getVehicleType(vehicle) ~= "Helicopter" and getVehicleType(vehicle) ~= "Plane" then
				local width = dxGetTextWidth( streetname )
				local x = width < 200 and ( x - 110 - width / 2 ) or ( x - 10 - width )
				dxDrawRectangle( x - 8, y - 296, width + 17, 24, tocolor( 5, 5, 5, 220 ) )
				dxDrawText( streetname, x, y - 292 )
			end
			
			-- district names
			local positionx, positiony, positionz = getElementPosition(getLocalPlayer())
			local district = getZoneName(positionx, positiony, positionz, false)
			if district and getVehicleType(vehicle) ~= "Boat" and getElementInterior(getLocalPlayer()) == 0 and getElementDimension(getLocalPlayer()) == 0 then
				local width = dxGetTextWidth( district )
				local x = width < 200 and ( x - 110 - width / 2 ) or ( x - 10 - width )
				dxDrawRectangle( x - 8, y - 76, width + 17, 24, tocolor( 5, 5, 5, 220 ) )
				dxDrawText( district, x, y - 72 )
			end
			
			
			dxDrawImage(x-210, y-275, 256, 256, "disc.png", 0, 0, 0, tocolor(255, 255, 255, 200))
		
			
			
			local speedlimit = getElementData(getLocalPlayer(), "speedo:limit")
			if speedlimit and getVehicleType(vehicle) ~= "Boat" and getVehicleType(vehicle) ~= "Helicopter" and getVehicleType(vehicle) ~= "Plane" then
				local ax, ay = x - 243, y - 202
				
				dxDrawImage(ax,ay,64,64,"images/speed" .. speedlimit .. ".png")
				ay = ay - 32
				
				if speedlimit >= 120 then
					dxDrawImage(ax,ay,64,64,"images/highway.png")
					ay = ay - 32
				end
				
				if speed > speedlimit then
					dxDrawImage(ax,ay,64,64,"images/accident.png")
				end
			end
			if (getVehicleType(vehicle) == "Boat" or getVehicleType(vehicle) == "Plane" or getVehicleType(vehicle) == "Helicopter") then
			dxDrawText("KNOTS", x - 149.5, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )		
			else
			dxDrawText("KM/H", x - 136, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )
			--dxDrawText("KM/PH", x - 145, y - 130, 5, 5, tocolor (255,255,255, 200), 1.8, "default-bold" )
			end
			
			if (speed < 100) then
			dxDrawText(math.floor(speed), x - 115, y - 108, 5, 5, tocolor (255,255,255, 200), 1.5 )
			else
			dxDrawText(math.floor(speed), x - 120, y - 108, 5, 5, tocolor (255,255,255, 200), 1.5 )
			end
			
			speed = speed - 100
			nx = x + math.sin(math.rad(-(speed)-150)) * 90
			ny = y + math.cos(math.rad(-(speed)-150)) * 90
			dxDrawLine(x-110, y-175, nx-110, ny-175, tocolor(255, 0, 0, 255), 2)
			
			dxDrawText( tostring(math.floor(getDistanceTraveled()/1000)), x - 115, y - 215, 5, 5, tocolor (255,255,255, 200), 1 )
		end
	end
end

function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)

function drawFuel()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
			
			dxDrawImage(x-265, y-165, 128, 128, "fueldisc.png", 0, 0, 0, tocolor(255, 255, 255, 200))
			movingx = x + math.sin(math.rad(-(fuel)-50)) * 50
			movingy = y + math.cos(math.rad(-(fuel)-50)) * 50
			dxDrawLine(x-215, y-115, movingx-210, movingy-115, tocolor(255, 0, 0, 255), 2)
			
			dxDrawText(math.floor(fuel).."%", x - 215, y - 110.5, 5, 5, tocolor (255,255,255, 200), 1 )
			
			if fuel < 10 then
				local ax, ay = x - 274, y - 202
				if (getElementData(vehicle, "vehicle:windowstat") == 1) then
					ay = ay - 32
				end
				if getTickCount() % 1000 < 500 then
					dxDrawImage(ax,ay,64,64,"images/fuel.png")
				else
					dxDrawImage(ax,ay,64,64,"images/fuel2.png")
				end
			end
		end
	end
end

function drawWindow()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			local width, height = guiGetScreenSize()
			local x = width
			local y = height

			if (getElementData(vehicle, "vehicle:windowstat") == 1) then
				local ax, ay = x - 274, y - 202
				dxDrawImage(ax,ay,64,64,"images/window.png")
			end
		end
	end
end

-- Check if the vehicle is engineless or fuelless when a player enters. If not, draw the speedo and fuel needles.
function onVehicleEnter(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if seat == 0 and not (fuellessVehicle[id]) then
				addEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if not (enginelessVehicle[id]) then
				addEventHandler("onClientRender", getRootElement(), drawSpeedo)
				addEventHandler("onClientRender", getRootElement(), drawWindow)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onVehicleEnter)

-- Check if the vehicle is engineless or fuelless when a player exits. If not, stop drawing the speedo and fuel needles.
function onVehicleExit(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if seat == 0 and not (fuellessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if not(enginelessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
				removeEventHandler("onClientRender", getRootElement(), drawWindow)
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), onVehicleExit)

function hideSpeedo()
	removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
	removeEventHandler("onClientRender", getRootElement(), drawFuel)
	removeEventHandler("onClientRender", getRootElement(), drawWindow)
end

function showSpeedo()
	source = getPedOccupiedVehicle(getLocalPlayer())
	if source then
		if getVehicleOccupant( source ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 0)
		elseif getVehicleOccupant( source, 1 ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 1)
		end
	end
end

-- If player is not in vehicle stop drawing the speedo needle.
function removeSpeedo()
	if not (isPedInVehicle(getLocalPlayer())) then
		hideSpeedo()
	end
end
setTimer(removeSpeedo, 1000, 0)

addCommandHandler( "togglespeedo",
	function( )
		local source = getPedOccupiedVehicle(getLocalPlayer())
		if source then
			active = not active
			if active then
				outputChatBox( "Speedo is now on.", 0, 255, 0 )
			else
				outputChatBox( "Speedo is now off.", 255, 0, 0 )
			end
		end
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement(), showSpeedo )

addEvent("addWindow", true)
addEventHandler("addWindow", getRootElement(), 
	function ()
		if source == getLocalPlayer() then
			addEventHandler("onClientRender", getRootElement(), drawWindow)
		end
	end
)

addEvent("removeWindow", true)
addEventHandler("removeWindow", getRootElement(), 
	function ()
		if source == getLocalPlayer() then
			removeEventHandler("onClientRender", getRootElement(), drawWindow)
		end
	end
)