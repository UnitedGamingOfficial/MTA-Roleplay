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

				<div id="content-middle">
					<div class="content-box">
						<div class="content-holder">
							<h2>Ticket Center - Viewing Ticket #<?php echo $_GET['view']; ?></h2>
							<div style="text-align:center;">								
								<?php
									if(isset($_POST['ticket_reply']) && $_POST['ticket_reply'] == "Post")
									{
										$pt = 0;
										if(isset($_POST['post_type']))
										{
											$pt = mysql_real_escape_string($_POST['post_type']);
										}
										
										$mes = "no message";
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
												echo("<p>Your message has been posted!</p>");
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
										$sN = array('New', 'Replied', 'Answered', 'Closed', 'Deleted');
										return $sN[$n];
									}

									$id = mysql_real_escape_string($_GET['view']);
									$gi = mysql_query("SELECT * FROM tc_tickets WHERE id='" . $id . "' AND status < 4");
									$gi = mysql_fetch_array($gi);

									if($admin <= 0)
									{
										if(!$gi)
										{
											echo("<p>Invalid Ticket ID!</p>");
										}else{
											if($userID == $gi['creator'])
											{
												echo('<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
												<tr style="border-top: 1px solid #FF6600;">
													<td width="10%" align="left" valign="top"><b>Posted:</b></td>
													<td width="40%" align="left" valign="top">' . getNameFromUserID($gi['creator'], $MySQLConn) . '</td>
													<td width="10%" align="left" valign="top"><b>Status:</b></td>
													<td width="40%" align="left" valign="top"><img src="/images/tc/' . $gi['status'] . '.png" />' . status($gi['status']) . '</td>
												</tr>
												<tr>
													<td width="10%" align="left" valign="top"><b>Created:</b></td>
													<td width="40%" align="left" valign="top">' . date("n-d-Y", $gi['posted']) . '</td>
													<td width="10%" align="left" valign="top"><b>Assigned:</b></td>
													<td width="40%" align="left" valign="top">' . getNameFromUserID($gi['assigned'], $MySQLConn) . '</td>
												</tr>
												<tr style="border-bottom: 1px solid #FF6600;">
													<td width="10%" align="left" valign="top"><b>Subject:</b></td>
													<td width="40%" align="left" valign="top">' . $gi['subject'] . '</td>
													<td width="15%" align="left" valign="top"><b>Last Post:</b></td>
													<td width="40%" align="left" valign="top">' . date("n-d-Y g:ia", $gi['lastpost']) . '</td>
												</tr>
												</table>');
												
											echo('<br /><br />
												<div style="border:1px solid #3D3D3D;">
													<div style="border-bottom:1px solid #3d3d3d;text-align:right;background: #3d3d3d;padding:2px;">By: ' . getNameFromUserID($gi["creator"], $MySQLConn) . ' On: ' . date("n-j-Y g:ia", $gi['posted']) . '</div>
													<div style="text-align:left;padding:2px;">' . nl2br($gi["message"]) . '</div>
												</div><br />');

											$sid = mysql_real_escape_string($_GET['view']);
											$com = mysql_query("SELECT * FROM tc_comments WHERE type = '0' AND ticket = '" . $sid . "'");
											
											$c0 = "#3d3d3d";
											$c1 = "#FF6600";

											while($tm = mysql_fetch_array($com))
											{
												$rc = $c0;
												if($tm['uadmin'] == 1)
												{
													$rc = $c1;
												}
												echo('<div style="border:1px solid ' . $rc . '">
														<div style="border-bottom:1px solid ' . $rc . ';text-align:right;background: ' . $rc . ';padding:2px;">By: ' . getNameFromUserID($tm["poster"], $MySQLConn) . ' On: ' . date("n-j-Y g:ia", $tm['posted']) . '</div>
														<div style="text-align:left;padding:2px;">' . nl2br($tm["message"]) . '</div>
													</div><br />');
											}
											
											echo('<hr size="1" color="#FF6600" width="75%">');
											
											if($gi['status'] == 3)
											{
												echo('<p>To reopen your ticket, just reply using the form below.</p>');
											}
											
											echo('<form name="ticket_reply" action="' . $PHP_SELF . '" method="POST" onsubmit="return checkform(this);">
												<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
													<tr>
														<td width="25%" align="right" valign="top">Message:</td>
														<td width="25%" align="left" valign="top"><textarea name="message" cols="35" rows="8" wrap="soft"></textarea><br /></td>
													</tr>
												</table>
												<input name="ticket_reply" type="submit" value="Post">
											</form>');
											}else{
												header("Location: /ticketcenter/main/");
											}
										}
									}else{
										if(!$gi)
										{
											echo("<p>Invalid Ticket ID!</p>");
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
												echo("<p>Ticket Updated!</p>");
													
												$gpia = mysql_query("SELECT username,email FROM accounts WHERE id='" . $aadmin . "'", $MySQLConn);
												$gpi = mysql_fetch_array($gpia);
												if(!empty($gpi['email']))
													{
												
												 $smtp = new SMTP($Config['SMTP']['hostname'], 465, false, 5);
												 $smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
												 $smtp->mail_from($Config['SMTP']['from']);

												 $smtp->send($gpi['email'], 'MTA:RP MTA Ticket Center - Ticket #'.$_GET["view"].' Assigned', 'Hello ' . $gpi['username'] . ',

You are receiving this e-mail because '. $username .' assigned the following ticket to you:

Ticket URL: http://mtaroleplay.com/ticketcenter/view/' . $_GET["view"] . '/

Kind Regards,
The Multi Theft Auto Roleplay Administration Team');
										}

												$gpia2 = mysql_query("SELECT username,email FROM accounts WHERE id='" . $gi['creator'] . "'", $MySQLConn);
												$gpi2 = mysql_fetch_array($gpia2);
												if(!empty($gpi2['email'])) 
													{
													
												$smtp = new SMTP($Config['SMTP']['hostname'], 465, false, 5);
												$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
												$smtp->mail_from($Config['SMTP']['from']);

												$smtp->send($gpi2['email'], 'MTA:RP MTA Ticket Center - Ticket #'.$_GET["view"].' Assigned', 'Hello ' . $gpi2['username'] . ',

You are receiving this e-mail because an admin assigned '.$gpi['username'].' to your ticket. Please wait for a message from him/her.

Ticket URL: http://mtaroleplay.com/ticketcenter/view/' . $_GET["view"] . '/

Kind Regards,
The Multi Theft Auto Roleplay Administration Team');
												}
											}
										}
										
										if(isset($_POST['admin_action']))
										{
											if($_POST['admin_action'] == 1)
											{
												$su = mysql_query("UPDATE tc_tickets SET status='0' WHERE id='" . $sid . "'");
												
												if($su)
													echo("<p>Ticket Updated! Status set to: <b>Opened/New</b>.</p>");

											}elseif($_POST['admin_action'] == 2){
												$su = mysql_query("UPDATE tc_tickets SET status='3' WHERE id='" . $sid . "'");

												
												if($su)
												{

													echo("<p>Ticket Updated! Status set to: <b>Closed</b>.</p>");
													// send mail
													$gpia = mysql_query("SELECT username,email FROM accounts WHERE id='" . $gi['creator'] . "'", $MySQLConn);
													$gpi = mysql_fetch_array($gpia);
													if(!empty($gpi['email'])) 
													{
														$smtp = new SMTP($Config['SMTP']['hostname'], 465, false, 5);
														$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
														$smtp->mail_from($Config['SMTP']['from']);

														$smtp->send($gpi['email'], 'Ticket #'.$_GET["view"].' Closed - MTA:RP MTA Ticket Center', 'Hello ' . $gpi['username'] . ',

You are receiving this e-mail because an Admin has closed your ticket. You can view the ticket at the following location:

Ticket URL: http://mtaroleplay.com/ticketcenter/view/' . $_GET["view"] . '/

If you don\'t think that the ticket is properly resolved, you can reply in the ticket to re-open it. 

Kind Regards,
The Multi Theft Auto Roleplay Administration Team');
													}
												}
											}elseif($_POST['admin_action'] == 3){
												$del = mysql_query("UPDATE tc_tickets SET status='4' WHERE id='" . $sid . "'");
												
												if($del)
													echo("<p>Ticket Deleted!<br /><br />");
											}
										}
									}
								
											echo('<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
											<tr style="border-top: 1px solid #FF6600;">
												<td width="10%" align="left" valign="top"><b>Posted:</b></td>
												<td width="40%" align="left" valign="top">' .getNameFromUserID($gi['creator'], $MySQLConn) . '</td>
												<td width="10%" align="left" valign="top"><b>Status:</b></td>
												<td width="40%" align="left" valign="top"><img src="/images/tc/' . $gi['status'] . '.png" />' . status($gi['status']) . '</td>
											</tr>
											<tr>
												<td width="10%" align="left" valign="top"><b>Created:</b></td>
												<td width="40%" align="left" valign="top">' . date("n-j-Y", $gi['posted']) . '</td>
												<td width="10%" align="left" valign="top"><b>Assigned:</b></td>
												<td width="40%" align="left" valign="top">' . getNameFromUserID($gi['assigned'], $MySQLConn) . '</td>
											</tr>
											<tr style="border-bottom: 1px solid #FF6600;">
												<td width="10%" align="left" valign="top"><b>Subject:</b></td>
												<td width="40%" align="left" valign="top">' . $gi['subject'] . '</td>
												<td width="15%" align="left" valign="top"><b>Last Post:</b></td>
												<td width="40%" align="left" valign="top">' . date("n-j-Y g:ia", $gi['lastpost']) . '</td>
											</tr>
											</table>
											<form name="ticket_action" action="' . $PHP_SELF . '" method="POST">
											<p>Assign To:
												<select name="assign_admin">
													<option value="-1"></option>');
												$ga = mysql_query("SELECT `id`,`username` FROM accounts WHERE admin >= '1' ORDER BY username ASC");
												while($as = mysql_fetch_array($ga))
												{
													?>
														<option value="<?php echo $as["id"]; ?>"  <?php if($as['id'] == $gi['assigned']){ echo("selected"); }?>><?php echo $as["username"]; ?></option>
													<?php

												}
												echo('</select>
											&nbsp;&nbsp; 
											Admin Action:
												<select name="admin_action">
													<option value=""></option>
													<option value="1">Open</option>
													<option value="2">Close</option>
													<option value="3">Delete</option>
												</select>
											&nbsp;&nbsp; 
											<input name="Do" type="submit" value="Do">
											</form>
											</p>');
											
											$sid = mysql_real_escape_string($_GET['view']);
											$in = mysql_query("SELECT * FROM tc_comments WHERE type = '1' AND ticket = '" . $sid . "'");

											echo('<p style="text-align:left;">Internal Notes:</p>');
											
											while($sin = mysql_fetch_array($in))
											{
												echo('<div style="border:1px solid #FF6600;">
														<div style="border-bottom:1px solid #FF6600;text-align:right;background: #FF6600;padding:2px;">By: ' . getNameFromUserID($sin['poster'], $MySQLConn) . ' On: ' . date("n-j-Y g:ia", $sin['posted']) . '</div>
														<div style="text-align:left;padding:2px;">' . stripslashes(nl2br($sin["message"])) . '</div>
													</div>');
											}

											echo('<p style="text-align:left;">Replies:</p>
											<div style="border:1px solid #3D3D3D;">
												<div style="border-bottom:1px solid #3d3d3d;text-align:right;background: #3d3d3d;padding:2px;"><span style="float:left;">IP: ' . $gi["IP"] . '</span>By: ' . getNameFromUserID($gi['creator'], $MySQLConn) . ' On: ' . date("n-j-Y g:ia", $gi['posted']) . '</div>
												<div style="text-align:left;padding:2px;">' . stripslashes(nl2br($gi["message"])) . '</div>
											</div><br />
											');

											$com = mysql_query("SELECT * FROM tc_comments WHERE type = '0' AND ticket = '" . $sid . "'");
											
											$c0 = "#3D3D3D";
											$c1 = "#FF6600";
											$rc = $c1;
											
											while($tm = mysql_fetch_array($com))
											{
												$ip = '<span style="float:left;">IP: ' . $tm['ip'] . '</span>';
												$rc = $c0;
												if($tm['uadmin'] == 1)
												{
													$rc = $c1;
													$ip = "";
												}

												echo('<div style="border:1px solid ' . $rc . ';">
														<div style="border-bottom:1px solid ' . $rc . ';text-align:right;background: ' . $rc . ';padding:2px;">' . $ip . 'By: ' . getNameFromUserID($tm["poster"], $MySQLConn) . ' On: ' . date("n-j-Y g:ia", $tm['posted']) . '</div>
														<div style="text-align:left;padding:2px;">' . stripslashes(nl2br($tm["message"])) . '</div>
													</div><br />');
											}
											
											echo('<hr size="1" color="#FF6600" width="75%">');
											echo('<form name="ticket_reply" action="' . $PHP_SELF . '" method="POST" onsubmit="return checkform(this);">
												<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
													<tr>
														<td width="25%" align="right" valign="top">Post Type:</td>
														<td width="25%" align="left" valign="top">
															<select name="post_type">
																<option value="0">Reply</option>
																<option value="1">Internal Post</option>
															</select>
														</td>
													</tr>
													<tr>
														<td width="25%" align="right" valign="top">Message:</td>
														<td width="25%" align="left" valign="top"><textarea name="message" cols="35" rows="8" wrap="soft"></textarea><br /></td>
													</tr>
												</table>
												<input name="ticket_reply" type="submit" value="Post">
											</form>');
										}
									}
								?>
							</div>
						</div>
					</div>
				</div>