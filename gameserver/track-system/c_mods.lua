function replaceModel()
	--Driving School Building
   local dff = engineLoadDFF("mods/driv.dff", 11083 )
   engineReplaceModel(dff, 11083)
   local col = engineLoadCOL ( "mods/driv.col")
   engineReplaceCOL ( col, 11083 )
   
   --Straight Piece
   local txd = engineLoadTXD ( "mods/track.txd")
   engineImportTXD ( txd, 2053 )
   local dff = engineLoadDFF("mods/straight.dff", 2053 )
   engineReplaceModel(dff, 2053)
   local col = engineLoadCOL ( "mods/straight.col")
   engineReplaceCOL ( col, 2053 )
   
   --90 Piece
   local txd = engineLoadTXD ( "mods/track.txd")
   engineImportTXD ( txd, 2052 )
   local dff = engineLoadDFF("mods/90.dff", 2052 )
   engineReplaceModel(dff, 2052)
   local col = engineLoadCOL ( "mods/90.col")
   engineReplaceCOL ( col, 2052 )
   
   --180 Piece
   local txd = engineLoadTXD ( "mods/track.txd")
   engineImportTXD ( txd, 2054 )
   local dff = engineLoadDFF("mods/180.dff", 2054 )
   engineReplaceModel(dff, 2054)
   local col = engineLoadCOL ( "mods/180.col")
   engineReplaceCOL ( col, 2054 )
   
   engineSetModelLODDistance ( 2052, 1000 )
   engineSetModelLODDistance ( 2053, 1000 )
   engineSetModelLODDistance ( 2054, 1000 )
 end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()),
     function()
         replaceModel()
         setTimer (replaceModel, 1000, 1)
end
)