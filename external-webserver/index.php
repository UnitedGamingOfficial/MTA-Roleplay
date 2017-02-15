<?php
if(!(isset($_SESSION)))
{
	session_start();
	$_SESSION['SESSION_IP'] = $_SERVER['REMOTE_ADDR'];
}
else
{
	if ($_SESSION['SESSION_IP'] != $_SERVER['REMOTE_ADDR'])
	{
		session_destroy();
		die("Invalid Session!");
	}
}
ob_start();
error_reporting(0);

@ini_set('magic_quotes_runtime', 0);
$UCPEnabled = "Comming Soon";
if($UCPEnabled)
{
require_once("includes/config.php");
require_once("includes/global.php");
require_once("includes/swift/lib/swift_required.php");
require_once("includes/mail_class.php");
require_once("includes/classes.php"); 
require_once("includes/ucp_functions.php");


// check $page
if (!isset($_GET['page']) and !isset($_GET['ucp']) and !isset($_GET['account']) and !isset($_GET['tc']) and !isset($_GET['admin']) and !isset($_GET['mdc']) and !isset($_GET['other'])){
	Header("Location: /main/home/");
	die();
}

addFlashObject("/flash/banner.swf", "banner", "1067", "252", "/flash/preloader.swf");

if (isset($_GET['page']))
	switch ($_GET['page'])
	{
		case 'home':
			$thexcookie = "Home - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/main.php");
			require_once("includes/footer.php");	
			break;
		case 'tamman':
			require_once("includes/header.php");
			require_once("pages/tamman.php");
			require_once("includes/footer.php");	
			break;
		case 'staff':
			$thexcookie = "Staff - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/staff.php");
			require_once("includes/footer.php");	
			break;
		case 'guides':
			$thexcookie = "Guides - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/guides.php");
			require_once("includes/footer.php");	
			break;
		case '404':
			$thexcookie = "Not Found - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/404.php");
			require_once("includes/footer.php");
			break;
		case '405':
			$thexcookie = "Area Blocked - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/405.php");
			require_once("includes/footer.php");
			break;
		default:
			header("Location: /main/home/");
			break;
	}
elseif (isset($_GET['ucp']))
{
	switch ($_GET['ucp'])
	{
		case 'login':
			$thexcookie = "Login - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/login.php");
			require_once("includes/footer.php");
			break;
		case 'logout':
			$thexcookie = "Logging Out - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/logout.php");	
			require_once("includes/footer.php");
			break;
		case 'forgot-password':
			$thexcookie = "Password Recovery - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/forgot-password.php");
			require_once("includes/footer.php");
			break;
		case 'editdetails':
			$thexcookie = "Settings - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/settings.php");
			require_once("includes/footer.php");
			break;
		case 'settings':
			$thexcookie = "Settings - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/settings.php");
			require_once("includes/footer.php");
			break;
		case 'character':
			$thexcookie = "Character - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/chardetail.php");	
			require_once("includes/footer.php");
			break;
		case 'characterlist':
			$thexcookie = "All Characters - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/characterlist.php");
			require_once("includes/footer.php");			
			break;
		case 'interior':
			if(isset($_SESSION['ucp_loggedin']))
			{
				if($_SESSION['ucp_adminlevel'] > 1)
				{
					$thexcookie = "Interior - ".$buznum;
					require_once("includes/header.php");
					require_once("pages/ucp/interiordetail.php");
					require_once("includes/footer.php");
					break;
				}
				else
				{
					header("Location: /main/405/");
					break;
				}
			}
			else
			{
				header("Location: /ucp/login/");
				break;
			}
		case 'perktransfer':
			$thexcookie = "Perk Transfer - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/perktransfer.php");	
			//DO NOT ADD FOOTER, for now.
			break;
		case 'donate':
			$thexcookie = "Donate - ".$buznum;
			require_once("includes/paypal.class.php");
			require_once("includes/header.php");	
			//require_once("pages/ucp/test.php");	
			require_once("pages/ucp/donate.php");	
			require_once("includes/footer.php");	
			break;	
		case 'newdonate':
			$thexcookie = "Donate - ".$buznum;
			require_once("includes/paypal.class.php");
			require_once("includes/header.php");	
			require_once("pages/ucp/donate.php");	
			require_once("includes/footer.php");	
			break;			
		case 'main':
			$thexcookie = "Overview - ".$buznum;
			require_once("pages/admin/functions/overview.php");
			require_once("includes/header.php");
			require_once("pages/ucp/main.php");
			require_once("includes/footer.php");
			break;
		case 'overview':
			$thexcookie = "Overview - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/main.php");
			require_once("includes/footer.php");
			break;
		case 'serverapp':
			$thexcookie = "ServerApp - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/ucp/writeapp.php");
			require_once("includes/footer.php");
			break;
		default:
			header("Location: /ucp/main/");			break;
	}
}

