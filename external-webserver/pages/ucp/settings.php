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
$mQuery1 = mysql_query("SELECT `username`, `email`, `adminreports` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$userRow = mysql_fetch_assoc($mQuery1);

// Application stuff
$username = $userRow['username'];
$email = $userRow['email'];
$adminReports = $userRow['adminreports'];

if (!isset($_POST['pass1']))
{
?>	
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left"><?php echo $global['UCP']['Settings']['Title']; ?></h3>
            <p class="left description "><?php echo $global['UCP']['Settings']['Status']; ?></p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
        <div class="three-fourth last">
        <div class="three-fourth notopmargin last">
			<form action="" method="post">
            <h2>Account Settings</h2>
				<br />
			<input type="text" name="email" class="text-input" disabled value="<?php echo $email;?>"/><label for="email">Email</label>
				<br />
			<input type="password" name="pass1" maxlength="100" class="text-input"/><label for="password">Password</label>
				<br />
			<input type="submit" class="button black" value="Submit Changes"/>
			<?php if ($adminLevel >= 1){  ?>
				<br />
				<br />
				<?php /*
				<h2>Extra Information</h2>
				<br />
				<input type="text" name="aReports" class="text-inputs" value="<?php echo $adminReports;?>" disabled/><label for="aReports">Report Count</label>*/?>
				<br />
				
			<?php } ?>
<?php
}
else {
	$passSQL = '';
	if (strlen($_POST['pass1']) > 3)
	{
		$passSQL = ", `password`='".md5($Config['server']['hashkey'] . $_POST['pass1'])."'";
	}
	
	//mysql_query("UPDATE `accounts` SET `email`='".mysql_real_escape_string($_POST['email'])."'".$passSQL." WHERE `id`='".$userID."'");
	header("Location: /ucp/main/");
}
?>
			</form>
				</div>
			</div>
		
		<!-- END MAIN CONTENT -->
