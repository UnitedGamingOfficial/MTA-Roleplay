local mysql = exports.mysql
local salt = "wedorp"

function clientReady()
	local thePlayer = source
	local resources = getResources()
	local missingResources = false
	for key, value in ipairs(resources) do
		local resourceName = getResourceName(value)
		if resourceName == "global" or resourceName == "mysql" or resourceNmae == "pool" then
			if getResourceState(value) == "loaded" or getResourceState(value) == "stopping" or getResourceState(value) == "failed to load" then
				missingResources = true
				outputChatBox("The server is missing dependent resource '"..getResourceName(value).."'.", thePlayer, 255, 0, 0)
				outputChatBox("Please try again shortly.", thePlayer, 255, 0, 0)
				outputChatBox("       - The United Gaming Administration Team", thePlayer, 255, 0, 0)
				break
			end
		end
	end
	if missingResources then return end
	local willPlayerBeBanned = false
	local bannedIPs = exports.global:fetchIPs()
	local playerIP = getPlayerIP(thePlayer)
	for key, value in ipairs(bannedIPs) do
		if playerIP == value then
			outputChatBox("Your IP is blacklisted from the server.", thePlayer, 255, 0, 0)
			setTimer(outputChatBox, 1000, 1, "You will be kicked from the server in 10 secconds.", thePlayer, 255, 0, 0)
			setTimer(kickPlayer, 10000, 1, "You are blacklisted from this server.")
			willPlayerBeBanned = true
			break
		end
	end
	if not willPlayerBeBanned then
		local bannedSerials = exports.global:fetchSerials()
		local playerSerial = getPlayerSerial(thePlayer)
		for key, value in ipairs(bannedSerials) do
			if playerSerial == value then
				outputChatBox("Your serial is blacklisted from the server.", thePlayer, 255, 0, 0)
				setTimer(outputChatBox, 1000, 1, "You will be kicked from the server in 10 secconds.", thePlayer, 255, 0, 0)
				setTimer(kickPlayer, 10000, 1, "You are blacklisted from this server.")
				willPlayerBeBanned = true
				break
			end
		end
	end
	if not willPlayerBeBanned then
		triggerClientEvent(thePlayer, "beginLogin", thePlayer)
	else
		triggerClientEvent(thePlayer, "beginLogin", thePlayer, "Banned.")
	end
end
addEvent("onJoin", true)
addEventHandler("onJoin", getRootElement(), clientReady)

addEventHandler ( "onResourceStop", getRootElement( ), 
    function ( resource )
		if (resource==getResourceFromName("rangeban-system")) then
			recieveSecurityConnections = nil
		end
	end 
)

addEventHandler ( "onResourceStart", getRootElement( ), 
    function ( resource )
		if (resource==getResourceFromName("rangeban-system")) then
			recieveSecurityConnections = exports['rangeban-system']:getSecurityConnections( )
			local securityCount = 0
			for k, v in pairs(recieveSecurityConnections) do
				securityCount = securityCount + 1
			end
			exports.global:sendMessageToAdmins("SecurityWrn: Loaded " .. securityCount .. " accounts with security configurations.")
			securityCount = nil
		end
	end 
)

addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		local seamless = getElementData(client, "account:seamless:validated")
		if seamless == true then
			
			-- outputChatBox("-- Migrated your session after a system restart", client, 0, 200, 0)
			setElementData(client, "account:seamless:validated", false, false, true)
			triggerClientEvent(client, "accounts:options", client)
			triggerClientEvent(client, "item:updateclient", client)
			return
		end
		triggerClientEvent(client, "accounts:login:request", client)
	end
);

addEventHandler("accounts:register:attempt", getRootElement(),
	function (username, password)
		local safeusername = mysql:escape_string(username)
		local result = mysql:query("SELECT username FROM accounts WHERE username='" .. safeusername .. "'")
		if (mysql:num_rows(result)>0) then -- Name is already taken
			triggerClientEvent(source, "accounts:error:window", source, "Username already taken.")
			return 
		end
		triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Please Wait.\n~15 Secconds")
		callRemote("http://localhost/server/register.php", verifyRegistration, username, password, source)
	end
);

function verifyRegistration(success, username, thePlayer)
	if success then
		local id = mysql:query_insert_free("INSERT INTO accounts SET username='" .. username .. "',appstate='3'")
		if id then 
			triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Account Registered Successfully")
		else
			triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Account Registration Failed! \n Please report on the forrums \n Account-0125 \n Sorry For the Inconvenience")
		end
	else
		triggerClientEvent(thePlayer, "accounts:error:window", thePlayer, "Account Registration Failed! \n Please report on the forrums \n Account-0126 \n Sorry For the Inconvenience")
	end
