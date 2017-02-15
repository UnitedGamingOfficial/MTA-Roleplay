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

addEvent("onClientKeyStateChange");
addEvent("onClientInterfaceClick");
addEvent("onClientInterfaceMouseMove");
addEvent("onClientInterfaceKey");
addEvent("onClientInterfaceInput");
addEvent("onClientGUIPropertyChanged");
addEvent("onClientGUIDissolve");
local hint=false;
local activeGUI=false;
local removeActiveGUI=false;
local specialKeys={};
local hackFocus = guiCreateStaticImage(0, 0, 1, 1, "pixel.png", false);

local editableGUI = {
	["gui-edit"] = true,
	["gui-memo"] = true
};

-- Mouse Globals
mouseX, mouseY = 0, 0;
mouseMoveTime = getTickCount();

addEventHandler("onClientPreRender", root, function()
		local relX, relY = getCursorPosition();
		
		if not (relX) then return true; end;
		
		local screenW, screenH = guiGetScreenSize();
		local x, y = relX * screenW, relY * screenH;
		
		if (mouseX == x) and (mouseY == y) then return true; end;
		
        mouseX, mouseY = x, y;
		mouseMoveTime = getTickCount();
		
		if (handleDXMouseMove(x, y)) then return true; end;
		
		triggerEvent("onClientInterfaceMouseMove", root, x, y);
	end
);

addEventHandler("onClientClick", root, function(button, state, x, y)
		destroyHint();

		if (handleDXMouseClick(button, (state == "down"), x, y)) then
			guiReleaseFocus();
			return true;
		end
		
		triggerEvent("onClientInterfaceClick", root, button, (state == "down"), x, y);
	end
);

addEventHandler("onClientGUIFocus", root, function()
		activeGUI = source;
		
		removeActiveGUI = false;
	end
);

addEventHandler("onClientGUIBlur", root, function()
		removeActiveGUI = true;
	end
);

function guiReleaseFocus()
	if not (activeGUI) then return true; end;

	guiBringToFront(hackFocus);
	
	activeGUI = false;
	return true;
end

addEventHandler("onClientElementDestroy", root, function()
		if not (source == activeGUI) then return true; end;
		
		activeGUI = false;
	end
);

-- KEY TABLES START
local keyTable = { "arrow_l", "arrow_u", "arrow_r", "arrow_d", "num_0", "num_1", "num_2", "num_3", "num_4", "num_5",
 "num_6", "num_7", "num_8", "num_9", "num_mul", "num_add", "num_sep", "num_sub", "num_div", "num_dec", "F1", "F2", "F3", "F4", "F5",
 "F6", "F7", "F8", "F9", "F10", "F11", "F12", "backspace", "tab", "lalt", "ralt", "enter", "space", "pgup", "pgdn", "end", "home",
 "insert", "delete", "lshift", "rshift", "lctrl", "rctrl", "pause", "capslock", "scroll" };
 
local inputTable = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
 "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "[", "]", ";", ",", "-", ".", "/", "#", "\\", "=" };
 
local specialTable = { "mouse1", "mouse2", "mouse3", "mouse4", "mouse5", "mouse_wheel_up", "mouse_wheel_down" };
 -- KEY TABLES END
 
-- Init our keyInfo
for m,n in ipairs(keyTable) do
    local info = {};
    
    info.state = false;
    info.input = false;
    keyInfo[n] = info;
end

for m,n in ipairs(inputTable) do
    local info = {};
    
    info.state = false;
    info.input = true;
    keyInfo[n] = info;
end

for m,n in ipairs(specialTable) do
	specialKeys[n] = true;
end

function guiGetAtPosition(x, y)
    local m,n;
    local guiroot = getElementsByType("guiroot");
    
    for m,n in ipairs(guiroot) do
		local j,k;
		local children = getElementChildren(n);
		
		for j,k in ipairs(children) do
			if (guiGetVisible(k)) then
				local posX, posY = guiGetPosition(k, false);
				local width, height = guiGetSize(k, false);
				
				if (x > posX) and (y > posY) and (x < posX + width) and (y < posY + height) then
					return k;
				end
			end
		end
    end
    
    return false;
end

function showHint(x, y, text, charScale, charFont)	
	local screenW, screenH = guiGetScreenSize();
	
	-- Make sure the previous hint is destroyed
	destroyHint();
	
	if not (charScale) then
		charScale = 1;
	end
	
	if not (charFont) then
		charFont = "default";
	end

	hint = {
		x = x,
		y = y,
		lineData = structureString(text, screenW - x - 50, screenW - x - 50, charScale, charFont),
		
		charScale = charScale,
		charFont = charFont,
		
		surface = false
	};
	
	function hint.destroy()
		if (hint.surface) then
			destroyElement(hint.surface);
		end
	end
	
	-- Maybe in the future, I add multiple hints, lolol
	return hint;
