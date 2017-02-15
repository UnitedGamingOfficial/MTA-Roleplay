local currentWeather = 10
local interior = false
local timeSavedHour, timeSavedMinute
local x, y, z = nil

function ChangePlayerWeather(weather, blended)
	currentWeather = weather
	interior = false
	if blended then
		if getElementInterior( getLocalPlayer( ) ) == 0 then
			 timeHour, timeMinute = getTime()
			 timeSavedHour, timeSavedMinute = getTime()
			timeHour = timeHour - 1
			setTime(timeHour, timeMinute)
			setWeatherBlended( currentWeather )
			setTimer( forceWeather, 60000, 1)
			setTimer( updateTime, 1000, 60)
		end
	end
end
addEvent( "weather:update", true )
addEventHandler( "weather:update", getRootElement(), ChangePlayerWeather )

function updateTime()
	local timeHour, timeMinute = getTime()
	timeMinute = timeMinute + 1
	if timeMinute == 60 then
		timeHour = timeHour + 1
		timeMinute = 0
	end
	if timeHour == 24 then
		timeHour = 0
	end
	setTime(timeHour, timeMinute)
	--outputDebugString("step "..timeHour ..":"..timeMinute)
end

function updateInterior()
	if getElementInterior( getLocalPlayer( ) ) > 0 then
		interior = true
		if not getWeather( ) == 3 then
			setWeather( 3 )
			setSkyGradient( 0, 0, 0, 0, 0, 0 )
		end
	elseif getElementInterior( getLocalPlayer( ) ) == 0 then
		interior = false
		local currentWeatherID, blended = getWeather( )
		if not  currentWeatherID == currentWeather and not blended then
			setWeather( currentWeather )
			resetSkyGradient( )
		end
	end
end
setTimer( updateInterior, 2000, 0)

function forceWeather(  )
	setWeather( currentWeather )
	resetSkyGradient( )
	setTime(timeSavedHour, timeSavedMinute+1)
	--outputDebugString("force step "..timeSavedHour ..":"..timeSavedMinute)
end

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "weather:request", getLocalPlayer( ) )
		return
	end
)
setDevelopmentMode(true)

addCommandHandler("fw", function()
	if exports.global:isPlayerLeadAdmin(localPlayer) then   
	outputChatBox("Fireworks created!", getRootElement())
	fxAddSparks(x, y, z+1, 0, 0, 0, 5, 1000, 0, 0, 1, false, 2, 2)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTankFire(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	outputChatBox("Fireworks created!", getRootElement())
	else
	end
end)

addCommandHandler("setfw", function()
	if exports.global:isPlayerLeadAdmin(localPlayer) then
	x, y, z = getElementPosition(localPlayer)     
	outputChatBox("Fireworks position set!", getRootElement())
	else
	end
end)

addCommandHandler("resetfw", function()
	if exports.global:isPlayerLeadAdmin(localPlayer) then
	x, y, z = nil, nil, nil
	outputChatBox("Fireworks position reset!", getRootElement())
	else
	end
end)