local localPlayer = getLocalPlayer()
local show = true
local badges = {}
masks = {}

function startRes()
	for key, value in ipairs(getElementsByType("player")) do
		setPlayerNametagShowing(value, false)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startRes)

function initStuff(res)
	if (res == getThisResource() and getResourceFromName("item-system")) or getResourceName(res) == "item-system" then
		for key, value in pairs(exports['item-system']:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5] }
		end
		
		masks = exports['item-system']:getMasks()
	end
end
addEventHandler("onClientResourceStart", getRootElement(), initStuff)

local playerhp = { }
local lasthp = { }

local playerarmor = { }
local lastarmor = { }

function playerQuit()
	if (getElementType(source)=="player") then
		playerhp[source] = nil
		lasthp[source] = nil
		playerarmor[source] = nil
		lastarmor[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), playerQuit)
addEventHandler("onClientPlayerQuit", getRootElement(), playerQuit)


function setNametagOnJoin()
	setPlayerNametagShowing(source, false)
end
addEventHandler("onClientPlayerJoin", getRootElement(), setNametagOnJoin)

function streamIn()
	if (getElementType(source)=="player") then
		playerhp[source] = getElementHealth(source)
		lasthp[source] = playerhp[source]
		
		playerarmor[source] = getPedArmor(source)
		lastarmor[source] = playerarmor[source]
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function isPlayerMoving(player)
	return (not isPedInVehicle(player) and (getPedControlState(player, "forwards") or getPedControlState(player, "backwards") or getPedControlState(player, "left") or getPedControlState(player, "right") or getPedControlState(player, "accelerate") or getPedControlState(player, "brake_reverse") or getPedControlState(player, "enter_exit") or getPedControlState(player, "enter_passenger")))
end

local lastrot = nil

function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and getPedWeapon(localPlayer) == 34
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

function getBadgeColor(player)
	for k, v in pairs(badges) do
		if getElementData(player, k) then
			return unpack(badges[k])
		end
	end
end

