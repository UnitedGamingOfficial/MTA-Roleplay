local mysql = exports.mysql

-- towing impound lot
local towSphere = createColPolygon(2155.1345214844, -2844.2290039063, 2126.9558105469, -2844.2290039063, 2127.0163574219, -2834.0209960938, 2116.7595214844, -2833.6547851563, 2116.7399902344, -2715.7543945313, 2116.7399902344, -2715.7543945313, 2126.8395996094, -2706.3256835938, 2204.8073730469, -2706.3247070313, 2214.5769042969, -2715.8764648438, 2214.6354980469, -2833.8139648438, 2126.9558105469, -2844.2260742188, 2155.1354980469, -2844.2280273438)
--createColPolygon(-2097.544921875, -110.19140625, -2155.9931640625, -110.19140625, -2155.9873046875, -159.1455078125, -2158.908203125, -173.857421875, -2167.888671875, -188.4033203125, -2180.955078125, -197.376953125, -2196.6479492188, -200.7822265625, -2200.9301757813, -200.8916015625, -2200.8256835938, -280.0537109375, -2097.5439453125, -280.072265625, -2097.5458984375, -110.1904296875)


local towImpoundSphere = createColPolygon( 2155.1364746094, -2844.1352539063, 2126.9577636719, -2844.2299804688, 2125.9597167969, -2816.7817382813, 2154.6403808594, -2809.5805664063, 2155.1364746094, -2844.1352539063)
--createColPolygon(-2097.544921875, -110.19140625, -2155.9931640625, -110.19140625, -2155.9873046875, -159.1455078125, -2158.908203125, -173.857421875, -2167.888671875, -188.4033203125, -2180.955078125, -197.376953125, -2196.6479492188, -200.7822265625, -2200.9301757813, -200.8916015625, -2200.8256835938, -280.0537109375, -2097.5439453125, -280.072265625, -2097.5400390625, -154.9990234375, -2110.3388671875, -154.6435546875, -2110.3427734375, -110.259765625)
-- pd db impound lot
local towSphere2 = createColPolygon(1245.8515625, -1651.591796875, 1279.8330078125, -1644.9619140625, 1279.8349609375, -1659.2939453125, 1268.767578125, -1659.517578125, 1268.771484375, -1677.0888671875, 1213.4970703125, -1677.193359375, 1213.4970703125, -1638.1162109375, 1268.7724609375, -1638.115234375, 1268.7939453125, -1644.833984375)

-- IGS - no /park zone
local towSphere3 = createColPolygon(1932.6806640625, -1778.4501953125, 1904.0517578125, -1762.48828125, 1950.74609375, -1761.9482421875, 1951.0078125, -1795.783203125, 1904.0517578125, -1796.248046875 )

-- RS Haul no /park zone
local RSHaulSphere = createColPolygon(-78.072265625, -1101.0654296875, -20.7373046875, -1120.7197265625,  -39.796875, -1160.791015625,-91.3857421875, -1136.51953125, -78.072265625, -1101.0654296875 )

local currentReleasePos = 0

local parkingPositions = {
                        { 2134.1220703125, -2676.5947265625, 13.17191696167 , 0, 0, 212 },
                        { 2138.7412109375, -2673.07421875, 13.171723365784, 0, 0, 219 },
                        { 2142.4833984375, -2669.04296875, 13.171941757202, 0, 0, 218 },
                        { 2147.0361328125, -2665.25, 13.171697616577, 0, 0, 220 },
                    }


function getReleasePosition()
    currentReleasePos = currentReleasePos + 1
    if currentReleasePos > #parkingPositions then
        currentReleasePos = 1
    end
    
    return parkingPositions[ currentReleasePos ][1], parkingPositions[ currentReleasePos ][2], parkingPositions[ currentReleasePos ][3], parkingPositions[ currentReleasePos ][4], parkingPositions[ currentReleasePos ][5], parkingPositions[ currentReleasePos ][6]
end

function cannotVehpos(thePlayer, theVehicle)
    return isElementWithinColShape(thePlayer, towSphere) and getElementData(thePlayer,"faction") ~= 4 or isElementWithinColShape(thePlayer, towSphere3) or isElementWithinColShape(thePlayer, RSHaulSphere)
