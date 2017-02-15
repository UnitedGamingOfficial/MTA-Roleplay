function createDutyColShape(posX, posY, posZ, size, interior, dimension) 
    tempShape = createColSphere(posX, posY, posZ, size)
    --exports.pool:allocateElement(tempShape)
    setElementDimension(tempShape, dimension)
    setElementInterior(tempShape, interior)
    return tempShape
end

local policeColShapes = { }

--table.insert(policeColShapes, createDutyColShape(272.53515625, 118.1806640625, 1005.2736816406, 3, 10, 1) ) -- SFPD Duty Room
--table.insert(policeColShapes, createDutyColShape(296.84765625, 80.65234375, 1007.1624755859, 5, 1, 598) ) -- SFPD Duty Room
--table.insert(policeColShapes, createDutyColShape(1564.2412109375, -1669.1396484375, 62.832809448242, 3, 1, 57) )
--table.insert(policeColShapes, createDutyColShape(222.8974609375, 185.3447265625, 1003.03125, 5, 1, 3) )
table.insert(policeColShapes, createDutyColShape(272.6767578125, 118.3876953125, 1004.6171875, 3, 10, 1158) ) -- SFPD Duty Room #1
table.insert(policeColShapes, createDutyColShape(2717.5625, -1481.015625, 1152.2132568359, 2, 55, 788) ) -- SFPD-DB Duty Room #1
table.insert(policeColShapes, createDutyColShape(2717.5625, -1483.8896484375, 1152.2203369141, 2, 55, 788) ) -- SFPD-DB Duty Room #2


local swatVehicles = { [427] = true }

local lsesColShapes = { }
table.insert(lsesColShapes, createDutyColShape(257.712890625, 77.0732421875, 1003.640625, 5, 6, 9) ) -- All Saints General Hospital Room
table.insert(lsesColShapes, createDutyColShape(254.626953125, 77.21875, 1003.640625, 5, 6, 9) ) -- FD Interior

local courtColShapes = { }
table.insert(courtColShapes, createDutyColShape(343.2958984375, 194.7607421875, 1014.5885620117, 5, 3, 100) ) -- Court weapon room

local hexColShapes = { }
--table.insert(hexColShapes, createDutyColShape(347.4033203125, 161.93359375, 1014.1875, 8, 3, 86) ) -- LST&R
table.insert(hexColShapes, createDutyColShape(1343.779296875, 1440.70703125, 10.877201080322, 5, 1, 86) ) -- LST&R Custom Int

local lsiaColShapes = { }
table.insert(lsiaColShapes, createDutyColShape(255.736328125, 76.53125, 1003.640625, 3, 6, 1636)) -- SFIA

local saspColShapes = { }
table.insert(saspColShapes, createDutyColShape(400.4248046875, 61.6728515625, 1085.859375, 5, 3, 63))
table.insert(saspColShapes, createDutyColShape(400.2666015625, 64.8779296875, 1085.859375, 5, 3, 63))
table.insert(saspColShapes, createDutyColShape(403.375, 65.0361328125, 1085.859375, 3, 5, 63))
table.insert(saspColShapes, createDutyColShape(403.5048828125, 60.4462890625, 1085.859375, 5, 3, 63))