function renderNametags()
	if (show) then
		local players = { }
		local distances = { }
		--local lx, ly, lz = getCameraMatrix()
		local lx, ly, lz = getElementPosition(localPlayer)
		local dim = getElementDimension(localPlayer)
		
		for key, player in ipairs(getElementsByType("player")) do
			if (isElement(player)) and getElementDimension(player) == dim then
				local logged = getElementData(player, "account:loggedin")
				
				if (logged == true) then
					
					local rx, ry, rz = getElementPosition(player)
					local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
					local limitdistance = 20
					local reconx = getElementData(localPlayer, "reconx") and exports.global:isPlayerAdmin(localPlayer)
					
					if ((player~=localPlayer) and isElementOnScreen(player)) then
						if (aimsAt(player) or distance<limitdistance or reconx) then
							if not getElementData(player, "reconx") and not getElementData(player, "freecam:state") and not (getElementAlpha(player) < 255) then
								--local lx, ly, lz = getPedBonePosition(localPlayer, 7)
								local lx, ly, lz = getCameraMatrix()
								local vehicle = getPedOccupiedVehicle(player) or nil
								local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)

								if not (collision) or aimsSniper() or (reconx) then
									local x, y, z = getElementPosition(player)
									
									if not (isPedDucked(player)) then
										z = z + 1
									else
										z = z + 0.5
									end
									
									local sx, sy = getScreenFromWorldPosition(x, y, z+0.30, 100, false)
									local oldsy = nil
									local badge = false
									local tinted = false
									-- HP
									
									local name = getPlayerName(player):gsub("_", " ")
									if (sx) and (sy) then
										
										
										if (1>0) then
											distance = distance / 5
											
											if (reconx or aimsAt(player)) then distance = 1
											elseif (distance<1) then distance = 1
											elseif (distance>2) then distance = 2 end
											
											local offset = 90 --/ distance
											
											--DRAW BG
											--dxDrawRectangle(sx-offset-5, sy, 95 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
											oldsy = sy

											local picxsize = 64 / 1 --/distance
											local picysize = 64 / 1 --/distance
											local xpos = 0
											
											local seatbelt = getElementData(player,"seatbelt")
											if seatbelt == true  then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/seatbelt.png")
												xpos = xpos+32
											end
											
											local isGM = getElementData(player,"account:gmduty")
											if isGM  then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/gm.png")
												xpos = xpos+32
											end
											
											local smoking = getElementData(player,"smoking")
											if smoking == true then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/cigarette.png")
												xpos = xpos+32
											end
											
											local masked = false
											for key, value in pairs(masks) do
												if getElementData(player, value[1]) then
													dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/" .. value[1] .. ".png")
													xpos = xpos+32
													masked = true
												end
											end
											
											local vehicle = getPedOccupiedVehicle( player )
											local windowsDown = false
											if vehicle then
												if (getElementData(vehicle, "vehicle:windowstat") == 1) then
													windowsDown = true
												end
												
												if not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
													local seat0 = getVehicleOccupant(vehicle, 0)
													local seat1 = getVehicleOccupant(vehicle, 1)
													local seat2 = getVehicleOccupant(vehicle, 2)
													local seat3 = getVehicleOccupant(vehicle, 3)
													if (seat0) or (seat1) then
														if not (distance < 1.4) then
															name = "Unknown Person (Tint)"
															tinted = true
														end
													elseif seat2 or seat3 then
														name = "Unknown Person (Tint)"
														tinted = true
													 end
												end
											end
											
											if not tinted then
												if masked then
													name = "Unknown Person"
												end
												for k, v in pairs(badges) do
													local title = getElementData(player, k)
													if title then
														if v[4] == 122 or v[4] == 123 or v[4] == 124 or v[4] == 125 or v[4] == 135 or v[4] == 136 then
														dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/bandana.png")
														xpos = xpos+32
														name = "Unknown Person (Bandana)"
														badge = true
														elseif v[2] == 112 or v[2] == 64 then
														dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/police.png")
														expos = xpos+32
														name = title .. "\n" .. name
														badge = true
														else
														dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/badge" .. tostring(v[5] or 1) .. ".png")
														xpos = xpos+32
														name = title .. "\n" .. name
														badge = true
														break
													end
												end
											end
											end
											
											local health = getElementHealth( player )
											if (health <= 30) then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/lowhp.png")
												xpos = xpos+32
											end
											
											local armour = getPedArmor( player )
											if armour > 50 then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/armour.png")
												xpos = xpos+32
											end
											
											if windowsDown then
												dxDrawImage(sx-offset+xpos,oldsy+45,picxsize,picysize,"images/hud/window.png")
												xpos = xpos+32
											end
										end
									end

									if (sx) and (sy) then
										if (distance<=2) then
											sy = math.ceil( sy + ( 2 - distance ) * 20 )
										end
										sy = sy + 10
										
										
										if (sx) and (sy) then

											
											if (6>5) then
												local offset = 45 / distance
											end
										end
																			
										if (distance<=2) then
											sy = math.ceil( sy - ( 2 - distance ) * 40 )
										end
										sy = sy - 20
											
										if (sx) and (sy) and oldsy then
											if (distance < 1) then distance = 1 end
											if (distance > 2) then distance = 2 end
											local offset = 75 / distance
											local scale = 1 --/ distance
											local font = "default-bold"
											local r, g, b = getBadgeColor(player)
											if not r or tinted then
												r, g, b = getPlayerNametagColor(player)
											end
											local id = getElementData(player, "playerid")
											
											if badge then
												sy = sy - dxGetFontHeight(scale, font) * scale + 2.5
											end
											name = name .. " (" .. tostring(id) .. ")"
											
											dxDrawText(name, sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+120 / distance, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
											dxDrawText(name, sx-offset, sy, (sx-offset)+130 / distance, sy+120 / distance, tocolor(r, g, b, 255), scale, font, "center", "center", false, false, false, false, false)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		for key, player in ipairs(getElementsByType("ped")) do
			if (isElement(player) and  (player~=localPlayer) and (isElementOnScreen(player)))then
				
				if (getElementData(player,"talk") == 1) then
					local lx, ly, lz = getElementPosition(localPlayer)
					local rx, ry, rz = getElementPosition(player)
					local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
					local limitdistance = 20
					local reconx = getElementData(localPlayer, "reconx")
					
					-- smoothing
					playerhp[player] = getElementHealth(player)
					
					if (lasthp[player] == nil) then
						lasthp[player] = playerhp[player]
					end
					
					playerarmor[player] = getPedArmor(player)
					
					if (lastarmor[player] == nil) then
						lastarmor[player] = playerarmor[player]
					end
				
					if (aimsAt(player) or distance<limitdistance or reconx) then
						if not getElementData(player, "reconx") and not getElementData(player, "freecam:state") then
							local lx, ly, lz = getCameraMatrix()
							local vehicle = getPedOccupiedVehicle(player) or nil
							local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
								if not (collision) or aimsSniper() or (reconx) then
								local x, y, z = getElementPosition(player)
								
								if not (isPedDucked(player)) then
									z = z + 1
								else
									z = z + 0.5
								end
								
								local sx, sy = getScreenFromWorldPosition(x, y, z+0.1, 100, false)
								local oldsy = nil
								-- HP
								if (sx) and (sy) then
																		
									if (1>0) then
										distance = distance / 5
										
										if (reconx or aimsAt(player)) then distance = 1
										elseif (distance<1) then distance = 1
										elseif (distance>2) then distance = 2 end
										
										local offset = 45 / distance

										oldsy = sy 
									end
								end
								

								if (sx) and (sy) then
									if (distance<=2) then
										sy = math.ceil( sy + ( 2 - distance ) * 20 )
									end
									sy = sy + 10
									
									
									if (sx) and (sy) then
										
										if (4>5) then
											local offset = 45 / distance
											
											-- DRAW BG
											dxDrawRectangle(sx-offset-5, sy, 95 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
											
											-- DRAW HEALTH
											local width = 85
											local armorsize = (width / 100) * armor
											local barsize = (width / 100) * (100-armor)
											
											
											if (distance<1.2) then
												dxDrawRectangle(sx-offset, sy+5, armorsize/distance, 10 / distance, tocolor(197, 197, 197, 130), false)
												dxDrawRectangle((sx-offset)+(armorsize/distance), sy+5, barsize/distance, 10 / distance, tocolor(162, 162, 162, 100), false)
											else
												dxDrawRectangle(sx-offset, sy+5, armorsize/distance-5, 10 / distance-3, tocolor(197, 197, 197, 130), false)
												dxDrawRectangle((sx-offset)+(armorsize/distance-5), sy+5, barsize/distance-2, 10 / distance-3, tocolor(162, 162, 162, 100), false)
											end
										end
									end
									
									if (distance<=2) then
										sy = math.ceil( sy - ( 2 - distance ) * 40 )
									end
									sy = sy - 20
										
									if (sx) and (sy) then
										if (distance < 1) then distance = 1 end
										if (distance > 2) then distance = 2 end
										local offset = 75 / distance
										local scale = 1 / distance
										local font = "default-bold"
										local r = 255
										local g = 255
										local b = 255--getPlayerNametagColor(player)
										dxDrawText(getElementData(player,"name"), sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
										dxDrawText(getElementData(player,"name"), sx-offset, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(r, g, b, 220), scale, font, "center", "center", false, false, false)
										local offset = 65 / distance
										--[[-- DRAW ids
										local offset = 65 / distance
										local id = getElementData(player, "npcid") or 999
										
										if (oldsy) and (id) then
											if (id<100 and id>9) then -- 2 digits
												dxDrawRectangle(sx-offset-15, oldsy, 30 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
												dxDrawText(tostring(id), sx-offset-22.5, oldsy, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
											elseif (id<=9) then -- 1 digit
												dxDrawRectangle(sx-offset-5, oldsy, 20 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
												dxDrawText(tostring(id), sx-offset-12.5, oldsy, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
											elseif (id>=100) then -- 3 digits
												if (id == 999) then
													id = "NPC"
												end]]
												dxDrawRectangle(sx-offset-30, oldsy-28, 32 / distance, 16 / distance, tocolor(0, 0, 0, 100), false)
												dxDrawText("NPC", sx-offset-50, oldsy-30, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
											--end
										--end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), renderNametags)

										-- DRAW BG
											--[[sxs, sys = getScreenFromWorldPosition(x, y, z, 100, false)
											dxDrawRectangle(sxs+15, sys+67, 95, 20, tocolor(0, 0, 0, 100), false)
											local health = getElementHealth(player)
											-- DRAW HEALTH
											local width = 85
											local healthsize = (width / 100) * health
											local barsize = (width / 100) * (100-health)
											local rh, gh, bh = 0, 0, 0
											if tonumber(health) <= 30 then
												rh, gh, bh = 255, 0, 0
											else
												rh, gh, bh = 0, 255, 0
											end
											dxDrawRectangle(sxs+20, sys+72, healthsize, 10, tocolor(rh, gh, bh, 255), false)]]

function applyClientConfigSettings()
	local nametagsEnabled = tonumber( exports['account-system']:loadSavedData("shownametags", "1") )
	if (nametagsEnabled == 1) then
		show = true
	else
		show = false
	end
end
addEventHandler("accounts:options:settings:updated", getRootElement(), applyClientConfigSettings)