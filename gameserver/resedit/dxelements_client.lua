-- Created by (c)The_GTA. All rights reserved.

--[[
	I allow you to use this in your project if you do not modify this.
	You can create advanced rendering solutions if you understand this logic.
	
	Do NOT copy the code of my rendering solutions though, i.e. dropDown or menu.
	Just take them as examples!
	
		The_GTA
]]

-- Optimizations
local ipairs = ipairs;
local pairs = pairs;
local type = type;

local elements = {};
local alwaysOnTopElements = {};
local activeElement = false;
local mouseElement = false;
local classForceSub = {
	destroy = true
};
local classNoAccess = {
	super = true
};

-- Temporarily force-disable instruction count hook
debug.sethook(nil);

local function createClass(members, forcedSuper)
	local class = members or {};
	local meta = {};
	local methods = {};
	local classmeta = {};
	local methodenv = {};
	local forceSuper = {};
	local m,n;
	
	for m,n in pairs(classForceSub) do
		forceSuper[m] = true;
	end
	
	if (forcedSuper) then
		for m,n in pairs(forcedSuper) do
			forceSuper[m] = true;
		end
	end
	
	function classmeta.__index(t, key)
		if (class[key] == nil) then
			return _G[key];
		end
	
		return class[key];
	end
	
	function classmeta.__newindex(t, key, value)
		if (methods[key]) then
			error("cannot overwrite method '" .. key .. "'", 2);
		elseif (type(value) == "function") then
			_G[key] = value;
			return true;
		end
		
		rawset(class, key, value);
		return true;
	end
	
	classmeta.__metatable = classmeta;
	setmetatable(methodenv, classmeta);
	
	function meta.__newindex(tab, key, value)
		if (classNoAccess[key]) then
			error("invalid member overload '" .. key .. "'", 2);
		end
	
		if (type(value) == "function") then
			local submethod = methods[key];
			local method;
		
			if (forceSuper[key]) then
				local function subCall()
					error("cannot call submethod in '" .. key .. "'", 2);
				end
			
				if (submethod) then
					function method(...)
						local previous = methods.super;
						
						methods.super = subCall;
					
						value(...);
						
						methods.super = previous;
						
						submethod(...);
						return true;
					end
				else
					function method(...)
						local previous = methods.super;
						
						methods.super = subCall;
					
						value(...);
						
						methods.super = previous;
						return true;
					end
				end
			else
				function method(...)
					local previous = methods.super;
					local ret;
				
					methods.super = submethod;
				
					ret = { value(...) };
					
					methods.super = previous;
					
					return unpack(ret);
				end
			end
			
			setfenv(value, methodenv);
			
			methods[key] = method;
			return true;
		elseif (methods[key]) then
			error("'" .. key .. "' cannot overwrite method with " .. type(value), 2);
		end
		
		rawset(class, key, value);
		return true;
	end
	
	meta.__index = methods;
	
	-- Make sure this stays a class
	meta.__metatable = meta;
	
	setmetatable(class, meta);
	
	-- Every class is destroyable
	function class.destroy()
		meta.__metatable = nil;
	
		setmetatable(class, {});
		
		forceSuper = nil;
		methodenv = nil;
		meta = nil;
		classmeta = nil;
		class = nil;
	end
	
	return class, methodenv;
end

