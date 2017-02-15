if not (hasObjectPermissionTo(getThisResource(), "general.ModifyOtherObjects")) then
    error("Permission Denied ('general.ModifyOtherObjects')");
	return false;
end

local resourceData={};
local playerData={};
local controlSessions={};
local string = string;
local math = math;
local table = table;
local strsub = string.sub;
local strlen = string.len;
local strbyte = string.byte;
local strfind = string.find;
local version = getVersion();

local accountData={};
local defaultAccount = {};

local transactionPacketBytes=1200;

-- Temporily disable instruction count hook
debug.sethook(nil);

-- Init all configuration files
local pAccessConfig = xmlLoadFile("access.xml");

if not (pAccessConfig) then
	pAccessConfig = xmlCreateFile("access.xml", "access");
end

local pConfig = xmlLoadFile("config.xml");

if not (pConfig) then
	local xml = xmlLoadFile("default/server_config.xml");
	
	pConfig = xmlCopyFile(xml, "config.xml");
	
	xmlUnloadFile(xml);
end

function getFileExtension(src)
    local lastOffset;
    local begin, last = string.find(src, "[.]");

    while (begin) do
        lastOffset = begin+1;
        begin, last = string.find(src, "[.]", lastOffset);
    end
    
    return string.sub(src, lastOffset, string.len(src));
end

-- Thanks to gwell from stackoverflow.com
-- convert bytes (network order) to a 32-bit two's complement integer
function bytes_to_int(b1, b2, b3, b4)
  return b1*16777216 + b2*65536 + b3*256 + b4;
end

function loadResource(pResource)
    local pEntry = {
		resource = pResource,
		name = getResourceName(pResource),
		type = "",
		author = "",
		authorserial = "",
		description = "",
		realname = "",
		
		files = {},
		scripts = {},
		maps = {}
	};
	
	function pEntry.addFile(src, type)
		local pFile = pEntry.getFileFromSource(src);
		local path, isFile;
		
		if not (type) then
			type = "client";
		end
	
		if (pFile) then
			if (type == "server") and (pFile.type == "client") or (type == "client") and (pFile.type == "server") then
				pFile.type = "shared";
			else
				return false;
			end
			
			return pFile, true;
		end
		
		path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		pFile = {
			src = path,
			type = type
		};
		
		-- We have to scan files here if its below MTA1.1
		if (version.number < 272) then
			pFile.ext = getFileExtension(path);
			
			if (pFile.ext == "png") then
				-- We have to get the width and height the client cannot get
				local filename = ":" .. pEntry.name .. "/" .. path;
				local png = fileOpen(filename);
				
				if (png) then
					fileSetPos(png, 16);
					
					local width = fileRead(png, 4);
					pFile.width = bytes_to_int(string.byte(width, 1, 4));
					local height = fileRead(png, 4);
					pFile.height = bytes_to_int(string.byte(height, 1, 4));
					
					print("Loaded PNG file '" .. filename .. "' (" .. pFile.width .. ", " .. pFile.height .. ")");
					
					fileClose(png);
				else
					outputDebugString("Could not read '" .. filename .. "'", 2);
				end
			end
		end
		
		table.insert(pEntry.files, pFile);
		
		return pFile, false;
	end
	
	function pEntry.addScript(src, type)
		local script = pEntry.getScriptFromSource(src);
		local path, isFile;
		
		if not (type) then return false; end;
		
		if (script) then
			if (type == "server") and (script.type == "client") or (type == "client") and (script.type == "server") then
				script.type = "shared";
			else
				return false;
			end
			
			return script, true;
		end
		
		path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		script = {
			src = path,
			type = type
		};
		
		table.insert(pEntry.scripts, script);
		
		return script, false;
	end
	
	function pEntry.addMap(src)
		local map, existed = pEntry.addFile(src, "server");
		
		if not (map) then return false; end;
		
		if (existed) then
			map = pEntry.getMapFromSource(src);
			
			if (map) then return map; end;
		
			pEntry.removeFileFromSource(src);
			
			map = pEntry.addFile(src, "server");
		end
		
		-- Good job fixing client->server, lil_Toady, but I actually need server->client
		map = {
			src = map.src,
			type = "server"
		};
	
		table.insert(pEntry.maps, map);
		return map;
	end
	
	function pEntry.removeFileFromSource(src)
		local m,n;
		local path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		for m,n in ipairs(pEntry.files) do
			if (n.src == path) then
				table.remove(pEntry.files, m);
				return true;
			end
		end
		
		return false;
	end
	
	function pEntry.removeScriptFromSource(src)
		local m,n;
		local path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		for m,n in ipairs(pEntry.scripts) do
			if (n.src == path) then
				table.remove(pEntry.scripts, m);
				return true;
			end
		end
		
		return false;
	end
	
	function pEntry.getScriptFromSource(src)
		local m,n;
		local path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		for m,n in ipairs(pEntry.scripts) do
			if (n.src == path) then
				return n;
			end
		end
		
		return false;
	end
	
	function pEntry.getFileFromSource(src)
		local m,n;
		local path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		for m,n in ipairs(pEntry.files) do
			if (n.src == path) then
				return n;
			end
		end
		
		return false;
	end
	
	function pEntry.getMapFromSource(src)
		local m,n;
		local path, isFile = fileParsePath(src);
		
		if not (path) or not (isFile) then return false; end;
		
		for m,n in ipairs(pEntry.maps) do
			if (n.src == path) then
				return n;
			end
		end
		
		return false;
	end
    
    -- Retrive files
    local pMeta = xmlLoadFile(":" .. pEntry.name .. "/meta.xml");
	
    if not (pMeta) then
        pEntry.active = false;
		
        table.insert(resourceData, pEntry);
		
        outputDebugString("Failed to load '" .. pEntry.name .. "'");
        return false;
    end
	
    pEntry.active = true;    
	
    local pNodes = xmlNodeGetChildren(pMeta);
    local m, n;
    
    for m,n in ipairs(pNodes) do
        local pName = xmlNodeGetName(n);
        
        if (pName == "file") then
			local src = xmlNodeGetAttribute(n, "src");
			local path, isFile = fileParsePath(src);
			
			if not (path) or not (isFile) then
				outputDebugString("Illegal file source '" .. src .. " at '" .. pEntry.name .. "'!", 1);
			else
				local type = xmlNodeGetAttribute(n, "type") or "client";
				local file = pEntry.getFileFromSource(path);
				
				if (file) and (file.type == type) then
					outputDebugString("Double file entry '" .. path .. "' found in '" .. pEntry.name .. "'!", 1);
				else
					pEntry.addFile(path, type);
				end
			end
        elseif (pName == "config") then   -- List them as files
			local src = xmlNodeGetAttribute(n, "src");
			local path, isFile = fileParsePath(src);
			
			if not (path) or not (isFile) then
				outputDebugString("Illegal file source '" .. src .. " at '" .. pEntry.name .. "'!", 1);
			else
				local type = xmlNodeGetAttribute(n, "type") or "server";
				local file = pEntry.getFileFromSource(path);
				
				if (file) and (file.type == type) then
					outputDebugString("Double config entry '" .. path .. "' found in '" .. pEntry.name .. "'!", 1);
				else
					pEntry.addFile(path, type);
				end
			end
        elseif (pName == "map") then
			local src = xmlNodeGetAttribute(n, "src");
			local path, isFile = fileParsePath(src);
			
			if not (path) or not (isFile) then
				outputDebugString("Illegal file source '" .. src .. " at '" .. pEntry.name .. "'!", 1);
			else
				local file = pEntry.getFileFromSource(path);
				
				if (file) then
					outputDebugString("Double map entry '" .. path .. "' found in '" .. pEntry.name .. "'!", 1);
				else
					-- Maps are also files!
					pEntry.addMap(path);
				end
			end
        elseif (pName == "script") then
			local src = xmlNodeGetAttribute(n, "src");
			local path, isFile = fileParsePath(src);
			
			if not (path) or not (isFile) then
				outputDebugString("Illegal file source '" .. src .. " at '" .. pEntry.name .. "'!", 1);
			else
				local type = xmlNodeGetAttribute(n, "type") or "server";
				local file = pEntry.getScriptFromSource(path);
				
				if (file) and ((file.type == type) or (file.type == "shared")) then
					outputDebugString("Double script entry '" .. path .. "' found in '" .. pEntry.name .. "'!", 1);
				else
					pEntry.addScript(path, type);
				end
			end
        elseif (pName == "info") then
            -- Update general info
            local author = xmlNodeGetAttribute(n, "author");
			
            if (author) then
                pEntry.author=author;
            end
			
            local realname = xmlNodeGetAttribute(n, "name");
			
            if (realname) then
                pEntry.realname=realname;
            end
			
            local description = xmlNodeGetAttribute(n, "description");
			
            if (description) then
                pEntry.description=description;
            end
			
            local ttype = xmlNodeGetAttribute(n, "type");
			
            if (ttype) then
                pEntry.type=ttype;
            end
			
            local serial = xmlNodeGetAttribute(n, "authorserial");
			
            if (serial) then
                pEntry.authorserial=serial;
            end
        elseif (pName=="deleted") then
            -- We don't load deleted resources
            return false;
        end
    end
	
    table.insert(resourceData, pEntry);
    xmlUnloadFile(pMeta);
    return pEntry;
