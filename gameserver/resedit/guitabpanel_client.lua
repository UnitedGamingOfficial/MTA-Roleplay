-- Optimizations
local dxGetFontHeight = dxGetFontHeight;
local dxGetTextWidth = dxGetTextWidth;
local dxDrawText = dxDrawText;
local dxDrawRectangle = dxDrawRectangle;
local tocolor = tocolor;
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

dxRoot.addEvent("onTabPanelSelect");
local tabs = {};
local panels = {};

function createTabPanel(parent)
	local panel = createDXElement("tabpanel", parent);
	local panelTabs = {};
	local charScale = 1;
	local charFont = "default";
	local fontHeight = dxGetFontHeight(charScale, charFont);
	
	if not (panel) then return false; end;
	
	local function registerTab(tab)
		table.insert(panelTabs, tab);
		
		panel.update();
		return true;
	end
	
	local function unregisterTab(tab)
		local m,n;
		
		for m,n in ipairs(panelTabs) do
			if (n == tab) then
				table.remove(panelTabs, m);
				
				panel.update();
				return true;
			end
		end
		
		return false;
	end
	
	function panel.addTab(title)
		local tab = createDXElement("tab", panel);
		local tabWidth;
		
		if not (tab) then
			error("failed to create tab in tabPanel", 2);
		end
		
		function tab.setTitle(newTitle)
			title = newTitle;
			tabWidth = dxGetTextWidth(title, charScale, charFont) + 10;
			return true;
		end
		
		function tab.getTitle()
			return title;
		end
		
		function tab.destroy()
			unregisterTab(tab);
		
			tabs[tab] = nil;
		end
		
		-- Set the title
		tab.setTitle(title);
		
		registerTab(tab);
		
		tabs[tab] = tab;
		return tab;
	end
	
	function panel.addElement(title, element)
		local tab = createDXElement("tab", panel);
		local tabWidth;
		
		if not (tab) then
			error("failed to create tab in tabPanel", 2);
		end
		
		function tab.setTitle(newTitle)
			title = newTitle;
			tabWidth = dxGetTextWidth(title, charScale, charFont) + 10;
			return true;
		end
		
		function tab.getTitle()
			return title;
		end
		
		function tab.destroy()
			unregisterTab(tab);
		
			tabs[tab] = nil;
		end
		
		-- Set the title
		tab.setTitle(title);
		
		registerTab(tab);
		
		tabs[tab] = tab;
		return tab;
	end
	
	function panel.render()
		dxDrawRectangle(0, 0, width, height, tocolor(75, 75, 115, 255));
		return super();
	end
	
	function panel.destroy()
		panels[panel] = nil;
	end
	
	panels[panel] = panel;
	return panel;
end

function isTabPanel(element)
	return not (panels[element] == nil);
end

function isTab(element)
	return not (tabs[element] == nil);
end