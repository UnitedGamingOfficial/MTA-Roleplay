gInteriorName, gOwnerName, gBuyMessage, gBizMessage = nil

timer = nil

intNameFont = guiCreateFont( "intNameFont.ttf", 30 ) --AngryBird
BizNoteFont = guiCreateFont( "BizNote.ttf", 21 )

-- Message on enter
function showIntName(name, ownerName, inttype, cost, ID, bizMsg)
	bizMessage = bizMsg
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil 
		end
		
		destroyElement(gInteriorName)
		gInteriorName = nil
		
		if isElement(gOwnerName) then
			destroyElement(gOwnerName)
			gOwnerName = nil
		end
			
		if (gBuyMessage) then
			destroyElement(gBuyMessage)
			gBuyMessage = nil
		end
		
		if (gBizMessage) then
			destroyElement(gBizMessage)
			gBizMessage = nil
		end
		
	end
	if name == "None" then
		return
	elseif name then
		if (inttype==3) then -- Interior name and Owner for rented
			gInteriorName = guiCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName,intNameFont)
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			--guiSetAlpha(gInteriorName, 0.0)
			
			if (exports.global:isPlayerAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "adminduty") == 1) or exports.global:hasItem(getLocalPlayer(), 4, ID) then
				gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Rented by: " .. tostring(ownerName), true)
				guiSetFont(gOwnerName, "default")
				guiLabelSetHorizontalAlign(gOwnerName, "center", true)
				--guiSetAlpha(gOwnerName, 0.0)
			end
		
		else -- Interior name and Owner for the rest
			--outputDebugString((name or "nil").." - "..(tostring(bizMsg) or "nil"))
			if bizMessage then 
				gInteriorName = guiCreateLabel(0.0, 0.80, 1.0, 0.3, tostring(name), true)
				gBizMessage = guiCreateLabel(0.0, 0.864, 1.0, 0.3, tostring(bizMessage), true)
				guiLabelSetHorizontalAlign(gBizMessage, "center", true)
				--guiSetAlpha(gBizMessage, 0.0)
				guiSetFont(gBizMessage, BizNoteFont)
			else
				gInteriorName = guiCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			end
			guiSetFont(gInteriorName, intNameFont)
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			--guiSetAlpha(gInteriorName, 0.0)
			if (exports.global:isPlayerAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "adminduty") == 1) or exports.global:hasItem(getLocalPlayer(), 4, ID) or exports.global:hasItem(getLocalPlayer(), 5, ID) then
				gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Owner: " .. tostring(ownerName), true)
				guiSetFont(gOwnerName, "default")
				guiLabelSetHorizontalAlign(gOwnerName, "center", true)
				--guiSetAlpha(gOwnerName, 0.0)
			end
		end
		if (ownerName=="None") and (inttype==3) then -- Unowned type 3 (rentable)
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to rent for $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			--guiSetAlpha(gBuyMessage, 0.0)
		elseif (ownerName=="None") and (inttype<2) then -- Unowned any other type
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to buy for $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			--guiSetAlpha(gBuyMessage, 0.0)
		else
			local msg = "Press F to enter."
			--[[if fee and fee > 0 then
				msg = "Entrance Fee: $" .. exports.global:formatMoney(fee)
				
				if exports.global:hasMoney( getLocalPlayer(), fee ) then
					msg = msg .. "\nPress F to enter."
				end
			end]]
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			--guiSetAlpha(gBuyMessage, 0.0)
		end
		
		setTimer(function()
			if gInteriorName then
				destroyElement(gInteriorName)
				gInteriorName = nil
			end
			
			if isElement(gOwnerName) then
				destroyElement(gOwnerName)
				gOwnerName = nil
			end
			
			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end
			
			if (gBizMessage) then
				destroyElement(gBizMessage)
				gBizMessage = nil
			end
		end, 3000, 1)
		
		--timer = setTimer(fadeMessage, 50, 20, true)
	end
end

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gInteriorName)
	
	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		guiSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			guiSetAlpha(gOwnerName, newalpha)
		end
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if gBizMessage then
			guiSetAlpha(gBizMessage, newalpha)
		end
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 5000, 1)
		end
	elseif (alpha) then
		local newalpha = alpha - 0.05
		guiSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			guiSetAlpha(gOwnerName, newalpha)
		end
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if (gBizMessage) then
			guiSetAlpha(gBizMessage, newalpha)
		end
		
		if(newalpha<=0.0) then
			destroyElement(gInteriorName)
			gInteriorName = nil
			
			if isElement(gOwnerName) then
				destroyElement(gOwnerName)
				gOwnerName = nil
			end
			
			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end
			
			if (gBizMessage) then
				destroyElement(gBizMessage)
				gBizMessage = nil
			end
			
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", getRootElement(), showIntName)

