function stopRestartRes()
	stopResource(getResourceFromName("Restart"))
	exports.global:sendMessageToAdmins('[RESTART ALL] Script has automatically stopped the resourse "Restart"')
end

local shutdownTimer = setTimer(stopRestartRes, 300000, 1)
--addEventHandler("onResourceStart", getRootElement(), autoShutOff)

function restartAllResources()
  local allResources = getResources()
  for index, res in ipairs(allResources) do
   if getResourceState(res) == "running" then
    restartResource(res)
   end
  end
 resetTimer(shutdownTimer)
end
addCommandHandler ( "restartresall", restartAllResources )

function restartOrder()
	setTimer(loadMySQL, 2000, 1)
	setTimer(loadGlobal, 4000, 1)
	setTimer(loadPool, 6000, 1)
	setTimer(loadAccounts, 8000, 1)
	setTimer(loadAchievement, 10000, 1)
	setTimer(loadAdmin, 12000, 1)
	setTimer(loadCache, 14000, 1)
	setTimer(loadComputer, 16000, 1)
	setTimer(loadDance, 18000, 1)
	setTimer(loadElevator, 20000, 1)
	setTimer(loadFaction, 22000, 1)
	setTimer(loadFuel, 24000, 1)
	setTimer(loadID, 26000, 1)
	setTimer(loadInterior, 28000, 1)
	setTimer(loadItem, 30000, 1)
	setTimer(loadJob, 32000, 1)
	setTimer(loadLSES, 34000, 1)
	setTimer(loadLSPD, 36000, 1)
	setTimer(loadPayNSpray, 38000, 1)
	setTimer(loadShop, 40000, 1)
	setTimer(loadVehicle, 42000, 1)
	setTimer(loadFinished, 42001, 1)
	resetTimer(shutdownTimer)
end
addCommandHandler ("restartresorder",restartOrder)

function fixProblem()
	setTimer(loadMySQL, 1000, 1)
	setTimer(loadGlobal, 2000, 1)
	setTimer(loadPool, 3000, 1)
	setTimer(loadFinished, 4000, 1)
	resetTimer(shutdownTimer)
end
addCommandHandler ("restartresproblem", fixProblem)

function loadMySQL()
	restartResource(getResourceFromName("mysql"))
	outputDebugString("[RESTART ALL] Script restarted the resource MySQL")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource MySQL")
end

function loadGlobal()
	restartResource(getResourceFromName("global"))
	outputDebugString("[RESTART ALL] Script restarted the resource Global")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Global")
end

function loadPool()
	restartResource(getResourceFromName("pool"))
	outputDebugString("[RESTART ALL] Script restarted the resource Pool")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Pool")
end

function loadAccounts()
	restartResource(getResourceFromName("account-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Account-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Account-system")
end

function loadAchievement()
	restartResource(getResourceFromName("achievement-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Achievement-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Achievement-system")
end

function loadAdmin()
	restartResource(getResourceFromName("admin-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Admin-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Admin-system")
end

function loadBank()
	restartResource(getResourceFromName("bank-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Bank-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Bank-system")
end

function loadCache()
	restartResource(getResourceFromName("cache"))
	outputDebugString("[RESTART ALL] Script restarted the resource Cache(Player Name)")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Cache (Player Names)")
end

function loadComputer()
	restartResource(getResourceFromName("computers-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Computes-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Computers-system")
end

function loadDance()
	restartResource(getResourceFromName("dancer-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Dancer-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Dancer-system")
end

function loadElevator()
	restartResource(getResourceFromName("elevator-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Elevator-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Elevator-system")
end

function loadFaction()
	restartResource(getResourceFromName("faction-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Faction-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Faction-system")
end

function loadFuel()
	restartResource(getResourceFromName("fuel-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Fuel-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Fuel-system")
end

function loadID()
	restartResource(getResourceFromName("id-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource ID-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource ID-system")
end

function loadInterior()
	restartResource(getResourceFromName("interior-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Interior-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Interior-system")
end

function loadItem()
	restartResource(getResourceFromName("item-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Item-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Item-system")
end

function loadJob()
	restartResource(getResourceFromName("job-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Job-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Job-system")
end

function loadLSES()
	restartResource(getResourceFromName("es-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource ES-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource ES-system")
end

function loadLSPD()
	restartResource(getResourceFromName("pd-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource PD-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource PD-system")
end

function loadPayNSpray()
	restartResource(getResourceFromName("paynspray-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource PayNSpray-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource PayNSpray-system")
end

function loadShop()
	restartResource(getResourceFromName("shop-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Shop-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Shop-system")
end

function loadVehicle()
	restartResource(getResourceFromName("vehicle-system"))
	outputDebugString("[RESTART ALL] Script restarted the resource Vehicle-system")
	exports.global:sendMessageToAdmins("[RESTART ALL] Script restarted the resource Vehicle-system")
end

function loadFinished()
	exports.global:sendMessageToAdmins("Done.")
end