if(isset($_POST['form']) && $_POST['form'] == "true")
									{
										$tid = $_POST['delete_ticket'];
										if($tid > 0)
										{
											$count = mysql_query("SELECT * FROM tc_tickets");
											$count = mysql_num_rows($count);

											for($i=0;$i<$count;$i++)
											{
												$del_id = $_POST['delete_ticket'][$i];
												$del = mysql_query("UPDATE tc_tickets SET status='4' WHERE id='" . mysql_real_escape_string( $del_id) . "'");
											}
											
											if($del)
											{
												echo("Tickets were successfully deleted!<br /><br />");
											}
										}
									}
									
									if($_GET['view'] == "closed")
									{
										$tickets = mysql_query("SELECT * FROM tc_tickets WHERE status = '3' ORDER BY lastpost DESC");
									}elseif($_GET['view'] == "assigned"){
										$tickets = mysql_query("SELECT * FROM tc_tickets WHERE (assigned = '" . mysql_real_escape_string($userID) . "' OR creator = '" . mysql_real_escape_string($userID ). "') AND status < '3' ORDER BY lastpost ASC");
									}else{
										$tickets = mysql_query("SELECT * FROM tc_tickets WHERE status < '3' ORDER BY lastpost ASC");
									}
									$count = mysql_num_rows($tickets);
									
									function status($n)
									{
										$sN = array('New', 'Replied', 'Answered', 'Closed');
										return $sN[$n];
									}
									
									if($count == 0)
									{
										echo("<center>There are currently 0 tickets posted.</center>");
									}else{
										$c1 = "#000000";
										$c2 = "#000000";
										$row_count = 0;
										echo('<form name="delete_button" action="' . $PHP_SELF . '" method="POST">
										<table width="100%" border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse;">
										<tr style="	border-top: 1px solid #FF6600;border-bottom: 1px solid #FF6600;">
											<td width="5%" valign="top">ID</td>
											<td width="15%" valign="top">Reporter</td>
											<td width="15%" valign="top">Assigned</td>
											<td width="20%" valign="top">Subject</td>
											<td width="20%" valign="top">Posted On</td>
											<td width="20%" valign="top">Status</td>
											<td width="5%" valign="top">Delete</td>
										</tr>');
										while($s = mysql_fetch_array($tickets))
										{
											$date = date('m-d-Y', $s['posted']);
											$rc = ($row_count % 2) ? $c1 : $c2;
											?>
											<tr>
												<td width="5%" valign="top" bgcolor="<?php echo $rc; ?>"><a href="/ticketcenter/view/<?php echo $s['id']; ?>/">#<?php echo $s['id']; ?></a></td>
												<td width="15%" valign="top" bgcolor="<?php echo $rc; ?>"><a href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo getNameFromUserID($s['creator'], $MySQLConn); ?></a></td>
												<td width="15%" valign="top" bgcolor="<?php echo $rc;?>/"><?php echo getNameFromUserID($s['assigned'], $MySQLConn); ?></a></td>
												<td width="20%" valign="top" bgcolor="<?php echo $rc; ?>"><a href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo $s['subject']; ?></a></td>
												<td width="20%" valign="top" bgcolor="<?php echo $rc; ?>"><a href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo $date; ?></a></td>
												<td width="20%" valign="top" bgcolor="<?php echo $rc; ?>"><img src="/images/tc/<?php echo $s['status']; ?>.png" alt="<?php echo status($s['status']); ?>" /><a href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo status($s['status']); ?></a></td>
												<td width="5/%" valign="top" bgcolor="<?php echo $rc; ?>"><input type="checkbox" name="delete_ticket[]" id="delete_ticket[]" value="<?php echo $s['id']; ?>"></td>
											</tr>
											<?php
											$row_count++;
										}
										echo('</table><br />
										<input name="form" type="hidden" id="form" value="true">
										<p style="text-align:right;"><a href="#" onclick="document[\'delete_button\'].submit()">Delete Selected Tickets</a></span></form>');
									}
								}
							?>