<?php


function isDecimalNumber($n) {
  return (string)(float)$n === (string)$n;
}



function getNameFromUserID($userID, $MySQLHandle)
{
	$mQuery = mysql_query("SELECT `username` FROM `accounts` WHERE `id`='".mysql_real_escape_string($userID)."'", $MySQLHandle);
	if (mysql_num_rows($mQuery) > 0)
	{
		$row = mysql_fetch_assoc($mQuery);
		return $row['username'];
	}
	return 'Unknown';
}

function getNamefromCharacterID($charID, $MySQLHandle)
{
	$mQuery = mysql_query("SELECT `charactername` FROM `characters` WHERE `id`='".mysql_real_escape_string($charID)."'", $MySQLHandle);
	if (mysql_num_rows($mQuery) > 0)
	{
		$row = mysql_fetch_assoc($mQuery);
		return $row['charactername'];
	}
	return 'Unknown';
}

function getAdminTitleFromIndex($index)
{
	$ranks = array("No", "Trial Admin", "Administrator", "Super Admin", "Lead Admin", "Head Admin", "Owner");
	return $ranks[$index];
}

function getDonatorTitleFromIndex($index)
{
	$ranks = array("<a href=\"/http://www.unitedgaming.org/forums/vbdonate.php?do=donate\"/ class=\"/link\"/>Make a Donation</a>", "Bronze" ,"Silver", "Gold", "Platinum", "Pearl", "Diamond", "Godly");
	return $ranks[$index];
}

function getStandingFromIndex($index)
{
	$ranks = array("<font color='green'>Excellent</font>", "<em><font color='#FF0000'>Banned</font></em>");
	return $ranks[$index];
}

function getVACStandingFromIndex($index)//valve anti cheat-not in use i assume~exytictac
{
	$ranks = array("<em><font color='green'>Excellent</font></em>", "<em><font color='#FF0000'>VAC Banned</font></em>");
	return $ranks[$index];
}

function check_email_address($email) 
{
	// checks proper syntax
	if(preg_match('/^[^@]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$/' , $email)) {
		// gets domain name
		list($username,$domain)=split('@',$email);
		// checks for if MX records in the DNS
		if(!checkdnsrr($domain, 'MX')) {
			return false;
		}
		//// attempts a socket connection to mail server
		//if(!fsockopen($domain,25,$errno,$errstr,30)) {
		//	return false;
		//}
		return true;
	}
	return false;
}

function generatePassword($length=9, $strength=0) {
	$vowels = 'aeuy';
	$consonants = 'bdghjmnpqrstvz';
	if ($strength & 1) {
		$consonants .= 'BDGHJLMNPQRSTVWXZ';
	}
	if ($strength & 2) {
		$vowels .= "AEUY";
	}
	if ($strength & 4) {
		$consonants .= '23456789';
	}
	if ($strength & 8) {
		$consonants .= '@#$%';
	}
	
	$password = '';
	$alt = time() % 2;
	for ($i = 0; $i < $length; $i++) {
		if ($alt == 1) {
			$password .= $consonants[(rand() % strlen($consonants))];
			$alt = 0;
		} else {
			$password .= $vowels[(rand() % strlen($vowels))];
			$alt = 1;
		}
	}
	return $password;
}


