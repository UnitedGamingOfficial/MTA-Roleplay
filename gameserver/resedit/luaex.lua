--[[
	Double conversion code taken from ChunkSpy 0.9.8!
]]

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

-- Compiler definitions
local falseDef = strchar(0);
local trueDef = strchar(1);
local luaSignature = strchar(0x1B) .. "Lua";
local luaVersion = strchar(0x51);
local typeNil = strchar(0);
local typeBool = strchar(1);
local typeLightUserdata = strchar(2);
local typeNumber = strchar(3);
local typeString = strchar(4);
local typeTable = strchar(5);
local typeFunction = strchar(6);
local typeUserdata = strchar(7);
local typeThread = strchar(8);

-- From ChunkSpy
local function grab_byte(v)
  return math.floor(v / 256), strchar(math.floor(v) % 256)
end

local function doubleToByte(x)
	local sign = 0
	
	if x < 0 then sign = 1; x = -x end
	
	local mantissa, exponent = math.frexp(x)
	
	if x == 0 then -- zero
		mantissa, exponent = 0, 0
	else
		mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 53)
		exponent = exponent + 1022
	end
	
	local v, byte = "" -- convert to bytes
	x = mantissa
	
	for i = 1,6 do
		x, byte = grab_byte(x); v = v..byte -- 47:0
	end
	
	x, byte = grab_byte(exponent * 16 + x); v = v..byte -- 55:48
	x, byte = grab_byte(sign * 128 + x); v = v..byte -- 63:56
	return v
end
-- ChunkSpy end

-- Thanks to gwell from stackoerflow.com for int_to_bytes
-- I changed this to return a string
local function intToByte(n)
	return strchar(n%256) .. strchar((math.modf(n/256))%256) .. strchar((math.modf(n/65536))%256) .. strchar((math.modf(n/16777216))%256);
end

local function dumpInt(int)
	return intToByte(int);
end

local function dumpNumber(double)
	return doubleToByte(double);
end

local function dumpString(str)
	return intToByte(strlen(str) + 1) .. str .. strchar(0);
end

local function dumpBool(bool)
	if (bool) then
		return trueDef;
	end
	
	return falseDef;
end

local function dumpFunction(proto)
	local code = "";
	local m,n;

	-- General information
	code = code .. dumpString(proto.name) .. dumpInt(proto.lineDefined) .. dumpInt(proto.lastLineDefined) .. strchar(#proto.upValues) .. strchar(proto.numParams) .. dumpBool(proto.isVararg) .. strchar(proto.stackSize);
	
	-- Now the code
	code = code .. dumpInt(#proto.instructions);
	
	for m,n in ipairs(proto.instructions) do
		code = code .. dumpInt(n);
	end
	
	-- Constants
	code = code .. dumpInt(#proto.constants);
	
	for m,n in ipairs(proto.constants) do
		local t = type(n);
		
		if (t == "string") then
			code = code .. typeString .. dumpString(n);
		elseif (t == "number") then
			code = code .. typeNumber .. dumpNumber(n);
		elseif (t == "boolean") then
			code = code .. typeBool .. dumpBool(n);
		else
			error("Unknown constant " .. t);
		end
	end
	
	-- Functions
	code = code .. dumpInt(#proto.functions);
	
	for m,n in ipairs(proto.functions) do
		code = code .. dumpFunction(n);
	end
	
	-- Zero out debug info
	return code .. dumpInt(0) .. dumpInt(0) .. dumpInt(0);
end

function scanLines(script)
	local lineData = {};
	local info = {
		offset = 1
	};
	
	table.insert(lineData, info);
	
	while (true) do
		local offset, begin = strfind(script, "\n", info.offset);
		
		if not (offset) then
			info.offsetEnd = strlen(script);
		
			return lineData;
		end
		
		info.offsetEnd = offset;
		
		info = {
			offset = offset + 1
		};
		table.insert(lineData, info);
	end
end

local function compile(chunk, environment)
	local proto = {
		name = "LuaEX",
		lineDefined = 0,
		lastLineDefined = 0,
		upValues = {},
		numParams = 0,
		isVararg = false,
		stack = {},
		stackSize = 2,
		
		instructions = {},
		constants = {},
		functions = {}
	};
	
	function proto.loadConst(reg, const)
		table.insert(proto.instructions, 1 + reg * 64 + const * 16384);
	end
	
	function proto.loadBool(reg, bool, skip)
		if (bool == true) then
			bool = 1;
		elseif (bool == false) then
			bool = 0;
		end
		
		if (skip == true) then
			skip = 1;
		elseif (skip == false) then
			skip = 0;
		end
		
		table.insert(proto.instructions, 2 + reg * 64 + bool * 8388608 + skip * 16384);
	end
	
	function proto.loadNil(from, to)
		table.insert(proto.instructions, 3 + reg * 64 + to * 8388608);
	end
	
	function proto.getUpValue(reg, upval)
		table.insert(proto.instructions, 4 + reg * 64 + upval * 8388608);
	end
	
	function proto.getGlobal(reg, constspec)
		table.insert(proto.instructions, 5 + reg * 64 + upval * 16384);
	end
	
	function proto.getTable(reg, id, index, isConst)
		local inst = 6 + reg * 64 + id * 8388608 + index * 16384;
		
		if (isConst) then
			inst = inst + 1048576;
		end
	
		table.insert(proto.instructions, inst);
	end
	
	function proto.setUpValue(upval, reg)
		table.insert(proto.instructions, 7 + upval * 8388608 + reg * 64);
	end
	
	function proto.setTable(id, index, reg, isConst)
		local inst = 8 + index * 64 + id * 8388608 + index + 16384;
		
		if (isConst) then
			inst = inst + 1048576;
		end
		
		table.insert(proto.instructions, inst);
	end
	
	function proto.instReturn(from, to)
		table.insert(proto.instructions, 30 + from * 64 + to * 8388608);	-- Return "hello world"
	end
	
	local function getScriptItem()
		
	end

	-- We setup the environment
	local offset, token, begin, errStart = getNextItem(chunk, 1);
	
	while (true) do
		if (offset == false) then
			if not (token) then
				break;
			end
			
			-- Output a syntax error and quit
			environment.error("syntax error");
			return false;
		end
		
		if (token == "local") then
			offset, token, begin = getNextItem(chunk, offset);
			
			
		elseif (token == "function") then
			
		else
			table.insert(environment.tokens, token);
		end
		
		offset, token, begin, errStart = getNextItem(chunk, offset);
	end
	
	proto.instReturn(0, 0);
	return proto;
end

local function strlimit(str, nchar)
	local len = strlen(str);

	if (len > nchar) then
		return strsub(str, len - nchar, len) .. "...";
	end
	
	return str;
end

function loadstringex(script, options)
	local environment = {
		source = '[string: "' .. script .. '"]',
		tokens = {},
		line = 1,
		err = nil,
		
		lineData = scanLines(script)
	};
	
	function environment.error(output)
		environment.err = strlimit(environment.source, 30) .. ":" .. environment.line .. ": " .. output;
	end
	
	local proto = compile(script, environment);
	
	if not (proto) then
		return false, environment.err;
	end

	-- Construct header
	local code = luaSignature .. luaVersion .. string.char(0) .. string.char(1) .. string.char(4) .. string.char(4) .. string.char(4) .. string.char(8) .. string.char(0).. dumpFunction(compile(script));
	
	local routine, errors = loadstring(code .. dumpFunction(compile(script, environment)));
	
	if not (routine) then
		return false, errors;
	end
	
	return routine;
end