-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)
		
		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	-- spawn the new ones
	for key, value in ipairs(interiors) do
		createBlipAtXY(interiors[key][1], interiors[key][2], interiors[key][3])
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", getRootElement(), createBlipsFromTable)

function createBlipAtXY(inttype, x, y)
	if inttype == 3 then inttype = 0 end
	createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", getRootElement(), createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= 'number' then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)
		
		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", getRootElement(), removeBlipAtXY)

------
local wBizNote, wRightClick, ax, ay = nil
local house = nil
local houseID = nil
local sx, sy = guiGetScreenSize( )
function showHouseMenu( )
	guiSetInputEnabled(true)
	showCursor(true)
	ax = math.max( math.min( sx - 160, ax - 75 ), 10 )
	ay = math.max( math.min( sx - 210, ay - 100 ), 10 )
	wRightClick = guiCreateWindow(ax, ay, 150, 200, (getElementData(house, "name") or ("Interior ID #"..tostring( houseID ))), false)
	guiWindowSetSizable(wRightClick, false)
	
	bLock = guiCreateButton(0.05, 0.13, 0.9, 0.1, "Lock/Unlock", true, wRightClick)
	addEventHandler("onClientGUIClick", bLock, lockUnlockHouse, false)
	
	bKnock = guiCreateButton(0.05, 0.27, 0.9, 0.1, "Knock on Door", true, wRightClick)
	addEventHandler("onClientGUIClick", bKnock, knockHouse, false)
	
	if hasKey(houseID) then
		bBizNote = guiCreateButton(0.05, 0.41, 0.9, 0.1, "Edit Greeting Msg", true, wRightClick)
		addEventHandler("onClientGUIClick", bBizNote, function()
			local width, height = 506, 103
			local sx, sy = guiGetScreenSize()
			local posX = (sx/2)-(width/2)
			local posY = (sy/2)-(height/2)
			wBizNote = guiCreateWindow(posX,posY,width,height,"Edit Business Greeting Message - "..(getElementData(house, "name") or ("Interior ID #"..tostring( houseID ))),false)
			local eBizNote = guiCreateEdit(9,22,488,40,"",false,wBizNote)
			local bRemove = guiCreateButton(9,68,163,28,"Remove",false,wBizNote)
			local bSave = guiCreateButton(172,68,163,28,"Save",false,wBizNote)
			local bCancel = guiCreateButton(335,68,163,28,"Cancel",false,wBizNote)
			addEventHandler("onClientGUIClick", bRemove, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bSave, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID, guiGetText(eBizNote)) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bCancel, function()
				if wBizNote then
					destroyElement(wBizNote)
					wBizNote = nil
				end
			end, false)
			
		end, false)
		
		bCloseMenu = guiCreateButton(0.05, 0.55, 0.9, 0.1, "Close Menu", true, wRightClick)
	else
		bCloseMenu = guiCreateButton(0.05, 0.41, 0.9, 0.1, "Close Menu", true, wRightClick)
	end
	
	addEventHandler("onClientGUIClick", bCloseMenu, hideHouseMenu, false)
end

local lastKnocked = 0
function knockHouse()
	local tick = getTickCount( )
	if tick - lastKnocked > 5000 then
		triggerServerEvent("onKnocking", getLocalPlayer(), house)
		hideHouseMenu()
		lastKnocked = tick
	else
		outputChatBox("Please wait a bit before knocking again.", 255, 0, 0)
	end
end

function lockUnlockHouse( )
	local tick = getTickCount( )
	if tick - lastKnocked > 2000 then
		local px, py, pz = getElementPosition(getLocalPlayer())
		local interiorEntrance = getElementData(house, "entrance")
		local interiorExit = getElementData(house, "exit")
		local x, y, z = getElementPosition(house)
		if getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
		elseif getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
		end
		hideHouseMenu()
	end
end

function hideHouseMenu( )
	if wRightClick then
		destroyElement( wRightClick )
		wRightClick = nil
		showCursor( false )
	end
	if wBizNote then
		destroyElement(wBizNote)
		wBizNote = nil
	end
	house = nil
	houseID = nil
	guiSetInputEnabled(false)
	showCursor(false)
end

-- local function hasKey( key )
	-- return exports.global:hasItem(getLocalPlayer(), 4, key) or exports.global:hasItem(getLocalPlayer(), 5,key)