elseif (isset($_GET['tc'])) //developer mode
{
	require_once("includes/ucp_functions.php");
	switch ($_GET['tc'])
	{
		case 'main':
			$thexcookie = "Dashboard - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/tc/main.php");//otherwise pages/tc/main.php
			require_once("includes/footer.php");
			break;
		case 'view':
			$thexcookie = "Ticket #".$_GET['view']." - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/tc/view.php");//otherwise pages/tc/view.php
			require_once("includes/footer.php");
			break;
		case 'new':
			$thexcookie = "New Ticket - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/tc/new.php");//otherwise pages/tc/new.php
			require_once("includes/footer.php");
			break;
		case 'mantis':
			$thexcookie = "Mantis - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/tc/mantis-external.php");
			require_once("includes/footer.php");
			break;
		default:
			header("Location: /");
			break;
	}
}

elseif (isset($_GET['admin']))
{
	switch ($_GET['admin'])
	{
		case 'main':
			$thexcookie = "Dashboard - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/admin/main.php");
			require_once("includes/footer.php");
			break;
		/*case 'interiors':
			require_once("includes/header.php");
			require_once("pages/admin/interiors/main.php");
			require_once("includes/footer.php");
			break;*/ 
		case 'players':
			require_once("includes/header.php");
			require_once("pages/admin/players/main.php");
			require_once("includes/footer.php");
			break;
		case 'perks':
			$thexcookie = "Admin Perks - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/admin/players/perkslist.php");
			require_once("includes/footer.php");
			break;
		case 'logs':
			$thexcookie = "Logs - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/admin/players/logs.php");
			require_once("includes/footer.php");
			break;
		case 'logsoverride':
			require_once("includes/header.php");
			require_once("pages/admin/players/logs.php");
			require_once("includes/footer.php");
			break;
		case 'accsearchm':
			$thexcookie = "Search - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/admin/players/accsearchm.php");
			require_once("includes/footer.php");
			break;
		case 'accsearch':
			$thexcookie = "Search - ".$buznum;
			require_once("./includes/header.php");
			require_once("./pages/admin/players/accsearch.php");
			require_once("./includes/footer.php");
			break;
		case 'moneyabuse':
			$thexcookie = "Search - ".$buznum;
			require_once("./includes/header.php");
			require_once("./pages/admin/players/moneyabuse.php");
			require_once("./includes/footer.php");
			break;
		case 'perks4retards':
			require_once("./includes/header.php");
			require_once("pages/admin/players/perkslistfaggot.php");
			require_once("includes/footer.php");
			break;
		default:
			header("Location: /admin/main/");
			break;
	}
}

elseif (isset($_GET['account']))
{
	switch ($_GET['account'])
	{
		case 'email':
			$thexcookie = "Update - ".$buznum;
			require_once("includes/header.php");
			require_once("pages/account/email.php");
			require_once("includes/footer.php");
			break;
		case 'dev':
			$thexcookie = "Developer Mode - ".$buznum;
			require_once("includes/header.php");
                        echo "No";
			//require_once("pages/account/developer.php");
			require_once("includes/footer.php");
			break;
		case 'dev/#!/remove':
			$thexcookie = "Developer Mode - ".$buznum;
			require_once("includes/header.php");
                        echo "No";
			//require_once("pages/account/developer.php");
			require_once("includes/footer.php");
			break;
		default:
			header("Location: /ucp/main/");
			break;
	}
}
}
elseif ($UCPEnabled == false)
{
	echo "The UCP is currently disabled. Please try again shortly.</BR>";
	echo 'You can visit the forums <a href="./forums"> here</a>.';
}
elseif ($UCPEnabled == "Comming Soon")
{
?>
	<title>United Gaming - Back Shortly</title>
	<center>
		<iframe width="560" height="315" src="//www.youtube-nocookie.com/embed/3_qF_FSfm8E?rel=0&autoplay=1" frameborder="0" autoplay="1"></iframe>
		<br><br>We're not dead.
		<br>Back soon!
	</center>
<?php
}
?>