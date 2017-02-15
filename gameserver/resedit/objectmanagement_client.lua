-- Optimizations
local string = string;
local math = math;
local table = table;
local strsub = string.sub;
local strbyte = string.byte;
local strchar = string.char;
local strlen = string.len;
local strfind = string.find;
local strrep = string.rep;
local ipairs = ipairs;
local pairs = pairs;

addEvent("onElementEditStart", true);
addEvent("onElementPositionUpdate", true);
addEvent("onElementRotationUpdate", true);
addEvent("onElementEditEnd", true);
local bObjectEdit=false;
local pEditObject=false;
local bSelecting=false;
local bObjectIsMoving=false;
local objX,objY,objZ;
local editSessions={};

-- Globals
keyInfo = {};

local pObjectInfo=false;

function canConfigureObject(element)
    if (getElementType(element)=="vehicle") then
        return true;
    end
    return false;
end

function showObjectGUI(bShow)
    if (bShow == true) then
        if not (pObjectInfo) then
            local screenWidth, screenHeight = guiGetScreenSize();
            local guiW,guiH=300,240;
			
			pObjectInfo = {};
			
			local window = guiCreateWindow(screenWidth - guiW, screenHeight * 0.3, guiW, guiH, "Object Info", false);
            guiWindowSetSizable(window, false);
            guiWindowSetMovable(window, false);
			pObjectInfo.window = window;
			
            guiCreateLabel(10, 25, 50, 14, "Element:", false, window);
            local pType = guiCreateEdit(60, 25, guiW-65, 18, "", false, window);
            guiEditSetReadOnly(pType, true);
            pObjectInfo.type = pType;
			
            guiCreateLabel(10, 45, 90, 14, "Resource Name:", false, window);
            local pResName = guiCreateEdit(100, 45, guiW-105, 18, "", false, window);
            guiEditSetReadOnly(pResName, true);
			pObjectInfo.resourceName = pResName;
            
			-- Position
            guiCreateLabel(20, 70, 20, 14, "X:", false, window);
            local pPosX = guiCreateEdit(40, 70, 65, 18, "", false, window);
            pObjectInfo.posX = pPosX;
			
            guiCreateLabel(110, 70, 20, 14, "Y:", false, window);
            local pPosY = guiCreateEdit(130, 70, 65, 18, "", false, window);
			pObjectInfo.posY = pPosY;
			
            guiCreateLabel(200, 70, 20, 14, "Z:", false, window);
            local pPosZ = guiCreateEdit(220, 70, 65, 18, "", false, window);
            pObjectInfo.posZ = pPosZ;
			
            local pSavePos = guiCreateButton(guiW/4+10, 90, guiW/2-10, 18, "Save Position", false, window);
            pObjectInfo.savePosition = pSavePos;
            
            addEventHandler("onClientGUIClick", pSavePos, function(button, state, x, y)
                    
                end, false
            );
            
			-- Rotation
            guiCreateLabel(20, 115, 20, 14, "RX:", false, window);
            local pRotX = guiCreateEdit(40, 115, 65, 18, "", false, window);
            pObjectInfo.rotX = pRotX;
			
            guiCreateLabel(110, 115, 20, 14, "RY:", false, window);
            local pRotY = guiCreateEdit(130, 115, 65, 18, "", false, window);
            pObjectInfo.rotY = pRotY;
			
            guiCreateLabel(200, 115, 20, 14, "RZ:", false, window);
            local pRotZ = guiCreateEdit(220, 115, 65, 18, "", false, window);
            pObjectInfo.rotZ = pRotZ;
			
            local pSaveRot = guiCreateButton(guiW/4+10, 135, guiW/2-10, 18, "Save Rotation", false, window);
            pObjectInfo.saveRotation = pSaveRot;
            
            addEventHandler("onClientGUIClick", pSaveRot, function(button, state, x, y)
                    
                end, false
            );
            
			-- World
            guiCreateLabel(10, 160, 60, 14, "Interior:", false, window);
            local pInterior = guiCreateEdit(60, 160, 45, 18, "", false, window);
            pObjectInfo.interior = pInterior;
			
            guiCreateLabel(110, 160, 65, 14, "Dimension:", false, window);
            local pDimension = guiCreateEdit(175, 160, 60, 18, "", false, window);
            pObjectInfo.dimension = pDimension;
			
            local pSetOrigin = guiCreateButton(235, 160, 60, 20, "Set", false,window);
            
            addEventHandler("onClientGUIClick", pSetOrigin, function(button, state, x, y)
                    
                end, false
            );
            
            local pConfig = guiCreateButton(10, 190, guiW/2-5, 20, "Configure", false, window);
            
            addEventHandler("onClientGUIClick", pConfig, function(button, state, x, y)
                    
                end, false
            );
            
            local pDestroy = guiCreateButton(10+guiW/2-5, 190, guiW/2-5, 20, "Destroy", false, window);
            pObjectInfo.destroy = pDestroy;
			
            addEventHandler("onClientGUIClick", pDestroy, function(button, state, x, y)
                    triggerServerEvent("onClientRequestElementDestroy", pEditObject);
                end, false
            );
            
            local pHeal = guiCreateButton(10, 210, guiW/2-5, 20, "Repair", false, window);
            pObjectInfo.restore = pHeal;
            
            addEventHandler("onClientGUIClick", pHeal, function(button, state, x, y)
                    triggerServerEvent("onElementRepair", pEditObject);
                end, false
            );
            
            local pClose = guiCreateButton(10+guiW/2-5, 210, guiW/2-5, 20, "Close", false, window);
            
            addEventHandler("onClientGUIClick", pClose, function(button, state, x, y)
                    triggerServerEvent("onClientRequestEditEnd", pEditObject);
                end, false
            );
        else
            guiSetVisible(pObjectInfo.window, true);
            guiBringToFront(pObjectInfo.window);
        end
		
        bObjectEdit = true;
    else
        if (pObjectInfo) then
            guiSetVisible(pObjectInfo.window, false);
        end
		
        showCursor(false);
        bObjectEdit = false;
    end
