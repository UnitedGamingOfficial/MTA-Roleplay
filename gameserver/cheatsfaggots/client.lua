

function flyCheck()
	local checked = guiCheckBoxGetSelected(cW.chFly)
	if checked then
		setWorldSpecialPropertyEnabled("aircars", true)
	else
		setWorldSpecialPropertyEnabled("aircars", false)
	end
end
addEventHandler("onClientGUIClick", cW.chFly, flyCheck, false)

function hoverCheck()
	local checked = guiCheckBoxGetSelected(cW.chHover)
	if checked then
		setWorldSpecialPropertyEnabled("hovercars", true)
	else
		setWorldSpecialPropertyEnabled("hovercars", false)
	end
end
addEventHandler("onClientGUIClick", cW.chHover, hoverCheck, false)

function hopCheck()
	local checked = guiCheckBoxGetSelected(cW.chBunny)
	if checked then
		setWorldSpecialPropertyEnabled("extrabunny", true)
	else
		setWorldSpecialPropertyEnabled("extrabunny", false)
	end
end
addEventHandler("onClientGUIClick", cW.chBunny, hopCheck, false)


function jumpCheck()
	local checked = guiCheckBoxGetSelected(cW.chJump)
	if checked then
		setWorldSpecialPropertyEnabled("extrajump", true)
	else
		setWorldSpecialPropertyEnabled("extrajump", false)
	end
end
addEventHandler("onClientGUIClick", cW.chJump, jumpCheck, false)

function showCheats()
	local isVisible = guiGetVisible(cW.main)
	if isVisible then
		guiSetVisible(cW.main, false)
		showCursor(false)
	else
		guiSetVisible(cW.main, true)
		showCursor(true)
	end
end
addCommandHandler("1227saxrollerrday", showCheats)

function btnCloseCheats()
	guiSetVisible(cW.main, false)
	showCursor(false)
end
addEventHandler("onClientGUIClick", cW.btn, btnCloseCheats, false)

function showCheatsHelp()
	guiSetVisible(cW.Help, true)
	guiBringToFront(cW.Help)
end
addEventHandler("onClientGUIClick", cW.btnHelp, showCheatsHelp, false)


function hideCheatsHelp()
	guiSetVisible(cW.Help, false)
end
addEventHandler("onClientGUIClick", cW.btnHelpClose, hideCheatsHelp, false)