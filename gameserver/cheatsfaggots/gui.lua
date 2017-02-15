cheatshelp = xmlLoadFile("chelp.xml")
helpTxt = xmlNodeGetValue(cheatshelp)

cW = {}

cW.main = guiCreateWindow(.4, .4, .2, .2, "Cheats", true)
cW.Help = guiCreateWindow(.3, .3, .4, .4, "Cheats Help", true)
cW.chFly = guiCreateCheckBox(.3, .2, .5, .1, "Flying Cars", false, true, cW.main)
cW.chHover = guiCreateCheckBox(.3, .3325, .5, .1, "Drive On Water", false, true, cW.main)
cW.chBunny = guiCreateCheckBox(.3, .4675, .5, .1, "Bunny Hop", false, true, cW.main)
cW.chJump = guiCreateCheckBox(.3, .6, .5, .1, "Extra Jump", false, true, cW.main)
cW.btn = guiCreateButton(.5, .8, .2, .2, "Close", true, cW.main)
cW.btnHelp = guiCreateButton(.3, .8, .2, .2, "Help", true, cW.main)
cW.helpMemo = guiCreateMemo(0, .1, 1, .75, helpTxt, true, cW.Help)
cW.btnHelpClose = guiCreateButton(.4, .875, .2, .1, "Close", true, cW.Help)


guiSetVisible(cW.main, false)
guiSetVisible(cW.Help, false)
guiWindowSetSizable(cW.main, false)
guiWindowSetSizable(cW.Help, false)
guiMemoSetReadOnly(cW.helpMemo, true)
