mysql = exports.mysql
local marijuanaplantstimers =  { }
local threads = { }
local toLoad = { }

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM marijuanaplants AS e1 LEFT JOIN marijuanaplants AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function saveAllMarijuanaPlants()
	for key, value in ipairs (getElementsByType("object", getResourceRootElement())) do
		local id = getElementData(value, "marijuanaplant:id")
		local day = getElementData(value, "marijuanaplant:day")
		local grams = getElementData(value, "marijuanaplant:grams")
		local createdby = getElementData(value, "marijuanaplant:createdby")
		local x, y, z = getElementPosition(value)
		local rx, ry, rz = getElementRotation(value)
		mysql:query_free("UPDATE marijuanaplants SET day = '" .. mysql:escape_string(day) .. "', grams = '" .. mysql:escape_string(grams) .. "', createdby = '" .. mysql:escape_string(createdby) .. "', x = '" .. mysql:escape_string(x) .. "', y = '" .. mysql:escape_string(y) .. "', z = '" .. mysql:escape_string(z) .. "', rx = '" .. mysql:escape_string(rx) .. "', ry = '" .. mysql:escape_string(ry) .. "', rz = '" .. mysql:escape_string(rz) .. "' WHERE id='" .. mysql:escape_string(id) .. "'")
	end
end
addEventHandler("onResourceStop", getResourceRootElement(), saveAllMarijuanaPlants)

