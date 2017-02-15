myWindow = nil
pressed = false

function bindKeys()
	bindKey("F1", "down", F1RPhelp)
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function resetState()
	pressed = false
end

function F1RPhelp( key, keyState )
	if not (pressed) then
		pressed = true
		setTimer(resetState, 200, 1)
		if ( myWindow == nil ) then		
			local xmlExplained = xmlLoadFile( "help/whatisroleplaying.xml" )
			local xmlOverview = xmlLoadFile( "help/overview.xml" )
			
			myWindow = guiCreateWindow ( 0.15, 0.15, 0.7, 0.7, "UnitedGaming - F1 Help", true )
			guiWindowSetSizable(myWindow, false)
			local tabPanel = guiCreateTabPanel ( 0, 0.05, 1, 1, true, myWindow )
			
			local tabPatchNotes = guiCreateTab( "MTA Patch Notes & Information", tabPanel )
			local memoPatchNotes = guiCreateMemo (  0.02, 0.02, 0.96, 0.96, getElementData(getResourceRootElement(getResourceFromName("account-system")), "patchnotes:text") or "Error fetching patch notes...", true, tabPatchNotes ) 
			guiMemoSetReadOnly(memoPatchNotes, true)
			
			local tabRules = guiCreateTab( "Server Rules", tabPanel )
			local memoRules = guiCreateMemo (  0.02, 0.02, 0.96, 0.96, getElementData(getResourceRootElement(getResourceFromName("account-system")), "rules:text") or "Error fetching rules...", true, tabRules ) 
			guiMemoSetReadOnly(memoRules, true)
			
			local tabExplained = guiCreateTab( "Roleplay Explained", tabPanel )
			local memoExplained = guiCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlExplained ), true, tabExplained )
			guiMemoSetReadOnly(memoExplained, true)
			
			local tabOverview = guiCreateTab( "Roleplay Overview", tabPanel )
			local memoOverview = guiCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlOverview ), true, tabOverview )
			guiMemoSetReadOnly(memoOverview, true)
			
			showCursor( true )
			
			--xmlUnloadFile( xmlServerRules )
			xmlUnloadFile( xmlExplained )
			xmlUnloadFile( xmlOverview )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end