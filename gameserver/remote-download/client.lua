addEvent( "onClientGotImage", true )
addEventHandler( "onClientGotImage", resourceRoot,
    function( pixels )
        if myTexture then
            destroyElement( myTexture )
        end
        myTexture = dxCreateTexture( pixels )
    end
)
 
addEventHandler("onClientRender", root,
    function()
        if myTexture then
            local width,height = dxGetMaterialSize( myTexture )
			local sx, sy = guiGetScreenSize()
			local posX = (sx/2)-(width/2)
			local posY = (sy/2)-(height/2)
            dxDrawImage( posX,posY,width,height, myTexture )
			setTimer(function()
				cancelEvent()
			end, 5000, 1)
        end
    end
)