addEvent("realism:startdrinking", true)
addEventHandler("realism:startdrinking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:drinkingsync", source, true, hand)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "realism:drinking", true, false )
		exports['anticheat-system']:changeProtectedElementDataEx(source, "realism:drinking:hand", hand, false )
		setTimer ( stopdrinking, 300000, 1, thePlayer )
	end
);


function stopdrinking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isdrinking = getElementData(thePlayer, "realism:drinking")
		if (isdrinking) then
			triggerClientEvent("realism:drinkingsync", thePlayer, false, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:drinking", false, false )
		end
	end
end
addEvent("realism:stopdrinking", true)
addEventHandler("realism:stopdrinking", getRootElement(), stopdrinking)

function stopdrinkingCMD(thePlayer)
	local isdrinking = getElementData(thePlayer, "realism:drinking")
	if (isdrinking) then
		stopdrinking(thePlayer)
		exports.global:sendLocalMeAction(thePlayer, "throws their beerette on the ground.")
	end
end
addCommandHandler("throwbeer", stopdrinkingCMD)

-- Sync to new players
addEvent("realism:drinking.request", true)
addEventHandler("realism:drinking.request", getRootElement(), 
	function ()
		local players = exports.pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isdrinking = getElementData(thePlayer, "realism:drinking")
			if (isdrinking) then
				local drinkingHand = getElementData(thePlayer, "realism:drinking:hand")
				triggerClientEvent(source, "realism:drinkingsync", thePlayer, isdrinking, drinkingHand)
			end
		end
	end
);