-- end

function hasKey( key )
	if exports.global:hasItem(getLocalPlayer(), 4, key) or exports.global:hasItem(getLocalPlayer(), 5,key) then
		return true, false
	else
		if getElementData(getLocalPlayer(), "adminduty") == 1 then
			return true, true
		else
			return false, false
		end
	end
	return false, false
end

function clickHouse(button, state, absX, absY, wx, wy, wz, e)
	if (button == "right") and (state=="down") and not e then
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		
		local element, id = nil, nil
		local px, py, pz = getElementPosition(getLocalPlayer())
		local x, y, z = nil
		local interiorres = getResourceRootElement(getResourceFromName("interior-system"))
		local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))

		for key, value in ipairs(getElementsByType("pickup")) do
			if isElementStreamedIn(value) then
				x, y, z = getElementPosition(value)
				local minx, miny, minz, maxx, maxy, maxz
				local offset = 4
				
				minx = x - offset
				miny = y - offset
				minz = z - offset
				
				maxx = x + offset
				maxy = y + offset
				maxz = z + offset
				
				if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
					local dbid = getElementData(getElementParent( value ), "dbid")
					if getElementType(getElementParent( value )) == "interior" then -- house found
						element = getElementParent( value )
						id = dbid
						break
					elseif  getElementType(getElementParent( value ) ) == "elevator" then
						-- it's an elevator
						if getElementData(value, "dim") and getElementData(value, "dim")  ~= 0 then
							element = getElementParent( value )
							id = getElementData(value, "dim")
							break
						elseif getElementData( getElementData( value, "other" ), "dim")  and getElementData( getElementData( value, "other" ), "dim")  ~= 0 then
							element = value
							id = getElementData( getElementData( value, "other" ), "dim")
							break
						end
					end
				end
			end
		end
		
		if element then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
				ax, ay = getScreenFromWorldPosition(x, y, z, 0, false)
				if ax then
					hideHouseMenu()
					house = element
					houseID = id
					showHouseMenu()
				end
			else
				outputChatBox("You are too far away from this house.", 255, 0, 0)
			end
		else
			hideHouseMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickHouse, true)

addEvent("playerKnock", true)
addEventHandler("playerKnock", root,
	function()
		outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		playSound("knocking.mp3")
	end
)

addEvent("doorUnlockSound", true)
addEventHandler("doorUnlockSound", root,
	function()
		--outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		-- playSound("doorUnlockSound.mp3")
	end
)

addEvent("doorLockSound", true)
addEventHandler("doorLockSound", root,
	function()
		--outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		-- playSound("doorLockSound.mp3")
	end
)

addEvent("doorGoThru", true)
addEventHandler("doorGoThru", root,
	function()
		--outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
	-- 	playSound("doorGoThru.mp3")
	end
)

local cache = { }
function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		if cache[ dbid ] then
			return unpack( cache[ dbid ] )
		end
		-- find the entrance and exit
		local entrance, exit = nil, nil
		for key, value in pairs(getElementsByType( "pickup", getResourceRootElement() )) do
			if getElementData(value, "dbid") == dbid then
				entrance = value
				break
			end
		end
		
		if entrance then
			cache[ dbid ] = { dbid, entrance }
			return dbid, entrance
		end
	end
	cache[ dbid ] = { 0 }
	return 0
end

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

--

