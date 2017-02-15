 <?php 
 
 $MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
if (!$MySQLConn) {
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
}
$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

 if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	$_SESSION['returnurl_login'] = "/account/dev/";
	header("Location: /ucp/login/");
	die();
}
 
 //First off; Kick anyone who's not $codeblue (defined in Global)
 # No worries, we go a step further in the form to authorize the level set, because Chase cares about security.
 $susername = $_SESSION['ucp_username'];
 $f_password = "V3YFlUjXU0s3F4AEK4aB";
  if (!$susername == $codeblue){
	 	 Header ("Location: /logout/");
 }


 if (!isset($_POST['dev-password'])){
 ?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h1 class="welcome nobottommargin left">Developer Mode</h1>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
        <div class="one separator  margin15"></div>
        <div class="one nottopmargin">
        <table border="0">
        <tr>
        <td align="left" valign="middle" width="30%">
       <p>To enter developer mode, you must enter the 20 digit password.<br/>Note: Your new level will be set to 8.</p>
        <form name="devmode" action="" method="post">
        	<input type="password" class="text-input" maxlength="20" name="dev-password"/><label for="dev-password">Password</label>
            <br/>
            <input type="submit" class="button2" name="makedev" value="Submit">
       
        </td>
        <td align="center" valign="middle" width="50%">
       <? if($adminLevel == "8"){?> <h1 class="cheeky">Active</h1><br/><a href="/account/remove-dev/" class="link">Remove Developer Mode</a><?php }else{ ?>
       <h1 class="xcheeky">Inactive</h1>
       <?php } ?>
        </td>
        </tr>
        </table>
        </div>
        
        


<?php
 } else {
	 if($_POST['dev-password']==$f_password){
	 $whatwedo = mysql_query("SELECT `admin` FROM `accounts` WHERE `id`='" . $_SESSION['ucp_userid'] . "' LIMIT 1", $MySQLConn);
	 
	 mysql_query("UPDATE `accounts` SET `admin`='8' WHERE `id`='".$_SESSION['ucp_userid']."' LIMIT 1", $MySQLConn);
	 				echo('<script type="text/javascript">
					toastr.success("You have successfully activated Developer Mode on your account, please remember to remove this by the end of the day.", "Dev Mode Active")
					</script>');
	 }
	 else
	 {
		 	 				echo('<script type="text/javascript">
					toastr.error("Action could not be completed.", "Incorrect Password")
					</script>');
	 }
 }

 

 ?>
 </form>