end

-- Load up all resources
local m,n;
local bFailed=false;
for m,n in ipairs(getResources()) do
    if not (loadResource(n)) then
        bFailed=true;
    end
end

outputDebugString("Loaded " .. #resourceData .. " resources!");

if (bFailed) then
    outputDebugString("Some resources failed to load.", 2);
end

local function initAccountDependencies(account)
	function account.addRight(right, allow)
		local found = strfind(right, "[.]");
		local objectType;
		local objectParam;
		
		if not (found) then return false; end;
		
		objectType = strsub(right, 1, found - 1);
		objectParam = strsub(right, found + 1, strlen(right));
		
		if (strlen(objectParam) == 0) then
			outputDebugString("Invalid parameter for type '" .. objectType .. "' at '" .. account.user .. "'", 2);
			return false;
		end
		
		if (objectType == "editor") then
			account.editor[objectParam] = allow;
		elseif (objectType == "resource") then
			local m,n;
			
			for m,n in pairs(resourceData) do
				if (globmatch(n.name, objectParam)) then
					account.resources[n.name] = allow;
				end
			end
		elseif (objectType == "controlPanel") then
			account.controlPanel[objectParam] = allow;
		else
			outputDebugString("Invalid access right for '" .. account.user .. "'", 2);
			return false;
		end
		
		return true;
	end
end

-- Set up pseudo default account
defaultAccount = {
	user = "guest",
	
	editor = {
		access = false,
		objectManagement = false,
		scriptLock = false,
		createResource = false,
		removeResource = false
	},
	controlPanel = {
		access = false,
		requirePassword = true
	},
	resources = {
		resedit = false
	}
};
initAccountDependencies(defaultAccount);

function createAccountData(user)
	local account = {
		user = user,
		
		editor = {},
		controlPanel = {},
		
		resources = {}
	};
	
	-- Inherit defaultAccount's settings
	local editor = account.editor;
	local controlPanel = account.controlPanel;
	local resources = account.resources;
	
	for m,n in pairs(defaultAccount.editor) do
		editor[m] = n;
	end
	
	for m,n in pairs(defaultAccount.controlPanel) do
		controlPanel[m] = n;
	end
	
	for m,n in pairs(defaultAccount.resources) do
		resources[m] = n;
	end
	
	initAccountDependencies(account);
	
	accountData[user] = account;
	return account;
end

local config;
local access;
local controlPanel;

local function loadConfig()
	local m,n;

	config = xmlGetNode(pConfig);
	access = xmlGetNode(pAccessConfig);
	controlPanel = findCreateNode(config, "controlPanel");
	
	-- Load up all access configurations
	accessData = {};
	
	n = access.children[1];
	
	for m,n in ipairs(access.children) do
		if (n.name == "account") then
			local account = createAccountData(n.attr.user);
			local j,k;
			
			for j,k in ipairs(n.children) do
				if (k.name == "right") then
					account.addRight(k.attr.object, k.attr.allow == "true");
				end
			end
		elseif (n.name == "default") then
			local j,k;
			
			for j,k in ipairs(n.children) do
				if (k.name == "right") then
					defaultAccount.addRight(k.attr.object, k.attr.allow == "true");
				end
			end
		end
	end
end
loadConfig();

function initPlayer(client)
    local pData = {
		isEditing = false,
		editElement = false,
		controlSession = false,
		access = {},
		account = defaultAccount,
		uploads = {},
		downloads = {}
	};
	
	-- Usually, a joined player is logged out, but whatever
	local account = getPlayerAccount(client);
	
	if not (isGuestAccount(account)) then
		pData.account = accountData[getAccountName(account)];
		
		if not (pData.account) then
			pData.account = defaultAccount;
		end
	end
	
	playerData[client] = pData;
    return true;
end

local m,n;
for m,n in ipairs(getElementsByType("player")) do
    initPlayer(n);
end

addEventHandler("onPlayerJoin", getRootElement(), function()
        initPlayer(source);
    end
);

if not (removeResource) then
	-- Pseudo removal of resource
	function removeResource(pResource)
		local pMeta=xmlLoadFile(":"..getResourceName(pResource).."/meta.xml");
		
		if not (pMeta) then return false; end;
		
		if (xmlFindChild(pMeta, "deleted", 0)) then
			outputDebugString("Already pseudo-deleted resource '"..getResourceName(pResource).."'!", 2);
			return true;
		end
		
		outputDebugString("Removed resource '"..getResourceName(pResource).."'");
		
		local pDeletionNotifier=xmlCreateChild(pMeta, "deleted");
		
		xmlNodeSetAttribute(pDeletionNotifier, "bSwitch", "true");
		xmlSaveFile(pDeletionNotifier);
		xmlSaveFile(pMeta);
		xmlUnloadFile(pMeta);
		return true;
	end
end

function removeResourceEx(resource)
	local m,n;
	
	for m,n in ipairs(resourceData) do
		if (n == resource) then
			table.remove(resourceData, m);
			return true;
		end
	end
	
	return false;
end

function getResourceFromNameEx(name)
    local m,n;
    
    for m,n in ipairs(resourceData) do
        if (n.name == name) then
            return n;
        end
    end
    
    return false;
end

function getElementResource(element)
	while (true) do
		element = getElementParent(element);
		
		if (element == getRootElement()) then
			return false;
		elseif (getElementType(element) == "resource") then
			local m,n;
			local resources = getResources();
			
			for m,n in ipairs(resources) do
				if (getResourceRootElement(n) == element) then
					return n;
				end
			end
			
			return false;
		end
	end
end

function getElementResourceEx(element)
	local resource = getElementResource(element);
	local m,n;
	
	for m,n in ipairs(resourceData) do
		if (n.name == getResourceName(resource)) then
			return n;
		end
	end
	
	return false;
end

function isElementChildOf(element, parent)
	while (true) do
		element = getElementParent(element);
		
		if (element == parent) then
			return true;
		elseif (element == getRootElement()) then
			return false;
		end
	end
end

function checkResourceAccess(client, resource)
    local pAccount = getPlayerAccount(client);
	
    if not (pAccount) then return false; end;
    
    local groups=aclGroupList();
    local clientGroups={};
    local resourceGroups={};
    local m,n;
	
    for m,n in ipairs(groups) do
        local k,j;
        local objects=aclGroupListObjects(n);
        
        for k,j in ipairs(objects) do
            if ("user."..getAccountName(pAccount) == j) then
                local a,b;
                local acl=aclGroupListACL(n);
                
                for a,b in ipairs(acl) do
                    table.insert(clientGroups, b);
                end
            elseif ("resource."..getResourceName(resource) == j) then
                local a,b;
                local acl=aclGroupListACL(n);
                
                for a,b in ipairs(acl) do
                    table.insert(resourceGroups, b);
                end
            end
        end
    end
    
    -- Compare groups
    for m,n in ipairs(resourceGroups) do
        local k,j;
        local bFound=false;
        
        for k,j in ipairs(clientGroups) do
            if (j==n) then
                bFound=true;
                break;
            end
        end
        if not (bFound) then
            return false;
        end
    end
    return true;
end

function updateClientAccess(client)
    local m,n;
    local resources = getResources();
    local pData = playerData[client];
    local access = pData.access;
    
	-- We simply send the account
    access.account = pData.account;
	
    access.resources = {};
    
    for m,n in ipairs(resources) do
        access.resources[getResourceName(n)] = checkResourceAccess(client, n);
    end
	
	-- Overwirte this with the account settings
	for m,n in pairs(pData.account.resources) do
		access.resources[m] = n;
	end
    
    -- Send this table to the client
    triggerClientEvent(client, "onClientAccessRightsUpdate", getRootElement(), access);
    return true;
end

function checkSpecialResourceAccess(client, resource)
    return hasObjectPermissionTo(client, "general.ModifyOtherObjects");
end

function updateResource(resource)
    local m,n;
    
    -- We write it into the file
    local pXml = xmlLoadFile(":" .. resource.name.."/meta.xml");
	
    if not (pXml) then
        -- Dont bother with bugged resources
        resource.active = false;
        return false;
    end
	
    local childs = xmlNodeGetChildren(pXml);
    
    for m,n in ipairs(childs) do
        local name = xmlNodeGetName(n);
        
        if (name == "info") then
            xmlNodeSetAttribute(n, "author", resource.author);
            xmlNodeSetAttribute(n, "description", resource.description);
            xmlNodeSetAttribute(n, "type", resource.type);
            xmlNodeSetAttribute(n, "name", resource.realname);
        end
    end
	
    xmlSaveFile(pXml);
    xmlUnloadFile(pXml);
    
    triggerClientEvent("onResourceDataUpdate", getRootElement(), resource, false);
    return true;
end

addEventHandler("onPlayerLogin", getRootElement(), function(previous, account, auto)
        local pData = playerData[source];
		
		-- Give client the account it logged into
		pData.account = accountData[getAccountName(account)];
		
		if not (pData.account) then
			pData.account = defaultAccount;
		end
		
		updateClientAccess(source);
    end
);

addEventHandler("onPlayerLogout", getRootElement(), function(previous, account)
        local pData = playerData[source];
		
		-- Give client the guest account data
		pData.account = defaultAccount;

        updateClientAccess(source);
        
        -- Kill illegal transactions
        local m,n;
        
        for m,n in pairs(pData.downloads) do
            if not (pData.access.resources[n.resource.name]) then
                triggerClientEvent(source, "onClientDownloadAbort", getRootElement(), n.id);
                
                pData.downloads[m] = nil;
            end
        end
		
		-- Abort uploads
		for m,n in pairs(pData.uploads) do
			if not (pData.access.resources[n.resource.name]) then
				triggerClientEvent(source, "onClientUploadAbort", getRootElement(), n.id);
				
				pData.uploads[m] = nil;
			end
		end
		
		-- Illegal scriptlock?
		if (pData.scriptLock) then
			if not (pData.access[pData.lockResource]) or not (pData.access.script_lock) then
				triggerClientEvent("onClientScriptLockFree", source, pData.lockResource.name, pData.scriptLock.src);
				
				pData.scriptLock.lockClient = false;
				pData.scriptLock = false;
			end
		end
    end
);

addEvent("onFileHashRequest", true);
addEventHandler("onFileHashRequest", getRootElement(), function(id, resource, filename)
		local pData = playerData[client];
		local res = getResourceFromNameEx(resource);
		
		if not (res) then return false; end;
		
		if not (pData.access.resources[resource]) then
			triggerClientEvent(client, "onClientFileHashAbort", getRootElement(), id);
			return false;
		end
		
		-- We just send the hash
		local file = fileOpen(":" .. resource .. "/" .. filename);
		
		if not (file) or (fileGetSize(file) == 0) then
			triggerClientEvent(client, "onClientFileHash", getRootElement(), id, "");
			return true;
		end
		
		triggerClientEvent(client, "onClientFileHash", getRootElement(), id, md5(fileRead(file, fileGetSize(file))));
		
		fileClose(file);
	end	
);

addEvent("onDownloadRequest", true);
addEventHandler("onDownloadRequest", getRootElement(), function(id, resource, filename)
        local pData = playerData[client];
        local res = getResourceFromNameEx(resource);
        local found = false;
        local m,n;
        
        if not (res) then return false; end;
        
        if not (pData.access.resources[resource]) then
            outputChatBox("Access denied to resource '" .. resource .. "'", client);
            return false;
        end
        
        -- Transaction is already running under this id
        if (pData.downloads[tostring(id)]) then
            triggerClientEvent(client, "onClientDownloadAbort", getRootElement(), id);
            return false;
        end
        
        -- It must be listed as file, else it is a safe hack
        for m,n in ipairs(res.files) do
            if (n.src == filename) then
                found = true;
            end
        end
        
        for m,n in ipairs(res.scripts) do
            if (n.src == filename) then
                found = true;
            end
        end
        
        if not (found) then
            kickPlayer(client, "Tried to request a non marked file. Please contact the server administrator.");
            return false;
        end
        
        -- Send data to client
        file = fileOpen(":" .. resource .. "/" .. filename);
        
        if not (file) then
            triggerClientEvent(client, "onClientDownloadAbort", id);
            return false;
        end
        
        local trans = {};
        pData.downloads[tostring(id)] = trans;
        trans.resource = res;
        trans.file = file;
        
        triggerClientEvent(client, "onClientDownloadAccept", getRootElement(), id, fileGetSize(file));
    end
);

addEvent("onDownloadReady", true);
addEventHandler("onDownloadReady", getRootElement(), function(id)
        local pData = playerData[client];
        local trans = pData.downloads[tostring(id)];
        
        if not (trans) then
            outputDebugString("Internal Error: Unknown transaction", client);   -- Short for HAAAAAXXXXXXX
            return false;
        end
        
        -- Much safer if we wait for another ready to tell client he is finished
        if (fileIsEOF(trans.file)) then
            triggerClientEvent(client, "onClientDownloadComplete", getRootElement(), id);
            
            pData.downloads[tostring(id)] = nil;
            fileClose(trans.file);
            return true;
        end
    
        -- Send the client more data
        triggerClientEvent(client, "onClientDownloadData", getRootElement(), id, fileRead(trans.file, transactionPacketBytes));
    end
);

addEvent("onDownloadAbort", true);
addEventHandler("onDownloadAbort", getRootElement(), function(id)
        local pData = playerData[client];
        
        -- We disable the transaction simply
        pData.downloads[tostring(id)] = nil;
    end
);

addEvent("onClientRequestScriptLock", true);
addEventHandler("onClientRequestScriptLock", getRootElement(), function(resource, filename)
        local pData = playerData[client];
        local res = getResourceFromNameEx(resource);
        
        if not (res) then return false; end;
		
		if not (pData.account.editor.scriptLock) then return false; end;
        
        -- Access check
        if not (pData.access.resources[resource]) then
            return false;
        end
		
		local script = res.getScriptFromSource(filename);
		
		if not (script) then
			kickPlayer(client, "Failed to find scriptData. Please contact the server administrator.");
			return false;
		end
        
		-- Script lock check
		if (script.lockClient == client) then
			return true;    -- You have the lock already
		elseif (script.lockClient) then
			return false;
		end
		
		-- Abandon the previous lock
		if (pData.scriptLock) then
			pData.scriptLock.lockClient = false;
			
			triggerClientEvent("onClientScriptLockFree", client, pData.lockResource.name, pData.scriptLock.src);
		end
		
		pData.lockResource = res;
		pData.scriptLock = script;
		script.lockClient = client;
		
		-- Update global data
		triggerClientEvent("onClientScriptLockAcquire", client, resource, filename);
    end
);

addEvent("onClientFreeScriptLock", true);
addEventHandler("onClientFreeScriptLock", getRootElement(), function()
        local pData = playerData[client];
        
        if not (pData.scriptLock) then
            return false;
        end
        
        triggerClientEvent("onClientScriptLockFree", client, pData.lockResource.name, pData.scriptLock.src);
        
        pData.scriptLock.lockClient = false;
        pData.scriptLock = false;
    end
);

addEvent("onUploadRequest", true);
addEventHandler("onUploadRequest", getRootElement(), function(id, resource, filename)
        local pData = playerData[client];
        local requestType = false;
        local res = getResourceFromNameEx(resource);
        
        if not (res) then return false; end;
        
        -- Transaction overlap?
        if (pData.uploads[tostring(id)]) then
            triggerClientEvent(client, "onClientTransactionAbort", getRootElement(), id);
            return false;
        end
        
        -- Access check
        if not (pData.access.resources[resource]) then
            outputChatBox("Access denied to resource '" .. res.name .. "'", client);
            return false;
        end
        
        -- Check what type this request is
        local script = res.getScriptFromSource(filename);
		
		if (script) then
			local client = client;
		
			if not (script.lockClient == client) then
				kickPlayer(client, "Tried to update a locked script.");
				return false;
			end
		
			local trans = {};
			pData.uploads[tostring(id)] = trans;
			trans.resource = res;
			trans.filename = filename;
			trans.data = "";
			
			function trans.cbAbort()
				outputDebugString("Client aborted a transaction", 2);
				return true;
			end
			
			function trans.cbComplete()
				triggerClientEvent("onScriptUpdate", client, resource, filename);
				return true;
			end
			
			triggerClientEvent(client, "onClientUploadReady", getRootElement(), id);
			return true;
        end
        
        local file = res.getFileFromSource(filename);
		
		if not (file) then
			-- Kicking is too harsh, let us abort the upload request
			triggerClientEvent(client, "onClientUploadAbort", getRootElement(), id);
			return false;
		end
		
		-- We have to lock files too for safety
		if (file.lockClient) and not (file.lockClient == client) then
			triggerClientEvent(client, "onClientUploadAbort", getRootElement(), id);
			return true;
		end
		
		file.lockClient = client;
		
		local trans = {};
		pData.uploads[tostring(id)] = trans;
		trans.resource = res;
		trans.filename = filename;
		trans.data = "";
		
		function trans.cbAbort()
			file.lockClient = false;
		
			outputDebugString("Client aborted a transaction");
			return true;
		end
		
		function trans.cbComplete()
			file.lockClient = false;
			return true;
		end
	
		triggerClientEvent(client, "onClientUploadReady", getRootElement(), id);
    end
);

addEvent("onUploadData", true);
addEventHandler("onUploadData", getRootElement(), function(id, data)
        local pData = playerData[client];
        local trans = pData.uploads[tostring(id)];
        
        if not (trans) then return false; end;
        
        if (trans.cbData) then
            trans.cbData(data);
        end
        
        trans.data = trans.data .. data;
        triggerClientEvent(client, "onClientUploadReady", getRootElement(), id);
    end
);

addEvent("onUploadAbort", true);
addEventHandler("onUploadAbort", getRootElement(), function(id)
		local pData = playerData[client];
		local trans = pData.uploads[tostring(id)];
		
		if not (trans) then return false; end;
		
		if (trans.cbAbort) then
			trans.cbAbort();
		end
		
		-- Make sure garbage collection picks it up
		trans.data = nil;
		
		pData.uploads[tostring(id)] = nil;
	end
);

addEvent("onUploadComplete", true);
addEventHandler("onUploadComplete", getRootElement(), function(id)
        local pData = playerData[client];
        local trans = pData.uploads[tostring(id)];
		
		if not (trans) then return false; end;
        
        if (trans.cbComplete) then
            trans.cbComplete();
        end
        
		local file = fileCreate(":" .. trans.resource.name .. "/" .. trans.filename);
		fileWrite(file, trans.data);
        fileClose(file);
		
		-- Forcefully free datachunk
		trans.data = nil;
		
        pData.uploads[tostring(id)] = nil;
    end
);

addEvent("onClientRequestControlPanelSession", true);
addEventHandler("onClientRequestControlPanelSession", getRootElement(), function(password)
		local pData = playerData[client];
		local session;
		local m,n;
		
		if (pData.access.requirePassword) and not (controlPanel.attr.password == password) then
			triggerClientEvent(client, "onControlPanelWrongPassword", client);
			return false;
		end
		
		session = {
			start = getTickCount()
		};
		
		controlSessions[client] = session;
		
		-- Send the notification
		triggerClientEvent("onControlPanelAccess", client);
		
		-- Now update him on the server data
		local serverData = {
			defaultAccount = false,
			accounts = {}
		};
		
		for m,n in pairs(access.children) do
			if (n.name == "account") then
				local account = {
					rights = {}
				};
				
				local j,k;
				
				for j,k in ipairs(n.children) do
					if (k.name == "right") then
						table.insert(account.rights, {
							object = k.attr.object,
							allow = k.attr.allow == "true"
						});
					end
				end
				
				table.insert(serverData.accounts, account);
			elseif (n.name == "default") then
				local account = {
					rights = {}
				};
				
				local j,k;
				
				for j,k in ipairs(n.children) do
					if (k.name == "right") then
						table.insert(account.rights, {
							object = k.attr.object,
							allow = k.attr.allow == "true"
						});
					end
				end
				
				serverData.defaultAccount = account;
			end
		end
		
		triggerClientEvent(client, "onControlPanelUpdate", getRootElement(), serverData);
	end
);

addEvent("onClientControlPanelTerminate", true);
addEventHandler("onClientControlPanelTerminate", getRootElement(), function()
		local session = controlSessions[client];
		
		if not (session) then return true; end;
		
		controlSessions[client] = nil;
		
		triggerClientEvent("onControlPanelTerminate", client);
	end
);

addEvent("onClientAddScript", true);
addEventHandler("onClientAddScript", getRootElement(), function(resource, filename, scripttype)
		local pData = playerData[client];
        local res = getResourceFromNameEx(resource);
		
		if not (res) then return false; end;
            
		if not (res.authorserial == getPlayerSerial(client)) and (not pData.access.resources[resource] and not (hasObjectPermissionTo(client, "general.ModifyOtherObjects"))) then
			outputChatBox("Access denied to resource '"..n.name.."'", client);
			return false;
		end
		
		if (filename == "meta.xml") then
			return false;
		end
		
		local path = ":" .. resource .. "/" .. filename;
		
		if not (fileExists(path)) then
			local pScript = fileCreate(path);
			
			if not (pScript) then
				outputChatBox("Failed to create script", client);
				return false;
			end
			
			fileClose(pScript);
		end
		
		if not (res.addScript(filename, scripttype)) then
			outputChatBox("Failed to add script", client);
			return false;
		end
		
		local content;
		local metaPath = ":" .. resource .. "/meta.xml";
		
		pMeta = xmlLoadFile(metaPath);
		
		if (pMeta) then
			content = xmlGetNode(pMeta);
		
			xmlUnloadFile(pMeta);
		else
			content = xmlCreateNodeEx("meta");
		end
		
		-- Hack to force creation of meta.xml
		fileClose(fileCreate(metaPath));
		
		-- Make sure we have a copy on local filesystem
		pMeta = xmlCreateFile(metaPath, "meta");
		
		-- We emulate the shared script association
		if (scripttype == "shared") then
			local serverNode = xmlCreateChildEx(content, "script");
			local clientNode = xmlCreateChildEx(content, "script");
			
			serverNode.attr.src = filename;
			clientNode.attr.src = filename;
			
			serverNode.attr.type = "server";
			clientNode.attr.type = "client";
		else
			local pScript = xmlCreateChildEx(content, "script");
			pScript.attr.src = filename;
			
			if (scripttype == "client") then
				pScript.attr.type = "client";
			end
		end
		
		xmlSetNode(pMeta, content);
		
		xmlSaveFile(pMeta);
		xmlUnloadFile(pMeta);
		
		triggerClientEvent("onResourceAddScript", getRootElement(), resource, filename, scripttype, "");
    end
);

addEvent("onClientRemoveScript", true);
addEventHandler("onClientRemoveScript", getRootElement(), function(resource, filename)
        if not (hasObjectPermissionTo(client, "general.ModifyOtherObjects")) then
            outputChatBox("You do not have the permission to update scripts.", client);
            return false;
        end
		
		local pData = playerData[client];
        local m,n;
        local res = getResourceFromNameEx(resource);
		
		if not (res) then return false; end
            
		if not (res.authorserial == getPlayerSerial(client)) and not (pData.access.resources[resource]) then
			outputChatBox("Access denied to resource '" .. resource .. "'", client);
			return false;
		end
		
		-- File exists already?
		local script = res.getScriptFromSource(filename);
		
		if not (script) then
			outputChatBox("Script '" .. filename .. "' does not exist in resource '" .. resource .. "'", client);
			return false;
		end
		
		if not (script.lockClient == client) then
			outputChatBox("You have to own the lock to '" .. filename .. "'!", client);
			return false;
		end
		
		local path = ":" .. resource .. "/" .. filename;
		
		if not (fileExists(path)) then
			outputChatBox("Internal Error: Couldn't find matching file ('" .. filename .. "')", client);
			return false;
		end
		
		-- Free scriptLock, clientside is automatic
		pData.scriptLock = false;
		
		fileDelete(path);
		
		-- Remove it
		res.removeScriptFromSource(filename);
		
		local metaPath = ":" .. resource .. "/meta.xml";
		
		-- Remove it from XML
		local pMeta = xmlLoadFile(metaPath);
		
		if not (pMeta) then
			return false;
		end 
		
		local content = xmlGetNode(pMeta);
		xmlUnloadFile(pMeta);
		
		-- Hack to force creation of meta.xml
		fileClose(fileCreate(metaPath));
		
		-- Make sure we have a copy on local filesystem
		pMeta = xmlCreateFile(metaPath, "meta");
		
		-- Fish out the node and kill it
		for m,n in ipairs(content.children) do
			if (n.name == "script") and (n.attr.src == filename) then
				table.remove(content.children, m);
				break;
			end
		end
		
		xmlSetNode(pMeta, content);
		
		xmlSaveFile(pMeta);
		xmlUnloadFile(pMeta);
		
		triggerClientEvent("onResourceRemoveScript", getRootElement(), resource, filename);
    end
);

addEvent("onClientRequestResourceCreation", true);
addEventHandler("onClientRequestResourceCreation", getRootElement(), function(name, restype, description)
		local pData = playerData[client];

        if not (pData.account.editor.createResource) then
            outputChatBox("You do not have the permission to create resources", client);
            return false;
        end
        
        if (string.len(name)==0) then
            return false;
        end
		
        if (string.len(restype)==0) then
            return false;
        end
		
        -- Check if resource already exists
        local pResource = getResourceFromName(name);
		
        if (pResource) then
            local pMeta = xmlLoadFile(":"..getResourceName(pResource).."/meta.xml");
			
            if not (pMeta) then
                -- Resource bugged
                return false;
            end
            
            -- Check for deletion tag
            if not (xmlFindChild(pMeta, "deleted", 0)) then
                outputChatBox("Resource '"..name.."' already exists", client);
                return false;
            end
        else
            pResource = createResource(name);
			
            if not (pResource) then
                outputChatBox("Failed to create resource '"..name.."'", client);
                return false;
            end
        end
		
        local pMeta = xmlCreateFile(":" .. name .. "/meta.xml", "meta");
        local pInfo = xmlCreateChild(pMeta, "info");
		
        xmlNodeSetAttribute(pInfo, "author", getPlayerName(client));
        xmlNodeSetAttribute(pInfo, "authorserial", getPlayerSerial(client));
        xmlNodeSetAttribute(pInfo, "description", description);
        xmlNodeSetAttribute(pInfo, "type", restype);
        xmlNodeSetAttribute(pInfo, "version", "1.0");
		
        xmlSaveFile(pMeta);
        xmlUnloadFile(pMeta);
        
        -- Load it
        local data = loadResource(pResource);
        updateResource(data);
		
		-- Update access rights
		local m,n;
		
		for m,n in pairs(playerData) do
			updateClientAccess(m);
		end
    end
);

addEvent("onClientRequestResourceRemoval", true);
addEventHandler("onClientRequestResourceRemoval", getRootElement(), function(resname)
		local pData = playerData[client];
		local res = getResourceFromNameEx(resource);
		
		if not (res) then
			return false;
		end
		
		-- You can only remove your resources, or if you have admin
		if not (n.authorserial == getPlayerSerial(client)) and not (pData.account.editor.removeResource) then
			outputChatBox("You do not have the permission to remove resource '"..resname.."'", client);
			return false;
		end
		
		removeResourceEx(res);
    end
);

addEvent("onClientRequestStartResource", true);
addEventHandler("onClientRequestStartResource", getRootElement(), function(resource)
        local pData = playerData[client];
		local res = getResourceFromNameEx(resource);
        
        if not (res) then
			return false;
		end

        if not (res.authorserial == getPlayerSerial(client)) then
            if not (hasObjectPermissionTo(client, "command.start")) then
                outputChatBox("Invalid access (/start)", client);
                return false;
            end

            if not (pData.access.resources[resource]) then
                outputChatBox("Access denied to resource '" .. resource .. "'", client);
                return false;
            end
        end
		
		if (getResourceState(res.resource) == "running") then
			restartResource(res.resource);
		else
			startResource(res.resource);
		end
    end
);

addEvent("onClientRequestStopResource", true);
addEventHandler("onClientRequestStopResource", getRootElement(), function(resource)
        local pData = playerData[client];
		local res = getResourceFromNameEx(resource);
		
        if not (res) then
			return false;
		end
        
        if not (res.authorserial == getPlayerSerial(client)) then
            if not (hasObjectPermissionTo(client, "command.stop")) then
                outputChatBox("Invalid access (/stop)", client);
                return false;
            end

            if not (pData.access.resources[resource]) then
                outputChatBox("Access denied to resource '" .. resource .. "'", client);
                return false;
            end
        end
		
        stopResource(res.resource);
    end
);

addEvent("onClientRequestElementEdit", true);
addEventHandler("onClientRequestElementEdit", getRootElement(), function()
        -- Check whether the element is being edited already
		local pData = playerData[client];
        local bMap = false;
        local resource;
        
        for m,n in pairs(playerData) do
            if (n.isEditing) and (n.editElement==source) then
                outputChatBox("Element is being edited already!", client);
                return false;
            end
        end
        
        if (getElementType(source) == "player") then
            if not (hasObjectPermissionTo(client, "general.ModifyOtherObjects")) then
                outputChatBox("You do not have the permission to edit players", client);
                return false;
            end
			
            resource = getResourceFromNameEx("resedit");
        else
			local children;
			local m,n;
		
			resource = getElementResourceEx(source);
			
			if not (resource) then
				outputDebugString("Failed to find element resource. Please restart resedit!", 2);
				return false;
			end
		
			-- Check all map roots
			for m,n in ipairs(resource.maps) do
				local map = getResourceMapRootElement(resource.resource, n.src);
				
				if (map) and (isElementChildOf(source, map)) then
					bMap = true;
					break;
				end
            end
			
            if not (resource) then
                outputChatBox("Invalid element selected", client);
                return false;
            end
			
            if not (checkResourceAccess(client, resource.resource)) then
                outputChatBox("Access denied to resource '" .. resource.name .. "'", client);
                return false;
            end
        end
        
        if (pData.isEditing) then
            outputChatBox("Editing already!", client);
            return false;
        end
		
        -- Set him as editor
        pData.isEditing = true;
        pData.editElement = source;
        triggerClientEvent("onElementEditStart", source, client, resource.name, bMap);
    end
);

addEvent("onElementPositionUpdate", true);
addEventHandler("onElementPositionUpdate", getRootElement(), function(posX, posY, posZ)
        local pData = playerData[client];
        
        if not (pData.isEditing) or not (pData.editElement == source) then
            kickPlayer(client, "Invalid Element");
            return false;
        end
		
        setElementPosition(source, posX, posY, posZ);
        triggerClientEvent("onElementPositionUpdate", source, posX, posY, posZ);
    end
);

addEvent("onElementRotationUpdate", true);
addEventHandler("onElementRotationUpdate", getRootElement(), function(rotX, rotY, rotZ)
        local pData = playerData[client];
        
        if not (pData.isEditing) or not (pData.editElement==source) then
            outputChatBox("Wrong element", client);
            return false;
        end
		
        setElementRotation(source, rotX, rotY, rotZ);
        triggerClientEvent("onElementRotationUpdate", source, rotX, rotY, rotZ);
    end
);

addEvent("onElementRepair", true);
addEventHandler("onElementRepair", getRootElement(), function()
        local pData = playerData[client];
        
        if not (pData.isEditing) or not (pData.editElement==source) then
            kickPlayer(client, "Hacking attempt");
            return false;
        end
        
        if (getElementType(source) == "vehicle") then
            fixVehicle(source);
        end
    end
);

addEvent("onClientRequestElementDestroy", true);
addEventHandler("onClientRequestElementDestroy", getRootElement(), function()
        local pData = playerData[client];
        
        if not (pData.isEditing) or not (pData.editElement == source) then
            kickPlayer(client, "Hacking attempt");
            return false;
        end
        
        -- Detaching from the player interface is handled through destroy event
        if (getElementType(source)=="player") then
            killPed(source);
        else
            destroyElement(source);
        end
    end
);

addEvent("onClientRequestEditEnd", true);
addEventHandler("onClientRequestEditEnd", getRootElement(), function()
        local pData = playerData[client];
        
        if not (pData.isEditing) then return false; end;
		
        if not (pData.editElement == source) then
            kickPlayer(client, "Hacking attempt");
            return false;
        end
        
        -- End the session
        pData.isEditing = false;
        triggerClientEvent("onElementEditEnd", pData.editElement, client);
    end
);

addEventHandler("onElementDestroy", getRootElement(), function()
        local m,n;
        
        for m,n in pairs(playerData) do
            if (n.isEditing) and (n.editElement == source) then
                outputDebugString("Quit edit session onDestroy("..getPlayerName(m)..");");
				
                n.isEditing = false;
				
                triggerClientEvent("onElementEditEnd", source, m);
                break;
            end
        end
    end
);

addEventHandler("onPlayerQuit", getRootElement(), function()
        local pData = playerData[source];
        local m,n;
        
        if (pData.isEditing) then
            triggerClientEvent("onElementEditEnd", pData.editElement, source);
        end
		
        playerData[source] = nil;
        
        -- Make sure all locks are removed
        for m,n in pairs(pData.uploads) do
			n.cbAbort();
			
			n.data = nil;
        end
        
        if (pData.scriptLock) then
            triggerClientEvent("onClientScriptLockFree", source, pData.lockResource.name, pData.scriptLock.src);
            
            pData.scriptLock.lockClient = false;
        end
    end
);

function updateClientResourceData(client)
    -- Send them our resourceData
    local m,n;
    
    -- Send silent updates
    for m,n in ipairs(resourceData) do
        triggerClientEvent(client, "onResourceDataUpdate", getRootElement(), n, true);
    end
	
    return true;
end

addEvent("onResourceSet", true);
addEventHandler("onResourceSet", getRootElement(), function(resource, cmd, ...)
        local args = {...};
		local res = getResourceFromNameEx(resource);
		
		if not (checkSpecialResourceAccess(client, res.resource)) then
			outputChatBox("Invalid access (" .. cmd .. ")", client);
			return false;
		end
		
		if (cmd == "type") then
			res.type = args[1];
		elseif (cmd == "description") then
			res.description = args[1];
		end
		
		updateResource(res);
    end
);

addEventHandler("onResourceStop", getResourceRootElement(), function()
		-- Save the configurations
		xmlSetNode(pConfig, config);
		xmlSetNode(pAccessConfig, access);
		
		xmlSaveFile(pConfig);
		xmlSaveFile(pAccessConfig);
		
		xmlUnloadFile(pConfig);
		xmlUnloadFile(pAccessConfig);
	end
);

addEvent("onClientResourceSystemReady", true);
    
addEventHandler("onClientResourceSystemReady", getRootElement(), function()
        updateClientResourceData(client);
        updateClientAccess(client);
    end
);