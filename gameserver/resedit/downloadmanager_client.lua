-- Optimizations
local string = string;
local math = math;
local strsub = string.sub;
local strlen = string.len;
local ipairs = ipairs;
local pairs = pairs;
local tostring = tostring;

addEvent("onClientUploadReady", true);
addEvent("onClientUploadAbort", true);
addEvent("onClientFileHash", true);
addEvent("onClientFileHashAbort", true);
addEvent("onClientFileHashRequest", true);
addEvent("onClientDownloadAccept", true);
addEvent("onClientDownloadAbort", true);
addEvent("onClientDownloadData", true);
addEvent("onClientDownloadComplete", true);
local uploads={};
local downloads={};
local fileList={};

addEventHandler("onClientPreRender", getRootElement(), function()
        local y = 0;
        local m,n;

        -- Reorder all transaction windows
        for m,n in pairs(uploads) do
            local width, height = guiGetSize(n.window, false);
            
            n.frame();
            
            guiSetPosition(n.window, 0, y, false);
            y = y + height;
        end
        
        for m,n in pairs(downloads) do
            if (n.status == 1) then
                local width, height = guiGetSize(n.window, false);
                
                n.frame();
                
                guiSetPosition(n.window, 0, y, false);
                y = y + height;
            end
        end
    end
);

function toupbyte(bytes)
    if (bytes == 0) then
        return "0bytes";
    end

    local level = math.floor(math.log(bytes) / math.log(1024));    -- Math.log(1024)
    local numBytes = math.floor(bytes / math.pow(1024, level));
    
    if (level == 0) then
        return numBytes .. "bytes";
    elseif (level == 1) then
        return numBytes .. "kilobytes";
    elseif (level == 2) then
        return numBytes .. "megabytes";
    end
    
    return "unknown";
end

function totimedesc(seconds)
    local timeString = "";

    if (seconds > 86400) then
        timeString = timeString .. math.floor(seconds / 86400) .. "days ";
        
        seconds = math.mod(seconds, 86400);
    end
    
    if (seconds > 3600) then
        timeString = timeString .. math.floor(seconds / 3600) .. "hours ";
        
        seconds = math.mod(seconds, 3600);
    end

    if (seconds > 60) then
        timeString = timeString .. math.floor(seconds / 60) .. "mins ";
        
        seconds = math.mod(seconds, 60);
    end

    timeString = timeString .. seconds .. "secs";
    return timeString;
end

function getFile(filename)
    local trans = {};
    local n=1;
    
    while (downloads[tostring(n)]) do
        n = n + 1;
    end
    
    downloads[tostring(n)] = trans;
    trans.id = n;
    trans.resource = currentResource;
    trans.filename = filename;
    trans.data = "";
    trans.status = 0;
    trans.seek = 0;
    
	if (createClientRepository) then
		trans.target = "repository/" .. currentResource.name .. "/" .. filename;
		
		if (fileExists("@" .. trans.target)) then
			trans.file = fileOpen("@" .. trans.target);
			trans.status = 2;
		
			triggerServerEvent("onFileHashRequest", root, n, currentResource.name, filename);
			return trans;
		end
	else
		trans.target = "temp/" .. math.random(1, 0xFFFF) .. ".tmp";
	end
	
	-- Create a private file
	trans.file = fileCreate("@" .. trans.target);
	fileList[trans.target] = true;
    
    triggerServerEvent("onDownloadRequest", root, n, currentResource.name, filename);
    return trans;
end

function fileGet(file)
	local seek = 0;
	local size = fileGetSize(file);
	local content = "";
	
	while (seek < size) do
		content = content .. fileRead(file, 65535);
		seek = seek + 65535;
	end
	
	return content;
end

addEventHandler("onClientFileHash", root, function(id, hash)
		local trans = downloads[tostring(id)];
		local data = fileGet(trans.file);
		
		fileClose(trans.file);
		
		if (hash == md5(data)) then
			trans.data = data;
			
			if (trans.cbComplete) then
				trans.cbComplete();
			end
		
			return;
		end
		
		trans.file = fileCreate("@" .. trans.target);
		
		triggerServerEvent("onDownloadRequest", getRootElement(), id, currentResource.name, trans.filename);
	end
);

