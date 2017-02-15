local weatherArray = {}

local weatherStartTime = 0
local currentWeather = { 1, 1000, 10 }
local weatherTimer = nil
--[[local weatherStates = {
	sunny = { 0, 1, 2, 3, 4, 5, 6, 10, 13, 14, 23, 24, 25, 26, 27, 29, 33, 34, 40, 46, 52, 302, 12800 }, --  11, 17, 18  has heat waves
	clouds = { 7, 12, 15, 31, 30, 35, 36, 37, 41, 43, 47, 48, 49, 50, 51, 53, 56, 60 },
	rainy = { 8, 16, 306 },
	fog = { 9, 20, 28, 32, 38, 42, 55, 65, 88, 800 },
	dull = { 12, 54 },
	--sandstorm = { 19 },
}]]

local weatherStates = {
 { 1, 2, 3, 4, 5, 6, 8, 9, 10, 13, 14}, -- 23, 24, 25,  27, 29, 33, 34, 40, 46, 52, 302, 12800 }, --  0, 11, 17, 18  has heat waves
 { 7, 12, 15 }, -- 31, 30, 35, 36, 37, 41, 43, 47, 48, 49, 50, 51, 53, 56, 60 },
 { 8, 16 }, --, 306 },
 { 9, 20, 28, 32}, -- 38, 42, 55, 65, 88, 800 },
 { 12}, --, 54 },
	--sandstorm = { 19 },
}

function startWeather() -- Added this function to prevent the server from setting the weather at 0 by default - Anthony
	setWeather(1)
end
addEventHandler("onResourceStart", resourceRoot, startWeather)