factionDuty = {
    { 
        factionID = 1,
        
        packages = {
            {
                packageName = 'SFPD || Non-Command',
                grantID = 1,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            }, 
            
            {
                packageName = 'SFPD || Command (Sgt+)',
                grantID = 2,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },

            {
                packageName = 'SFPD || Command (Lt+)',
                grantID = 3,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282, 288 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },  			
            
            {
                packageName = 'SFPD || High Command (Cmdr+)', --DB
                grantID = 4,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282, 288, 283 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },  
                
            {
                packageName = 'SFPD || Cadet Duty',
                grantID = 11,
                forceSkinChange = true,
                skins = { 71, 211 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 50, false }, -- Nightstick
                    { -24, 35, false }, -- MPW/Deagle
                    { -41, 1200, false }, -- Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
					{ 71, 50, false }, -- Notepad
					{ -100, 100, false }, -- Kevlar
                }
            },
			
            {
                packageName = 'SFPD || Student Duty',
                grantID = 12,
                forceSkinChange = true,
				skins = { 71, 211 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
					{ -24, 50, false }, -- MPW/Deagle
					{ -3, 50, false }, -- Nightstick
                    { -41, 1200, false }, -- Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 71, 50, false }, -- Notepad
                }
            },
			
            {
                packageName = 'SFPD || Internal Affairs Duty',
                grantID = 13,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
					{ 
                }
            },			
				},
			
 --[[           {
                packageName = 'SFPD - DoC Duty',
                grantID = 6,
                forceSkinChange = true,
				skins = { 282 },
                colShape = policeColShapes,
                items = {
					{ -3, 50, false }, -- Nightstick
                    { 45, 2, false }, -- Handcuffs
                    { -41, 1200, false }, -- Pepperspray
					{ 126, 1, false }, -- Duty belt
					{ -100, 60, false }, -- Kevlar
                }
            },				
        }]]--
		
		{
             packageName = 'SFPD || SWAT Duty',
             grantID = 15,
             forceSkinChange = true,
             skins = { 285, 211, 265, 266, 267, 280, 281, 284 },
             colShape = policeColShapes,
             vehicle = swatVehicles,
             items = {
				{ 126, 1, false }, -- Duty belt
                 { -24, 50, false }, -- MPW/Deagle
                 { -3, 1, false }, -- Nitestick
                 { -27, 20, false }, -- Shotgun
				{ -25, 20, 1 }, --SPAZ
                 { -29, 100, false }, -- MP5
                 { -31, 200, false }, -- M4
                 { -34, 10, false }, -- Sniper
				{ -33, 10, 1 }, -- Country Rifle
                 { -17, 2, false }, -- Tear Gas
                 { -100, 100, false }, -- Kevlar
                 { 26, 1, false }, -- Gas Mask
                 { 27, 1, false }, -- Flashbang
                 { 27, 1, false }, -- Flashbang
                 { 113, 5, false }, -- Pack of glowsticks
                 { 45, 1, false }, -- Handcuffs
				{ 137, 1, false }, -- Snake Cam
				{ 53, 1, 1 }, -- Breathalizer
				{ 71, 50, false }, -- Notepad
             }
         }, 
            {
                packageName = 'SFPD || Detective Duty',
                grantID = 16,
                forceSkinChange = false,
				skins = { 285, 211, 265, 266, 267, 280, 281, 284 },
                colShape = policeColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -22, 50, false }, -- Colt-45
					{ -24, 50, false }, -- MPW/Deagle
					{ -29, 100, false }, -- MP5
                    { -43, 250, false }, -- Digital camera
                    { 45, 1, false }, -- Handcuffs
                    { 71, 50, false }, -- Notepad
					{ -100, 50, false }, -- Kevlar
                }
            },  
		},
    },
	{
	factionID = 15,
        
        packages = {
            {
                packageName = 'SFIA Employee',
                grantID = 8,
                forceSkinChange = false,
                skins = { 17, 120, 147, 93, 211, 61 },
                colShape = lsiaColShapes,
                items = {
					{ 71, 125, false }, -- Notebook (100 pages)
					--{ -100, 50, false }, -- Kevlar (50%)

                }
            }, 
			
			{
                packageName = 'Trainee Security Officer',
                grantID = 11,
                forceSkinChange = true,
                skins = { 71, 93, 211 },
                colShape = lsiaColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
					{ -3, 50, false }, -- Nightstick
                    { -41, 1500, false }, -- Spraycan/Pepperspray
					{ 45, 2, false }, -- Handcuffs
					{ 71, 100, false }, -- Notebook (125 pages)
					{ -100, 50, false }, -- Kevlar (50%)
					--{ -24, 35, false }, -- MPW/Deagle
                    --{ -25, 20, false }, -- Shotgun
                }
            }, 
			
			{
                packageName = 'Security Officer',
                grantID = 13,
                forceSkinChange = true,
                skins = { 71, 163, 164, 165, 166, 93, 211 },
                colShape = lsiaColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
					{ -3, 50, false }, -- Nightstick
                    { -41, 1500, false }, -- Spraycan/Pepperspray
					{ 45, 2, false }, -- Handcuffs
					{ 71, 100, false }, -- Notebook (100 pages)
					{ -100, 50, false }, -- Kevlar (50%)
				   --{ -24, 35, false }, -- MPW/Deagle
                   --{ -29, 60, false }, -- MP5
                }
            }, 
			
			--[[{
                packageName = 'SFIA - 4) FFA Tactical Response Agent',
                grantID = 14,
                forceSkinChange = true,
                skins = { 285, 286 },
                colShape = lsiaColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
					{ -3, 50, false }, -- Nightstick
                    { -41, 1500, false }, -- Spraycan/Pepperspray
					{ 45, 2, false }, -- Handcuffs
					{ 71, 125, false }, -- Notebook (125 pages)
					{ -100, 100, false }, -- Kevlar (100%)
					{ -24, 35, false }, -- MPW/Deagle
                    { -31, 150, false }, -- M4
					{ -34, 20, false }, -- Sniper
                }
            },]]
        },
	},
    { 
        factionID = 2,
        
        packages = {
            {
                packageName = 'LSES - Medical',
                grantID = 5,
                forceSkinChange = true,
                skins = { 274, 275, 276 },
                colShape = lsesColShapes,
                items = {
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 70, 5, false } -- First Aid Kit
					}
			},
            {
                packageName = 'LSES - Firefighter',
                grantID = 6,
                forceSkinChange = true,
                colShape = lsesColShapes,
                skins = { 277, 278, 279 },
                items = {
                    { -42, 3000, 1 }, -- Fire Extinguisher
                    { -9, 1, 2 }, -- Chainsaw
                    { 26, 1, false }, -- Gas mask
                    { 70, 2, false }, -- First Aid Kit
                }
            },
            {
                packageName = 'LSES - Fire Inspector',
                grantID = 7,
                forceSkinChange = false,
                colShape = lsesColShapes,
                items = {
                    { -43, 100, false }, -- Digital camera
                    { 71, 25, false }, -- Notepad
                }
            },
            {
                packageName = 'LSES - Search & Rescue',
                grantID = 8,
                forceSkinChange = true,
                colShape = lsesColShapes,
                skins = { 277, 278, 279 },
                items = {
                    { -9, 1, false }, -- Chainsaw
                    { 26, 1, false }, -- Gas mask
                    { 70, 5, false }, -- First Aid Kit
                    { 120, 1, false }, -- Scuba Gear
                    { 113, 5, false }, -- Pack of glowsticks
                    { -42, 3000, 1 }, -- Fire Extinguisher
                }
            },  
        }
    },
    { 
        factionID = 4,
        
        packages = {
            {
                packageName = 'LST&R - Mechanic',
                grantID = 9,
                forceSkinChange = true,
                colShape = hexColShapes,
                skins = { 50, 305 },
                items = {
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 26, 1, false }, -- Gas mask
                    { 70, 2, false }, -- First Aid Kit
                }
            },--[[
            {
                packageName = 'LST&R - WRT',
                grantID = 10,
                forceSkinChange = true,
                colShape = hexColShapes,
                skins = { 50, 305 },
                items = {
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 26, 1, false }, -- Gas mask
                    { 70, 2, false }, -- First Aid Kit
                }
            }, 
            {
                packageName = 'LST&R - OSRT',
                grantID = 10,
                forceSkinChange = true,
                colShape = hexColShapes,
                skins = { 50, 305 },
                items = {
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 26, 1, false }, -- Gas mask
                    { 70, 2, false }, -- First Aid Kit
                }
            }, 	]]		
        }
    },
    { 
        factionID = 3,
        
        packages = {
            {
                packageName = 'GoLS - FCoSA Marshalls',
                grantID = 10,
                forceSkinChange = false,
                skins = { 286 },
                colShape = courtColShapes,
                items = {
                    { -100, 49, false }, -- 49% Armour
                    { 45, 1, false }, -- Handcuffs
                    { -23, 17, 1 }, -- Deagle
                }
            },
            {
                packageName = 'GoLS - FCoSA Fugitive Task Force',
                grantID = 13,
                forceSkinChange = true,
                skins = { 286 },
                colShape = courtColShapes,
                items = {
                    { -100, 49, false }, -- 49% Armour
                    { 45, 1, false }, -- Handcuffs
                    { -23, 17, 1 }, -- Deagle
                    { -29, 100, false }, -- MP5
                }
            },  
            {
                packageName = 'GoLS - FCoSA Security',
                grantID = 14,
                forceSkinChange = true,
                skins = { 286 },
                colShape = courtColShapes,
                items = {
                    { -100, 49, false }, -- 49% Armour
                    { 45, 1, false }, -- Handcuffs
                    { -23, 17, 1 }, -- Deagle
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                }
            }               
        }
    },
	{ 
        factionID = 45,
        
        packages = {
            {
                packageName = 'SASP || Non-Command',
                grantID = 1,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 288, 282, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            }, 
            
            {
                packageName = 'SASP || Command (Sgt+)',
                grantID = 2,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282, 288, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },

            {
                packageName = 'SASP || Command (Lt+)',
                grantID = 3,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282, 288, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },  			
            
            {
                packageName = 'SASP || High Command (Cmdr+)', --DB
                grantID = 4,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 282, 288, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
                }
            },  
                
            {
                packageName = 'SASP || Cadet Duty',
                grantID = 11,
                forceSkinChange = true,
                skins = { 71, 211, 288, 282, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 50, false }, -- Nightstick
                    { -24, 35, false }, -- MPW/Deagle
                    { -41, 1200, false }, -- Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
					{ 71, 50, false }, -- Notepad
					{ -100, 100, false }, -- Kevlar
                }
            },
			
            {
                packageName = 'SASP || Student Duty',
                grantID = 12,
                forceSkinChange = true,
				skins = { 71, 211, 288, 282, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
					{ -24, 50, false }, -- MPW/Deagle
					{ -3, 50, false }, -- Nightstick
                    { -41, 1200, false }, -- Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 71, 50, false }, -- Notepad
                }
            },
			
            {
                packageName = 'SASP || Internal Affairs Duty',
                grantID = 13,
                forceSkinChange = true,
                skins = { 211, 265, 266, 267, 280, 281, 284, 288, 282, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -3, 1, false }, -- Nitestick
                    { -24, 50, false }, -- MPW/Deagle
                    { -25, 20, false }, -- Shotgun
                    { -41, 1500, false }, -- Spraycan/Pepperspray
                    { 45, 1, false }, -- Handcuffs
                    { 45, 1, false }, -- Handcuffs
                    { -100, 100, false }, -- Kevlar
                    { 53, 1, false }, -- Breathalizer
					{ 71, 50, false }, -- Notepad
					{ 
                }
            },			
				},
			
 --[[           {
                packageName = 'SFPD - DoC Duty',
                grantID = 6,
                forceSkinChange = true,
				skins = { 282 },
                colShape = policeColShapes,
                items = {
					{ -3, 50, false }, -- Nightstick
                    { 45, 2, false }, -- Handcuffs
                    { -41, 1200, false }, -- Pepperspray
					{ 126, 1, false }, -- Duty belt
					{ -100, 60, false }, -- Kevlar
                }
            },				
        }]]--
		
		{
             packageName = 'SASP || STOP Duty',
             grantID = 15,
             forceSkinChange = true,
             skins = { 285, 211, 265, 266, 267, 280, 281, 284, 288, 282, 283 },
             colShape = saspColShapes,
             vehicle = swatVehicles,
             items = {
				{ 126, 1, false }, -- Duty belt
                 { -24, 50, false }, -- MPW/Deagle
                 { -3, 1, false }, -- Nitestick
                 { -27, 20, false }, -- Shotgun
				{ -25, 20, 1 }, --SPAZ
                 { -29, 100, false }, -- MP5
                 { -31, 200, false }, -- M4
                 { -34, 10, false }, -- Sniper
				{ -33, 10, 1 }, -- Country Rifle
                 { -17, 2, false }, -- Tear Gas
                 { -100, 100, false }, -- Kevlar
                 { 26, 1, false }, -- Gas Mask
                 { 27, 1, false }, -- Flashbang
                 { 27, 1, false }, -- Flashbang
                 { 113, 5, false }, -- Pack of glowsticks
                 { 45, 1, false }, -- Handcuffs
				{ 137, 1, false }, -- Snake Cam
				{ 53, 1, 1 }, -- Breathalizer
				{ 71, 50, false }, -- Notepad
             }
         }, 
            {
                packageName = 'SASP || BCI Duty',
                grantID = 16,
                forceSkinChange = false,
				skins = { 285, 211, 265, 266, 267, 280, 281, 284, 288, 282, 283 },
                colShape = saspColShapes,
                items = {
					{ 126, 1, false }, -- Duty belt
                    { -22, 50, false }, -- Colt-45
					{ -24, 50, false }, -- MPW/Deagle
					{ -29, 100, false }, -- MP5
                    { -43, 250, false }, -- Digital camera
                    { 45, 1, false }, -- Handcuffs
                    { 71, 50, false }, -- Notepad
					{ -100, 50, false }, -- Kevlar
                }
            },  
		},
    },
} 

