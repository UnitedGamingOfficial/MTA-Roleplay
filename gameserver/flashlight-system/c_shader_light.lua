local isLightOn = false
local light_shader = {}
local flashlight = {}
local shader_jaroovka = {}
local shader_rays = {}
local isFlon = {}
local isFLen = {}
local fLInID = {}
local fLInID = {}
local lightColor = {1, 1, 0.7, 0.65}
local effectRange = 85
local isFakeBump = true
local isLightDir = true
local lightDirAcc = 0.2
local maxEffectSwitch = 47
local DistFade = {85, 60, 40, 1}
local objID = 15060
local theTikGap = 0
local getLastTick = getTickCount()-(theTikGap*1000)
local textureCube = dxCreateTexture("textures/cubebox.dds")

local removeList = {
	"",
	"basketball2", "skybox_tex", "drvin_screen",
	"flashlight*", "crackedground*",
	"roughcornerstone*",
	"muzzle_texture*",
	"font*", "radar*",
	"*headlight*",
	"*shad*",
	"coronastar", "coronamoon", "coronaringa",
	"lunar",
	"tx*",
	"lod*",
	"cj_w_grad",
	"*cloud*",
	"*smoke*",
	"sphere_cj",
	"particle*",
	"water*", "sw_sand", "coral",
	"boatwake*", "splash_up", "carsplash_*",
	"gensplash", "wjet4", "bubbles",
	"blood*"
}

function renderLight()
	for _,thisPed in ipairs(getElementsByType("player")) do
		if (light_shader[thisPed]) then
			xx1, yy1, zz1, lxx1, lyy1, lzz1,rl = getCameraMatrix()
			x1, y1, z1 = getPedBonePosition(thisPed, 24)
			lx1, ly1, lz1 = getPedBonePosition(thisPed, 25)
			
			local yaw = math.atan2(lx1-x1, ly1-y1)
			local pitch = (math.atan2(lz1-z1, math.sqrt(((lx1-x1)*(lx1-x1))+((ly1-y1)*(ly1-y1)))))
			local roll = 0
			local movx = xx1-x1
			local movy = yy1-y1
			local movz = zz1-z1
			
			dxSetShaderValue(light_shader[thisPed], "rotate", yaw, roll, pitch)	
			dxSetShaderValue(light_shader[thisPed], "alterPosition", movx, movy, movz)
		end
	end
end

function createFlashlightModel(thisPed)
	if (not flashlight[thisPed]) then
		flashlight[thisPed] = createObject(objID, 0, 0, 0, 0, 0, 0, true)
		exports.bone_attach:attachElementToBone(flashlight[thisPed], thisPed, 12, 0, 0.015, 0.2, 0, 0, 0)
	end
end

local function destroyFlashlightModel(thisPed)
	if (flashlight[thisPed]) then
		exports.bone_attach:detachElementFromBone(flashlight[thisPed])
		destroyElement(flashlight[thisPed])
		flashlight[thisPed] = nil
	end
end

function createWorldLightShader(thisPed)
	if (light_shader[thisPed]) then return end
	light_shader[thisPed] = dxCreateShader("shaders/shader_light.fx", 1, effectRange, true, "world,object,vehicle,ped")
	if (not light_shader[thisPed]) then return end
	dxSetShaderValue(light_shader[thisPed], "sCubeTexture", textureCube)
	dxSetShaderValue(light_shader[thisPed], "isLightDir", isLightDir)
	dxSetShaderValue(light_shader[thisPed], "isFakeBump", isFakeBump)
	dxSetShaderValue(light_shader[thisPed], "lightColor",lightColor)
	dxSetShaderValue(light_shader[thisPed], "lightDirAcc", lightDirAcc)
	dxSetShaderValue(light_shader[thisPed], "DistFade",DistFade)
	engineApplyShaderToWorldTexture(light_shader[thisPed], "*")
	
	for _,removeMatch in ipairs(removeList) do
		engineRemoveShaderFromWorldTexture(light_shader[thisPed], removeMatch)
	end
end

function destroyWorldLightShader(thisPed)
	if (light_shader[thisPed]) then
		engineRemoveShaderFromWorldTexture(light_shader[thisPed], "*")
		destroyElement(light_shader[thisPed])
		light_shader[thisPed] = nil
	end
end

function createFlashLightShader(thisPed)
	if (not flashlight[thisPed]) then return false end
	if (not shader_jaroovka[thisPed]) or (shader_rays[thisPed]) then
		shader_jaroovka[thisPed] = dxCreateShader("shaders/shader_jaroovka.fx", 0, 0, false)
		shader_rays[thisPed] = dxCreateShader("shaders/flash_light_rays.fx", 0, 0, false)
		if (not shader_jaroovka[thisPed]) or (not shader_rays[thisPed]) then return end
		engineApplyShaderToWorldTexture(shader_jaroovka[thisPed], "flashlight_L", flashlight[thisPed])
		engineApplyShaderToWorldTexture(shader_rays[thisPed], "flashlight_R", flashlight[thisPed])	
		dxSetShaderValue(shader_jaroovka[thisPed], "lightColor", lightColor)
		dxSetShaderValue(shader_rays[thisPed], "lightColor", lightColor)
	end
end

function destroyFlashLightShader(thisPed)
	if (shader_jaroovka[thisPed]) or (shader_rays[thisPed]) then
		destroyElement(shader_jaroovka[thisPed])
		destroyElement(shader_rays[thisPed])
		shader_jaroovka[thisPed] = nil
		shader_rays[thisPed] = nil
	end
end

