<?php
include("auth.php");
  
// check to see if login form has been submitted
if(isset($_POST['username'])){
	// run information through authenticator
	if($result = register($_POST['username'],$_POST['userPassword']))
	{
		// authentication passed
		print("$result");
	} else {
		// authentication failed
		$error = 1;
	}
}
 
// output error to user
if(isset($error)) echo "<br>Register Failed, something dun fucked up<br /-->";
?>
 
 It looks like shit but it works (I think)
 Wait ~30 after account creation before usage.
<form action="register.php" method="post">
	User: <input type="text" name="username" /><br />
	Password: <input type="password" name="userPassword" />
	<input type="submit" name="submit" value="Submit" />
</form>