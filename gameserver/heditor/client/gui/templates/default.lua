guiTemplate.default = {
    window = {
        type = "window",
        pos = { 0, 0 },
        size = { 374, 513 },
        centered = true,
        sizable = false,
        movable = true,
        extraItems = {
            {
                type = "gridlist",
                pos = { 65, 54 },
                size = { 300, 435 },
                runfunction = function ( this )
                    guiMoveToBack ( this )
                end
            },
            {
                type = "line",
                pos = { 0, 32 },
                size = { 365, 15 },
                alpha = 76
            },
            {
                type = "line",
                pos = { 66, 63 },
                size = { 299, 15 },
                alpha = 76
            },
            {
                type = "line",
                pos = { 66, 378 },
                size = { 299, 15 },
                alpha = 76
            },
            {
                type = "line",
                pos = { 66, 431 },
                size = { 299, 15 },
                alpha = 76
            },
            {
                type = "line",
                pos = { 0, 32 },
                size = { 365, 15 },
                alpha = 76
            }
        }
    },

    ----------------------------------------------------------------------------------------------------

    utilbuttons = {
        handling = {
            type = "button",
            pos = { 10, 22 },
            size = { 60, 19 },
            hovercolor = { 255, 27, 224, 224 },
            items = {
                "reset",
                "save",
                "load",
                "upload",
                "download"
            }
        },
        tools = {
            type = "button",
            pos = { 75, 22 },
            size = { 60, 19 },
            hovercolor = { 255, 27, 224, 224 },
            items = {
                "import",
                "export",
                "get",
                "share"
            }
        },
        extra = {
            type = "button",
            pos = { 140, 22 },
            size = { 60, 19 },
            hovercolor = { 255, 27, 224, 224 },
            items = {
                "options",
                "administration",
                "updatelist"
            }
        },
        close = {
            type = "button",
            pos = { 345, 22 },
            size = { 20, 19 },
            hovercolor = { 255, 255, 0, 0 },
            items = nil
        }
    },

    ----------------------------------------------------------------------------------------------------
    
    menubuttons = {
        engine = {
            type = "button",
            pos = { 10, 54 },
            size = { 50, 50 },
            content = "handlingconfig",
            hovercolor = { 255, 255, 255, 128 }
        },
        body = {
            type = "button",
            pos = { 10, 109 },
            size = { 50, 50 },
            content = "handlingconfig",
            hovercolor = { 255, 255, 255, 128 }
        },
        wheels = {
            type = "button",
            pos = { 10, 164 },
            size = { 50, 50 },
            content = "handlingconfig",
            hovercolor = { 255, 255, 255, 128 }
        },
        appearance = {
            type = "button",
            pos = { 10, 219 },
            size = { 50, 50 },
            content = "submenu",
            hovercolor = { 255, 255, 255, 128 }
        },
        modelflags = {
            type = "button",
            pos = { 10, 274 },
            size = { 50, 50 },
            content = "handlingflags",
            hovercolor = { 255, 255, 255, 128 }
        },
        handlingflags = {
            type = "button",
            pos = { 10, 329 },
            size = { 50, 50 },
            content = "handlingflags",
            hovercolor = { 255, 255, 255, 128 }
        },
        dynamometer = {
            type = "button",
            pos = { 10, 384 },
            size = { 50, 50 },
            content = "submenu",
            hovercolor = { 255, 255, 255, 128 }
        },
        help = {
            type = "button",
            pos = { 10, 439 },
            size = { 50, 50 },
            content = "submenu",
            hovercolor = { 255, 255, 255, 128 }
        }
    },
    
    ----------------------------------------------------------------------------------------------------
    
    menucontents = {
        --// MULTI USAGE
        redirect_handlingconfig = {
            redirect = "THIS_IS_ONE",
            content = {
                labels = {
                    {
                        type = "label",
                        pos = { 72, 83 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 108 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 133 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 158 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 183 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 208 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 233 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 258 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 283 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 308 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 333 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    },
                    {
                        type = "label",
                        pos = { 72, 358 },
                        size = { 180, 20 },
                        hovercolor = { 255, 255, 255, 128 }
                    }
                },
                buttons = { -- Do not need a type!
                    {
                        pos = { 258, 83 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 108 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 133 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 158 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 183 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 208 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 233 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 258 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 283 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 308 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 333 },
                        size = { 100, 20 }
                    },
                    {
                        pos = { 258, 358 },
                        size = { 100, 20 }
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        redirect_handlingflags = {
            redirect = "THIS_IS_ONE",
            content = {
                checkboxes = {
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 77 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 92 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 77 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 92 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 107 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 122 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 107 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 122 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 137 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 152 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 137 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 152 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 167 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 182 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 167 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 182 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 197 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 212 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 197 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 212 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 227 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 242 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 227 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 242 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 257 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 272 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 257 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 272 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    },
                    {
                        ["1"] = {
                            type = "checkbox",
                            pos = { 72, 287 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["2"] = {
                            type = "checkbox",
                            pos = { 72, 302 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["4"] = {
                            type = "checkbox",
                            pos = { 212, 287 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        },
                        ["8"] = {
                            type = "checkbox",
                            pos = { 212, 302 },
                            size = { 135, 15 },
                            hovercolor = { 255, 255, 255, 128 }
                        }
                    }
                },
                extras = {
                }
            }
        },
        
        ------------------------------------------------------------------------------------------------

        --// MENU BUTTONS
        engine = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingconfig",
            content = {
                "numberOfGears",
                "maxVelocity",
                "engineAcceleration",
                "engineInertia",
                "driveType",
                "engineType",
                "steeringLock",
                "collisionDamageMultiplier"
            }
        },

        ------------------------------------------------------------------------------------------------

        body = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingconfig",
            content = {
                "mass",
                "turnMass",
                "dragCoeff",
                "centerOfMass",
                "percentSubmerged",
                "suspensionForceLevel",
                "suspensionDamping",
                "suspensionHighSpeedDamping",
                "suspensionUpperLimit",
                "suspensionLowerLimit",
                "suspensionAntiDiveMultiplier",
                "suspensionFrontRearBias"
            }
        },

        ------------------------------------------------------------------------------------------------

        wheels = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingconfig",
            content = {
                "tractionMultiplier",
                "tractionLoss",
                "tractionBias",
                "brakeDeceleration",
                "brakeBias"
            }
        },

        ------------------------------------------------------------------------------------------------

        appearance = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingconfig",
            content = {
                "animGroup",
                "seatOffsetDistance"
            }
        },

        ------------------------------------------------------------------------------------------------

        modelflags = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingflags",
            content = {
                "modelFlags"
            }
        },

        ------------------------------------------------------------------------------------------------

        handlingflags = {
            requirelogin = false,
            requireadmin = false,
            redirect = "handlingflags",
            content = {
                "handlingFlags"
            }
        },

        ------------------------------------------------------------------------------------------------

        dynamometer = {
            requirelogin = false,
            requireadmin = false,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        help = {
            requirelogin = false,
            requireadmin = false,
            --[[runfunction = function ( content )
                setElementParent ( content.textlabel, content.pane ) -- MEH
                guiSetSize ( content.textlabel, 290, 1000, false )
            end,]]
            content = {
                --[[pane = {
                    type = "scrollpane",
                    pos = { 73, 77 },
                    size = { 290, 300 }
                },]]
                textlabel = {
                    type = "label",
                    pos = { 73, 77 },
                    size = { 290, 200 },
                    runfunction = function ( this )
                        guiLabelSetHorizontalAlign ( this, "left", true )
                        guiSetFont ( this, "default-small" )
                    end
                },
                websitebox = {
                    type = "editbox",
                    pos = { 73, 220 },
                    size = { 290, 30 },
                    runfunction = function ( this )
                        guiSetEnabled ( this, false )
                    end
                },
                morelabel = {
                    type = "label",
                    pos = { 73, 250 },
                    size = { 290, 50 },
                    runfunction = function ( this )
                        guiLabelSetHorizontalAlign ( this, "left", true )
                    end
                }
            }
        },

        ------------------------------------------------------------------------------------------------
        
        --// UTILITY
        reset = {
            requirelogin = false,
            requireadmin = false,
            onOpen = function ( content )
                local vehicle = getPedOccupiedVehicle ( localPlayer )
                if vehicle then
                    local name = getVehicleNameFromModel ( getElementModel ( vehicle ) )
                    
                    for i=0,212 do
                        local item = guiComboBoxGetItemText ( content.combo, i )
                        if item == name then
                            guiComboBoxSetSelected ( content.combo, i )
                            return true
                        end
                    end
                end 
            end,
            content = {
                label = {
                    type = "label",
                    pos = { 72, 83 },
                    size = { 180, 20 }
                },
                combo = {
                    type = "combobox",
                    pos = { 258, 83 },
                    size = { 100, 4240 },
                    runfunction = function ( this )
                        local vehNames = {}
                        for v=400,611 do
                            local name = getVehicleNameFromModel ( v )
                            
                            table.insert ( vehNames, name )
                        end
                        
                        table.sort ( vehNames )
                        
                        for i,v in ipairs ( vehNames ) do
                            guiComboBoxAddItem ( this, v )
                        end
                    end
                },
                button = {
                    type = "button",
                    pos = { 72, 359 },
                    size = { 285, 25 },
                    events = {
                        onClick = function ( this )
                            local vehicle = getPedOccupiedVehicle ( localPlayer )
                            if vehicle then
                                local content = heditGUI.menuItems.reset.guiItems
                                local selected = guiComboBoxGetSelected ( content.combo )
                                local vehID = getVehicleModelFromName ( guiComboBoxGetItemText ( content.combo, selected ) )
                                
                                local function func ( )
                                    resetVehicleHandling ( vehicle, vehID )
                                end
                                
                                guiCreateWarningMessage ( getText ( "confirmReset" ), 2, {func} )
                            end
                        end
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        save = {
            requirelogin = false,
            requireadmin = false,
            onOpen = function ( content )
                guiGridListClear ( content.grid )

                local saves = getClientSaves ( )
                for name,info in pairs ( saves ) do
                    local row = guiGridListAddRow ( content.grid )
                    local model = getVehicleNameFromModel ( tonumber ( info.model ) )
                    guiGridListSetItemText ( content.grid, row, 1, info.name, false, false )
                    guiGridListSetItemText ( content.grid, row, 2, model, false, false )
                end

                
                
                guiSetText ( content.nameEdit, "" )
                guiSetText ( content.descriptionEdit, "" )
                
                guiBringToFront ( content.nameLabel )
                guiBringToFront ( content.descriptionLabel )
            end,
            content = {
                grid = {
                    type = "gridlist",
                    pos = { 72, 83 },
                    size = { 285, 246 },
                    runfunction = function ( this )
                        guiGridListAddColumn ( this, "Name",  0.5 )
                        guiGridListAddColumn ( this, "Model", 0.4 )
                    end,
                    events = {
                        onClick = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            local row,col = guiGridListGetSelectedItem ( this )
                            if row > -1 and col > -1 then
                                local name = string.lower ( guiGridListGetItemText ( this, row, col ) )
                                local save = getClientSaves()[name]
                                guiSetVisible ( content.nameLabel, false )
                                guiSetVisible ( content.descriptionLabel, false )
                                guiSetText ( content.nameEdit, save.name )
                                guiSetText ( content.descriptionEdit, save.description )
                                return true
                            end

                            guiSetVisible ( content.nameLabel, true )
                            guiSetVisible ( content.descriptionLabel, true )
                            guiBringToFront ( content.nameLabel )
                            guiBringToFront ( content.descriptionLabel )
                            guiSetText ( content.nameEdit, "" )
                            guiSetText ( content.descriptionEdit, "" )
                        end
                    }
                },
                nameEdit = {
                    type = "editbox",
                    pos = { 72, 334 },
                    size = { 212, 25 },
                    events = {
                        onFocus = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            guiSetVisible ( content.nameLabel, false )
                        end,
                        onBlur = function ( this )
                            if guiGetText ( this ) == "" then
                                local content = heditGUI.menuItems.save.guiItems
                                guiBringToFront ( content.nameLabel )
                                guiSetVisible ( content.nameLabel, true )
                            end
                        end
                    }
                },
                descriptionEdit = {
                    type = "editbox",
                    pos = { 72, 359 },
                    size = { 212, 25 },
                    events = {
                        onFocus = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            guiSetVisible ( content.descriptionLabel, false )
                        end,
                        onBlur = function ( this )
                            if guiGetText ( this ) == "" then
                                local content = heditGUI.menuItems.save.guiItems
                                guiBringToFront ( content.descriptionLabel )
                                guiSetVisible ( content.descriptionLabel, true )
                            end
                        end
                    }
                },
                nameLabel = {
                    type = "label",
                    pos = { 80, 334 },
                    size = { 50, 12 },
                    runfunction = function ( this )
                        guiLabelSetColor ( this, 0, 0, 0 )
                        guiSetFont ( this, "default-small" )
                    end,
                    events = {
                        onClick = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            
                            guiSetVisible ( this, false )
                            guiBringToFront ( content.nameEdit )
                            guiEditSetCaretIndex ( content.nameEdit, string.len ( guiGetText ( content.nameEdit ) ) )
                        end
                    }
                },
                descriptionLabel = {
                    type = "label",
                    pos = { 80, 359 },
                    size = { 50, 12 },
                    runfunction = function ( this )
                        guiLabelSetColor ( this, 0, 0, 0 )
                        guiSetFont ( this, "default-small" )
                    end,
                    events = {
                        onClick = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            
                            guiSetVisible ( this, false )
                            guiBringToFront ( content.descriptionEdit )
                            guiEditSetCaretIndex ( content.descriptionEdit, string.len ( guiGetText ( content.descriptionEdit ) ) )
                        end
                    }
                },
                button = {
                    type = "button",
                    pos = { 289, 334 },
                    size = { 68, 50 },
                    events = {
                        onClick = function ( this )
                            local content = heditGUI.menuItems.save.guiItems
                            local name = guiGetText ( content.nameEdit )
                            local description = guiGetText ( content.descriptionEdit )

                            if string.len ( name ) < 1 or string.len ( description ) < 1 then
                                guiCreateWarningMessage ( getText ( "invalidSave" ), 0 )
                                return false
                            end

                            local function func ( )
                                saveClientHandling ( pVehicle, name, description )
                                guiShowMenu ( previousMenu )
                                guiCreateWarningMessage ( getText ( "successSave" ), 3 )
                            end

                            if isClientHandlingExisting ( name ) then
                                guiCreateWarningMessage ( getText ( "confirmReplace" ), 2, {func} )
                                return false
                            end

                            func ( )
                        end
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        load = {
            requirelogin = false,
            requireadmin = false,
            onOpen = function ( content )
                guiGridListClear ( content.grid )

                local saves = getClientSaves ( )
                for name,info in pairs ( saves ) do
                    local row = guiGridListAddRow ( content.grid )
                    local model = getVehicleNameFromModel ( tonumber ( info.model ) )
                    guiGridListSetItemText ( content.grid, row, 1, info.name, false, false )
                    guiGridListSetItemText ( content.grid, row, 2, model, false, false )
                end
            end,
            onClose = function ( content )
                guiResetStaticInfoText ( )
            end,
            content = {
                grid = {
                    type = "gridlist",
                    pos = { 72, 83 },
                    size = { 285, 271 },
                    runfunction = function ( this )
                        guiGridListAddColumn ( this, "Name",  0.5 )
                        guiGridListAddColumn ( this, "Model", 0.4 )
                    end,
                    events = {
                        onClick = function ( this )
                            local row,col = guiGridListGetSelectedItem ( this )
                            if row ~= -1 and col ~= -1 then
                                local name = string.lower ( guiGridListGetItemText ( this, row, col ) )
                                local save = getClientSaves()[name]
                                guiSetStaticInfoText ( save.name, save.description )
                                return true
                            end
                            guiResetStaticInfoText ( )
                        end,
                        onDoubleClick = function ( this )
                            local row,col = guiGridListGetSelectedItem ( this )

                            if row ~= -1 and col ~= -1 then
                                local name = string.lower ( guiGridListGetItemText ( this, row, col ) )

                                local function func ( )
                                    if loadClientHandling ( pVehicle, name ) then
                                        guiCreateWarningMessage ( getText ( "successLoad" ), 3)
                                    end
                                end

                                if not isVehicleSaved ( pVehicle ) then
                                    guiCreateWarningMessage ( getText ( "confirmLoad" ), 2, {func} )
                                    return true
                                end

                                func ( )
                            end
                        end
                    }
                },
                button = {
                    type = "button",
                    pos = { 72, 359 },
                    size = { 285, 25 },
                    events = {
                        onClick = function ( this )
                            local content = heditGUI.menuItems.load.guiItems
                            local row,col = guiGridListGetSelectedItem ( content.grid )

                            if row ~= -1 and col ~= -1 then
                                local name = string.lower ( guiGridListGetItemText ( content.grid, row, col ) )

                                local function func ( )
                                    if loadClientHandling ( pVehicle, name ) then
                                        guiCreateWarningMessage ( getText ( "successLoad" ), 3 )
                                    end
                                end

                                if not isVehicleSaved ( pVehicle ) then
                                    guiCreateWarningMessage ( getText ( "confirmLoad" ), 2, {func} )
                                    return true
                                end

                                func ( )
                            end
                        end
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        import = {
            requirelogin = false,
            requireadmin = false,
            content = {
                methods = {
                    III = {
                        type = "checkbox",
                        pos = { 72, 83 },
                        size = { 72, 15 },
                        runfunction = function ( this )
                            guiSetEnabled ( this, false )
                        end,
                        events = {
                            onClick = function ( this )
                                for k,v in pairs ( heditGUI.menuItems.import.guiItems.methods ) do
                                    guiCheckBoxSetSelected ( v, false )
                                end
                                guiCheckBoxSetSelected ( this, true )
                            end
                        }
                    },
                    VC = {
                        type = "checkbox",
                        pos = { 144, 83 },
                        size = { 71, 15 },
                        runfunction = function ( this )
                            guiSetEnabled ( this, false )
                        end,
                        events = {
                            onClick = function ( this )
                                for k,v in pairs ( heditGUI.menuItems.import.guiItems.methods ) do
                                    guiCheckBoxSetSelected ( v, false )
                                end
                                guiCheckBoxSetSelected ( this, true )
                            end
                        }
                    },
                    SA = {
                        type = "checkbox",
                        pos = { 215, 83 },
                        size = { 71, 15 },
                        runfunction = function ( this )
                            guiSetEnabled ( this, false )
                        end,
                        events = {
                            onClick = function ( this )
                                for k,v in pairs ( heditGUI.menuItems.import.guiItems.methods ) do
                                    guiCheckBoxSetSelected ( v, false )
                                end
                                guiCheckBoxSetSelected ( this, true )
                            end
                        },
                        runfunction = function ( this )
                            guiCheckBoxSetSelected ( this, true )
                        end
                    },
                    IV = {
                        type = "checkbox",
                        pos = { 286, 83 },
                        size = { 71, 15 },
                        runfunction = function ( this )
                            guiSetEnabled ( this, false )
                        end,
                        events = {
                            onClick = function ( this )
                                for k,v in pairs ( heditGUI.menuItems.import.guiItems.methods ) do
                                    guiCheckBoxSetSelected ( v, false )
                                end
                                guiCheckBoxSetSelected ( this, true )
                            end
                        }
                    }
                },
                memo = {
                    type = "memo",
                    pos = { 72, 103 },
                    size = { 285, 251 }
                },
                button = {
                    type = "button",
                    pos = { 72, 359 },
                    size = { 285, 25 },
                    events = {
                        onClick = function ( this )
                            local vehicle = getPedOccupiedVehicle ( localPlayer )
                            if vehicle then
                                local items = heditGUI.menuItems.import.guiItems
                                local method = "SA"
                                for k,v in pairs ( items.methods ) do
                                    if guiCheckBoxGetSelected ( v ) then
                                        method = k
                                    end
                                end
                                
                                importHandling ( vehicle, guiGetText ( items.memo ), method )
                            end
                        end
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        export = {
            requirelogin = false,
            requireadmin = false,
            onOpen = function ( content )
                local vehicle = getPedOccupiedVehicle ( localPlayer )
                if vehicle then
                    local line = exportHandling ( vehicle )
                    guiSetText ( content.memo, line )
                end
            end,
            content = {
                memo = {
                    type = "memo",
                    pos = { 72, 83 },
                    size = { 285, 271 }
                },
                button = {
                    type = "button",
                    pos = { 72, 359 },
                    size = { 285, 25 },
                    events = {
                        onClick = function ( this )
                            local vehicle = getPedOccupiedVehicle ( localPlayer )
                            if vehicle then
                                setClipboard ( exportHandling ( vehicle ) )
                                guiCreateWarningMessage ( getText ( "copiedToClipboard" ), 3 )
                            end
                        end
                    }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        get = {
            requirelogin = false,
            requireadmin = false,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        share = {
            requirelogin = false,
            requireadmin = false,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        upload = {
            requirelogin = true,
            requireadmin = true,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        download = {
            requirelogin = false,
            requireadmin = false,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        resourcesave = {
            requirelogin = true,
            requireadmin = true,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        resourceload = {
            requirelogin = true,
            requireadmin = true,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        options = {
            requirelogin = false,
            requireadmin = false,
            content = {
                label_key = {
                    type = "label",
                    pos = { 72, 83 },
                    size = { 180, 25 }
                },
                combo_key = {
                    type = "combobox",
                    pos = { 258, 83 },
                    size = { 100, 25 },
                    runfunction = function ( this )
                        for i=1,#validKeys do
                            guiComboBoxAddItem ( this, validKeys[i] )
                            guicache.optionmenu_item[ validKeys[i] ] = i-1
                        end
                        guiSetSize ( this, 100, ( 20 * #validKeys ) + 25, false )
                    end
                },
                label_cmd = {
                    type = "label",
                    pos = { 72, 113 },
                    size = { 180, 25 }
                },
                edit_cmd = {
                    type = "editbox",
                    pos = { 258, 113 },
                    size = { 100, 25 }
                },
                label_template = {
                    type = "label",
                    pos = { 72, 143 },
                    size = { 180, 25 }
                },
                combo_template = {
                    type = "combobox",
                    pos = { 258, 143 },
                    size = { 100, 25 },
                    runfunction = function ( this )
                        local item = 0
                        for name in pairs ( guiTemplate ) do
                            guiComboBoxAddItem ( this, name )
                            guicache.optionmenu_item[name] = item
                            item = item + 1
                        end
                        local size = table.size ( guiLanguage )
                        size = size == 1 and 52 or ( 21 * size ) + 25
                        guiSetSize ( this, 100, size, false )
                    end
                },
                label_language = {
                    type = "label",
                    pos = { 72, 173 },
                    size = { 180, 25 }
                },
                combo_language = {
                    type = "combobox",
                    pos = { 258, 173 },
                    size = { 100, 25 },
                    runfunction = function ( this )
                        local item = 0
                        for name in pairs ( guiLanguage ) do
                            guiComboBoxAddItem ( this, name )
                            guicache.optionmenu_item[name] = item
                            item = item + 1
                        end
                        local size = table.size ( guiLanguage )
                        size = size == 1 and 52 or ( 21 * size ) + 25
                        guiSetSize ( this, 100, size, false )
                    end
                },
                label_commode = {
                    type = "label",
                    pos = { 72, 203 },
                    size = { 180, 25 }
                },
                combo_commode = {
                    type = "combobox",
                    pos = { 258, 203 },
                    size = { 100, 25 },
                    runfunction = function ( this )
                        for num,name in ipairs ( centerOfMassModes ) do
                            guiComboBoxAddItem ( this, getText ( "special", "commode", num ) )
                            guicache.optionmenu_item[name] = num-1
                        end
                        guiSetSize ( this, 100, 68, false )
                    end
                },
			   checkbox_versionreset = {
                    type = "checkbox", 
                    pos = { 72, 250 },
                    size = { 285, 25 },
					runfunction = function(this)
						guiSetText(this, string.format(getText("menuinfo", "options", "itemtext", "checkbox_versionreset"), tostring(getUserConfig(version)), tostring(HREV)))
					end
                },
				checkbox_lockwhenediting = {
					type = "checkbox",
					pos = {72, 275},
					size = { 285, 25},
					runfunction = function(this)
						guiCheckBoxSetSelected(this, tobool(getUserConfig("lockVehicleWhenEditing")))
					end
				},
                button_save = {
                    type = "button",
                    pos = { 72, 359 },
                    size = { 285, 25 },
                    events = {
                        onClick = function ( this )
                            local item = heditGUI.menuItems.options.guiItems

                            local function confirm ( )

                                local function apply ( bool )

                                    unbindKey ( getUserConfig ( "usedKey" ), "down", toggleEditor )
                                    removeCommandHandler ( getUserConfig ( "usedCommand", toggleEditor ) )
                                
                                    setUserConfig ( "usedKey", guiComboBoxGetItemText ( item.combo_key, guiComboBoxGetSelected ( item.combo_key ) ) )
                                    setUserConfig ( "usedCommand", guiGetText ( item.edit_cmd ) )
                                    setUserConfig ( "template", guiComboBoxGetItemText ( item.combo_template, guiComboBoxGetSelected ( item.combo_template ) ) )
                                    setUserConfig ( "language", guiComboBoxGetItemText ( item.combo_language, guiComboBoxGetSelected ( item.combo_language ) ) )
                                    setUserConfig ( "commode", centerOfMassModes[ guiComboBoxGetSelected ( item.combo_commode )+1 ] )
									setUserConfig("lockVehicleWhenEditing", guiCheckBoxGetSelected(item.checkbox_lockwhenediting))
									
                                    if bool then
                                        setUserConfig ( "version", tostring ( HREV ) )
                                        setUserConfig ( "minVersion", tostring ( HMREV ) )
                                    end
                                
                                    startBuilding ( )
                                
                                    toggleEditor ( )

                                end
									
                                if guiCheckBoxGetSelected ( item.checkbox_versionreset ) then
                                    guiCreateWarningMessage ( getText ( "confirmVersionReset" ), 2, {apply, true}, {apply,false} )
                                    return true
                                end
                                
                                apply ( false )

                                return true
                            end

                            guiCreateWarningMessage ( getText ( "wantTheSettings" ), 2, {confirm} )
                        end
                    }
                }
            },
            onOpen = function ( content )
                guiSetText ( content.edit_cmd, getUserConfig ( "usedCommand" ) )
                guiComboBoxSetSelected ( content.combo_key, guicache.optionmenu_item[ string.lower ( getUserConfig ( "usedKey" ) ) ] )
                guiComboBoxSetSelected ( content.combo_template, guicache.optionmenu_item[ getUserConfig ( "template" ) ] )
                guiComboBoxSetSelected ( content.combo_language, guicache.optionmenu_item[ getUserConfig ( "language" ) ] )
                guiComboBoxSetSelected ( content.combo_commode, guicache.optionmenu_item[ getUserConfig ( "commode" ) ] )
                if tonumber ( getUserConfig ( "version" ) ) <= HREV then
                    guiSetVisible ( content.checkbox_versionreset, false )
                end
            end
        },

        ------------------------------------------------------------------------------------------------

        administration = {
            requirelogin = true,
            requireadmin = true,
            disable = true,
            content = {
            }
        },

        ------------------------------------------------------------------------------------------------

        handlinglog = {
            requirelogin = false,
            requireadmin = false,
            disable = true,
            content = {
                logpane = {
                    type = "scrollpane",
                    pos = { 73, 77 },
                    size = { 290, 300 }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        updatelist = {
            requirelogin = false,
            requireadmin = false,
            content = {
                scrollpane = {
                    type = "scrollpane",
                    pos = { 73, 77 },
                    size = { 290, 300 }
                }
            }
        },

        ------------------------------------------------------------------------------------------------

        mtaversionupdate = {
            requirelogin = false,
            requireadmin = false,
            content = {
                infotext = {
                    type = "label",
                    pos = { 73, 77 },
                    size = { 285, 200 },
                    runfunction = function ( this )
                        guiLabelSetHorizontalAlign ( this, "left", true )
                    end
                },
                websitebox = {
                    type = "editbox",
                    pos = { 73, 358 },
                    size = { 285, 25 }
                }
            }
        }
    },
    
    ----------------------------------------------------------------------------------------------------
    
    specials = {
        menuheader = {
            type = "label",
            pos = { 72, 58 },
            size = { 299, 15 },
            runfunction = function ( this )
                guiSetFont ( this, "default-bold-small" )
            end
        },
        infobox = {
            header = {
                type = "label",
                pos = { 72, 393 },
                size = { 285, 16 }
            },
            text = {
                type = "label",
                pos = { 72, 409 },
                size = { 285, 30 },
                runfunction = function ( this )
                    guiSetFont ( this, "default-small" )
                    guiLabelSetHorizontalAlign ( this, "left", true )
                end
            }
        },
        minilog = {
            {
                timestamp = {
                    type = "label",
                    pos = { 72, 446 },
                    size = { 45, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                },
                text = {
                    type = "label",
                    pos = { 117, 446 },
                    size = { 230, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                }
            },
            {
                timestamp = {
                    type = "label",
                    pos = { 72, 459 },
                    size = { 45, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                },
                text = {
                    type = "label",
                    pos = { 117, 459 },
                    size = { 230, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                }
            },
            {
                timestamp = {
                    type = "label",
                    pos = { 72, 472 },
                    size = { 45, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                },
                text = {
                    type = "label",
                    pos = { 117, 472 },
                    size = { 230, 13 },
                    runfunction = function ( this )
                        guiSetFont ( this, "default-small" )
                    end
                }
            }
        },
        vehicleinfo = {
            type = "label",
            pos = { 10, 493 },
            size = { 354, 12 },
            runfunction = function ( this )
                guiSetFont ( this, "default-small" )
            end
        }
    }
}