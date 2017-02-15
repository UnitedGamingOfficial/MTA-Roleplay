local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local openReports = 0
local handledReports = 0
local ckAmount = 0
local chopAmount = 0
local unansweredReports = {}
local ownReports = {}

-- dx stuff
local textString = ""
local admstr = ""
local show = false

-- Admin Titles
function getAdminTitle(thePlayer)
	local text = exports.global:getPlayerAdminTitle(thePlayer)	
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end
	return text
end

local GMtitles = { "Trial GameMaster", "GameMaster", "Senior GameMaster", "Lead GameMaster", "Head GameMaster" }
function getPlayerGMTitle(thePlayer)
	local gmLevel = tonumber(getElementData(thePlayer, "account:gmlevel")) or 0
	local text = GMtitles[gmLevel] or "Player"
	return text
end

-- update the labels
local function updateGUI()
	if show then

		local reporttext = ""
		if #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, ", #")
		end
		
		local ownreporttext = ""
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, ", #")
		end 
		
		local onduty = getElementData( localPlayer, "adminlevel" ) <= 7 and "Off Duty " or ""
		if getElementData( localPlayer, "adminduty" ) == 1 then
			onduty = "On Duty" .. " :: "
		else
		end
		
		textString = getAdminTitle( localPlayer ) .. " :: " .. onduty .. admstr .. ( (getElementData( localPlayer, "adminlevel" ) <= 7 )and ( " :: " .. ( openReports - handledReports ) .. " unanswered reports" .. reporttext .. " :: " .. handledReports .. " handled reports" .. ownreporttext .. " ::") or "" )
	end
end
addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )

-- create the gui
local function createGUI()
	show = false
	local adminlevel = getElementData( localPlayer, "adminlevel" ) or 0
	local gmlevel = getElementData( localPlayer, "account:gmlevel" ) or 0

	if adminlevel > 1 or gmlevel > 0 then
		show = true
		updateGUI()
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "adminlevel" or n == "hiddenadmin" or n=="adminduty" then
			createGUI()
		end
	end, false
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( open, handled, unanswered, own, admst )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		admstr = admst
		ownReports = own or {}
		updateGUI()
	end, false
)

function drawText ( )
	if show then
		if ( getPedWeapon( localPlayer ) ~= 43 or not getControlState( "aim_weapon" ) ) then
			dxDrawRectangle(0, sy-25, sx, 25, tocolor(0, 0, 0, 100), false)
			dxDrawText( textString, 5, sy-19, sx, sy, tocolor ( 255, 255, 255, 255 ), 1, "default")
		end
	end
end
addEventHandler("onClientRender",getRootElement(), drawText)