addEventHandler("onClientFileHashAbort", getRootElement(), function(id)
		local trans = downloads[tostring(id)];
		
		if (trans.cbAbort) then
			trans.cbAbort();
		end

		downloads[tostring(id)] = nil;
	end
);

function sendFile(filename, data)
    local screenW, screenH = guiGetScreenSize();
    local guiW, guiH = 300, 115;
    local trans = {};
    local n=1;
	local title = "File Upload (:" .. currentResource.name .. "/" .. filename .. ")";
	local width = dxGetTextWidth(title) + 50;
    
    while (uploads[tostring(n)]) do
        n = n + 1;
    end
	
	if (guiW < width) then
		guiW = width;
	end
    
	-- We create the upload window at upload request
    trans.window = guiCreateWindow(0, 0, guiW, guiH, title, false);
	guiWindowSetSizable(trans.window, false);
	
	local pUpload = guiCreateLabel(10, 25, guiW - 140, 15, "Total Upload: 0bytes", false, trans.window);
	local pTime = guiCreateLabel(guiW - 140, 25, 100, 15, "Time: 0secs", false, trans.window);
	local pRate = guiCreateLabel(10, 40, guiW - 20, 15, "Upload Rate: 0bytes per second", false, trans.window);
	
	trans.progress = guiCreateProgressBar(10, 60, guiW - 20, 20, false, trans.window);
	
	function trans.frame()
		local elapsed = (getTickCount() - trans.startTime) / 1000;
	
		guiSetText(pUpload, "Total Upload: " .. toupbyte(trans.seek));
		guiSetText(pTime, "Time: " .. totimedesc(math.floor(elapsed)));
		guiSetText(pRate, "Upload Rate: " .. toupbyte(trans.seek / (elapsed)) .. " per second");
		return true;
	end
	
	local pAbort = guiCreateButton(guiW - 110, 90, 100, 20, "Abort", false, trans.window);
	
	addEventHandler("onClientGUIClick", pAbort, function(button, state, x, y)
			triggerServerEvent("onUploadAbort", getRootElement(), n);
			
			destroyElement(trans.window);
			
			uploads[tostring(n)] = nil;
		end, false
	);
    
    uploads[tostring(n)] = trans;
    trans.id = n;
    trans.resource = currentResource;
    trans.filename = filename;
    trans.data = data;
    trans.seek = 1;
    trans.status = 1;
	trans.startTime = getTickCount();
    
    triggerServerEvent("onUploadRequest", getRootElement(), n, currentResource.name, filename);
    return trans;
end

addEventHandler("onClientUploadReady", getRootElement(), function(id)
        local trans = uploads[tostring(id)];
		
		-- Packets tend to be unreliable
		if not (trans) then return false; end;
        
        if (trans.seek > strlen(trans.data)) then
            if (trans.cbComplete) then
                trans.cbComplete();
            end
            
            triggerServerEvent("onUploadComplete", getRootElement(), id);
            
            -- Kill window
            destroyElement(trans.window);
            
            uploads[tostring(id)] = nil;
            return true;
        end
        
        local data = strsub(trans.data, trans.seek, trans.seek + transactionPacketBytes);
        
        if (trans.cbData) then
            trans.cbData(data);
        end
        
        trans.seek = trans.seek + transactionPacketBytes + 1;
        triggerServerEvent("onUploadData", getRootElement(), id, data);
		
		-- Update GUI
        guiSetProperty(trans.progress, "CurrentProgress", tostring(trans.seek / strlen(trans.data)));
    end
);

addEventHandler("onClientUploadAbort", getRootElement(), function(id)
        local trans = uploads[tostring(id)];
        
        -- Maybe we just cannot do it
        if (trans.cbAbort) then
            trans.cbAbort();
        end
        
        -- Kill window
        destroyElement(trans.window);
        
        uploads[tostring(id)] = nil;
    end
);

