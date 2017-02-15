-- Optimizations
local string = string;
local math = math;
local table = table;
local strsub = string.sub;
local strbyte = string.byte;
local strchar = string.char;
local strlen = string.len;
local strfind = string.find;
local strrep = string.rep;
local ipairs = ipairs;
local pairs = pairs;

addEvent("onClientScriptLockAcquire", true);
addEvent("onClientScriptLockFree", true);
addEvent("onResourceDataUpdate", true);
local resourceData={};
local resourceList={};

-- Globals
access = false;
transactionPacketBytes=0;
deleteOnQuit=false;
createClientRepository=false;
currentResource=false;
currentFile=false;

-- Resource GUI
mainGUI=false;
local pEditor=false;
local pResourceInfo=false;
local pFileList=false;
local pTextbox=false;
local pSaveButton=false;
local pCloseButton=false;
local pTabHolder=false;
local pResourceName=false;
local pResourceType=false;
local pResourceDescription=false;
local pResourceAuthor=false;
local pFilename=false;
local pScriptType=false;
local pScriptSize=false;
local pFunctionSearch=false;
local pFunctionList=false;
local pMenu=false;
local pRightClickMenu=false;
local pFunctionTabPanel=false;

-- General
local lastKeyPress=false;
local lastKeyTime=0;
local messageBoxes={};
local editorMode=0;
local enableHighlighting;
local showLineNumbers;
local notifyOnChange;
local useFileManager;
local useResourceSelect;
local showFunctionsFullscreen;
local enableHints;
local colorFunctions;
local showHintDescription;
local functionlistArguments;
local automaticIndentation;
local soundPreview=false;
local library={};
local functionlist={};
local sortedFunctionlist={};
local internalDictionary;
local importedDictionary;
local scriptLock=false;
local requestControlPanel=false;
local serverData;
local version=getVersion();

-- Sub GUI
local pDenyEditorAccessMsg=false;
local pClientConfigGUI=false;
local pServerConfigGUI=false;
local pFileManager=false;
local pSelectGUI=false;
local pScriptDebug=false;
local pUpdateGUI=false;
local pConfigEditor=false;
local pResourceCreation=false;
local pControlPanel=false;
local pPasteGUI=false;

local fileColors = {
	png = { 110, 160, 255 },
	dff = { 220, 220, 75 },
	txd = { 75, 220, 200 },
	mp3 = { 75, 220, 140 },
	wav = { 75, 220, 140 },
	ogg = { 75, 220, 140 },
	riff = { 75, 220, 140 },
	mod = { 75, 220, 140 },
	xm = { 75, 220, 140 },
	it = { 75, 220, 140 },
	s3m = { 75, 220, 140 }
};

local scriptColors = {
	server = { 75, 255, 75 },
	client = { 255, 100, 75 },
	shared = { 200, 75, 220 }
};

local rowSelect=false;
local curSelectRadius=200;

if not (getClipboard) then
	local _setClipboard = setClipboard;
	local buffer = "";

	function setClipboard(text)
		buffer = text;
		
		_setClipboard(text);
		return true;
	end
	
	function getClipboard()
		return buffer;
	end
end

function showMessageBox(msg, title, setting)
    if not (pEditor.isVisible()) then return false; end;

    local msgBox = createMessageBox(msg, title, setting);
    
    addEventHandler("onClientMessageBoxClose", msgBox, function()
            messageBoxes[msgBox] = nil;
        end
    );
    
    messageBoxes[msgBox] = true;
    return msgBox;
end

function initLibrary()
	library = {};
end

function loadDictionary(node)
	local j,k;
	local dictionary = {};
	
	for j,k in ipairs(node.children) do
		local class = {
			functions = {},
			vars = {}
		};
		
		local functions = xmlFindSubNodeEx(k, "functions");
		
		if (functions) then
			local m,n;
		
			for m,n in ipairs(functions.children) do
				local details = {
					name = n.name,
				
					returnType = n.attr.returnType or "void",
					arguments = n.attr.arguments or "",
					textColor = n.attr.textColor,
					backColor = n.attr.backColor,
					
					type = k.name
				};
				
				if (n.attr.description) then
					details.description = parseStringInternal(n.attr.description)
				end
				
				table.insert(class.functions, details);
			end
		end
		
		dictionary[k.name] = class;
	end
	
	table.insert(library, dictionary);
	return dictionary;
end

function importDefinitions(type)
	local m,n;
	
	for m,n in ipairs(library) do
		local class = n[type];
		
		if (class) then
			local x,y;
			
			for x,y in ipairs(class.functions) do
				local functions = functionlist[y.name];
				
				if not (functions) then
					functions = {};
					
					functionlist[y.name] = functions;
				end
				
				table.insert(functions, y);
				table.insert(sortedFunctionlist, y);
			end
		end
	end
end

