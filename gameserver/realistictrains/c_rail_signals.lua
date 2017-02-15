local stationNames = { }
stationNames[1] = "Jefferson East"
stationNames[2] = "Unity"
stationNames[3] = "Market"
stationNames[4] = "San Fierro Central"
--stationNames[4] = "Las Venturas North"
--stationNames[5] = "Las Venturas East"

sent = false
function triggerApproachStation(stationID)
	if (not sent) then
		triggerServerEvent("apprStat", getLocalPlayer(), stationID)
		sent = true
		setTimer(resetCooldown, 1000, 1)
	end
end

function triggerAtStation(stationID)
	if (not sent) then
		triggerServerEvent("atStat", getLocalPlayer(), stationID)
		sent = true
		setTimer(resetCooldown, 1000, 1)
	end
end

function resetCooldown()
	sent = false
end

function inApproachStation(stationID)
	outputChatBox("We are now approaching " .. stationNames[stationID] .. ".")
end
addEvent("inApprStat", true)
addEventHandler("inApprStat", getRootElement(), inApproachStation)

function inAtStation(stationID)
	if (stationID + 1 < #stationNames) then
		outputChatBox("This is " .. stationNames[stationID] .. ". This train is for " .. stationNames[#stationNames] .. ". The next stop is " .. stationNames[stationID+1] .. ".")
	else
		outputChatBox("This is " .. stationNames[stationID] .. ". Where this train will terminate.")
	end
end
addEvent("inAtStat", true)
addEventHandler("inAtStat", getRootElement(), inAtStation)

local signalsRight = { }
local signalsLeft = { }

signalsRight[1] = { }
signalsRight[1]["x"] = -1950.6005859375
signalsRight[1]["y"] = -86.392578125
signalsRight[1]["z"] = 24.7109375
signalsRight[1]["cx"] = 1
signalsRight[1]["cy"] = 0
signalsRight[1]["cz"] = 0
signalsRight[1]["rot"] = 180.0
signalsRight[1]["state"] = 3
signalsRight[1]["colshape"] = nil
signalsRight[1]["aws"] = createColSphere(-1948.4892578125, -134.2236328125, 999924.7109375, 3)
signalsRight[1]["marker"] = nil
signalsRight[1]["marker2"] = nil


signalsRight[2] = { }
signalsRight[2]["x"] = -1948.96484375
signalsRight[2]["y"] = 187.0458984375
signalsRight[2]["z"] = 25.28125
signalsRight[2]["cx"] = 0
signalsRight[2]["cy"] = 0
signalsRight[2]["cz"] = -1
signalsRight[2]["rot"] = 180.0
signalsRight[2]["state"] = 0
signalsRight[2]["colshape"] = nil
signalsRight[2]["aws"] = createColSphere(-1948.412109375, 93.220703125, 24.718618392944, 3)
signalsRight[2]["marker"] = nil
signalsRight[2]["marker2"] = nil

signalsRight[3] = { }
signalsRight[3]["x"] = -1856.267578125
signalsRight[3]["y"] = 338.865234375
signalsRight[3]["z"] = 5.476355552673
signalsRight[3]["cx"] = 2
signalsRight[3]["cy"] = -2
signalsRight[3]["cz"] = 0
signalsRight[3]["rot"] = 180.0
signalsRight[3]["state"] = 3
signalsRight[3]["colshape"] = nil
signalsRight[3]["aws"] = createColSphere(-1919.443359375, 284.2353515625, 17.360954284668, 3)
signalsRight[3]["marker"] = nil
signalsRight[3]["marker2"] = nil


signalsRight[4] = { }
signalsRight[4]["x"] = -1506.2978515625
signalsRight[4]["y"] = 589.5625
signalsRight[4]["z"] = 33.578125
signalsRight[4]["cx"] = 2.5
signalsRight[4]["cy"] = -2
signalsRight[4]["cz"] = 0
signalsRight[4]["rot"] = 180.0
signalsRight[4]["state"] = 3
signalsRight[4]["colshape"] = nil
signalsRight[4]["aws"] = createColSphere(-1537.734375, 563.0009765625, 33.578125, 3)
signalsRight[4]["marker"] = nil
signalsRight[4]["marker2"] = nil

signalsRight[5] = { }
signalsRight[5]["x"] = -841.5439453125
signalsRight[5]["y"] = 1073.5068359375
signalsRight[5]["z"] = 33.678638458252
signalsRight[5]["cx"] = 3
signalsRight[5]["cy"] = -2
signalsRight[5]["cz"] = 0
signalsRight[5]["rot"] = 180.0
signalsRight[5]["state"] = 3
signalsRight[5]["colshape"] = nil
signalsRight[5]["aws"] = createColSphere(-899.5048828125, 1026.849609375, 33.578125, 3)
signalsRight[5]["marker"] = nil
signalsRight[5]["marker2"] = nil

signalsRight[6] = { }
signalsRight[6]["x"] = -423.318359375
signalsRight[6]["y"] = 1232.8935546875
signalsRight[6]["z"] = 29.545492172241
signalsRight[6]["cx"] = 3
signalsRight[6]["cy"] = -2
signalsRight[6]["cz"] = 0
signalsRight[6]["rot"] = 180.0
signalsRight[6]["state"] = 3
signalsRight[6]["colshape"] = nil
signalsRight[6]["aws"] = createColSphere(-474.470703125, 1219.0302734375, 28.544841766357, 3)
signalsRight[6]["marker"] = nil
signalsRight[6]["marker2"] = nil

signalsRight[7] = { }
signalsRight[7]["x"] = 154.2724609375
signalsRight[7]["y"] = 1272.9736328125
signalsRight[7]["z"] = 21.683788299561
signalsRight[7]["cx"] = -1.5
signalsRight[7]["cy"] = -3
signalsRight[7]["cz"] = 0
signalsRight[7]["rot"] = 180.0
signalsRight[7]["state"] = 3
signalsRight[7]["colshape"] = nil
signalsRight[7]["aws"] = createColSphere(98.947265625, 1286.1728515625, 19.790117263794, 3)
signalsRight[7]["marker"] = nil
signalsRight[7]["marker2"] = nil

signalsRight[8] = { }
signalsRight[8]["x"] = 671.55859375
signalsRight[8]["y"] = 1337.9658203125
signalsRight[8]["z"] = 10.781408309937
signalsRight[8]["cx"] = 3
signalsRight[8]["cy"] = -2
signalsRight[8]["cz"] = 0
signalsRight[8]["rot"] = 180.0
signalsRight[8]["state"] = 3
signalsRight[8]["colshape"] = nil
signalsRight[8]["aws"] = createColSphere(598.41796875, 1287.40234375, 10.794978141785, 3)
signalsRight[8]["marker"] = nil
signalsRight[8]["marker2"] = nil

signalsRight[9] = { }
signalsRight[9]["x"] = 2788.7900390625
signalsRight[9]["y"] = 1851.0322265625
signalsRight[9]["z"] = 9.724720001221
signalsRight[9]["cx"] = -3
signalsRight[9]["cy"] = 0
signalsRight[9]["cz"] = 0
signalsRight[9]["rot"] = 180.0
signalsRight[9]["state"] = 3
signalsRight[9]["colshape"] = nil
signalsRight[9]["aws"] = createColSphere(2785.0380859375, 1913.5546875, 4.2692031860352, 3)
signalsRight[9]["marker"] = nil
signalsRight[9]["marker2"] = nil

signalsRight[10] = { }
signalsRight[10]["x"] = 2788.00390625
signalsRight[10]["y"] = 1720.8271484375
signalsRight[10]["z"] = 10.234554290771
signalsRight[10]["cx"] = -3
signalsRight[10]["cy"] = 0
signalsRight[10]["cz"] = -1
signalsRight[10]["rot"] = 180.0
signalsRight[10]["state"] = 3
signalsRight[10]["colshape"] = nil
signalsRight[10]["aws"] = createColSphere(2785.1103515625, 1770.2392578125, 9.8203125, 3)
signalsRight[10]["marker"] = nil
signalsRight[10]["marker2"] = nil

signalsRight[11] = { }
signalsRight[11]["x"] = 2871.0263671875
signalsRight[11]["y"] = 1405.7744140625
signalsRight[11]["z"] = 9.8203125
signalsRight[11]["cx"] = -2
signalsRight[11]["cy"] = 0
signalsRight[11]["cz"] = 0
signalsRight[11]["rot"] = 180.0
signalsRight[11]["state"] = 3
signalsRight[11]["colshape"] = nil
signalsRight[11]["aws"] = createColSphere(2868.71875, 1463.1796875, 9.8203125, 3)
signalsRight[11]["marker"] = nil
signalsRight[11]["marker2"] = nil

signalsRight[12] = { }
signalsRight[12]["x"] = 2871.62890625
signalsRight[12]["y"] = 1243.7490234375
signalsRight[12]["z"] = 10.392618179321
signalsRight[12]["cx"] = -2.5
signalsRight[12]["cy"] = 0
signalsRight[12]["cz"] = -1
signalsRight[12]["rot"] = 180.0
signalsRight[12]["state"] = 3
signalsRight[12]["colshape"] = nil
signalsRight[12]["aws"] = createColSphere(2868.81640625, 1286.7548828125, 9.8203125, 3)
signalsRight[12]["marker"] = nil
signalsRight[12]["marker2"] = nil

signalsRight[13] = { }
signalsRight[13]["x"] = 2772.7060546875
signalsRight[13]["y"] = 289.740234375
signalsRight[13]["z"] = 7.4244861602783
signalsRight[13]["cx"] = -2.5
signalsRight[13]["cy"] = 0
signalsRight[13]["cz"] = 0
signalsRight[13]["rot"] = 180.0
signalsRight[13]["state"] = 3
signalsRight[13]["colshape"] = nil
signalsRight[13]["aws"] = createColSphere(2769.5458984375, 355.5595703125, 7.2897529602051, 3)
signalsRight[13]["marker"] = nil
signalsRight[13]["marker2"] = nil

signalsRight[14] = { }
signalsRight[14]["x"] = 2816.15234375
signalsRight[14]["y"] = -163.888671875
signalsRight[14]["z"] = 29.517730712891
signalsRight[14]["cx"] = -3
signalsRight[14]["cy"] = 0
signalsRight[14]["cz"] = 0
signalsRight[14]["rot"] = 180.0
signalsRight[14]["state"] = 3
signalsRight[14]["colshape"] = nil
signalsRight[14]["aws"] = createColSphere(2832.33203125, -53.8740234375, 31.505477905273, 3)
signalsRight[14]["marker"] = nil
signalsRight[14]["marker2"] = nil

signalsRight[15] = { }
signalsRight[15]["x"] = -67.5546875
signalsRight[15]["y"] = -1025.3701171875
signalsRight[15]["z"] = 17.18614768981
signalsRight[15]["cx"] = -3
signalsRight[15]["cy"] = 2
signalsRight[15]["cz"] = 0
signalsRight[15]["rot"] = 180.0
signalsRight[15]["state"] = 3
signalsRight[15]["colshape"] = nil
signalsRight[15]["aws"] = createColSphere(2438.3232421875, -276.8974609375, 17.40145111084, 3)
signalsRight[15]["marker"] = nil
signalsRight[15]["marker2"] = nil

signalsRight[16] = { }
signalsRight[16]["x"] = 2261.607421875
signalsRight[16]["y"] = -758.7333984375
signalsRight[16]["z"] = 35.534355163574
signalsRight[16]["cx"] = -3.5
signalsRight[16]["cy"] = -1
signalsRight[16]["cz"] = 0
signalsRight[16]["rot"] = 180.0
signalsRight[16]["state"] = 2
signalsRight[16]["colshape"] = nil
signalsRight[16]["aws"] = createColSphere(2080.1572265625, -608.0390625, 64.744461059574, 3)
signalsRight[16]["marker"] = nil
signalsRight[16]["marker2"] = nil

-- jefferson tunnel
signalsRight[17] = { }
signalsRight[17]["x"] = 2292.150390625
signalsRight[17]["y"] = -1135.662109375
signalsRight[17]["z"] = 25.7032852172854
signalsRight[17]["cx"] = -3.5
signalsRight[17]["cy"] = -1
signalsRight[17]["cz"] = 0
signalsRight[17]["rot"] = 180.0
signalsRight[17]["state"] = 1
signalsRight[17]["colshape"] = nil
signalsRight[17]["aws"] = createColSphere(2289.04296875, -991.646484375, 25.712432861328, 3)
signalsRight[17]["marker"] = nil
signalsRight[17]["marker2"] = nil

signalsRight[18] = { }
signalsRight[18]["x"] = 2291.5458984375
signalsRight[18]["y"] = -1232.115234375
signalsRight[18]["z"] = 23.007436752319
signalsRight[18]["cx"] = -2.5
signalsRight[18]["cy"] = -1
signalsRight[18]["cz"] = 0
signalsRight[18]["rot"] = 180.0
signalsRight[18]["state"] = 0
signalsRight[18]["colshape"] = nil
signalsRight[18]["aws"] = createColSphere(2289.0361328125, -1173.505859375, 25.224695205688, 3)
signalsRight[18]["marker"] = nil
signalsRight[18]["marker2"] = nil

signalsRight[19] = { }
signalsRight[19]["x"] = 2291.611328125
signalsRight[19]["y"] = -1349.78515625
signalsRight[19]["z"] = 23.34218788147
signalsRight[19]["cx"] = -2.5
signalsRight[19]["cy"] = -1
signalsRight[19]["cz"] = -1
signalsRight[19]["rot"] = 180.0
signalsRight[19]["state"] = 3
signalsRight[19]["colshape"] = nil
signalsRight[19]["aws"] = createColSphere(2288.763671875, -1312.5810546875, 23, 3)
signalsRight[19]["marker"] = nil
signalsRight[19]["marker2"] = nil

signalsRight[20] = { }
signalsRight[20]["x"] = 2221.236328125
signalsRight[20]["y"] = -1635.87890625
signalsRight[20]["z"] = 14.439674377441
signalsRight[20]["cx"] = -2.5
signalsRight[20]["cy"] = -0.5
signalsRight[20]["cz"] = -1
signalsRight[20]["rot"] = 180.0
signalsRight[20]["state"] = 3
signalsRight[20]["colshape"] = nil
signalsRight[20]["aws"] = createColSphere(2245.38671875, -1567.623046875, 17.588848114014, 3)
signalsRight[20]["marker"] = nil
signalsRight[20]["marker2"] = nil

signalsRight[21] = { }
signalsRight[21]["x"] = 2206.490234375
signalsRight[21]["y"] = -1719.3583984375
signalsRight[21]["z"] = 12.324449539185
signalsRight[21]["cx"] = -3
signalsRight[21]["cy"] = -0.5
signalsRight[21]["cz"] = -1
signalsRight[21]["rot"] = 180.0
signalsRight[21]["state"] = 3
signalsRight[21]["colshape"] = nil
signalsRight[21]["aws"] = createColSphere(2213.9296875, -1651.6552734375, 14.05, 3)
signalsRight[21]["marker"] = nil
signalsRight[21]["marker2"] = nil

signalsRight[22] = { }
signalsRight[22]["x"] = 1974.0927734375
signalsRight[22]["y"] = -1960.458984375
signalsRight[22]["z"] = 12.546875
signalsRight[22]["cx"] = 0
signalsRight[22]["cy"] = 2.5
signalsRight[22]["cz"] = -1
signalsRight[22]["rot"] = 180.0
signalsRight[22]["state"] = 3
signalsRight[22]["colshape"] = nil
signalsRight[22]["aws"] = createColSphere(2068.8359375, -1957.8427734375, 12.546875, 3)
signalsRight[22]["marker"] = nil
signalsRight[22]["marker2"] = nil

signalsRight[23] = { }
signalsRight[23]["x"] = 1684.3
signalsRight[23]["y"] = -1957.7919921875
signalsRight[23]["z"] = 16.5609375
signalsRight[23]["cx"] = 0
signalsRight[23]["cy"] = 0
signalsRight[23]["cz"] = -5
signalsRight[23]["rot"] = 180.0
signalsRight[23]["state"] = 3
signalsRight[23]["colshape"] = nil
signalsRight[23]["aws"] = createColSphere(1739.8330078125, -1957.9931640625, 12.539102554321, 3)
signalsRight[23]["marker"] = nil
signalsRight[23]["marker2"] = nil

-- market
signalsRight[24] = { }
signalsRight[24]["x"] = 772.599609375
signalsRight[24]["y"] = -1338.16796875
signalsRight[24]["z"] = -1.5272169113159
signalsRight[24]["cx"] = 0
signalsRight[24]["cy"] = 150
signalsRight[24]["cz"] = 0
signalsRight[24]["rot"] = 180.0
signalsRight[24]["state"] = 3
signalsRight[24]["colshape"] = nil
signalsRight[24]["aws"] = createColSphere(800.298828125, -1358.638671875, -0.6275658607483, 3)
signalsRight[24]["marker"] = nil
signalsRight[24]["marker2"] = nil

signalsRight[25] = { }
signalsRight[25]["x"] = -1287.3984375
signalsRight[25]["y"] = -1519.0869140625
signalsRight[25]["z"] = 24.120220184326
signalsRight[25]["cx"] = 0
signalsRight[25]["cy"] = 3
signalsRight[25]["cz"] = 0
signalsRight[25]["rot"] = 180.0
signalsRight[25]["state"] = 3
signalsRight[25]["colshape"] = nil
signalsRight[25]["aws"] = createColSphere(-1081.142578125, -1512.4013671875, 62.331741333008, 3)
signalsRight[25]["marker"] = nil
signalsRight[25]["marker2"] = nil

signalsRight[26] = { }
signalsRight[26]["x"] = -1971.4794921875
signalsRight[26]["y"] = -333.044921875
signalsRight[26]["z"] = 24.7109375
signalsRight[26]["cx"] = 3
signalsRight[26]["cy"] = 0
signalsRight[26]["cz"] = 0
signalsRight[26]["rot"] = 180.0
signalsRight[26]["state"] = 2
signalsRight[26]["colshape"] = nil
signalsRight[26]["aws"] = createColSphere(-1983.1337890625, -499.1279296875, 24.7109375, 3)
signalsRight[26]["marker"] = nil
signalsRight[26]["marker2"] = nil

function cleanupSecondMarker(id)
	if ( signalsRight[id]["marker2"] ~= nil ) then
		destroyElement(signalsRight[id]["marker2"])
		signalsRight[id]["marker2"] = nil
	end
end

function updateState(id, state)
	signalsRight[id]["state"] = state
	
	local x = signalsRight[id]["x"]
	local y = signalsRight[id]["y"]
	local z = signalsRight[id]["z"]
	local marker = signalsRight[id]["marker"]
	local marker2 = signalsRight[id]["marker2"]
	
	if (state==0) then -- red
		cleanupSecondMarker(id)
		setMarkerColor(marker, 255, 0, 0)
		setElementPosition(marker, x, y, z + 2.6)
	elseif (state==1) then -- single yellow
		cleanupSecondMarker(id)
		setMarkerColor(marker, 255, 255, 0)
		setElementPosition(marker, x, y, z + 3.8)
	elseif (state==2) then -- double yellow
		cleanupSecondMarker(id)
		setMarkerColor(marker, 255, 255, 0)
		setElementPosition(marker, x, y, z + 3.8)
		signalsRight[id]["marker2"] = createMarker(x, y, z+3.0, "corona", 0.5, 255, 255, 0, 200)
	elseif (state==3) then -- green
		cleanupSecondMarker(id)
		setMarkerColor(marker, 0, 255, 0)
		setElementPosition(marker, x, y, z + 3.4)
	end
end
	
function getIDFromColshape(colshape)
	for i = 1, #signalsRight do
		local pcolshape = signalsRight[i]["colshape"]
		--outputDebugString(tostring(colshape) .. " : " .. tostring(pcolshape))
		if (colshape == pcolshape) then
			return i
		end
	end
end

function getIDFromAWSColshape(colshape)
	for i = 1, #signalsRight do
		local pcolshape = signalsRight[i]["aws"]
		--outputDebugString(tostring(colshape) .. " : " .. tostring(pcolshape))
		if (colshape == pcolshape) then
			return i
		end
	end
end

function syncSignal(id, reverse)
	if (reverse) then
		triggerServerEvent("syncSSIn", getLocalPlayer(), id, true)
	else
		triggerServerEvent("syncSSIn", getLocalPlayer(), id)
	end
end

function syncSignalState(id, reverse)
	if not reverse then
		updateState(id, 0)
					
		if (id == 1) then -- fix for invalid index
			return
			--id = #signalsRight + 1
		end
		
		updateState(id-1, 1)
		
		if (id-2 > 0) then
			updateState(id-2, 2)
		end
		
		if (id-3 > 0) then
			updateState(id-3, 3)
		end
	else
		updateState(id, 3)
				
		if (id == 1) then -- fix for invalid index
			return
			--id = #signalsRight + 1
		end
		
		updateState(id-1, 0)
		
		if (id-2 > 0) then
			updateState(id-2, 1)
		end
		
		if (id-3 > 0) then
			updateState(id-3, 2)
		end
	end
end
addEvent("syncSS", true)
addEventHandler("syncSS", getRootElement(), syncSignalState)

local speed = 0.0
local timer = nil
function emergencyBrake(train)
	if ( speed <= 0 or speed -0.01 == 0.0 ) then
		setTrainSpeed(train, 0)
		killTimer(timer)
		return
	end
	
	setTrainSpeed(train, speed - 0.01)
	speed = getTrainSpeed(train)
end


function hitSignalColshape(train, dimension)
		if ( dimension ) and ( getVehicleType(train) == "Train" )  then
			local id = getIDFromColshape(source)
			if (getTrainSpeed(train) > 0) then
				-- check speed an signal
				local absspeed = math.abs(getTrainSpeed(train))
				if (absspeed > 5.9) then
					outputChatBox("You were speeding, emergency brake applied.")
					speed = absspeed
					timer = setTimer(emergencyBrake, 100, 0, train)
				end
				
				if (signalsRight[id]["state"] == 0) then -- passed red signal
					outputChatBox("You passed a red signal, emergency brake applied.")
					speed = absspeed
					timer = setTimer(emergencyBrake, 100, 0, train)
				end
			
				-- outputs
				if ( id == 22 ) then triggerApproachStation(2) end
				if ( id == 23 ) then triggerApproachStation(3) end
				if ( id == 1 ) then triggerApproachStation(4) end
			
				syncSignal(id)
				updateState(id, 0)
				
				if (id == 1) then -- fix for invalid index
					return
					--id = #signalsRight + 1
				end
				
				updateState(id-1, 1)
				
				if (id-2 > 0) then
					updateState(id-2, 2)
				end
				
				if (id-3 > 0) then
					updateState(id-3, 3)
				end
				
			elseif (getTrainSpeed(train) < 0) then
				syncSignal(id, true)
				updateState(id, 3)
				
				if (id == 1) then -- fix for invalid index
					return
					--id = #signalsRight + 1
				end
				
				updateState(id-1, 0)
				
				if (id-2 > 0) then
					updateState(id-2, 1)
				end
				
				if (id-3 > 0) then
					updateState(id-3, 2)
				end
			end
	end
end

local sound = nil
local myTrain = nil

function acknowledgeAWS(train)
	stopSound(sound)
	killTimer(timer)
	outputChatBox("AWS Reset.", 0, 255, 0)
end

function activateAWS(train)
	outputChatBox("You didn't respond to the AWS, emergency brake applied.", 255, 0, 0)
	speed = math.abs(getTrainSpeed(train))
	timer = setTimer(emergencyBrake, 100, 0, train)
	stopSound(sound)
end

function hitAWSColshape(train, dimension)
	if ( dimension ) and ( getVehicleType(train) == "Train" )  then
		local id = getIDFromAWSColshape(source)
		
		if (getTrainSpeed(train) > 0) then -- going forward
			-- get signal infront

			state = signalsRight[id]["state"]
			
			if (timer == nil) then
				-- process 'at station' announcements
				outputDebugString("APPROACH: " .. tostring(id))
				if ( id == 2 ) then triggerAtStation(4) end
				if ( id == 19 ) then triggerAtStation(1) end
				if ( id == 23 ) then triggerAtStation(2) end
				if ( id == 24 ) then triggerAtStation(3) end
				if ( id == 2 ) then triggerAtStation(4) end
			end
			
			if (state == 0 or state == 1) or (getTrainSpeed(train) > 1) then -- red or amber or fast speed
				sound = playSound("awswarn.wav", true)
				bindKey("n", "down", acknowledgeAWS, train)
				timer = setTimer(activateAWS, 2000, 1, train)
			else
				sound = playSound("awsclear.wav", false)
			end
			
			
		end
	end
end


function createSignals()
	for i = 1, #signalsRight do
		local x = signalsRight[i]["x"]
		local y = signalsRight[i]["y"]
		local z = signalsRight[i]["z"]
		local cx = signalsRight[i]["cx"]
		local cy = signalsRight[i]["cy"]
		local cz = signalsRight[i]["cz"]
		local rot = signalsRight[i]["rot"]
		local state = signalsRight[i]["state"]
	
		signalsRight[i]["colshape"] = createColSphere(x+cx, y+cy, z+cz, 4)
		
		addEventHandler("onClientColShapeHit", signalsRight[i]["colshape"], hitSignalColshape)
		
		local aws = signalsRight[i]["aws"]
		addEventHandler("onClientColShapeHit", signalsRight[i]["aws"], hitAWSColshape)
		local ax, ay, az = getElementPosition(aws)
		--createMarker(x+cx, y+cy, z+cz, "cylinder", 3)
		--createMarker(ax, ay, az, "cylinder", 3, 0, 255, 0)
		createObject(1285, ax, ay, az - 0.4,180, 180, 102)
		
		-- poles
		if ( i ~= 23 ) then
			createObject(1214, x, y, z)
			createObject(1214, x, y, z+1.15)
		end
		
		-- signal head
		createObject(1287, x, y, z+2.9, 0, 0, 180-rot)
		createObject(1287, x, y, z+3.4, 0, 0, 180-rot)

		-- lights
		
		--if (state==0) then -- red
			--signalsRight[i]["marker"] = createMarker(x, y, z+2.6, "corona", 0.5, 255, 0, 0, 255) -- red
		--[[elseif (state==1) then -- single yellow
			
		elseif (state==2) then -- double yellow
			createMarker(x, y, z+3.8, "corona", 0.5, 255, 255, 0, 255) -- yellow 1
			createMarker(x, y, z+3.0, "corona", 0.5, 255, 255, 0, 255) -- yellow 2
		elseif (state==3) then -- double yellow]]--
		
		if (state == 0) then
			signalsRight[i]["marker"] = createMarker(x, y, z+2.6, "corona", 0.5, 255, 0, 0, 255) -- red
		elseif (state == 1) then
			signalsRight[i]["marker"] = createMarker(x, y, z+3.8, "corona", 0.5, 255, 255, 0, 255) -- yellow 1
		elseif (state == 2) then
			signalsRight[i]["marker"] = createMarker(x, y, z+3.8, "corona", 0.5, 255, 255, 0, 255) -- yellow 1
			signalsRight[i]["marker2"] = createMarker(x, y, z+3.0, "corona", 0.5, 255, 255, 0, 255) -- yellow 2
		else
			signalsRight[i]["marker"] = createMarker(x, y, z+3.4, "corona", 0.5, 0, 255, 0, 200) -- green
		end
		--end]]--
		
	end
	triggerEvent("onClientPlayerVehicleEnter", getLocalPlayer(), getPedOccupiedVehicle(getLocalPlayer()))
end
addEventHandler("onClientResourceStart", getRootElement(), createSignals)



function handleVelocity()
	local player = getLocalPlayer()
	local train = getPedOccupiedVehicle(player)
	
	if (train) then
		local accel2D = (100 - guiScrollBarGetScrollPosition(scrollThrottle)) / 2000
		local brake2D = (100 - guiScrollBarGetScrollPosition(scrollBrake)) / 2000
		
		
		guiSetText(lThrottle, "Throttle: " .. tostring((100 - guiScrollBarGetScrollPosition(scrollThrottle))) .. "%")
		guiSetText(lBrake, "Brake: " .. tostring((100 - guiScrollBarGetScrollPosition(scrollBrake))) .. "%")
		
		local accel = accel2D / 3
		local brake = brake2D / 3
		
		local velocity = getTrainSpeed(train)
		
		if (velocity + (accel - brake) > 0) then
			setTrainSpeed(train, velocity + (accel - brake))
		end
	else
		killTimer(velocityTimer)
	end
end

velocityTimer, wTrain, scrollThrottle, scrollBrake, lThrottle, lBrake = nil
-------------- DRIVING
function enterTrain(train)
	if ( getVehicleType(train)=="Train") then
		velocityTimer = setTimer(handleVelocity, 100, 0)
		local screenwidth, screenheight = guiGetScreenSize ()
	
		local width = 200
		local height = 300
		local x = (screenwidth - width)/18
		local y = (screenheight - height)/2
	
		wTrain = guiCreateWindow(x, y, width, height, "Train Cab", false)
		
		scrollThrottle = guiCreateScrollBar(0.2, 0.1, 0.1, 0.5, false, true, wTrain)
		scrollBrake = guiCreateScrollBar(0.7, 0.1, 0.1, 0.5, false, true, wTrain)
		
		lThrottle = guiCreateLabel(0.1, 0.6, 0.5, 0.1, "Throttle: 0%", true, wTrain)
		lBrake = guiCreateLabel(0.6, 0.6, 0.5, 0.1, "Brake: 0%", true, wTrain)

		
		guiScrollBarSetScrollPosition(scrollThrottle, 100)
		guiScrollBarSetScrollPosition(scrollBrake, 100)
	end
end
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), enterTrain)

function exitTrain(train)
	if ( getVehicleType(train)=="Train") then
		destroyElement(scrollThrottle)
		scrollThrottle = nil
		
		destroyElement(scrollBrake)
		scrollBrake = nil
		
		destroyElement(lThrottle)
		lThrottle = nil
		
		destroyElement(lBrake)
		lBrake = nil
		
		destroyElement(wTrain)
		wTrain = nil
		
		killTimer(velocityTimer)
	end
end
addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), exitTrain)