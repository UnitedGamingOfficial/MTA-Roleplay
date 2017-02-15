function news_update( player )
    callRemote( newsURL,
		function( title, text, author, date )
			if title == "ERROR" or not text or not author or not date then
				outputDebugString( "Fetching news failed." )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:title", "Error." )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:text", "There was an error fetching the news." )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:sub", "By: UnitedGaming Server" )
				if player then
					outputChatBox( "News failed: " .. text, player )
				end
			else
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:title", title )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:text", text )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:sub", "By: " .. author .. " on " .. date )
				if player then
					outputChatBox( "News set to: " .. title, player )
				end
			end
		end
	)
end

function rules_update(player)
	callRemote( rulesURL, 
		function( title, text)
			if title == "ERROR" or not text or not author or not date then
				outputDebugString( "Fetching rules failed." )
				if player then
					outputChatBox( "News failed: " .. text, player )
				end
			else
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "rules:text", text )
				if player then
					outputChatBox( "Rules set to: " .. title, player )
				end
			end
		end
	)
end

function patchNotes_update(player)
	callRemote("www.unitedgaming.org/server/patchnotes.php", 
		function( title, text)
			if title == "ERROR" or not text or not author or not date then
				outputDebugString( "Fetching patch notes failed.")
				if player then
					outputChatBox( "Patch notes failed: " .. text, player )
				end
			else
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "patchnotes:text", text )
				if player then
					outputChatBox( "Patch notes set to: " .. title, player )
				end
			end
		end
	)
end

function adminRules_update(player)
	callRemote("www.unitedgaming.org/server/adminrules.php", 
		function( title, text)
			if title == "ERROR" or not text or not author or not date then
				outputDebugString( "Fetching admin rules failed." )
				if player then
					outputChatBox( "Admin rules failed: " .. text, player )
				end
			else
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "adminrules:text", text )
				if player then
					outputChatBox( "Admin rules set to: " .. title, player )
				end
			end
		end
	)
end

-- Fetch news every so often
setTimer( news_update, 30 * 60000, 0 )
setTimer( rules_update, 30 * 60000, 0)
setTimer( patchNotes_update, 30 * 60000, 0)
setTimer( adminRules_update, 30 * 60000, 0)

-- Initial update
news_update( )
rules_update( )
patchNotes_update( )
adminRules_update()

addCommandHandler( "updateadminrules",
	function( player )
		if exports.global:isPlayerAdmin( player ) then
			adminRules_update( player )
			outputChatBox( "Fetching admin rules...", player )
		end
	end 
)

addCommandHandler( "updatepatchnotes",
	function( player )
		if exports.global:isPlayerAdmin( player ) then
			patchNotes_update( player )
			outputChatBox( "Fetching patch notes...", player )
		end
	end 
)

addCommandHandler( "updatenews",
	function( player )
		if exports.global:isPlayerAdmin( player ) then
			news_update( player )
			outputChatBox( "Fetching news...", player )
		end
	end
)

addCommandHandler( "updaterules",
	function( player )
		if exports.global:isPlayerAdmin( player ) then
			rules_update( player )
			outputChatBox( "Fetching rules...", player )
		end
	end
)