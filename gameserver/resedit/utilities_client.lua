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

addEvent("onClientMessageBoxClose");
local xmleditors = {};

function table.delete(tab, obj)
	local m,n;
	
	for m,n in ipairs(tab) do
		if (n == obj) then
			table.remove(tab, m);
			return true;
		end
	end
	
	error("failed to delete table item", 2);
	return false;
end

local function getLongestWordWidth(text, charScale, charFont)
    local n;
	local lastBreak = 1;
	local wordWidth;
    local maxWidth = 0;
	
	if not (charScale) then
		charScale = 1;
	end
	
	if not (charFont) then
		charFont = "default";
	end
    
	n = strfind(text, "[\n%s]", 1);
	
    while (n) do
		local word = strsub(text, lastBreak, n+1);
		
		if not (strlen(word) == 0) then
			wordWidth = dxGetTextWidth(word, charScale, charFont);
			
			if (maxWidth < wordWidth) then
				maxWidth = wordWidth;
			end
		end
		
		lastBreak = n + 1;
		n = strfind(text, "[\n%s]", lastBreak);
    end
	
	wordWidth = dxGetTextWidth(strsub(text, lastBreak, strlen(text)), charScale, charFont);
	
	if (wordWidth > maxWidth) then
		maxWidth = wordWidth;
	end
	
    return maxWidth;
end

-- Structure the given text into a cached line system
function structureString(msg, width, maxWidth, charScale, charFont)
	if not (msg) then
		error("no message specified", 2);
	end
	
	if not (maxWidth) then
		error("no maximum width specified", 2);
	end

	if not (charScale) then
		charScale = 1;
	end
	
	if not (charFont) then
		charFont = "default";
	end

	local lineData = {
		lines = {},
		width = width
	};
    local m, n, len, wordLen;
	local lastBreak = 1;
    local curWidth = 0;
	local spaceWidth = dxGetTextWidth(" ", charScale, charFont);
    local word = "";
    local wordWidth;
    local line = "";
	local widestLine = 0;
	
    -- Messages have to end with newline
    len = strlen(msg);
    
    if not (strbyte(msg, len) == 10) then
        msg = msg .. "\n";
        len = len + 1;
    end
    
    -- First determine the maximum word width, in order to output text correctly
    wordWidth = getLongestWordWidth(msg);
    
    if (width < wordWidth) then
        if (wordWidth > maxWidth) then
            -- What the hell is this for a word
            width = maxWidth;
        else
            width = wordWidth;
        end
    end
	
	n = strfind(msg, "[\n%s]", 1);
    
    -- Structurize it!
    while (n) do
        local byte = strbyte(msg, n, n);
		
		word = strsub(msg, lastBreak, n-1);
		wordLen = strlen(word);
		
		if not (wordLen == 0) then
			wordWidth = dxGetTextWidth(word, charScale, charFont);
		
			if (wordWidth > width) then
				curWidth = curWidth + spaceWidth;
				
				if not (strlen(line) == 0) then
					line = line .. " ";
				end
				
				for m=1,wordLen do
					local char = strsub(word, m, m);
					local charWidth = dxGetTextWidth(char, charScale, charFont);
					
					if (curWidth + charWidth > width) then
						table.insert(lineData.lines, line);
						
						if (widestLine < curWidth) then
							widestLine = curWidth;
						end
					
						line = char;
						curWidth = charWidth;
					else
						curWidth = curWidth + charWidth;
						line = line .. char;
					end
				end
			else
				curWidth = curWidth + wordWidth;
				
				if (curWidth > width) then
					table.insert(lineData.lines, line);
					
					if (widestLine < curWidth) then
						widestLine = curWidth;
					end
				
					curWidth = wordWidth;
					line = word;
				elseif (curWidth == wordWidth) then
					line = line .. word;
				else
					curWidth = curWidth + spaceWidth;
					line = line .. " " .. word;
				end
			end
		end
		
		if (byte == 10) then
			table.insert(lineData.lines, line);
			
			if (widestLine < curWidth) then
				widestLine = curWidth;
			end
			
			line = "";
			curWidth = 0;
		end
		
		lastBreak = n + 1;
		n = strfind(msg, "[\n%s]", lastBreak);
    end
	
	-- Finalize
	lineData.width = widestLine;
	lineData.height = #lineData.lines * dxGetFontHeight(charScale, charFont);
	return lineData;
end

