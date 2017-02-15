--[[function fixPrison()]]
	colp = engineLoadCOL (  "Fixes/prisonfix.col" )
	engineReplaceCOL ( colp, 4000 )
 
	dffp = engineLoadDFF ( "Fixes/twintjail2_lan.dff" )
	engineReplaceModel ( dffp, 4000 )--[[
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), fixPrison)]]

