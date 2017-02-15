backupBlip = false
backupPlayer = nil

function destroyBlip()
	for key, value in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Towing & Recovery"))) do
		outputChatBox("The unit no longer requires assistance. Resume normal patrol", value, 255, 194, 14)
	end
	for k,v in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Towing & Recovery"))) do
		triggerClientEvent(v, "destroyBackupBlip3", thePlayer)
	end
	if source and isElement(source) then
		removeEventHandler("onPlayerQuit", source, destroyBlip)
		removeEventHandler("savePlayer", source, destroyBlip)
	end
	backupPlayer = nil
	backupBlip = false
end

function removeBackup(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) or (getTeamName(thePlayerTeam) == "Los Santos Towing & Recovery" and getElementData(thePlayer, "factionleader") == 1) then
		if (backupPlayer~=nil) then
			
			for k,v in ipairs(getPlayersInTeam ( getTeamFromName("Los Santos Towing & Recovery") )) do
				triggerClientEvent(v, "destroyBackupBlip3", backupBlip)
			end
			removeEventHandler("onPlayerQuit", backupPlayer, destroyBlip)
			removeEventHandler("savePlayer", backupPlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = false
			outputChatBox("Backup system reset!", thePlayer, 255, 194, 14)
		else
			outputChatBox("Backup system did not need reset.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("resettowbackup", removeBackup, false, false)

function backup(thePlayer, commandName)
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	
	--if (factionType==3 or getTeamName(thePlayerTeam) == "Los Santos Towing & Recovery") then--Leaving this in in case of abuse.
		if (backupBlip == true) and (backupPlayer~=thePlayer) then -- in use
			outputChatBox("There is already a backup beacon in use.", thePlayer, 255, 194, 14)
		elseif (backupBlip == false) then -- make backup blip
			backupBlip = true
			backupPlayer = thePlayer
			for k,v in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Towing & Recovery"))) do
				triggerClientEvent(v, "createBackupBlip3", thePlayer)
				outputChatBox("A person requires a Tow Truck. Please respond ASAP!", v, 255, 194, 14)
			end

			addEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			addEventHandler("savePlayer", thePlayer, destroyBlip)
			outputChatBox("You enabled your GPS Beacon for SFT&R.", thePlayer, 0, 255, 0)
		elseif (backupBlip == true) and (backupPlayer==thePlayer) then -- in use by this player
			destroyBlip( )
			outputChatBox("You disabled your GPS Beacon for SFT&R.", thePlayer, 255, 0, 0)
		end
	--end
end
addCommandHandler("towtruck", backup, false, false)