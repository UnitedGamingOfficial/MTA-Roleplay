local bans = 
{
	--[["141.35.*.*", -- mabako uni
	"141.33.*.*", -- mabako uni
	"141.32.*.*", -- mabako uni
	"141.31.*.*", -- mabako uni
	"79.215.*.*", -- mabako home]]
	--"66.27.*.*" -- maccer
	
	"212.92.*.*", -- Tailor Joe
	"41.249.*.*", -- Joe Harisson
	--"120.60.*.*", -- Edd Brown
	"79.230.*.*" -- Denis petrenko

}

local serials = 
{
	--"811273FEC91818AFAE83240291B67A93", --mabako
	--"10FFF3A458F598F56419C5007D1638A4", -- mabako notebook
	--"58871EE55815F344DBE19113522A1602" -- maccer
	"139E1C55D34268ABF758FF325B870444" -- Denis petrenko
}

local whitelist = 
{
	--"79.215.237.228" -- kays friend
}

local securityConnections = {
	["Bean"] = { { "523BE7A4126C38EAF4810E7920178053", "7EE99333B49065EA198BA5CF9CA196B3" }, { "174.100.146.91", "127.0.0.1" } }
}

-- For use with account system.
function getSecurityConnections( )
	return securityConnections
end


addEventHandler ("onPlayerConnect", getRootElement(), 
	function(playerNick, playerIP, playerUsername, playerSerial, playerVersion)
	
		for _, v in pairs( serials ) do
			if (playerSerial == v) then
				exports.global:sendMessageToAdmins("AdmWrn: Denied " .. playerIP .. "/"..playerVersion.."/"..playerNick.."/(("..playerSerial..")) from the server, rangeban")
				cancelEvent( true, "You are banned from this server." )
			end
		end
		
		for _, v in pairs( bans ) do
			if string.find( playerIP, "^" .. v .. "$" ) then
				local whitelisted = false
				for _, vv in ipairs(whitelist) do
					if (playerIP == vv) then
						whitelisted = true
					end
				end
				
				if not whitelisted then
					exports.global:sendMessageToAdmins("AdmWrn: Denied ((" .. playerIP .. "))/"..playerVersion.."/"..playerNick.."/"..playerSerial.." from the server, rangeban")
					cancelEvent( true, "You are banned from this server." )
				end
			end
		end
	end
)