-- -------------------------- --
-- General checking functions --
-- -------------------------- --

function isPlayerInFaction(targetPlayer, factionID)
    return tonumber( getElementData(targetPlayer, "faction") ) == factionID
end

function fetchAvailablePackages( targetPlayer )
    local availablePackages = { }
    
    for index, factionTable in ipairs ( factionDuty ) do    -- Loop all the factions
        if isPlayerInFaction(targetPlayer, factionTable["factionID"]) then
            for index, factionPackage in ipairs ( factionTable["packages"] ) do -- Loop all the faction packages
                local found = false
                for index, packageColShape in ipairs ( factionPackage["colShape"] ) do -- Loop all the colshapes of the factionpackage
                    if isElementWithinColShape( targetPlayer, packageColShape ) then
                        found = true
                        break  -- We found this package already, no need to search the other colshapes
                    end
                end
                
                if factionPackage.vehicle and getPedOccupiedVehicle( targetPlayer ) and factionPackage.vehicle[ getElementModel( getPedOccupiedVehicle( targetPlayer ) ) ] then
                    found = true
                end
                
                if found and canPlayerUseDutyPackage(targetPlayer, factionPackage) then
                    table.insert(availablePackages, factionPackage)
                end
            end
        end
    end
    
    return availablePackages
end

function fetchAllPackages( )
    local availablePackages = { }
    
    for index, factionTable in ipairs ( factionDuty ) do    -- Loop all the factions
        table.insert(availablePackages, factionPackage)
    end
    
    return availablePackages
end

function canPlayerUseDutyPackage(targetPlayer, factionPackage)
    local playerPackagePermission = getElementData(targetPlayer, "factionPackages")
    if playerPackagePermission then
        for index, permissionID in ipairs(playerPackagePermission) do
            if (permissionID == factionPackage["grantID"]) then
                return true
            end
        end
    end
    return false
end

function getFactionPackages( factionID )
    if not factionID or not tonumber( factionID ) then
        return factionDuty
    end
    
    for index, factionTable in ipairs ( factionDuty ) do    -- Loop all the factions
        if tonumber(factionTable["factionID"]) == tonumber( factionID ) then
            return factionTable["packages"]
        end
    end
    
    return {}   
end

addEvent("onPlayerDuty", true)