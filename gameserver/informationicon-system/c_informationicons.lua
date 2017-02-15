-- Done by Anthony
local informationicons = { }

function showNearbyInformationIconsInformation()
	for index, informationicon in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "pickup") ) do -- change to object for i object
			informationicons[index] = informationicon
	end
	showInformationText()
end
addEventHandler("onClientRender", getRootElement(), showNearbyInformationIconsInformation)

function showInformationText()
	for i = 1, #informationicons, 1 do
	if isElement(informationicons[i]) then
		local x,y,z = getElementPosition(informationicons[i])			
        local cx,cy,cz = getCameraMatrix()
		local information = getElementData(informationicons[i], "informationicon:information")
		if information then
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 30 then
				local px,py,pz = getScreenFromWorldPosition(x,y,z+0.5,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, true, true, true, true, false, false) then
					dxDrawText("* " .. information .. " *", px, py, px, py, tocolor(255, 51, 102, 255), 1, "default-bold", "center", "center", false, false)
				else
				end
			end
		end
	end
	end
end
addEventHandler("onResourceStart", getRootElement(), showInformationText)

