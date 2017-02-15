<?php
if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	header("Location: /ucp/login/");
	die();
}

$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
if (!$MySQLConn) 
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

$userID = $_SESSION['ucp_userid'];
$mQuery1 = mysql_query("SELECT `type`,`owner`, `itemValue` FROM `items` WHERE itemID='134' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	#header("Location: /ucp/login/");
	#die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$adminLevel = $userRow['admin'];
?>
<?php
if(isset($_POST['submit'])) {
error_reporting(0);
require_once("./././internal/mta_sdk.php");
$Fuck['acl'] = array();
$Fuck['acl']['hostname'] = 'server.unitedgaming.org';
$Fuck['acl']['username'] = 'website';
$Fuck['acl']['password'] = '209572079502AHIAWPGHAWPGR';
$sex = '1';
$OfflineOrNot = false;
$error = 'ERR-44395-A4'

	$mtaserver = new mta($Fuck['acl']['hostname'], 22005, $Fuck['acl']['username'], $Fuck['acl']['password'])
	$isServerOnline = $mtaServer->getResource("usercontrolpanel")->call("isServerOnline"), $sex;
	if (!$isServerOnline[0]) {
		$OfflineOrNot = true;
		$error = 'ERR-4435-A4'
		if ($OfflineOrNot[1]) {
			$error = 'ERR-54869-A8'
			// execute sms
		}
	} else {
	}
?>
<?php require_once("./././includes/sidebar.php"); ?>
<?php require_once("./././includes/mta_sdk.php"); ?>
<h3 class="welcome nobottommargin left">test</h3>
			<p class="small-italic notopmargin clear"><a href="/admin/main/" class="link">test</a></p>
		
			<form action="<?=$_SERVER['PHP_SELF'];?>" method="post">
<input type="submit" name="submit" value="Click Me">
</form>
	