function createMarijuanaPlant(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		z = z - 1
		local rx, ry, rz = getElementRotation(thePlayer)
		local id = SmallestID()
		local createdby = getPlayerName(thePlayer):gsub("_", " ")
		local query = mysql:query_fetch_assoc("INSERT INTO marijuanaplants SET id="..mysql:escape_string(id)..",day='1',grams='0',createdby='"..mysql:escape_string(createdby).."',x='"..mysql:escape_string(x).."', y='"..mysql:escape_string(y).."', z='"..mysql:escape_string(z).."', rx='"..mysql:escape_string(rx).."', ry='"..mysql:escape_string(ry).."', rz='"..mysql:escape_string(rz).."'")
		if query then
			loadOnePlant(id)
		end
	end
end
addCommandHandler("makemarijuanaplant", createMarijuanaPlant, false, false)

function deleteMarijuanaPlant(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if tonumber(id) then
			local plant
			for k, v in ipairs (getElementsByType("object", getResourceRootElement())) do
				local dbid = getElementData(v, "marijuanaplant:id")
				if dbid and dbid == id then
					plant = v
					break
				end
			end
			if plant then
				killTimer(marijuanaplantstimers[id])
				local query = mysql:query_free("DELETE FROM marijuanaplants WHERE id='"..mysql:escape_string(id).."'")
				if query then
					destroyElement(plant)
					outputChatBox("Marijuana plant ID: "..id.." deleted.", thePlayer, 0, 255, 0)
				else
					outputChatBox("Error deleting marijuana plant. Please report on the mantis.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("A plant with that ID does not exist.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Please enter a number as the ID.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delmarijuanaplant", deleteMarijuanaPlant, false, false)

function moveMarijuanaPlant(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if tonumber(id) then
			local plant
			for k, v in ipairs (getElementsByType("object", getResourceRootElement())) do
				local dbid = getElementData(v, "marijuanaplant:id")
				if dbid and dbid == id then
					plant = v
					break
				end
			end
			if plant then
				local x, y, z = getElementPosition(thePlayer)
				z = z - 1
				local querymove = mysql:query_free("UPDATE marijuanaplants SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. " WHERE id='" .. mysql:escape_string(id) .. "'")
				if querymove then
					setElementPosition(plant, x, y, z)
					outputChatBox("Marijuana plant ID: "..id.." moved.", thePlayer, 0, 255, 0)
				else
					outputChatBox("Error moving marijuana plant. Please report on the mantis.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("No plant with that ID was found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("movemarijuanaplant", moveMarijuanaPlant, false, false)

function loadAllMarijuanaPlants(res)
	if not res then
		for k, v in ipairs (getElementsByType("object", getResourceRootElement())) do
			local id = getElementData(v, "marijuanaplant:id")
			if isTimer(marijuanaplantstimers[id]) then
				killTimer(marijuanaplantstimers[id])
			end
			destroyElement(v)
		end
	end
	local result = mysql:query("SELECT * FROM `marijuanaplants`")
	while true do
		local row = mysql:fetch_assoc(result)
		if not row then break end
		loadOnePlant(row.id)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllMarijuanaPlants)

function loadOnePlant(id)
	local row = mysql:query_fetch_assoc("SELECT * FROM `marijuanaplants` WHERE id =".. mysql:escape_string(id) .. " LIMIT 1")
	local day = tonumber(row["day"])
	local grams = tonumber(row["grams"])
	local createdby = tostring(row["createdby"])
	local x = tonumber(row["x"])
	local y = tonumber(row["y"])
	local z = tonumber(row["z"])
	local rx = tonumber(row["rx"])
	local ry = tonumber(row["ry"])
	local rz = tonumber(row["rz"])
	local object = createObject(626, x, y, z, rx, ry, rz)
	exports['anticheat-system']:changeProtectedElementDataEx(object, "marijuanaplant:id", id)
	exports['anticheat-system']:changeProtectedElementDataEx(object, "marijuanaplant:day", day)
	exports['anticheat-system']:changeProtectedElementDataEx(object, "marijuanaplant:grams", grams)
	exports['anticheat-system']:changeProtectedElementDataEx(object, "marijuanaplant:createdby", createdby)
	marijuanaplantstimers[id] = setTimer(growMarijuanaPlant, 5000, 1, id)
end

function getNearbyMarijuanaPlants(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Marijuana Plants:", thePlayer, 255, 126, 0)
		local count = 0
		for key, value in ipairs (getElementsByType("object", getResourceRootElement())) do
			local dbid = getElementData(value, "marijuanaplant:id")
			if dbid then
				local x, y, z = getElementPosition(value)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if distance <= 10 and getElementDimension(value) == getElementDimension(thePlayer) and getElementInterior(value) == getElementInterior(thePlayer) then
					local createdby = getElementData(value, "marijuanaplant:createdby")
					local grams = getElementData(value, "marijuanaplant:grams")
					outputChatBox("   #" .. dbid .. " by " .. createdby .. " - Marijuana Plant: " .. grams .. " grams", thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbymarijuanaplants", getNearbyMarijuanaPlants, false, false)

function growMarijuanaPlant(id)
	local plant
	for k, v in ipairs (getElementsByType("object", getResourceRootElement())) do
		local dbid = getElementData(v, "marijuanaplant:id")
		if dbid and dbid == id then
			plant = v
			break
		end
	end
	local timer = tonumber(getElementData(plant, "marijuanaplant:timer"))
	timer = timer - 1
	if timer == 0 then
		local day = getElementData(plant, "marijuanaplant:day")
		if day < 4 then
			local newgrams = tonumber(getElementData(plant, "marijuanaplant:grams"))
			if newgrams < 28 then
				newgrams = newgrams + 28
				exports['anticheat-system']:changeProtectedElementDataEx(plant, "marijuanaplant:grams", 28)
			elseif newgrams < 56 then
				newgrams = newgrams + 28
				exports['anticheat-system']:changeProtectedElementDataEx(plant, "marijuanaplant:grams", 56)
			elseif newgrams < 84 then
				newgrams = newgrams + 28
				exports['anticheat-system']:changeProtectedElementDataEx(plant, "marijuanaplant:grams", 84)
			else
				outputDebugString("POT-PLANT-ERROR-0003 in growth")
			end
			day = day + 1
			local querygrow = mysql:query_free("UPDATE marijuanaplants SET grams = " .. newgrams .. ", day = '" .. day .. "', timer=24 WHERE id='" .. mysql:escape_string(id) .. "'")
			if querygrow then
				--local x, y, z = getElementPosition(plant)
				--moveObject(plant, 5000, x, y ,z+0.5)
				marijuanaplantstimers[id] = setTimer(growMarijuanaPlant, 5000, 1, id)
				exports['anticheat-system']:changeProtectedElementDataEx(plant, "marijuanaplant:day", day)
			end
		end
	else
		exports['anticheat-system']:changeProtectedElementDataEx(plant, "marijuanaplant:timer", timer)
		local querygrow = mysql:query_free("UPDATE marijuanaplants SET timer= " .. timer .. " WHERE id='" .. mysql:escape_string(id) .. "'")
		marijuanaplantstimers[id] = setTimer(growMarijuanaPlant, 5000, 1, id)
	end
end

function giveMarijuanaToPlayer(thePlayer, grams, id)
	local plant
	for k, v in ipairs (getElementsByType("object", getResourceRootElement())) do
		local dbid = getElementData(v, "marijuanaplant:id")
		if dbid and dbid == id then
			plant = v
			break
		end
	end
	if plant then
		if isTimer(marijuanaplantstimers[id]) then
			killTimer(marijuanaplantstimers[id])
		end
		destroyElement(plant)
		local querydelete = mysql:query_free("DELETE FROM marijuanaplants WHERE id='"..mysql:escape_string(id).."'")
		outputChatBox("You harvested " .. grams .. " grams from the marijuana plant.", thePlayer, 0, 255, 0)
		exports['item-system']:giveItem(thePlayer, 38, grams.." grams")
		triggerClientEvent("hideMarijuanaPlantGUI", thePlayer)
	else
		outputChatBox("POT-PLANT-ERROR-0004 - Please report on the forums!", thePlayer, 255, 0, 0)
	end
end
addEvent( "giveMarijuanaToPlayer", true )
addEventHandler( "giveMarijuanaToPlayer", getRootElement(), giveMarijuanaToPlayer)