function createDXElement(elementType, parent)
	local element, methodenv = createClass({
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		visible = true
	},
	{
		mouseenter = true,
		mousemove = true,
		mouseclick = true,
		mouseleave = true,
		focus = true,
		blur = true
	});
	local events = {};
	local children = {};
	local target = false;
	local updateTarget = false;
	local alwaysOnTop = false;
	local hackStatic = false;
	local changed = true;
	local eventTable = {};
	local eventMeta = {};
	local previousGUIState = false;
	local captiveMode = true;
	local drawingOrder = {};
	local childAPI;
	
	if (parent) and not (isDXElement(parent)) then 
		return false;
	elseif (dxRoot) then
		parent = dxRoot;
	end
	
	function element.getType()
		return elementType;
	end
	
	function element.setCaptiveMode(enabled)
		captiveMode = enabled;
		return true;
	end
	
	function element.isCaptiveMode()
		return captiveMode;
	end
	
	function element.setPosition(posX, posY)
		x, y = posX, posY;
		
		if not (alwaysOnTop) then return true; end;
		
		guiSetPosition(hackStatic, posX, posY, false);
		return true;
	end
	
	function element.getAbsolutePosition()
		if (captiveMode) then
			local offX, offY = parent.getPosition();
			
			return x + offX, y + offY;
		end
		
		return x, y;
	end
	
	function element.getPosition()
		return x, y;
	end
	
	function element.setSize(w, h)
		width, height = w, h;
		
		-- Make sure we update the target later, since caching slows down alot
		updateTarget = true;
		
		if not (alwaysOnTop) then return true; end;
		
		guiSetSize(hackStatic, w, h, false);
		return true;
	end
	
	function element.getSize()
		return width, height;
	end
	
	function element.setWidth(w)
		setSize(w, height);
		return true;
	end
	
	function element.setHeight(h)
		setSize(width, h);
		return true;
	end
	
	function element.isInArea(posX, posY)
		if (captiveMode) and not (parent.isInArea(posX, posY)) then return false; end;
	
		local x, y = getAbsolutePosition();
	
		return (posX >= x) and (posY >= y) and (posX <= x + width) and (posY <= y + height);
	end
	
	function element.isInLocalArea(posX, posY)
		return (posX >= x) and (posY >= y) and (posX <= x + width) and (posY <= y + height);
	end
	
	function element.isHit(offX, offY)
		return true;
	end
	
	function element.setVisible(show)
		local m,n;
	
		if (visible == show) then return false; end;
		
		if not (show) then
			if not (triggerEvent("onHide")) then return false; end;
			
			visible = false;
			
			for m,n in ipairs(children) do
				if (n.visible) then
					n.hide();
				end
			end
			
			element.hide();
			return true;
		elseif not (triggerEvent("onShow")) then return false; end;
		
		visible = true;
		
		for m,n in ipairs(children) do
			if (n.visible) then
				n.show();
			end
		end
		
		element.show();
		
		update();
		return true;
	end
	
	function element.setChildModes(modes)
		local m,n;
		
		for m,n in pairs(modes) do
			childModes[m] = n;
		end
		
		return true;
	end
	
	function element.getChildMode(type)
		return childModes[type] or false;
	end
	
	local function cleanupStates()
		if (element == mouseElement) then
			mouseElement.triggerEvent("onMouseLeave");
			
			mouseElement = false;
			
			element.mouseleave();
		end
		
		if (element == activeElement) then
			activeElement.triggerEvent("onBlur");
			
			activeElement = false;
			
			element.blur();
		end
		
		return true;
	end
	
	function element.show()
		if (alwaysOnTop) then
			guiSetVisible(hackStatic, true);
		end
		
		return true;
	end
	
	function element.hide()
		if (alwaysOnTop) then
			guiSetVisible(hackStatic, false);
		end
		
		-- Terminate sessions, i.e. mouse focus
		cleanupStates();
		return true;
	end
	
	function element.isVisible()
		if not (parent.isVisible()) then return false; end;
		
		return visible;
	end
	
	function element.getVisible()
		return visible;
	end
	
	function element.addEvent(name)
		local m,n;
	
		if (events[name]) then return true; end;
	
		local event = {
			handlers = {}
		};
		
		events[name] = event;
		
		for m,n in ipairs(children) do
			n.addEvent(name);
		end
		
		return true;
	end

	function element.addEventHandler(name, handler, propagate)
		local event = events[name];
		
		if not (event) or not (handler) then return false; end;
		
		if (propagate == nil) then
			propagate = true;
		end
		
		table.insert(event.handlers, {
			handler = handler,
			propagate = propagate
		});
		return true;
	end
	
	-- Set up a private event namespace 
	function eventMeta.__index()
		return false;
	end
	
	function eventMeta.__newindex(t, key, value)
		if not (type(key) == "string") then
			error("event namespace requires string type keys", 2);
		end
		
		if not (type(value) == "function") then
			error("event namespace requires function handlers", 2);
		end
		
		setfenv(value, methodenv);
		
		element.addEventHandler(key, value, false);
		return true;
	end
	
	eventMeta.__metatable = eventMeta;
	
	setmetatable(eventTable, eventMeta);
	
	element.events = eventTable;
	
	function element.executeEventHandlers(name, ...)
		local event = events[name];
		local m,n;
		
		if not (event) then return false; end;
		
		for m,n in ipairs(event.handlers) do
			if (n.propagate) or (source == element) then
				if (n.handler(...) == false) then
					return false;
				end
			end
		end
		
		return true;
	end
	
	function element.triggerEvent(name, ...)
		local previous = source;
		local ret;
	
		-- Preserve the previous source, while setting it to the current element
		_G.source = element;
		
		if not (element.executeEventHandlers(name, ...)) then
			_G.source = previous;
			return false;
		end
		
		if not (parent) then
			_G.source = previous;
			return true;
		end
		
		ret = parent.executeEventHandlers(name, ...);
		
		_G.source = previous;
		return ret;
	end
	
	function element.setChild(child)
		local m,n;
		local childAPI = {};
		local alwaysOnTop = false;
	
		-- Add events to it
		for m,n in pairs(events) do
			child.addEvent(m);
		end
		
		function childAPI.setAlwaysOnTop(enabled)
			if (alwaysOnTop == enabled) then return false; end;
			
			if (enabled) then
				table.delete(drawingOrder, child);
				
				table.insert(alwaysOnTopElements, child);
			
				alwaysOnTop = true;
				return true;
			end
			
			table.delete(alwaysOnTopElements, child);
			
			table.insert(drawingOrder, child);
			
			alwaysOnTop = false;
			return true;
		end
		
		function childAPI.putToFront()
			if (alwaysOnTop) then
				table.delete(alwaysOnTopElements, child);
				
				table.insert(alwaysOnTopElements, child);
				return true;
			end
		
			table.delete(drawingOrder, child);
			
			table.insert(drawingOrder, child);
			return true;
		end
		
		function childAPI.putToBack()
			if (alwaysOnTop) then
				table.delete(alwaysOnTopElements, child);
				
				table.insert(alwaysOnTopElements, 1, child);
				return true;
			end
		
			table.delete(drawingOrder, child);
			
			table.insert(drawingOrder, 1, child);
			return true;
		end
		
		function child.events.onDestruction()
			childAPI.kill();
			return true;
		end
		
		function childAPI.kill()
			child.setAlwaysOnTop(false);
			
			table.delete(drawingOrder, child);
			
			table.delete(children, child);
			return true;
		end
		
		table.insert(drawingOrder, child);
	
		table.insert(children, child);
		return childAPI;
	end
	
	function element.getChildren()
		return children;
	end
	
	function element.moveToBack()
		if (activeElement == element) then
			triggerEvent("onBlur");
			
			activeElement = false;
			
			blur();
		end
		
		childAPI.putToBack();
		return true;
	end
	
	function element.giveFocus()
		if (activeElement == element) then return true; end;
	
		if not (triggerEvent("onFocus")) then return false; end;
		
		if (activeElement) then
			local active = activeElement;
		
			activeElement.triggerEvent("onBlur");
			
			activeElement = false;
			
			active.blur();
		end
	
		activeElement = element;
		
		focus();
		return true;
	end
	
	function element.moveToFront()
		giveFocus();
		
		childAPI.putToFront();
		return true;
	end
	
	function element.setAlwaysOnTop(enabled)
		if (alwaysOnTop == enabled) then return false; end;
		
		childAPI.setAlwaysOnTop(enabled);
	
		if (enabled) then
			alwaysOnTop = true;
		
			hackStatic = guiCreateStaticImage(x, y, math.max(1, width), math.max(1, height), "pixel.png", false);
			
			guiSetProperty(hackStatic, "AlwaysOnTop", "True");
			return true;
		end
		
		alwaysOnTop = false;
		
		destroyElement(hackStatic);
		return true;
	end
	
	function element.getAlwaysOnTop()
		return alwaysOnTop;
	end
	
	function element.focus()
		previousGUIState = guiGetInputMode();
		
		guiSetInputEnabled(acceptInput());
		return true;
	end
	
	function element.blur()
		guiSetInputMode(previousGUIState);
		return true;
	end
	
	addEventHandler("onClientGUIPropertyChanged", guiRoot, function(name, value)
			if not (name == "inputMode") then return true; end;
			if not (element == activeElement) then return true; end;
			
			previousGUIState = value;
			
			cancelEvent();
			return false;
		end
	);
	
	function element.isActive()
		return activeElement == element;
	end
	
	function element.getElementAtOffset(offX, offY)
		local n = #drawingOrder;
		
		while not (n == 0) do
			local element = drawingOrder[n];
		
			if (element.isVisible()) and (element.isInLocalArea(offX, offY)) then return element; end;
			
			n = n - 1;
		end
		
		return false;
	end
	
	function element.handleMouseClick(button, x, y)
		local mouse = getElementAtOffset(x, y);
		
		if not (mouse) then
			if not (activeElement == element) then
				moveToFront();
			end
			
			if not (triggerEvent("onClick", "left", true, x, y)) then return true; end;
			
			return mouseclick(button, true, x, y);
		elseif (mouse == activeElement) then
			local posX, posY = activeElement.getPosition();
			
			return activeElement.handleMouseClick(button, x - posX, y - posY);
		end
		
		local posX, posY = mouse.getPosition();
		
		return mouse.handleMouseClick(button, x - posX, y - posY);
	end
	
	function element.handleMouseMove(offX, offY)
		local mouse = getElementAtOffset(offX, offY);
		
		if not (mouse) then
			if not (mouseElement == element) then
				if (mouseElement) then
					mouseElement.triggerEvent("onMouseLeave");
					
					mouseElement.mouseleave();
				end
				
				mouseElement = element;
			end
			
			triggerEvent("onMouseEnter");
			mouseenter();
			
			triggerEvent("onMouseMove", offX, offY);
			return mousemove(offX, offY);
		end
		
		local posX, posY = mouse.getPosition();
		
		return mouse.handleMouseMove(offX - posX, offY - posY);
	end
	
	function element.mouseclick(button, state, offX, offY)
		return true;
	end
	
	function element.isMouseFocused()
		return mouseElement == element;
	end
	
	function element.mouseenter()
		return true;
	end
	
	function element.mousemove(offX, offY)
		return true;
	end
	
	function element.mouseleave()
		return true;
	end
	
	function element.acceptInput()
		return false;
	end
	
	function element.keyInput(button, state)
		return true;
	end
	
	function element.input(char)
		return true;
	end
	
	function element.update()
		if (captiveMode) then
			parent.update();
		end
	
		changed = true;
		return true;
	end
	
	function element.destroyRenderTarget()
		if not (target) then return false; end;
		
		destroyElement(target);
		
		target = false;
		return true;
	end
	
	function element.ready()
		if not (isVisible()) then return false; end;
	
		return not (target == false);
	end
	
	function element.preRender()
		if (updateTarget) then
			destroyRenderTarget();
			
			target = dxCreateRenderTarget(width, height, false);
			
			assert(target, "render target creation failed");
			
			update();
			
			updateTarget = false;
		end
		
		if not (changed) then return false; end;
		
		dxSetRenderTarget(target);
		return true;
	end
	
	function element.render()
		local m,n;
	
		changed = false;
		
		for m,n in ipairs(drawingOrder) do
			if (n.visible) then
				if (n.preRender()) then
					n.render();
				end
				
				-- Set correct render target
				dxSetRenderTarget(n.isCaptiveMode() and target or nil);
				
				n.present();
			end
		end
		
		triggerEvent("onRender");
		return true;
	end
	
	function element.present()
		local x, y = getPosition();
	
		dxDrawImage(x, y, width, height, target);
		
		triggerEvent("onPresent", false, x, y);
		return true;
	end
	
	function element.presentAbsolute()
		local x, y = getAbsolutePosition();
		
		-- Make sure we target the screen
		dxSetRenderTarget();
		
		dxDrawImage(x, y, width, height, target, 0, 0, 0, tocolor(255, 255, 255, 255), true);
		
		triggerEvent("onPresent", true, x, y);
		return true;
	end
	
	function element.resetRenderTarget()
		dxSetRenderTarget(target);
		return true;
	end
	
	local function restore()
		element.update();
		return true;
	end
	
	function element.destroy()
		removeEventHandler("onClientRestore", root, restore);
		element.triggerEvent("onDestruction");
		
		-- Destroy all children, too
		for m,n in ipairs(children) do
			n.destroy();
		end
		
		-- Make sure we dont conflict with active states
		cleanupStates();
	
		elements[element] = nil;
		return true;
	end
	
	addEventHandler("onClientRestore", root, restore);
	
	if (parent) then
		childAPI = parent.setChild(element);
	end
	
	-- Trigger creation event
	element.triggerEvent("onCreation");
	
	elements[element] = element;
	return element;