end

addEventHandler("onClientClick", getRootElement(), function(button, state, x, y, posX, posY, posZ, element)
        -- Check whether it is selecting object to edit
        if (bSelecting) then
            if not (element) then return false; end;
            if not (state=="down") then return false; end;
            
            -- Request edit
            triggerServerEvent("onClientRequestElementEdit", element);
            outputDebugString("Requesting object edit...");
        elseif (bObjectEdit) then
            if (state=="down") and (element==pEditObject) then
				if (guiGetAtPosition(x, y)) then return true; end;
			
                outputDebugString("Moving element");
                bObjectIsMoving=true;
            elseif (bObjectIsMoving) then
                outputDebugString("Stopping movement");
                bObjectIsMoving=false;
            end
        end
    end
);

bindKey("lctrl", "both", function(button, state)
        if not (access) then return false; end;
        if not (access.account.editor.objectManagement) then return false; end;
        
        if (isScriptEditShowing==true) then return false; end;
        
        if (state=="down") then
            if (bObjectEdit) then return false; end;
            
            bSelecting=true;
			
            showCursor(true);
        else
            bSelecting=false;
			
            if not (bObjectEdit) then
                showCursor(false);
            end
        end
    end
);

addEventHandler("onElementEditStart", getRootElement(), function(player, res, bMap)
        outputDebugString(getPlayerName(player).." edits an element");
        
        editSessions[player]={};
		
        local pEdit=editSessions[player];
        pEdit.element=source;
        pEdit.posX, pEdit.posY, pEdit.posZ = getElementPosition(source);
        pEdit.rotX, pEdit.rotY, pEdit.rotZ = getElementRotation(source);
        
        if not (player == getLocalPlayer()) then return true; end;
        
        showObjectGUI(true);
        pEditObject=source;
        curSelectRadius=100;
        
		-- Update
        guiSetText(pObjectInfo.type, getElementType(source));
        guiSetText(pObjectInfo.resourceName, res);
		
		guiSetText(pObjectInfo.posX, tostring(pEdit.posX));
		guiSetText(pObjectInfo.posY, tostring(pEdit.posY));
		guiSetText(pObjectInfo.posZ, tostring(pEdit.posZ));
		guiSetText(pObjectInfo.rotX, tostring(pEdit.rotX));
		guiSetText(pObjectInfo.rotY, tostring(pEdit.rotY));
		guiSetText(pObjectInfo.rotZ, tostring(pEdit.rotZ));
        
		guiSetEnabled(pObjectInfo.savePosition, bMap);
		guiSetEnabled(pObjectInfo.saveRotation, bMap);
		
		guiSetEnabled(pObjectInfo.restore, getElementType(source) == "vehicle");
    end
);