end

-- generic function to check if a guy is in the col polygon and the right team
function CanTowTruckDriverVehPos(thePlayer, commandName)
    local ret = 0
    if (isElementWithinColShape(thePlayer, towSphere) or isElementWithinColShape(thePlayer,towSphere2)) then
        if (getElementData(thePlayer,"faction") == 4) then
            ret = 2
        else
            ret = 1
        end
    end
    return ret
end

--Auto Pay for PD
function CanTowTruckDriverGetPaid(thePlayer, commandName)
    if (isElementWithinColShape(thePlayer,towSphere2)) then
        if (getElementData(thePlayer,"faction") == 4) then
            return true
        end
    end
    return false
end

function UnlockVehicle(element, matchingdimension) 
    if (getElementType(element) == "vehicle" and getVehicleOccupant(element) and getElementData(getVehicleOccupant(element),"faction") == 4 and getElementModel(element) == 525 and getVehicleTowedByVehicle(element)) then
        local temp = element
        while (getVehicleTowedByVehicle(temp)) do
            temp = getVehicleTowedByVehicle(temp)
            local owner = getElementData(temp, "owner")
            local faction = getElementData(temp, "faction")
            local dbid = getElementData(temp, "dbid")
            local impounded = getElementData(temp, "Impounded")
            local thePlayer = getVehicleOccupant(element)
            if (owner > 0) then
                if (faction > 3 or faction < 0) then
                    if (source == towSphere2) then
                        --PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
                        setVehicleLocked(temp, false)
                        exports['anticheat-system']:changeProtectedElementDataEx(temp, "Impounded", 0)
                        exports['anticheat-system']:changeProtectedElementDataEx(temp, "enginebroke", 0, false)
                        setVehicleDamageProof(temp, false)
                        setVehicleEngineState(temp, false)
                        outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", thePlayer, 255, 194, 14)
                    else
                        if (getElementData(temp, "faction") ~= 4) then
                            if (impounded == 0) then
                                --unlock it and impound it
                                exports['anticheat-system']:changeProtectedElementDataEx(temp, "Impounded", getRealTime().yearday)
                                setVehicleLocked(temp, false)
                                exports['anticheat-system']:changeProtectedElementDataEx(temp, "enginebroke", 1, false)
                                setVehicleEngineState(temp, false)
                                
                                local time = getRealTime()
                                -- fix trailing 0's
                                local hour = tostring(time.hour)
                                local mins = tostring(time.minute)
                                
                                if ( time.hour < 10 ) then
                                    hour = "0" .. hour
                                end
                                
                                if ( time.minute < 10 ) then
                                    mins = "0" .. mins
                                end
                                local datestr = time.monthday .. "/" .. time.month .." " .. hour .. ":" .. mins
                                
                                local theTeam = exports.pool:getElement("team", 4)
                                local factionRanks = getElementData(theTeam, "ranks")
                                local factionRank = factionRanks[ getElementData(thePlayer, "factionrank") ] or ""
                                
                                exports.global:giveItem(temp, 72, "Towing Notice: Impounded by ".. factionRank .." '".. getPlayerName(thePlayer) .."' at "..datestr)
                                outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", thePlayer, 255, 194, 14)
                            end
                        end
                    end
                else
                    outputChatBox("This faction's vehicle cannot be impounded.", thePlayer, 255, 194, 14)
                end
            end
        end
    end
end
addEventHandler("onColShapeHit", towImpoundSphere, UnlockVehicle)
addEventHandler("onColShapeHit", towSphere2, UnlockVehicle)

