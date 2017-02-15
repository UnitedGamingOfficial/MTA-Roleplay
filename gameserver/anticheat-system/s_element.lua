local secretHandle = ''

addEventHandler("onElementDataChange", getRootElement(), 
	function (index, oldValue)
		if not client then
			return
		end
		local theElement = source
		if (index ~= "interiormarker") and (index ~= "i:left") and (index ~= "i:right") then
			local isProtected = getElementData(theElement, secretHandle.."p:"..index)
			if (isProtected) then
				-- get real source here
				-- it aint source!
				local sourceClient = client
				if (sourceClient) then
					if (getElementType(sourceClient) == "player") then
						local newData = getElementData(source, index)
						local playername = getPlayerName(source) or "Somethings"
						-- Get rid of the player
						local msg = "[AdmWarn] " .. getPlayerName(sourceClient) .. " sent illegal data. Player has been banned."
						local msg2 = " (victim: "..playername.." index: "..index .." newvalue: ".. tostring(newData) .. " oldvalue: ".. tostring(oldValue)  ..")"
						exports.global:sendMessageToAdmins(msg)
						exports.global:sendMessageToAdmins(msg2)
						exports.logs:dbLog(sourceClient, 5, sourceClient, msg..msg2 )
						outputChatBox("TamBan: " .. playername .. " has been banned.", getRootElement(), 255, 0, 51)
						outputChatBox("TamBan: Reason: Hacked Client.", getRootElement(), 255, 0, 51)
						-- revert data
						changeProtectedElementDataEx(source, index, oldValue, true)
						local ban = banPlayer(sourceClient, false, false, true, getRootElement(), "Hacked Client.", 0)
					end
				end
			end
		end
	end
);

addEventHandler ( "onPlayerJoin", getRootElement(), 
	function () 
		protectElementData(source, "adminlevel")
		protectElementData(source, "account:id")
		protectElementData(source, "account:username")
		protectElementData(source, "legitnamechange")
		protectElementData(source, "dbid")
	end
);

function allowElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, false, false)
end

function protectElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, true, false)
end

function changeProtectedElementData(thePlayer, index, newvalue)
	allowElementData(thePlayer, index)
	setElementData(thePlayer, index, newvalue)
	protectElementData(thePlayer, index)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		if not newvalue then
			newvalue = nil
		end
		if not nosyncatall then
			nosyncatall = false
		end
	
		allowElementData(thePlayer, index)
		local set = setElementData(thePlayer, index, newvalue, sync) 
		if not set then
			if index ~= "interiormarker" then
				if not isElement(thePlayer) then
					outputDebugString("changeProtectedElementDataEx Error Log:")
					if thePlayer then
						outputDebugString("Type: " ..type(thePlayer))
						outputDebugString("Element: " ..tostring(thePlayer))
					else
						outputDebugString("No Element")
					end
					outputDebugString("index: "..index)
					outputDebugString("newvalue: "..tostring(newvalue))
				end
			end
		end
		if not sync then
			if not nosyncatall then
				if getElementType ( thePlayer ) == "player" then
					triggerClientEvent(thePlayer, "edu", getRootElement(), thePlayer, index, newvalue)
				end
			end
		end
		protectElementData(thePlayer, index)
		return true
	end
	return false
end

function genHandle()
	local hash = ''
	for Loop = 1, math.random(5,16) do
		hash = hash .. string.char(math.random(65, 122))
	end
	return hash
end

function fetchH()
	return secretHandle
end

secretHandle = genHandle()