--[[
	*
	* SoundGroup Corporation - System
	* File: c_bots.lua
	* Author: Socialz
	* Created for Socialz's Gaming Community and United Gaming
	* Please do not redistribute this script in any way, if you want to use this script somewhere else, contact Socialz
	*
]]

local mode = nil
local rendering = false
local peds = {}
local following = nil

function findRotation(x1, y1, x2, y2)
	local t = -math.deg(math.atan2(x2-x1, y2-y1))
	if t < 0 then
		t = t
	end
	return t+180
end

addEvent("sync@follow", true)
addEventHandler("sync@follow", resourceRoot,
	function(ped, player, nmode)
		if not ped or not player or not nmode then return end
		if getElementType(ped) ~= "ped" then return end
		local id = tonumber(getElementData(ped, "npc:id"))
		mode = nmode
		peds[id] = ped
		following = player
		if nmode ~= 1 and getPedAnimation(ped) then
			setPedAnimation(ped)
		end
		if nmode == 1 or nmode == 0 then
			setPedControlState(ped, "sprint", false)
			setPedControlState(ped, "walk", false)
			setPedControlState(ped, "forwards", false)
			if nmode == 0 then
				following = nil
				peds = {}
				if rendering then
					removeEventHandler("onClientRender", root, renderAnimations)
					rendering = false
					mode = nil
				end
			end
		elseif nmode == 2 then
			setPedControlState(ped, "sprint", false)
			setPedControlState(ped, "walk", true)
			setPedControlState(ped, "forwards", true)
		elseif nmode == 3 then
			setPedControlState(ped, "sprint", false)
			setPedControlState(ped, "walk", false)
			setPedControlState(ped, "forwards", true)
		elseif nmode == 4 then
			setPedControlState(ped, "sprint", true)
			setPedControlState(ped, "walk", false)
			setPedControlState(ped, "forwards", true)
		end
		if not rendering then
			setPedVoice(ped, "PED_TYPE_DISABLED", "n/a")
			addEventHandler("onClientRender", root, renderAnimations)
			rendering = true
		end
	end
)

function renderAnimations()
	for _,v in pairs(peds) do
		if isElement(v) and isElement(following) and getElementData(v, "npc:following") then
			local x, y, z = getElementPosition(following)
			local px, py, pz = getElementPosition(v)
			setPedRotation(v, findRotation(x, y, px, py))
		end
	end
end