function closeMessageBox(msgbox)
    triggerEvent("onClientMessageBoxClose", msgbox, false);
    
    destroyElement(msgbox);
    return true;
end

function createMessageBox(msg, title, setting, ...)
    -- If creating a messageBox, there are no limits
    local screenWidth, screenHeight = guiGetScreenSize();
    local fontHeight = dxGetFontHeight(1);
    local guiW, guiH;
    local msgBox;
	local lineData = structureString(msg, 350, screenWidth - 100);
    local y = 0;
	local n;
    
    if not (title) then
        title = "Message Box";
    end
	
	-- Adjust the window setting
    guiW = math.max(350, lineData.width) + 50;
    guiH = 65 + lineData.height;

    -- Create window
    msgBox = guiCreateWindow((screenWidth - guiW) / 2, (screenHeight - guiH) / 2, guiW, guiH, title, false);
    guiWindowSetSizable(msgBox, false);
	
	-- Create content
	for n=1,#lineData.lines do
		local line = lineData.lines[n];
		
		if not (strlen(line) == 0) then
			guiCreateLabel(25, 25 + y, guiW - 50, fontHeight, line, false, msgBox);
		end
		
		y = y + fontHeight;
	end
    
    if not (setting) or (setting == "info") then
        local pClose = guiCreateButton((guiW - 100) / 2, guiH - 30, 100, 20, "OK", false, msgBox);
        
        addEventHandler("onClientGUIClick", pClose, function(button, state, x, y)
                triggerEvent("onClientMessageBoxClose", msgBox);
                destroyElement(msgBox);
            end, false
        );
		
		guiBringToFront(msgBox);
    elseif (setting == "confirm") then
        local pYes = guiCreateButton(guiW / 2 - 80, guiH - 30, 75, 20, "Yes", false, msgBox);
        local pNo = guiCreateButton(guiW / 2 + 5, guiH - 30, 75, 20, "No", false, msgBox);
        
        addEventHandler("onClientGUIClick", pYes, function(button, state, x, y)
                triggerEvent("onClientMessageBoxClose", msgBox, true);
                destroyElement(msgBox);
            end, false
        );
        
        addEventHandler("onClientGUIClick", pNo, function(button, state, x, y)
                triggerEvent("onClientMessageBoxClose", msgBox, false);
                destroyElement(msgBox);
            end, false
        );
		
		guiBringToFront(msgBox);
    elseif (setting == "input") then
		local args = { ... };
	
        guiH = guiH + 25;
        guiSetSize(msgBox, guiW, guiH, false);
        guiSetPosition(msgBox, (screenWidth - guiW) / 2, (screenHeight - guiH) / 2, false);
    
        local pInput = guiCreateEdit(25, guiH - 55, guiW - 50, 20, args[1] or "", false, msgBox);
		guiBringToFront(pInput);
		
        local pOK = guiCreateButton(guiW / 2 - 80, guiH - 30, 75, 20, "OK", false, msgBox);
        local pCancel = guiCreateButton(guiW / 2 + 5, guiH - 30, 75, 20, "Cancel", false, msgBox);
        
        addEventHandler("onClientGUIAccepted", pInput, function()
                triggerEvent("onClientMessageBoxClose", msgBox, guiGetText(pInput));
                destroyElement(msgBox);
            end, false
        );
        
        addEventHandler("onClientGUIClick", pOK, function(button, state, x, y)
                triggerEvent("onClientMessageBoxClose", msgBox, guiGetText(pInput));
                destroyElement(msgBox);
            end, false
        );
        
        addEventHandler("onClientGUIClick", pCancel, function(button, state, x, y)
                triggerEvent("onClientMessageBoxClose", msgBox, false);
                destroyElement(msgBox);
            end, false
        );
    end
    
    return msgBox;
end

function xmlNotify(node, event, ...)
    local m,n;
    
    for m,n in pairs(xmleditors) do
        if (n.node == node) then
            n.notify(event, ...);
        else
            local j,k;
            
            -- Check if it has a child
            for j,k in ipairs(n.node.children) do
                if (k == node) then
                    n.notifyChild(j, event, ...);
                    break;
                end
            end
        end
    end
    
    return false;
end

