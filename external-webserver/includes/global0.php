<?php


require_once ('GameQ/GameQ.php');
require_once ('server-status.php');
//require_once("includes/classes.php"); 


$codeblue = "Chase"; // Developer mode :) used at /account/dev/

# Definitions
define("Logo", "http://unitedgaming.org/mainlogo.png");

if (__FILE__ == $_SERVER['SCRIPT_FILENAME']) exit('No direct access allowed.');

$global = array();	

//	{Control Panel Definition}
$verno;
$vername;
$global['VER'] = array();
	$global['VER']['NO'] = "0.9.2";
	$global['VER']['NAME'] = "";
	$verno = $global['VER']['NO'];
	$vername = $global['VER']['NAME'];

// {Generals} // These aren't directly used for something.
$global['Gen'] = array();
	$global['Gen']['DonationURL'] = "/ucp/donate/";
	// ..gameserver..
		$global['Gen']['ServerIP'] = "69.197.38.155";
		$global['Gen']['ServerIPLink'] = "mtasa://69.197.38.155:22003";
	// ..ventserver..
		$global['Gen']['TS3IP'] = "69.197.38.156";
		$global['Gen']['TS3IPLink'] = "ts3server://69.197.38.156";
	// ..server..
		$global['Gen']['uGname'] = "United Gaming";
		$global['Gen']['uGnname'] = "";
		

$userID = $_SESSION['ucp_userid'];

$global['adminLevel'] = $userRowFrame['admin'];
$adminLevel = $userRowFrame['admin'];
// {Pages}
$global['Page'] = array();
	// ..staff..
	$global['Page']['Staff'] = array();
		$global['Page']['Staff']['Title'] = "Staff";
		$global['Page']['Staff']['Status'] = "The current staff that represent our MTA Roleplay server.";
	$global['Page']['Guides'] = array();
		$global['Page']['Guides']['Title'] = "Guides";
		$global['Page']['Guides']['Status'] = "Guides that will help you in-game, and ultimately have a better experience.";
	
	
//	{Footer}
$global['Footer'] = array();
	$global['Footer']['DEF'] = "Control Panel";
	$global['Footer']['Year'] = date(Y);
	$global['Footer']['uG'] = $global['Gen']['uGname'];

// {Home}
$global['HOME'] = array();
	// ..welcome..
	$global['HOME']['Welcome'] = array();
		$global['HOME']['Welcome']['Button'] = array();
		$global['HOME']['Welcome']['Button']['Text'] = array();
		$global['HOME']['Welcome']['Button']['Text']['LOUT'] = "Login";
		$global['HOME']['Welcome']['Button']['Text']['LOUTURL'] = "/ucp/login/";
		$global['HOME']['Welcome']['Button']['Text']['LIN'] = "Control Panel";
		$global['HOME']['Welcome']['Button']['Text']['LINURL'] = "/ucp/main/";
	// ..blocks..
	$global['HOME']['Blocks'] = array();
		$global['HOME']['Blocks']['Header'] = array();
			$global['HOME']['Blocks']['Header']['Left'] = "Donations";//
			$global['HOME']['Blocks']['Header']['Center'] = "MTA Ticket Center";//
			$global['HOME']['Blocks']['Header']['Right'] = "MTA User Control Panel";//
		$global['HOME']['Blocks']['Link'] = array();
			$global['HOME']['Blocks']['Link']['Left'] = "http://www.unitedgaming.org/forums/vbdonate.php?do=donate";//DONATIONS BLOCK
			$global['HOME']['Blocks']['Link']['Center'] = "http://www.unitedgaming.org/forums/forumdisplay.php/89-Reports-amp-Unban-Requests";//TICKET CENTER BLOCK
			$global['HOME']['Blocks']['Link']['Right'] = "/ucp/main/";//UCP BLOCK
		$global['HOME']['Blocks']['Desc'] = array();
			$global['HOME']['Blocks']['Desc']['Left'] = "All donations are taken with great consideration and we take pride in the people who take the time to donate.";//DONATIONS BLOCK
			$global['HOME']['Blocks']['Desc']['Center'] = "Are you banned? Make an unban request here. Need to report a player/staff member? Do so here.";//TICKET CENTER BLOCK
			$global['HOME']['Blocks']['Desc']['Right'] = "Control all aspects of your account and characters directly from the User Control Panel.";//UCP BLOCK
			
