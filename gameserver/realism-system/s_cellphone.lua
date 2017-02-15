function startCellphone(hand, test)
	if test then
		source = test
	end
	if not (hand) then
		hand = 0
	else
		hand = tonumber(hand)
	end	
	
	triggerClientEvent("realism:phonesync", source, true, hand)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "realism:smoking", true, false )
	exports['anticheat-system']:changeProtectedElementDataEx(source, "realism:smoking:hand", hand, false )
	setTimer ( stopSmoking, 300000, 1, thePlayer )
end
addEvent("realism:startCellphone", true)
addEventHandler("realism:startCellphone", getRootElement(),startCellphone)

function test (thePlayer)
	startCellphone(false, thePlayer)
end
addCommandHandler("startcellphone", test)


function stopSmoking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isSmoking = getElementData(thePlayer, "realism:smoking")
		if (isSmoking) then
			triggerClientEvent("realism:phonesync", thePlayer, false, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
		end
	end
end
addEvent("realism:stopsmoking", true)
addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

function stopSmokingCMD(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		stopSmoking(thePlayer)
		exports.global:sendLocalMeAction(thePlayer, "throws their cigarette on the ground.")
	end
end
addCommandHandler("throwaway", stopSmokingCMD)

function changeSmokehand(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		triggerClientEvent("realism:phonesync", thePlayer, true, 1-smokingHand)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:smoking:hand",1-smokingHand, false )
	end
end
addCommandHandler("switchhand", changeSmokehand)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:phonesync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
)
--[[
function phone (source)
	daBlockz = getElementData(root,"blockz")
	daAnimz = getElementData(root,"animz")
		if daBlockz == "phoning" and daAnimz == "phone_talk" then
			setPedAnimation(source,false)
		else
			setPedAnimation ( source, "phoning", "phone_talk")
		end
	end
addCommandHandler("phone",phone)]]