addEventHandler("onClientDownloadAccept", getRootElement(), function(id, size)
        local trans = downloads[tostring(id)];
        local screenW, screenH = guiGetScreenSize();
        local guiW, guiH = 325, 115;
        local title = "File Download (:" .. currentResource.name .. "/" .. trans.filename .. ")";
        local width = dxGetTextWidth(title) + 50;
        
        trans.data = "";
        trans.size = size;
        trans.status = 1;
        trans.startTime = getTickCount();
        
        if (trans.cbAccept) then
            trans.cbAccept();
        end
        
        if (guiW < width) then
            guiW = width;
        end
        
        -- GUI shall be created once accepted
        trans.window = guiCreateWindow(0, 0, guiW, guiH, title, false);
		guiWindowSetSizable(trans.window, false);
        
        local pUpload = guiCreateLabel(10, 25, guiW - 140, 15, "Total Download: 0bytes", false, trans.window);
        local pTime = guiCreateLabel(guiW - 140, 25, 100, 15, "Time: 0secs", false, trans.window);
        local pRate = guiCreateLabel(10, 40, guiW - 20, 15, "Download Rate: 0bytes per second", false, trans.window);
        
        trans.progress = guiCreateProgressBar(10, 60, guiW - 20, 20, false, trans.window);
        
        if (trans.target) then
            guiH = guiH + 15;
            guiSetSize(trans.window, guiW, guiH, false);
            
            trans.targetLabel = guiCreateLabel(10, 80, guiW - 20, 15, "Target: " .. trans.target, false, trans.window);
        end
        
        function trans.frame()
            local elapsed = (getTickCount() - trans.startTime) / 1000;
        
            guiSetText(pUpload, "Total Download: " .. toupbyte(trans.seek));
            guiSetText(pTime, "Time: " .. totimedesc(math.floor(elapsed)));
            guiSetText(pRate, "Download Rate: " .. toupbyte(trans.seek / (elapsed)) .. " per second");
            return true;
        end
        
        local pAbort = guiCreateButton(guiW - 110, guiH - 30, 100, 20, "Abort", false, trans.window);
        
        addEventHandler("onClientGUIClick", pAbort, function(button, state, x, y)
                triggerServerEvent("onDownloadAbort", getRootElement(), id);
                
                destroyElement(trans.window);
                
                downloads[tostring(id)] = nil;
            end, false
        );
        
        outputDebugString("File Transaction (:" .. trans.resource.name .. "/" .. trans.filename .. ", " .. tostring(id) .. ")");
        
        -- We are ready to start
        triggerServerEvent("onDownloadReady", getRootElement(), id);
    end
);

addEventHandler("onClientDownloadAbort", getRootElement(), function(id)
        local trans = downloads[tostring(id)];
        
        if (trans.cbAbort) then
            trans.cbAbort();
        end
        
        outputDebugString("Aborted (" .. tostring(id) .. ")");
        
        if (trans.status == 1) then
            -- Kill window
            destroyElement(trans.window);
        end
        
        if (trans.file) then
            fileClose(trans.file);
        end
        
        transactions[tostring(id)] = nil;
    end
);

addEventHandler("onClientDownloadData", getRootElement(), function(id, data)
        local trans = downloads[tostring(id)];
        
        if not (trans) then return true; end;
        
        if (trans.cbData) then
            trans.cbData(data);
        end
        
        trans.data = trans.data .. data;
        trans.seek = strlen(trans.data) + 1;
        
        if (trans.file) then
            fileWrite(trans.file, data);
        end
        
        -- Update GUI
        guiSetProperty(trans.progress, "CurrentProgress", tostring(trans.seek / trans.size));
        
        -- Send an OK to the server
        triggerServerEvent("onDownloadReady", getRootElement(), id);
    end
);

addEventHandler("onClientDownloadComplete", getRootElement(), function(id)
        local trans = downloads[tostring(id)];
        
        outputDebugString("Complete! (" .. tostring(id) .. ")");
        
        if (trans.file) then
            fileClose(trans.file);
        end
		
        if (trans.cbComplete) then
            trans.cbComplete();
        end
		
        -- Kill window
        destroyElement(trans.window);
        
        downloads[tostring(id)] = nil;
    end
);

addEventHandler("onClientResourceStop", resourceRoot, function()
        -- Delete created files
        if (deleteOnQuit) then
            for m,n in pairs(fileList) do
                fileDelete("@" .. m);
            end
        end
	end
);