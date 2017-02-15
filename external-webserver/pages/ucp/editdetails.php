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
$mQuery1 = mysql_query("SELECT `username`, `email` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
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

if (!isset($_POST['email']))
{
	require_once("././includes/header.php");
	?>				<!-- Middle Column - main content -->
					<div id="content-middle">
						<div class="content-box">
							<div class="content-holder">
								<form action="" method="post">
									<h2>User Control Panel - Account Information</h2>
									<table border="0">
										<tr>
											<td>Username:</td>
											<td><?php echo $username?></td>
										</tr>
										<tr>
											<td>E-mail address:</td>
											<td><input type="text" name="email" value="<?php echo $email; ?>" maxlength="100" style="width:150px;height:16px"/></td>
										</tr>
										<tr>
											<td>Password: (Only if you want to change it)</td>
											<td><input type="text" name="pass1" maxlength="100" style="width:150px;height:16px"/></td>
										</tr>
										<tr>
											<td></td>
											<td><input type="submit" value="Save"/></td>
										</tr>
									</table>
								</form>
							</div>
						</div>
					</div>
	<?php
	require_once("././includes/footer.php");
}
else {
	$passSQL = '';
	if (strlen($_POST['pass1']) > 3)
	{
		$passSQL = ", `password`='".md5($Config['server']['hashkey'] . $_POST['pass1'])."'";
	}
	
	mysql_query("UPDATE `accounts` SET `email`='".mysql_real_escape_string($_POST['email'])."'".$passSQL." WHERE `id`='".$userID."'");
	header("Location: /ucp/main/");
}
?>