function playSwitchSound(this_player)
	pos_x, pos_y, pos_z = getElementPosition(this_player)
	local flSound = playSound3D("sounds/switch.wav", pos_x, pos_y, pos_z, false)
	setSoundMaxDistance(flSound, 40)
	setSoundVolume(flSound, 0.6)
end


addEvent("flashOnPlayerEnable", true)
addEventHandler("flashOnPlayerEnable", resourceRoot,
	function(isEN, this_player)
		if (isEN == true) then
			isFLen[this_player] = isEN
		else
			isFLen[this_player] = isEN
		end
	end
)

addEvent("flashOnPlayerSwitch", true)
addEventHandler("flashOnPlayerSwitch", resourceRoot,
	function(isON, this_player)
		if (isElementStreamedIn(this_player)) and (isFLen[this_player]) then playSwitchSound(this_player) end
		if (isON) then
			isFlon[this_player] = true
		else
			isFlon[this_player] = false
		end
	end
)

addEvent("flashOnPlayerQuit", true)
addEventHandler("flashOnPlayerQuit", resourceRoot,
	function(this_player)
		destroyWorldLightShader(this_player)
		destroyFlashlightModel(this_player)
		destroyFlashLightShader(this_player)
	end
)

function streamInAndOutFlEffects()
	for _,this_player in ipairs(getElementsByType("player")) do
		local cam_x, cam_y, cam_z, _, _, _ = getCameraMatrix()
		local player_x, player_y, player_z = getElementPosition(this_player)
		local getDist = getDistanceBetweenPoints3D(cam_x, cam_y, cam_z, player_x, player_y, player_z)
		if (isElementStreamedIn(this_player)) and (getDist <= maxEffectSwitch) then
			if (not light_shader[this_player]) and (isFlon[this_player] == true) then
				createWorldLightShader(this_player)
			end 
			if (light_shader[this_player]) and (isFlon[this_player] == false) then	
				destroyWorldLightShader(this_player) 
			end
		end
		if (not isElementStreamedIn(this_player) or getDist > maxEffectSwitch) and (light_shader[this_player]) and (isFlon[this_player] == true) then 
			destroyWorldLightShader(this_player)		
		end
	end
end

function streamInAndOutFlModel()
	for _,this_player in ipairs(getElementsByType("player")) do
		if (fLInID[this_player] == nil) then fLInID[this_player] = 0 end
		if (isElementStreamedIn(this_player)) and (isFLen[this_player] == true) and (fLInID[this_player] ~= getElementInterior(this_player)) then
			triggerServerEvent("onPlayerGetInter", this_player)
		end
		
		if (isElementStreamedIn(this_player)) and (not flashlight[this_player]) and (isFLen[this_player] == true) then
			createFlashlightModel(this_player)
			if (fLInID[this_player] ~= nil) then setElementInterior(flashlight[this_player], fLInID[this_player]) end
		end
		
		if (isElementStreamedIn(this_player)) and (flashlight[this_player]) and (isFLen[this_player] == false) then
			destroyFlashlightModel(this_player)
		end
		
		if (isElementStreamedIn(this_player)) and (not shader_rays[this_player]) and (isFlon[this_player] == true) then
			createFlashLightShader(this_player)
		end
		
		if (isElementStreamedIn(this_player) or not isElementStreamedIn(this_player)) and (shader_rays[this_player]) and (isFlon[this_player] == false) then
			destroyFlashLightShader(this_player)
		end
	end
end

addEvent("flashOnPlayerInter", true)
addEventHandler("flashOnPlayerInter", resourceRoot,
	function(this_player, interiorID)
		if (flashlight[this_player]) then
			fLInID[this_player] = interiorID
			if (flashlight[this_player]) then setElementInterior(flashlight[this_player], fLInID[this_player]) end
		end
	end
)

function toggleLight()
	if (getTickCount() - getLastTick < theTikGap*1000) then return end
	if (isLightOn == false) then isLightOn = true else isLightOn = false end
	triggerServerEvent("onSwitchLight", localPlayer, isLightOn)
	getLastTick = getTickCount()
end

function toggleFlashLight(arg)
	if (arg) and (arg == 2) then
		if (flashlight[localPlayer]) then
			triggerServerEvent("sendLocalMeAction", root, localPlayer, "turns off their flashlight.")
			triggerServerEvent("onSwitchLight", localPlayer, false)
			triggerServerEvent("onSwitchEffect", localPlayer, false)
		end
		return
	end
	
	if (flashlight[localPlayer]) then
		triggerServerEvent("sendLocalMeAction", root, localPlayer, "turns off their flashlight.")
		triggerServerEvent("onSwitchLight", localPlayer, false)
		triggerServerEvent("onSwitchEffect", localPlayer, false)
	else
		triggerServerEvent("sendLocalMeAction", root, localPlayer, "turns on their flashlight.")
		triggerServerEvent("onSwitchLight", localPlayer, false)
		triggerServerEvent("onSwitchEffect", localPlayer, true)
	end
	toggleLight()
end
addEvent("onFlashlightToggle", true)
addEventHandler("onFlashlightToggle", root, toggleFlashLight)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local ver = getVersion().sortable
		local build = string.sub(ver, 9, 13)
		
		if (build < "04938") or (ver < "1.3.1") then
			return
		end
		
		engineImportTXD(engineLoadTXD("objects/flashlight.txd"), objID) 
		engineReplaceModel(engineLoadDFF("objects/flashlight.dff", 0), objID, true)
		addEventHandler("onClientPreRender", root, renderLight)
		addEventHandler("onClientRender", root, streamInAndOutFlEffects)
		addEventHandler("onClientRender", root, streamInAndOutFlModel)
		triggerServerEvent("onPlayerStartRes", localPlayer)
	end
)