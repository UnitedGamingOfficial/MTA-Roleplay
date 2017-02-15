-- if not exports.global:isPlayerScripter( getLocalPlayer( ) ) then return false, "No." end

weaponTesting = false

password = { }
screenX, screenY = guiGetScreenSize()

function passwordChangeGUI( )
	if password.window then
		destroyElement( password.window )
		password = { }
		guiSetInputEnabled( false )
		showCursor( false )
	else
		password.window = guiCreateWindow( screenX / 2 - 330 / 2, screenY / 2 - 232 / 2, 330, 232, "Change Account Password", false )
		guiWindowSetSizable( password.window, false )
		guiSetInputEnabled( true )
		showCursor( true )
		password.label = { }
		password.edit = { }
		password.button = { }
		password.label[1] = guiCreateLabel( 23, 27, 107, 20, "Current Password:", false, password.window )
		password.label[2] = guiCreateLabel( 23, 82, 107, 23, "New Password:", false, password.window )
		password.label[3] = guiCreateLabel( 23, 140, 107, 21, "Confirm New Pass:", false, password.window )
		password.edit[1] = guiCreateEdit( 130, 27, 178, 22, "", false, password.window )
		password.edit[2] = guiCreateEdit( 130, 82, 178, 22, "", false, password.window )
		password.edit[3] = guiCreateEdit( 130, 140, 178, 22, "", false, password.window )
		guiEditSetMasked( password.edit[1], true )
		guiEditSetMasked( password.edit[2], true )
		guiEditSetMasked( password.edit[3], true )
		password.button[1] = guiCreateButton( 54, 178, 91, 37, "Change Password", false, password.window )
		addEventHandler("onClientGUIClick", password.button[1],
		function( )
			local oldPassword = tostring( guiGetText( password.edit[1] ) )
			local newPassword = tostring( guiGetText( password.edit[2] ) )
			local newPassword_confirm = tostring( guiGetText( password.edit[3] ) )
			if oldPassword and newPassword and newPassword_confirm then
				if newPassword~=newPassword_confirm then
					outputChatBox( "Your new passwords don't match." )
				else
					if ( string.find( newPassword, ";", 0 ) ) or ( string.find( newPassword, "'", 0 ) ) or ( string.find( newPassword, "@", 0 ) ) or ( string.find( newPassword, ",", 0 ) ) then
						outputChatBox( "Your password contains invalid characters." )
					else
						triggerServerEvent( "securePasswordChange", getLocalPlayer( ), oldPassword, newPassword )
					end
				end
			end
		end, true )
		guiSetProperty( password.button[1], "NormalTextColour", "FFAAAAAA" )
		password.button[2] = guiCreateButton( 193, 178, 91, 37, "Cancel Change", false, password.window )
		addEventHandler( "onClientGUIClick", password.button[2], passwordChangeGUI, true )
		guiSetProperty( password.button[2], "NormalTextColour", "FFAAAAAA" )
	end
end
addCommandHandler( "changepass", passwordChangeGUI )


soundPlaying = nil

function playTheSoundClient( address )
	if soundPlaying then
		stopSound( soundPlaying )
		soundPlaying = nil
	end
	soundPlaying = playSound( address, true )
end
addEvent("playSuperSound", true)
addEventHandler("playSuperSound", getLocalPlayer( ), playTheSoundClient)

--players = { }

function renderOverHeadMeActions()
	--for index, render in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "player") ) do
	--	players[index] = render
	--end
	--for i = 1, #players, 1 do
	for k, v in ipairs(getElementsByType("player")) do
		if v~=localPlayer then
			local hasAme = getElementData(v, "ame:text")
			--local hasAme = "is a nigger."
			if hasAme then
				local px, py, pz = getElementPosition( v )
				local cx, cy, cz = getCameraMatrix( )
				local dimension = getElementDimension( v )
				local interior = getElementInterior( v )
				if getElementDimension( localPlayer ) == dimension and getElementInterior( localPlayer ) == interior then
					local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
					font = "default-bold"
					if distance <= 45 then
						local sx, sy = getScreenFromWorldPosition( px, py, pz + 1.6 )
						if sx and sy then
							dxDrawText( "* " .. getPlayerName(v):gsub("_", " ") .. " " .. hasAme, sx, sy, sx, sy, tocolor( 0, 0, 0, 255 ), 1.3, font, "center", "center" )
							dxDrawText( "* " .. getPlayerName(v):gsub("_", " ") .. " " .. hasAme, sx, sy, sx, sy, tocolor( 255, 51, 102, 255 ), 1.3, font, "center", "center" )
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement( ), renderOverHeadMeActions)