local function getLexicalDefinition(token)
	if (token == "client") then
		return "Player who sent last event";
	elseif (token == "source") then
		return "Triggered event's source element";
	end
	
	local entry = functionlist[token];
	local text = "";
	local m,n;
	
	if not (entry) then return false; end;
	
	local m,n;
	
	for m,n in ipairs(entry) do
		text = text .. n.returnType .. " " .. token .. " (" .. n.arguments .. ")";
		
		if (showHintDescription) and (n.description) then
			text = text .. "\n\n" .. n.description;
		end
		
		if not (m == #entry) then
			text = text .. "\n\n";
		end
	end
	
	return text;
end

function updateFunctionList()
	if not (mainGUI) then return false; end;
	
	guiGridListClear(pFunctionList);
	
	local sort = guiGetProperty(pFunctionList, "SortDirection");
	guiSetProperty(pFunctionList, "SortDirection", "");
	
	local find = guiGetText(pFunctionSearch);
	
	for m,n in ipairs(sortedFunctionlist) do
		if (string.find(n.name, find, 1, true)) then
			local row = guiGridListAddRow(pFunctionList);
			local display = n.name;
			
			if (functionlistArguments) then
				display = display .. " (" .. n.arguments ..  ")";
			end
			
			guiGridListSetItemText(pFunctionList, row, 1, display, false, false);
			guiGridListSetItemText(pFunctionList, row, 2, n.type, false, false);
			guiGridListSetItemData(pFunctionList, row, 1, m);
		end
	end
	
	guiSetProperty(pFunctionList, "SortDirection", sort);
	
	resizeColumn(pFunctionList, 1, 150);
	return true;
end

function clearDefinitions()
	functionlist = {};
	sortedFunctionlist = {};
	
	guiGridListClear(pFunctionList);
	return true;
end

function unloadDictionary(dict)
	local m,n;
	
	for m,n in ipairs(library) do
		if (n == dict) then
			table.remove(library, m);
			return true;
		end
	end
	
	return false;
end

-- Load the configuration files
local pConfigFile = xmlLoadFile("config.xml");

if not (pConfigFile) then
    local xml = xmlLoadFile("default/config.xml");
	
    pConfigFile = xmlCopyFile(xml, "config.xml");
	
    xmlUnloadFile(xml);
end
local config;
local editor;
local syntax;
local specialsyntax;
local string1;
local string2;
local string3;
local comment1;
local comment2;
local dict;
local clientDict;
local serverDict;
local sharedDict;

local function loadConfig()
    config = xmlGetNode(pConfigFile);
    editor = findCreateNode(config, "editor");
    transfer = findCreateNode(config, "transfer");
    syntax = findCreateNode(config, "syntax");
    specialsyntax = findCreateNode(config, "specialsyntax");
    string1 = findCreateNode(specialsyntax, "string1");
    string2 = findCreateNode(specialsyntax, "string2");
    string3 = findCreateNode(specialsyntax, "string3");
    comment1 = findCreateNode(specialsyntax, "comment1");
    comment2 = findCreateNode(specialsyntax, "comment2");
    dict = findCreateNode(config, "dict");
	clientDict = findCreateNode(dict, "client");
	serverDict = findCreateNode(dict, "server");
	sharedDict = findCreateNode(dict, "shared");

    local function isHexDigit(char)
        if (char > 96) and (char < 103) or
            (char > 47) and (char < 58) or
            (char > 64) and (char < 91) then
            
            return true;
        end
        
        return false;
    end

    -- Set up the nodes
    local m,n;

    function initSyntaxEntry(node)
        function node.cbAddChild(child)
            return false;
        end
        
        function node.cbSetAttribute(key, value)
            if (key == "textColor") or
                (key == "backColor") then
                
                local m;
                local len = strlen(value);
                
                if not (len == 6) then
                    showMessageBox("Color has to be 6 hex digits long.", "Color Error");
                    return false;
                end
                
                for m=1,6 do
                    if not (isHexDigit(strbyte(value, m))) then
                        showMessageBox("Invalid '" .. key .. "'", "Color Error");
                        return false;
                    end
                end
                
                -- We set it here to immediatly have effect
                node.attr[key] = value;
                
				pEditor.parseColor();
                return true;
            end
            
            return true;
        end
        
        function node.cbUnsetAttribute(key)
            if (key == "textColor") or
                (key == "backColor") then
               
                node.attr[key] = nil;

                pEditor.parseColor();            
            end
            
            return true;
        end
        
        return true;
    end

    function initSpecialSyntaxEntry(node)
        function node.cbAddChild(child)
            return false;
        end
        
        function node.cbSetAttribute(key, value)
            if (key == "textColor") or
                (key == "backColor") then
                
                local m,n;
                local len = strlen(value);
                
                if not (len == 6) then
                    showMessageBox("Color has to be 6 hex digits long.", "Color Error");
                    return false;
                end
                
                for m=1,6 do
                    if not (isHexDigit(strbyte(value, m))) then
                        showMessageBox("Invalid '" .. key .. "'", "Color Error");
                        return false;
                    end
                end
                
                -- We set it here to immediatly have effect
                node.attr[key] = value;
                
                -- Update the GUI
                if (pClientConfigGUI) then
                    pClientConfigGUI.updateSyntax(node);
                end
                
                pEditor.parseColor();
                return true;
            end
            
            return true;
        end
        
        function node.cbUnsetAttribute(key)
            if (key == "textColor") or
                (key == "backColor") then
               
                node.attr[key] = nil;
                
                -- Update the GUI
                if (pClientConfigGUI) then
                    pClientConfigGUI.updateSyntax(node);
                end

                pEditor.parseColor();            
            end
            
            return true;
        end
        
        return true;
    end

    for m,n in ipairs(syntax.children) do
        initSyntaxEntry(n);
    end

    for m,n in ipairs(specialsyntax.children) do
        initSpecialSyntaxEntry(n);
    end

    function config.cbRemoveChild(id)
        local node = config.children[id];

        if (node.name == "editor")
			or (node.name == "transfer")
            or (node.name == "syntax")
			or (node.name == "specialsyntax")
            or (node.name == "dict") then
            
            showMessageBox("You cannot remove '" .. node.name .. "'");
            return false;
        end
        
        return true;
    end

    function syntax.cbAddChild(node)
        local n;
        local len = strlen(node.name);

        -- Check if it is a correct name
        for n=1,len do
            if not (isName(strbyte(node.name, n))) then
                showMessageBox("Invalid name given to syntax highlight.", "Invalid Name");
                return false;
            end
        end
        
        initSyntaxEntry(node);
        return true;
    end

    function syntax.cbRemoveChild(id)
        local m,n;

        -- Remove for immediate effect
        syntax.children[id] = nil;
        
        -- Now color parse
        pEditor.parseColor();
        return true;
    end

    function syntax.cbSetAttribute(key, value)
        if (key == "enable") then
            if (value == "true") then
                if (pClientConfigGUI) then
                    guiCheckBoxSetSelected(pClientConfigGUI.enableSyntax, true);
                end
            
                enableHighlighting = true;
				
				pEditor.setColorEnabled(true);
				return true;
            elseif (value == "false") then
                if (pClientConfigGUI) then
                    guiCheckBoxSetSelected(pClientConfigGUI.enableSyntax, false);
                end
				
				enableHighlighting = false;
            
                pEditor.setColorEnabled(false);
				return true;
            else
                showMessageBox("Either 'true' or 'false'.", "Syntax Error");
                return false;
            end
        end
        
        return true;
    end
	
	function syntax.cbUnsetAttribute(key)
		if (key == "enable") then
			showMessageBox("You cannot remove '" .. key .. "'.", "Attribute Error");
			return false;
		end
		
		return true;
	end

    function specialsyntax.cbAddChild(node)
        showMessageBox("You cannot add children to 'specialsyntax'", "Child Creation Failed");
        return false;
    end

    function specialsyntax.cbRemoveChild(id)
        showMessageBox("You cannot remove children from 'specialsyntax'", "Child Removal Failed");
        return false;
    end

    function editor.cbAddChild(node)
        showMessageBox("You cannot add children to the editor.", "Child Creation Failed");
        return false;
    end

    function editor.cbSetAttribute(key, value)
        if (key == "font") then
            if not (value == "default") and
                not (value == "default-bold") and
                not (value == "clear") and
                not (value == "arial") and
                not (value == "sans") and
                not (value == "pricedown") and
                not (value == "bankgothic") and
                not (value == "diploma") and
                not (value == "beckett") then
                
                showMessageBox("Unknown font");
                return false;
            end
            
            charFont = value;
            
            if (pClientConfigGUI) then
				if (charFont == "default") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 0);
				elseif (charFont == "default-bold") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 1);
				elseif (charFont == "clear") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 2);
				elseif (charFont == "arial") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 3);
				elseif (charFont == "sans") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 4);
				elseif (charFont == "pricedown") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 5);
				elseif (charFont == "bankgothic") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 6);
				elseif (charFont == "diploma") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 7);
				elseif (charFont == "beckett") then
					guiComboBoxSetSelected(pClientConfigGUI.font, 8);
				end
            end
            
            pEditor.parseCode();
        elseif (key == "fontSize") then
            local size = tonumber(value);
        
            if not (size) then
                showMessageBox("Invalid fontSize");
                return false;
            end
            
            charScale = size;
            
            if (pClientConfigGUI) then
                guiSetText(pClientConfigGUI.fontSize, value);
            end
            
            pEditor.parseCode();
        elseif (key == "notifyOnChange") then
            if (value == "true") then
                notifyOnChange = true;
            elseif (value == "false") then
                notifyOnChange = false;
            else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
            end
            
            if (pClientConfigGUI) then
                guiCheckBoxSetSelected(pClientConfigGUI.notifyOnChange, notifyOnChange);
            end
        elseif (key == "showLineNumbers") then
            if (value == "true") then
                showLineNumbers = true;
            elseif (value == "false") then
                showLineNumbers = false;
            else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
            end
            
            if (pClientConfigGUI) then
                guiCheckBoxSetSelected(pClientConfigGUI.showLineBar, showLineNumbers);
            end
            
            pEditor.showLineNumbers(showLineNumbers);
        elseif (key == "useFileManager") then
            if (value == "true") then
                useFileManager = true;
                
                if (mainGUI.mode == "file") then
                    mainGUI.nextFileMode();
					
                    showFileManager(true);
                end
            elseif (value == "false") then
                useFileManager = false;
                
                if (pFileManager) and (guiGetVisible(pFileManager.window)) then
                    showFileManager(false);
					
                    mainGUI.nextFileMode();
                end
            else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
            end
            
            if (pClientConfigGUI) then
                guiCheckBoxSetSelected(pClientConfigGUI.useFileManager, useFileManager);
            end
        elseif (key == "useResourceSelect") then
            if (value == "true") then
                useResourceSelect = true;
            elseif (value == "false") then
                useResourceSelect = false;
            else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
            end
		elseif (key == "automaticIndentation") then
            if (value == "true") then
				automaticIndentation = true;
            elseif (value == "false") then
                automaticIndentation = false;
            else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
            end
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.automaticIndentation, automaticIndentation);
			end
			
			pEditor.setAutoIndentEnabled(automaticIndentation);
		elseif (key == "showFunctionsFullscreen") then
			if (value == "true") then
				showFunctionsFullscreen = true;
			elseif (value == "false") then
				showFunctionsFullscreen = false;
			else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
			end
			
			setEditorMode(editorMode);
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.showFunctionsFullscreen, showFunctionsFullscreen);
			end
		end
        
        return true;
    end

    function editor.cbUnsetAttribute(key)
        if (key == "fontSize") or
            (key == "font") or
            (key == "notifyOnChange") or
            (key == "showLineNumbers") or
            (key == "useFileManager") or
			(key == "showFunctionsFullscreen") or
			(key == "automaticIndentation") then
        
            showMessageBox("You cannot remove '" .. key .. "'", "Attribute Error");
            return false;        
        end
        
        return true;
    end
	
	-- Load the internal definitions
	internalDictionary = loadDictionary(dict);
	
	local function initDictionaryNode(node)
		function node.cbAddChild()
			return false;
		end
		
		function node.cbSetAttribute(key, value)
			if (key == "description") then
				return true;
			elseif (key == "returnType") then
				return true;
			elseif (key == "arguments") then
				return true;
			elseif (key == "textColor")
				or (key == "backColor") then
				
				local m,n;
				local len = strlen(value);
				
				if not (len == 6) then
					showMessageBox("Color has to be 6 hex digits long.", "Color Error");
					return false;
				end
				
				for m=1,6 do
					if not (isHexDigit(strbyte(value, m))) then
						showMessageBox("Invalid '" .. key .. "'", "Color Error");
						return false;
					end
				end
				
				-- We set it here to immediatly have effect
				node.attr[key] = value;
				
				-- Update the GUI
				if (pClientConfigGUI) then
					pClientConfigGUI.updateSyntax(k);
				end
				
				parseColor();
				return true;
			else
				showMessageBox("Invalid dictionary attribute '" .. key .. "'", "Invalid Attribute");
				return false;
			end
		end
		
		function node.cbUnsetAttribute(key)
			if (key == "textColor") or
				(key == "backColor") then
				
				node.attr[key] = nil;
				parseColor();     
			elseif (key == "returnType") or
				(key == "arguments") then
				
				showMessageBox("Cannot remove attribute '" .. key .. "'");
				return false;
			end
			
			return true;
		end
	end
	
	function initDictionary(node)
		local j,k;
		local functions = xmlFindSubNodeEx(node, "functions");
		
		if not (functions) then return false; end;
		
		function functions.cbAddChild(node)
			if (string.find(node.name, "[^%a%d_.:]")) then
				showMessageBox("Invalid dictionary entry name", "Child Creation Failed");
				return false
			end
			
			node.attr.returnType = "void";
			node.attr.arguments = "";
			
			local msgBox = showMessageBox("Give in the description.", "Set description", "input");
			
			addEventHandler("onClientMessageBoxClose", msgBox, function(input)
					if not (input) then return false; end;
					
					xmlNotify(node, "set_attribute", "description", input);
					node.attr.description = input;
				end
			);
			
			initDictionaryNode(node);
			return true;
		end
		
		for j,k in ipairs(functions.children) do
			initDictionaryNode(k);
		end
	end
	
	initDictionary(clientDict);
	initDictionary(serverDict);
	initDictionary(sharedDict);
	
	function dict.cbAddChild(node)
		if not (node.name == "client") and not (node.name == "server") and not (node.name == "shared") then
			showMessageBox("Invalid dictionary node '" .. node.name .. "'", "Child Creation Failed");
			return false;
		end
		
		return true;
	end
	
	function dict.cbSetAttribute(key, value)
		if (key == "enableHints") then
			if (value == "true") then
				enableHints = true;
			elseif (value == "false") then
				enableHints = false;
			else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
			end
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.enableHints, enableHints);
			end
		elseif (key == "colorFunctions") then
			if (value == "true") then
				colorFunctions = true;
			elseif (value == "false") then
				colorFunctions = false;
			else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
			end
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.colorFunctions, colorFunctions);
			end
			
			pEditor.parseColor();
		elseif (key == "showHintDescription") then
			if (value == "true") then
				showHintDescription = true;
			elseif (value == "false") then
				showHintDescription = false;
			else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
			end
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.showHintDescription, showHintDescription);
			end
		elseif (key == "functionlistArguments") then
			if (value == "true") then
				functionlistArguments = true;
			elseif (value == "false") then
				functionlistArguments = false;
			else
                showMessageBox("Either 'true' or 'false'", "Boolean Required");
                return false;
			end
			
			updateFunctionList();
		else
			showMessageBox("Invalid dictionary attribute '" .. key .. "'", "Invalid Attribute");
			return false;
		end
		
		return true;
	end
	
	function dict.cbUnsetAttribute(key)
		if (key == "enableHints") or
			(key == "colorFunctions") or
			(key == "showHintDescription") then
			
            showMessageBox("You cannot remove '" .. key .. "'", "Attribute Error");
            return false;        
		end
		
		return true;
	end
	
	function transfer.cbAddChild(name)
		showMessageBox("You cannot add children to transfer.", "Child Creation Failed");
		return false;
	end
	
	function transfer.cbSetAttribute(key, value)
		if (key == "mtu") then
			local mtu = tonumber(value);
			
			if not (mtu) then
				showMessageBox("You did not specify a valid Maximum Transfer Unit.");
				return false;
			end
			
			if (mtu < 256) or (mtu > 65535) then
				showMessageBox("Invalid MTU (256 - 65535).", "Invalid Value");
				return false;
			end
			
			transactionPacketBytes = mtu;
			
			if (pClientConfigGUI) then
				guiSetText(pClientConfigGUI.mtu, value);
			end
		elseif (key == "deleteOnQuit") then
			
		elseif (key == "createRepository") then
			if (value == "true") then
				createClientRepository = true;
			elseif (value == "false") then
				createClientRepository = false;
			else
				showMessageBox("Either 'true' or 'false'.", "Boolean Required");
				return false;
			end
			
			if (pClientConfigGUI) then
				guiCheckBoxSetSelected(pClientConfigGUI.createRepository, createClientRepository);
			end
		end
		
		return true;
	end
	
	function transfer.cbUnsetAttribute(key)
		if (key == "mtu") or
			(key == "deleteOnQuit") or
			(key == "createRepository") then
			
			showMessageBox("You cannot remove '" .. key .. "'", "Attribute Error");
			return false;
		end
		
		return true;
	end

    -- Set some configurations
    charScale = tonumber(editor.attr.fontSize);
    charFont = editor.attr.font;
    enableHighlighting = (syntax.attr.enable == "true");
    showLineNumbers = (editor.attr.showLineNumbers == "true");
    notifyOnChange = (editor.attr.notifyOnChange == "true");
    useFileManager = (editor.attr.useFileManager == "true");
    useResourceSelect = (editor.attr.useResourceSelect == "true");
	showFunctionsFullscreen = (editor.attr.showFunctionsFullscreen == "true");
	automaticIndentation = (editor.attr.automaticIndentation == "true");
    transactionPacketBytes = tonumber(transfer.attr.mtu);
    deleteOnQuit = (transfer.attr.deleteOnQuit == "true");
	createClientRepository = (transfer.attr.createRepository == "true");
	enableHints = (dict.attr.enableHints == "true");
	colorFunctions = (dict.attr.colorFunctions == "true");
	showHintDescription = (dict.attr.showHintDescription == "true");
	functionlistArguments = (dict.attr.functionlistArguments == "true");
end
loadConfig();

