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
$mQuery1 = mysql_query("SELECT `username`, `admin`,`banned`,`banned_by`,`banned_reason` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
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
$admin = $userRow['admin'];

$isBanned = $userRow['banned'];
if ($isBanned)
{
	$isBannedBy = $userRow['banned_by'];
	$isBannedReason = $userRow['banned_reason'];
}
else {
	$isBannedBy ='';
	$isBannedReason='';
}
if(isset($_POST['message']) && strlen($_POST['message']) > 5)
{
	$sub = mysql_real_escape_string( htmlentities( $_POST['subject'] ) );
	$mes = mysql_real_escape_string( htmlentities( $_POST['message'] ) );
	
	$ci = mysql_query("SELECT id FROM tc_tickets WHERE subject = '" . $sub . "' AND message = '" . $mes . "'", $MySQLConn);
	$count = mysql_num_rows($ci);
	if($count > 0)
	{
		$existsRow = mysql_fetch_assoc($ci);
		Header("Location: /ticketcenter/view/".$existsRow['id']."/");
		die();
	}
	else
	{
		$ip = $_SERVER['REMOTE_ADDR'];
		$time = time();
		$make = mysql_query("INSERT INTO tc_tickets(creator, posted, subject, message, status, lastpost, assigned, IP)VALUES('" . $userID . "', '" . $time . "', '" . $sub . "', '" . $mes . "', '0', '" . $time . "', -1, '" . $ip . "')");
		if($make)
		{
			$getid = mysql_insert_id();
			Header("Location: /ticketcenter/view/".$getid."/");
			die();
		}
		else
		{
			echo mysql_error();
		}
	}
}
else {

?>


        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Ticket Center</h3>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth last">
        <div class="three-fourth notopmargin last">
            <form name="create_ticket" action="<?php $PHP_SELF; ?>" method="post">
	<?php
	if (!isset($_POST['type']) OR $_POST['type'] == 'none')
	{
	?>			
				<center>
					<h2>Ticket Type</h2>
				<br />
					<label>
						<select name="type" onChange='document.create_ticket.submit();' >
							<option selected value="-1">Select Ticket Type...</option>
							<option value="account">Account Issue</option>
							<option value="report_admin">Report Admin</option>
							<option value="report_player">Report Player</option>
							<option value="unban">Unban Request</option>
							<option value="script">Script Issue/Report a Bug</option>
							<option value="other">Other</option>
						</select>
					</label>

				</center>
		<?php
	}
	else {
		$subject = '';
		$msg = '';
		if(!empty($postedhint)){
			$postedhint = "Provide as much detail as you can to ensure administrators may help you to the fullest.";
		} else {
			$postedhint = "Provide as much detail as you can to ensure administrators may help you to the fullest.";
		}
		$type = $_POST['type'];
		if ($type == 'account')
		{
			$postedhint = "Provide as much detail as you can to ensure administrators may help you to the fullest.";
			$subject = 'Account Issue';
			$msg = "My Username: ".$username." 
Issue Occurring: ";
		} elseif ($type == 'report_admin')
		{
			$subject = 'Admin Report - [admin]';
			$msg = "My username: ".$username."
Admin(s) you are reporting: 
Date and Time of the incident(s):
What transpired: 
					
Evidence that supports you (screenshots, logs files, other persons): ";
		} elseif ($type == 'report_player')
		{
			$subject = 'Player Report - [player]';
			$msg = "My username: ".$username."
Player(s) you are reporting: 
Date and Time of the incident(s): 
What transpired: 

Evidence that supports you (screenshots, log files, other persons): ";
		} elseif ($type == 'unban')
		{
			$subject = 'Unban Request - Ban By: '.$isBannedBy.'';
			$msg = "My Username: ".$username."
Character I was banned on: 
Date of Ban: 
Banned By: ".$isBannedBy."
Banned Reason: ".$isBannedReason."

In vast detail, explain why you should be unbanned: 

Evidence that supports you (screenshots, log files, other persons): ";		
		} elseif ($type=='script')
		{
			$subject = 'Script Issue';
			$msg = "Your username: ".$username."
Character this occurred on: 
What Happens: 
How is it produced/can you reproduce it? How: ";			
		}
?>
	<h2 align="center">Composing Ticket</h2>
	<table align="center" border="0">
    <tr>
    <td align="center" valign="middle"><span style="font-weight:bold;color:#333;font-family: 'Didact Gothic', sans-serif;"><?php echo $postedhint;?></span><br /><br/></td>
    </tr>
    <tr>
		<td>
		<label for="subject">Subject</label><input type="text" style="font-size: 12px;" class="text-inputa" name="subject" size="60" value="<?php echo $subject; ?>"/></td></tr>
	<tr>
		<td>
		<label for="message">Message</label><textarea name="message" class="text-inputa" cols="90%" rows="10" wrap="soft"><?php echo $msg; ?></textarea><br /></td></tr>
<tr align="right"><td>
		<input type="submit" class="button" value="Submit Ticket" />
</td></tr></table>
<?php
	}
?>
</form>

<?php
}
?>

        </div></div>
		<!-- END MAIN CONTENT -->