$itemIDtoName = array (
'1' => 'Hotdog',
'2' => 'Cellphone',
'3' => 'Vehicle key',
'4' => 'House key',
'5' => 'Business key',
'6' => 'Radio',
'7' => 'Phonebook',
'8' => 'Sandwich',
'9' => 'Softdrink',
'10' => 'Dice',
'11' => 'Taco',
'12' => 'Burger',
'13' => 'Donut',
'14' => 'Cookie',
'15' => 'Water',
'16' => 'Clothes',
'17' => 'Watch',
'18' => 'City Guide',
'19' => 'MP3 Player',
'20' => 'Standard Fighting for Dummies',
'21' => 'Boxing for Dummies',
'22' => 'Kung fu for Dummies',
'23' => 'Knee Head Fighting for Dummies',
'24' => 'Grab Kick Fighting for Dummies',
'25' => 'Elbow Fighting for Dummies',
'26' => 'Gas Mask',
'27' => 'Flashbang',
'28' => 'Glowstick',
'29' => 'Door Ram',
'30' => 'Cannabis Sativa',
'31' => 'Cocaine Alkaloid',
'32' => 'Lysergic Acit',
'33' => 'Unprocessed PCP',
'34' => 'Cocaine',
'35' => 'Drug 2',
'36' => 'Drug 3',
'37' => 'Drug 4',
'38' => 'Marijuana',
'39' => 'Drug 6',
'40' => 'Angel Dust',
'41' => 'LSD',
'42' => 'Drug 9',
'43' => 'PCP Hydrochloride',
'44' => 'Chemistry Set',
'45' => 'Handcuffs',
'46' => 'Rope',
'47' => 'Handcuff Keys',
'48' => 'Backpack',
'49' => 'Fishing Rod',
'50' => 'Los Santos Highway Code',
'51' => 'Chemistry 101',
'52' => 'Police officer\'s Manual',
'53' => 'Breathalizer',
'54' => 'Ghettoblaster',
'55' => 'Business Card',
'56' => 'Ski Mask',
'57' => 'Fuel Can',
'58' => 'Ziebrand Beer',
'59' => 'Mudkip',
'60' => 'Safe',
'61' => 'Emergency Light strobes',
'62' => 'Bastradov Vodka',
'63' => 'Scottish Whiskey',
'64' => 'LSPD Badge',
'65' => 'LSES Identification',
'66' => 'Blindfold',
'67' => 'GPS',
'68' => 'Lottery Ticket',
'69' => 'Dictionary',
'70' => 'First Aid Kit',
'71' => 'Notebook',
'72' => 'Note',
'73' => 'Elevator Remote',
'76' => 'Riot Shielf',
'77' => 'Card Deck',
'78' => 'San Andreas Pilot Certificate',
'79' => 'Porn Tape',
'80' => 'Generic Item',
'81' => 'Fridge',
'82' => 'LST&R Identification',
'83' => 'Coffee',
'84' => 'Escort 9500ci Radar Detector',
'85' => 'Emergency Siren',
'86' => 'SAN Identification',
'87' => 'LS Government Badge',
'88' => 'Earpiece',
'89' => 'Food',
'90' => 'Helmet',
'91' => 'Eggnog',
'92' => 'Turkey',
'93' => 'Christmas Pudding',
'94' => 'Christmas Present',
'95' => 'Drink',
'96' => 'PDA',
'97' => 'LSES Procedures Manual',
'98' => 'Garage Remote',
'99' => 'Mixed Dinner Tray',
'100' => 'Small Milk Carton',
'101' => 'Small Juice Carton',
'102' => 'Cabbage',
'103' => 'Shelf',
'104' => 'Portable TV',
'105' => 'Pack of Cifgarettes',
'106' => 'Cigarette',
'107' => 'Lighter',
'-0' => 'Fist',
'-1' => 'Brass Knuckles',
'-2' => 'Golf Club',
'-3' => 'Nightstick',
'-4' => 'Knife',
'-5' => 'Baseball Bat',
'-6' => 'Shovel',
'-7' => 'Pool Cue',
'-8' => 'Katana',
'-9' => 'Chainsaw',
'-10' => 'Long Purple Dildo',
'-11' => 'Short tan Dildo',
'-12' => 'Vibrator',
'-14' => 'Flowers',
'-15' => 'Cane',
'-16' => 'Grenade',
'-17' => 'Tear Gas',
'-18' => 'Molotov Cocktails',
'-22' => 'Colt 45',
'-23' => 'Silenced Pistol',
'-24' => 'Desert Eagle',
'-25' => 'Shotgun',
'-26' => 'Sawn-Off Shotgun',
'-27' => 'SPAZ-12 Combat Shotgun',
'-28' => 'Uzi',
'-29' => 'MP5',
'-30' => 'AK-47',
'-31' => 'M4',
'-32' => 'TEC-9',
'-33' => 'Country Rifle',
'-34' => 'Sniper Rifle',
'-35' => 'Rocket Launcher',
'-36' => 'Heat-Seeking RPG',
'-37' => 'Flamethrower',
'-38' => 'Minigun',
'-39' => 'Satchel Charges',
'-40' => 'Satchel Detonator',
'-41' => 'Spraycan',
'-42' => 'Fire extinguisher',
'-43' => 'Camera',
'-44' => 'Night-Vision Goggles',
'-45' => 'Infrared Goggles',
'-46' => 'Parachute');

