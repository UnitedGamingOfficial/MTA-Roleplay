function applyMods()
	-- Bus stops
	busStop = engineLoadTXD("ls/bustopm.txd")
	engineImportTXD(busStop, 1257)
	
	-- Retextures
	a = engineLoadTXD ( "sf/hub_sfse.txd" )
	engineImportTXD ( a, 10983 )
	
	b = engineLoadTXD ( "sf/hubhole_sfse.txd" )
	engineImportTXD ( b, 11223 )

	c = engineLoadTXD ( "sf/oldgarage_sfse.txd" )
	engineImportTXD ( c, 11387 )
	
	d = engineLoadTXD ( "sf/shops_sfse.txd" )
	engineImportTXD ( d, 10946 )

	e = engineLoadTXD ( "sf/skyscrapper_sfs.txd" )
	engineImportTXD ( e, 10948 )

	f = engineLoadTXD ( "sf/navybasefence.txd" )
	engineImportTXD ( f, 10835 )
	
	g = engineLoadTXD ( "lasxrefdockbox.txd" )
	engineImportTXD ( g, 3761 )
	
	--[[g = engineLoadTXD ( "sf/mission2_sfse.txd" )
	engineImportTXD ( g, 11005 )]]
	
	
	-- Vehicle Mods
	txd = engineLoadTXD ( "landstal.txd" )
	engineImportTXD ( txd, 400 )
	
	--[[txdtram = engineLoadTXD ( "tram.txd" )
	engineImportTXD ( txdtram, 449 )

	dfftram = engineLoadDFF ( "tram.dff" )
	engineReplaceModel ( dfftram, 449 )]]

	txd = engineLoadTXD ( "nrg500.txd" )
	engineImportTXD ( txd, 522 )
	
	txdl = engineLoadTXD ( "leviathn.txd" )
	engineImportTXD ( txdl, 417 )

	dffl = engineLoadDFF ( "leviathn.dff" )
	engineReplaceModel ( dffl, 417 )
	
	txdhdv = engineLoadTXD ( "hotdog.txd" )
	engineImportTXD ( txdhdv, 588 )
	
	dffhdv = engineLoadDFF ( "hotdog.dff" )
	engineReplaceModel ( dffhdv, 588 )
	
	txdmw = engineLoadTXD ( "mrwhoop.txd" )
	engineImportTXD ( txdmw, 423 )
	
	dffmw = engineLoadDFF ( "mrwhoop.dff" )
	engineReplaceModel ( dffmw, 423 )
	
	txdintruder = engineLoadTXD ( "intruder.txd" )
	engineImportTXD ( txdintruder, 546 )
	
	dffintruder = engineLoadDFF ( "intruder.dff" )
	engineReplaceModel ( dffintruder, 546 )
	
	txdpatriot = engineLoadTXD ( "patriot.txd" )
	engineImportTXD ( txdpatriot, 470 )
	
	dffpatriot = engineLoadDFF ( "patriot.dff" )
	engineReplaceModel ( dffpatriot, 470 )
	
	dffdft30 = engineLoadDFF ( "dft30.dff" )
	engineReplaceModel ( dffdft30, 578 )
	
	----------------
	-- Gang Tags --
	----------------
	tag3 = engineLoadTXD ( "tags/tags_larifa.txd" ) -- Crips (South)
	engineImportTXD ( tag3, 1526 )

	tag4 = engineLoadTXD ( "tags/tags_larollin.txd" ) -- Surenos/Rifa (West)
	engineImportTXD ( tag4, 1527 )

	tag5 = engineLoadTXD ( "tags/tags_laseville.txd" ) -- Nortenos (East)
	engineImportTXD ( tag5, 1528 )	

	tag8 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Bloods (East)
	engineImportTXD ( tag8, 1531 )
	
	
	-- Rim mod
	dff = engineLoadDFF ( "wheels/wheel_gn1.dff", 1082)
      engineReplaceModel ( dff, 1082)
 
      dff = engineLoadDFF ( "wheels/wheel_gn2.dff", 1085)
      engineReplaceModel ( dff, 1085)
 
      dff = engineLoadDFF ( "wheels/wheel_gn3.dff", 1096)
      engineReplaceModel ( dff, 1096)
 
      dff = engineLoadDFF ( "wheels/wheel_gn4.dff", 1097)
      engineReplaceModel ( dff, 1097)
 
      dff = engineLoadDFF ( "wheels/wheel_gn5.dff", 1098)
      engineReplaceModel ( dff, 1098)
 
      dff = engineLoadDFF ( "wheels/wheel_lr1.dff", 1077)
      engineReplaceModel ( dff, 1077)
 
      dff = engineLoadDFF ( "wheels/wheel_lr2.dff", 1083)
      engineReplaceModel ( dff, 1083)
 
      dff = engineLoadDFF ( "wheels/wheel_lr3.dff", 1078)
      engineReplaceModel ( dff, 1078)
 
      dff = engineLoadDFF ( "wheels/wheel_lr4.dff", 1076)
      engineReplaceModel ( dff, 1076)
 
      dff = engineLoadDFF ( "wheels/wheel_lr5.dff", 1084)
      engineReplaceModel ( dff, 1084)
 
      dff = engineLoadDFF ( "wheels/wheel_or1.dff", 1025)
      engineReplaceModel ( dff, 1025)
 
      dff = engineLoadDFF ( "wheels/wheel_sr1.dff", 1079)
      engineReplaceModel ( dff, 1079)
 
      dff = engineLoadDFF ( "wheels/wheel_sr2.dff", 1075)
      engineReplaceModel ( dff, 1075)
 
      dff = engineLoadDFF ( "wheels/wheel_sr3.dff", 1074)
      engineReplaceModel ( dff, 1074)
 
      dff = engineLoadDFF ( "wheels/wheel_sr4.dff", 1081)
      engineReplaceModel ( dff, 1081)
 
      dff = engineLoadDFF ( "wheels/wheel_sr5.dff", 1080)
      engineReplaceModel ( dff, 1080)
 
      dff = engineLoadDFF ( "wheels/wheel_sr6.dff", 1073)
      engineReplaceModel ( dff, 1073)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)