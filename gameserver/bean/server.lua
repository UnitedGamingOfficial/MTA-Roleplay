mysql = exports.mysql

setWeaponProperty ( 31, "pro", "move_speed", 999 )


local attachedWeapons = { [31] = {} }--{ [24] = {}, [25] = {}, [30] = {} }

addEvent("onPlayerAttachWeapon", true)
addEvent("onPlayerDetachWeapon", true)

function doesPlayerHaveGunAttached( weaponID )
	if (attachedWeapons[weaponID][source]) and (attachedWeapons[weaponID][source][2] == weaponID) then
		return true
	else
		return false
	end
end

function attachWeapon( weaponID, objectID, boneID, status )
	if not boneID then boneID = 3 end -- Spine by default.
	if doesPlayerHaveGunAttached( weaponID ) then return end
	if not getPedWeapon( source, weaponID ) then
		--if exports['item-system']:doesPlayerHaveWeapon( source, weaponID ) then
			local x, y, z = getElementPosition(source)
			local rot = getPedRotation(source)
			local dim, int = getElementDimension(source), getElementInterior(source)
			x = x + math.sin(math.rad(rot)) * 0.3
			y = y + math.cos(math.rad(rot)) * 0.3				
			local object = createObject( objectID, x, y, z )
			setElementInterior(object, int)
			setElementDimension(object, dim)
			exports['bone_attach']:attachElementToBone( object, source, boneID, 0.1, 0.275, 0.05, 190, -130, 0) -- Eventually unpack() a saved location here, but for now we're just testing, right?
			attachedWeapons[weaponID][source] = { object, weaponID, objectID }
		--end
	end
end
addEventHandler( "onPlayerAttachWeapon", getRootElement( ), attachWeapon )

function detachWeapon( weaponID )
	if (attachedWeapons[weaponID][source]) and (attachedWeapons[weaponID][source][2] == weaponID) then -- Already got that gun attached :O remove it....
		destroyElement(attachedWeapons[weaponID][source][1])
		attachedWeapons[weaponID][source] = nil
	end
end
addEventHandler( "onPlayerDetachWeapon", getRootElement( ), detachWeapon )

addCommandHandler("cd",
	function( )
		outputChatBox(getElementData(source, "speedo:street" ) or "No known street.", source, 0, 255, 0)
	end
);

function doTheSound( thePlayer, commandName, sound )
	for k, v in ipairs(getElementsByType("player")) do
		triggerClientEvent ( v, "playSuperSound", v, tostring(sound) )
	end
	outputChatBox("Sent to all clients.", thePlayer, 0, 255, 0)
end
addCommandHandler("dosound", doTheSound)


salt = "JFYHJHFH@@4ygagssg677SHhsffalLASIjnfg GV,,dJGHUADHfALalSj66sjffakals||Sdfa;..521%#s"
addEvent( "securePasswordChange", true )
addEventHandler( "securePasswordChange", getRootElement( ),
	function( oldpass, newpass )
		local safeusername = mysql:escape_string( getElementData( source, "account:username" ) )
		local safepassword_new = mysql:escape_string( newpass )
		
		local checkQuery = mysql:query_free("SELECT `password` FROM `accounts` WHERE `username`='" .. safeusername .. "'")
		if checkQuery ~= sha256(sha256( salt ) .. sha256( oldpass )) then
			outputDebugString("QUERY: " .. checkQuery )
			outputDebugString("Current pass: " .. sha256(sha256( salt ) .. sha256( oldpass )))
			outputChatBox( "Changing password failed: incorrect current password.", source, 255, 0, 0 )
		else
			local saltedPassword = sha256(sha256( salt ) .. sha256( newpass ))
			local updateQuery = mysql:query_free("UPDATE `accounts` SET `password`='"..saltedPassword.."' WHERE `username`='" .. safeusername .. "'")
			if updateQuery then
				outputChatBox( "Password successfully changed to: " .. newpass, source, 0, 255, 0 )
			end
		end
	end
);

legitTimers = {}

function ameAction( thePlayer, commandName, ... )
	local message = table.concat({...}, " ")
	if not (...) then
		outputChatBox("SYNTAX: /ame [Action]", source, 255, 194, 14)
	else
		local hasAme = getElementData(thePlayer, "ame:text")
		if hasAme then
			setElementData(thePlayer, "ame:text", nil)
			if legitTimers[thePlayer] then
				killTimer( legitTimers[thePlayer] )
				legitTimers[thePlayer] = nil
			end
		end
		setElementData(thePlayer, "ame:text", message)
		legitTimers[thePlayer] = setTimer(function( )
					setElementData(thePlayer, "ame:text", nil)
				end, 8000, 1)
		outputChatBox(" > " .. getPlayerName(thePlayer):gsub("_", " ") .. " " .. message, thePlayer, 255, 51, 102)
	end
end
addCommandHandler("ame", ameAction)
addEvent("performAmeAction", true)
addEventHandler("performAmeAction", getRootElement( ), ameAction)

addCommandHandler("doit",
	function( p, c )
		ameAction( p, c, "hits a button on the Genesis II Select radar unit." )
	end
);

-- cleanup
addEventHandler("onPlayerQuit", getRootElement( ), 
function( )
	if legitTimers[source] then
		killTimer( legitTimers[source] )
		legitTimers[source] = nil
	end
end
);