function showResourceSelect(bShow)
    if (bShow == true) then
        if not (pSelectGUI) then
            local screenWidth, screenHeight = guiGetScreenSize();
            local guiW, guiH=300,450;
            
            pSelectGUI = {};
            
            local window = guiCreateWindow((screenWidth - guiW) / 2, (screenHeight - guiH) / 2, guiW, guiH, "Select Resource", false);
            pSelectGUI.window = window;
            
            local pList = guiCreateGridList(20, 40, guiW - 40, guiH - 60, false, window);
			guiSetProperty(pList, "ColumnsMovable", "False");
			guiSetProperty(pList, "ColumnsSizable", "False");
            guiGridListAddColumn(pList, "Resource", 0.3);
            guiGridListAddColumn(pList, "Real Name", 0.4);
            
            local function resizeColumn(column, width)
                local n = 0;
                local rowcount = guiGridListGetRowCount(pList);
                
                while (n < rowcount) do
                    local curWidth = dxGetTextWidth(guiGridListGetItemText(pList, n, column)) + 20;
                    
                    if (width < curWidth) then
                        width = curWidth;
                    end
                
                    n = n + 1;
                end
                
                return guiGridListSetColumnWidth(pList, column, width, false);
            end
            
            function pSelectGUI.update()
                guiGridListClear(pList);
				
                local m,n;
                local sort = guiGetProperty(pList, "SortDirection");
                
                guiSetProperty(pList, "SortDirection", "");
                
                for m,n in ipairs(resourceList) do
                    if (access.resources[n]) then
                        local resource = resourceData[n];
                        local row = guiGridListAddRow(pList);
                        
                        guiGridListSetItemText(pList, row, 1, n, false, false);
                        guiGridListSetItemText(pList, row, 2, resource.realname, false, false);
                        
                        guiGridListSetItemData(pList, row, 1, n);
                    end
                end
				
                resizeColumn(1, 100);
                resizeColumn(2, 50);
                
                guiSetProperty(pList, "SortDirection", sort);
                return true;
            end
            
            addEventHandler("onClientGUIClick", pList, function(button, state, x, y)
                    local row=guiGridListGetSelectedItem(pList);
                    
                    if (row == -1) then return false; end;

                    local res = guiGridListGetItemData(pList, row, 1);
					
					if (scriptLock) then
						-- We no longer can handle the script lock
						triggerServerEvent("onClientFreeScriptLock", root);
					end
                    
                    currentResource = resourceData[res];

                    outputDebugString("Selected resource '" .. res .. "'");
					
					pEditor.setText("");
					
                    guiSetText(pScriptSize, "0");
                    guiSetText(pFilename, "");
                    guiSetText(pScriptType, "");
					mainGUI.updateResource();
                    
                    showResourceSelect(false);
                end, false
            );
            
            addEventHandler("onClientGUISize", window, function()
                    local width, height = guiGetSize(window, false);
                    
                    width = math.max(guiW, width);
                    height = math.max(guiH, height);
                    
                    guiSetSize(window, width, height, false);
                    guiSetSize(pList, width - 40, height - 60, false);
                end, false
            );
        else
            guiSetVisible(pSelectGUI.window, true);
            guiBringToFront(pSelectGUI.window);
        end
        
        -- Update it
        pSelectGUI.update();
    else
        if (pSelectGUI) then
            guiSetVisible(pSelectGUI.window, false);
        end
    end
    return true;
end

function showScriptDebug(bShow)
    if (bShow == true) then
        local screenW, screenH = guiGetScreenSize();
        local guiW = screenW-600;
        local guiH = 225;
        local posX = 250;
        local posY = screenH - guiH - 40;

        if not (pScriptDebug) then
			local buffer = "";
		
			pScriptDebug = {};
		
			local window = guiCreateWindow(posX, posY, guiW, guiH, "Script Debug", false);
            guiWindowSetSizable(window, false);
			pScriptDebug.window = window;
			
            local pOutput = guiCreateMemo(10, 25, guiW-20, guiH-50, "", false, window);
            guiMemoSetReadOnly(pOutput, true);
			
			local pClear = guiCreateButton(guiW - 215, 200, 100, 20, "Clear", false, window);
			
			addEventHandler("onClientGUIClick", pClear, function()
					buffer = "";
					
					guiSetText(pOutput, "");
				end, false
			);
			
            local pClose = guiCreateButton(guiW-110, 200, 100, 20, "Close", false, window);
            
            addEventHandler("onClientGUIClick", pClose, function(button, state, x, y)
                    showScriptDebug(false);
                end, false
            );
			
			function pScriptDebug.output(text)
				if not (strbyte(text, strlen(text)) == 10) then
					text = text .. "\n";
				end
				
				buffer = buffer .. text;
				
				guiSetText(pOutput, buffer);
				guiSetProperty(pOutput, "CaratIndex", tostring(strlen(buffer) - 1));
				
				guiBringToFront(window);
				return true;
			end
        else
            guiSetVisible(pScriptDebug.window, true);
            guiBringToFront(pScriptDebug.window);
        end
		
        guiSetPosition(pScriptDebug.window, posX, posY, false);
    else
        if (pScriptDebug) then
            guiSetVisible(pScriptDebug.window, false);
        end
    end
	
    return true;
end

function showUpdateGUI(bShow, text, time, fade)
    if (bShow == true) then
        if not (pUpdateGUI) then
            local screenWidth, screenHeight = guiGetScreenSize();
            local guiW, guiH = 325, 125;
			
			pUpdateGUI = {};
            
			local window = guiCreateWindow(screenWidth-guiW, screenHeight-guiH, guiW, guiH, "Update!", false);
            guiWindowSetMovable(window, false);
            guiWindowSetSizable(window, false);
			pUpdateGUI.window = window;
			
            local pUpdate = guiCreateMemo(5, 15, guiW - 10, guiH - 15, "", false, window);
            guiMemoSetReadOnly(pUpdate, true);
            pUpdateGUI.update = pUpdate;
			
			-- Event optimization, all child events get destroyed, yo
			addEventHandler("onClientRender", root, function()
					if not (guiGetVisible(window) == true) then return false; end;
					
					local now = getTickCount();
					
					if (pUpdateGUI.showstart + pUpdateGUI.showtime < now) then
						showUpdateGUI(false);
						return true;
					end
					
					if (getTickCount() - pUpdateGUI.showstart <= pUpdateGUI.fadetime) then
						local fadeTime = now - pUpdateGUI.showstart;
						guiSetProperty(window, "Alpha", tostring(fadeTime / pUpdateGUI.fadetime));
					elseif (now - pUpdateGUI.showstart > pUpdateGUI.showtime - pUpdateGUI.fadetime) then
						local fadeTime = pUpdateGUI.showtime - (now - pUpdateGUI.showstart);
						guiSetProperty(window, "Alpha", tostring(fadeTime / pUpdateGUI.fadetime));
					else
						guiSetProperty(window, "Alpha", "1");
					end
				end
			);
        else
            guiSetVisible(pUpdateGUI.window, true);
            guiBringToFront(pUpdateGUI.window);
        end
        
        -- Make it fade in
        pUpdateGUI.showstart = getTickCount();
		
        if not (time) then
            pUpdateGUI.showtime = 5000;
        else
            pUpdateGUI.showtime = time;
        end
		
        if not (fade) then
            pUpdateGUI.fadetime = 1000;
        else
            pUpdateGUI.fadetime = fade;
        end
		
        guiSetText(pUpdateGUI.update, text);
    else
        if (pUpdateGUI) then
            guiSetVisible(pUpdateGUI.window, false);
        end
    end
	
    return true;
end

function showConfigEditor(bShow)
    if (bShow == true) then
        if not (pConfigEditor) then
            local guiW, guiH = 0, 0;
			
			--pConfigEditor = {};
        else
            guiSetVisible(pConfigEditor.window, true);
            guiBringToFront(pConfigEditor.window);
        end
    else
        if (pConfigEditor) then
            guiSetVisible(pConfigEditor.window, false);
        end
    end
	
    return true;
end

function showResourceCreation(bShow)
    if (bShow == true) then
        if not (pResourceCreation) then
            local screenWidth, screenHeight = guiGetScreenSize();
            local guiW, guiH = 450,175;
			
			pResourceCreation = {};
			
            local window = guiCreateWindow((screenWidth - guiW)/2, (screenHeight - guiH)/2, guiW, guiH, "Resource Creation", false);
            guiWindowSetSizable(window, false);
			pResourceCreation.window = window;
            
            guiCreateLabel(10, 25, 50, 14, "Name:", false, window);
            local pName = guiCreateEdit(60, 25, guiW-70, 18, "", false, window);
			pResourceCreation.name = pName;
			
            guiCreateLabel(10, 45, 50, 14, "Type:", false, window);
            local pType = guiCreateEdit(60, 45, guiW-70, 18, "", false, window);
			pResourceCreation.type = pType;

            guiCreateLabel(10, 65, 85, 15, "Description:", false, window);
            local pDescription = guiCreateMemo(95, 65, guiW-105, 54, "", false, window);
			pResourceCreation.description = pDescription;
			
            -- Buttons
            local buttonOffset = 125;
            local pCreate = guiCreateButton(10, buttonOffset, guiW-20, 20, "Create", false, window);
            
            addEventHandler("onClientGUIClick", pCreate, function()
                    -- Check if everything is filled out correctly
                    local name = string.gsub(guiGetText(pName), "[^a-z,A-Z,0-9,_,-]", "");
                    local ttype = string.gsub(guiGetText(pType), "[^a-z,_,-]", "");
                    local description=guiGetText(pDescription);
                    
                    if (string.len(name) < 4) then
                        showMessageBox("Invalid resource name", "Creation Failed");
                        return false;
                    end
					
                    if (string.len(ttype) == 0) then
                        showMessageBox("Invalid resource type", "Creation Failed");
                        return false;
                    end
					
                    triggerServerEvent("onClientRequestResourceCreation", root, name, ttype, description);
                    showResourceCreation(false);
                end, false
            );
            
            local pCancel = guiCreateButton(10, buttonOffset+20, guiW-20, 20, "Cancel", false, window);
            
            addEventHandler("onClientGUIClick", pCancel, function()
                    showResourceCreation(false);
                end, false
            );
        else
            guiSetVisible(pResourceCreation.window, true);
            guiBringToFront(pResourceCreation.window);
            
            -- Clean up GUI
            guiSetText(pResourceCreation.name, "");
            guiSetText(pResourceCreation.type, "");
            guiSetText(pResourceCreation.description, "");
        end
    else
        if (pResourceCreation) then
            guiSetVisible(pResourceCreation.window, false);
        end
    end
end

function enterEditorMode()
	local screenW, screenH = guiGetScreenSize();

    if (editorMode == 0) then
        guiSetVisible(pFileList, true);
        guiSetVisible(pSaveButton, true);
        guiSetVisible(pCloseButton, true);
        guiSetVisible(pTabHolder, true);
		guiSetVisible(pFunctionSearch, true);
		guiSetVisible(pFunctionList, true);
		
		guiSetPosition(pFunctionSearch, screenW - 348, 315, false);
		guiSetPosition(pFunctionList, screenW - 350, 335, false);
		
		guiSetSize(pFunctionList, 350, screenH - 335, false);
		
		-- Update the editor
		pEditor.setPosition(250, 40);
		pEditor.setSize(screenW - 600, screenH - 80);
    elseif (editorMode == 1) then
		-- Update the editor
		pEditor.setPosition(0, 40);
	
		if (showFunctionsFullscreen) then
			guiSetVisible(pFunctionSearch, true);
			guiSetVisible(pFunctionList, true);
			
			guiSetPosition(pFunctionSearch, screenW - 348, 20, false);
			guiSetPosition(pFunctionList, screenW - 350, 40, false);
			guiSetSize(pFunctionList, 350, screenH - 40, false);
			
			-- Set the tabpanel width smaller
			pEditor.setSize(screenW - 350, screenH - 40);
		else
			-- Fullscreen mode
			pEditor.setSize(screenW, screenH - 40);
		end
	end
	
	-- Temporary
	pFunctionTabPanel.setPosition(pEditor.x, pEditor.y - 20);
	pFunctionTabPanel.setSize(pEditor.width, 20);
end

function leaveEditorMode()
    if (editorMode == 0) then
        guiSetVisible(pFileList, false);
        guiSetVisible(pSaveButton, false);
        guiSetVisible(pCloseButton, false);
        guiSetVisible(pTabHolder, false);
		guiSetVisible(pFunctionSearch, false);
		guiSetVisible(pFunctionList, false);
    elseif (editorMode == 1) then
		guiSetVisible(pFunctionSearch, false);
		guiSetVisible(pFunctionList, false);
	end
end

function setEditorMode(mode)
    if not (mainGUI) then return false; end;
	
    -- Exit out mode
    leaveEditorMode();
    
    editorMode = math.mod(math.floor(mode), 2);
	
	-- Init new mode
	enterEditorMode();
    
    pEditor.calculate();
    return true;
