local string = string;
local math = math;
local table = table;
local strsub = string.sub;
local strbyte = string.byte;
local strchar = string.char;
local strlen = string.len;
local strfind = string.find;
local ipairs = ipairs;
local pairs = pairs;
local collectgarbage = collectgarbage;

-- Thanks to gwell from stackoverflow.com
-- convert bytes (network order) to a 32-bit two's complement integer
function bytes_to_int(b1, b2, b3, b4)
  return b1*16777216 + b2*65536 + b3*256 + b4;
end

function getFileExtension(src)
    local lastOffset;
    local begin, last = strfind(src, "[.]");

    while (begin) do
        lastOffset = begin+1;
		
        begin, last = strfind(src, "[.]", lastOffset);
    end
    
    return strsub(src, lastOffset, strlen(src));
end

function fileParsePath(path)
	local arches = {};
	local n = 0;
	local lastBreak = 1;
	local name;
	local len = strlen(path);
	local j,k;
	local output = "";

	while (true) do
		n = strfind(path, "[\\/]", lastBreak);

		if not (n) then break; end;

		local archName = strsub(path, lastBreak, n - 1);

		if (strlen(archName) == 0) then return false; end;

		if (strfind(archName, "[<>:\"/|?*]")) then return false; end;

		if (archName == "..") then
			if (#arches == 0) then return false; end;

			table.remove(arches);
		elseif not (archName == ".") then
			table.insert(arches, archName);
		end

		lastBreak = n + 1;
	end

	for j,k in ipairs(arches) do
		output = output .. k .. "/";
	end

	if (lastBreak <= len) then
		local filename = strsub(path, lastBreak, len);

		if (strfind(filename, "[<>:\"/|?*]")) then return false; end;

		return output .. filename, true;
	end

	return output, false;
end

-- New string.match routine
function globmatch(str, matchWith)
	local m,n;
	local lastBreak;
	local len = strlen(str);

	lastBreak = strfind(matchWith, "*", 1);

	if not (lastBreak) then
		return str == matchWith;
	end

	lastBreak = lastBreak + 1;

	if not (strsub(str, 1, lastBreak - 2) == strsub(matchWith, 1, lastBreak - 2)) then return false; end;

	m = lastBreak - 1;

	while (true) do
		n = strfind(matchWith, "*", lastBreak);

		if not (n) then break; end;

		local find = strsub(matchWith, lastBreak, n - 1);

		m = strfind(str, find, m, true);

		if not (m) then return false; end;

		m = m + strlen(find);

		lastBreak = n + 1;
	end

	local find = strsub(matchWith, lastBreak, strlen(matchWith));

	if (strlen(find) == 0) then return true; end;

	m = strfind(str, find, m, true);

	if (m) then
		m = m + 1;

		while (true) do
			n = strfind(str, find, m, true);

			if not (n) then break; end;

			m = n + 1;
		end

		m = m - 1 + strlen(find);
	else
		return false;
	end

	return m == len + 1;
end

function isName(char)
    if ((char > 96) and (char < 123)) or ((char > 64) and (char < 91))
        or (char == 95)     -- _
        or (char == 45)     -- -
        or (char == 46)     -- .
        or (char == 58) then    -- :
        
        return true;
    end
    
    return false;
end

function getNextSimpleItem(script, offset)
    local m,n;
    local len=strlen(script);
	local char;
	local parseOffset;
	
	parseOffset = strfind(script, "[%a%d_.:]", offset);
	
	if not (parseOffset) then
		return false, nil, len, offset;
	end
	
	m = strfind(script, "[^%a%d_.:]", parseOffset+1);
	
	if (m == nil) then
		m = len+1;
	end
	
	return m, strsub(script, parseOffset, m-1), parseOffset;
end

-- returns new offset and item
function getNextItem(script, offset)
    local m,n;
    local len=strlen(script);
	local char;
	local parseOffset;
	
	m = string.find(script, "[^%s%c]", offset);

	if (m == nil) then
		return false, nil, len, offset;
	end
	
	char = strbyte(script, m);
        
	if (char == 45) and (strbyte(script, m+1) == 45) then	-- --
		parseOffset = m;
	
		if (strbyte(script, m+2) == 91) and (strbyte(script, m+3) == 91) then  -- --[[
			m, n = strfind(script, "]]", m+4);
			
			if (m == nil) then
				return false, "--[[", len, parseOffset;
			end
			
			return m+2, strsub(script, parseOffset, n), parseOffset;
		end
		
		m = strfind(script, "\n", m+2);
		
		if (m == nil) then
			m = len + 1;
		end
		
		return m+1, strsub(script, parseOffset, m-1), parseOffset;
	elseif (char == 91) and (strbyte(script, m+1) == 91) then  -- [[
		parseOffset = m;
		m = strfind(script, "]]", m+2);
		
		if (m == nil) then
			return false, "[[", len, parseOffset;
		end
		
		return m+2, strsub(script, parseOffset, m+1), parseOffset;
	elseif (char == 34) then    -- "
		parseOffset = m;
		
		repeat
			m = strfind(script, '[\n\\"]', m+1);
			
			if (m == nil) then
				return false, '"', len, parseOffset;
			end
			
			char = strbyte(script, m);
			
			if (char == 92) then
				m = m + 1;
			elseif (char == 10) then
				return false, '"', m-1, parseOffset;
			end
		until (char == 34);
		
		return m+1, strsub(script, parseOffset, m), parseOffset;
	elseif (char == 39) then     -- '
		parseOffset = m;
		
		repeat
			m = strfind(script, "[\n\\']", m+1);
			
			if (m == nil) then
				return false, '"', len, parseOffset;
			end
			
			char = strbyte(script, m);
			
			if (char == 92) then
				m = m + 1;
			elseif (char == 10) then
				return false, '"', m-1, parseOffset;
			end
		until (char == 39);
		
		return m+1, strsub(script, parseOffset, m), parseOffset;
	end
	
	parseOffset = m;
	
	m = strfind(script, "[^%a%d_.:]", m);
	
	if (m == nil) then
		m = len + 1;
	elseif (m == parseOffset) then
		return m+1, strchar(char), m;
	end
	
	return m, strsub(script, parseOffset, m-1), parseOffset;
end

local function xmlScanNode(xml, offset)
    local offset, token, nodeEnd = getNextItem(xml, offset);
    local nodeStart;
    local inNode=false;
    
    while (offset) do
        token = strbyte(token);
    
        if (inNode) then
            if (token == 33) or (token == 63) then
                local begin, offsetEnd = strfind(xml, ">", offset);
                
                if not (begin) then
                    return false;
                end
                
                offset = begin + 1;
                inNode = false;
            elseif (token == 62) then
                return strsub(xml, nodeStart, nodeEnd), offset, nodeStart;
            elseif (token == 60) then
                return false;
            end
        else
            if (token == 60) then
                if (inNode) then
                    return false;
                end
                
                inNode = true;
                nodeStart = nodeEnd;
            elseif (token == 62) then
                return false;
            end
        end
        
        offset, token, nodeEnd = getNextItem(xml, offset);
    end
    
    return false;
end

function parseStringInternal(input)
    local n=1;
    local len=strlen(input);
    local output = "";
    
    while (n <= len) do
        local char = strsub(input, n, n);
        
        if (char == "\\") then
            n = n + 1;
            
            char = strsub(input, n, n);
            
            if (char == "n") then
                output = output .. "\n";
            elseif (char == "a") then
                output = output .. "\a";
            end
        else
            output = output .. char;
        end
        
        n = n + 1;
    end
    
    return output;
end

function convertStringInternal(input)
    local n=1;
    local len=strlen(input);
    local output = "";
    
    while (n <= len) do
        local char = strsub(input, n, n);
        
        if (char == "\n") then
            output = output .. "\\n";
        elseif (char == "\a") then
            output = output .. "\\a";
        else
            output = output .. char;
        end
        
        n = n + 1;
    end
    
    return output;
end

function xmlParse(xml)
    return xmlParseNode(xml, 1);
end

function xmlParseNode(xml, xmlOffset)
    local token, offset = xmlScanNode(xml, xmlOffset);
    local setOffset, setToken;
    local key, value;
    
    if not (token) then return false; end;
    
    -- Parse the node, it is the node we want
    local setting = strsub(token, 2, strlen(token) - 1);
    
    setOffset, setToken = getNextItem(setting, 1);
    
    local node = xmlCreateNodeEx(setToken);
    
    if not (node) then return false; end;
    
    setOffset, key = getNextItem(setting, setOffset);
    
    while (setOffset) do
        if (key == "/") then
            -- The node is parsed correctly
            return node, offset;
        elseif not (isName(strbyte(key))) then
            return false;   -- Some wrong char was input
        end
        
        setOffset, setToken = getNextItem(setting, setOffset);
        
        -- There can be only '='
        if not (setToken == "=") then
            outputDebugString("error "..setToken .. " " .. tostring(strbyte(setToken)));
            return false;
        end
        
        setOffset, value = getNextItem(setting, setOffset);
        
        -- Has to be string, yeah
        if not (strbyte(value) == 34) then return false; end;
        
        -- But this string has to be parsed, then we can set the attribute
        node.attr[key] = parseStringInternal(strsub(value, 2, strlen(value)-1));     
    
        setOffset, key = getNextItem(setting, setOffset);
    end
    
    token, offset, key = xmlScanNode(xml, offset);
    
    while (token) do
        -- See whether this token closes us
        setting = strsub(token, 2, offset - 2);
        
        setOffset, setToken = getNextItem(setting, 1);
        
        if (setToken == "/") then
            setOffset, setToken = getNextItem(setting, setOffset);
            
            if not (setToken == node.name) then return false; end;
            
            -- Finished children correctly
            return node, offset;
        elseif not (setToken == "!") then
            local child;
            child, offset = xmlParseNode(xml, key);
            
            if not (child) then return false; end;
            
            table.insert(node.children, child);
        end
        
        token, offset, key = xmlScanNode(xml, offset);
    end
    
    -- We need a closing node
    return false;
end

function xmlCreateNodeEx(name)
    local node = {};
	
	if not (name) or (strlen(name) == 0) then return false; end;
	
	if (strfind(name, "[^%a%d_-]")) then return false; end;
    
    node.name = name;
    node.children = {};
    node.attr = {};
    
    function node.writeTree(tabcount)
        local buff = string.rep(" ", tabcount * 4) .. "<" .. node.name;
        local m,n;
        
        if not (tabcount) then
            tabcount = 0;
        end
        
        for m,n in pairs(node.attr) do
            buff = buff .. " " .. m .. "=\"" .. convertStringInternal(n) .. "\"";
        end
        
        if (#node.children == 0) then
            buff = buff .. " />\n";
            return buff;
        end
        
        buff = buff .. ">\n";
        
        for j,k in ipairs(node.children) do
            buff = buff .. k.writeTree(tabcount + 1);
        end
        
        buff = buff .. string.rep(" ", tabcount * 4) ..  "</" .. node.name .. ">\n";
        return buff;
    end
    
    return node;
end

function xmlCreateChildEx(parent, name)
	local node = xmlCreateNodeEx(name);
	
	table.insert(parent.children, node);
	return node;
end

-- Pull xml node into table
function xmlGetNode(pXml)
    local pBuff;
    local m,n;
    local attribs;
	
	if not (pXml) then return false; end;
	
	pBuff = xmlCreateNodeEx(xmlNodeGetName(pXml));
	attribs=xmlNodeGetAttributes(pXml);
    
    for m,n in pairs(attribs) do
        pBuff.attr[m]=n;
    end
    
    local children=xmlNodeGetChildren(pXml);
    
    for m,n in ipairs(children) do
        table.insert(pBuff.children, xmlGetNode(n));
    end
    return pBuff;
end

-- Save the node from table
function xmlSetNode(pXml, content)
    local m,n;
    local children = xmlNodeGetChildren(pXml);
    local attributes = xmlNodeGetAttributes(pXml);
    
    -- Destroy previous children
    for m,n in ipairs(children) do
        xmlDestroyNode(n);
    end
    
    -- Unset previous attributes
    for m,n in pairs(attributes) do
        xmlNodeSetAttribute(pXml, m, nil);
    end
    
    xmlNodeSetName(pXml, content.name);
	
    for m,n in pairs(content.attr) do
        xmlNodeSetAttribute(pXml, m, n);
    end
    
    for m,n in ipairs(content.children) do
        xmlSetNode(xmlCreateChild(pXml, n.name), n);
    end
	
    return true;
end

function xmlFindSubNodeEx(node, name)
    local m,n;
    
    for m,n in ipairs(node.children) do
        if (n.name == name) then
            return n;
        end
    end
    
    return false;
end

function findCreateNode(node, name)
    local found = xmlFindSubNodeEx(node, name);
    
    if not (found) then
        found = xmlCreateNodeEx(name);
        table.insert(node.children, found);
    end

    return found;
end