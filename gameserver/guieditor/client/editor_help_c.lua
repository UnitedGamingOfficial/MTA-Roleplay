--[[ GUI Editor - Editor Help - Client ]]--


-- help window tables
local help_descriptions = {}
-- hold the help function names and descriptions, used in onClientClick code to colour and navigate the help window
local help_functions = {}
local help_labels = {}


addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),function()

	-- help window
	help_window = guiCreateWindow(sx-415,sy-355,410,350,"Click an option to view details  -  /guihelp or click here to hide",false)
	guiWindowSetSizable(help_window,false)
	help_description_label = guiCreateLabel(185,20,215,325,"If the mouse cursor is not showing, type /guiedit to show the mouse and navigate this window.",false,help_window)
	guiLabelSetHorizontalAlign(help_description_label,"center",true)
	guiLabelSetVerticalAlign(help_description_label,"center")
	help_list_scrollpane = guiCreateScrollPane(5,20,170,325,false,help_window,false)
	guiSetVisible(help_window,false)	
	
	addEventHandler("onClientGUIClick",help_window,GUIEditorHelp,false)
	
	setElementData(help_description_label,"cant_highlight",true)
end)


function LoadHelpDescription(index)
	if index then
		guiSetText(help_description_label,help_descriptions[index]:gsub("\\n","\n"))
	else
		guiSetText(help_description_label,"")
	end
end

function GUIEditorHelp(topic)
	if not gui_editor then
		outputChatBox("Type /guieditor to begin using the GUI Editor")
		return
	end
	-- first time, load all the data. dont want to load onClientResourceStart as it can take a while and is a pain if you arent actually going to be using it
	if not help_labels[1] then
		local help_documentation = xmlLoadFile("help_documentation.xml")
		if help_documentation then
			local options = xmlFindChild (help_documentation,"options",0)
			if options then
				-- load all the data into help_functions and help_descriptions
				local count = 0
				while xmlFindChild(options,"option",count)~=false do
					local option = xmlFindChild(options,"option",count)
					help_functions[count+1] = xmlNodeGetAttribute(option,"name")
					help_descriptions[count+1] = xmlNodeGetAttribute(option,"description")
					
					-- create a label for each option
					help_labels[count+1] = guiCreateLabel(5,5+(20*count),190,20,help_functions[count+1],false,help_list_scrollpane)
					guiLabelSetVerticalAlign(help_labels[count+1],"center")	
					setElementData(help_labels[count+1],"cant_highlight",true)
					
					count = count + 1				
				end
			end
		end
	end

	if topic then
		for i=1, #help_functions do
			guiLabelSetColor(help_labels[i],255,255,255)
			if guiGetText(help_labels[i]) == topic then
				guiLabelSetColor(help_labels[i],0,200,50)
				LoadHelpDescription(i)
			end
		end	
	end
	
	guiSetVisible(help_window,not guiGetVisible(help_window))
	if guiGetVisible(help_window) then guiBringToFront(help_window) end
end

addCommandHandler("guihelp",GUIEditorHelp)
addCommandHandler("guiedhelp",GUIEditorHelp)
addCommandHandler("guieditorhelp",GUIEditorHelp)


function ClickedHelpMenu()
	for i=1, #help_functions do
		guiLabelSetColor(help_labels[i],255,255,255)
		if current_cursor_element==help_labels[i] then
			guiLabelSetColor(help_labels[i],0,200,50)
			LoadHelpDescription(i)
		end
	end	
end
