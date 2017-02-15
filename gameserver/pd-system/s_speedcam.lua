--[[
	*
	* Law Enforcement: Speed Camera System
	* File: s_speedcam.lua
	* Author: Socialz, Jonnis
	* Created for United Gaming (unitedgaming.org)
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

-- Variables
local rangeOfRadar = 50
local policeVehicles = {[523] = true, [598] = true, [596] = true, [597] = true, [599] = true}
local governmentVehicles = {[523] = true, [598] = true, [596] = true, [597] = true, [599] = true, [416] = true, [490] = true, [427] = true, [407] = true, [544] = true}
local colors = {
	"white", "blue", "red", "dark green", "purple",
	"yellow", "blue", "gray", "blue", "silver",
	"gray", "blue", "dark gray", "silver", "gray",
	"green", "red", "red", "gray", "blue",
	"red", "red", "gray", "dark gray", "dark gray",
	"silver", "brown", "blue", "silver", "brown",
	"red", "blue", "gray", "gray", "dark gray",
	"black", "green", "light green", "blue", "black",
	"brown", "red", "red", "green", "red",
	"pale", "brown", "gray", "silver", "gray",
	"green", "blue", "dark blue", "dark blue", "brown",
	"silver", "pale", "red", "blue", "gray",
	"brown", "red", "silver", "silver", "green",
	"dark red", "blue", "pale", "light pink", "red",
	"blue", "brown", "light green", "red", "black",
	"silver", "pale", "red", "blue", "dark red",
	"purple", "dark red", "dark green", "dark brown", "purple",
	"green", "blue", "red", "pale", "silver",
	"dark blue", "gray", "blue", "blue", "blue",
	"silver", "light blue", "gray", "pale", "blue",
	"black", "pale", "blue", "pale", "gray",
	"blue", "pale", "blue", "dark gray", "brown",
	"silver", "blue", "dark brown", "dark green", "red",
	"dark blue", "red", "silver", "dark brown", "brown",
	"red", "gray", "brown", "red", "blue",
	"pink", [0] = "black"
}

-- Wrappers
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if type(commandName) ~= "table" then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if key == 1 then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					if hasObjectPermissionTo(player, "command." .. commandName[1], not restricted) then
						fn(player, ...)
					end
				end
			)
		end
	end
end

-- Exports
function isVerifiedElement(element, verified)
	if isElement(element) then
		if getElementType(element) == tostring(verified) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function isCameraExisting(player)
	if not isVerifiedElement(player, "player") then return end
	local exists = false
	for _,v in ipairs(getElementsByType("colshape")) do
		if getElementData(v, "speedcamera:owner") == getPlayerName(player) then
			exists = true
			return true
		end
	end
	
	setTimer(function()
		if exists == false then
			return false
		end
	end, 700, 1)
end

function isCameraOwner(player, camera)
	if not isVerifiedElement(player, "player") then return end
	if not isVerifiedElement(camera, "vehicle") then return end
	if getElementData(camera, "speedcamera:owner") == getPlayerName(player) then
		return true
	else
		return false
	end
end

function getColorName(c1, c2)
	local color1 = colors[c1] or "Unknown"
	local color2 = colors[c2] or "Unknown"
	
	if color1 ~= color2 then
		return color1 .. " & " .. color2
	else
		return color1
	end
end

-- Interactive functions
addCommandHandler({"togspeedcamera", "togglespeedcamera", "togspeedcam", "togglespeedcam", "togspeed", "togglespeed"},
	function(player, cmd, speed)
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			if tonumber(getElementData(vehicle, "faction")) == 1 or tonumber(getElementData(vehicle, "dbid") == 331) or tonumber(getElementData(vehicle, "faction")) == 45 and (getVehicleController(vehicle) == player) then
				if getElementData(vehicle, "speedcamera:state") then
					local x, y, z = getElementPosition(vehicle)
					for _,v in ipairs(getAttachedElements(vehicle)) do
						if isVerifiedElement(v, "colshape") and getElementData(v, "speedcamera:state") then
							destroyElement(v)
							break
						end
					end
					outputChatBox("Dual Stalker SL speed camera has been deactivated on this cruiser.", player, 255, 180, 20, false)
					removeElementData(vehicle, "speedcamera:owner")
					removeElementData(vehicle, "speedcamera:state")
					playSoundFrontEnd(player, 101)
				else
					if not isCameraExisting(player) then
						local speed = tonumber(speed)
						if speed then
							if speed >= 60 and speed <= 500 then
								local x, y, z = getElementPosition(vehicle)
								local creator = getPlayerName(player)
								local radius = createColSphere(x, y, z, rangeOfRadar)
								attachElements(radius, vehicle)
								setElementData(vehicle, "speedcamera:owner", creator, false)
								setElementData(vehicle, "speedcamera:state", 1, false)
								setElementData(radius, "speedcamera:state", 1, false)
								setElementData(radius, "speedcamera:owner", creator, false)
								setElementData(radius, "speedcamera:speed", speed, false)
								outputChatBox("You have turned on Dual Stalker SL speed camera.", player, 255, 180, 20, false)
								playSoundFrontEnd(player, 101)
							end
						else
							outputChatBox("SYNTAX: /" .. cmd .. " [60 or more]", player, 255, 180, 20, false)
						end
					else
						outputChatBox("You need to deactivate the existing speed camera.", player, 255, 0, 0, false)
					end
				end
			else
				outputChatBox("You must be in a law enforcement vehicle in order to activate your speed camera.", player, 255, 0, 0, false)
			end
		end
	end, false, false
)

addCommandHandler({"resetspeed", "resetspeedcam", "resetspeedcamera"},
	function(player, cmd)
		if isCameraExisting(player) then
			for _,v in ipairs(getElementsByType("vehicle")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(player) then
					removeElementData(v, "speedcamera:owner")
					removeElementData(v, "speedcamera:state")
				end
			end
			
			for _,v in ipairs(getElementsByType("colshape")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(player) then
					destroyElement(v)
					break
				end
			end
			outputChatBox("All of your speed cameras are now deactivated.", player, 255, 180, 20, false)
		else
			outputChatBox("You do not have any existing speed cameras.", player, 255, 0, 0, false)
		end
	end, false, false
)

-- Events
addEventHandler("onColShapeHit", root,
	function(hitElement, matchingDimension)
		if matchingDimension then
			if not isVerifiedElement(hitElement, "vehicle") then return end
			if getElementData(source, "speedcamera:state") then
				if (not policeVehicles[getElementModel(hitElement)]) and (not governmentVehicles[getElementModel(hitElement)]) then
					local speedx, speedy, speedz = getElementVelocity(hitElement)
					local actualspeed = (speedx ^ 2 + speedy ^ 2 + speedz ^ 2) ^ (0.5)
					local kmh = math.ceil(actualspeed * 180 - 21)
					if tonumber(kmh) >= tonumber(getElementData(source, "speedcamera:speed")) then
						local radar = getElementAttachedTo(source)
						if radar then
							local x, y, z = getElementPosition(getVehicleController(hitElement))
							setTimer(function(hitElement, x, y, z, kmh)
								local nx, ny, nz = getElementPosition(hitElement)
								local dx = nx - x
								local dy = ny - y
								
								if dy > math.abs(dx) then
									direction = "northbound"
								elseif dy < -math.abs(dx) then
									direction = "southbound"
								elseif dx > math.abs(dy) then
									direction = "eastbound"
								elseif dx < -math.abs(dy) then
									direction = "westbound"
								end
								
								if isVerifiedElement(radar, "vehicle") and getElementData(radar, "speedcamera:state") then
									local c1, c2, c3, c4 = getVehicleColor(hitElement)
									for seat,player in pairs(getVehicleOccupants(radar)) do
										outputChatBox("[RADAR] A " .. getColorName(c1, c2) .. " " .. getVehicleName(hitElement) .. " was clocked travelling at " .. tonumber(kmh) .. " km/h and is heading " .. direction .. ".", player, 255, 180, 20, false)
									end
								end
							end, 500, 1, hitElement, x, y, z, kmh)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if isCameraExisting(source) then
			for _,v in ipairs(getElementsByType("vehicle")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(source) then
					removeElementData(v, "speedcamera:owner")
					removeElementData(v, "speedcamera:state")
				end
			end
			
			for _,v in ipairs(getElementsByType("colshape")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(source) then
					destroyElement(v)
					break
				end
			end
		end
	end
)

addEventHandler("onPlayerVehicleExit", root,
	function(vehicle, seat, jacked)
		if getElementData(vehicle, "speedcamera:state") then
			removeElementData(vehicle, "speedcamera:owner")
			removeElementData(vehicle, "speedcamera:state")
			for _,v in ipairs(getElementsByType("colshape")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(source) then
					destroyElement(v)
					break
				end
			end
			outputChatBox("Speed camera has been deactivated.", source, 255, 180, 20, false)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _,v in ipairs(getElementsByType("vehicle")) do
			if getElementData(v, "speedcamera:state") then
				removeElementData(v, "speedcamera:owner")
				removeElementData(v, "speedcamera:state")
				outputChatBox("Speed camera has been deactivated.", getVehicleController(v), 255, 180, 20, false)
			end
		end
		
		for _,v in ipairs(getElementsByType("colshape")) do
			if getElementData(v, "speedcamera:state") then
				destroyElement(v)
			end
		end
	end
)

addEventHandler("onPlayerWasted", root,
	function(ammo, killer, weapon, bodypart, stealth)
		if isCameraExisting(source) then
			for _,v in ipairs(getElementsByType("vehicle")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(source) then
					removeElementData(v, "speedcamera:owner")
					removeElementData(v, "speedcamera:state")
				end
			end
			
			for _,v in ipairs(getElementsByType("colshape")) do
				if getElementData(v, "speedcamera:owner") == getPlayerName(source) then
					destroyElement(v)
					break
				end
			end
			outputChatBox("Speed camera has been deactivated.", source, 255, 180, 20, false)
		end
	end
)