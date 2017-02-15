<?php
// Validating etc has been done by the file that includes this one
	require_once("includes/header.php");
	require_once("includes/mta_sdk.php");
	if (isset($_POST['revokeID']))
	{
		$mQuery2 = mysql_query("SELECT `accountID` FROM `donators` WHERE `id`='". mysql_real_escape_string($_POST['revokeID']) ."'", $MySQLConn);
		if (mysql_num_rows($mQuery2) > 0)
		{
			$mResult2 = mysql_fetch_assoc($mQuery2);
			
			$tempAccountID = $mResult2['accountID'];
			mysql_query("DELETE FROM `donators` WHERE `id`='". mysql_real_escape_string($_POST['revokeID']) ."'", $MySQLConn);
			$mtaServer = new mta($Config['server']['hostname'], 22003, $Config['server']['username'], $Config['server']['password'] );
			$mtaServer->getResource("mtavg")->call("reloadUserPerks", $tempAccountID);
		}
		Header("Location: /admin/players/perkslist/");
	}
	if (isset($_POST['grantUser']))
	{
		if ($_POST['grantPerk'] == 13 or $_POST['grantPerk'] == 14 or $_POST['grantPerk'] == 16 or $_POST['grantPerk'] == 17)
		{
			if ($_POST['days'] > 0  && $_POST['days'] < 29)
			{
				$mQuery2 = mysql_query("SELECT `id` FROM `accounts` WHERE `username`='". mysql_real_escape_string($_POST['grantUser']) ."'", $MySQLConn);
				if (mysql_num_rows($mQuery2) > 0)
				{
					$mResult2 = mysql_fetch_assoc($mQuery2);
					
					$tempAccountID = $mResult2['id'];
					//mysql_query("INSERT INTO `donators` () WHERE `id`='". mysql_real_escape_string($_POST['revokeID']) ."'", $MySQLConn);
					mysql_query("INSERT INTO `donators` (accountID, perkID, perkValue, expirationDate) VALUES ('".$tempAccountID."', '".mysql_real_escape_string($_POST['grantPerk'])."', '1', NOW() + interval " .$_POST['days']." day)");
				
					$mtaServer = new mta($Config['server']['hostname'], 22003, $Config['server']['username'], $Config['server']['password'] );
					$mtaServer->getResource("mtavg")->call("reloadUserPerks", $tempAccountID);
				}
			}
		}
		Header("Location: /admin/players/perkslist/");
	}
	else {
?>				<!-- Middle Column - main content -->
					<div id="content-middle">
						<div class="content-box">
							<div class="content-holder">
								<h2>AdminCP - Perkslist</h2>
								
								<BR />
								<BR />
								Players with perk ID 13 (Object management - mapping team)<BR />
								Add username: <form action="" method="post"><input type="input" name="grantUser" value=""><input type="hidden" name="grantPerk" value="13">
								<select name="days">
								  <option value="1">1 day</option>
								  <option value="2">2 days</option>
								  <option value="3">3 days</option>
								  <option value="4">4 days</option>
								  <option value="5">5 days</option>
								  <option value="7">7 days</option>
								  <option value="14">14 days</option>
								  <option value="21">21 days</option>
								  <option value="28">28 days</option>
								</select>
								<input type="submit" name="submitGrant" value="Save"></form>
								<TABLE>
									<TR>
										<TH>ID</TH>
										<TH>Name</TH>
										<TH>Expiration</TH>
										<TH></TH>
									</TR>

<?php
$mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=13", $MySQLConn);
if (mysql_num_rows($mQuery2) == 0)
{
	echo "									<TR>\r\n";
	echo "										<TD COLSPAN=4>Nothing to show here :'(</TD>\r\n";
	echo "									</TR>\r\n";
}
while ($row = mysql_fetch_assoc($mQuery2))
{
	echo "									<TR>\r\n";
	echo "										<TD>".$row['id']."</TD>";
	echo "										<TD>".$row['username']."</TD>\r\n";
	echo "										<TD>".$row["expirationDate"]."</TD>\r\n";
	echo "										<TD><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"submit\" name=\"submitRevoke\" value=\"Revoke\"></form></TD>\r\n";
	echo "									</TR>\r\n";
}
?>								</TABLE>	


								<BR />
								<BR />
								Players with perk ID 14 (Interior commands)<BR />
								Add username: <form action="" method="post"><input type="input" name="grantUser" value=""><input type="hidden" name="grantPerk" value="14">
								<select name="days">
								  <option value="1">1 day</option>
								  <option value="2">2 days</option>
								  <option value="3">3 days</option>
								  <option value="4">4 days</option>
								  <option value="5">5 days</option>
								  <option value="7">7 days</option>
								  <option value="14">14 days</option>
								  <option value="21">21 days</option>
								  <option value="28">28 days</option>
								</select>
								<input type="submit" name="submitGrant" value="Save"></form>
								<TABLE>
									<TR>
										<TH>ID</TH>
										<TH>Name</TH>
										<TH>Expiration</TH>
										<TH></TH>
									</TR>

<?php
$mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=14", $MySQLConn);
if (mysql_num_rows($mQuery2) == 0)
{
	echo "									<TR>\r\n";
	echo "										<TD COLSPAN=4>Nothing to show here :'(</TD>\r\n";
	echo "									</TR>\r\n";
}
while ($row = mysql_fetch_assoc($mQuery2))
{
	echo "									<TR>\r\n";
	echo "										<TD>".$row['id']."</TD>";
	echo "										<TD>".$row['username']."</TD>\r\n";
	echo "										<TD>".$row["expirationDate"]."</TD>\r\n";
	echo "										<TD><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"submit\" name=\"submitRevoke\" value=\"Revoke\"></form></TD>\r\n";
	echo "									</TR>\r\n";
}
?>								</TABLE>	

								<BR />
								<BR />
								Players with perk ID 16 (Vehicle commands)<BR />
								Add username: <form action="" method="post"><input type="input" name="grantUser" value=""><input type="hidden" name="grantPerk" value="16">
								<select name="days">
								  <option value="1">1 day</option>
								  <option value="2">2 days</option>
								  <option value="3">3 days</option>
								  <option value="4">4 days</option>
								  <option value="5">5 days</option>
								  <option value="7">7 days</option>
								  <option value="14">14 days</option>
								  <option value="21">21 days</option>
								  <option value="28">28 days</option>
								</select>
								<input type="submit" name="submitGrant" value="Save"></form>
								<TABLE>
									<TR>
										<TH>ID</TH>
										<TH>Name</TH>
										<TH>Expiration</TH>
										<TH></TH>
									</TR>

<?php
$mQuery3 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=16", $MySQLConn);
if (mysql_num_rows($mQuery3) == 0)
{
	echo "									<TR>\r\n";
	echo "										<TD COLSPAN=4>Nothing to show here :'(</TD>\r\n";
	echo "									</TR>\r\n";
}
while ($row = mysql_fetch_assoc($mQuery3))
{
	echo "									<TR>\r\n";
	echo "										<TD>".$row['id']."</TD>";
	echo "										<TD>".$row['username']."</TD>\r\n";
	echo "										<TD>".$row["expirationDate"]."</TD>\r\n";
	echo "										<TD><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"submit\" name=\"submitRevoke\" value=\"Revoke\"></form></TD>\r\n";
	echo "									</TR>\r\n";
}
?>								</TABLE>	

								<BR />
								<BR />
								Players with perk ID 17 (GM Team Leader)<BR />
								Add username: <form action="" method="post"><input type="input" name="grantUser" value=""><input type="hidden" name="grantPerk" value="17">
								<select name="days">
								  <option value="1">1 day</option>
								  <option value="2">2 days</option>
								  <option value="3">3 days</option>
								  <option value="4">4 days</option>
								  <option value="5">5 days</option>
								  <option value="7">7 days</option>
								  <option value="14">14 days</option>
								  <option value="21">21 days</option>
								  <option value="28">28 days</option>
								</select>
								<input type="submit" name="submitGrant" value="Save"></form>
								<TABLE>
									<TR>
										<TH>ID</TH>
										<TH>Name</TH>
										<TH>Expiration</TH>
										<TH></TH>
									</TR>

<?php
$mQuery4 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=17", $MySQLConn);
if (mysql_num_rows($mQuery4) == 0)
{
	echo "									<TR>\r\n";
	echo "										<TD COLSPAN=4>Nothing to show here :'(</TD>\r\n";
	echo "									</TR>\r\n";
}
while ($row = mysql_fetch_assoc($mQuery4))
{
	echo "									<TR>\r\n";
	echo "										<TD>".$row['id']."</TD>";
	echo "										<TD>".$row['username']."</TD>\r\n";
	echo "										<TD>".$row["expirationDate"]."</TD>\r\n";
	echo "										<TD><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"submit\" name=\"submitRevoke\" value=\"Revoke\"></form></TD>\r\n";
	echo "									</TR>\r\n";
}
?>								</TABLE>	
							</div>
						</div>
					</div>
<?php
}
	require_once("includes/footer.php");
?>