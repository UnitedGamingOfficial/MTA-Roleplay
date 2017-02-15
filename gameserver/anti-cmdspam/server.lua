local spam = {}
local uTimers = {}
local antispamCooldown = 5000

function onCmd( commandName )
	if not getElementData(source, "cmdDisabled") then
		spam[source] = tonumber(spam[source] or 0) + 1
		if spam[source] == 100 then
			local playerName = getPlayerName( source ):gsub('_', ' ')
			outputChatBox('   Please try not to spam too much or you will have your commands disabled.', source, 255,0,0)
			exports.global:sendMessageToAdmins("[ANTI-CMDSPAM] Detected Player '" .. playerName .. "' for possibly spamming "..tonumber(spam[source]).." commands / "..(antispamCooldown/1000).." seconds. ('/"..commandName.."').")
		elseif spam[source] > 150 then
			local playerName = getPlayerName( source ):gsub('_', ' ')
			exports.global:sendMessageToAdmins("[ANTI-CMDSPAM] Player '" .. playerName .. "' has had his commands disabled spamming "..tonumber(spam[source]).." commands / "..(antispamCooldown/1000).." seconds. ('/"..commandName.."').")
			outputChatBox('   Your command usage has been disabled.', source, 255,0,0)
			exports['anticheat-system']:changeProtectedElementDataEx(source, "cmdDisabled", true)
			spam[source] = 0
		end
	
		if isTimer(uTimers[source]) then
			killTimer(uTimers[source])
		end
	
		uTimers[source] = setTimer(	function (source)
			spam[source] = 0
			
			if isElement(source) and getElementData(source, "cmdDisabled") then
				exports['anticheat-system']:changeProtectedElementDataEx(source, "cmdDisabled", false)
			end
		end, antispamCooldown, 1, source)
		-- outputServerLog('[CMD] '.. playerName ..' executed command /'.. commandName ..'')
		-- outputDebugString('[CMD] '.. playerName ..' executed command /'.. commandName ..'')
	else
		cancelEvent()
	end
end
addEventHandler('onPlayerCommand', root, onCmd)

function quitPlayer()
	spam[source] = nil
end
addEventHandler("onPlayerQuit", root, quitPlayer)