end

-- Internal routine for color recalculation, is used by editor to generate colors
function getColorFromToken(token)
	local char = strbyte(token);

	if (char == 34) then    -- '"'
		if not (string1.attr.backColor) then
			return tonumbersign("0x" .. (string1.attr.textColor or "000000") .. "FF");
		end
		
		return tonumbersign("0x" .. (string1.attr.textColor or "000000") .. "FF"), tonumbersign("0x" .. string1.attr.backColor .. "FF");
	elseif (char == 39) then     -- "'"
		if not (string2.attr.backColor) then
			return tonumbersign("0x" .. (string2.attr.textColor or "000000") .. "FF");
		end
		
		return tonumbersign("0x" .. (string2.attr.textColor or "000000") .. "FF"), tonumbersign("0x" .. string2.attr.backColor .. "FF");
	elseif (strsub(token, 1, 4) == "--[[") then
		if not (comment2.attr.backColor) then
			return tonumbersign("0x" .. (comment2.attr.textColor or "000000") .. "FF");
		end
		
		return tonumbersign("0x" .. (comment2.attr.textColor or "000000") .. "FF"), tonumbersign("0x" .. comment2.attr.backColor .. "FF");
	elseif (strsub(token, 1, 2) == "--") then
		if not (comment1.attr.backColor) then
			return tonumbersign("0x" .. (comment1.attr.textColor or "000000") .. "FF");
		end
		
		return tonumbersign("0x" .. (comment1.attr.textColor or "000000") .. "FF"), tonumbersign("0x" .. comment1.attr.backColor .. "FF");
	else
		local colorNode = xmlFindSubNodeEx(syntax, token);
		
		if (colorNode) then
			if not (colorNode.attr.backColor) then
				return tonumbersign("0x" .. (colorNode.attr.textColor or "000000") .. "FF");
			end
			
			return tonumbersign("0x" .. (colorNode.attr.textColor or "000000") .. "FF"), tonumbersign("0x" .. colorNode.attr.backColor .. "FF");
		elseif (colorFunctions) then
			local entry = functionlist[token];
			
			if (entry) and (entry.textColor) then
				if not (entry.backColor) then
					return tonumbersign("0x" .. entry.textColor .. "FF");
				end
				
				return tonumbersign("0x" .. entry.textColor .. "FF"), tonumbersign("0x" .. entry.backColor .. "FF");
			end
		end
	end
	
	return false;
end

local function getLineNumberFromError(data)
    local m;
    local len = strlen(data);
    local args = 0;
    local didpass = false;
    local instring = false;
    local didfind = false;
    local findstart = 0;
    
    for m=1,len do
        local char = strbyte(data, m);
        
        if (char == 91) then    -- [
            if not (instring) then
                args = args + 1;
            end
        elseif (char == 93) then    -- ]
            if not (instring) then
                args = args - 1;
                if (args==0) then
                    didpass = true;
                end
            end
        elseif (char == 34) then    -- "
            if (instring) then
                instring = false;
            else
                instring = true;
            end
        elseif (char == 58) then    -- :
            if not (instring) then
                if (didfind) then
					return tonumber(strsub(data, findstart, m - 1));
                end
				
				didfind = true;
				findstart = m + 1;
            end
        end
    end
	
    return 1;
end

addEventHandler("onClientKey", root, function(button, state)
	if exports.global:isPlayerScripter(getLocalPlayer()) then
		if not (state) then return false; end;
		
		if not (mainGUI) or not (mainGUI.visible) then
			if (button == "F6") then
				showResourceGUI(true);
			end
		else		
			if (button == "F7") then
				setEditorMode(editorMode + 1);
			elseif (button == "F6") then
				showResourceGUI(false);
			elseif (button == "F5") then
				xmlCreateEditor(config);
			elseif (button == "F4") then
				if (useFileManager) then
					showFileManager(true);
				else
					mainGUI.nextFileMode();
				end
			elseif (button == "F3") then
				local routine, error = loadstring(pEditor.getText());
				local line;
				
				if (routine) then
					showCursorHint("Parsed successfully!");
					return true;
				end
				
				showScriptDebug(true);
				pScriptDebug.output(error);
				
				line = getLineNumberFromError(error);
				
				-- Set the cursor to the line
				pEditor.setCursor(pEditor.getLine(line));
			elseif (button == "F2") then
				showControlPanel(true);
			end
		end
	end
	end
);

function executeFile(file)
    local ext = getFileExtension(file.src);

    if (ext == "png") then
        if not (file.type == "client") then return false; end;

		local trans = getFile(file.src);
		
		function trans.cbComplete()
			if not (file.width) then
				local png = fileOpen("@" .. trans.target);
				
				fileSetPos(png, 16);
				
				local width = fileRead(png, 4);
				file.width = bytes_to_int(string.byte(width, 1, 4));
				local height = fileRead(png, 4);
				file.height = bytes_to_int(string.byte(height, 1, 4));
				
				fileClose(png);
				
				outputDebugString("Cached .png info ('" .. trans.target .. "')");
			end
			
			mainGUI.createImagePreview("@" .. trans.target, file.width, file.height);
			return true;
		end
    elseif (ext == "mp3") or
        (ext == "wav") or
        (ext == "ogg") or
        (ext == "riff") or
        (ext == "mod") or
        (ext == "xm") or
        (ext == "it") or
        (ext == "s3m") then
        
        if not (file.type == "client") then return false; end
        
		local trans = getFile(file.src);
		
		function trans.cbComplete()
			if (soundPreview) then
				destroyElement(soundPreview);
			end
			
			soundPreview = playSound("@" .. trans.target);
			
			if not (soundPreview) then return false; end;
			
			addEventHandler("onClientElementDestroy", soundPreview, function()
					soundPreview = false;
				end, false
			);
			return true;
		end
    elseif (ext == "xml") or
        (ext == "map") then
        
        local trans = getFile(file.src);
        
        function trans.cbAbort()
            showMessageBox("Failed to request '" .. file.src .. "'", "Request Aborted");
            return true;
        end
        
        function trans.cbComplete()
			local node;
			local xml = xmlLoadFile("@" .. trans.target);
				
			node = xmlGetNode(xml);
            
            if not (node) then
				pEditor.setText(trans.data);
				
				clearDefinitions();
            
                showMessageBox("Corrupted .xml file", "XML Error");
                return true;
            end
            
            local editor = xmlCreateEditor(node);
            
            addEventHandler("onClientElementDestroy", editor.window, function()
                    local m,n;
            
                    -- Kill children
                    for m,n in ipairs(editor.node.children) do
                        xmlNotify(n, "destroy");
                    end
                    
                    -- Send the node as plaintext
					xmlSetNode(xml, node);
					xmlSaveFile(xml);
					xmlUnloadFile(xml);
					
					xml = fileOpen("@" .. trans.target);
					
					local xmltrans = sendFile(file.src, fileRead(xml, fileGetSize(xml)));
					
					fileClose(xml);
                    
                    function xmltrans.cbAbort()
                        showMessageBox("Failed to update XML file", "Transaction Error");
                        return true;
                    end
                    
                    function xmltrans.cbComplete()
                        showUpdateGUI(true, "Saved successfully");
                        return true;
                    end
                end, false
            );
            return true;
        end
    elseif (ext == "txt") then
        local trans = getFile(file.src);
        
        function trans.cbComplete()
			pEditor.setText(trans.data);
			
			clearDefinitions();
            return true;
        end
    end
end