addEventHandler("onElementPositionUpdate", getRootElement(), function(posX, posY, posZ)
        local m,n;
        
        for m,n in pairs(editSessions) do
            if (n.element == source) then
                n.posX, n.posY, n.posZ = posX, posY, posZ;
				
				if not (m == getLocalPlayer()) then return true; end;
				
				-- Update the GUI
				guiSetText(pObjectInfo.posX, tostring(posX));
				guiSetText(pObjectInfo.posY, tostring(posY));
				guiSetText(pObjectInfo.posZ, tostring(posZ));
            end
        end
    end
);

addEventHandler("onElementRotationUpdate", getRootElement(), function(rotX, rotY, rotZ)
        local m,n;
        
        for m,n in pairs(editSessions) do
            if (n.element == source) then
                n.rotX, n.rotY, n.rotZ = rotX, rotY, rotZ;
				
				if not (m == getLocalPlayer()) then return true; end;
				
				-- Update the GUI
				guiSetText(pObjectInfo.rotX, tostring(rotX));
				guiSetText(pObjectInfo.rotY, tostring(rotY));
				guiSetText(pObjectInfo.rotZ, tostring(rotZ));
            end
        end
    end
);

addEventHandler("onClientRender", getRootElement(), function(a, b, posX, posY, posZ)
        if not (bObjectEdit) then return false; end;
        if not (bObjectIsMoving) then return false; end;
        
        posX, posY, posZ = getCameraMatrix();
        newX, newY, newZ = getWorldFromScreenPosition(mouseX, mouseY, curSelectRadius);
        
        local bHit, endX, endY, endZ, element, nX, nY, nZ = processLineOfSight(posX, posY, posZ, newX, newY, newZ, true, false, false, true, false, false, false, false);
        
		if not (bHit) then
			endX,endY,endZ=newX,newY,newZ;
			--endZ=getGroundPosition(newX, newY, newZ);
			posX=endX;
			posY=endY;
			posZ=endZ;
		else
			local matrix=getElementMatrix(pEditObject);
			local rotX, rotY, rotZ = getElementRotation(pEditObject);
			
			posX = endX + nX * getElementDistanceFromCentreOfMassToBaseOfModel(pEditObject);
			posY = endY + nY * getElementDistanceFromCentreOfMassToBaseOfModel(pEditObject);
			posZ = endZ + nZ * getElementDistanceFromCentreOfMassToBaseOfModel(pEditObject);
			
			-- I suck at geometry, help me please :(
			-- The rotation I want is the rotation to correctly put the editing object on a surface
			--[[
			-- Rotate the object accordingly
			rotX = math.deg(math.asin(nZ));
			--rotY = math.deg(math.acos(nX));
			rotZ = math.deg(math.atan2(nX, nY));
			setElementRotation(pEditObject, rotX, rotY, rotZ);
			triggerServerEvent("onElementRotationUpdate", pEditObject, rotX, rotY, rotZ);]]
		end
        
        setElementPosition(pEditObject, posX, posY, posZ);
        triggerServerEvent("onElementPositionUpdate", pEditObject, posX, posY, posZ);
    end
);

addEventHandler("onElementEditEnd", getRootElement(), function(player)
        outputDebugString(getPlayerName(player) .. " ended edit session");
        
        editSessions[player]=nil;

        if not (player == getLocalPlayer()) then return false; end;
		
        showObjectGUI(false);
    end
);

addEventHandler("onClientElementDestroy", getRootElement(), function()
        local m,n;
        
        for m,n in pairs(editSessions) do
            if (n.element == source) then
                triggerEvent("onElementEditEnd", n.element, m);
                break;
            end
        end
    end
);

addEventHandler("onClientPreRender", getRootElement(), function()
        local m,n;
        
        for m,n in pairs(editSessions) do
            setElementVelocity(n.element, 0, 0, 0);
            setElementPosition(n.element, n.posX, n.posY, n.posZ, false);
			
            if (getElementType(n.element) == "vehicle") then
                setVehicleTurnVelocity(n.element, 0, 0, 0);
            end
			
            setElementRotation(n.element, n.rotX, n.rotY, n.rotZ);
        end
    end
);