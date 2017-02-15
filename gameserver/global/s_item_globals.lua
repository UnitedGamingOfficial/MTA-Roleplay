function hasSpaceForItem( ... )
	return call( getResourceFromName( "item-system" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue, clothingTest )
	return call( getResourceFromName( "item-system" ), "hasItem", element, itemID, itemValue, clothingTest )
end

function giveItem( element, itemID, itemValue )
	return call( getResourceFromName( "item-system" ), "giveItem", element, itemID, itemValue, false, true )
end

function takeItem( element, itemID, itemValue )
	return call( getResourceFromName( "item-system" ), "takeItem", element, itemID, itemValue )
end

function takeItemFromSlot( element, slotID, nosql )
	return call( getResourceFromName( "item-system" ), "takeItemFromSlot", element, slotID, nosql )
end