function showFileManager(bShow)
    if (bShow == true) then
        if not (pFileManager) then
            local screenW, screenH = guiGetScreenSize();
            local guiW, guiH = 450, 400;
            
            pFileManager = {};
            pFileManager.window = guiCreateWindow((screenW - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, "File Manager", false);
            
            local pList = guiCreateGridList(guiW - 210, 25, 200, guiH - 30, false, pFileManager.window);
            guiGridListAddColumn(pList, "Resource File", 0.5);
            guiGridListAddColumn(pList, "Type", 0.25);
            
            addEventHandler("onClientGUIDoubleClick", pList, function(button, state, x, y)
                    local row = guiGridListGetSelectedItem(pList);
                    
                    if (row == -1) then return false; end;
                    
                    executeFile(currentResource.files[tonumber(guiGridListGetItemData(pList, row, 1))]);
                end, false
            );
            
            local pClose = guiCreateButton(10, guiH - 30, guiW - 225, 20, "Close", false, pFileManager.window);
            
            addEventHandler("onClientGUIClick", pClose, function(button, state, x, y)
                    showFileManager(false);
                end, false
            );
            
            function pFileManager.update()
                guiGridListClear(pList);
                local sort = guiGetProperty(pList, "SortDirection");
                
                guiSetProperty(pList, "SortDirection", "");
            
                for m,n in ipairs(currentResource.files) do
                    local row = guiGridListAddRow(pList);
                    guiGridListSetItemText(pList, row, 1, n.src, false, false);
                    guiGridListSetItemText(pList, row, 2, n.type, false, false);
                    guiGridListSetItemData(pList, row, 1, tostring(m));
                    
                    local colorType = fileColors[getFileExtension(n.src)];
					
					if not (colorType) then
						colorType = { 255, 255, 255 };
					end
					
					colorType[4] = 255;
                    
					guiGridListSetItemColor(pList, row, 1, unpack(colorType));
                end
                
                guiSetProperty(pList, "SortDirection", sort);
                
                resizeColumn(pList, 1, 100);
                return true;
            end
            
            addEventHandler("onClientGUISize", pFileManager.window, function()
                    local width, height = guiGetSize(pFileManager.window, false);
                    
                    width = math.max(guiW, width);
                    height = math.max(guiH, height);
                    
                    guiSetSize(pFileManager.window, width, height, false);
                    guiSetSize(pList, width - 250, height - 30, false);
                    
                    guiSetPosition(pClose, 10, height - 30, false);
                end, false
            );
            
            -- Update it
            pFileManager.update();
        else
            guiSetVisible(pFileManager.window, true);
            guiBringToFront(pFileManager.window);
        end
    else
        if (pFileManager) then
            guiSetVisible(pFileManager.window, false);
        end
    end
end

addEventHandler("onClientScriptLockAcquire", root, function(resource, filename)
        local res = resourceData[resource];
        local m,n;
        
        for m,n in ipairs(res.scripts) do
            if (n.src == filename) then
                if (source == getLocalPlayer()) and (res == currentResource) and (filename == currentFile.src) then
                    guiSetEnabled(pSaveButton, true);
                    
                    scriptLock = n;
                end
                
                n.lockClient = source;
                
                outputDebugString(getPlayerName(source) .. " acquired script lock: :"..resource.."/"..filename);
                return true;
            end
        end
    end
);

addEventHandler("onClientScriptLockFree", root, function(resource, filename)
        local res = resourceData[resource];
        local m,n;
        
        for m,n in ipairs(res.scripts) do
            if (n.src == filename) then
				if (source == getLocalPlayer()) then
					guiSetEnabled(pSaveButton, false);
				
					scriptLock = false;
				elseif (res == currentResource) and (currentFile == n) then
                    if not (scriptLock) then
                        triggerServerEvent("onClientRequestScriptLock", root, currentResource.name, currentFile.src);
                    end
                end
                
                n.lockClient = false;
                
                outputDebugString(getPlayerName(source) .. " released script lock");
                return true;
            end
        end
    end
);

-- todo
function showDictionary(show)
	if (show == true) then

	else
	
	end
end

function showControlPanel(show)
	if (show == true) then
		if not (pControlPanel) then
			local guiW, guiH = 725, 520;
			local screenW, screenH = guiGetScreenSize();
			
			pControlPanel = {};
			
			local window = guiCreateWindow((screenW - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, "Server Control Panel", false);
			guiWindowSetSizable(window, false);
			pControlPanel.window = window;
			
			local pTabHolder = guiCreateTabPanel(0, 20, guiW, guiH - 55, false, window);
			
			-- General tab
			local pGeneral = guiCreateTab("General", pTabHolder);
			
			guiCreateLabel(20, 20, 150, 15, "Maximum Transfer Unit:", false, pGeneral);
			local pMTU = guiCreateEdit(170, 18, 75, 20, "", false, pGeneral);
			
			-- Access tab
			local pAccess = guiCreateTab("Access", pTabHolder);
			
			local pAccounts = guiCreateGridList(20, 20, 180, guiH - 155, false, pAccess);
			guiGridListAddColumn(pAccounts, "Account", 0.87);
			
			local pAddAccount = guiCreateButton(20, guiH - 135, 180, 20, "Add Access", false, pAccess);
			
			local pRemoveAccount = guiCreateButton(20, guiH - 115, 180, 20, "Remove Access", false, pAccess);
			
			local pRights = guiCreateGridList(215, 20, guiW - 250, guiH - 160, false, pAccess);
			guiGridListAddColumn(pRights, "Object", 0.6);
			guiGridListAddColumn(pRights, "Allow", 0.25);
			
			local pNewObject = guiCreateButton(215, guiH - 140, 140, 20, "New Object", false, pAccess);
			
			local pDeleteObject = guiCreateButton(355, guiH - 140, 140, 20, "Delete Object", false, pAccess);
			
			local pDefaultAccess = guiCreateButton(550, guiH - 140, 140, 20, "See Default", false, pAccess);
			
			guiCreateLabel(220, guiH - 115, 125, 15, "Amount of objects:", false, pAccess);
			local pAmountOfObjects = guiCreateLabel(345, guiH - 115, 40, 15, "0", false, pAccess);
			
			-- Buttons
			local pSetPassword = guiCreateButton(15, guiH - 30, 150, 20, "Set Password", false, window);
			
			local pClose = guiCreateButton(guiW - 150, guiH - 30, 120, 20, "Close", false, window);
			
			addEventHandler("onClientGUIClick", pClose, function()
					showControlPanel(false);
				end, false
			);
		else
			guiSetVisible(pControlPanel.window, true);
		end
	else
		if (pControlPanel) then
			guiSetVisible(pControlPanel.window, false);
		end
	end
end

function showClientConfig(bShow)
    if (bShow == true) then
        if not (pClientConfigGUI) then
            local screenW,screenH = guiGetScreenSize();
            local guiW = 450;
            local guiH = 300;
            local m,n;
            
            pClientConfigGUI = {};
            
            local window = guiCreateWindow((screenW - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, "Client Preferences", false);
            guiWindowSetSizable(window, false);
            
            pClientConfigGUI.window = window;
            pClientConfigGUI.subwindows = {};
            
            local function showConfigMessageBox(msg, title, usage)
                local msgbox = createMessageBox(msg, title, usage);
                
                addEventHandler("onClientMessageBoxClose", msgbox, function()
                        local m,n;
                        
                        for m,n in ipairs(pClientConfigGUI.subwindows) do
                            if (n == msgbox) then
                                table.remove(pClientConfigGUI.subwindows, m);
                                break;
                            end
                        end
                    end
                );
                
                table.insert(pClientConfigGUI.subwindows, msgbox);
                return msgbox;
            end
            
            local pTabPanel=guiCreateTabPanel(0, 20, guiW, guiH-55, false, window);
            
            -- Editor
            local pEditorTab = guiCreateTab("Editor", pTabPanel);
            
            guiCreateLabel(20, 20, 55, 15, "Font Size:", false, pEditorTab);
            
            local pFontSize=guiCreateEdit(90, 18, 40, 20, tostring(charScale), false, pEditorTab);
            pClientConfigGUI.fontSize = pFontSize;
            
            guiCreateLabel(20, 45, 40, 15, "Font:", false, pEditorTab);
            
            local pFont = guiCreateComboBox(90, 43, 100, 170, "", false, pEditorTab);
                
			-- List all fonts
			guiComboBoxAddItem(pFont, "default");
			guiComboBoxAddItem(pFont, "default-bold");
			guiComboBoxAddItem(pFont, "clear");
			guiComboBoxAddItem(pFont, "arial");
			guiComboBoxAddItem(pFont, "sans");
			guiComboBoxAddItem(pFont, "pricedown");
			guiComboBoxAddItem(pFont, "bankgothic");
			guiComboBoxAddItem(pFont, "diploma");
			guiComboBoxAddItem(pFont, "beckett");

            pClientConfigGUI.font = pFont;
            
            local pNotifyOnChange = guiCreateCheckBox(20, 85, guiW - 40, 15, "Warn me if script progress might be lost", false, false, pEditorTab);
            pClientConfigGUI.notifyOnChange = pNotifyOnChange;
            
            local pShowLineBar = guiCreateCheckBox(20, 105, guiW - 40, 15, "Show line numbers", false, false, pEditorTab);
            pClientConfigGUI.showLineBar = pShowLineBar;
            
            local pUseFileManager = guiCreateCheckBox(20, 125, guiW - 40, 15, "Use File Manager for file viewing", false, false, pEditorTab);
            pClientConfigGUI.useFileManager = pUseFileManager;
			
			local pShowFunctionsFullscreen = guiCreateCheckBox(20, 145, guiW - 40, 15, "Show functionlist in fullscreen", false, false, pEditorTab);
			pClientConfigGUI.showFunctionsFullscreen = pShowFunctionsFullscreen;
			
			local pAutomaticIndentation = guiCreateCheckBox(20, 165, guiW - 40, 15, "Enable automatic indentation", false, false, pEditorTab);
			pClientConfigGUI.automaticIndentation = pAutomaticIndentation;
			
            -- Syntax coloring
            local pSyntax=guiCreateTab("Syntax", pTabPanel);
            
            local pEnableSyntax=guiCreateCheckBox(20, 20, guiW - 40, 15, "Enable Syntax Highlighting", false, false, pSyntax);
            pClientConfigGUI.enableSyntax = pEnableSyntax;
            
            local pSyntaxList=guiCreateGridList(20, 45, guiW - 60, guiH - 160, false, pSyntax);
            guiGridListAddColumn(pSyntaxList, "Syntax", 0.4);
            guiGridListAddColumn(pSyntaxList, "Color", 0.5);
            pClientConfigGUI.syntaxList = pSyntaxList;
            
            addEventHandler("onClientGUIDoubleClick", pSyntaxList, function(button, state, x, y)
                    local row = guiGridListGetSelectedItem(pSyntaxList);
                    
                    if (row == -1) then return false; end;
                    
                    local node = specialsyntax.children[tonumber(guiGridListGetItemData(pSyntaxList, row, 1))];
                    
                    xmlCreateEditor(node);
                end, false
            );
            
            function pClientConfigGUI.updateSyntax(child)
                local rowcount = guiGridListGetRowCount(pSyntaxList);
                local j,k;
                n=0;
                
                -- Find out id of child
                for j,k in ipairs(specialsyntax.children) do
                    if (k == child) then
                        while (n < rowcount) do
                            if (tonumber(guiGridListGetItemData(pSyntaxList, n, 1)) == j) then
                                if (child.attr.textColor) and (child.attr.backColor) then
                                    guiGridListSetItemText(pSyntaxList, n, 2, child.attr.textColor .. ", " .. child.attr.backColor, false, false);
                                elseif (child.attr.textColor) then
                                    guiGridListSetItemText(pSyntaxList, n, 2, child.attr.textColor.. ", ", false, false);
                                elseif (child.attr.backColor) then
                                    guiGridListSetItemText(pSyntaxList, n, 2, ", " .. child.attr.backColor, false, false);
                                end
                                break;
                            end
                        
                            n = n + 1;
                        end
                        
                        break;
                    end
                end
            end
            
            -- Fill it with specialsyntax
            for m,n in ipairs(specialsyntax.children) do
                local row = guiGridListAddRow(pSyntaxList);
                guiGridListSetItemText(pSyntaxList, row, 1, n.name, false, false);
                
                if (n.attr.textColor) and (n.attr.backColor) then
                    guiGridListSetItemText(pSyntaxList, row, 2, n.attr.textColor .. ", " .. n.attr.backColor, false, false);
                elseif (n.attr.textColor) then
                    guiGridListSetItemText(pSyntaxList, row, 2, n.attr.textColor.. ", ", false, false);
                elseif (n.attr.backColor) then
                    guiGridListSetItemText(pSyntaxList, row, 2, ", " .. n.attr.backColor, false, false);
                end
                
                guiGridListSetItemData(pSyntaxList, row, 1, tostring(m));
            end
            
            local pOpenAdvancedSyntax=guiCreateButton(20, guiH - 115, guiW - 60, 20, "Advanced Syntax Settings", false, pSyntax);
            
            addEventHandler("onClientGUIClick", pOpenAdvancedSyntax, function(button, state, x, y)
                    xmlCreateEditor(syntax);
                end, false
            );
            
            -- Dictionary
            local pDict = guiCreateTab("Dict", pTabPanel);
			
			local pEnableHints = guiCreateCheckBox(20, 20, 150, 15, "Enable Lexical Popups", false, false, pDict);
			pClientConfigGUI.enableHints = pEnableHints;
			
			local pColorFunctions = guiCreateCheckBox(200, 20, 200, 15, "Color functionnames in editor", false, false, pDict);
			pClientConfigGUI.colorFunctions = pColorFunctions;
			
			local pShowHintDescription = guiCreateCheckBox(20, 40, guiW - 40, 15, "Show description in editor hints", false, false, pDict);
			pClientConfigGUI.showHintDescription = pShowHintDescription;
			
			local pFunctionlistArguments = guiCreateCheckBox(20, 60, guiW - 40, 15, "Show arguments in functionlist", false, false, pDict);
			pClientConfigGUI.functionlistArguments = pFunctionlistArguments;
            
            -- File Transfer
            local pTransfer = guiCreateTab("Transfer", pTabPanel);
            
            guiCreateLabel(20, 20, 140, 15, "Maximum Transfer Unit:", false, pTransfer);
            
            local pMTU = guiCreateEdit(160, 18, 60, 20, "", false, pTransfer);
			pClientConfigGUI.mtu = pMTU;
            
            local pCreateRepository = guiCreateCheckBox(20, 50, guiW - 40, 20, "Create clientside resource repository", false, false, pTransfer);
			pClientConfigGUI.createRepository = pCreateRepository;
            
            -- Bottom
            local function saveGUI()
                if (guiCheckBoxGetSelected(pEnableSyntax)) then
                    enableHighlighting = true;
                    
                    if not (syntax.attr.enable == "true") then
                        xmlNotify(syntax, "set_attribute", "enable", "true");
                        syntax.attr.enable = "true";
                    end
                else
                    enableHighlighting = false;
                    
                    xmlNotify(syntax, "set_attribute", "enable", "false");
                    syntax.attr.enable = "false";
                end
                
                if (guiCheckBoxGetSelected(pShowLineBar)) then
                    showLineNumbers = true;
                    
                    if not (editor.attr.showLineNumbers == "true") then
                        xmlNotify(editor, "set_attribute", "showLineNumbers", "true");
                        editor.attr.showLineNumbers = "true";
                    end
                else
                    showLineNumbers = false;
                    
                    if not (editor.attr.showLineNumbers == "false") then
                        xmlNotify(editor, "set_attribute", "showLineNumbers", "false");
                        editor.attr.showLineNumbers = "false";
                    end
                end
                
                if (guiCheckBoxGetSelected(pNotifyOnChange)) then
                    notifyOnChange = true;
                    
                    if not (editor.attr.notifyOnChange == "true") then
                        xmlNotify(editor, "set_attribute", "notifyOnChange", "true");
                        editor.attr.notifyOnChange = "true";
                    end
                else
                    notifyOnChange = false;
                    
                    if not (editor.attr.notifyOnChange == "false") then
                        xmlNotify(editor, "set_attribute", "notifyOnChange", "false");
                        editor.attr.notifyOnChange = "false";
                    end
                end
                
                if (guiCheckBoxGetSelected(pUseFileManager)) then
                    useFileManager = true;
                    
                    if (mainGUI.mode == "file") then
                        mainGUI.nextFileMode();
                        showFileManager(true);
                    end
                    
                    if not (editor.attr.useFileManager == "true") then
                        xmlNotify(editor, "set_attribute", "useFileManager", "true");
                        editor.attr.useFileManager = "true";
                    end
                else
                    useFileManager = false;
                    
                    if (pFileManager) and (guiGetVisible(pFileManager.window)) then
                        showFileManager(false);
                        mainGUI.nextFileMode();
                    end
                    
                    if not (editor.attr.useFileManager == "false") then
                        xmlNotify(editor, "set_attribute", "useFileManager", "false");
                        editor.attr.useFileManager = "false";
                    end
                end
				
				if (guiCheckBoxGetSelected(pAutomaticIndentation)) then
					automaticIndentation = true;
					
					if not (editor.attr.automaticIndentation == "true") then
						xmlNotify(editor, "set_attribute", "automaticIndentation", "true");
						editor.attr.automaticIndentation = "true";
					end
				else
					automaticIndentation = false;
					
					if not (editor.attr.automaticIndentation == "false") then
						xmlNotify(editor, "set_attribute", "automaticIndentation", "false");
						editor.attr.automaticIndentation = "false";
					end
				end
				
				if (guiCheckBoxGetSelected(pShowFunctionsFullscreen)) then
					showFunctionsFullscreen = true;
					
					if not (editor.attr.showFunctionsFullscreen == "true") then
						xmlNotify(editor, "set_attribute", "showFunctionsFullscreen", "true");
						editor.attr.showFunctionsFullscreen = "true";
					end
				else
					showFunctionsFullscreen = false;
					
					if not (editor.attr.showFunctionsFullscreen == "false") then
						xmlNotify(editor, "set_attribute", "showFunctionsFullscreen", "false");
						editor.attr.showFunctionsFullscreen = "false";
					end
				end
				
				if (guiCheckBoxGetSelected(pEnableHints)) then
					enableHints = true;
					
					if not (dict.attr.enableHints == "true") then
						xmlNotify(dict, "set_attribute", "enableHints", "true");
						dict.attr.enableHints = "true";
					end
				else
					enableHints = false;
					
					if not (dict.attr.enableHints == "false") then
						xmlNotify(dict, "set_attribute", "enableHints", "false");
						dict.attr.enableHints = "false";
					end
				end
				
				if (guiCheckBoxGetSelected(pColorFunctions)) then
					colorFunctions = true;
					
					if not (dict.attr.colorFunctions == "true") then
						xmlNotify(dict, "set_attribute", "colorFunctions", "true");
						dict.attr.colorFunctions = "true";
					end
				else
					colorFunctions = false;
					
					if not (dict.attr.colorFunctions == "false") then
						xmlNotify(dict, "set_attribute", "colorFunction", "false");
						dict.attr.colorFunctions = "false";
					end
				end
				
				if (guiCheckBoxGetSelected(pShowHintDescription)) then
					showHintDescription = true;
					
					if not (dict.attr.showHintDescription == "true") then
						xmlNotify(dict, "set_attribute", "showHintDescription", "true");
						dict.attr.showHintDescription = "true";
					end
				else
					showHintDescription = false;
					
					if not (dict.attr.showHintDescription == "false") then
						xmlNotify(dict, "set_attribute", "showHintDescription", "false");
						dict.attr.showHintDescription = "false";
					end
				end
				
				if (guiCheckBoxGetSelected(pFunctionlistArguments)) then
					functionlistArguments = true;
					
					if not (dict.attr.functionlistArguments == "true") then
						xmlNotify(dict, "set_attribute", "functionlistArguments", "true");
						dict.attr.functionlistArguments = "true";
						
						updateFunctionList();
					end
				else
					functionlistArguments = false;
					
					if not (dict.attr.functionlistArguments == "false") then
						xmlNotify(dict, "set_attribute", "functionlistArguments", "false");
						dict.attr.functionlistArguments = "false";
						
						updateFunctionList();
					end
				end
                
                local fontSize = guiGetText(pFontSize);
                
                if (tonumber(fontSize)) then
                    charScale = tonumber(fontSize);
                    xmlNotify(editor, "set_attribute", "fontSize", fontSize);
                    editor.attr.fontSize = fontSize;
                end
                
                local font = guiComboBoxGetItemText(pFont, guiComboBoxGetSelected(pFont));
				
                xmlNotify(editor, "set_attribute", "font", font);
                editor.attr.font = font;
                charFont = font;
				
				if (guiCheckBoxGetSelected(pCreateRepository)) then
					createClientRepository = true;
					
					if (transfer.attr.createRepository == "false") then
						xmlNotify(transfer, "set_attribute", "createRepository", "true");
						transfer.attr.createRepository = "true";
					end
				else
					createClientRepository = false;
					
					if (transfer.attr.createRepository == "true") then
						xmlNotify(transfer, "set_attribute", "createRepository", "false");
						transfer.attr.createRepository = "false";
					end
				end
				
				local mtu = guiGetText(pMTU);
				
				if not (mtu == transfer.attr.mtu) then
					xmlNotify(transfer, "set_attribute", "mtu", mtu);
					transfer.attr.mtu = mtu;
					
					transactionPacketBytes = tonumber(mtu);
				end
                
                -- Update the editor
				pEditor.showLineNumbers(showLineNumbers);
				pEditor.setColorEnabled(enableHighlighting);
				pEditor.setLexicalHintingEnabled(enableHints);
				pEditor.setFont(charScale, charFont);
				pEditor.setAutoIndentEnabled(automaticIndentation);
				
				pEditor.parseCode();
                
                -- Also update the manager
                setEditorMode(editorMode);
            end
            
            local pRestoreDefaults = guiCreateButton(10, guiH-30, 110, 20, "Restore Defaults", false, window);
            
            addEventHandler("onClientGUIClick", pRestoreDefaults, function(button, state, x, y)
                    local ask = showConfigMessageBox("Are you sure you want to restore your settings to default?", "Factory Reset", "confirm");
                    
                    addEventHandler("onClientMessageBoxClose", ask, function(switch)
                            if not (switch) then return false; end;
                            
                            -- Kill editors
                            xmlNotify(config, "destroy");
                            
                            local xml = xmlLoadFile("default/config.xml");
                            pConfigFile = xmlCopyFile(xml, "config.xml");
                            xmlUnloadFile(xml);
							
							-- We have to unload configured data
							unloadDictionary(internalDictionary);
                            
                            -- Reload xml data
                            loadConfig();
                            
                            showClientConfig(false);
                            
                            pEditor.parseCode();
                        end
                    );
                end, false
            );
            
            local pCancel = guiCreateButton(guiW - 100, guiH - 30, 75, 20, "Cancel", false, window);
            
            addEventHandler("onClientGUIClick", pCancel, function(button, state, x, y)
                    showClientConfig(false);
                end, false
            );
            
            local pOK = guiCreateButton(guiW - 180, guiH - 30, 75, 20, "OK", false, window);
            
            addEventHandler("onClientGUIClick", pOK, function(button, state, x, y)
                    saveGUI();
                    
                    showClientConfig(false);
                end, false
            );
        else
            guiSetVisible(pClientConfigGUI.window, true);
            guiBringToFront(pClientConfigGUI.window);
            
            -- Update easy stuff
            guiSetText(pClientConfigGUI.fontSize, tostring(charScale));
        end
        
		if (charFont == "default") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 0);
		elseif (charFont == "default-bold") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 1);
		elseif (charFont == "clear") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 2);
		elseif (charFont == "arial") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 3);
		elseif (charFont == "sans") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 4);
		elseif (charFont == "pricedown") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 5);
		elseif (charFont == "bankgothic") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 6);
		elseif (charFont == "diploma") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 7);
		elseif (charFont == "beckett") then
			guiComboBoxSetSelected(pClientConfigGUI.font, 8);
		end
		
		guiSetText(pClientConfigGUI.mtu, tostring(transactionPacketBytes));
        
        guiCheckBoxSetSelected(pClientConfigGUI.enableSyntax, enableHighlighting);
        guiCheckBoxSetSelected(pClientConfigGUI.notifyOnChange, notifyOnChange);
        guiCheckBoxSetSelected(pClientConfigGUI.showLineBar, showLineNumbers);
        guiCheckBoxSetSelected(pClientConfigGUI.useFileManager, useFileManager);
		guiCheckBoxSetSelected(pClientConfigGUI.showFunctionsFullscreen, showFunctionsFullscreen);
		guiCheckBoxSetSelected(pClientConfigGUI.automaticIndentation, automaticIndentation);
		guiCheckBoxSetSelected(pClientConfigGUI.enableHints, enableHints);
		guiCheckBoxSetSelected(pClientConfigGUI.colorFunctions, colorFunctions);
		guiCheckBoxSetSelected(pClientConfigGUI.showHintDescription, showHintDescription);
		guiCheckBoxSetSelected(pClientConfigGUI.functionlistArguments, functionlistArguments);
		guiCheckBoxSetSelected(pClientConfigGUI.createRepository, createClientRepository);
    else
        if (pClientConfigGUI) then
            while not (#pClientConfigGUI.subwindows == 0) do
                closeMessageBox(pClientConfigGUI.subwindows[1]);
            end
        
            guiSetVisible(pClientConfigGUI.window, false);
        end
    end
end

function resizeColumn(gridlist, column, width)
    local n = 0;
    local rowcount = guiGridListGetRowCount(gridlist);
    
    while (n < rowcount) do
        local curWidth = dxGetTextWidth(guiGridListGetItemText(gridlist, n, column)) + 20;
        
        if (width < curWidth) then
            width = curWidth;
        end
    
        n = n + 1;
    end
    
    return guiGridListSetColumnWidth(gridlist, column, width, false);
end

addEventHandler("onClientInterfaceMouseClick", root, function(button, state, x, y)
		if not (button == "right") or not (state) then return true; end;
		
		if (pRightClickMenu) then
			if (pRightClickMenu.isInArea(mouseX, mouseY)) then return true; end;
			
			pRightClickMenu.destroy();
		end
	
		pRightClickMenu = createDropDown();
		
		pRightClickMenu.setPosition(mouseX, mouseY);
		
		pRightClickMenu.addItem("lol", function()
				showMessageBox("It works!");
			end
		);
		
		pRightClickMenu.addEventHandler("onHide", function()
				pRightClickMenu.destroy();
				
				pRightClickMenu = false;
				return false;
			end, false
		);
	end
);

function showPasteGUI(show)
	if (show) then
		if not (pPasteGUI) then
			local screenW, screenH = guiGetScreenSize();
			local guiW, guiH = 150, 80;
		
			pPasteGUI = {};
			
			local window = guiCreateWindow((screenW - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, "Paste GUI", false);
			pPasteGUI.window = window;
			
			local edit = guiCreateMemo(5, 5, guiW - 10, guiH - 10, "", false, window);
			pPasteGUI.edit = edit;
			
			addEventHandler("onClientGUIChanged", edit, function()
					local text = guiGetText(edit);
			
					if (strlen(text) == 1) then return true; end;
					
					local len = strlen(text) - 1;
					local text = strsub(text, 1, len);
					local cursor = pEditor.getCursor();
					
					pEditor.insertText(text, cursor);
					
					-- Show some highlight
					pEditor.setHighlight(cursor, cursor + len);
					pEditor.setCursor(cursor + strlen(text));
					
					pEditor.moveToFront();
					
					showPasteGUI(false);
				end
			);
		else
			guiSetVisible(pPasteGUI.window, true);
			
			guiSetText(pPasteGUI.edit, "");
		end
	else
		if (pPasteGUI) then
			guiSetVisible(pPasteGUI.window, false);
			guiMoveToBack(pPasteGUI.window);
		end
	end
end

function showResourceGUI(bShow)
    if (bShow == true) then
        if not (access) then return false; end;
        
        -- Priviledge to open it
        if (access.account.editor.access == false) then
            if not (pDenyEditorAccessMsg) then
                showCursor(true);
                
                pDenyEditorAccessMsg = createMessageBox("You do not have the right to open Resource Manager", "Access Denied");
                
                addEventHandler("onClientMessageBoxClose", pDenyEditorAccessMsg, function()
                        showCursor(false);
                        pDenyEditorAccessMsg = false;
                    end
                );
            else
                guiBringToFront(pDenyEditorAccessMsg);
            end
            
            return false;
        end
    
        showCursor(true);
        showChat(false);
        
        if not (mainGUI) then
            local m,n;
            local screenW, screenH = guiGetScreenSize();
            
            mainGUI = {
				mode = "script",
				
				imagePreviews = {},
				visible = true
			};
            
            editorMode = 0;
			
			-- Create the functional tab panel
			pFunctionTabPanel = createTabPanel();
			
			-- Create the editor
			pEditor = createEditor();
			pEditor.showLineNumbers(showLineNumbers);
			pEditor.setColorEnabled(enableHighlighting);
			pEditor.setColorTokenHandler(getColorFromToken);
			pEditor.setLexicalHintingEnabled(enableHints);
			pEditor.setLexicalTokenHandler(getLexicalDefinition);
			pEditor.setAutoIndentEnabled(automaticIndentation);
			pEditor.setFont(charScale, charFont);
			
			-- Create the top menu
			pMenu = createMenu();
			
			local fileMenu = pMenu.addItem("File");

			fileMenu.addItem("Open Resource", function()
					showResourceSelect(true);
					return true;
				end
			);
			
			fileMenu.addItem("Create Resource", function()
					showResourceCreation(true);
					return true;
				end
			);
			
			fileMenu.addItem("Delete Resource", function()
					if not (currentResource) then return false; end;
					
					local resource = currentResource;
					local msg = showMessageBox("Are you sure you want to delete '" .. resource.name .. "'?", "Resource Deletion", "confirm");
					
					addEventHandler("onClientMessageBoxClose", msg, function(accepted)
							if not (accepted) then return false; end;
							
							triggerServerEvent("onClientRequestResourceRemoval", root, resource.name);
						end
					);
					
					return true;
				end
			);
			
			fileMenu.addBreak();
			
			local scriptMenu = fileMenu.addSubList("Open Script");
			
			local filesMenu = fileMenu.addSubList("Open File");
			
			fileMenu.addBreak();
			
			fileMenu.addItem("Exit", function()
					showResourceGUI(false);
				end
			);
			
			local optionsMenu = pMenu.addItem("Options");
			
			optionsMenu.addItem("Preferences", function()
					showClientConfig(true);
				end
			);
			
			local toolsMenu = pMenu.addItem("Tools");
			
			local id = toolsMenu.addItem("Advanced Configuration", function()
					xmlCreateEditor(config);
				end
			);
			
			toolsMenu.setItemDescription(id, "F5");
			
			local viewMenu = pMenu.addItem("View");
			
			viewMenu.addItem("Switch Mode", function()
					mainGUI.nextFileMode();
				end
			);
			
			local helpMenu = pMenu.addItem("?");
			
			helpMenu.addItem("About", function()
					showMessageBox("Resource Manager created by (c)The_GTA.\nVisit http://community.mtasa.com/index.php?p=resources&s=details&id=1821", "About");
				end
			);
	
            pFileList = guiCreateGridList(0, 20, 250, screenH-20, false);
            guiGridListAddColumn(pFileList, "Resource File", 2);
            guiGridListAddColumn(pFileList, "Type", 0.25);
            guiSetProperty(pFileList, "ZOrderChangeEnabled", "False");
            
            addEventHandler("onClientGUIClick", pFileList, function(button, state, x, y)
                    local row = guiGridListGetSelectedItem(source);
                    
                    if (row == -1) then return false; end;
                    
                    if (mainGUI.mode == "script") then
                        mainGUI.openScript(tonumber(guiGridListGetItemData(pFileList, row, 1)));
                    else
                        local id = guiGridListGetItemData(pFileList, row, 1);
                        local file = currentResource.files[tonumber(id)];
                        
                        outputDebugString("Selected '" .. file.src .. "' (" .. id .. ", " .. file.type .. ")");
                        
                        executeFile(file);
                    end
                end, false
            );

            pSaveButton = guiCreateButton(screenW - 440, screenH - 30, 75, 20, "Save", false);
            guiSetProperty(pSaveButton, "ZOrderChangeEnabled", "False");
            
            addEventHandler("onClientGUIClick", pSaveButton, function(button, state, x, y)
                    if not (currentResource) then return false; end;
                    if not (currentFile) then return false; end;
                    
                    if not (loadstring(pEditor.getText())) then
                        showMessageBox("Parse failed, please debug the script.", "Parse Error");
                    else
                        local trans = sendFile(currentFile.src, pEditor.getText());
                    
                        function trans.cbAbort()
                            showMessageBox("Failed to save script.", "Script Error");
                            return true;
                        end
                    
                        function trans.cbComplete()
                            outputDebugString("Saved '" .. currentFile.src .. "'!");
                            return true;
                        end
                    end
                end, false
            );
            
            pCloseButton = guiCreateButton(screenW - 530, screenH - 30, 75, 20, "Close", false);
            guiSetProperty(pCloseButton, "ZOrderChangeEnabled", "False");
            
            addEventHandler("onClientGUIClick", pCloseButton, function(button, state, x, y)
                    showResourceGUI(false);
                end, false
            );
        
            local currentName="";
            local currentType="";
            local currentRealname="";
            local currentDescription="none";
            local currentAuthor="community";
            
            -- Create advanced settings tabpanel
            pTabHolder=guiCreateTabPanel(screenW-350, 20, 350, 290, false);
            guiSetProperty(pTabHolder, "ZOrderChangeEnabled", "False");
            
            local pGeneralTab=guiCreateTab("General", pTabHolder);
            guiCreateLabel(15, 20, 100, 14, "Resource Name:", false, pGeneralTab);
            
            pResourceName=guiCreateEdit(115, 20, 225, 18, currentName, false, pGeneralTab);
            
            guiEditSetReadOnly(pResourceName, true);
            guiCreateLabel(15, 40, 100, 14, "Resource Type:", false, pGeneralTab);
            
            pResourceType=guiCreateEdit(115, 40, 150, 18, currentType, false, pGeneralTab);
            --guiEditSetReadOnly(pResourceType, true);
        
            local pTypeSet=guiCreateButton(265, 40, 75, 18, "Set", false, pGeneralTab);
            
            addEventHandler("onClientGUIClick", pTypeSet, function(button, state, x, y)
                    if not (currentResource) then return false; end;
                    
                    triggerServerEvent("onResourceSet", root, currentResource.name, "type", guiGetText(pResourceType));
                end, false
            );
            
            guiCreateLabel(15, 60, 80, 14, "Description:", false, pGeneralTab);
            
            pResourceDescription=guiCreateMemo(95, 60, 245, 54, currentDescription, false, pGeneralTab);
            --guiMemoSetReadOnly(pDescription, true);
            
            local pSetDescription=guiCreateButton(15, 76, 80, 20, "Set", false, pGeneralTab);
            
            addEventHandler("onClientGUIClick", pSetDescription, function(button, state, x, y)
                    if not (currentResource) then return false; end;
                    
                    triggerServerEvent("onResourceSet", root, currentResource.name, "description", guiGetText(pResourceDescription));
                end, false
            );
            
            guiCreateLabel(15, 120, 100, 14, "Author:", false, pGeneralTab);
            
            pResourceAuthor=guiCreateEdit(115, 120, 225, 18, currentAuthor, false, pGeneralTab);
            guiEditSetReadOnly(pResourceAuthor, true);
            
            -- Resource buttons
            local buttonOffset=155;
            local pStartResource=guiCreateButton(10, buttonOffset+20, 165, 20, "Start Resource", false, pGeneralTab);
            
            addEventHandler("onClientGUIClick", pStartResource, function()
                    if not (currentResource) then return false; end;
                    
                    triggerServerEvent("onClientRequestStartResource", root, currentResource.name);
                end, false
            );
            
            local pStopResource=guiCreateButton(175, buttonOffset+20, 165, 20, "Stop Resource", false, pGeneralTab);
            
            addEventHandler("onClientGUIClick", pStopResource, function(button, state, x, y)
                    if not (currentResource) then return false; end;
                    
                    triggerServerEvent("onClientRequestStopResource", root, currentResource.name);
                end, false
            );
            
            -- Script
            local pScriptTab=guiCreateTab("Script", pTabHolder);
            guiCreateLabel(15, 20, 60, 14, "Filename:", false, pScriptTab);
            
            pFilename=guiCreateEdit(75, 20, 265, 18, "", false, pScriptTab);
            
            guiCreateLabel(15, 40, 40, 14, "Type:", false, pScriptTab);
            
            pScriptType=guiCreateEdit(55, 40, 285, 18, "", false, pScriptTab);
            
            guiCreateLabel(15, 60, 30, 14, "Size:", false, pScriptTab);
            
            pScriptSize=guiCreateLabel(50, 60, 295, 14, "0", false, pScriptTab);
            
            -- Buttons
            local buttonOffset=85;
            local pAddScript=guiCreateButton(10, buttonOffset, 165, 20, "Add Script", false, pScriptTab);
            
            addEventHandler("onClientGUIClick", pAddScript, function(button, state, x, y)
                    if not (currentResource) then return false; end;
					
					local src = guiGetText(pFilename);
					local path, isFile = fileParsePath(src);
					
					if not (path) then
						showMessageBox("Target '" .. src .. "' is a invalid path");
						return false;
					end
					
					if not (isFile) then
						showMessageBox("Target '" .. src .. "' does not point to a file location!");
						return false;
					end
                    
                    triggerServerEvent("onClientAddScript", root, currentResource.name, path, guiGetText(pScriptType));
                end, false
            );
            
            local pRemoveScript=guiCreateButton(175, buttonOffset, 165, 20, "Remove Script", false, pScriptTab);
            
            addEventHandler("onClientGUIClick", pRemoveScript, function(button, state, x, y)
                    if not (currentResource) then return false; end;
                    
                    triggerServerEvent("onClientRemoveScript", root, currentResource.name, guiGetText(pFilename));
                end, false
            );
			
			-- Functions list
			pFunctionSearch = guiCreateEdit(screenW - 348, 315, 346, 20, "", false);
			guiSetProperty(pFunctionSearch, "ZOrderChangeEnabled", "False");
			
			addEventHandler("onClientGUIChanged", pFunctionSearch, function()
					updateFunctionList();
				end
			);
			
			pFunctionList = guiCreateGridList(screenW - 350, 335, 350, screenH - 335, false);
			guiGridListAddColumn(pFunctionList, "Function", 0.4);
			guiGridListAddColumn(pFunctionList, "Type", 0.2);
			guiSetProperty(pFunctionList, "ZOrderChangeEnabled", "False");
            
            function mainGUI.update()
                guiGridListClear(pFileList);
                
                if (currentResource) then
                    local m,n;
                    local sort = guiGetProperty(pFileList, "SortDirection");
                    
                    guiSetProperty(pFileList, "SortDirection", "");
                    
                    if (mainGUI.mode == "script") then
                        for m,n in ipairs(currentResource.scripts) do
                            local row = guiGridListAddRow(pFileList);
                            guiGridListSetItemText(pFileList, row, 1, n.src, false, false);
                            guiGridListSetItemText(pFileList, row, 2, n.type, false, false);
                            guiGridListSetItemData(pFileList, row, 1, tostring(m));
                            
                            local colorType = scriptColors[n.type];
							
							if not (colorType) then
								colorType = { 255, 255, 255 };
							end
							
							colorType[4] = 255;
							
							guiGridListSetItemColor(pFileList, row, 1, unpack(colorType));
                        end
                        
                        resizeColumn(pFileList, 1, 100);
                    elseif (mainGUI.mode == "file") then
                        for m,n in ipairs(currentResource.files) do
                            local row = guiGridListAddRow(pFileList);
                            guiGridListSetItemText(pFileList, row, 1, n.src, false, false);
                            guiGridListSetItemText(pFileList, row, 2, n.type, false, false);
                            guiGridListSetItemData(pFileList, row, 1, tostring(m));
							
                            local colorType = fileColors[getFileExtension(n.src)];
							
							if not (colorType) then
								colorType = { 255, 255, 255 };
							end
							
							colorType[4] = 255;
							
							guiGridListSetItemColor(pFileList, row, 1, unpack(colorType));
                        end
                        
                        resizeColumn(pFileList, 1, 100);
                    end
                    
                    guiSetProperty(pFileList, "SortDirection", sort);

                    -- Update info
                    guiSetText(pResourceName, currentResource.name);
                    guiSetText(pResourceType, currentResource.type);
                    guiSetText(pResourceDescription, currentResource.description);
                    guiSetText(pResourceAuthor, currentResource.author);
                else
                    guiSetText(pResourceName, "");
                    guiSetText(pResourceType, "");
                    guiSetText(pResourceDescription, "");
                    guiSetText(pResourceAuthor, "");
                end

                -- Update sub GUI
                if (pSelectGUI) then
                    pSelectGUI.update();
                end
                
                if (pFileManager) then
                    pFileManager.update();
                end

                outputDebugString("Updated mainGUI");
                return true;
            end
			
			function mainGUI.updateResource()
				-- Update the usual thing
				mainGUI.update();
			
				scriptMenu.clear();
				filesMenu.clear();
				
				for m,n in ipairs(currentResource.scripts) do
					local menu, id = scriptMenu.addSubList(n.src);
					
					scriptMenu.setItemHandler(id, function()
							mainGUI.openScript(m);
						end
					);
					
					menu.addItem("Open", function() end);
					menu.addItem("Delete", function() end);
					
					scriptMenu.setItemDescription(id, n.type);
					
					local colorType = scriptColors[n.type];
					
					if not (colorType) then
						colorType = { 255, 255, 255 };
					end
					
					colorType[4] = 255;
					
					scriptMenu.setItemColor(id, unpack(colorType));
				end
				
				for m,n in ipairs(currentResource.files) do
					local id = filesMenu.addItem(n.src, function()
							executeFile(n);
						end
					);
					
					filesMenu.setItemDescription(id, n.type);
					
					local colorType = fileColors[getFileExtension(n.src)];
					
					if not (colorType) then
						colorType = { 255, 255, 255 };
					end
					
					filesMenu.setItemColor(id, unpack(colorType));
				end
				
				return true;
			end
			
			function mainGUI.updateAccess()
				-- Update access oriented elements
				return true;
			end
            
            function mainGUI.setFileMode(mode)
                if not (mainGUI.mode == mode) then
                    mainGUI.mode = mode;
					
                    mainGUI.update();
                end
                
                return true;
            end
            
            function mainGUI.nextFileMode()
                if not (mainGUI.mode == "file") then
                    mainGUI.setFileMode("file");
                else
                    mainGUI.setFileMode("script");
                end
            end
			
			function mainGUI.openScript(id)
				local script = currentResource.scripts[id];
			
				guiSetEnabled(pSaveButton, false);
				
				if (scriptLock) then
					-- Release our current scriptLock
					triggerServerEvent("onClientFreeScriptLock", root);
				end
				
				-- Request it
				local trans = getFile(script.src);
				
				function trans.cbAbort()
					showMessageBox("Unable to request script '" .. script.src .. "'", "Request Error");
					return true;
				end
				
				function trans.cbComplete()					
					clearDefinitions();
					
					-- Import definition data
					if (script.type == "shared") then
						importDefinitions("server");
						importDefinitions("client");
					else
						importDefinitions(script.type);
					end
					
					importDefinitions("shared");
					
					-- Now fill our list
					updateFunctionList();
					
					pEditor.setText(trans.data);
					currentFile = script;
					
					guiSetText(pFilename, currentFile.src);
					guiSetText(pScriptSize, tostring(strlen(pEditor.getText())));
					guiSetText(pScriptType, script.type);
					
					-- If it has no scriptLock, get it for us
					if not (script.lockClient) then
						triggerServerEvent("onClientRequestScriptLock", root, currentResource.name, currentFile.src);
					end
					
					return true;
				end
			end
            
            function mainGUI.createImagePreview(src, width, height)
                local screenWidth, screenHeight = guiGetScreenSize();
                local guiW,guiH = math.max(200, width), math.max(200, height + 50);
                local titleWidth = dxGetTextWidth(src) + 30;
                
                if (guiW < titleWidth) then
                    guiW = titleWidth;
                end
                
                local window = guiCreateWindow((screenWidth - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, src, false);
                local image = guiCreateStaticImage((guiW - width) / 2, 20 + ((guiH-50) - height) / 2, width, height, src, false, window);
                guiWindowSetSizable(window, false);
                
                local button = guiCreateButton((guiW - 100) / 2, guiH - 30, 100, 20, "Close", false, window);
                
                addEventHandler("onClientGUIClick", button, function(button, state, x, y)
                        mainGUI.imagePreviews[window] = nil;
                    
                        destroyElement(window);
                    end, false
                );
				
				guiSetVisible(window, mainGUI.visible);
                
                mainGUI.imagePreviews[window] = true;
                return window;
            end
            
            guiSetEnabled(pSaveButton, false);
			
			-- Render everything
			addEventHandler("onClientRender", root, function()
					if not (mainGUI.visible) then return true; end;

					local screenWidth, screenHeight = guiGetScreenSize();

					dxDrawRectangle(0, 20, screenWidth, screenHeight - 20, tocolor(20, 20, 20, 255));
					
					-- Render the dx elements
					renderDXElements();

					-- Add a cute notification <3
					if (editorMode == 0) then
						dxDrawText("Resource Manager by (c)The_GTA", 265, screenHeight-27);
					end
				end
			);
            
            -- Clear the scriptBuffer
			pEditor.setText("");
			
			-- Reset definitions
			clearDefinitions();
			
			-- Update
			mainGUI.updateResource();
		elseif (mainGUI.visible) then
			return true;
        else
            local m,n;
            local j,k;
			
			pEditor.setVisible(true);
			pMenu.setVisible(true);
			pFunctionTabPanel.setVisible(true);
            
            -- There should not be any messageBoxes when the GUI is not created yet            
            for m,n in pairs(messageBoxes) do
                guiSetVisible(m, true);
            end
            
            -- Show xmleditors
            xmlShowEditors(true);
            
            -- Show image previews
            for m,n in pairs(mainGUI.imagePreviews) do
                guiSetVisible(m, true);
            end
			
			mainGUI.visible = true;
        end
		
		enterEditorMode();
    else
        if (mainGUI) and (mainGUI.visible) then
            local m,n;
            local j,k;
        
			-- Switch modes
            showCursor(false);
            showChat(true);
            showFileManager(false);
            showResourceSelect(false);
            showScriptDebug(false);
            showResourceCreation(false);
            showClientConfig(false);
			showControlPanel(false);
			showPasteGUI(false);
			pEditor.setVisible(false);
			pMenu.setVisible(false);
			pFunctionTabPanel.setVisible(false);
			
			leaveEditorMode();
			
			destroyHint();
            
            -- Hide messageBoxes
            for m,n in pairs(messageBoxes) do
                guiSetVisible(m, false);
            end
            
            -- Hide xmleditors
            xmlShowEditors(false);
            
            -- Hide image previews
            for m,n in pairs(mainGUI.imagePreviews) do
                guiSetVisible(m, false);
            end
			
			guiReleaseFocus();
			guiSetInputEnabled(false);
	
			mainGUI.visible = false;
        end
    end
	
    return true;
end

addEventHandler("onClientResourceStop", resourceRoot, function()
        local m,n;

        showResourceGUI(false);
        
        -- Kill xmleditors
        xmlDestroyEditors();
        
        -- Kill messageBoxes
        for m,n in pairs(messageBoxes) do
            closeMessageBox(m);
        end
		
        -- Save config changes
        xmlSetNode(pConfigFile, config);
        xmlSaveFile(pConfigFile);
        xmlUnloadFile(pConfigFile);
		
		-- Destroy dxElements interface
		dxRoot.destroy();
    end
);

addEvent("onClientAccessRightsUpdate", true);
addEventHandler("onClientAccessRightsUpdate", root, function(accessTable)
        access = accessTable;
        outputDebugString("Received access rights");
        
        if (access.account.editor.access) then
            -- Close that window to avoid bugs ;)
            if (pDenyEditorAccessMsg) then
                closeMessageBox(pDenyEditorAccessMsg);
				
				-- Let us show the editor here
				showResourceGUI(true);
            end
		
			-- Check whether we lost access or just do not have a valid resource selected
			if not (currentResource) or not (access.resources[currentResource.name]) then
				currentResource = false;
			
				-- Select the first resource we have access to
				for m,n in ipairs(resourceList) do
					if (access.resources[n]) then
						currentName = n;
						currentResource = resourceData[n];
						currentType = currentResource.type;
						currentAuthor = currentResource.author;
						currentRealname = currentResource.realname;
						currentDescription = currentResource.description;
						break;
					end
				end
				
				if (mainGUI) then
					mainGUI.updateResource();
				end
			elseif (pSelectGUI) then
				pSelectGUI.update();
			end
			
			if (mainGUI) then
				mainGUI.updateAccess();
			end
        else
            -- Woops, we probably lost access to the editor
            showResourceGUI(false);
        end
    end
);

addEvent("onScriptUpdate", true);
addEventHandler("onScriptUpdate", root, function(resource, filename)
        outputDebugString("File '" .. filename .. "' updated!");
        showUpdateGUI(true, "["..resource.."]: "..filename.." ("..getPlayerName(source)..")", 3500);
		
		if not (resource.name == currentResource.name) then return true; end;
		
		if not (filename == currentFile.src) then return true; end;
		
		local trans = getFile(filename);
		
		function trans.cbComplete()
			pEditor.setText(trans.data);
			return true;
		end
    end
);

addEvent("onResourceDataUpdate",true);
addEventHandler("onResourceDataUpdate", root, function(data, silent)
        if not (resourceData[data.name]) then
            table.insert(resourceList, data.name);
			
			resourceData[data.name] = data;
			
			if not (silent) then
				showUpdateGUI(true, "Added resource '" .. data.name, 5000);
			end
			
			if (pSelectGUI) then
				pSelectGUI.update();
			end
			
			return;
		end
		
		-- Resource already exists
		resourceData[data.name] = data;

		if not (silent) then
			showUpdateGUI(true, "Resource '" .. data.name .. "' update", 5000);
		end
		
		if (mainGUI) and (currentResource.name == data.name) then
			currentResource = data;
		
			mainGUI.updateResource();
		end
    end
);

addEvent("onResourceRemove", true);
addEventHandler("onResourceRemove", root, function(resname)
        local m,n;

        if (resname == currentResource.name) then
            if (mainGUI) then
                mainGUI.updateResource();
            end
            
            currentResource = false;
        end
        
        for m,n in ipairs(resourceList) do
            if (n == resname) then
                table.remove(resourceList, m);
                break;
            end
        end
    
        resourceData[resname] = nil;
        showUpdateGUI(true, "Resource Deletion: "..resname);
    end
);

addEvent("onResourceAddScript", true);
addEventHandler("onResourceAddScript", root, function(resource, filename, scripttype, data)
        local pRes = resourceData[resource];
        local pEntry={};
        pEntry.src=filename;
        pEntry.type=scripttype;
        table.insert(pRes.scripts, pEntry);
        
        if (mainGUI) and (pRes == currentResource) then
            mainGUI.updateResource();
        end
		
        showUpdateGUI(true, "[" .. resource .. "]: Added script '" .. filename .. "'");
    end
);

addEvent("onResourceRemoveScript", true);
addEventHandler("onResourceRemoveScript", root, function(resource, filename)
        local pRes = resourceData[resource];
        local m,n;
        
        for m,n in ipairs(pRes.scripts) do
            if (n.src == filename) then
				if (n.lockClient) then
					triggerEvent("onClientScriptLockFree", n.lockClient, resource, filename);
				end
			
                table.remove(pRes.scripts, m);
            end
        end
		
		-- Notify the user
		showUpdateGUI(true, "[" .. resource.."]: Removed script '" .. filename .. "'");
		
        if (mainGUI) and (pRes == currentResource) then
            mainGUI.updateResource();
        end
    end
);

triggerServerEvent("onClientResourceSystemReady", localPlayer);