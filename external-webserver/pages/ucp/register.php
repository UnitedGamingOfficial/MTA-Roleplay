<?php

if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	if (!isset($_POST['register']))
	{


?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h1 class="welcome nobottommargin left"><?php echo $global['UCP']['Register']['Title']; ?></h1>
            <p class="left description "><?php echo $global['UCP']['Register']['Status']; ?></p>
        </div>
        <!-- END WELCOME BLOCK -->
        <div class="one separator  margin15"></div>
        <div class="one last">
										<script type="text/javascript" src="/js/prototype/prototype.js"></script>
								<script type="text/javascript" src="/js/bramus/jsProgressBarHandler.js"></script>
						<script type="text/javascript">
								<!--
									function validate_form(thisform)
									{
										with (thisform)
										  {
											if (thisform.username.value==null || thisform.username.value==""  || thisform.username.value.length<3 || thisform.username.value.length>30 )
											{
												alert("Please ensure you have entered a valid username.\n\n Usernames must be between 3 and 30 characters long.");
												return false;
											}
											else if (thisform.password.value==null || thisform.password.value==""  || thisform.password.value.length<3 || thisform.password.value.length>30 )
											{
												alert("Please ensure you have entered a valid password.\n\n Passwords must be between 3 and 30 characters long.");
												return false;
											}
											else if (thisform.emailaddress.value==null || thisform.emailaddress.value==""  || thisform.emailaddress.value.length<3 || thisform.emailaddress.value.length>100 )
											{
												alert("Please ensure you have entered a valid e-mail address.\n\n Passwords must be between 3 and 100 characters long.");
												return false;
											}
											else if (thisform.password.value != thisform.password2.value)
											{
												alert("You didn't use the same password twice. Please correct this and try it again.");
												thisform.password.value = ''
												thisform.password2.value = ''
												return false;
											}
											else
											{
												return true;
											}
										  }
									 }

									Event.observe(window, 'load', function() {
									  securityPB = new JS_BRAMUS.jsProgressBar($('securitybar'), 0, {animate: false, width:120, height: 12});
									}, false);


									 function hasNumbers(t)
									 {
										var regex = /\d/g;
										return regex.test(t);
									 }
									 
									 function hasSpecialCharacters(t)
									 {
										 var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?~_"; 
										 for (var i = 0; i < t.length; i++) 
										 {
											if (iChars.indexOf(t.charAt(i)) != -1) 
												return true;
										 }
										 return false;
									  }
									  
									function isValidEmail(t)
									{
										for (var i = 0; i < t.length; i++) 
										{
											if ( t.charAt(i) == "@")
												return true;
										}
										return false;
									}
									 
									 function checkSecurity(field)
									 {
										 var value = field.value
										 var len = value.length
										 
										 if (hasNumbers(value))
											len = len * 2
											
										 if (hasSpecialCharacters(value))
											len = len * 2
										 
										 len = Math.round((len / 30) * 100, 0)
											
										 securityPB.setPercentage(len, false)
									 }
								 //-->
								 </script>
				<form action="" method="post" onSubmit="return validate_form(this)">
					<h2>Register</h2>
					<input type="text" name="username" maxlength="30" class="text-input"/><label for="username">Username (eg. Hobknocker293)</label>
					<br />
					<input type="emailaddress" name="emailaddress" maxlength="30" class="text-input"/><label for="emailaddress">Email Address</label>
					<br />
					<input type="password" name="password" maxlength="32" class="text-input" onKeyUp="checkSecurity(this)"/><label for="password">Password</label>
					<br />
					<input type="password" name="password2" maxlength="32" class="text-input"/><label for="password2">Repeat Password</label>
					<br />
					Password Strength <div class="securitybar" id="securitybar"></div>
					
					<br />
					<input type="submit" class="button black" name="register" value="Register"/><a class="button black" href="/ucp/login/">Login</a><br /><a href="/ucp/forgot-password/">&nbsp;Forgot Password</a>
				</form>
												<?php
					if (isset($_SESSION["reg:errno"]))
						$errno = $_SESSION["reg:errno"];
					else
						$errno = 0;
						
					if ($errno==1)
						echo '<h6 class="sh6">This account already exists!</h6>';
					elseif ($errno==2)
						echo '<h6 class="sh6">Unknown Error</h6>';
					elseif ($errno==3)
						echo '<h6 class="sh6">This email address is already in use!</h6>';
					elseif ($errno==4)
						echo '<h6 class="sh6">Please complete all fields.</h6>';
					elseif ($errno==5)
						echo '<h6 class="sh6">Passwords do not match!</h6>';
					elseif ($errno==6)
						echo '<h6 class="sh6">That email address is invalid!</h6>';
					elseif ($errno==7)
						echo '<h6 class="sh6">Uh-Oh! Database is offline!</h6>';
						
					unset($_SESSION["reg:errno"]);
				?>
			</div>
<?php
	} else {
		if (isset($_POST['username']) and isset($_POST['password']) and isset($_POST['password2']) and isset($_POST['emailaddress']))
		{
			if ($_POST['password'] != $_POST['password2'])
			{
				$_SESSION["reg:errno"] = 5;
				header("Location: /ucp/register/");
			}
			else { // passwords match
				if (check_email_address($_POST['emailaddress'])) // Is the mail address vailid?
				{
					$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
					if (!$MySQLConn) {
						$_SESSION["reg:errno"] = 7;
						header("Location: /ucp/register/");
					}
					else {
						$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
						// Got a server connection
						
						// escape some stuff
						$username = mysql_real_escape_string($_POST['username'], $MySQLConn);
						$password = md5($Config['server']['hashkey'] . $_POST['password']);
						$emailaddress = mysql_real_escape_string($_POST['emailaddress'], $MySQLConn);
						$ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR'], $MySQLConn);
						
						$mQuery1 = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='" . $username . "' LIMIT 1", $MySQLConn);
						if (mysql_num_rows($mQuery1) == 0)
						{ // username is free
							$mQuery2 = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='" . $username . "' LIMIT 1", $MySQLConn);
							if (mysql_num_rows($mQuery2) == 0)
							{ // e-mail address is not used yet
								// make the account
								$mQuery3 = mysql_query("INSERT INTO `accounts` SET `username`='" . $username . "', `password`='" . $password . "', email='" . $emailaddress. "', registerdate=NOW(), ip='" . $ip . "', country='SC', friendsmessage='Hello', appstate='3'", $MySQLConn);

								$smtp = new SMTP($Config['SMTP']['hostname'], 25, false, 5);
								$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
								$smtp->mail_from($Config['SMTP']['from']);

								$smtp->send($emailaddress, 'Welcome to United Gaming!', 'Hi

Thank you for joining United Gaming, and our MTA Roleplay server.

Your login details are displayed below.

Username: '.$username.'
Password: '.$_POST['password'].'
Control Panel: http://unitedgaming.org
Forums: http://unitedgaming.org/forums/


						
Kind Regards,
Chuevo');

								$_SESSION['errno'] = 7;
								header("Location: /ucp/login/");
							}
							else 
							{
								$_SESSION["reg:errno"] = 3;
								header("Location: /ucp/register/");
							}
						}
						else
						{
							$_SESSION["reg:errno"] = 1;
							header("Location: /ucp/register/");
						}
						
					}
				}
				else {
					$_SESSION["reg:errno"] = 6;
					header("Location: /ucp/register/");
				}
			}
		}
		else {
			$_SESSION["reg:errno"] = 4;
			header("Location: /ucp/register/");
		}
	}
}
else {
	header("Location: /ucp/main/");
}
?>

		<!-- END MAIN CONTENT -->