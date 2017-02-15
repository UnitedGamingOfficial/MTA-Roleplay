--[[
************************************
* MTA REALISTIC NIGHT SHADER
************************************
*
* @author		Jesseunit
* @link			http://jsiau.site11.com
* @info			An uncompiled script, hooray.
* @version		1.0
]]--

local maxDarkness = 0.35 -- [1] = lightest || [0] = darkest
local speed = 0.001

-- Default variables you shouldn't alter.
local b = 1
local shaderList = {}
local fading = false

-- Feel free to add more removables.
local removables = {
	'tx*',
	'coronastar',
	'shad_exp*',
	'radar*',
	'*icon',
	'font*',
	'lampost_16clr',
	'headlight',
	'vehiclegeneric256',
	'bullethitsmoke',
}

function night_init()
	if getVersion ().sortable < '1.1.0' then
		outputChatBox('Night shader is not compatible with this client.')
		return false
	end

	local testShader, tec = dxCreateShader('night.fx')
	if not testShader then
		outputChatBox('Could not create night shader. Please use debugscript 3')
	else
		for c=65,96 do
			local clone = dxCreateShader('night.fx')
			engineApplyShaderToWorldTexture(clone, string.format('%c*', c + 32))
			for i,v in pairs(removables) do
				engineRemoveShaderFromWorldTexture(clone, v)
			end
			table.insert(shaderList, clone)
		end
	end

	addEventHandler('onClientHUDRender', root, night_render)
	nightTimer = setTimer(night_check, 1000, 0)
end

function night_check()
	local hours, minutes = getTime()
	if hours >= 5 and hours < 12 then
		fading = false
	elseif hours >= 12 and hours < 15 then
		fading = false
	elseif hours >= 15 and hours < 21 then
		fading = false
	elseif hours >= 21 and hours < 5 then
		fading = false
	else
		fading = true
	end
end

function night_render()
	local int, dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
	if fading then
		if b > maxDarkness then
			b = b - speed
		elseif b <= maxDarkness then
			b = maxDarkness
		end
	else
		if b < 1.0 then
			b = b + speed
		elseif b >= 1.0 then
			b = 1.0
		end
	end
	for _,shader in ipairs(shaderList) do
		if int == 0 and dim == 0 then
			dxSetShaderValue(shader, 'NIGHT', b, b, b)
		else
			dxSetShaderValue(shader, 'NIGHT', 1.0, 1.0, 1.0)
		end
	end
end

night_init()