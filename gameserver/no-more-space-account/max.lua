mysql = exports.mysql
function drug (player, cmd)
	local accountsList = {}
	if exports.global:isPlayerScripter(player) then
		mQuery1 = mysql:query("SELECT `id`, `username` FROM `accounts` WHERE `username` LIKE '% %'")
		if mQuery1 then
			while true do
				local row = mysql:fetch_assoc(mQuery1)
				if not row then break end
				table.insert(accountsList, { row["id"], row["username"] } )
			end
			mysql:free_result(mQuery1)
			
			local i = 0
            for _, record in ipairs(accountsList) do
				local fixedUsername = tostring(record[2]):gsub(" ", "_")
				outputChatBox(fixedUsername.." - ID #"..record[1],getRootElement(), 0, 255,0)
				mQuery2 = mysql:query_free("UPDATE `accounts` SET `username`= '"..fixedUsername.."' WHERE `id` = '"..record[1].."'")
				if mQuery2 then
					i = i + 1
				end
            end      
			outputChatBox(i.." account names have been renamed!",getRootElement(), 0, 255,0)
		end
	end
end
addCommandHandler("nospace",drug, false, false )