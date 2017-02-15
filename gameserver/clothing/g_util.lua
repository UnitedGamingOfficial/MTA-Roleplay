function canEdit(player)
	return false
end

function sortList(list_)
	local newList = {}
	for k, v in pairs(list_) do
		v.id = tonumber(v.id)
		v.skin = tonumber(v.skin)
		v.price = tonumber(v.price)

		table.insert(newList, v)
	end

	table.sort(newList,
		function(a, b)
			if a.model == b.model then
				return a.description < b.description
			else
				return a.model < b.model
			end
		end)

	return newList
end


function getInteriorOwner(player)
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["interior-system"]:findProperty(player)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(getElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

local getPlayerName_ = getPlayerName
function getPlayerName(player)
	return getElementType(player) == 'player' and getPlayerName_(player):gsub('_', ' ') or getElementData(player, 'name') or '(ped)'
end

restrictedSkins = { [280] = true, [285] = true, [265] = true, [266] = true, [267] = true, [281] = true, [284] = true }

function getRestrictedSkins( )
	return restrictedSkins
end

pdSkins = { [280] = true, [285] = true, [265] = true, [266] = true, [267] = true, [281] = true, [284] = true }
pdFaction = { [1] = true }

function canBuySkin(player, clothing)
	if not clothing.description or clothing.price == 0 then
		return false
	end
	
	if pdSkins[clothing.skin] then -- Only PD leaders can purchase those skins.
		local pF = getElementData(player, "faction")
		local fL = getElementData(player, "factionleader")
		if not pdFaction[pF] or fL~=1 then
			return false
		end
	end

	local desc = clothing.description:lower()
	if desc:sub(1, 7) == 'private' then -- starts with private
		-- can only buy it if it contains his name
		if desc:find(getPlayerName(player):lower()) then
			return true
		end
		return false
	end
	return true
end