end

addEventHandler("accounts:login:attempt", getRootElement(), 
	function (username, password, wantsLoginHash)
		if string.len(password) == 64 then
			safeusername = mysql:escape_string(username)
			safepassword = mysql:escape_string(password)
			result = mysql:query("SELECT `id` FROM `accounts` WHERE `username`='" .. safeusername .. "' AND `loginhash`='" .. safepassword .. "'")
			if mysql:num_rows(result) == 1 then
				verifyLogin(true, username, wantsLoginHash, client)
			else
				verifyLogin(false, nil, nil, client)
			end
		else
			callRemote("http://localhost/server/login.php", verifyLogin, username, password, wantsLoginHash, client)
		end
	end
) 

function verifyLogin(success, username, wantsLoginHash, client)
	if success then
		local accountData = mysql:query_fetch_assoc("SELECT `id`, `username`, `banned`, `appstate`, `admin`,  `warn_style`, `adminduty`, `adminreports`, `hiddenadmin`, `adminjail`, `adminjail_time`, `adminjail_by`, `adminjail_reason`, `monitored`, `email` FROM `accounts` WHERE `username`='" .. username .. "'")
		local securityTable = exports['rangeban-system']:getSecurityConnections( )
			
		if securityTable[username] then
			canConnect = false
			local playerIP = getPlayerIP(client)
			local playerSerial = getPlayerSerial(client)
			local playerNick = getPlayerName(client)
			for _,serial in pairs(securityTable[username][1]) do
				if (playerSerial==serial) then
					canConnect = true
				end
			end				
			
			for _,ip in pairs(securityTable[username][2]) do
				if (playerIP==ip) then
					canConnect = true
				end
			end
			
			if not canConnect then
				exports.global:sendMessageToAdmins("SecurityWrn: Denied ((" .. playerIP .. "))"..playerNick.."/"..playerSerial.." from the server.")
				exports.global:sendMessageToAdmins("SecurityWrn: Inform " .. username .. " to change their password immediately, unapproved serial / IP gained access to their password.")
				exports.logs:dbLog("account-system", 5, tostring(username), "SECURITY BREACH ("..username.."), password compromised: S: " .. playerSerial .. " IP: " .. playerIP .. " N: " .. playerNick)
				kickPlayer ( client, "Security breach: IP & serial not allowed for that account." )
				return
			end
		end
		-- Create a new safety hash, also used for autologin
		local newAccountHash = Login_calculateAutoLoginHash(username)
		setElementDataEx(client, "account:seamlesshash", newAccountHash, false, true)
		if not (wantsLoginHash) then
			newAccountHash = ""
		end
		
		-- Check the account isn't already logged in
		local found = false
		for _, thePlayer in ipairs(exports.pool:getPoolElementsByType("player")) do
			local playerAccountID = tonumber(getElementData(thePlayer, "account:id"))
			if (playerAccountID) then
				if (playerAccountID == tonumber(accountData["id"])) and (thePlayer ~= client) then
					kickPlayer(thePlayer, getRootElement(), "Someone else has logged into your account.") -- To prevent the 0 ping / MAXIME
					break
				end
			end
		end
			
		-- Check if the account ain't banned
		if (tonumber(accountData["banned"]) == 1) then
			triggerClientEvent(client, "accounts:login:attempt", client, 2, "Account is disabled." ) 
			return
		end
		
		-- Check the application state
		if (tonumber(accountData["appstate"]) == 0) then
			triggerClientEvent(client, "accounts:login:attempt", client, 5, "You need to send in an application to play on this server." ) 
			return
		elseif (tonumber(accountData["appstate"]) == 1) then
			triggerClientEvent(client, "accounts:login:attempt", client, 4, "Your application is still pending." ) 
			return
		elseif (tonumber(accountData["appstate"]) == 2) then
			triggerClientEvent(client, "accounts:login:attempt", client, 3, "Your application has been denied." ) 
			return
		end
		local forceAppCheckQuery = mysql:query("SELECT `username`,`appstate` FROM `accounts` WHERE `ip`='" .. mysql:escape_string(getPlayerIP(client)) .. "' OR `mtaserial`='" .. mysql:escape_string(getPlayerSerial(client)) .. "'")
		if forceAppCheckQuery then
			while true do
				local forceAppRow = mysql:fetch_assoc(forceAppQuery)
				if not forceAppRow then break end
				if (tonumber(forceAppRow["appstate"]) == 1) then
					triggerClientEvent(client, "accounts:login:attempt", client, 4, "Your application is still pending on account "..forceAppRow["username"].."." ) 
					mysql:free_result(forceAppCheckQuery)
					return
				elseif (tonumber(forceAppRow["appstate"]) == 2) then
					triggerClientEvent(client, "accounts:login:attempt", client, 3, "Your application has been denied on account "..forceAppRow["username"]..", you can remake one at http://mta.vg." ) 
					mysql:free_result(forceAppCheckQuery)
					return
				end
				
			end
		end
		mysql:free_result(forceAppCheckQuery)
		-- Start the magic
		setElementDataEx(client, "account:loggedin", true, true)
		setElementDataEx(client, "account:id", tonumber(accountData["id"]), true) 
		setElementDataEx(client, "account:username", accountData["username"], false)
		
		setElementDataEx(client, "adminreports", accountData["adminreports"], false)
		setElementDataEx(client, "hiddenadmin", accountData["hiddenadmin"], false)
		
		setElementDataEx(client, "autopark", tonumber(accountData["autopark"]), true)
		setElementDataEx(client, "email", accountData["email"], true)
		
		if (tonumber(accountData["admin"]) >= 0) then
			setElementDataEx(client, "adminlevel", tonumber(accountData["admin"]), false)
			setElementDataEx(client, "account:gmlevel", 0, false)
			setElementDataEx(client, "adminduty", accountData["adminduty"], false)
			setElementDataEx(client, "account:gmduty", false, true)
			setElementDataEx(client, "wrn:style", tonumber(accountData["warn_style"]), true)
		else
			setElementDataEx(client, "adminlevel", 0, false)
			local GMlevel = -tonumber(accountData["admin"])
			setElementDataEx(client, "account:gmlevel", GMlevel, false)
			if (tonumber(accountData["adminduty"]) == 1) then
				setElementDataEx(client, "account:gmduty", true, true)
			else
				setElementDataEx(client, "account:gmduty", false, true)
			end
		end
		
		--PLAYER SECURITY EMAIL REQUEST BY MAXIME
		if not (tostring(accountData["email"]):find("@"))  then
			triggerClientEvent(client, "requestEmail:onPlayerLogin", client, tonumber(accountData["id"]))
		end
		
		if  tonumber(accountData["adminjail"]) == 1 then
			setElementDataEx(client, "adminjailed", true, false)
		else
			setElementDataEx(client, "adminjailed", false, false)
		end
		setElementDataEx(client, "jailtime", tonumber(accountData["adminjail_time"]), false)
		setElementDataEx(client, "jailadmin", accountData["adminjail_by"], false)
		setElementDataEx(client, "jailreason", accountData["adminjail_reason"], false)
		
		if accountData["monitored"] ~= "" then
			setElementDataEx(client, "admin:monitor", accountData["monitored"], false)
		end
			local dataTable = { }
		
		table.insert(dataTable, { "account:newAccountHash", newAccountHash } )
		table.insert(dataTable, { "account:characters", characterList( client ) } )
		triggerClientEvent(client, "accounts:login:attempt", client, 0, dataTable  ) 

		exports.logs:dbLog("ac"..tostring(accountData["id"]), 27, "ac"..tostring(accountData["id"]), "Connected from "..getPlayerIP(client) .. " - "..getPlayerSerial(client))
		mysql:query_free("UPDATE `accounts` SET `ip`='" .. mysql:escape_string(getPlayerIP(client)) .. "', `mtaserial`='" .. mysql:escape_string(getPlayerSerial(client)) .. "' WHERE `id`='".. mysql:escape_string(tostring(accountData["id"])) .."'")	
		triggerEvent( "social:account", client, tonumber( accountData.id ) )
	else
		triggerClientEvent(client, "accounts:login:attempt", client, 1, "No combination found of the \nentered username/password." ) 
	end
end

function Login_calculateAutoLoginHash(username)
	local finalhash = ""
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for i = 1, 64 do
		local rand = math.random(#chars)
		finalhash = finalhash .. chars:sub(rand, rand)
	end
	mysql:query_free("UPDATE `accounts` SET `loginhash`='".. finalhash .."' WHERE `username`='".. mysql:escape_string(username) .."'")
	return finalhash
end

function quitPlayer(quitReason, reason)
	local accountID = tonumber(getElementData(source, "account:id"))
	if accountID then
		local affected = { "ac"..tostring(accountID) } 
		local dbID = getElementData(source,"dbid")
		if dbID then
			table.insert(affected, "ch"..tostring(dbID))
		end
		exports.logs:dbLog("ac"..tostring(accountID), 27, affected, "Disconnected ("..quitReason or "Unknown reason"..") (Name: "..getPlayerName(source)..")" )
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)