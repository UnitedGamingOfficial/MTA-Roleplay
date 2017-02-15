-- old one with CJ walk | local validWalkingStyles = { [0]=true, [54]=true, [55]=true, [56]=true, [57]=true, [58]=true, [59]=true, [60]=true, [61]=true, [62]=true, [63]=true, [64]=true, [65]=true, [66]=true, [67]=true, [68]=true, [69]=true, [118]=true, [119]=true, [120]=true, [121]=true, [122]=true, [123]=true, [124]=true, [125]=true, [126]=true, [127]=true, [128]=true, [129]=true, [130]=true, [131]=true, [132]=true, [133]=true, [134]=true, [135]=true, [136]=true, [137]=true, [138]=true }
local validWalkingStyles = { [55]=true, [57]=true, [58]=true, [59]=true, [60]=true, [61]=true, [62]=true, [63]=true, [64]=true, [65]=true, [66]=true, [67]=true, [68]=true, [118]=true, [119]=true, [120]=true, [121]=true, [122]=true, [123]=true, [124]=true, [125]=true, [126]=true, [127]=true, [128]=true, [129]=true, [130]=true, [131]=true, [132]=true, [133]=true, [134]=true, [135]=true, [136]=true, [137]=true, [138]=true }

function setWalkingStyle(thePlayer, commandName, walkingStyle)
	if not walkingStyle or not validWalkingStyles[tonumber(walkingStyle)] or not tonumber(walkingStyle) then
		outputChatBox("Invalid walking style ID.", thePlayer, 255, 0, 0)
		outputChatBox("SYNTAX: /" .. commandName .. " [Walking Style ID]", thePlayer, 255, 194, 14)
		outputChatBox("'/walklist' to list all valid walking style IDs.", thePlayer, 255, 194, 14)
	else
		local dbid = getElementData(thePlayer, "dbid")
		local updateWalkingStyleSQL = exports.mysql:query_free("UPDATE `characters` SET `walkingstyle`='" .. exports.mysql:escape_string(tonumber(walkingStyle)) .. "' WHERE `id`='".. exports.mysql:escape_string(tostring(dbid)) .."'")
		if updateWalkingStyleSQL then
			setElementData(thePlayer, "walkingstyle", walkingStyle)
			triggerClientEvent("updateWalkingStyle", getRootElement(), walkingStyle, thePlayer)
			outputChatBox("Walking style successfully set to: " .. walkingStyle, thePlayer, 0, 255, 0)
		else
			outputChatBox("Walking style could not be set. Error 1337 - Report on mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwalkingstyle", setWalkingStyle)
addCommandHandler("setwalk", setWalkingStyle)

function walkStyleList(thePlayer, commandName)
	outputChatBox("Walking style IDs list:", thePlayer, 255, 194, 14)
	outputChatBox("55, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 118", thePlayer, 100, 194, 14)
	outputChatBox("119, 120, 121, 122, 123, 124, 125, 126, 127, 128", thePlayer, 100, 194, 14)
	outputChatBox("129, 130, 131, 132, 133, 134, 135, 136, 137, 138", thePlayer, 100, 194, 14)
end
addCommandHandler("walklist", walkStyleList)