$vehicleIDtoName = array (
'400' => 'Landstalker',
'401' => 'Bravura',
'402' => 'Buffalo',
'403' => 'Linerunner',
'404' => 'Perenail',
'405' => 'Sentinel',
'406' => 'Dumper',
'407' => 'Firetruck',
'408' => 'Trashmaster',
'409' => 'Stretch',
'410' => 'Manana',
'411' => 'Infernus',
'412' => 'Voodoo',
'413' => 'Pony',
'414' => 'Mule',
'415' => 'Cheetah',
'416' => 'Ambulance',
'417' => 'Levetian',
'418' => 'Moonbeam',
'419' => 'Esperanto',
'420' => 'Taxi',
'421' => 'Washington',
'422' => 'Bobcat',
'423' => 'Mr Whoopee',
'424' => 'BF Injection',
'425' => 'Hunter',
'426' => 'Premier',
'427' => 'Enforcer',
'428' => 'Securicar',
'429' => 'Banshee',
'430' => 'Predator',
'431' => 'Bus',
'432' => 'Rhino',
'433' => 'Barracks',
'434' => 'Hotknife',
'435' => 'Artic trailer 1',
'436' => 'Previon',
'437' => 'Coach',
'438' => 'Cabbie',
'439' => 'Stallion',
'440' => 'Rumpo',
'441' => 'RC Bandit',
'442' => 'Romero',
'443' => 'Packer',
'444' => 'Monster',
'445' => 'Admiral',
'446' => 'Squalo',
'447' => 'Seasparrow',
'448' => 'Pizza boy',
'449' => 'Tram',
'450' => 'Artic trailer 2',
'451' => 'Turismo',
'452' => 'Speeder',
'453' => 'Reefer',
'454' => 'Tropic',
'455' => 'Flatbed',
'456' => 'Yankee',
'457' => 'Caddy',
'458' => 'Solair',
'459' => 'Top fun',
'460' => 'Skimmer',
'461' => 'PCJ 600',
'462' => 'Faggio',
'463' => 'Freeway',
'464' => 'RC Baron',
'465' => 'RC Raider',
'466' => 'Glendale',
'467' => 'Oceanic',
'468' => 'Sanchez',
'469' => 'Sparrow',
'470' => 'Patriot',
'471' => 'Quad',
'472' => 'Coastguard',
'473' => 'Dinghy',
'474' => 'Hermes',
'475' => 'Sabre',
'476' => 'Rustler',
'477' => 'ZR 350',
'478' => 'Walton',
'479' => 'Regina',
'480' => 'Comet',
'481' => 'BMX',
'482' => 'Burriro',
'483' => 'Camper',
'484' => 'Marquis',
'485' => 'Baggage',
'486' => 'Dozer',
'487' => 'Maverick',
'488' => 'VCN Maverick',
'489' => 'Rancher',
'490' => 'FBI Rancher',
'491' => 'Virgo',
'492' => 'Greenwood',
'493' => 'Jetmax',
'494' => 'Hotring',
'495' => 'Sandking',
'496' => 'Blistac',
'497' => 'Police Maverick',
'498' => 'Boxville',
'499' => 'Benson',
'500' => 'Mesa',
'501' => 'RC Goblin',
'502' => 'Hotring A',
'503' => 'Hotring B',
'504' => 'Blood ring banger',
'505' => 'Rancher (lure)',
'506' => 'Super GT',
'507' => 'Elegant',
'508' => 'Journey',
'509' => 'Bike',
'510' => 'Mountain bike',
'511' => 'Beagle',
'512' => 'Cropduster',
'513' => 'Stuntplane',
'514' => 'Petrol',
'515' => 'Roadtrain',
'516' => 'Nebula',
'517' => 'Majestic',
'518' => 'Buccaneer',
'519' => 'Shamal',
'520' => 'Hydra',
'521' => 'FCR 900',
'522' => 'NRG 500',
'523' => 'HPV 1000',
'524' => 'Cement',
'525' => 'Towtruck',
'526' => 'Fortune',
'527' => 'Cadrona',
'528' => 'FBI Truck',
'529' => 'Williard',
'530' => 'Fork lift',
'531' => 'Tractor',
'532' => 'Combine',
'533' => 'Feltzer',
'534' => 'Remington',
'535' => 'Slamvan',
'536' => 'Blade',
'537' => 'Freight',
'538' => 'Streak',
'539' => 'Vortex',
'540' => 'Vincent',
'541' => 'Bullet',
'542' => 'Clover',
'543' => 'Sadler',
'544' => 'Firetruck LA',
'545' => 'Hustler',
'546' => 'Intruder',
'547' => 'Primo',
'548' => 'Cargobob',
'549' => 'Tampa',
'550' => 'Sunrise',
'551' => 'Merit',
'552' => 'Utility Van',
'553' => 'Nevada',
'554' => 'Yosemite',
'555' => 'Windsor',
'556' => 'Monster A',
'557' => 'Monster B',
'558' => 'Uranus',
'559' => 'Jester',
'560' => 'Sultan',
'561' => 'Stratum',
'562' => 'Elegy',
'563' => 'Raindance',
'564' => 'RC Tiger',
'565' => 'Flsh',
'566' => 'Tahoma',
'567' => 'Savanna',
'568' => 'Bandito',
'569' => 'Freight flat',
'570' => 'Streak',
'571' => 'Kart',
'572' => 'Mower',
'573' => 'Duneride',
'574' => 'Sweeper',
'575' => 'Broadway',
'576' => 'Tornado',
'577' => 'AT 400',
'578' => 'DFT 30',
'579' => 'Huntley',
'580' => 'Stafford',
'581' => 'BF 400',
'582' => 'News van',
'583' => 'Tug',
'584' => 'Petrol Tanker',
'585' => 'Emperor',
'586' => 'Wayfarer',
'587' => 'Euros',
'588' => 'Hotdog',
'589' => 'Club',
'590' => 'Freight box',
'591' => 'Artic trailer 3',
'592' => 'Andromada',
'593' => 'Dodo',
'594' => 'RC Cam',
'595' => 'Launch',
'596' => 'Cop car LS',
'597' => 'Cop car SF',
'598' => 'Cop car LV',
'599' => 'Ranger',
'600' => 'Picador',
'601' => 'Swat tank',
'602' => 'Alpha',
'603' => 'Pheonix',
'604' => 'Glendale (damage)',
'605' => 'Sadler (damage)',
'606' => 'Bag box A',
'607' => 'Bag box B',
'608' => 'Stairs',
'609' => 'Boxville (black)',
'610' => 'Farm trailer',
'611' => 'Utility van trailer'
)

?>