--[[ GUI Editor - GUI Properties - Client ]]--


-- property window tables
local properties = true
local property_widgets = {}
-- used in the input box accept processing code to determine if the manually entered property is valid
property_descriptions = {}
-- used in onClientClick code to colour and navigate the property window
local widget_labels = {}
local property_labels = {}
local current_selected_widget = ""
current_selected_property = ""
-- used in right click menu selection code to indicate the element clicked (the element you are querying properties for) and whether you are getting or setting a property
property_window_purpose = ""
property_window_source = nil

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()

	-- cegui properties window
	property_window = guiCreateWindow(5,sy-445,600,440,"CEGUI Properties - click a widget or a property to select",false)
	guiWindowSetSizable(property_window,false)
	property_description_label = guiCreateLabel(386,23,206,359,"To view the description of a property, use the left panel to select a widget type and the right panel to select one of its properties.\n\nWarning: There is no filter for bad property combinations so be sure of what you are doing before accepting.",false,property_window)
	guiLabelSetVerticalAlign(property_description_label,"center")
	guiLabelSetHorizontalAlign(property_description_label,"center",true)
	property_close_button = guiCreateButton(399,382,80,20,"Close",false,property_window)
	property_accept_button = guiCreateButton(498,382,80,20,"Accept",false,property_window)
	property_manual_button = guiCreateButton(399,408,179,20,"Enter property name manually",false,property_window)
	property_widget_scrollpane = guiCreateScrollPane(9,21,170,409,false,property_window,false)
	property_properties_scrollpane = guiCreateScrollPane(182,21,200,410,false,property_window,false)
	guiSetVisible(property_window,false)
	addEventHandler("onClientGUIClick",property_close_button,CloseCEGUIProperties,false)
	addEventHandler("onClientGUIClick",property_accept_button,CEGUIPropertiesAccept,false)
	addEventHandler("onClientGUIClick",property_manual_button,CEGUIPropertiesManual,false)
	
	setElementData(property_description_label,"cant_highlight",true)
end)


function ToggleCEGUIProperties()
	if properties then
		-- first time, load all the data. dont want to load onClientResourceStart as it can take a while and is a pain if you arent actually going to be using it
		if not property_widgets["Button"] then
			outputChatBox("Loading property tables...")
			local highest, hcount = nil,0
			
			local cegui_widgets = xmlLoadFile("cegui/cegui_widgets.xml")
			if cegui_widgets then
				local widget = xmlFindChild (cegui_widgets,"widget",0)
				if widget then
					-- load all the data into property_widgets and property_descriptions
					local count = 0
					while xmlFindChild(cegui_widgets,"widget",count)~=false do
						widget = xmlFindChild(cegui_widgets,"widget",count)
						local name = xmlNodeGetAttribute(widget,"name")
						property_widgets[name] = {}
						
						-- create a label for each option
						widget_labels[count+1] = guiCreateLabel(5,5+(20*count),160,20,name,false,property_widget_scrollpane)
						guiLabelSetVerticalAlign(widget_labels[count+1],"center")	
						
						setElementData(widget_labels[count+1],"cant_highlight",true)
						
						local pcount = 0
						while xmlFindChild(widget,"property",pcount) do
							local property = xmlFindChild(widget,"property",pcount)
							property_widgets[name][pcount+1] = xmlNodeGetAttribute(property,"name")
							pcount = pcount + 1
						end
						
						if pcount > hcount then
							hcount = pcount
							highest = name
						end
						count = count + 1				
					end
				end
			end	
			
			-- use the highest property count of a single widget to create labels
			for i,v in ipairs(property_widgets[highest]) do
				property_labels[i] = guiCreateLabel(5,5+(20*(i-1)),190,20,"",false,property_properties_scrollpane)
				guiLabelSetVerticalAlign(property_labels[i],"center")
				setElementData(property_labels[i],"cant_highlight",true)
			end
			
			local cegui_descriptions = xmlLoadFile("cegui/cegui_property_descriptions.xml")
			count = 0
			
			if cegui_descriptions then
				while xmlFindChild (cegui_descriptions,"property",count) do
					local property = xmlFindChild (cegui_descriptions,"property",count)
					property_descriptions[xmlNodeGetAttribute(property,"name")] = xmlNodeGetAttribute(property,"description")
					count = count + 1
				end
			end
		end
		
		guiSetVisible(property_window,true)
		guiBringToFront(property_window)
	end
end
--[[
addCommandHandler("cegui",ToggleCEGUIProperties)
addCommandHandler("ceguiproperties",ToggleCEGUIProperties)
addCommandHandler("cegui_properties",ToggleCEGUIProperties)
addCommandHandler("ceguiprop",ToggleCEGUIProperties)
addCommandHandler("cegui_prop",ToggleCEGUIProperties)
addCommandHandler("guiproperties",ToggleCEGUIProperties)
addCommandHandler("guiprop",ToggleCEGUIProperties)]]


function PopulatePropertyList(widget)
	for i=1, #property_labels do
		guiSetText(property_labels[i],"")
	end

	for i,v in ipairs(property_widgets[widget]) do
		guiSetText(property_labels[i],property_widgets[widget][i])
	end
end


function LoadPropertyDescription(property)
	if property then
		guiSetText(property_description_label,property_descriptions[property])
	else
		guiSetText(property_description_label,"")
	end
end


function CEGUIPropertiesAccept()
	--outputChatBox(current_selected_widget .. " : "..current_selected_property)
		
	if not property_window_source then	
		outputChatBox("Invalid GUI element. (selected)")
		return
	end	
	
	if property_window_purpose == "get" then
		local result = guiGetProperty(property_window_source,current_selected_property)
		if result then
			outputChatBox(getElementType(property_window_source).." property "..current_selected_property..": "..result)
		else
			outputChatBox("Invalid property")
		end
	elseif property_window_purpose == "set" then			
		ShowInputBox(property_window_source,"set_property_value","Enter the value you want to set the property to")
	end
	
	property_window_source = nil
	guiSetVisible(property_window,false)
end


-- manually enter a property name to query against the gui element
function CEGUIPropertiesManual()
	if not property_window_source then	
		outputChatBox("Invalid GUI element. (manual)")
		return
	end	
	
	if property_window_purpose == "get" then
		ShowInputBox(property_window_source,"get_property_value","Enter the property to get the value of")
	elseif property_window_purpose == "set" then
		ShowInputBox(property_window_source,"set_property","Enter the property to set the value of")
	end
end


function CloseCEGUIProperties()
	guiSetVisible(property_window,false)
end


function ClickedPropertiesWidget()
	for i=1, #property_labels do
		guiLabelSetColor(property_labels[i],255,255,255)
	end		
	
	for i=1, #widget_labels do
		guiLabelSetColor(widget_labels[i],255,255,255)
		if current_cursor_element==widget_labels[i] then
			guiLabelSetColor(widget_labels[i],0,200,50)
			current_selected_widget = guiGetText(widget_labels[i])
			PopulatePropertyList(current_selected_widget)
			guiSetText(property_description_label,"")
			current_selected_property = ""
			for i=1, #property_labels do
				guiLabelSetColor(property_labels[i],255,255,255)
			end
		end
	end
end


function ClickedPropertiesProperty()
	for i=1, #property_labels do
		guiLabelSetColor(property_labels[i],255,255,255)
		if current_cursor_element==property_labels[i] then
			guiLabelSetColor(property_labels[i],0,200,50)
			current_selected_property = guiGetText(property_labels[i])
			LoadPropertyDescription(current_selected_property)
		end
	end		
end
