local myadminWindow = nil
local lists = {}

function adminhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			myadminWindow = guiCreateWindow ( 0.15, 0.15, 0.7, 0.7,  "Index of admin commands (Updated on 17/5/2013) ", true)
			guiWindowSetSizable(myadminWindow, false)
			
			guiCreateLabel(0.02, 0.05, 0.6, 0.05,"Double click to copy command to clipboard.", true, myadminWindow)
			
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			
			
			local tabAdminRules = guiCreateTab( "Admin Rules & Recent Updates", tabPanel )
			local memoAdminRules = guiCreateMemo (  0.02, 0.02, 0.96, 0.96, getElementData(getResourceRootElement(getResourceFromName("account-system")), "adminrules:text") or "Error fetching...", true, tabAdminRules ) 
			guiMemoSetReadOnly(memoAdminRules, true)
			
			for level = 1, 5 do 
				local tab = guiCreateTab("Level " .. level+1, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Command", 0.2)
				--guiGridListAddColumn (lists[level], "Syntax", 0.2)
				guiGridListAddColumn (lists[level], "Explanation", 2)
			end
			
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level 1: Trial Admin
				{
					{ "/trace", "traces a phone number and tells you who owns it. Player must be online." },
					{ "/getkey",  "Spawns yourself a key of interior or vehicle that you're currently in." },
					{ "/cr",  "without specified ID will closes all your own accepted reports." },
					{ "/createemitter [Emitter Type]",  "Spawns Synced Fire/Water Emitters" },
					{ "/nearbyemitters",  "Shows all nearby Fire/Water emitters." },
					{ "/delemitters",  "Deletes all nearby Fire/Water emitters." },
					{ "/delemitter [Emitter ID]",  "Deletes a Fire/Water emitters." },
					{ "/delnearbyshops",  "Deletes nearby shops." },
					{ "/reloadshop [ID]",  "Reloads a bugged shop." },
					{ "/restoreshop [ID]",  "Restores a deleted NPC from SQL." },
					{ "/delshop [ID]",  "Deletes a NPC from game, still exist in SQL." },
					{ "/showallcustomshops",  "Shows all custom shops parameters and settings." },
					{ "/fixnearbyeleators",  "Fixes near by elevators. Players can use too." },
					--{ "/reloadallelevators",  "Reloads all elevators." },
					{ "/fixvehvis [Driver's partial Name/ID]",  "Fixes player's car's visual, leave the engine's health." },
					{ "/findvehid [Veh Name]",  "Gets car's Model ID from Name." },
					{ "/getcolor [Veh ID]",  "Gets car's color." },
					{ "/respawnint",  "Respawns all vehicle within current interior/dimension." },
					{ "/restock",  "Restocks businesses, you must be inside an interior to restock. Or use SYNTAX: /restock [Interior ID] [Amount 1~300]" },
					{ "/ojail [Exact Username] [Minutes(>=1) 999=Perm] [Reason]",  "Jails an offline player." },
					{ "/sojail [Exact Username] [Minutes(>=1) 999=Perm] [Reason]",  "Silently jails an offline player." },
					{ "/oban [Exact Username] [Time in Hours, 0 = Infinite] [Reason]",  "Bans an offline player." },
					{ "/delefromint [Interior ID, 0 = world map]",  "Deletes all elevators that connect to a specified interior." },
					{ "/delnearbye",  "Deletes all nearby elevators." },
					{ "/stopradiodistrict",  "Stops all car radios within current district." },
					{ "/adde",  "creates an elevator" },
					{ "/adde2", "Create an elevator between you and another player" },
					{ "/dele",  "deletes an elevator" },
					{ "/nearbye",  "shows nearby elevators" },
					{ "/togglee",  "enables/disables an elevator" },
					{ "/togautocheck", "Toogles auto opening player /check on /ar reports." },
					{ "/changewarnstyle",  "changes admin warning message displaying style." },
					{ "/ur", "view unanswered reports." },
					{ "/superman", "activates superman" },
					{ "/adminlounge", "Chill out in the lounge" },
					{ "/check", "retrieves specified player's information" },
					{ "/stats", "shows players vehicle id's, languages etc" },
					{ "/history",  "checks the admin history of the player, works also when offline." },
					{ "/auncuff",  "uncuffs the player" },
					{ "/pmute",  "mutes the player" },
					{ "/togooc", "Toggles OOC on/off" },
					{ "/stogooc", "Siently Toggles OOC on/off" },
					{ "/disarm",  "takes all weapon from the player" },
					{ "/freconnect", "reconnects the player" },
					{ "/giveitem",  "gives the player the specified item, see /itemlist for ids" },
					{ "/sethp",  "sets the health of the player" },
					{ "/setarmor",  "sets the armor of the player" },
					{ "/setskin",  "sets the skin of a player" },
					{ "/changename",  "changes the character name" },
					{ "/slap",  "drops the player from a height of 15" },
					{ "/recon",  "spectate a player" },
					{ "/fuckrecon",  "forces recon to stop" },
					{ "/pkick",  "kicks the player from the server" },
					{ "/pban",  "bans the player for the given time, specify 0 as hours for permanent ban" },
					{ "/unban", "unbans the player with the given character name" },
					{ "/unbanip", "unbans the specified ip" },
					{ "/unbanserial",  "unbans the specified serial" },
					{ "/gotoplace",  "teleports you to one of those 4 places" },
					{ "/jail",  "jails the player, if minutes >= 999 it's permanent" },
					{ "/unjail",  "unjails the player" },
					{ "/jailed", "shows a list of players that are in adminjail, including time left and reason" },
					{ "/goto",  "teleport to another player" },
					{ "/gethere",  "teleports the player to you" },
					{ "/sendto",  "teleports a player to another one" },
					{ "/freeze",  "freezes the player" },
					{ "/unfreeze",  "unfreezes the player" },
					{ "/mark",  "saves your current position" },
					{ "/gotomark",  "teleports to the position where you did /mark [label]" },
					{ "/adminduty",  "(un)marks you as admin on duty" },
					{ "/setmotd",  "updates the message of the day" },
					{ "/setamotd",  "updates the admin message of the day" },
					{ "/amotd",  "shows the current admin message of the day" },
					{ "/warn",  "issues a warning, player is banned when having 3 warnings" },
					{ "/showinv",  "views the inventory of the player" },
					{ "/togmytag",  "toggles your nametag on and off" },
					{ "/dropme", "drops you off at the current freecam position" },
					{ "/disappear", "/disappear", "toggles invisibility" },
					{ "/listcarprices",  "shows list with carprices in dealerships" },

					{ "/findalts",  "shows all characters the player has" },
					{ "/findip",  "shows all accounts the player has" },
					{ "/findserial",  "shows all accounts the player has" },

					{ "/setlanguage or /setlang", "adjusts the skill of a player's language, or learns it to him" },
					{ "/dellanguage",  "deletes a language from the player's knowledge" },
					{ "/aunblindfold",  "unblindfold the player" },
					{ "/agivelicense",  "gives the player a license" },
					{ "/resetcontract",  "resets the job time limit for a person." },
					{ "/ads",  "Shows all pending adverts." },
					{ "/freezead",  "Freeze an advert." },
					{ "/unfreezead",  "Unfreeze an advert" },
					{ "/deletead",  "Delete an advert" },
					{ "'P'", "Locks a world item. Make it unpickable." },
					{ "/itemprotect",  "Sets locked world item pickable by faction members." },
					{ "/addii",  "Adds an information marker" },
					{ "/delii", "Deletes an information marker" },
					{ "/nearbyii", "Shows all nearby information markers" },
					{ "/makeshop ", "Creates a NPC." },
					{ "/nearbyshops ",  "Shows all near by NPCs." },
					
					{ "/gunlist or /gunchart",  "Showing a details weapon's properties table with IDs." },
					{ "/setage ",  "Change player's age" },
					{ "/setrace ",  "Change player's race" },
					{ "/setheight  ", "Change player's height" },
					{ "/setgender  ","Change player's gender" },
					{ "/sll  ",  "Change suspension's height" },
					{ "/getsll  ",  "Gets suspension's height" },
					{ "/resetsll",  "Resets suspension's height for the current vehicle." },
					{ "/sdt  ",  "Change drivetrain type" },
					{ "/getsdt  ",  "Gets drivetrain type" },
					{ "/resetsdt",  "Resets drive type for the current vehicle." },
					{ "/skick",  "Silently kick a player" },
					{ "/sjail  ",  "Silently jail a player" },
					{ "/sjail  ",  "Silently jail a player" },
					{ "/stogooc  ",  "Silently toggle global OOC chat" },
					{ "/setjob  ", "Sets player job." },
					{ "/deljob  ",  "Deletes player job." },
					{ "/issuepilotcertificate  ", "Issues player a pilot license" },
					{ "/issuepc  ",  "Issues player a pilot license" },
					{ "/items or /itemlist ",  "Opens Item Creator." },
					{ "/settrainrailed ", "Sets a train off/on the rail." },
					{ "/settraindirection", "Sets a train direction to (counter)clockwise." },
					-- vehicle/*
					{ "/listcarprices",  "Shows an list of vehicles in car dealerships" },
					{ "/unflip",  "unflips the car" },
					{ "/unlockcivcars",  "unlocks all civilian vehicles" },
					{ "/oldcar",  "retrieves the id of the last car you drove" },
					{ "/thiscar",  "retrieves the id of your current car" },
					{ "/gotocar",  "teleports you to the car with that id" },
					{ "/getcar",  "teleports the car to you" },
					{ "/nearbyvehicles",  "shows all vehicles within a radius of 20" },
					{ "/respawnveh",  "respawns the vehicle with that id" },
					{ "/respawnall",  "respawns all vehicles" },
					{ "/respawndistrict",  "respawns all vehicles in the district you are in" },
					{ "/respawnciv",  "respawns all civilian (job) vehicles" },
					{ "/findveh",  "retrieves the model for that vehicle name" },
					{ "/fixveh",  "repairs a player's vehicle" },
					{ "/fixvehs", "repairs all vehicles" },
					{ "/fixvehis",  "fixes the vehicles look, engine may remain broken" },
					{ "/blowveh",  "blows up a players car" },
					{ "/setcarhp",  "sets the health of a car, full health is 1000." },
					{ "/fuelveh",  "refills a players vehicle" },
					{ "/fuelvehs",  "refills all vehicles" },
					{ "/setcolor",  "changes the players vehicle colors" },
					{ "/getcolor", "returns the colors of a vehicle" },
					{ "/entercar",  "puts the player into the given vehicle at either the specified seat, or if none then the first free seat" },
					
					-- interior/*
					{ "/getpos",  "outputs your current position, interior and dimension" },
					{ "/x",  "increases your x-coordinate by the given value" },
					{ "/y", "increases your y-coordinate by the given value" },
					{ "/z",  "increases your z-coordinate by the given value" },
					{ "/set*",  "sets your coordinates - available combinations: x, y, z, xyz, xy, xz, yz" },
					{ "/reloadint", "reloads an interior from the database" },
					{ "/nearbyints","shows nearby interiors" },
					{ "/setintname", "changes an interior name" },
					{ "/setfee", "sets an fee on entering the interior" },
					{ "/getintid", "Gets the interior id"},
					{ "/setdim or /setdimension", "Sets the players dimension id"},
					{ "/setint or /setinterior", "Setst he players interior id"},
					
					-- election/*
					{ "/addcandidate",  "add's player to election vote list" },
					{ "/delcandidate",  "deletes a player to election vote list" },
					{ "/showresults", "shows the results of the election" },
					
					-- factions/*
					{ "/showfactions",  "shows a list with factions" },
					{" /respawnfaction", "respawns faction vehicles" },
					
					{ "/resetbackup",  "Resets PD's backup unit" },
					{ "/resetassist",  "Resets ES's assist system" },
					{ "/resettowbackup",  "Resets towing backup system" },
					{ "/aremovespikes", "Removes all the PD spikes" },
					{ "/clearnearbytag",  "Clears nearby tag" },
					{ "/nearbytags", "Shows nearby tag and its creators" },
					
					{ "/changelock",  "changes the lock from the vehicle/interior" },
					{ "/restartgatekeepers", "restarts the gatekeepers resource" },
					
					{ "/bury", "buries the player; removes the ck corpse" },
					
					-- advert commands
					{ "/listadverts",  "gives a list with recently ran and pending adverts" },
					{ "/freeze",  "prevents an ad from being aired, max is 10 minutes." },
					{ "/unfreeze",  "Unfreezes an advert" },
					{ "/deletead",  "Marks an ad as aired" },
					{ "/resetpos",  "Reset player's position, works when player's offline." },
				},
				-- level 2: Admin
				{
					{ "/delsupercar", "deletes the supercar you're in, given that it meets the criteria for deletion." },
					{ "/setbiznote [Message]",  "Sets business greeting/notification message." },
					{ "/delitemsfromint [Int ID] [Day old of Items]",  "Deletes all the items within a specified interior that older than an interval of item's day old." },
					{ "/ints or /interiors", "Opens Interior Manager." },
					{ "/delint", "Deletes the interior from game and disables it from loading in next server/resource restarts." },
					{ "/delthisint or /delthisinterior",  "Deletes the interior you're currently in it from game and disables it from loading in next server/resource restarts." },
					{ "/restoreint ", "Restores a deleted interior included safe, items and NPCs inside it." },
					{ "/gotohouse",  "teleports to the house" },
					{ "/gotoint",  "teleports to the interior" },
					{ "/gotointi",  "teleports inside of an interior" },
					-- vehicles
					{ "/veh",  "spawns a temporary vehicle" }

					
				},
				-- level 3: Super Admin
				{
					-- vehicles
					{ "/resetshopwage", "Resets all shops wages to $0." },
					{ "/forceupdateshopwage", "Forces update all shop wages." },
					{ "/delnearbyvehs",  "Deletes all the nearby (temporary) vehicles." },
					{ "/delveh",  "Deletes the (temporary) vehicle with that id" },
					{ "/delthisveh", "Deletes the (temporary) vehicle" },
					{ "/restoreveh",  "Restores a deleted vehicle." },
					{ "/makeveh", "creates a new permanent vehicle" },
					{ "/makecivveh", "creates a new permanent civilian vehicle" },
					{ "/addupgrade", "upgrades a players car" },
					{ "/setpaintjob",  "set another paintjob on a vehicle" },
					{ "/setvariant",  "set another variant on a vehicle" },
					{ "/delupgrade",  "removes a specific upgrade from the player's car" },
					{ "/resetupgrades", "removes all upgrades on the player's car" },
					{ "/aunimpound",  "unimpounds the vehicle from the BTR lot" },
					{ "/setvehtint",  "adds or removes vehicle tint" },
					{ "/atakelicense", "revokes the player a license (use full name for offline players" },
					{ "/setvehplate", "changes the plate of a vehicle" },
					{ "/setvehfaction",  "changes the owner of a vehicle to a faction, use factionid -1 to set it to yourself" },
					-- elevatorssa
					{ "/gates",  "Opens Gate Manager" },
					{ "/gotogate", "Teleports to a gate." },
					{ "/delgate",  "Deletes to a gate." },
				},
				-- level 4: Lead Admins
				{ 
					{ "/loginto [Exact Character Name] ", "Logs into an other account's character." },
					{ "/forcepayday [Player ID/Name] ", "Forces a player to get payday." },
					{ "/forcepaydayall ", "Forces all players to get paydays." },
					{ "/rwarn [warn #]", "sends a predefined admin warnings or custom admin warning." },
					{ "/soban [Player Username] [Time in Hours, 0 = Infinite] [Reason]",  "Silently bans an offline player." },
					{ "/givesuperman [Player Partial Nick / ID]",  "Gives player temporary ability to fly. Execute the cmd again to revoke the ability. Ability will be automatically gone after player relogs." },
					{ "/sw",  "change the weather" },
					{ "/addatm",  "adds an ATM at this spot" },
					{ "/delatm", "deletes an ATM with the id" },
					{ "/nearbyatms",  "shows the nearby ATMs" },
					{ "/bigears",  "hook yourself between someone's chats" },
					{ "/bigearsf",  "hook yourself between faction chats" },
					{ "/nearbyatms", "shows the nearby ATMs" },
					{ "/gunmaker", "Opens Weapon Creator" },
					
					-- paynspray/*
					{ "/makepaynspray",  "creates an pay n spray" },
					{ "/nearbypaynsprays",  "shows nearby pay n sprays" },
					{ "/delpaynspray",  "deletes an pay n spray" },
					
					-- phone/*
					{ "/addphone",  "creates a public phone" },
					{ "/nearbyphones", "shows nearby public phone" },
					{ "/delphone", "deletes a public phone" },
					
					-- interiors/*
					{ "/enableallelevators",  "enables all elevators" },
					
					{ "/addint", "adds an interior" },
					{ "/sellproperty", "sells an interior" },
					{ "/delint", "deletes an interior" },
					{ "/getintid", "shows the current interior" },
					{ "/setintid", "changes the interior" },
					{ "/getintprice", "shows the interiors price" },
					{ "/setintprice", "changes the interiors price" },
					{ "/getinttype", "shows the interiors type" },
					{ "/setinttype", "changes the interiors type" },
					{ "/togint", "sets the interior enabled or disabled" },
					{ "/enableallinteriors","enables all the interiors" },
					{ "/setintexit","changes an interior exit marker" },
					{ "/setintentrance", "changes an interior entrance marker" },
					{ "/fsell", "force-sells an interior" },
					
					-- factions/*
					{ "/setfactionleader",  "puts a player into a faction and makes the player leader" },
					{ "/setfactionrank",  "sets a player to a specific faction rank" },
					{ "/makefaction",  "creates a faction" },
					{ "/renamefaction",  "renames a faction" },
					{ "/setfaction", "puts an player into a faction" },
					{ "/delfaction", "deletes a faction" },
					
					-- fuelpoints/*
					{ "/addfuelpoint","creates a new fuelpoint" },
					{ "/nearbyfuelpoints",  "shows nearby fuelpoints" },
					{ "/delfuelpoint",  "deletes a fuelpoint" },
					
					-- player/*
					{ "/ck",  "permanently kills the character; spawns a corpse at the location the player is at" },
					{ "/unck",  "reverts a character kill" },
					
					-- Weapons
					{ "/makegun",  "gives the player the specified weapon item" },
					{ "/makeammo", "gives the player the specified ammo item" },
					
					-- Etc
					{ "/setmoney",  "sets the players money to that value" },
					{ "/givemoney",  "gives the player money in addition to his current cash" },
					{ "/resetcharacter", "fully resets the character" },
					{ "/setvehlimit",  "Set the players vehicle limit." },
					{ "/adminstats", "shows admin stats" }
				},
				-- level 5: Head Admins
				{
					-- player/*
					{ "/removeshop",  "Deletes a NPC from SQL." },
					{ "/forcesellinactiveints",  "Force-sells All inactive interiors." },
					{ "/removeinactiveints",  "Removes All inactive interiors completedly and permanently from SQL." },
					{ "/removedeletedints",  "Removes All deleted interiors completedly and permanently from SQL." },
					{ "/removeforsaleints",  "Removes All for-sale interiors completedly and permanently from SQL." },
					{ "/delallitems [Item ID] [Item Value]",  "Deletes all the item instances from everywhere in game." },
					{ "/removeint [ID]",  "Deletes the interior from game and erases all the data from database completely and permanently include NPCs, items, safe and items inside the safe. If the deleted interior is a custom interior, the custom map will be gone forever." }, 
					{ "/removeveh [ID]",  "Removes the vehicle from game and erases all the data from database completely and permanently include items inside. " }, 
					{ "/givedonPoints",  "awards a player donPoints" },
					{ "/givestattransfer",  "awards a player stat transfers" },
					{ "/hideadmin",  "toggles hidden/visible the admin status" },
					{ "/ho",  "send global ooc as hidden admin" },
					{ "/hw",  "send a pm as hidden admin" },
					{ "/makeadmin",  "gives the player an admin rank" },
					{ "/setaccountpassword",  "sets player's account password" },
					{ "/toga",  "Toggles admin chat." },
					{ "/togg",  "Toggles gamemaster chat." },
					
					-- resource/*
					{ "/startres",  "starts the resource" },
					{ "/stopres", "stops the resource" },
					{ "/restartres",  "restarts the resource" },
					{ "/rescheck",  "checks for ceatain down resources and startes them" },
					{ "/rcs",  "check if the resource \"Resource-Keeper\" is running" },
					
					{"/generatecode", "generates a donation code" },
					{"/setdamageproof", "makes a vehicle damageproof" }
				}
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "There are currently no commands specific to this level.", false, false)
					--guiGridListSetItemText ( lists[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						--guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			addEventHandler("onClientGUIDoubleClick", lists[1] , copyToClipboard1 , false)
			addEventHandler("onClientGUIDoubleClick", lists[2] , copyToClipboard2 , false)
			addEventHandler("onClientGUIDoubleClick", lists[3] , copyToClipboard3 , false)
			addEventHandler("onClientGUIDoubleClick", lists[4] , copyToClipboard4 , false)
			addEventHandler("onClientGUIDoubleClick", lists[5] , copyToClipboard5 , false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
				--lists = nil
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("ah", adminhelp)

function copyToClipboard1(button,state)
	local row, col = guiGridListGetSelectedItem(lists[1])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(lists[1], guiGridListGetSelectedItem(lists[1]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function copyToClipboard2(button,state)
	local row, col = guiGridListGetSelectedItem(lists[2])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(lists[2], guiGridListGetSelectedItem(lists[2]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function copyToClipboard3(button,state)
	local row, col = guiGridListGetSelectedItem(lists[3])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(lists[3], guiGridListGetSelectedItem(lists[3]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function copyToClipboard4(button,state)
	local row, col = guiGridListGetSelectedItem(lists[4])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(lists[4], guiGridListGetSelectedItem(lists[4]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end

function copyToClipboard5(button,state)
	local row, col = guiGridListGetSelectedItem(lists[5])
	if (row==-1) or (col==-1) then
		outputChatBox("Please select a command first!", 255, 0, 0)
	else
		local CmdName = tostring(guiGridListGetItemText(lists[5], guiGridListGetSelectedItem(lists[5]), 1))
		if setClipboard ( CmdName:sub(2,99) ) then
			outputChatBox("Copied monitor content to clipboard.")
		end
	end
end


