--
-- "woundedTable" = { 9mmhits, 556hits, 762hits, sniperhits, 12ghits, countryhits, mischits }

woundedPlayers = { }
injuredString = { }
oldString = { }

function loadPlayers()
	for index, player in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "player") ) do
		if ( getElementData( player, "wounded" ) == 1 ) then
			woundedPlayers[index] = player
			injuredString[index] = ""
		else
			if woundedPlayers[index] == player then
				woundedPlayers[index] = nil
				injuredString[index] = ""
				oldString[index] = false
			end
		end
	end
	showText()
end
addEventHandler("onClientRender", getRootElement(), loadPlayers)

function isMore( element, start )
	local playerInjuries = getElementData( element, "woundedTable" )
	for i = start,(#stringNames - 1) do
		if playerInjuries[i] then
			if (playerInjuries[i]>0) then
				return " // "
			end
		end
	end
	return ""
end

function showText()
	for i = 1, #woundedPlayers, 1 do
		local x,y,z = getElementPosition(woundedPlayers[i])				
        local cx,cy,cz = getCameraMatrix()
		if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 21 then
			if getElementData(woundedPlayers[i], "wounded") then
				local playerInjuries = getElementData( woundedPlayers[i], "woundedTable" )
				for injurySlot = 1, #stringNames do
					if playerInjuries then
						if ( playerInjuries[injurySlot]>0 ) then
							oldString[i] = injuredString[i]
							injuredString[i] = oldString[i] .. stringNames[injurySlot] .. " hits: " .. playerInjuries[injurySlot] .. isMore( woundedPlayers[i], injurySlot + 1 )
						end
					end
				end
				local px,py = getScreenFromWorldPosition(x,y,z,0.05)
				if ( injuredString[i] == "" ) then
					injuredString[i] = "No damage information"
				end
				dxDrawText("(( " .. injuredString[i] .. ". ))", px, py, px, py, tocolor(220, 20, 0, 255), 1.2, "arial", "center", "center", false, true)				
			end
		end
	end
	
	if injuredString[i] then
		injuredString[i] = { }
	end
end
addEventHandler("onClientRender", getLocalPlayer(), showText)