-- Command to impound Bikes:
function setbikeimpound(player, matchingDimension)
    local leader = tonumber( getElementData(player, "factionleader") ) or 0
    local rank = tonumber( getElementData(player, "factionrank") ) or 0

    local veh = getPedOccupiedVehicle(player)
    if (getElementData(player,"faction")) == 4 then
        if (isPedInVehicle(player)) then
            if (getVehicleType(veh) == "Bike") or (getVehicleType(veh) == "BMX") then
                local owner = getElementData(veh, "owner")
                local faction = getElementData(veh, "faction")
                local dbid = getElementData(veh, "dbid")
                local impounded = getElementData(veh, "Impounded")
                if (owner > 0) then
                    if (faction > 3 or faction < 0) then
                        if (source == towSphere2) then
                            --PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
                            setVehicleLocked(veh, false)
                            exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", 0)
                            exports['anticheat-system']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
                            setVehicleDamageProof(veh, false)
                            setVehicleEngineState(veh, false)
                            outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
                        else
                            if rank >= 5 then
                                if (getElementData(veh, "faction") ~= 4) then
                                    if (impounded == 0) then
                                        exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", getRealTime().yearday)
                                        setVehicleLocked(veh, false)
                                        exports['anticheat-system']:changeProtectedElementDataEx(veh, "enginebroke", 1, false)
                                        setVehicleEngineState(veh, false)
                                        outputChatBox("(( The bike has been successfully impounded. ))", player, 50, 205, 50)
                                        outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
                                        isin = false
                                        
                                        exports.logs:logMessage("[IMPOUNDED BIKE] " .. getPlayerName(player) .. " impounded vehicle #" .. dbid .. ", owned by " .. tostring(exports['cache']:getCharacterName(owner)) .. ", in " .. table.concat({exports.global:getElementZoneName(veh)}, ", ") .. " (pos = " .. table.concat({getElementPosition(veh)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(veh)}, ", ") .. ", health = " .. getElementHealth(veh) .. ")", 14)
                                    end
                                end
                            else
                                local factionRanks = getElementData(getPlayerTeam(player), "ranks")
                                local factionRank = factionRanks[ 5 ] or "awesome dudes"
                                outputChatBox("Command only usable by " .. factionRank .. " and above.", player, 255, 194, 14)
                            end
                        end
                    else
                        outputChatBox("This faction's vehicle cannot be impounded.", player, 255, 194, 14)
                    end
                end
            else
                outputChatBox("You can only use this command to impound motorcycles and bicycles.", player, 255, 194, 14)
            end
        else
            outputChatBox("You are not in a vehicle.", player, 255, 0, 0)
        end
    end
end
addCommandHandler("impoundbike", setbikeimpound)

function payRelease(vehID)
    if exports.global:takeMoney(source, 225) then
        exports.global:giveMoney(getTeamFromName("Los Santos Towing & Recovery"), 225)
        setElementFrozen(vehID, false)
        local x, y, z, int, dim, rotation = getReleasePosition()
        setElementPosition(vehID, x, y, z)
        setVehicleRotation(vehID, 0, 0, rotation)
        setElementInterior(vehID, int)
        setElementDimension(vehID, dim)
        setVehicleLocked(vehID, true)
        exports['anticheat-system']:changeProtectedElementDataEx(vehID, "enginebroke", 0, false)
        setVehicleDamageProof(vehID, false)
        setVehicleEngineState(vehID, false)
        exports['anticheat-system']:changeProtectedElementDataEx(vehID, "handbrake", 0, false)
        exports['anticheat-system']:changeProtectedElementDataEx(vehID, "Impounded", 0)

        outputChatBox("Your vehicle has been released, it's out front. (( Please remember to /park your vehicle so it does not respawn back here. ))", source, 255, 194, 14)
    else
        outputChatBox("Insufficient funds.", source, 255, 0, 0)
    end
end
addEvent("releaseCar", true)
addEventHandler("releaseCar", getRootElement(), payRelease)

