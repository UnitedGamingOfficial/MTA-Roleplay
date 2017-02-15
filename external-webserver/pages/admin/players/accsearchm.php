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
$mQuery1 = mysql_query("SELECT `username`,`admin` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$adminLevel = $userRow['admin'];

if ($adminLevel < 2)
{
	header("Location: /ucp/main/");
	die();
}

if (!isset($_GET['action']) or $_GET['action'] == "accsearch")
{
?>
<div class="one notopmargin">
<?php require_once("./././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
			<h3 class="welcome nobottommargin left">ACCOUNT SEARCH</h3>
			<p class="left description "></p>
			<p class="small-italic notopmargin clear"><a href="/admin/main/" class="link">Admin Dashboard</a></p>
		</div>
				<form action="/admin/accsearch/" method="post">
				Account Name: <input type="text" name="termacc" />&nbsp;&nbsp;
				<input type="submit" class="button black" name="submit" value="Search" />
				</form> 
			</div>
		</div>
	
<?php
}
else {
	echo 'epicfail';
}
	echo mysql_error();
?>