local inttimer = nil
addEvent( "setPlayerInsideInterior", true )
addEventHandler( "setPlayerInsideInterior", getRootElement( ),
	function( targetLocation, targetInterior)
		if inttimer then
			return
		end

		if targetLocation[INTERIOR_DIM] ~= 0 then
			setGravity(0)
		end
		
		setElementFrozen(getLocalPlayer(), true)
		if targetLocation[INTERIOR_DIM] > 0 then
			offset = 6
		else
			offset = 0
		end		
		setElementFrozen(getLocalPlayer(), true)
		setElementPosition(getLocalPlayer(), targetLocation[INTERIOR_X], targetLocation[INTERIOR_Y], targetLocation[INTERIOR_Z] - offset, true)
		setElementInterior(getLocalPlayer(), targetLocation[INTERIOR_INT])
		setCameraInterior(targetLocation[INTERIOR_INT])
		setElementDimension(getLocalPlayer(), targetLocation[INTERIOR_DIM])
		if targetLocation[INTERIOR_ANGLE] then
			setPedRotation(getLocalPlayer(), targetLocation[INTERIOR_ANGLE])
		end
		
		triggerServerEvent("onPlayerInteriorChange", getLocalPlayer(), 0, 0, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		inttimer = setTimer(onPlayerPutInInteriorSecond, 1000, 1, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		engineSetAsynchronousLoading ( false, true )
		
		-- if tonumber(targetLocation[INTERIOR_DIM]) == 0 then
			-- updateLightStatus(1)
		-- else --shit
			-- outputDebugString(tostring(getElementData(targetInterior, "isLightOn")))
			-- updateLightStatus(getElementData(targetInterior, "isLightOn")) 
			-- outputChatBox("'/toglight' to switch on/off the lights in this interior")
		-- end
		
		local adminnote = tostring(getElementData(targetInterior, "adminnote"))
		if string.sub(tostring(adminnote),1,8) ~= "userdata" and adminnote ~= "\n" and getElementData(getLocalPlayer(), "adminduty") == 1 then
			outputChatBox("[INT MONITOR]: "..adminnote:gsub("\n", " ").."[..]", 255,0,0)
			outputChatBox("'/checkint "..getElementData(targetInterior, "dbid").." 'for details.",255,255,0)
		end
		
	end
)

function onPlayerPutInInteriorSecond(dimension, interior)
	setCameraInterior(interior)
	
	local safeToSpawn = true
	if(getResourceFromName("object-system"))then
		safeToSpawn = exports['object-system']:isSafeToSpawn()
	end
	
	if (safeToSpawn) then
		inttimer = nil
		if isElement(getLocalPlayer()) then
			setTimer(onPlayerPutInInteriorThird, 1000, 1)
		end
	else
		setTimer(onPlayerPutInInteriorSecond, 1000, 1, dimension, interior)
	end
end

function onPlayerPutInInteriorThird()
	setGravity(0.008)
	setElementFrozen(getLocalPlayer(), false)
	engineSetAsynchronousLoading ( true, false )
	local x, y, z = getElementPosition(getLocalPlayer())
	setElementPosition(localPlayer, x, y, z + offset)
	setElementFrozen(getLocalPlayer(), false)
	engineSetAsynchronousLoading ( true, false )
end

function cPKnock()
	if (getElementDimension(getLocalPlayer()) > 20000) then
		triggerServerEvent("onVehicleKnocking", getLocalPlayer())
	else
		triggerServerEvent("onKnocking", getLocalPlayer(), 0)
	end
end
addCommandHandler("knock", cPKnock)

local starttime = false
local function updateIconAlpha( )
	local time = getTickCount( ) - starttime
	-- if time > 20000 then
		-- removeIcon( )
	-- else
		time = time % 1000
		local alpha = 0
		if time < 500 then
			alpha = time / 500
		else
			alpha = 1 - ( time - 500 ) / 500
		end
		
		guiSetAlpha(help_icon, alpha)
		guiSetAlpha(icon_label_shadow, alpha)
		guiSetAlpha(icon_label, alpha)
	--end
end

function showLoadingProgress(stats_numberOfInts, delayTime)
	if help_icon then
		removeIcon()
	end
	local title = stats_numberOfInts.." interiors(ETA: "..string.sub(tostring((tonumber(delayTime)-5000)/(60*1000)), 1, 3).." minutes) are being loaded. Don't panic if your house hasn't appeared yet. "
	local screenwidth, screenheight = guiGetScreenSize()
	help_icon = guiCreateStaticImage(screenwidth-25,6,20,20,"icon.png",false)
	icon_label_shadow = guiCreateLabel(screenwidth-829,11,800,20,title,false)
	guiSetFont(icon_label_shadow,"default-bold-small")
	guiLabelSetColor(icon_label_shadow,0,0,0)
	guiLabelSetHorizontalAlign(icon_label_shadow,"right",true)
	
	icon_label = guiCreateLabel(screenwidth-830,10,800,20,title,false)
	guiSetFont(icon_label,"default-bold-small")
	guiLabelSetHorizontalAlign(icon_label,"right",true)
	
	starttime = getTickCount( )
	updateIconAlpha( )
	addEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )
	
	setTimer(function () 
		if help_icon then
			removeIcon()
		end
	end, delayTime+10000 , 1)
end
addEvent("interior:showLoadingProgress",true)
addEventHandler("interior:showLoadingProgress",getRootElement(),showLoadingProgress)
--addCommandHandler("fu",showLoadingProgress)

function removeIcon()
	removeEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )
	destroyElement(icon_label_shadow)
	destroyElement(icon_label)
	destroyElement(help_icon)
	icon_label_shadow, icon_label, help_icon = nil
end