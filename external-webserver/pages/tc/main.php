<?php
if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	$_SESSION['returnurl_login'] = '/ticketcenter/main/';
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

$tickets = mysql_query("SELECT * FROM tc_tickets WHERE creator='".$userID."'");
$count = mysql_num_rows($tickets);

$mytickets = mysql_query("SELECT * FROM tc_tickets WHERE (assigned = '" . mysql_real_escape_string($userID) . "' OR creator = '" . mysql_real_escape_string($userID ). "') AND status < '3'");
?>


        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Ticket Center</h3>
			<?php if($admin <= 0){?>
            <p class="left description "><?php echo $global['TC']['PlayerMsg']; ?></p>
			<?php } else { ?>
				<p class="left description "><?php echo $global['TC']['AdminMsg']; ?></p>
			<?php } ?>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
        <div class="three-fourth last">
        <div class="three-fourth notopmargin last">
        <script type="text/javascript">
function DoNav(url)
{
   document.location.href = url;
}
</script>
				<?php if($adminLevel == 1){?>
                <p align="center">You are currently suspended, and do not have access to administrating tickets</p>
                <?php }?>
				<?php  if($admin <=1){?>
				
            	<h3 class=" notopmargin">Opening a Ticket</h3>
            	<p>Administrators are here to help you in every way they can. When making a ticket, please provide all information necessary along with a clear statement in your ticket. Keep in mind aswell, using provocative language in a ticket will not support your case. Speaking clear English, and correct grammar/puncuation will also support you in the long run.</p>
            </div>
				<?php } ?>
				<?php  if($admin <=1){?>
					<div class="three-fourth left last">
            	<h3 class=" notopmargin colored">My Tickets</h3>
				<?php if($count == 0){ ?>
				<p>All tickets you make will show here.</p>
				<?php } else { ?>
            	<p>All tickets you have made show here. To re-open a closed ticket, select the ticket below and make a reply.</p>
				<?php } ?>
            </div>
<?php

function status($n)
{
	$sN = array('New', 'Responded', 'Answered', 'Locked', 'Deleted');
	return $sN[$n];
}

if($count == 0)
{
	echo("<center>You haven't created any tickets.</center>");
}else{
	$x = 0;
while($s = mysql_fetch_array($tickets))
{
echo("<a href='/ticketcenter/view/" . $s['id'] . "/'>#" . $s['id'] . " - " . $s['subject'] . "</a> (" . status($s['status']) . ")");
		
++ $x;
if($x < $count)
{
echo("<br/>");
}
}
}


?>
				<?php  } else { /*ADMIN*/?>
				
				
				
	<?php			
				if(isset($_POST['form']) && $_POST['form'] == "true" && $adminLevel >= 6) 
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
					echo('<script type="text/javascript">
					toastr.success("Selected Ticket(s) have been deleted.", "Successful!")
					</script>');
				}
			}
		}
		

		if($_GET['view'] == "locked")
		{
			echo("<center><h3>" . $global['TC']['Header']['Locked'] . "</center></h3>");
			$tickets = mysql_query("SELECT * FROM tc_tickets WHERE status = '3' ORDER BY lastpost DESC");
		}elseif($_GET['view'] == "assigned"){
			echo("<center><h3>" . $global['TC']['Header']['Assigned'] . "</center></h3>");
			$tickets = mysql_query("SELECT * FROM tc_tickets WHERE (assigned = '" . mysql_real_escape_string($userID) . "' OR creator = '" . mysql_real_escape_string($userID ). "') AND status < '3' ORDER BY lastpost ASC");
		}else{
			echo("<center><h3>" . $global['TC']['Header']['ActiveTickets'] . "</center></h3>");
			$tickets = mysql_query("SELECT * FROM tc_tickets WHERE status < '3' ORDER BY lastpost ASC");
		}
		$count = mysql_num_rows($tickets);
		
		function status($n)
		{
			$sN = array('New', 'Responded', 'Answered', 'Locked', 'Deleted');
			return $sN[$n];
		}
		
		if($count == 0)
		{
			echo("<center>" . $global['TC']['MyTickets']['None'] . "</center>");
		}else{
			$c2 = "#F0F0F0";
			$c1 = "#DEDEDE";
			$row_count = 0;
			echo('<form name="delete_button" action="' . $PHP_SELF . '" method="POST">
			<div class="tcsimple">
			<table>
			<thead>
			<tr>
				<th width="2%" align="center" valign="top">ID</th>
				<th width="15%" align="center" valign="top">Reporter</th>
				<th width="15%" align="center" valign="top">Handler</th>
				<th width="20%" align="center" valign="top">Subject</th>
				<th width="20%" align="center" valign="top">Posted On</th>
				<th width="10%" align="center" valign="top">Status</th>
				'); if($adminLevel > 5){ echo('<th width="2%" align="center" valign="middle"><img src="http://cdn1.iconfinder.com/data/icons/gloss-basic-icons-by-momentum/16/document-delete.png"></th>'); } 
			echo('</tr>
			</thead>
			<tbody>');
			while($s = mysql_fetch_array($tickets))
			{
				$date = date('m-d-Y', $s['posted']);
				$rc = ($row_count % 2) ? $c1 : $c2;
				?>
				<tr>
					<td width="2%" align="center" valign="middle"><a class="linktc" href="/ticketcenter/view/<?php echo $s['id']; ?>/">#<?php echo $s['id']; ?></a></td>
					<td width="15%" align="center" valign="middle"><a class="linktc" href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo getNameFromUserID($s['creator'], $MySQLConn); ?></a></td>
					<td width="15%" align="center" valign="middle"><?php echo getNameFromUserID($s['assigned'], $MySQLConn); ?></a></td>
					<td width="20%" align="center" valign="middle"><a class="linktc" href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo $s['subject']; ?></a></td>
					<td width="20%" align="center" valign="middle"><a class="linktc" href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo $date; ?></a></td>
					<td width="10%" align="center" valign="middle"><a class="linktc" href="/ticketcenter/view/<?php echo $s['id']; ?>/"><?php echo status($s['status']); ?></a></td>
					<?php if($adminLevel > 5){?><td width="2%" align="center" valign="middle"><input type="checkbox" name="delete_ticket[]" id="delete_ticket[]" value="<?php echo $s['id']; ?>"></td><?php } ?>

				</tr>
				<?php
				$row_count++;
			}
			echo('</tbody></table></div><br />');
			if($adminLevel > 5){ echo('<input name="form" type="hidden" id="form" value="true">
			<p style="text-align:right;"><a href="#" class="right" onclick="document[\'delete_button\'].submit()">Delete Selected Tickets</a></p></span></form>');}?>
            <?php if($adminLevel >=6){?><?php }
		}
?>
				
				
				
				<?php /* Admins can see their created tickets in "My Tickets"	<div class="three-fourth left last">
            	<h3 class=" notopmargin">My Tickets</h3>
				<?php if($count == 0){ ?>
				<p>All tickets you make will show here.</p>
				<?php } else { ?>
            	<p>All tickets you have made. To re-open a closed ticket, select the ticket below and make a reply.</p>
				<?php } ?>
            </div>*/?>
<?php

//PRODUCES ERROR <> that makes it so the footer doesn't show, since it's already declared
//function status($n)
//{
//	$sN = array('New', 'Responded', 'Answered', 'Locked', 'Deleted');
//	return $sN[$n];
//}

if($count == 0)
{

}else{
	$x = 0;
while($s = mysql_fetch_array($tickets))
{
echo("<a href='/ticketcenter/view/" . $s['id'] . "/'>#" . $s['id'] . " - " . $s['subject'] . "</a> (" . status($s['status']) . ")");
		
++ $x;
if($x < $count)
{
echo("<br/>");
}
}
}


?>
				<?php  } ?>
			
        </div>
        </div>
		<!-- END MAIN CONTENT -->