end

function isDXElement(element)
	return not (elements[element] == nil);
end

-- Create root
dxRoot = createDXElement("root");

-- Specialize the root instance
function dxRoot.isVisible()
	return visible;
end

function dxRoot.ready()
	return false;
end

function dxRoot.isHit()
	return false;
end

function dxRoot.preRender()
	return false;
end

function dxRoot.present()
	local m,n;
	
	-- We render the alwaysOnTop elements here!
	for m,n in ipairs(alwaysOnTopElements) do
		if (n.visible) then
			if (n.preRender()) then
				n.render();
			end
			
			-- Render on screen
			n.presentAbsolute();
		end
	end
	
	triggerEvent("onPresent", false, 0, 0);
	return true;
end

function dxRoot.presentAbsolute()
	triggerEvent("onPresent", true, 0, 0);
	return true;
end

function dxRoot.mouseclick()
	return false;
end

function dxRoot.mousemove()
	return false;
end

function dxRoot.update()
	return true;
end

function dxRoot.isInArea()
	return true;
end

function dxRoot.moveToFront()
	if (activeElement) then
		activeElement.triggerEvent("onBlur");
		
		activeElement.blur();
	end

	activeElement = dxRoot;
	
	triggerEvent("onFocus");
	
	focus();
	return true;
