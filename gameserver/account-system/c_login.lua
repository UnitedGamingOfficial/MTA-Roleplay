--Globals
local lUsername, tUsername, lPassword, tPassword, chkRememberLogin, bLogin, bRegister, defaultingTimer = nil
local newsTitle, newsText, newsAuthor
local loginTitleText = "UnitedGaming MTA Roleplay"
--------------------------------------------
addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		setElementDimension ( getLocalPlayer(), 0 )
		setElementInterior( getLocalPlayer(), 0 )
		--setElementPosition( getLocalPlayer(), -262, -1143, 24)
		--setCameraMatrix(-262, -1143, 24, -97, -1167, 2)
		setElementPosition( getLocalPlayer(), 1480, -1688, 13 )
		setCameraMatrix( 1480, -1773, 108, 1480, -1688, 13)
		fadeCamera(true)
		guiSetInputEnabled(true)
		clearChat()
		triggerServerEvent("onJoin", getLocalPlayer())
		--LoginScreen_openLoginScreen()
	end
);

--[[ LoginScreen_openLoginScreen( ) - Open the login screen ]]--
local wLogin, lUsername, tUsername, lPassword, tPassword, chkRememberLogin, bLogin, bRegister--[[, updateTimer]] = nil
function LoginScreen_openLoginScreen(title)
	guiSetInputEnabled(true)
	showCursor(true)
	if not title then
		local width, height = guiGetScreenSize()
		local logoW, logoH = 257, 120
		local logoPosX = width/2 - 130
		local logoPosY = height/2- 170
		iLogo = guiCreateStaticImage(logoPosX, logoPosY, logoW, logoH, "img/UGLogo.png", false)
		lUsername = guiCreateLabel(0.4110, 0.4800, 1, 0.5000, "Username", true)
			guiSetFont(lUsername, "default-bold-small")
		tUsername = guiCreateEdit(0.3680, 0.5000, 0.1300, 0.0350, "Username", true)
			guiSetFont(tUsername, "default-bold-small")
			guiEditSetMaxLength(tUsername, 32)
			addEventHandler("onClientGUIAccepted", tUsername, checkCredentials, false)
		lPassword = guiCreateLabel(0.5460, 0.4800, 1, 0.5000, "Password", true)
			guiSetFont(lPassword, "default-bold-small")
		tPassword = guiCreateEdit(0.5000, 0.5000, 0.1300, 0.0350, "Password", true)
			guiSetFont(tPassword, "default-bold-small")
			guiEditSetMasked(tPassword, true)
			guiEditSetMaxLength(tPassword, 64)
			addEventHandler("onClientGUIAccepted", tPassword, checkCredentials, false)
		chkRememberLogin = guiCreateCheckBox(0.4610, 0.5650, 0.1300, 0.0350, "Remember Me", false, true)
			guiSetFont(chkRememberLogin, "default-bold-small")
		bLogin = guiCreateButton(0.4330, 0.5400, 0.0650, 0.0300, "Login", true)
			guiSetFont(bLogin, "default-bold-small")
			addEventHandler("onClientGUIClick", bLogin, checkCredentials, false)
		bRegister = guiCreateButton(0.5000, 0.5400, 0.0650, 0.0300, "Register", true)
			guiSetFont(bRegister, "default-bold-small")
			addEventHandler("onClientGUIClick", bRegister, LoginScreen_Register, false)
			guiSetText(tUsername, tostring( loadSavedData("username", "") ))
			local tHash = tostring( loadSavedData("hashcode", "") )
			guiSetText(tPassword,  tHash)
			if #tHash > 1 then
				guiCheckBoxSetSelected(chkRememberLogin, true)
			end
		newsTitle = getElementData(getResourceRootElement(), "news:title")
		newsText = getElementData(getResourceRootElement(), "news:text")
		newsAuthor = getElementData(getResourceRootElement(), "news:sub")
		addEventHandler("onClientRender", getRootElement(), showLoginTitle)
		triggerEvent("accounts:options:settings:updated", getLocalPlayer())
	else
		loginTitleText = title
		addEventHandler("onClientRender", getRootElement(), showLoginTitle)
	end
end
addEvent("beginLogin", true)
addEventHandler("beginLogin", getRootElement(), LoginScreen_openLoginScreen)

function showLoginTitle()
	local screenX, screenY = guiGetScreenSize()
	local alphaAction = 3
	local alphaStep = 50
	local alphaAction = 3
	local alphaStep = 50
	local sWidth,sHeight = guiGetScreenSize()
	if loginTitleText == "Banned." then
		dxDrawText(loginTitleText,(700/1600)*sWidth, (350/900)*sHeight, (900/1600)*sWidth, (450/900)*sHeight, tocolor(255,0,0,255), (sWidth/1600)*2, "default-bold","center","center",false,false,false)
	else
		dxDrawText(loginTitleText,(700/1600)*sWidth, (350/900)*sHeight, (900/1600)*sWidth, (450/900)*sHeight, tocolor(255,255,255,255), (sWidth/1600)*2, "default-bold","center","center",false,false,false)
	end
	alphaStep = alphaStep + alphaAction
	if (alphaStep > 200) or (alphaStep < 50) then
		alphaAction = alphaAction - alphaAction - alphaAction
	end
	dxDrawRectangle( (10/1600)*sWidth, (17/900)*sHeight, (400/1600)*sWidth, (600/900)*sHeight, tocolor(0, 0, 0, 150))
	dxDrawText( newsTitle, (35/1600)*sWidth, (30/900)*sHeight, (375/1600)*sWidth, (550/900)*sHeight, tocolor ( 255, 255, 255, 255 ), 1.5, "default-bold" )
	dxDrawText( "     " .. newsAuthor, (80/1600)*sWidth, (60/900)*sHeight, sWidth, sHeight, tocolor ( 255, 255, 255, 255 ), 1.2, "default-bold", "left", "top", true, false )
	dxDrawText( newsText, (35/1600)*sWidth, (92/900)*sHeight, (375/1600)*sWidth, sHeight,  tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "left", "top", true, true )
