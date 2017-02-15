function replaceModel()
  txd = engineLoadTXD("weed.txd")
  engineImportTXD(txd, 2203)
  
  dff = engineLoadDFF("weed.dff", 2203)
  engineReplaceModel(dff, 2203)
  
  dff = engineReplaceCOL("plant.col", 2203)
  engineReplaceCOL(dff, 2203)
end
 addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()),
     function()
         replaceModel()
         setTimer (replaceModel, 1000, 1)
     end
)