end

function dxRoot.moveToBack()
	return false;
end

function dxRoot.getAbsolutePosition()
	return 0, 0;
end

dxRoot.addEvent("onCreation");
dxRoot.addEvent("onShow");
dxRoot.addEvent("onHide");
dxRoot.addEvent("onFocus");
dxRoot.addEvent("onBlur");
dxRoot.addEvent("onClick");
dxRoot.addEvent("onMouseEnter");
dxRoot.addEvent("onMouseLeave");
dxRoot.addEvent("onMouseMove");
dxRoot.addEvent("onKeyInput");
dxRoot.addEvent("onInput");
dxRoot.addEvent("onFrame");
dxRoot.addEvent("onRender");
dxRoot.addEvent("onPresent");
dxRoot.addEvent("onDestruction");

-- Callback to render the dx elements, for better control
function renderDXElements()
	dxRoot.render();
	
	-- Other stuff
	dxRoot.present();
	
	-- Restore render target to default
	dxSetRenderTarget();
end

function getTopElementAtPosition(offX, offY)
	local n = #alwaysOnTopElements;
	
	while not (n == 0) do
		local element = alwaysOnTopElements[n];
	
		if (element.isVisible()) and (element.isInArea(offX, offY)) then return element; end;
		
		n = n - 1;
	end
	
	return false;
