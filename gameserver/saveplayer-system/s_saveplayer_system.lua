mysql = exports.mysql
local playersToBeSaved = { }

function beginSave()
	outputDebugString("WORLDSAVE INCOMING")
	for key, value in ipairs(getElementsByType("player")) do
		--triggerEvent("savePlayer", value, "Save All")
		table.insert(playersToBeSaved, value)
	end
	local timerDelay = 0
	for key, thePlayer in ipairs(playersToBeSaved) do
		timerDelay = timerDelay + 1000
		setTimer(savePlayer, timerDelay, 1, "Save All", thePlayer)
	end
end

function syncTIS()
	for key, value in ipairs(getElementsByType("player")) do
		local tis = getElementData(value, "timeinserver")
		if (tis) and (getPlayerIdleTime(value) < 600000)  then
			exports['anticheat-system']:changeProtectedElementDataEx(value, "timeinserver", tonumber(tis)+1, false)
		end
	end
end
setTimer(syncTIS, 60000, 0)

function savePlayer(reason, player)
	if source ~= nil then
		player = source
	end
	if isElement(player) then
		local logged = getElementData(player, "loggedin")
		if (logged==1 or reason=="Change Character") then
			local vehicle = getPedOccupiedVehicle(player)
		
			if (vehicle) then
				local seat = getPedOccupiedVehicleSeat(player)
				triggerEvent("onVehicleExit", vehicle, player, seat)
			end
		
			local x, y, z, rot, health, armour, interior, dimension, cuffed, skin, duty, timeinserver, businessprofit, alcohollevel
		
			local x, y, z = getElementPosition(player)
			local rot = getPedRotation(player)
			local health = getElementHealth(player)
			local armor = getPedArmor(player)
			local interior = getElementInterior(player)
			local dimension = getElementDimension(player)
			local alcohollevel = getElementData(player, "alcohollevel")
			local d_addiction = ( getElementData(player, "drug.1") or 0 ) .. ";" .. ( getElementData(player, "drug.2") or 0 ) .. ";" .. ( getElementData(player, "drug.3") or 0 ) .. ";" .. ( getElementData(player, "drug.4") or 0 ) .. ";" .. ( getElementData(player, "drug.5") or 0 ) .. ";" .. ( getElementData(player, "drug.6") or 0 ) .. ";" .. ( getElementData(player, "drug.7") or 0 ) .. ";" .. ( getElementData(player, "drug.8") or 0 ) .. ";" .. ( getElementData(player, "drug.9") or 0 ) .. ";" .. ( getElementData(player, "drug.10") or 0 )
			money = getElementData(player, "stevie.money")
			if money and money > 0 then
			money = 'money = money + ' .. money .. ', '
			else
				money = ''
			end
			skin = getElementModel(player)
		
			if getElementData(player, "help") then
				dimension, interior, x, y, z = unpack( getElementData(player, "help") )
			end
		
			-- Fix for #0000984
			if getElementData(player, "businessprofit") and ( reason == "Quit" or reason == "Timed Out" or reason == "Unknown" or reason == "Bad Connection" or reason == "Kicked" or reason == "Banned" ) then
				businessprofit = 'bankmoney = bankmoney + ' .. getElementData(player, "businessprofit") .. ', '
			else
				businessprofit = ''
			end
		
			-- Fix for freecam-tv
			if exports['freecam-tv']:isPlayerFreecamEnabled(player) then 
				x = getElementData(player, "tv:x")
				y = getElementData(player, "tv:y")
				z =  getElementData(player, "tv:z")
				interior = getElementData(player, "tv:int")
				dimension = getElementData(player, "tv:dim") 
			end
		
			local  timeinserver = getElementData(player, "timeinserver")
			-- LAST AREA
			local zone = exports.global:getElementZoneName(player)
			if not zone or #zone == 0 then
				zone = "Unknown"
			end
		
			local update = mysql:query_free("UPDATE characters SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotation='" .. mysql:escape_string(rot) .. "', health='" .. mysql:escape_string(health) .. "', armor='" .. mysql:escape_string(armor) .. "', dimension_id='" .. mysql:escape_string(dimension) .. "', interior_id='" .. mysql:escape_string(interior) .. "', " .. mysql:escape_string(money) .. mysql:escape_string(businessprofit) .. "lastlogin=NOW(), lastarea='" .. mysql:escape_string(zone) .. "', timeinserver='" .. mysql:escape_string(timeinserver) .. "', alcohollevel='".. mysql:escape_string( tostring( alcohollevel ) ) .."' WHERE id=" .. mysql:escape_string(getElementData(player, "dbid"))) -- , d_addiction='" .. mysql:escape_string(d_addiction) .. "'
			if not (update) then
				outputDebugString( "Saveplayer Update:" )
			end
		
			local update2 = mysql:query_free("UPDATE accounts SET lastlogin=NOW() WHERE id = " .. mysql:escape_string(getElementData(player,"account:id")))
			if not (update2) then
				outputDebugString( "Saveplayer Update2: " )
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)
setTimer(beginSave, 3600000, 0)
addCommandHandler("saveall", function(p) if exports.global:isPlayerHeadAdmin(p) then beginSave() outputChatBox("Done.", p) end end)
addCommandHandler("saveme", function(p) triggerEvent("savePlayer", p, "Save Me", p) end)