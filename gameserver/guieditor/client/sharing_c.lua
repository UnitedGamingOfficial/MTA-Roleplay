--[[ GUI Editor - Sharing - Client ]]--


local share = {}

addEventHandler("onClientResourceStart",resourceRoot,function()
	setElementData(local_player,"guieditor_share",nil)
end)


function createShareGUI()
	share.window = guiCreateWindow(sx-196,2,194,424,"Share GUI",false)
	guiWindowSetSizable(share.window,false)
	share.gridlist = guiCreateGridList(12,140,170,220,false,share.window)
	guiGridListSetSelectionMode(share.gridlist,2)
	guiGridListAddColumn(share.gridlist,"Players",0.8)
	share.button_share = guiCreateButton(12,366,71,23,"Share",false,share.window)
	share.button_exit = guiCreateButton(111,393,71,21,"Exit",false,share.window)
	share.label = guiCreateLabel(12,25,170,115,"Select a player and click 'Share' to share your GUI with them.\n\nPlayers highlighted in blue are sharing their GUI with you.\n\nYou are sharing your GUI with players highlighted red.\n\nPlayers highlighted in green are both.",false,share.window)
	guiLabelSetColor(share.label,255,255,255)
	guiLabelSetVerticalAlign(share.label,"top")
	guiLabelSetHorizontalAlign(share.label,"center",true)
	guiSetFont(share.label,"default-small")
	share.button_view = guiCreateButton(111,366,71,23,"View",false,share.window)
	share.button_help = guiCreateButton(12,393,71,23,"Help",false,share.window)
	
	setElementData(share.label,"cant_highlight",true)
	
	guiSetVisible(share.window,true)
	guiBringToFront(share.window)
	
	addEventHandler("onClientGUIClick",share.button_help,function(button,state)
		if button == "left" and state == "up" then
			GUIEditorHelp("Share")
		end
	end,false)
	
	addEventHandler("onClientGUIClick",share.button_exit,hideShareGUI,false)
	
	addEventHandler("onClientGUIClick",share.button_share,function(button,state)
		if button == "left" and state == "up" then
			local sharing = getElementData(local_player,"guieditor_share")
			local row,col = guiGridListGetSelectedItem(share.gridlist)
			
			if row and col and row ~= -1 and col ~= -1 then
				local player = getPlayerFromName(guiGridListGetItemText(share.gridlist,row,col))
				
				if player == local_player then outputChatBox("You can't share with yourself!") return end
				
				if sharing then
					local exist
					for k,p in ipairs(sharing) do
						if p == local_player then 
						--	outputChatBox("You are already sharing with that player!") 
						--	return 
							exist = true
						end
					end
										
					if not exist then
						table.insert(sharing,player)
					end							
					
					PrintAllGUI("sharing")
				else
					sharing = {player}
					PrintAllGUI("sharing")
				end
				
				setElementData(local_player,"guieditor_share",sharing)
				
				refreshShareList()
			end
		end
	end,false)
	
	addEventHandler("onClientGUIClick",share.button_view,function(button,state)
		if button == "left" and state == "up" then
			local row,col = guiGridListGetSelectedItem(share.gridlist)
			
			if row and col and row ~= -1 and col ~= -1 then
				local player = getPlayerFromName(guiGridListGetItemText(share.gridlist,row,col))
				
				if player then
					if player == local_player then return outputChatBox("You can't view yourself!") end
				
					local sharing = getElementData(player,"guieditor_share")
					
					if sharing then
						for k,p in ipairs(sharing) do
							if p == local_player then 
								triggerServerEvent("requestPlayerGUI",local_player,player)
								break
							end
						end					
					else
						outputChatBox("That player is not sharing with you!")
					end
				end
			end
		end
	end,false)
end


function hideShareGUI()
	guiSetVisible(share.window,false)
end


function shareCode()
	if not share.window then
		createShareGUI()
	else		
		guiSetVisible(share.window,true)
		guiBringToFront(share.window)
	end
	
	refreshShareList()
end


function refreshShareList()
	guiGridListClear(share.gridlist)

	local myshares = getElementData(local_player,"guieditor_share")
	
	for i,v in ipairs(getElementsByType("player")) do		
		local visible,sharing = false,false
			
		if getElementData(v,"guieditor_share") then
			for k,p in ipairs(getElementData(v,"guieditor_share")) do
				if p == local_player then visible = true break end
			end
		end
		
		if myshares then
			for k,p in ipairs(myshares) do
				if p == v then sharing = true break end
			end
		end
			
		local row = guiGridListAddRow(share.gridlist)
		guiGridListSetItemText(share.gridlist,row,1,getPlayerName(v),false,false)
			
		if guiGridListSetItemColor then
			if visible and not sharing then
				guiGridListSetItemColor(share.gridlist,row,1,0,0,200,255)
			elseif not visible and sharing then
				guiGridListSetItemColor(share.gridlist,row,1,200,0,0,255)
			elseif visible and sharing then
				guiGridListSetItemColor(share.gridlist,row,1,0,200,0,255)
			end
		end
	end
end


addEvent("receiveSharedCode",true)
addEventHandler("receiveSharedCode",root,function(code)
	outputChatBox("Loaded shared code.")
	--loadstring(code)()
	loadCodeString(code)
end)


addEventHandler("onClientElementDataChange",root,function(data,value)
	if data == "guieditor_share" then
		refreshShareList()
	end
end)