function xmlCreateEditor(node)
    local screenW, screenH = guiGetScreenSize();
    local guiW, guiH = 600, 250;
    local xmleditor = {};
    local m,n;
    local id=1;
    
    xmleditor.window = guiCreateWindow((screenW - guiW) / 2, (screenH - guiH) / 2, guiW, guiH, "XML Editor (" .. node.name .. ")", false);
    
    guiSetVisible(xmleditor.window, mainGUI.visible);
    
    xmleditors[xmleditor] = xmleditor;
    xmleditor.id = id;
    xmleditor.node = node;
    xmleditor.subwindows = {};
    
    xmleditor.pChildren=guiCreateGridList(0, 20, guiW - 250, guiH - 50, false, xmleditor.window);
    guiGridListAddColumn(xmleditor.pChildren, "Node Name", 0.3);
    guiGridListAddColumn(xmleditor.pChildren, "Sub", 0.1);
    guiGridListAddColumn(xmleditor.pChildren, "Attributes", 0.55);
    
    local function xmlShowMessageBox(msg, title, usage, ...)
        local msgbox = createMessageBox(msg, title, usage, ...);
        
        table.insert(xmleditor.subwindows, msgbox);
        
        addEventHandler("onClientMessageBoxClose", msgbox, function()
                local m,n;
        
                for m,n in ipairs(xmleditor.subwindows) do
                    if (n == source) then
                        table.remove(xmleditor.subwindows, m);
                        break;
                    end
                end
            end
        );
        
        return msgbox;
    end
    
    local function resizeAttributes()
        local nameWidth = 100;
        local attWidth = 100;
        local n=0;
        local rowcount = guiGridListGetRowCount(xmleditor.pAttributes);
        
        while (n < rowcount) do
            local curName = dxGetTextWidth(guiGridListGetItemText(xmleditor.pAttributes, n, 1)) + 20;
            local curAtt = dxGetTextWidth(guiGridListGetItemText(xmleditor.pAttributes, n, 2)) + 20;
            
            if (nameWidth < curName) then
                nameWidth = curName;
            end
            
            if (attWidth < curAtt) then
                attWidth = curAtt;
            end
            
            n = n + 1;
        end
        
        guiGridListSetColumnWidth(xmleditor.pAttributes, 1, nameWidth, false);
        guiGridListSetColumnWidth(xmleditor.pAttributes, 2, attWidth, false);
        return true;
    end
    
    local function xmlAskAttribute(node)
        local input = xmlShowMessageBox("Specify the attribute to be set.\nFirst ',' seperates the key from value (ex. font,sans).", "Set attribute", "input");
        
        addEventHandler("onClientMessageBoxClose", input, function(input)                
                if not (input) then return false; end;
                
                -- Seperate the key from value
                local key, value;
                local offset = strfind(input, ",");
                
                if (offset == 1) then
                    showMessageBox("No key specified!", "Attribute Error");
                    return false;
                end
                
                if not (offset) then
                    key = input;
                    value = "";
                else
                    key = strsub(input, 1, offset-1);
                    value = strsub(input, offset+1, strlen(input));
                end
                
                -- Check for valid key
				local n = strfind(key, "[^%a%d_-]");
				
                if (n) then
					showMessageBox("Invalid key name ('" .. strsub(key, n, n) .. "').", "Attribute Error");
					return false;
                end
                
                if (node.cbSetAttribute) and not (node.cbSetAttribute(key, value)) then return false; end;
                
                xmlNotify(node, "set_attribute", key, value);
                
                node.attr[key] = value;
            end
        );
    end
    
    addEventHandler("onClientGUIDoubleClick", xmleditor.pChildren, function(button, state, x, y)
            local row = guiGridListGetSelectedItem(source);
            
            if (row == -1) then return false; end;
            
            local node = node.children[tonumber(guiGridListGetItemData(source, row, 1))];
            
            if (button == "left") then
                xmlCreateEditor(node);
            elseif (button == "right") then
                xmlAskAttribute(node);
            end
        end, false
    );
    
    -- Fill out GUI
	for m,n in ipairs(node.children) do
		local row = guiGridListAddRow(xmleditor.pChildren);
		guiGridListSetItemText(xmleditor.pChildren, row, 1, n.name, false, false);
		guiGridListSetItemText(xmleditor.pChildren, row, 2, tostring(#n.children), false, true);
		
		local j,k;
		local attrstring = "";
		
		for j,k in pairs(n.attr) do
			attrstring = attrstring .. j .. "=" .. "\"" .. k .. "\"" .. " ";
		end
		guiGridListSetItemText(xmleditor.pChildren, row, 3, attrstring, false, false);
		
		guiGridListSetItemData(xmleditor.pChildren, row, 1, tostring(m));
	end
    
    xmleditor.pAttributes=guiCreateGridList(guiW - 240, 20, 260, guiH - 50, false, xmleditor.window);
    guiGridListAddColumn(xmleditor.pAttributes, "Attribute", 0.3);
    guiGridListAddColumn(xmleditor.pAttributes, "Value", 0.60);
    
    function xmleditor.notify(event, ...)
        local args = { ... };
        
        if (event == "set_attribute") then
            local key = args[1];
            local value = args[2];
            local n=0;
            local rowcount = guiGridListGetRowCount(xmleditor.pAttributes);
            
            while (n < rowcount) do
                if (guiGridListGetItemText(xmleditor.pAttributes, n, 1) == key) then
                    guiGridListSetItemText(xmleditor.pAttributes, n, 2, value, false, false);
                    return true;
                end
            
                n = n + 1;
            end

            local row = guiGridListAddRow(xmleditor.pAttributes);
            guiGridListSetItemText(xmleditor.pAttributes, row, 1, key, false, false);
            guiGridListSetItemText(xmleditor.pAttributes, row, 2, value, false, false);
            
            resizeAttributes();
            return true;
        elseif (event == "unset_attribute") then
            local attribute = args[1];
            local n = 0;
            local rowcount = guiGridListGetRowCount(xmleditor.pAttributes);
            
            while (n < rowcount) do
                if (guiGridListGetItemText(xmleditor.pAttributes, n, 1) == attribute) then
                    guiGridListRemoveRow(xmleditor.pAttributes, n);
                    break;
                end
            
                n = n + 1;
            end
            
            resizeAttributes();
            return true;
        elseif (event == "add_child") then
            local child = args[1];
            local row;
			local sort = guiGetProperty(xmleditor.pChildren, "SortDirection");
			
			guiSetProperty(xmleditor.pChildren, "SortDirection", "");
			
			row = guiGridListAddRow(xmleditor.pChildren);
            
            guiGridListSetItemText(xmleditor.pChildren, row, 1, child.name, false, false);
            guiGridListSetItemText(xmleditor.pChildren, row, 2, "0", false, false);

			local j,k;
			local attrstring = "";
			
			for j,k in pairs(child.attr) do
				attrstring = attrstring .. j .. "=" .. "\"" .. k .. "\"" .. " ";
			end
			guiGridListSetItemText(xmleditor.pChildren, row, 3, attrstring, false, false);
		
            guiGridListSetItemData(xmleditor.pChildren, row, 1, tostring(#node.children));
			
			guiSetProperty(xmleditor.pChildren, "SortDirection", sort);
            return true;
        elseif (event == "remove_child") then
            local id = args[1];
            local j,k;
            local rowcount = guiGridListGetRowCount(xmleditor.pChildren);
            local m = 0;
        
            while (m < rowcount) do
				local curId = tonumber(guiGridListGetItemData(xmleditor.pChildren, m, 1));
			
                if (curId == id) then
                    guiGridListRemoveRow(xmleditor.pChildren, m);
					rowcount = rowcount - 1;
					break;
				end
                
                m = m + 1;
            end
			
			-- Decrement the remaining nodes
			while (m < rowcount) do
				local curId = tonumber(guiGridListGetItemData(xmleditor.pChildren, m, 1));
				
				if (curId > id) then
					guiGridListSetItemData(xmleditor.pChildren, m, 1, tostring(curId-1));
				end
				
				m = m + 1;
			end
			
            return true;
        elseif (event == "destroy") then
            local m,n;
        
            -- Notify all children
            for m,n in ipairs(node.children) do
                xmlNotify(n, "destroy");
            end
        
            xmlDestroyEditor(xmleditor);
            return true;
        end
        
        return false;
    end
    
    function xmleditor.notifyChild(id, event, ...)
        local args = { ... };
        local child = node.children[id];
        local n=0;
        local rowcount = guiGridListGetRowCount(xmleditor.pChildren);
        
        while (n < rowcount) do
            if (tonumber(guiGridListGetItemData(xmleditor.pChildren, n, 1)) == id) then
                if (event == "set_attribute") then
                    local key = args[1];
                    local value = args[2];
                    local attrstring;
                    
                    if (child.attr[key]) then
                        local j,k;
                        attrstring = "";
                        
                        for j,k in pairs(child.attr) do
                            if (j == key) then
                                k = value;
                            end
                            
                            attrstring = attrstring .. j .. "=" .. "\"" .. k .. "\"" .. " ";
                        end
                        guiGridListSetItemText(xmleditor.pChildren, n, 3, attrstring, false, false);
                    else
                        attrstring = guiGridListGetItemText(xmleditor.pChildren, n, 3) .. " " .. key .. "=\"" .. value .. "\"";
                        
                        guiGridListSetItemText(xmleditor.pChildren, n, 3, attrstring, false, false);
                        return true;
                    end
                elseif (event == "unset_attribute") then
                    local j,k;
                    local attrstring = "";
                    
                    for j,k in pairs(child.attr) do
                        attrstring = attrstring .. j .. "=" .. "\"" .. k .. "\"" .. " ";
                    end
                    guiGridListSetItemText(xmleditor.pChildren, n, 3, attrstring, false, false);
                    return true;
                elseif (event == "add_child") or
                    (event == "remove_child") then
                    
                    guiGridListSetItemText(xmleditor.pChildren, n, 2, tostring(#child.children), false, true);
                    return true;
                end
            
                break;
            end
            
            n = n + 1;
        end
        
        return false;
    end
    
    addEventHandler("onClientGUIDoubleClick", xmleditor.pAttributes, function(button, state, x, y)
            local row = guiGridListGetSelectedItem(source);
            
            if (row == -1) then
                xmlAskAttribute(node);
            else
                local attribute = guiGridListGetItemText(source, row, 1);
                local input;
				
				if (button == "middle") then
					input = xmlShowMessageBox("Specify the new value of '" .. attribute .. "'", "Set " .. attribute, "input", node.attr[attribute]);
				else
					input = xmlShowMessageBox("Specify the new value of '" .. attribute .. "'", "Set " .. attribute, "input");
				end
                
                addEventHandler("onClientMessageBoxClose", input, function(input)                
                        if not (input) then return false; end;
                        if (node.cbSetAttribute) and not (node.cbSetAttribute(attribute, input)) then return false; end;
                        
                        xmlNotify(node, "set_attribute", attribute, input);
                        
                        node.attr[attribute] = input;
                    end
                );
            end
        end, false
    );
    
    -- Same for attributes
    for m,n in pairs(node.attr) do
        local row = guiGridListAddRow(xmleditor.pAttributes);
        guiGridListSetItemText(xmleditor.pAttributes, row, 1, m, false, false);
        guiGridListSetItemText(xmleditor.pAttributes, row, 2, n, false, false);
    end
    
    -- Apply correct size
    resizeAttributes();
    
    local pAddChild=guiCreateButton(10, guiH - 30, 100, 20, "Add Child", false, xmleditor.window);
    
    addEventHandler("onClientGUIClick", pAddChild, function(button, state, x, y)
            local input = xmlShowMessageBox("Type in the node name.", "Add Child", "input");
            
            addEventHandler("onClientMessageBoxClose", input, function(name)
                    if not (name) then return false; end;
					
					local n = strfind(name, "[^%a%d_-]");
					
					if (n) then
						showMessageBox("Invalid node name ('" .. strsub(name, n, n) .. "').", "Node Creation Failed");
						return false;
					end
                    
                    local child = xmlCreateNodeEx(name);
					
					if not (child) then
						showMessageBox("Failed to create node.", "Node Creation Failed");
						return false;
					end
                    
                    if (node.cbAddChild) and not (node.cbAddChild(child)) then return false; end;
                    
                    table.insert(node.children, child);
                    
                    xmlNotify(node, "add_child", child);
                end
            );
        end, false
    );
    
    local pRemoveChild=guiCreateButton(110, guiH - 30, 100, 20, "Remove Child", false, xmleditor.window);
    
    addEventHandler("onClientGUIClick", pRemoveChild, function(button, state, x, y)
            local row = guiGridListGetSelectedItem(xmleditor.pChildren);
            
            if (row == -1) then return false; end;
            
            local id = tonumber(guiGridListGetItemData(xmleditor.pChildren, row, 1));
            local child = node.children[id];
            
            if (node.cbRemoveChild) and not (node.cbRemoveChild(id)) then return false; end;
            
            xmlNotify(child, "destroy");
            
            table.remove(node.children, id);
            
            xmlNotify(node, "remove_child", id);
        end, false
    );
    
    local pSetAttribute=guiCreateButton(210, guiH - 30, 100, 20, "Set Attribute", false, xmleditor.window);
    
    addEventHandler("onClientGUIClick", pSetAttribute, function(button, state, x, y)
            xmlAskAttribute(node);
        end, false
    );
    
    local pUnsetAttribute=guiCreateButton(310, guiH - 30, 100, 20, "Unset Attribute", false, xmleditor.window);
    
    addEventHandler("onClientGUIClick", pUnsetAttribute, function(button, state, x, y)
            local row = guiGridListGetSelectedItem(xmleditor.pAttributes);
            
            if (row == -1) then return false; end;
            
            local attribute = guiGridListGetItemText(xmleditor.pAttributes, row, 1);
            
            if (node.cbUnsetAttribute) and not (node.cbUnsetAttribute(attribute)) then return false; end;
            
            node.attr[attribute] = nil;
            
            xmlNotify(node, "unset_attribute", attribute);
        end, false
    );
    
    local pClose=guiCreateButton(guiW-100, guiH - 30, 100, 20, "Close", false, xmleditor.window);
    
    addEventHandler("onClientGUIClick", pClose, function(button, state, x, y)
            xmlDestroyEditor(xmleditor);
        end, false
    );
    
    addEventHandler("onClientGUISize", xmleditor.window, function()
            local width, height = guiGetSize(xmleditor.window, false);
            
            width = math.max(width, 600);
            height = math.max(height, 250);
            
            guiSetSize(xmleditor.window, width, height, false);
            
            guiSetSize(xmleditor.pChildren, width - 250, height - 50, false);
            
            guiSetPosition(xmleditor.pAttributes, width - 240, 20, false);
            guiSetSize(xmleditor.pAttributes, 260, height - 50, false);
            
            guiSetPosition(pAddChild, 10, height - 30, false);
            guiSetPosition(pRemoveChild, 110, height - 30, false);
            guiSetPosition(pSetAttribute, 210, height - 30, false);
            guiSetPosition(pUnsetAttribute, 310, height - 30, false);
            guiSetPosition(pClose, width - 100, height - 30, false);
        end, false
    );
    
    return xmleditor;
end

function xmlShowEditors(show)
	local m,n;
	
	for m,n in pairs(xmleditors) do
		local j,k;
		
		for j,k in ipairs(n.subwindows) do
			guiSetVisible(k, show);
		end
	
		guiSetVisible(n.window, show);
	end

	return true;
end

function xmlDestroyEditor(editor)
    local m,n;
	
	if not (xmleditors[editor]) then return false; end;
    
    for m,n in ipairs(editor.subwindows) do
        closeMessageBox(n);
    end
    
    xmleditors[editor] = nil;
    
    destroyElement(editor.window);
	return true;
end

function xmlDestroyEditors()
	local m,n;
	
	for m,n in pairs(xmleditors) do
		xmlDestroyEditor(n);
	end
	
	return true;
end

-- tonumber and tocolor dont ******* match 
function tonumbersign(num)
    return tocolor(tonumber("0x" .. strsub(num, 3, 4)), tonumber("0x" .. strsub(num, 5, 6)), tonumber("0x" .. strsub(num, 7, 8)), 255);
end

function getTextLogicalOffset(text, offset, charScale, charFont)
	local n = 1;
	local len = strlen(text);
	local curOffset = 0;
	local charWidth;

	while (n <= len) do
		charWidth = dxGetTextWidth(strsub(text, n, n), charScale, charFont);
		curOffset = curOffset + charWidth;
		
		n = n + 1;
		
		if (curOffset > offset) then
			break;
		end
	end
	
	if not (n == 1) and (curOffset - offset > charWidth * 0.5) then
		return n-1, curOffset - charWidth;
	end
	
	return n, curOffset;
end

function parseScript(script)
    local output = "";
    local m = 1;
	local n;
	local char;
	local lineBegin = 1;
    local len=strlen(script);
	
	while (true) do
		n = strfind(script, "[\r\n\t]", m);
		char = strbyte(script, n);
		
		if (n == nil) then
			return output .. strsub(script, m, len);
		else
			if (char == 10) then
				output = output .. strsub(script, m, n);
				lineBegin = n + 1;
			elseif (char == 9) then
				output = output .. strsub(script, m, n - 1);
				output = output .. string.rep(" ", 4 - (n - lineBegin) % 4);
				
				lineBegin = n + 1;
			else
				output = output .. strsub(script, m, n - 1);
			end
		end
		
		m = n + 1;
	end

    return output;
end