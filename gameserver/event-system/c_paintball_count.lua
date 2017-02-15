local currentCount = -1
local guiImage = nil

function startCountDown( count )
	if not count or count < 1 then
		return
	end
	
	if not (currentCount == -1) then
		return
	end
	currentCount = count + 1
	doCountDown( )
	setTimer ( doCountDown, 1000, count + 1 )
	
end
addEvent("paintball:countdown", true)
addEventHandler("paintball:countdown", getRootElement(), startCountDown)

function doCountDown()
	currentCount = currentCount - 1

	if (isElement(guiImage)) then
		guiSetVisible ( guiImage, false )
		destroyElement( guiImage )
		guiImage = nil
	end
	
	if (currentCount ~= -1) then
		guiImage = guiCreateStaticImage(0.5,0.5,0.5,0.5,"images/countdown/".. currentCount ..".png",true)
	end
end