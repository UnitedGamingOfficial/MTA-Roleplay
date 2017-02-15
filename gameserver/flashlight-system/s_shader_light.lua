local isFlon = {}
local isFlen = {}

addEvent("onPlayerStartRes",true)
addEventHandler("onPlayerStartRes", root,
	function()
		isFlon[source] = false
		isFlen[source] = false
		for _,v in ipairs(getElementsByType("player")) do		
			triggerClientEvent(source, "flashOnPlayerEnable", root, isFlen[v], v)
			triggerClientEvent(source, "flashOnPlayerSwitch", root, isFlon[v], v)
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if (getElementType(source) == "player") then
			isFlon[source] = false
			isFlen[source] = false
			triggerClientEvent("flashOnPlayerQuit", root, source)
		end
	end
)

addEvent("onSwitchLight",true)
addEventHandler("onSwitchLight", root,
	function(isON)
		isFlon[source] = isON 
		triggerClientEvent("flashOnPlayerSwitch", root, isFlon[source], source)
	end
)

addEvent("onSwitchEffect",true)
addEventHandler("onSwitchEffect", root,
	function(isEN)
		isFlen[source] = isEN 
		triggerClientEvent("flashOnPlayerEnable", root, isFlen[source], source)
	end
)

addEvent("onPlayerGetInter", true)
addEventHandler("onPlayerGetInter", root,
	function()
		local interior = getElementInterior(source)
		triggerClientEvent("flashOnPlayerInter", root, source, interior)
	end
)