end

function LoginScreen_Register()
	local username = guiGetText(tUsername)
	local password = guiGetText(tPassword)
	if (string.len(username)<3) then
		LoginScreen_showWarningMessage( "Your username must be a minimum of 3 characters!" )
	elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) or (string.find(username, " ", 0)) then
		LoginScreen_showWarningMessage("Your username cannot contain ;,@.' or space!")
	elseif (string.len(password)<6) then
	    LoginScreen_showWarningMessage("Your password is too short. \n You must enter 6 or more characters.", 255, 0, 0)
    elseif (string.len(password)>=30) then
        LoginScreen_showWarningMessage("Your password is too long. \n You must enter less than 30 characters.", 255, 0, 0)
    elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
        LoginScreen_showWarningMessage("Your password cannot contain ;,@'.", 255, 0, 0)
	else
		showChat(true)
		triggerServerEvent("accounts:register:attempt", getLocalPlayer(), username, password)
	end
end

function LoginScreen_RefreshIMG()
	currentslide =  currentslide + 1
	if currentslide > totalslides then
		currentslide = 1
	end
end

--[[ LoginScreen_closeLoginScreen() - Close the loginscreen ]]
function LoginScreen_closeLoginScreen()
	destroyElement(lUsername)
	destroyElement(tUsername)
	destroyElement(lPassword)
	destroyElement(tPassword)
	destroyElement(chkRememberLogin)
	destroyElement(bLogin)
	destroyElement(bRegister)
	destroyElement(iLogo)
	--destroyElement(wLogin)
	--killTimer(updateTimer)
	removeEventHandler( "onClientRender", getRootElement(), showLoginTitle )
end

--[[ checkCredentials() - Used to validate and send the contents of the login screen  ]]--
function checkCredentials()
	local username = guiGetText(tUsername)
	local password = guiGetText(tPassword)
	guiSetText(tPassword, "")
	appendSavedData("hashcode", "")
	if (string.len(username)<3) then
		outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
	else
		local saveInfo = guiCheckBoxGetSelected(chkRememberLogin)
		triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, saveInfo) 
					
		if (saveInfo) then
			appendSavedData("username", tostring(username))
		else
			appendSavedData("username", "")
		end
	end
end

local warningBox, warningMessage, warningOk = nil
function LoginScreen_showWarningMessage( message )

	if (isElement(warningBox)) then
		destroyElement(warningBox)
	end
	
	local x, y = guiGetScreenSize()
	warningBox = guiCreateWindow( x*.5-150, y*.5-65, 300, 120, "Attention!", false )
	guiWindowSetSizable( warningBox, false )
	warningMessage = guiCreateLabel( 40, 30, 220, 60, message, false, warningBox )
	guiLabelSetHorizontalAlign( warningMessage, "center", true )
	guiLabelSetVerticalAlign( warningMessage, "center" )
	warningOk = guiCreateButton( 130, 90, 70, 20, "Ok", false, warningBox )
	addEventHandler( "onClientGUIClick", warningOk, function() destroyElement(warningBox) end )
	guiBringToFront( warningBox )
end
addEventHandler("accounts:error:window", getRootElement(), LoginScreen_showWarningMessage)

function defaultLoginText()
	loginTitleText = "UnitedGaming MTA Roleplay"
end

addEventHandler("accounts:login:attempt", getRootElement(), 
	function (statusCode, additionalData)
		
		if (statusCode == 0) then
			LoginScreen_closeLoginScreen()
			
			if (isElement(warningBox)) then
				destroyElement(warningBox)
			end
			
			-- Succesful login
			for _, theValue in ipairs(additionalData) do
				setElementData(getLocalPlayer(), theValue[1], theValue[2], false)
			end
			
			local newAccountHash = getElementData(getLocalPlayer(), "account:newAccountHash")
			appendSavedData("hashcode", newAccountHash or "")
			
			local characterList = getElementData(getLocalPlayer(), "account:characters")
			
			if #characterList == 0 then
				newCharacter_init()
			else
				Characters_showSelection()
			end
			
		elseif (statusCode > 0) and (statusCode < 5) then
			LoginScreen_showWarningMessage( additionalData )
		elseif (statusCode == 5) then
			LoginScreen_showWarningMessage( additionalData )
			-- TODO: show make app screen?
		end
	end
)