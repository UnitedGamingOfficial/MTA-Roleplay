function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /restartres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				local delayTime = 50
				if resourceName:lower() == "interior-system" then
					delayTime = 20*1000
					outputChatBox("* Interiors system is restarting in "..(delayTime/1000).." seconds! *", root, 255, 0, 0)
					outputChatBox("* Your game might be frozen for a short moment, please standby... *", root, 255, 0, 0)
					
				elseif resourceName:lower() == "vehicle-system" then
					delayTime = 10*1000
					outputChatBox("* Vehicles system is restarting in "..(delayTime/1000).." seconds! *", root, 255, 0, 0)
					outputChatBox("* Your game might be frozen and your vehicle might disappear for a short moment, please standby... *", root, 255, 0, 0)
					
				elseif resourceName:lower() == "elevator-system" then
					delayTime = 5*1000
					outputChatBox("* Elevators system is restarting in "..(delayTime/1000).." seconds! *", root, 255, 0, 0)
					outputChatBox("* Your game might be frozen for a short moment, please standby... *", root, 255, 0, 0)
					
				elseif resourceName:lower() == "item-system" then
					delayTime = 5*1000
					outputChatBox("* Item system is restarting in ".. (delayTime/1000) .." seconds! *", root, 255, 0, 0)
					outputChatBox("* Your game might be frozen for a short moment. *", root, 255, 0, 0)
					outputChatBox("* It might take up to a minute before your inventory re-appears. *", root, 255, 0, 0)
				end
				setTimer(function ()	
					if getResourceState(theResource) == "running" then
						restartResource(theResource)
						outputChatBox("Resource " .. resourceName .. " was restarted.", thePlayer, 0, 255, 0)
						exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the resource '" .. resourceName .. "'.")
					elseif getResourceState(theResource) == "loaded" then
						startResource(theResource, true)
						outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
						exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
					elseif getResourceState(theResource) == "failed to load" then
						outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
					else
						outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
					end
				end, delayTime, 1)
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartres", restartSingleResource)
 
function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /stopres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if stopResource(theResource) then
					outputChatBox("Resource " .. resourceName .. " was stopped.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " stopped the resource '" .. resourceName .. "'.")
				else
					outputChatBox("Couldn't stop Resource " .. resourceName .. ".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)
 
function startSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /startres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("Resource " .. resourceName .. " is already started.", thePlayer, 0, 255, 0)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)

-- ACL
function reloadACL(thePlayer)
	if exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerLeadAdmin(thePlayer) then
		local acl = aclReload()
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if acl then
			outputChatBox("The ACL has been succefully reloaded!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("AdmACL: " .. getPlayerName(thePlayer):gsub("_"," ") .. " has reloaded the ACL settings!")
			else
				exports.global:sendMessageToAdmins("AdmACL: A hidden admin has reloaded the ACL settings!")
			end
		else
			outputChatBox("Failed to reload the ACL!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("reloadacl", reloadACL, false, false)