function changeWeather()
	if  #weatherArray < 4 then
		while (#weatherArray < 8) do
			
			table.insert(weatherArray, { 1, generateRandomTime() } ) -- generateWeatherTypes()
		end
	end
	
	if weatherArray[1] then
		weatherStartTime = getRealTime().timestamp
		currentWeather = weatherArray[1]
		table.remove(weatherArray, 1)
		
		-- Generate new weatherstyle
		--outputDebugString("wtfman")
		local weatherStyle = currentWeather[1]
		--outputDebugString(tostring(#weatherStates[weatherStyle ]))
		--outputDebugString("wtfman2")
		currentWeather[3] = weatherStates[currentWeather[1]][math.random(1, #weatherStates[currentWeather[1]])]
		--outputDebugString("wtfman3")
		exports.global:sendMessageToAdmins("Weather changing to "..currentWeather[1]..":"..currentWeather[3] .." for "..	currentWeather[2] .. " second(s).")
		--outputDebugString("wtfman4")
		-- Shift weather
		triggerClientEvent("weather:update", getRootElement(), currentWeather[3], true)
		
		-- Cleanup
		if weatherTimer and isTimer(weatherTimer) then
			killTimer(weatherTimer)
		end
		weatherTimer = setTimer(changeWeather, currentWeather[2]*1000, 1)
	end
end


function eta(tp)
	if exports.global:isPlayerAdmin(tp) then
		local timed = weatherStartTime + currentWeather[2]
		local realtime = getRealTime( timed - 3600  )
		outputChatBox("Time of next change: "..realtime.hour .. ":"..realtime.minute, tp)
	else
		exports.global:sendMessageToAdmins("ILLEGAL COMMAND USAGE! " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /eta command!")
	end
end
addCommandHandler("eta", eta)

function srl(tp, commandName, rainLevel)
	if exports.global:isPlayerAdmin(tp) then
		if not rainLevel or tonumber(rainLevel) > 40 then
		outputChatBox("Invalid level entered.", tp)
		else
		setRainLevel(rainLevel)
		local rank = exports.global:getPlayerAdminTitle(tp)
		local name = getPlayerName(tp):gsub("_"," ")
		exports.global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." set the rain level to: "..rainLevel)
		outputChatBox("Set rain level to: "..rainLevel, tp)
		end
	else
		exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /srl command!")
	end
end
addCommandHandler("srl", srl)

function sw(tp, commandName, weather)
	if exports.global:isPlayerLeadAdmin(tp) then
		if not weather then
		outputChatBox("Invalid ID entered.", tp)
		else
			setWeather(tonumber(weather))
			local rank = exports.global:getPlayerAdminTitle(tp)
			local name = getPlayerName(tp):gsub("_"," ")
			exports.global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." set the weather to ID: "..weather)
			outputChatBox("Weather set to ID: "..weather, tp)
		end
	else
		exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /sw command!")
	end
end
addCommandHandler("sw", sw)

function swb(tp, commandName, weather)
	if exports.global:isPlayerLeadAdmin(tp) then
		if not weather then
		outputChatBox("Invalid ID entered.", tp)
		else
			setWeatherBlended(tonumber(weather))
			local rank = exports.global:getPlayerAdminTitle(tp)
			local name = getPlayerName(tp):gsub("_"," ")
			exports.global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." blended the weather to ID: "..weather)
			outputChatBox("Blending weather to set ID: "..weather, tp)
		end
	else
		exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /swb command!")
	end
end
addCommandHandler("swb", swb)

function swh(tp, commandName, height)
	if exports.global:isPlayerLeadAdmin(tp) then
		if not height and not height < 40 then
		outputChatBox("Invalid ID entered.", tp)
		else
			setWaveHeight(height)
			local rank = exports.global:getPlayerAdminTitle(tp)
			local name = getPlayerName(tp):gsub("_"," ")
			exports.global:sendMessageToAdmins("AdmCmd: "..rank.." "..name.." set the wave height to: "..height)
			outputChatBox("Setting wave height to: "..height, tp)
		end
	else
		exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /swh command!")
	end
end
addCommandHandler("swh", swh)

--[[
function sf(tp, commandName, fogLevel)
	if exports.global:isPlayerAdmin(tp) then
	setFogDistance(fogLevel)
	local rank = exports.global:getPlayerAdminTitle(tp)
	local name = getPlayerName(tp):gsub("_"," ")
	exports.global:sendMessageToAdmins("AdmCmd: "..rank.." Admin "..name.." set the fog level to: "..fogLevel)
	outputChatBox("Set fog level to: "..fogLevel, tp)
	else
	end
end
addCommandHandler("sf", sf)

function swv(tp, commandName, x, y, z)
	if exports.global:isPlayerLeadAdmin(tp) then
	x = tonumber(x) or 0
	y = tonumber(y) or 0
	z = tonumber(z) or 0
	setWindVelocity(x, y, z)
	outputChatBox("Wind velocity set to: ("..x..", "..y..", "..z..").", tp)
	else
	end
end
addCommandHandler("swv", swv)

function st( tp, commandName, hour, minute )
	if exports.global:isPlayerLeadAdmin(tp) then
	setTime ( hour, minute )
	outputChatBox ( "Time set to: "..hour..":"..minute..".", tp)
	end
end
addCommandHandler("st", st)

function shh(tp, commandName, heathazeLevel)
	if exports.global:isPlayerLeadAdmin(tp) then
		setHeatHaze(heathazeLevel)
		outputChatBox("Set heat haze level to: "..heathazeLevel, tp)
	else
		--exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /srl command!")
	end
end
addCommandHandler("shh", shh)

function swh(tp, commandName, whLevel)
	if exports.global:isPlayerLeadAdmin(tp) then
	setWaveHeight(whLevel)
	outputChatBox("Wave height level set to: "..whLevel, tp)
	else
	end
end
addCommandHandler("swh", swh)
]]--[[ Causes massive glitchout with vehicles that are lowered going over Santa Maria Beach Bridge
function swl(tp, commandName, waterLevel)
	if exports.global:isPlayerScripter(tp) then
	if wata == 1 then
	destroyElement ( wata )
	else
	wata = createWater(-2998, -2998, 0, 2998, -2998, 0, -2998, 2998, 0, 2998, 2998, 0)
	setWaterLevel(wata, waterLevel)
	setWaterLevel(waterLevel, true, true)
	outputChatBox("Water level set to: "..waterLevel, tp)
	end
	else
	end
end
addCommandHandler("swl", swl)

function swr(tp)
	if exports.global:isPlayerScripter(tp) then
	setWaterLevel(wata, 0)
	setWaterLevel(0, true, true)
	outputChatBox("Water level reset.", tp)
	destroyElement ( wata )
	else
	end
end
addCommandHandler("swr", swr)]]

--[[
function swb(tp, commandName, wb2)
	if exports.global:isPlayerLeadAdmin(tp) then
	local wb1 = getWeather()
	setWeatherBlended(wb2)
	outputChatBox("Weather blend set to IDs: "..wb1.." and "..wb2, tp)
	else
	end
end
addCommandHandler("swb", swb)
]]

function etan(tp)
	if exports.global:isPlayerAdmin(tp) then
		changeWeather()
		local timed = weatherStartTime + currentWeather[2]
		local realtime = getRealTime( timed - 3600  )
		outputChatBox("Time of change: "..realtime.hour .. ":"..realtime.minute, tp)
	else
		exports.global:sendMessageToAdmins("ILLEGAL COMMAND USAGE! " .. getPlayerName(tp):gsub("_"," ") .. " has attempted to use the /etanow command!")
	end
end
addCommandHandler("etanow", etan)

function generateWeatherTypes()
	return (math.random(1, #weatherStates) < #weatherStates / 1.5 and math.random(1, 2) or math.random(1, #weatherStates))
end

function generateRandomTime()
	return ((math.random(1, 6) == 1 and math.random(10, 26) or math.random(29, 120)) * 60) -- Generate time in seconds
end

addEvent( "weather:request", true )
addEventHandler( "weather:request", getRootElement( ),
	function( )
		triggerClientEvent(client or source, "weather:update", getRootElement(), currentWeather[3], false)
	end
)

function parseWeatherDetails(condition, humidity, temperature, wind, icon)
	if condition == "ERROR" then
		return
	elseif condition == nil then
		return
	else
		if w == 'sunny' or w == 'mostly sunny' or w == 'chance of storm' then
			setWeatherEx( 'sunny' )
		elseif w == 'partly cloudy' or w == 'mostly cloudy' or w == 'smoke' or w == 'cloudy' then
			setWeatherEx( 'clouds' )
		elseif w == 'showers' or w == 'rain' or w == 'chance of rain' then
			setWeatherEx( 'rainy' )
		elseif w == 'storm' or w == 'thunderstorm' or w == 'chance of tstorm' then
			setWeatherEx( 'stormy' )
		elseif w == 'fog' or w == 'icy' or w == 'snow' or w == 'chance of snow' or w == 'flurries' or w == 'sleet' or w == 'mist' then
			setWeatherEx( 'fog' )
		elseif w == 'dust' or w == 'haze' then
			setWeatherEx( 'dull' )
		end
	end
end
setTimer( changeWeather, 5000, 1)