end

function showCursorHint(text)
	local hint = showHint(mouseX, mouseY, text);
	local now = getTickCount();
	
	function hint.cbUpdate()
		if (getTickCount() - now > 2500) then return false; end;
	
		hint.x = mouseX;
		hint.y = mouseY;
		return true;
	end
	
	return true;
end

function destroyHint()
	if (hint) then
		hint.destroy();
		
		hint = false;
	end
	
	return true;
end

local function isEditableGUI(gui)
	return (gui) and not (editableGUI[getElementType(gui)] == nil);
end

addEventHandler("onClientGUIFocus", guiRoot, function()
		if (isEditableGUI(source)) then
			setInputMode("no_binds");
		end
	end
);

addEventHandler("onClientGUIBlur", guiRoot, function()
		if not (isEditableGUI(source)) then return true; end;
		
		setInputMode("allow_binds");
	end
);

local function handleKeyInput(button, down, isInput)
	if (handleDXKeyInput(button, down, isInput)) then return true; end;
	
	triggerEvent("onClientKeyStateChange", root, button, down, isInput);
	return true;
end
 
addEventHandler("onClientPreRender", root, function()
        local m,n;
		local now = getTickCount();
        
        for m,n in pairs(keyInfo) do
            local state = getKeyState(m);
			
            if not (state == n.state) then
                if (state) and (not (n.input) or not (activeGUI) or not (isEditableGUI(activeGUI))) then
                    handleKeyInput(m, true, n.input);
					
					lastKeyPress = m;
					lastKeyTime = getTickCount();
                else
                    handleKeyInput(m, false, n.input);
					
					if (lastKeyPress == m) then
						lastKeyPress = false;
					end
                end
                
                n.state = state;
            end
        end
		
		-- Hack for delayed GUI fade notification
		if (removeActiveGUI) then
			activeGUI = false;
			
			removeActiveGUI = false;
		end
		
		if (lastKeyPress) and (now - lastKeyTime > 500) then
			handleKeyInput(lastKeyPress, true, keyInfo[lastKeyPress].input);
			
			lastKeyTime = now - 475;
		end
    end
);

addEventHandler("onClientCharacter", root, function(char)
		if (handleDXInput(char)) then return true; end;
		
		triggerEvent("onClientInterfaceInput", root, char);
	end
);

addEventHandler("onClientKey", root, function(button, down)
		if not (specialKeys[button]) then return true; end;
		
		handleKeyInput(button, down, false);
	end
);

-- Deprecated hint system!
addEventHandler("onClientRender", root, function()
		if not (hint) then return false; end;

		if (hint.cbUpdate) and not (hint.cbUpdate()) then
			if (hint.surface) then
				destroyElement(hint.surface);
			end
			
			hint = false;
			return;
		end
		
		local width = hint.lineData.width + 10;
		local height = hint.lineData.height + 10;
		
		if not (hint.surface) or (hint.changed) then
			hint.surface = dxCreateRenderTarget(width, height, false);
			
			hint.changed = true;
		end
		
		if (hint.changed) then
			local n, line;
			local y = 0;
			local fontHeight = dxGetFontHeight(hint.charScale, hint.charFont);

			dxSetRenderTarget(hint.surface);
			
			dxDrawRectangle(0, 0, width, height, tocolor(0x80, 0x80, 0x80, 0xFF));
			dxDrawRectangle(1, 1, width - 2, height - 2, tocolor(225, 225, 225, 255));
			
			for n=1,#hint.lineData.lines do
				line = hint.lineData.lines[n];
				
				if not (strlen(line) == 0) then
					dxDrawText(line, 5, 5 + y, 0, 0, tocolor(0x00, 0x00, 0x00, 0xFF));
				end
				
				y = y + fontHeight;
			end
			
			dxSetRenderTarget();
			
			hint.changed = false;
		end
		
		dxDrawImage(hint.x, hint.y, width, height, hint.surface, 0, 0, 0, tocolor(0xFF, 0xFF, 0xFF, 0xFF), true);
	end
);

addEventHandler("onClientRestore", root, function()
		if (hint) then
			hint.changed = true;
		end
	end
);

function setInputMode(mode)
	triggerEvent("onClientGUIPropertyChanged", guiRoot, "inputMode", mode);
	
	if (wasEventCancelled()) then return false; end;
	
	guiSetInputMode(mode);
	return true;
end