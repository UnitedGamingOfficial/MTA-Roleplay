<?php
error_reporting( 0 ) ;
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
$mQuery1 = mysql_query("SELECT `username`, `admin` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
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


?>
				<script language="JavaScript" type="text/javascript">
					<!--
					function checkform ( form )
					{
						if (form.message.value == "" || form.message.value == " ") {
							alert( "Please enter your message." );
							form.message.focus();
						//	return false ;
					//	}

						return true ;
					}
					//-->
				</script>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Ticket #<?php echo $_GET['view']; ?></h3>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
        <div class="three-fourth last">
        <div class="three-fourth notopmargin last">
<?php
	if(isset($_POST['ticket_reply']) && $_POST['ticket_reply'] == "Post Message")
	{
		$pt = 0;
		if(isset($_POST['post_type']))
		{
			$pt = mysql_real_escape_string($_POST['post_type']);
		}
		
		$mes = "none";
		if(isset($_POST['message']))
		{
			$mes = mysql_real_escape_string(htmlentities($_POST['message']));
		}
		
		$sid = mysql_real_escape_string($_GET['view']);
		$ip = $ip = $_SERVER['REMOTE_ADDR'];
		$time = time();
		
		$pc = mysql_query("INSERT INTO tc_comments(poster, ip, message, posted, type, ticket)VALUES('" . $userID . "', '" . $ip . "', '" . $mes . "', '" . $time . "', '" . $pt . "', '" . $sid . "')");
		if($pc)
		{
			$status = 1;
			if($admin > 1)
			{
				$status = 2;
			}

			if($pt == 0)
			{
				$ut = mysql_query("UPDATE tc_tickets SET lastpost='" . $time . "', status='" . $status . "' WHERE id='" . $sid . "' ");
			}
			if($ut)
			{
				echo('<script type="text/javascript">
					toastr.success("Your response has been recorded successfully.", "Message Posted!")
					</script>');
				if($pt != 1)
				$gpia3 = mysql_query("SELECT username,email FROM accounts WHERE id='" . $aadmin . "'", $MySQLConn);
				$gpi3 = mysql_fetch_array($gpia3);
				if(!empty($gpi['email']))
					{
				
					require_once("pages/tc/sendmail.php");
				
					}
			}
		}
	}
	function status($n)
	{
		$sN = array('New', 'Replied', 'Answered', 'Locked', 'Deleted');
		return $sN[$n];
	}

	$id = mysql_real_escape_string($_GET['view']);
	$gi = mysql_query("SELECT * FROM tc_tickets WHERE id='" . $id . "' AND status < 4");
	$gi = mysql_fetch_array($gi);

	if($admin <= 1)
	{
		if(!$gi)
		{
			echo('<script type="text/javascript">
					toastr.error("Invalid Ticket ID", "Error!")
					</script>');
		}else{
			if($userID == $gi['creator'])
			{
				echo('<h3>Ticket Information</h3><div class="dg"><table>
			<tr style="">
				<td width="30%" align="center" valign="middle"><b>Posted: ' .getNameFromUserID($gi['creator'], $MySQLConn) . '</b>
				<td width="30%" align="center" valign="middle"><b>Status: ' . status($gi['status']) . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Created: ' . date("n-j-Y", $gi['posted']) . '</b></td>
				<tr>
				<td width="30%" align="center" valign="middle"><b>Handler: ' . getNameFromUserID($gi['assigned'], $MySQLConn) . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Subject: ' . $gi['subject'] . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Last Post: ' . date("n-j-Y g:ia", $gi['lastpost']) . '</b></td>
			</tr>
			</table></div>');
				
			echo('<br /><br />
				<div style="border:1px solid #004ca1;">
					<div style="border-bottom:1px solid #004ca1;text-align:right;background: #004ca1;padding:4px;"><span style="float:left;color:#f2f2f2;">' . getNameFromUserID($gi["creator"], $MySQLConn) .'</span> <span style="color:#f2f2f2;">' . date("n-j-Y g:ia", $gi['posted']) . '</span></div>
					<div style="text-align:left;padding:4px;">' . nl2br($gi["message"]) . '</div>
				</div><br />');

			$sid = mysql_real_escape_string($_GET['view']);
			$com = mysql_query("SELECT * FROM tc_comments WHERE type = '0' AND ticket = '" . $sid . "'");
			
			$c0 = "#ccc";
			$c1 = "#0099ff";

			while($tm = mysql_fetch_array($com))
			{
				$rc = $c0;
				if($tm['uadmin'] == 1)
				{
					$rc = $c1;
				}
				echo('<div style="border:1px solid ' . $rc . '">
						<div style="border-bottom:1px solid '.$rc.';text-align:right;background: '.$rc.';padding:4px;"><span style="float:left;color:#3d3d3d;">' . getNameFromUserID($tm["poster"], $MySQLConn) .'</span> <span style="color:#3d3d3d;">' . date("n-j-Y g:ia", $tm['posted']) . '</span></div>
						<div style="text-align:left;padding:4px;">' . nl2br($tm["message"]) . '</div>
					</div><br />');
			}
			
			echo('<hr size="1" color="#0099ff" width="100%"><br/>');
			
			if($gi['status'] == 3)
			{
				echo('<script type="text/javascript">
					toastr.info("To reopen your ticket, simply submit a response", "Info!")
					</script>');
			}
			
			echo('<form name="ticket_reply" action="' . $PHP_SELF . '" method="POST" onsubmit="return checkform(this);">
				<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
					<tr>
						<td width="25%" align="left" valign="top"><label for="message">Message</label><textarea name="message" class="text-inputa" cols="35" rows="8" wrap="soft"></textarea><br /></td>
					</tr>
				</table>
				<input name="ticket_reply" type="submit" class="button" value="Post Message">
			</form>');
			}else{
				header("Location: /ticketcenter/main/");
			}
		}
	}else{
		if(!$gi)
		{
			echo("<script type=\"text/javascript\">
					toastr.error(\"Invalid Ticket ID\", \"Error!\")
					</script>");
		}else{
	if(isset($_POST['Do']))
	{
		$sid = mysql_real_escape_string($_GET['view']);
		$c = mysql_query("SELECT assigned FROM tc_tickets WHERE id='" . $sid . "'");
		$c = mysql_fetch_array($c);
		if(isset($_POST['assign_admin']) && $_POST['assign_admin'] != $c['assigned'])
		{
			$aadmin = mysql_real_escape_string($_POST['assign_admin']);
			$su = mysql_query("UPDATE tc_tickets SET assigned='" . $aadmin . "' WHERE id='" . $sid . "'");
			
			if($su)
			{
				echo("<script type=\"text/javascript\">
					toastr.success(\"Ticket has been updated\", \"Success!\")
					</script>");
					
				$gpia = mysql_query("SELECT username,email FROM accounts WHERE id='" . $aadmin . "'", $MySQLConn);
				$gpi = mysql_fetch_array($gpia);
				if(!empty($gpi['email']))
					{
				
				 $smtp = new SMTP($Config['SMTP']['hostname'], 465, true, 5);
				 $smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
				 $smtp->mail_from($Config['SMTP']['from']);

				 $smtp->send($gpi['email'], 'UnitedGaming Ticket Center - Ticket #'.$_GET["view"].' Assigned', 'Hi ' . $gpi['username'] . ',

Administrator '. $username .' assigned the following ticket to you:

Ticket URL: http://unitedgaming.org/ticketcenter/view/' . $_GET["view"] . '/

Remember to handle the ticket to the best of your abilities.

Kind Regards,
Chuevo');
		}

				$gpia2 = mysql_query("SELECT username,email FROM accounts WHERE id='" . $gi['creator'] . "'", $MySQLConn);
				$gpi2 = mysql_fetch_array($gpia2);
				if(!empty($gpi2['email'])) 
					{
					
				$smtp = new SMTP($Config['SMTP']['hostname'], 465, true, 5);
				$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
				$smtp->mail_from($Config['SMTP']['from']);

				$smtp->send($gpi2['email'], 'UnitedGaming Ticket Center - Ticket #'.$_GET["view"].' Assigned', 'Hi ' . $gpi2['username'] . ',

Administrator '.$gpi['username'].' has been assigned to your ticket. Please wait and give them time to respond.

Ticket URL: http://unitedgaming.org/ticketcenter/view/' . $_GET["view"] . '/

Kind Regards,
Chuevo');
				}
			}
		}
		
		if(isset($_POST['admin_action']))
		{
			if($_POST['admin_action'] == 1)
			{
				$su = mysql_query("UPDATE tc_tickets SET status='0' WHERE id='" . $sid . "'");
				
				if($su)
					echo("<script type=\"text/javascript\">
					toastr.success(\"Ticket status set to; <b>New</b>\", \"Ticket Updated!\")
					</script>");

			}elseif($_POST['admin_action'] == 2){
				$su = mysql_query("UPDATE tc_tickets SET status='3' WHERE id='" . $sid . "'");

				
				if($su)
				{

					echo("<script type=\"text/javascript\">
					toastr.info(\"Ticket status set to; <b>Closed</b>\", \"Ticket Updated!\")
					</script>");
					// send mail
					$gpia = mysql_query("SELECT username,email FROM accounts WHERE id='" . $gi['creator'] . "'", $MySQLConn);
					$gpi = mysql_fetch_array($gpia);
					if(!empty($gpi['email'])) 
					{
						$smtp = new SMTP($Config['SMTP']['hostname'], 465, true, 5);
						$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
						$smtp->mail_from($Config['SMTP']['from']);

						$smtp->send($gpi['email'], 'Ticket #'.$_GET["view"].' Closed - UnitedGaming Ticket Center', 'Hi ' . $gpi['username'] . ',

Your ticket, #'.$_GET["view"].', has been closed.

Ticket URL: http://unitedgaming.org/ticketcenter/view/' . $_GET["view"] . '/

If you do not feel like the ticket has been properly handled or resolved, you may either reply to that ticket or contact Head of Administration directly. 

Kind Regards,
Chuevo');
					}
				}
			}elseif($_POST['admin_action'] == 3){
				$del = mysql_query("UPDATE tc_tickets SET status='1' WHERE id='" . $sid . "'");
				
				if($del)
					echo("<script type=\"text/javascript\">
					toastr.info(\"Ticket has been not been deleted.\", \"Nice try, faggot.\")
					</script>");
			}
		}
	}

			echo('<h3>Ticket Information</h3><div class="dg"><table>
			<tr style="">
				<td width="30%" align="center" valign="middle"><b>Posted: ' .getNameFromUserID($gi['creator'], $MySQLConn) . '</b>
				<td width="30%" align="center" valign="middle"><b>Status: ' . status($gi['status']) . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Created: ' . date("n-j-Y", $gi['posted']) . '</b></td>
				<tr>
				<td width="30%" align="center" valign="middle"><b>Handler: ' . getNameFromUserID($gi['assigned'], $MySQLConn) . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Subject: ' . $gi['subject'] . '</b></td>
				<td width="30%" align="center" valign="middle"><b>Last Post: ' . date("n-j-Y g:ia", $gi['lastpost']) . '</b></td>
			</tr>
			</table></div>
		
			<table border="0" align="right"><tr align="right"><td align="right"><form name="ticket_action" action="' . $PHP_SELF . '" method="POST">
			<select name="assign_admin">
					<option value="-1" disabled selected>Assign Admin...</option>');
				$ga = mysql_query("SELECT `id`,`username` FROM accounts WHERE admin >= '1' ORDER BY username ASC");
				while($as = mysql_fetch_array($ga))
				{
					?>
						<option value="<?php echo $as["id"]; ?>"  <?php if($as['id'] == $gi['assigned']){ echo("selected"); }?>><?php echo $as["username"]; ?></option>
					<?php

				}
				echo('</select>
				<select name="admin_action">
					<option value="" disabled selected>Action...</option>
					<option value="1">Open</option>
					<option value="2">Lock</option>
					<option value="3">Delete</option>
				</select>
				<input name="Do" type="submit" class="button" value="Update Ticket">
				</form></td></tr></table><br /><br />
			');
			
			$sid = mysql_real_escape_string($_GET['view']);
			$in = mysql_query("SELECT * FROM tc_comments WHERE type = '1' AND ticket = '" . $sid . "'");

			echo('<h4><span style="color:orange">Internal Notes</span> (Admin Only)</h4>
			<center><table width="98%" border="0" align="center">');
			
			while($sin = mysql_fetch_array($in))
			{
				echo('<tr><td><div style="border:1px solid #0099ff;">
						<div style="border-bottom:1px solid #0099ff;text-align:right;background: #0099ff;padding:4px;"><span style="float:left;color:#333;">' . getNameFromUserID($sin['poster'], $MySQLConn) . '</span><span style="color:#333;"> ' . date("n-j-Y g:ia", $sin['posted']) . '</span></div>
						<div style="text-align:left;padding:4px;">' . stripslashes(nl2br($sin["message"])) . '</div>
					</div></td></tr>');
			}

			echo('</table></center>
			<h4 class="colored">Replies</h4>
			<div style="border:1px solid #b3b3b3;">
				<div style="border-bottom:1px solid #ccc;text-align:right;background: #ccc;padding:4px;"><span style="float:left;color:#333;">' . getNameFromUserID($gi['creator'], $MySQLConn) .', IP: ' . $gi["IP"] . '</span> <span style="color:#333;">' . date("n-j-Y g:ia", $gi['posted']) . '</span></div>
				<div style="text-align:left;padding:4px;">' . stripslashes(nl2br($gi["message"])) . '</div>
			</div><br />
			');

			$com = mysql_query("SELECT * FROM tc_comments WHERE type = '0' AND ticket = '" . $sid . "'");
			
			$c0 = "#ccc";
			$c1 = "#0099ff";
			$rc = $c1;
			
			while($tm = mysql_fetch_array($com))
			{
				$ip = $tm['ip'];
				$rc = $c0;
				if($tm['uadmin'] == 1)
				{
					$rc = $c1;
					$ip = "";
				}

				echo('<div style="border:1px solid ' . $rc . ';">
						<div style="border-bottom:1px solid ' . $rc . ';text-align:right;background: ' . $rc . ';padding:4px;"><span style="float:left;color:#333;">' . getNameFromUserID($tm["poster"], $MySQLConn) .', IP: ' . $ip . '</span> <span style="color:#333;">' . date("n-j-Y g:ia", $tm['posted']) . '</span></div>
						<div style="text-align:left;padding:4px;">' . stripslashes(nl2br($tm["message"])) . '</div>
					</div><br />');
			}
			
			echo('<hr size="1" color="#0099ff" width="100%"><br/><br/>');
			echo('<form name="ticket_reply" action="' . $PHP_SELF . '" method="POST" onsubmit="return checkform(this);">
				<table width="100%" align="center" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
					<tr>
					<td width="100%" align="left" valign="top"><label for="message">Message</label><textarea name="message" cols="100%" rows="8" class="text-inputa" wrap="soft"></textarea><br /></td>
					</tr>
				
				<tr>
				<td><select name="post_type">
						<option value="0">Reply</option>
						<option value="1">Internal Post</option>
				</select>
				<input name="ticket_reply" type="submit" class="button" value="Post Message">
				</td>
				</tr>
				</table>
			</form>');
		}
	}
?>    
        </div>
        </div>
       