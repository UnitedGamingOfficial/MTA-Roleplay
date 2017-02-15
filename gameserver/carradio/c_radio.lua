radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

local totalStreams = 22 --Update this with the number of streams
local theTimer
local streams = { }
--Template: streams[Next Number In Order] = { "Link to Stream", "Name of Stream" }
streams[1] = {"http://relay.181.fm:8008", "181.1 - Rock 181 FM"}
streams[2] = {"http://relay.181.fm:8068","181.2 - Old School 181 FM"}
streams[3] = {"http://206.190.130.180:8120", "181.3 - Reggaeton 181 FM"}
streams[4] = {"http://relay.181.fm:8096", "181.4 - Reggae 181 FM"}
streams[5] = {"http://relay.181.fm:8132", "181.5 - Oldies 181 FM"}
streams[6] = {"http://relay.181.fm:8026", "181.6 - Comedy 181 FM"}
streams[7] = {"http://relay.181.fm:8006", "181.7 - Love 181 FM"}
streams[8] = {"http://relay.181.fm:8034", "181.8 - Country 181 FM"}
streams[9] = {"http://relay.181.fm:8098", "181.9 - Salsa 181 FM"}
streams[10] = {"http://listen.hardbase.fm/dsl.pls", "107.9 - HardBase FM"}
streams[11] = {"http://149.5.240.22/WR-FI-finland.m3u", "107.6 - NRJ FM"}
streams[12] = {"http://blackbeats.fm/listen.asx", "107.2 - Beats FM"}
streams[13] = {"http://205.188.215.229:8040", "106.6 FM - HOT 108 JAMZ"}
streams[14] = {"http://108.61.73.119:8054", "106.2 FM - The Beat"}
streams[15] = {"http://stream-103.shoutcast.com:80/powerhitz_mp3_128kbps", "105.0 FM - PowerHitz"}
streams[16] = {"http://listen.technobase.fm/tunein-mp3-asx", "104.5 FM - TechnoBase FM"}
streams[17] = {"http://72.232.40.182:80/", "103.8 FM - Dubstep FM"}
streams[18] = {"http://80.94.69.106:6344", "102.4 FM - Clubbin' FM"}
streams[19] = {"http://80.94.69.106:6104", "101.6 FM - TranceWave"}
streams[20] = {"http://mms-live.online.no/p4_nrj_mp3_hq", "99.9 - NRJ HMO FM"}
streams[21] = {"http://94.23.91.55:8000/live2.m3u", "95.8 Unknown Station (( STREAM #2 ))"} --  Stream #2
streams[22] = {"http://94.23.91.55:8000/live.m3u", "94.5 Energy FM (( STREAM #1 ))"} --  Stream #1
--streams[12] = {"http://72.8.182.2:8000/listen.pls", "108.5 - UnitedGaming FM"}
local soundElement = nil
local soundElementsOutside = { }

function check(thePlayer)
	outputChatBox(getElementData(getLocalPlayer(), "streams"), 255, 0, 0)
end
addCommandHandler("checkme", check, false, false)

function setVolume(commandname, val)
	if tonumber(val) then
		val = tonumber(val)
		if (tonumber(val) >= 0 and tonumber(val) <= 100) then
			triggerServerEvent("car:radio:vol", getLocalPlayer(), tonumber(val))
			outputChatBox("Volume changed to: "..tonumber(val))
			return
		end
	end
	outputChatBox("Failed to set volume.")
end
addCommandHandler("setvol", setVolume)

local textShowing = false
function showStation()
	local screenwidth, screenheight = guiGetScreenSize ()
	local width = 300
	local height = 100
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/8 - (height/8)) 
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (theVehicle) then
		local streamID = getElementData(theVehicle, "vehicle:radio")
		local streamTitle
		if tonumber(streamID) ~= 0 then
			streamTitle = streams[tonumber(streamID)][2]
		else
			streamTitle = "Radio Off"
		end
		dxDrawText (streamTitle, 46, screenheight - 41, screenwidth, screenheight, tocolor ( 0, 0, 0, 255 ), 0.6, "bankgothic" )
		dxDrawText (streamTitle, 44, screenheight - 43, screenwidth, screenheight, tocolor ( 255, 255, 255, 255 ), 0.6, "bankgothic" )
	end
end

function removeTheEvent()
	removeEventHandler("onClientRender", getRootElement(), showStation)
	textShowing = false
end

