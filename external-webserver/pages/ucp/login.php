<?php
 if (!isset($_POST['username'])) { ?>

        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h1 class="welcome nobottommargin left">Login</h1>
            <p class="left description ">Your login details are the same as those used in-game.</p>
        </div>
        <!-- END WELCOME BLOCK -->
        <div class="one separator  margin15"></div>
        <div class="one last">
			
				<form action="" method="post">
				<?php
				if (isset($_SESSION["errno"]))
					$errno = $_SESSION["errno"];
				else
					$errno = 0;
					
				if (isset($_SESSION["loggedout"]))
					$_SESSION["loggedout"] = true;
				else
					$_SESSION["loggedout"] = false;
				if ($errno==2)
					echo "The User Control Panel is currently offline.";
				elseif ($errno==3)
					echo "Invalid Username/Password, try again.";
				elseif ($errno==4)
					echo "You have used up the 3 login attempts, you're now locked out for 15 minutes.";
				elseif ($errno==5)
					echo "Your username and new password have been sent to your email.";
				elseif ($errno==6)
					echo "Invalid Username/Password, try again.";	
				elseif ($errno==7)
					echo "You've successfully registered a new account, please check your email for your password.";
				elseif ($loggedout==true)
					echo "You are now logged out.";
				else
				$error_response = "";
				unset($_SESSION["errno"]);
				unset($_SESSION["loggedout"]);
				?>
					<h2>Login</h2>
					<input type="text" name="username" maxlength="32" class="text-input"/><label for="username">Username</label>
					<br />
					<input type="password" name="password" maxlength="32" class="text-input"/><label for="password">Password</label>
					
					<br />
					<input type="submit" class="button black" value="Login"/>&nbsp;&nbsp;<a href="/ucp/forgot-password/">I can't remember my password</a>
				</form>
        </div>
		<!-- END MAIN CONTENT -->

<?php
}
else {
	// login attempt
	if (!isset($_POST['username']) or !isset($_POST['password']))
	{
		$_SESSION['errno'] = 6;
		header("Location: /ucp/login/");
	}
	else {
		$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
		if (!$MySQLConn) {
			$_SESSION['errno'] = 2;
			header("Location: /ucp/login/");
		}
		$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
		
		$username = mysql_real_escape_string($_POST['username'], $MySQLConn);
		//$password = md5($Config['server']['hashkey'] . $_POST['password']);
		$result = mysql_query("SELECT * FROM `accounts` WHERE `username`='" . $username . "' AND `password`=SHA1(CONCAT(SHA1('" . $Config['server']['superSalt'] . "'), SHA1('" . $_POST['password'] ."'))) LIMIT 1", $MySQLConn);

		if (!$result)
		{
			$_SESSION['errno'] = 3;
			header("Location: /ucp/login/");
		}
		elseif (mysql_num_rows($result) == 0)
		{
			$_SESSION['errno'] = 3;
			header("Location: /ucp/login/");
		}
		else
		{
			$row = mysql_fetch_assoc($result);
			$_SESSION['ucp_loggedin'] = true;
			$_SESSION['ucp_username'] = $username;
			$_SESSION['ucp_userid'] = $row['id'];
			$_SESSION['ucp_adminlevel'] = $row['admin'];
			$_SESSION['ucp_email'] = $row['email'];
			$_SESSION['ucp_appstate'] = $row['appstate'];
			if (isset($_SESSION['returnurl_login']))
			{
				header("Location: ".$_SESSION['returnurl_login']);
				unset ($_SESSION['returnurl_login']);
			}
			else
				if (empty($_SESSION['ucp_email'])){
					header("Location: /account/email/");
				} else {
				header("Location: /ucp/main/");
				}
			
		}
	}
}
?>