end

function handleDXMouseClick(button, state, x, y)
	if not (state) then
		if not (activeElement) then return false; end;
		
		local posX, posY = activeElement.getAbsolutePosition();
		local offX, offY = x - posX, y - posY;
		
		if not (activeElement.triggerEvent("onClick", button, false, offX, offY)) then return true; end;
		
		return activeElement.mouseclick(button, false, offX, offY);
	end
	
	local mouse = getTopElementAtPosition(x, y);
	
	if (mouse) then
		local posX, posY = mouse.getAbsolutePosition();
	
		mouse.moveToFront();
		
		return mouse.handleMouseClick(button, x - posX, y - posY);
	end
	
	if (guiGetAtPosition(x, y)) then
		if (activeElement) then
			local element = activeElement;
		
			activeElement.triggerEvent("onBlur");
			
			activeElement = false;
			
			element.blur();
		end
		
		return false;
	end

	return dxRoot.handleMouseClick(button, x, y);
end

function handleDXMouseMove(x, y)
	local mouse = getTopElementAtPosition(x, y);
	
	if (mouse) then
		local posX, posY = mouse.getAbsolutePosition();
	
		return mouse.handleMouseMove(x - posX, y - posY);
	end
	
	if (guiGetAtPosition(x, y)) then
		if (mouseElement) then
			mouseElement.triggerEvent("onMouseLeave");
			
			mouseElement.mouseleave();
			
			mouseElement = false;
		end
		
		return false;
	end
	
	return dxRoot.handleMouseMove(x, y);
end

function handleDXKeyInput(button, down, isInput)
	if (isMTAWindowActive()) or not (activeElement) or not (activeElement.triggerEvent("onKeyInput", button, down, isInput)) then return false; end;

	activeElement.keyInput(button, down, isInput);
	return true;
end

function handleDXInput(char)
	if (isMTAWindowActive()) or not (activeElement) or not (activeElement.triggerEvent("onInput", char)) then return false; end;
	
	activeElement.input(char);
	return true;
end