function saveRadio(station)	
	local radios = 0
	if (station == 0) then
		return
	end

	if exports.unitedgamingscoreboard:isVisible() then
		cancelEvent()
		return
	end
	
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (vehicle) then
		if getVehicleOccupant(vehicle) == getLocalPlayer() or getVehicleOccupant(vehicle, 1) == getLocalPlayer() then
			if (station == 12) then	
				if (radio == 0) then
					radio = totalStreams + 1
				end
				
				if (streams[radio - 1]) then
					radio = radio - 1
				else
					radio = 0
				end
			elseif (station == 0) then
				if (streams[radio+1]) then
					radio = radio+1
				else
					radio = 0
				end
			end
			if not textShowing then
				addEventHandler("onClientRender", getRootElement(), showStation)
				if (isTimer(theTimer)) then
					resetTimer(theTimer)
				else
					theTimer = setTimer(removeTheEvent, 10000, 1)
				end
				textShowing = true
			else
				removeEventHandler("onClientRender", getRootElement(), showStation)
				addEventHandler("onClientRender", getRootElement(), showStation)
				if (isTimer(theTimer)) then
					resetTimer(theTimer)
				else
					theTimer = setTimer(removeTheEvent, 10000, 1)
				end
			end
			triggerServerEvent("car:radio:sync", getLocalPlayer(), radio)
		end
		cancelEvent()
	end
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)

addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

function stopStupidRadio()
	removeEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
	setRadioChannel(0)
	addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
end

addEventHandler ( "onClientElementDataChange", getRootElement(),
	function ( dataName )
		if getElementType ( source ) == "vehicle" and dataName == "vehicle:radio" then
			local enableStreams = getElementData(getLocalPlayer(), "streams")
			if enableStreams == 1 then
				local newStation =  getElementData(source, "vehicle:radio") or 0
				if (isElementStreamedIn (source)) then
					if newStation ~= 0 then
						if (soundElementsOutside[source]) then
							stopSound(soundElementsOutside[source])
						end
						local x, y, z = getElementPosition(source)
						newSoundElement = playSound3D(streams[newStation][1], x, y, z, true)
						soundElementsOutside[source] = newSoundElement
						updateLoudness(source)
						setElementDimension(newSoundElement, getElementDimension(source))
						setElementDimension(newSoundElement, getElementDimension(source))
					else
						if (soundElementsOutside[source]) then
							stopSound(soundElementsOutside[source])
							soundElementsOutside[source] = nil
						end
					end
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:windowstat" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:radio:volume" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		end
		
		--
	end 
)

addEventHandler( "onClientPreRender", getRootElement(),
	function()
		if soundElementsOutside ~= nil then
			for element, sound in pairs(soundElementsOutside) do
				if (isElement(sound) and isElement(element)) then
					local x, y, z = getElementPosition(element)
					setElementPosition(sound, x, y, z)
					setElementInterior(sound, getElementInterior(element))
					getElementDimension(sound, getElementDimension(element))
				end
			end
		end
	end	
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()	
		local vehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(vehicles) do
			if (isElementStreamedIn(theVehicle)) then
				spawnSound(theVehicle)
			end
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),
	function()	
		local vehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(vehicles) do
			if (isElementStreamedIn(theVehicle)) then
				spawnSound(theVehicle)
			end
		end
	end
)

function spawnSound(theVehicle)
	local newSoundElement = nil
    if getElementType( theVehicle ) == "vehicle" then
		local enableStreams = getElementData(getLocalPlayer(), "streams")
		if enableStreams == 1 then
			local radioStation = getElementData(theVehicle, "vehicle:radio") or 0
			if radioStation ~= 0 then
				if (soundElementsOutside[theVehicle]) then
					stopSound(soundElementsOutside[theVehicle])
				end
				local x, y, z = getElementPosition(theVehicle)
				newSoundElement = playSound3D(streams[radioStation][1], x, y, z, true)
				soundElementsOutside[theVehicle] = newSoundElement
				setElementDimension(newSoundElement, getElementDimension(theVehicle))
				setElementDimension(newSoundElement, getElementDimension(theVehicle))
				updateLoudness(theVehicle)
			end
		end
    end
end

function updateLoudness(theVehicle)
	if (soundElementsOutside[theVehicle]) then
		local windowState = getElementData(theVehicle, "vehicle:windowstat") or 1
		local carVolume = getElementData(theVehicle, "vehicle:radio:volume") or 60
		
		carVolume = carVolume / 100
		
		--  ped is inside
		if (getPedOccupiedVehicle( getLocalPlayer() ) == theVehicle) then
			setSoundMinDistance(soundElementsOutside[theVehicle], 8)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 70)
			setSoundVolume(soundElementsOutside[theVehicle], 1*carVolume)
		elseif (getVehicleType(theVehicle) == "Boat") then
			setSoundMinDistance(soundElementsOutside[theVehicle], 25)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 60)
			setSoundVolume(soundElementsOutside[theVehicle], 0.7*carVolume)
		elseif (windowState == 1) then -- window is open, ped outside
			setSoundMinDistance(soundElementsOutside[theVehicle], 25)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 60)
			setSoundVolume(soundElementsOutside[theVehicle], 0.8*carVolume)
		else -- outside with closed windows
			setSoundMinDistance(soundElementsOutside[theVehicle], 3)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
			setSoundVolume(soundElementsOutside[theVehicle], 0.3*carVolume)
		end
	end
end

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
		spawnSound(source)
    end
)

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
		local newSoundElement = nil
        if getElementType( source ) == "vehicle" then
			if (soundElementsOutside[source]) then
				stopSound(soundElementsOutside[source])
				soundElementsOutside[source] = nil
			end
        end
    end
)