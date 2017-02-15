local sx, sy = guiGetScreenSize()
local scrSrc = dxCreateScreenSource(sx, sy)

local shaderFX = dxCreateShader("tinted_windows.fx", 1, 200, true)

function goodWindowTint()
	for key,veh in ipairs(getElementsByType("vehicle")) do
		if (getElementData(veh, "tinted") == true) then
			engineApplyShaderToWorldTexture(shaderFX, "vehiclegeneric256", veh)
			engineApplyShaderToWorldTexture(shaderFX, "hotdog92glass128", veh)
			engineApplyShaderToWorldTexture(shaderFX, "okoshko", veh)
			engineApplyShaderToWorldTexture(shaderFX, "@hite", veh)
		else
			engineRemoveShaderFromWorldTexture( shaderFX, "vehiclegeneric256", veh )
			engineRemoveShaderFromWorldTexture( shaderFX, "hotdog92glass128", veh )
			engineRemoveShaderFromWorldTexture( shaderFX, "okoshko", veh )
			engineRemoveShaderFromWorldTexture( shaderFX, "@hite", veh )
		end
	end
	for _, veh in ipairs(getElementsByType("vehicle")) do
		if (getElementData(veh, "dbid") == 9311) then
			local shader, tec = dxCreateShader ( "texreplace.fx" )
			local tex = dxCreateTexture ( "textures/elegy.png")
			engineApplyShaderToWorldTexture ( shader, "elegy3body256", veh )
			engineApplyShaderToWorldTexture ( shader, "elegy3body256lod", veh )
			dxSetShaderValue ( shader, "gTexture", tex )
		end
		if (getElementData(veh, "dbid") == 491) or (getElementData(veh, "dbid") == 9312) then
			local shader, tec = dxCreateShader ( "texreplace.fx" )
			local tex = dxCreateTexture ( "textures/elegy2.png")
			engineApplyShaderToWorldTexture ( shader, "elegy3body256", veh )
			engineApplyShaderToWorldTexture ( shader, "elegy3body256lod", veh )
			dxSetShaderValue ( shader, "gTexture", tex )
		end
		if (getElementData(veh, "dbid") == 341) then
			local shader, tec = dxCreateShader ( "texreplace.fx" )
			local tex = dxCreateTexture ( "textures/theno_monster.png" )
			engineApplyShaderToWorldTexture(shader, "monstera92body256a", veh)
			dxSetShaderValue(shader, "gTexture", tex)
		end
		if (getElementData(veh, "faction") == 45) then
			local shader, tec = dxCreateShader ( "texreplace.fx" )
			local tex = dxCreateTexture ( "textures/sasp.png")
			engineApplyShaderToWorldTexture ( shader, "vehiclepoldecals128", veh )
			engineApplyShaderToWorldTexture ( shader, "vehiclepoldecals128lod", veh )
			dxSetShaderValue ( shader, "gTexture", tex )
		end
		if (getElementData(veh, "dbid") == 331) then
			local shader, tec = dxCreateShader ( "texreplace.fx" )
			local tex = dxCreateTexture ( "textures/chuevo.png")
			engineApplyShaderToWorldTexture ( shader, "vehiclepoldecals128", veh )
			engineApplyShaderToWorldTexture ( shader, "vehiclepoldecals128lod", veh )
			dxSetShaderValue ( shader, "gTexture", tex )
		end
    end
end
addEvent("legitimateResponceRecived", true)
addEventHandler("legitimateResponceRecived", getRootElement(), goodWindowTint)

function startTheRes()
	triggerServerEvent("tintDemWindows", getLocalPlayer())
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), startTheRes)
addEventHandler("onVehicleRespawn", getResourceRootElement(getThisResource()), startTheRes)
addEvent("tintWindows", true)
addEventHandler("tintWindows", getRootElement(), startTheRes)