--[[ GUI Editor (server) ]]--

local sharedCode = {}

function OutputGUIToFile(text,valuetype)
	local file = fileOpen("GUIEditor_output.txt") 
	
	if not file then
		file = fileCreate("GUIEditor_output.txt")
		outputDebugString("Creating GUIEditor_output.txt")
	end
    
	if file then    
		local time = getRealTime()
	
		fileSetPos(file,fileGetSize(file))
		local written = fileWrite(file,"\r\n",string.format("-- Created: %02s/%02s/%04s %02s:%02s\r\n",
						tostring(time.monthday),
						tostring(time.month + 1),
						tostring(time.year + 1900),
						tostring(time.hour),
						tostring(time.minute)),		
						text,"\r\n--- --- --- --- ---\r\n")
		fileFlush(file)
		fileClose(file)
		if written then
			outputChatBox("Succesfully saved to GUIEditor_output.txt",source)
			outputChatBox(valuetype,source)
		end
	else
		outputDebugString("GUIEditor: Cannot find or create guieditor_output.txt")
	end
end
addEvent("OutputGUIToFile",true)
addEventHandler("OutputGUIToFile",root,OutputGUIToFile)


function ServerLoadImageTable()
	local res,table_,xml = getThisResource(), {}, xmlLoadFile("meta.xml",res)
    if xml then
		local i = 0
		while (xmlFindChild(xml, "file", i)) do  
			local dir = xmlNodeGetAttribute(xmlFindChild(xml, "file", i), "src")
			if dir:find("images/")~=nil then
				table.insert(table_,dir)
			end
			i = i + 1
		end  	
	end
	
	--for i,v in ipairs(table_) do
	--	outputChatBox(v)
	--end
	
	triggerClientEvent(source,"ClientReceiveImageTable",root,table_)
end
addEvent("ServerLoadImageTable",true)
addEventHandler("ServerLoadImageTable",root,ServerLoadImageTable)


addEvent("getEditorVersion",true)
addEventHandler("getEditorVersion",root,function()
	triggerClientEvent(client,"receiveEditorVersion",client,getResourceInfo(getThisResource(),"version"))
end)
	

function checkForUpdates(manual)
	local player = client
	local called = callRemote("http://community.mtasa.com/mta/resources.php",function(n,v) updateResult(n,v,player,manual) end,"version",string.lower(getResourceName(getThisResource())))
	
	if not called then
	--	outputChatBox("Error: Check ACL permissions and website availability.")
		triggerClientEvent(client,"receiveUpdateCheck",client,nil)
	end
end	
addEvent("checkUpdateStatus",true)
addEventHandler("checkUpdateStatus",root,checkForUpdates)


function updateResult(name,version,player,manual)
	local update = false
	
	if string.lower(name):find("error") or version == 0 then update = nil end
	
	if update == false then
		local v1,v2,v3 = parseVersion(tostring(version))

		local cv1,cv2,cv3 = parseVersion(tostring(getResourceInfo(getThisResource(),"version")))
		
		if v1 and cv1 then
			if v1 > cv1 then update = true
			elseif v2 > cv2 then update = true
			elseif v3 > cv3 then update = true
			end
		end
	end

	triggerClientEvent(player,"receiveUpdateCheck",player,update,version,tostring(getResourceInfo(getThisResource(),"version")),manual)
end


function parseVersion(version)
	local parts = split(version,string.byte("."))
	
	return parts[1],parts[2],parts[3]
end


	
-- needed as of 1.0 to get a list of gui elements
-- no longer needed as of 1.0.1
--[[
function GetResourcesForOutput(arg1,arg2)
	local resources = {}
	
	for _,res in ipairs(getResources()) do
		if getResourceState(res) == "running" then
			table.insert(resources,getResourceName(res))
		end
	end
	
	triggerClientEvent(source,"RecieveResourcesForOutput",getRootElement(),resources,arg1,arg2)
end
addEvent("GetResourcesForOutput",true)
addEventHandler("GetResourcesForOutput",getRootElement(),GetResourcesForOutput)
]]


function loadOutputCode()
	local code = ""

	local file = fileOpen("GUIEditor_output.txt") 
    
	if file then  
		local size = fileGetSize(file)
		if size and tonumber(size) and tonumber(size) > 0 then
			code = fileRead(file,tonumber(size))
			
			if code then
				code = parseOutputCode(code)
				
				triggerClientEvent(source,"receiveLoadedCode",source,code)
			else
				triggerClientEvent(source,"receiveLoadedCode",source,nil)
			end
		else
			triggerClientEvent(source,"receiveLoadedCode",source,nil)
		end
	else
		outputDebugString("Cannot find GUIEditor_output.txt")
		triggerClientEvent(source,"receiveLoadedCode",source,nil)
	end
end
addEvent("loadGUICode",true)
addEventHandler("loadGUICode",root,loadOutputCode)


function parseOutputCode(code)
	local sections = {}
		
	while true do
		local s,e = code:find("--- --- --- --- ---",1,true)
		
		if not s then break end
		
		local section = code:sub(1,s-1)
		
		local ss,se = section:find("-- Created:",1,true)
		local d = ""
		
		if ss then
			d = code:sub(se+2,se+18)
			section = section:sub(se+18)
		end
		
		sections[#sections+1] = {c = section, date = d}
		
		code = code:sub(e)
	end
	
--	for i,v in ipairs(sections) do
--		outputChatBox("coded on: "..tostring(v.date)..".")
--	end
	
	return sections
end


addEvent("requestPlayerGUI",true)
addEventHandler("requestPlayerGUI",root,function(player)
	if sharedCode[player] then
		triggerClientEvent(client,"receiveSharedCode",client,sharedCode[player])
	end
end)


addEvent("sendSharedCode",true)
addEventHandler("sendSharedCode",root,function(code)
	sharedCode[client] = code
end)