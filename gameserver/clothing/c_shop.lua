local window, editing_window = nil

-- creating the ped
local previewPed = nil
local defaultModel = 211

defaultPrice = 1000
main = { }
edit = { }

function createShopPed()
	local ped = createPed(defaultModel, 208.8193359375, -98.7041015625, 1005.2578125)
	setElementFrozen(ped, true)
	setElementRotation(ped, 0, 0, 180)
	setElementDimension(ped, 7)
	setElementInterior(ped, 15)

	setElementData(ped, 'name', 'Clothing Lady', false)
	setElementData(ped, "talk", 1, true)

	addEventHandler( 'onClientPedWasted', ped,
		function()
			setTimer(
				function()
					destroyElement(ped)
					createShopPed()
				end, 20000, 1)
		end, false)

	addEventHandler( 'onClientPedDamage', ped, cancelEvent, false )

	previewPed = ped
end

addEventHandler( 'onClientResourceStart', resourceRoot, createShopPed )

-- gui to show all clothing items
local screen_width, screen_height = guiGetScreenSize()
local width, height = 700, math.min(400, math.max(180, math.ceil(screen_height / 4)))
local list, checkbox, grid, editing_item = nil

local function resetPed()
	setElementModel(previewPed, defaultModel)
	setElementData(previewPed, 'clothing:id', nil, false)
	setElementRotation(previewPed, 0, 0, 180)
end

local function closeEditingWindow()
	if edit.window then
		destroyElement(edit.window)
		edit = { }

		guiSetInputMode('allow_binds')
	end
end

local function closeWindow()
	if main.window then
		destroyElement(main.window)
		main = { }
	end

	closeEditingWindow()

	resetPed()
end

-- forcibly close the window upon streaming out
addEventHandler('onClientElementStreamOut', resourceRoot, closeWindow)
addEventHandler('onClientResourceStop', resourceRoot, closeWindow)

-- returns the table by [skin] = true
local function getFittingSkins()
	local race, gender = getElementData(localPlayer, 'race'), getElementData(localPlayer, 'gender')
	local temp = exports['shop-system']:getFittingSkins()

	local t = {}
	for k, v in ipairs(temp[gender][race]) do
		t[v] = true
	end
	return t
end

-- called every once in a while when (de-)selecting the 'only show fitting' checkbox
local function updateGrid()
	-- clean up a little beforehand
	guiGridListClear(main.grid)

	local fitting_skins = getFittingSkins()

	for k, v in ipairs(list) do
		-- price 0 might be disabled, dont show it if the player doesnt have a key
		if canBuySkin(localPlayer, v) then
			-- either display all skins, or only those matching the race/gender
			if not only_fitting or fitting_skins[v.skin] then
				local charid = getElementData( localPlayer, "account:character:id" )
				if (charid==v.added) then
					local row = guiGridListAddRow(main.grid)
					guiGridListSetItemText(main.grid, row, 1, tostring(v.id), false, true)
					guiGridListSetItemData(main.grid, row, 1, tostring(k)) -- index in [list]
					guiGridListSetItemText(main.grid, row, 2, tostring(v.description), false, false)
					guiGridListSetItemText(main.grid, row, 3, tostring(v.skin), false, true)
				end
				-- guiGridListSetItemText(main.grid, row, 4, v.price == 0 and 'N/A' or ('$' .. exports.global:formatMoney(v.price)), false, false)
			end
		end
	end
end

addEvent("clothing:list", true)
addEventHandler("clothing:list", resourceRoot,
	function(list_)
		closeWindow()
		main = { }
		main.window = guiCreateWindow(screen_width / 2 - 289 / 2,screen_height / 2 - 346 / 2,289,346,"Custom Skin Texture Menu",false)
		main.label = guiCreateLabel(20,20,300,300,"All custom textures cost $1000 to purchase.",false,main.window)
		main.grid = guiCreateGridList(20,53,362,196,false,main.window)
		guiGridListSetSelectionMode(main.grid, 0)
		guiGridListAddColumn(main.grid,"id",0.1)
		guiGridListAddColumn(main.grid,"description",0.6)
		guiGridListAddColumn(main.grid,"skin ID",0.2)
		
		list = sortList(list_)
		updateGrid()
		
		main.add = guiCreateButton(25,264,109,33,"Add",false,main.window)
		addEventHandler("onClientGUIClick", main.add, createEditWindow, false)
		main.remove = guiCreateButton(165,264,109,33,"Remove",false,main.window)
		addEventHandler("onClientGUIClick", main.remove,
			function( b, s )
				local row, column = guiGridListGetSelectedItem(main.grid)
				local item = list[tonumber(guiGridListGetItemData(main.grid, row, 1))]
				if item then
					triggerServerEvent('clothing:delete', resourceRoot, item.id)
					closeWindow( )
				end
			end, false )
		main.purchase = guiCreateButton(23,308,109,33,"Purchase",false,main.window)
		addEventHandler("onClientGUIClick", main.purchase,
			function( b, s )
				local row, column = guiGridListGetSelectedItem(main.grid)
				local item = list[tonumber(guiGridListGetItemData(main.grid, row, 1))]
				if item then
					triggerServerEvent('clothing:buy', resourceRoot, item.id)
				end
			end, false )
		main.close = guiCreateButton(166,308,109,33,"Close",false,main.window)
		addEventHandler("onClientGUIClick", main.close, closeWindow, false )
	end, false )
	
function createEditWindow()
	if edit.window then
		destroyElement(edit.window)
		edit = { }
	end
	edit = { 
		label = {},
		edit = {},
		button = {} }
	edit.window = guiCreateWindow(screen_width/2 - 242/2,screen_height/2 - 185/2,242,185,"New Clothing Texture",false)
	edit.label[1] = guiCreateLabel(41,38,47,20,"Skin ID:",false,edit.window)
	edit.edit[1] = guiCreateEdit(87,33,128,25,"",false,edit.window)
	edit.label[2] = guiCreateLabel(61,66,77,20,"URL:",false,edit.window)
	edit.label[3] = guiCreateLabel(21,94,77,20,"Description:",false,edit.window)
	edit.edit[3] = guiCreateEdit(88,62,128,25,"",false,edit.window)
	edit.edit[2] = guiCreateEdit(88,90,128,25,"",false,edit.window)
	edit.button[1] = guiCreateButton(18,135,98,30,"Add",false,edit.window)
	
	guiSetText( edit.edit[1], tostring( getElementModel(localPlayer) ) )
	addEventHandler("onClientGUIClick", edit.button[1],
		function( b, s )
			-- it's really only transferring edited values to the server
			if not ( (string.sub( guiGetText(edit.edit[3]), -4 )==".jpg") or ( (string.sub( guiGetText(edit.edit[3]), -4 )==".png") ) ) then
				outputChatBox( "You must enter a valid URL to an image ending in .jpg or .png", 255, 0, 0 )
			else
				local values = {}
				values["skin"] = guiGetText(edit.edit[1])
				values["description"] = guiGetText(edit.edit[2])
				values["url"] = guiGetText(edit.edit[3])
				values["price"] = defaultPrice
				values["added"] = getElementData( localPlayer, "account:character:id" )

				triggerServerEvent('clothing:save', resourceRoot, values)
				closeWindow( )
				closeEditingWindow()
			end
		end, false)
	edit.button[2] = guiCreateButton(126,136,98,30,"Cancel",false,edit.window)
	addEventHandler("onClientGUIClick", edit.button[2],
		function( b, s )
			closeEditingWindow()
		end, false)
	guiSetInputMode('no_binds_when_editing')
end