 <?php
  if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	$_SESSION['returnurl_login'] = "/account/email/";
	header("Location: /ucp/login/");
	die();
}

if (empty($_SESSION['ucp_email'])){

$userID = $_SESSION['ucp_userid'];

$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);

 //	They are smart, and update their email.
 if (!isset($_POST['email']))
 {


 

 ?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h1 class="welcome nobottommargin left">Account Security</h1>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
        <div class="one separator  margin15"></div>
        <div class="one-half notopmargin">
        
        <h3>No email address on file!</h3>
        <p>Your email is used to recover your password in the chance of losing access to your account. Please update your email to the right.</p>
        <p class="small-italic">We will not force you to add an email address, however, <font color="red">we will no longer be recovering accounts manually</font>, when you can have it recovered with your email.<br/>In the chance you do lose access to your account, nothing can be done on our end.</p><p>Thanks for understanding,<br/><font style="font-weight:bold;">Management</font>.</strong></p>
		
        </div>
        <div class="one-half notopmargin last">
        <h3>Information</h3><br/>
        <form action="" method="post">
        <input type="email" name="email" maxlength="132" class="text-inputl"/><label for="email">Valid Email Address</label>
        <input type="submit" class="button" value="Update Account Information" align="right"/> <a href="/ucp/main/" class="link">Later</a>
        <p class="small-italic">Warning: If you enter an invalid/fake email address now, you will not be able to change it in the future.</p>
        </form>
        </div>
		<!-- END MAIN CONTENT -->
        
        <?php 
		
 }else { if (empty($_POST['email'])){
		 header("Location: /account/email/#false");
		 echo("<script type=\"text/javascript\">
					toastr.info(\"That's not an email, try again\", \"Umm...\")
					</script>");
	 } else {
			mysql_query("UPDATE `accounts` SET `email`='".mysql_real_escape_string($_POST['email'])."' WHERE `id`='".$userID."'", $MySQLConn);
			$_SESSION['security_updated:email'] = 1;
			header("Location: /ucp/main/#secure");
	 }
}
} else {
	header("Location: /ucp/main/");
}
?>