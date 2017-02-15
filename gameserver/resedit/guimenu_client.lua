-- Optimizations
local dxGetFontHeight = dxGetFontHeight;
local dxGetTextWidth = dxGetTextWidth;
local dxDrawText = dxDrawText;
local dxDrawRectangle = dxDrawRectangle;
local tocolor = tocolor;
local strlen = string.len;
local ipairs = ipairs;
local pairs = pairs;
local collectgarbage = collectgarbage;

-- Set up events
dxRoot.addEvent("onMenuHighlight");
dxRoot.addEvent("onMenuSelect");
local menus = {};

function createMenu(parent)
	local menu = createDXElement("menu", parent);
	local items = {};
	local offset = 0;
	local activeDropDown = false;
	local currentSelection = false;
	
	if not (menu) then return false; end;
	
	-- Specify the dimensions
	menu.setSize(guiGetScreenSize(), 20);
	
	local function getItemAtOffset(off)
		local m,n;
		
		if (off >= offset) then return false; end;
		
		for m,n in ipairs(items) do
			if (off < n.offset + n.width + 10) then
				return m;
			end
		end
		
		return false;
	end
	
	function menu.openDropDown(id)
		if (id < 1) or (id > #items) then return false; end;
		
		activeDropDown = items[id].dropDown;
		
		update();
		
		if not (activeDropDown.setVisible(true)) then
			activeDropDown = false;
			return false;
		end
		
		return true;
	end
	
	function menu.closeDropDown()
		if not (activeDropDown) then return true; end;
		
		activeDropDown.setVisible(false);
		
		activeDropDown = false;
		
		update();
		return true;
	end
	
	function menu.addItem(text)
		local dropDown = createDropDown(menu);
		local width = dxGetTextWidth(text);
		local x, y = menu.getPosition();
	
		table.insert(items, {
			offset = offset,
			width = width,
			text = text,
			dropDown = dropDown
		});
		
		-- Cache the dropDown
		dropDown.setVisible(false);
		dropDown.setPosition(offset, y + 20);
		
		dropDown.addEventHandler("onHide", function()
				if not (isInArea(mouseX, mouseY)) or not (getItemAtOffset(mouseX - x)) then
					currentSelection = false;
				end
		
				activeDropDown = false;
				
				update();
			end, false
		);
		
		offset = offset + width + 10;
		
		update();
		return dropDown, #items;
	end
	
	function menu.removeItem(id)
		if (id < 1) or (id > #items) then return false; end;
		
		offset = offset - dxGetTextWidth(items[id].text) - 10;
		
		table.remove(items, id);
		return true;
	end
	
	function menu.getPosition()
		if not (parent) then
			return 0, 0;
		end
		
		return guiGetPosition(parent);
	end
	
	function menu.setVisible(show)
		if not (super(show)) then return false; end;
		
		if not (show) then
			if (activeDropDown) then
				activeDropDown.setVisible(false);
				
				activeDropDown = false;
			end
		
			currentSelection = false;
		end
		
		return true;
	end
	
	function menu.render()
		local offset = 0;
		local m,n;
		
		dxDrawRectangle(0, 0, width, height, tocolor(45, 45, 45, 255));
		
		for m,n in ipairs(items) do
			if (currentSelection == m) then
				dxDrawRectangle(n.offset, 0, n.width + 10, height, tocolor(80, 200, 40, 255));
			end
			
			dxDrawText(n.text, n.offset + 5, 3, 0, 0, tocolor(255, 255, 255, 255));
		end
		
		return super();
	end
	
	function menu.isInArea(posX, posY)
		local x, y = getPosition();
	
		return (posX >= x) and (posY >= y) and (posX <= x + width) and (posY <= y + height);
	end
	
	function menu.blur()
		if (activeDropDown) then return true; end;
		
		closeDropDown();
		
		currentSelection = false;
		
		update();
		return true;
	end
	
	function menu.mouseclick(button, state, offX, offY)
		if (activeDropDown) then return true; end;
		if not (button == "left") or not (state) then return true; end;
		
		local item = getItemAtOffset(offX);
		
		if not (item) then
			closeDropDown();
			return true;
		end
		
		openDropDown(item);
		return true;
	end
	
	function menu.mouseleave()
		if not (currentSelection) or (activeDropDown) then return true; end; 
		
		currentSelection = false;
		
		update();
		return true;
	end
	
	function menu.mousemove(offX, offY)		
		local id = getItemAtOffset(offX);
		
		if not (currentSelection == id) then
			currentSelection = id;
		
			if (activeDropDown) then
				if not (id) then return true; end;
			
				local dropDown = items[id].dropDown;
				
				if not (dropDown == activeDropDown) then
					activeDropDown.setVisible(false);
				
					activeDropDown = dropDown;
					activeDropDown.setVisible(true);
				end
			end
			
			update();
		end
		
		return true;
	end
	
	function menu.destroy()
		menus[menu] = nil;
	end
	
	menus[menu] = menu;
	return menu;
end

function isMenu(element)
	return not (menus[element] == nil);
end