// {User Control Panel}
$global['UCP'] = array();
	// ..overview..
	$global['UCP']['Main'] = array();
		$global['UCP']['Main']['Title'] = "UCP";
	$ucpHintsArray = array();
		$ucpHintsArray[] = "If you deactivate a character, it will no longer show in-game when you login.";
		$ucpHintsArray[] = "If you re-activate a character, it will show in-game when you login.";
		$ucpHintsArray[] = "You are not able to delete your character(s), however you may use the deactivate feature to remove them from the login screen.";
	$random_ucpHintsArray = rand(0,count($ucpHintsArray)-1);
		$global['UCP']['Main']['Status'] = $ucpHintsArray[$random_ucpHintsArray];//hints :)
	$global['UCP']['PT'] = array();
		$global['UCP']['PT']['Title'] = "User Control Panel";
		$global['UCP']['PT']['Status'] = "";
	$global['UCP']['CHAR'] = array();
		$global['UCP']['CHAR']['Title'] = "User Control Panel";
		$global['UCP']['CHAR']['Status'] = "Viewing Character Information";
	$global['UCP']['Login'] = array();
		$global['UCP']['Login']['Title'] = "User Control Panel";
		$global['UCP']['Login']['Status'] = "To login, use your United Gaming Multi Theft Auto Roleplay username and password.";//this gets changed in the login file for $errno
	$global['UCP']['Register'] = array();
		$global['UCP']['Register']['Title'] = "User Control Panel";
		$global['UCP']['Register']['Status'] = "To register, enter your new account details below.";
	$global['UCP']['Settings'] = array();
		$global['UCP']['Settings']['Title'] = "Settings";
		$global['UCP']['Settings']['Status'] = "Change your core account settings in a flash!";

//	{Ticket Center}
$global['TC'] = array();
		$global['TC']['AdminMsg'] = "As an administrator, we expect you to handle all ticket accordingly. Do not take tickets you aren't able to handle.";
		$global['TC']['PlayerMsg'] = "It's better to report something wrong and not have it solved the way you want, then not to have it solved at all.";
	$global['TC']['Header'] = array();
		$global['TC']['Header']['ActiveTickets'] = "Tickets currently being handled";
		$global['TC']['Header']['Assigned'] = "Tickets created by or assigned to you";
		$global['TC']['Header']['Locked'] = "Tickets that have been handled";
	$global['TC']['MyTickets'] = array(); // Page: My Tickets- Simple variable(s)
		$global['TC']['MyTickets']['None'] = "There are currently no tickets to display here.";

	function newFeature(){
		echo '<img src="http://icons.iconarchive.com/icons/led24.de/led/16/new-icon.png" title="New Feature" alt="NEW"/>';
	}
	
//	F{General}

function suggestion(){
	
	echo '
	
<center><table width="80%" border="0" align="center" cellpadding="4px" cellspacing="3px">
  <tr>
    <td width="5%" align="center" valign="middle"><img src="http://cdn1.iconfinder.com/data/icons/customicondesign-office6-shadow/16/communication.png"></td>
    <td width="95%" align="left" valign="middle"><a href="http://www.unitedgaming.org/forums/forumdisplay.php/277-Script-Suggestions" class="link" target="_blank">Have an idea you would like to submit to the team? We\'d love to hear from you!</a></td>
  </tr>
</table>
</center>

		 ';	
}

function displayAD($type){
	
	if ($type == 1){
		echo('<script type="text/javascript"><!--
google_ad_client = "ca-pub-4764558730158437";
/* UG Footer Ad */
google_ad_slot = "1159724083";
google_ad_width = 234;
google_ad_height = 60;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>');
	}
	elseif ($type == 2){
		echo('<script type="text/javascript"><!--
google_ad_client = "ca-pub-4764558730158437";
/* United Gaming Footer */
google_ad_slot = "9237308088";
google_ad_width = 468;
google_ad_height = 15;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>');
	}
	elseif ($type == 3){
		echo('<script type="text/javascript"><!--
google_ad_client = "ca-pub-4764558730158437";
/* UnitedGaming Long Ad Placement Footer */
google_ad_slot = "1841794484";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>');
	}
}


#new in 0.9.1+ :: this quickly checks if someone is logged in, if not, make them be!
function requirelogin($returnurl){
	
	if(empty($returnurl)){
		$returnurl = "/ucp/main/";
	}
	
	if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
	{
		$_SESSION['returnurl_login'] = $returnurl;
		header("Location: /ucp/login/");
		die();
	}	
}

$adminU = $un;
$adminT = $ti;


// Our visitor information

$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

$mQueryVisitor = mysql_query("SELECT * FROM accounts WHERE id='" . $_SESSION['ucp_userid'] . "' LIMIT 1", $MySQLConn);

if (!mysql_num_rows($mQueryVisitor) < 1)
{
$visitorInfo = mysql_fetch_assoc($mQueryVisitor);
$clientUsername = $visitorInfo['username'];
$clientPassword = $visitorInfo['password'];
$clientIP = $visitorInfo['ip'];
$clientAdmin = $visitorInfo['admin'];
$clientReports = $visitorInfo['adminreports'];
$clientAppState = $visitorInfo['appstate'];
$clientEmail = $visitorInfo['email'];
$clientCredits = $visitorInfo['credits'];
$clientTransfers = $visitorInfo['transfers'];
} else{}


?>