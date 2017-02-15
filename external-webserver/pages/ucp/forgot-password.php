<?php
if (isset($_GET['param3']))
{ // url used
// param1 = accountid
// param2 = hash

	$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
	if (!$MySQLConn) {
		$_SESSION['errno'] = 2;
		header("Location: /ucp/forgot-password/");
	}
	$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
	
	$userID = mysql_real_escape_string($_GET['param2'], $MySQLConn);
	$activationHash = mysql_real_escape_string($_GET['param3'], $MySQLConn);
	
	$result = mysql_query("SELECT `account` FROM `forgotdetails` WHERE `account`='" . $userID . "' AND `uniquekey`='".$activationHash."' LIMIT 1", $MySQLConn);
	

	if ($result and mysql_num_rows($result) > 0)
	{
		// $userID is valid
		
		// Clean the old mess
		mysql_query("DELETE from FROM `forgotdetails` WHERE `account`='" . $userID . "'", $MySQLConn);

		$result2 = mysql_query("SELECT `id`,`username`,`admin` FROM `accounts` WHERE `id`='" . $userID . "'LIMIT 1", $MySQLConn);
		
		$row2 = mysql_fetch_assoc($result2);
		//Log the player in
		$_SESSION['ucp_loggedin'] = true;
		$_SESSION['ucp_username'] = $row2['username'];
		$_SESSION['ucp_userid'] = $row2['id'];
		$_SESSION['ucp_adminlevel'] = $row2['admin'];
		header("Location: /ucp/editdetails/");
	}
	else
	{
		$_SESSION['errno'] = 5;
		header("Location: /ucp/forgot-password/");
	}
	
	mysql_close($MySQLConn);
}
elseif (!isset($_POST['username']))
{

?>
        <div class="one separator  margin15"></div>
        <div class="one last">
			<h2>Password Recovery</h2>
								
				<form action="" method="post">
									<?php
									if (isset($_SESSION["errno"]))
										$errno = $_SESSION["errno"];
									else
										$errno = 0;
										
									if ($errno==2)
										echo "<span style='text-align:left;'><p>The UCP is currently unavailable!</p></span>";
									elseif ($errno==3)
										echo "<span style='text-align:left;'><p>No details found with the given details.</p></span>";
									elseif ($errno==4)
										echo "<span style='text-align:left;'><p>An e-mail with the required details has been sent to the e-mail address you've used while registrering.a</p></span>";
									elseif ($errno==5)
										echo "<span style='text-align:left;'><p>The link you've used to retrieve your password is invalid.</p></span>";
									else
										echo "<span style='text-align:left;'><p>Please fill in your username or e-mail address below to start the password recovery procedure.</span>";
									unset($_SESSION["errno"]);
									unset($_SESSION["loggedout"]);
?>	<br />
				<input type="text" name="username" maxlength="32" class="text-input"/><label for="username">Username</label>
                <br/>OR<br/><br/>
				<input type="text" name="email" maxlength="100" class="text-input"/><label for="email">Email Address</label>
				<input type="submit" class="button" value="Recover Password"/>
				<br />
				</form>
		</div>
<?php
}
else {
	// login attempt
	if (!isset($_POST['username']) and !isset($_POST['email']))
	{
		$_SESSION['errno'] = 3;
		header("Location: /ucp/forgot-password/");
	}
	else {
		$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
		if (!$MySQLConn) {
			$_SESSION['errno'] = 2;
			header("Location: /ucp/forgot-password/");
		}
		$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
		
		
		$donesomething = false;
		if (isset($_POST['username']) AND strlen($_POST['username']) > 1)
		{
			$username = mysql_real_escape_string($_POST['username'], $MySQLConn);
			
			$result = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='" . $username . "' LIMIT 1", $MySQLConn);
			
			if ($result || mysql_num_rows($result) > 0)
			{
				$row = mysql_fetch_assoc($result);
				sendPasswordMail($row['id']);
				$donesomething = true;
			}
		}
		
		if (!$donesomething AND isset($_POST['email']) and strlen($_POST['email']) > 1)
		{
			$email = mysql_real_escape_string($_POST['email'], $MySQLConn);
			
			$result = mysql_query("SELECT `id` FROM `accounts` WHERE `email`='" . $email . "' LIMIT 1", $MySQLConn);
			
			if ($result and mysql_num_rows($result) > 0)
			{
				$row = mysql_fetch_assoc($result);
				sendPasswordMail($row['id']);
				$donesomething = true;
			}
		}
		
		if (!$donesomething)
		{
			$_SESSION['errno'] = 3;
			header("Location: /ucp/forgot-password/");
		}
		mysql_close($MySQLConn);
	}
}

function sendPasswordMail($accountID)
{
	global $MySQLConn,$Config;
	$result = mysql_query("SELECT `username`,`email` FROM `accounts` WHERE `id`='" . $accountID . "' LIMIT 1", $MySQLConn);
	if ($result and mysql_num_rows($result) > 0)
	{
		$row = mysql_fetch_assoc($result);
		
		$id = $accountID;
		$ip = $_SERVER['REMOTE_ADDR'];
		$username = $row['username'];
		$email = $row['email'];
		$uniquekey = md5(rand(1,100000).$id.$username.$email);
		$url = "http://unitedgaming.org/ucp/forgot-password/".$id."/".$uniquekey."/";
		
		mysql_query("INSERT INTO `forgotdetails` (`uniquekey`, `account`) VALUES ('".$uniquekey."', '".$id."')", $MySQLConn);
		
		EMAIL_tc($email, $username, "New Password", "Password Recovery", "Hi ". $username.",<br/>Someone (hopefully you) has requested a new password, details below on the process.<br/><br/>Account ID: ".$id."<br/>Username: ".$username."<br/>Password Reset URL: <a href=\"".$url."\">".$url."</a><br/><br/>If you did not request a new password, and/or getting multiple reset emails, it may be nice to know ".$ip." did. If it was false, and/or is being spammed, we will block it. Just report it on our <a href=\"http://unitedgaming.org/tc/\" target=\"_blank\">ticket center</a>.");

		$_SESSION['errno'] = 4;
		header("Location: /ucp/forgot-password/");

	}
	else {
		$_SESSION['errno'] = 2;
		header("Location: /ucp/forgot-password/");
	}
}
?>