function startImageDownload( thePlayer, commandName, url )
	if not fetchRemote(url, myCallback, "", false, thePlayer ) then
		outputChatBox("Invalid Link", thePlayer, 255,0,0)
	end
end
addCommandHandler("downloadtome", startImageDownload)

function myCallback( responseData, errno, thePlayer )
    if errno == 0 then
        triggerClientEvent( thePlayer, "onClientGotImage", resourceRoot, responseData )
    end
end