function displayExtraArmor( )
	if isPlayerHudComponentVisible( "health" ) and isPlayerHudComponentVisible( "armour" ) then
		if getElementData(localPlayer, "loggedin") == 1 and not exports['freecam']:isFreecamEnabled() then
			local sx, sy = guiGetScreenSize( )
			local extraArmor = getElementData(localPlayer, "extraarmour")
			if extraArmor then
				dxDrawText( math.floor(extraArmor) + math.floor(getPedArmor(localPlayer)), (1639/1920)*sx, (143/1080)*sy, (1825/1920)*sx, (172/1080)*sy, tocolor(0, 0, 0, 255), 1, "sans", "center", "center", false, false, true, false, false)
			elseif (getPedArmor(localPlayer) > 0) then
				dxDrawText( math.floor(getPedArmor(localPlayer)), (1639/1920)*sx, (143/1080)*sy, (1825/1920)*sx, (172/1080)*sy, tocolor(0, 0, 0, 255), 1, "sans", "center", "center", false, false, true, false, false)
			end
			dxDrawText( math.floor(getElementHealth(localPlayer)), (1639/1920)*sx, (214/1080)*sy, (1825/1920)*sx, (243/1080)*sy, tocolor(0, 0, 0, 255), 1, "sans", "center", "center", false, false, true, false, false)
		end
	end
end
addEventHandler("onClientRender", getRootElement( ), displayExtraArmor)

--[[addCommandHandler("extraarmor",
	function( )
		if setElementData(localPlayer, "extraarmour", 100) then
			outputChatBox("Gave yourself 100 more armor lol.", 0, 255, 0)
			exports.global:sendMessageToAdmins(getPlayerName(localPlayer) .. " set did /extraarmor.")
		end
	end
);]]

addCommandHandler("togmytag",
	function( )
		exports.global:sendMessageToAdmins("[TOGMYTAG] " .. getPlayerName(localPlayer) .. " just typed /togmytag.")
	end
)

addEventHandler("onClientPlayerDamage", getLocalPlayer( ),
	function( attacker, weapon, bodypart, loss )
		if (weapon>22 or weapon<34) and attacker then
			if getElementData(source, "adminduty") == 1 then
				return
			end
			local currentExtraArmour = getElementData(source, "extraarmour")
			if currentExtraArmour and currentExtraArmour>0 then
				if currentExtraArmour - loss < 1 then
					setElementData(source, "extraarmour", nil)
				else
					setElementData(source, "extraarmour", currentExtraArmour - loss)
					cancelEvent()
				end
			else
				return
			end
		end
	end
);

local allowedWeapons = {
--[[[24] = { 24, 348, 14 },
[25] = { 25, 349, 3 },
[30] = { 30, 355, 3 }]]
[31] = { 31, 356, 3 }
}

function testScrollingAction ( prevSlot, newSlot )
	local attachWeapon = getPedWeapon( getLocalPlayer(), newSlot )
	local myWeapon = allowedWeapons[attachWeapon]
	if myWeapon then
		triggerServerEvent("onPlayerDetachWeapon", getLocalPlayer( ), attachWeapon) -- remove the deagle.
	end
	for k, v in pairs(allowedWeapons) do
		if k~=attachWeapon then
			if getSlotFromWeapon( k ) then
				triggerServerEvent("onPlayerDetachWeapon", getLocalPlayer( ), k)
				triggerServerEvent( "onPlayerAttachWeapon", getLocalPlayer( ), v[1], v[2], v[3] )
			end
		end
	end
end
if weaponTesting then
	addEventHandler ( "onClientPlayerWeaponSwitch", getRootElement(), testScrollingAction )
end

function giveWeaponShitOnStart( )
	triggerServerEvent( "onPlayerAttachWeapon", getLocalPlayer( ), 24, 348, 14 ) -- Deagle.
end
--addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), giveWeaponShitOnStart )