function unimpoundVeh(thePlayer, commandName, vehid)
    if thePlayer then
        if not vehid then
            outputChatBox("SYNTAX: /" .. commandName .. " [Vehicle ID]", thePlayer, 255, 194, 14)
        else
            local vehID = exports.pool:getElement("vehicle", tonumber(vehid))
            if not vehID then
                outputChatBox("Invalid Vehicle.", thePlayer, 255, 0, 0)
            else
                if getElementData(vehID, "Impounded") and getElementData(vehID, "Impounded") >= 1 then
                    if commandName == "unimpound" then
                        if (getElementData(thePlayer,"faction") == 4) then
                            if(getElementData(thePlayer, "factionleader") == 1) then
                                setElementFrozen(vehID, false)
                                local x, y, z, int, dim, rotation = getReleasePosition()
                                setElementPosition(vehID, x, y, z)
                                setVehicleRotation(vehID, 0, 0, rotation)
                                setElementInterior(vehID, int)
                                setElementDimension(vehID, dim)
                                setVehicleLocked(vehID, true)
                                exports['anticheat-system']:changeProtectedElementDataEx(vehID, "enginebroke", 0, false)
                                setVehicleDamageProof(vehID, false)
                                setVehicleEngineState(vehID, false)
                                exports['anticheat-system']:changeProtectedElementDataEx(vehID, "handbrake", 0, false)
                                exports['anticheat-system']:changeProtectedElementDataEx(vehID, "Impounded", 0)
                                updateVehPos(vehID)
                                triggerEvent("parkVehicle", thePlayer, vehID)

                                outputChatBox("You have unimpounded vehicle #" .. vehid .. ".", thePlayer, 0, 255, 0)
                                
                                local theTeam = getTeamFromName("Los Santos Towing & Recovery")
                                local teamPlayers = getPlayersInTeam(theTeam)
                                local username = getPlayerName(thePlayer):gsub("_", " ")
                                for key, value in ipairs(teamPlayers) do
                                    outputChatBox(username .. " has unimpounded vehicle #" .. vehid .. ".", value, 0, 255, 0)
                                end
                                
                                exports.logs:logMessage("[SFTR-UNIMPOUND] " .. username .. " has unimpounded vehicle #" .. vehid .. ".", 9)
                            else
                                outputChatBox("You must be the faction leader.", thePlayer, 255, 0, 0)
                            end
                        end
                    elseif commandName == "aunimpound" then
                        if exports.global:isPlayerSuperAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 16) then
                            setElementFrozen(vehID, false)
                            local x, y, z, int, dim, rotation = getReleasePosition()
                            setElementPosition(vehID, x, y, z)
                            setVehicleRotation(vehID, 0, 0, rotation)
                            setElementInterior(vehID, int)
                            setElementDimension(vehID, dim)
                            setVehicleLocked(vehID, true)
                            exports['anticheat-system']:changeProtectedElementDataEx(vehID, "enginebroke", 0, false)
                            setVehicleDamageProof(vehID, false)
                            setVehicleEngineState(vehID, false)
                            exports['anticheat-system']:changeProtectedElementDataEx(vehID, "handbrake", 0, false)
                            exports['anticheat-system']:changeProtectedElementDataEx(vehID, "Impounded", 0)
                            updateVehPos(vehID)
                            triggerEvent("parkVehicle", thePlayer, vehID)
                            
                            local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
                            local playerName = getPlayerName(thePlayer):gsub("_", " ")
                            outputChatBox("You have unimpounded vehicle #" .. vehid .. ".", thePlayer, 0, 255, 0)
                            exports.global:sendMessageToAdmins("AdmCmd: " .. adminTitle .. " " .. playerName .. " unimpounded vehicle #" .. vehid .. ".")
                            
                            exports.logs:logMessage("[ADMIN-UNIMPOUND] " .. playerName .. " has unimpounded vehicle #" .. vehid .. ".", 9)
                        end
                    end
                else
                    outputChatBox("Vehicle #" .. vehid .. " is not currently impounded.", thePlayer, 255, 0, 0)
                end
            end
        end
    end
end
addCommandHandler("unimpound", unimpoundVeh)
addCommandHandler("aunimpound", unimpoundVeh)

