myWindow = nil

function displayPdCodes( )
      if ( myWindow == nil ) then      
      local xmlCodes = xmlLoadFile( "codes.xml" )  
	  local xmlProcedure = xmlLoadFile( "procedure.xml" )   
	  --local xmlExample = xmlLoadFile( "example.xml" )   
      myWindow = guiCreateWindow ( 0.25, 0.25, 0.5, 0.5, "Los Santos Government - Radio Codes & Procedures - V1.2", true )
      local tabPanel = guiCreateTabPanel ( 0, 0.079, 1, 1, true, myWindow ) 
	 --Response & Ten Codes
			local tabCodes = guiCreateTab( "Response & Ten Codes", tabPanel )
			local memoCodes = guiCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlCodes ), true, tabCodes )
			guiMemoSetReadOnly(memoCodes, true)
	 --Radio Procedures
			local tabProcedure = guiCreateTab( "Radio procedures", tabPanel )
			local memoProcedure = guiCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlProcedure ), true, tabProcedure )
			guiMemoSetReadOnly(memoProcedure, true)	 
      local tlBackButton = guiCreateButton(0.79, 0.05, 0.2, 0.07, "Close", true, myWindow) -- close button      
      addEventHandler("onClientGUIClick", tlBackButton, closeItemsList, false)
      showCursor( true )      
      xmlUnloadFile( xmlCodes )
	  xmlUnloadFile( xmlProcedure )
	  --xmlUnloadFile( xmlExample )
   else
      destroyElement(myWindow)
      myWindow = nil
      showCursor(false)
   end
end
addEvent("showPoliceWindow", true)
addEventHandler("showPoliceWindow", getLocalPlayer(), displayPdCodes)

function closeItemsList()
   showCursor(false)
   destroyElement(myWindow)
   tlBackButton = nil
   myWindow = nil
end