function disableEntryToTowedVehicles(thePlayer, seat, jacked, door) 
    if (getVehicleTowingVehicle(source)) then
        if seat == 0 then
            outputChatBox("You cannot enter a vehicle being towed!", thePlayer, 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onVehicleStartEnter", getRootElement(), disableEntryToTowedVehicles)

function triggerShowImpound()
    element = client
    local vehElements = {}
    local count = 1
    for key, value in ipairs(getElementsByType("vehicle")) do
        local dbid = getElementData(value, "dbid")
        if (getElementData(value, "Impounded") and getElementData(value, "Impounded") > 0 and ((dbid > 0 and exports.global:hasItem(element, 3, dbid) or (getElementData(value, "faction") == getElementData(element, "faction") and getElementData(value, "owner") == getElementData(element, "dbid"))))) then
            vehElements[count] = value
            count = count + 1
        end
    end
    triggerClientEvent( element, "ShowImpound", element, vehElements)
end
addEvent("onTowMisterTalk", true)
addEventHandler("onTowMisterTalk", getRootElement(), triggerShowImpound)

function updateVehPos(veh)
    local x, y, z = getElementPosition(veh)
    local rx, ry, rz = getVehicleRotation(veh)
        
    local interior = getElementInterior(veh)
    local dimension = getElementDimension(veh)
    local dbid = getElementData(veh, "dbid")
    mysql:query_free("UPDATE vehicles SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
    setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
    exports['anticheat-system']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
end

function updateTowingVehicle(theTruck)
    local thePlayer = getVehicleOccupant(theTruck)
    if (thePlayer) then
        if (getElementData(thePlayer,"faction") == 4) or (getElementData(thePlayer,"faction") == 42) then
            local owner = getElementData(source, "owner")
            local faction = getElementData(source, "faction")
            local carName = getVehicleName(source)
            
            if owner < 0 and faction == -1 then
                outputChatBox("(( This " .. carName .. " is a civilian vehicle. ))", thePlayer, 255, 195, 14)
            elseif (faction==-1) and (owner>0) then
                local ownerName = exports["cache"]:getCharacterName(owner)
                outputChatBox("(( This " .. carName .. " belongs to " .. ownerName .. ". ))", thePlayer, 255, 195, 14)
            else
                local row = mysql:query_fetch_assoc("SELECT name FROM factions WHERE id='" .. mysql:escape_string(faction) .. "' LIMIT 1")
            
                if not (row == false) then
                    local ownerName = row.name
                    outputChatBox("(( This " .. carName .. " belongs to the " .. ownerName .. " faction. ))", thePlayer, 255, 195, 14)
                end
            end
            
            if (getElementData(source, "Impounded") > 0) then
                local output = getRealTime().yearday-getElementData(source, "Impounded")
                outputChatBox("(( This " .. carName .. " has been impounded for: " .. output .. (output == 1 and " Day." or " Days.") .. " ))", thePlayer, 255, 195, 14)
            end
            
            -- fix for handbraked vehicles
            local handbrake = getElementData(source, "handbrake")
            if (handbrake == 1) then
                exports['anticheat-system']:changeProtectedElementDataEx(source, "handbrake",0,false)
                setElementFrozen(source, false)
            end
        end
        if thePlayer then
            exports.logs:logMessage("[TOW] " .. getPlayerName( thePlayer ) .. " started towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['cache']:getCharacterName(getElementData(source,"owner"))) .. ", from " .. table.concat({exports.global:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
        end
    end
end

addEventHandler("onTrailerAttach", getRootElement(), updateTowingVehicle)

function updateCivilianVehicles(theTruck)
    if (isElementWithinColShape(theTruck, towSphere)) then
        local owner = getElementData(source, "owner")
        local faction = getElementData(source, "faction")
        local dbid = getElementData(source, "dbid")

        if (dbid >= 0 and faction == -1 and owner < 0) then
            exports.global:giveMoney(getTeamFromName("Los Santos Towing & Recovery"), 225)
            outputChatBox("The state has unimpounded the vehicle you were towing.", getVehicleOccupant(theTruck), 255, 194, 14)
            respawnVehicle(source)
        end
    end
    
    if getVehicleOccupant(theTruck) then
        exports.logs:logMessage("[TOW STOP] " .. getPlayerName( getVehicleOccupant(theTruck) ) .. " stopped towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['cache']:getCharacterName(getElementData(source,"owner"))) .. ", in " .. table.concat({exports.global:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
    end
end
addEventHandler("onTrailerDetach", getRootElement(), updateCivilianVehicles)
