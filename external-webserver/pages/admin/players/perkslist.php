<?php

		if ($adminLevel < 6)
	{
		header("Location: /ucp/main/");
		die();
	}
	
	require_once("./././includes/header.php");
	require_once("./././includes/mta_sdk.php");
	if (isset($_POST['revokeID']))
	{
		$mQuery2 = mysql_query("SELECT `accountID` FROM `donators` WHERE `id`='". mysql_real_escape_string($_POST['revokeID']) ."'", $MySQLConn);
		if (mysql_num_rows($mQuery2) > 0)
		{
			$mResult2 = mysql_fetch_assoc($mQuery2);
			
			$tempAccountID = $mResult2['accountID'];
			mysql_query("DELETE FROM `donators` WHERE `id`='". mysql_real_escape_string($_POST['revokeID']) ."'", $MySQLConn);
			$mtaServer = new mta($Config['server']['hostname'], 22005, $Config['server']['username'], $Config['server']['password'] );
			$mtaServer->getResource("usercontrolpanel")->call("reloadUserPerks", $tempAccountID);
		}
		Header("Location: /admin/perks/");
	}
	if (isset($_POST['grantUser']))
	{
		if ($_POST['grantPerk'] == 13 or $_POST['grantPerk'] == 14 or $_POST['grantPerk'] == 16 or $_POST['grantPerk'] == 17 or $_POST['grantPerk'] == 19)
		
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
				
					$mtaServer = new mta($Config['server']['hostname'], 22005, $Config['server']['username'], $Config['server']['password'] );
					$mtaServer->getResource("usercontrolpanel")->call("reloadUserPerks", $tempAccountID);
				}
			}
		}
		header("Location: /admin/perks/");
	}
	else {
?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Admin Perk Control</h3>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
		<?php require_once("./././includes/sidebar.php"); ?>
        <div class="three-fourth last">
        <div class="three-fourth notopmargin last">
        <?php
		#######################################################
		#########################//OBJECT MANAGEMENT//#########
		#######################################################
		?>
        <h3 align="center"><img src="http://cdn1.iconfinder.com/data/icons/all_google_icons_symbols_by_carlosjj-du/24/maps.png"/> Object Management</h3>
        <div class="simplegrid">
        	<table>
            	<thead>
                <tr>
                	<th valign="middle" align="center">ID</th>
                    <th valign="middle" align="center">Username</th>
                    <th valign="middle" align="center">Expires</th>
                    <th valign="middle" align="center"></th>
                </tr>
                </thead>
                <tbody>
				<?php
                $mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=13", $MySQLConn);
                if (mysql_num_rows($mQuery2) == 0)
                {
                    echo "<tr>\r\n";
                    echo "<td colspan=4>No users currently obtain this perk, <a href=\"#objmng\" class=\"link\">add new</a> users?</td>\r\n";
                    echo "</tr>\r\n";
                }
                while ($row = mysql_fetch_assoc($mQuery2))
                {
                    echo "<tr>\r\n";
                    echo "<td align=\"center\" width=\"14px\">".$row['id']."</td>";
                    echo "<td align=\"center\" >".$row['username']."</td>\r\n";
                    echo "<td align=\"center\" >".$row["expirationDate"]."</td>\r\n";
                    echo "<td width=\"12px\"><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"image\" src=\"http://cdn1.iconfinder.com/data/icons/diagona/icon/16/150.png\" onsubmit=\"submit-form();\"></form></td>\r\n";
                    echo "</tr>\r\n";
                }
                ?>	
                </tbody>
                </table>
                </div>
         <h4 class="notopmargin">Add user to Object Management</h4>
        <form action="" id="objmng" method="post">
        <input type="input" name="grantUser" class="text-input" value=""><label for="grantUser">Username</label><input type="hidden" name="grantPerk" value="13">
        	<select name="days">
              <option value="1">Apply for 1 day</option>
              <option value="2">Apply for 2 days</option>
              <option value="3">Apply for 3 days</option>
              <option value="4">Apply for 4 days</option>
              <option value="5">Apply for 5 days</option>
              <option value="7">Apply for 1 week</option>
              <option value="14">Apply for 2 weeks</option>
              <option value="21">Apply for 21 days</option>
              <option value="28">Apply for 28 days</option>
            </select>
        <input type="submit" name="submitGrant" class="button" value="Grant Perk">
        </form>
        <?php
		#######################################################
		#########################//INTERIOR COMMANDS//#########
		#######################################################
		?>
        <h3 align="center"><img src="http://cdn1.iconfinder.com/data/icons/flatforlinux/24/1%20-%20Home.png" /> Interior Permissions</h3>
        <div class="simplegrid">
        	<table>
            	<thead>
                <tr>
                	<th valign="middle" align="center">ID</th>
                    <th valign="middle" align="center">Username</th>
                    <th valign="middle" align="center">Expires</th>
                    <th valign="middle" align="center"></th>
                </tr>
                </thead>
                <tbody>
				<?php
                $mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=14", $MySQLConn);
                if (mysql_num_rows($mQuery2) == 0)
                {
                    echo "<tr>\r\n";
                    echo "<td colspan=4>No users currently obtain this perk, <a href=\"#intcmd\" class=\"link\">add new</a> users?</td>\r\n";
                    echo "</tr>\r\n";
                }
                while ($row = mysql_fetch_assoc($mQuery2))
                {
                    echo "<tr>\r\n";
                    echo "<td align=\"center\" width=\"14px\">".$row['id']."</td>";
                    echo "<td align=\"center\" >".$row['username']."</td>\r\n";
                    echo "<td align=\"center\" >".$row["expirationDate"]."</td>\r\n";
                    echo "<td width=\"12px\"><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"image\" src=\"http://cdn1.iconfinder.com/data/icons/diagona/icon/16/150.png\" onsubmit=\"submit-form();\"></form></td>\r\n";
                    echo "</tr>\r\n";
                }
                ?>	
                </tbody>
                </table>
                </div>
         <h4 class="notopmargin">Add user to Interior Permissions</h4>
        <form action="" id="intcmd" method="post">
        <input type="input" name="grantUser" class="text-input" value=""><label for="grantUser">Username</label><input type="hidden" name="grantPerk" value="14">
        	<select name="days">
              <option value="1">Apply for 1 day</option>
              <option value="2">Apply for 2 days</option>
              <option value="3">Apply for 3 days</option>
              <option value="4">Apply for 4 days</option>
              <option value="5">Apply for 5 days</option>
              <option value="7">Apply for 1 week</option>
              <option value="14">Apply for 2 weeks</option>
              <option value="21">Apply for 21 days</option>
              <option value="28">Apply for 28 days</option>
            </select>
        <input type="submit" name="submitGrant" class="button" value="Grant Perk">
        </form>  
        <?php
		#######################################################
		##########################//VEHICLE COMMANDS//#########
		#######################################################
		?>
        <h3 align="center"><img src="http://cdn1.iconfinder.com/data/icons/iconslandtransport/PNG/24x24/CabrioletRed.png" /> Vehicle Permissions</h3>
        <div class="simplegrid">
        	<table>
            	<thead>
                <tr>
                	<th valign="middle" align="center">ID</th>
                    <th valign="middle" align="center">Username</th>
                    <th valign="middle" align="center">Expires</th>
                    <th valign="middle" align="center"></th>
                </tr>
                </thead>
                <tbody>
				<?php
                $mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=16", $MySQLConn);
                if (mysql_num_rows($mQuery2) == 0)
                {
                    echo "<tr>\r\n";
                    echo "<td colspan=4>No users currently obtain this perk, <a href=\"#vehcmd\" class=\"link\">add new</a> users?</td>\r\n";
                    echo "</tr>\r\n";
                }
                while ($row = mysql_fetch_assoc($mQuery2))
                {
                    echo "<tr>\r\n";
                    echo "<td align=\"center\" width=\"14px\">".$row['id']."</td>";
                    echo "<td align=\"center\" >".$row['username']."</td>\r\n";
                    echo "<td align=\"center\" >".$row["expirationDate"]."</td>\r\n";
                    echo "<td width=\"12px\"><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"image\" src=\"http://cdn1.iconfinder.com/data/icons/diagona/icon/16/150.png\" onsubmit=\"submit-form();\"></form></td>\r\n";
                    echo "</tr>\r\n";
                }
                ?>	
                </tbody>
                </table>
                </div>
         <h4 class="notopmargin">Add user to Vehicle Permissions</h4>
        <form action="" id="vehcmd" method="post">
        <input type="input" name="grantUser" class="text-input" value=""><label for="grantUser">Username</label><input type="hidden" name="grantPerk" value="16">
        	<select name="days">
              <option value="1">Apply for 1 day</option>
              <option value="2">Apply for 2 days</option>
              <option value="3">Apply for 3 days</option>
              <option value="4">Apply for 4 days</option>
              <option value="5">Apply for 5 days</option>
              <option value="7">Apply for 1 week</option>
              <option value="14">Apply for 2 weeks</option>
              <option value="21">Apply for 21 days</option>
              <option value="28">Apply for 28 days</option>
            </select>
        <input type="submit" name="submitGrant" class="button" value="Grant Perk">
        </form> 
<?php
		#######################################################
		##########################//HEAD GM COMMANDS//#########
		#######################################################
		?>
        <h3 align="center"><!--<img src="http://cdn1.iconfinder.com/data/icons/iconslandtransport/PNG/24x24/CabrioletRed.png" />--> GameMaster Permissions</h3>
        <div class="simplegrid">
        	<table>
            	<thead>
                <tr>
                	<th valign="middle" align="center">ID</th>
                    <th valign="middle" align="center">Username</th>
                    <th valign="middle" align="center">Expires</th>
                    <th valign="middle" align="center"></th>
                </tr>
                </thead>
                <tbody>
				<?php
                $mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=17", $MySQLConn);
                if (mysql_num_rows($mQuery2) == 0)
                {
                    echo "<tr>\r\n";
                    echo "<td colspan=4>No users currently obtain this perk, <a href=\"#gmcmd\" class=\"link\">add new</a> users?</td>\r\n";
                    echo "</tr>\r\n";
                }
                while ($row = mysql_fetch_assoc($mQuery2))
                {
                    echo "<tr>\r\n";
                    echo "<td align=\"center\" width=\"14px\">".$row['id']."</td>";
                    echo "<td align=\"center\" >".$row['username']."</td>\r\n";
                    echo "<td align=\"center\" >".$row["expirationDate"]."</td>\r\n";
                    echo "<td width=\"12px\"><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"image\" src=\"http://cdn1.iconfinder.com/data/icons/diagona/icon/16/150.png\" onsubmit=\"submit-form();\"></form></td>\r\n";
                    echo "</tr>\r\n";
                }
                ?>	
                </tbody>
                </table>
                </div>
         <h4 class="notopmargin">Add user to Head GameMaster Permissions</h4>
        <form action="" id="gmcmd" method="post">
        <input type="input" name="grantUser" class="text-input" value=""><label for="grantUser">Username</label><input type="hidden" name="grantPerk" value="17">
        	<select name="days">
              <option value="1">Apply for 1 day</option>
              <option value="2">Apply for 2 days</option>
              <option value="3">Apply for 3 days</option>
              <option value="4">Apply for 4 days</option>
              <option value="5">Apply for 5 days</option>
              <option value="7">Apply for 1 week</option>
              <option value="14">Apply for 2 weeks</option>
              <option value="21">Apply for 21 days</option>
              <option value="28">Apply for 28 days</option>
            </select>
        <input type="submit" name="submitGrant" class="button" value="Grant Perk">
        </form> 
<?php
		#######################################################
		##########################//WEAPON COMMANDS//#########
		#######################################################
		?>
        <h3 align="center">Weapon Permissions</h3>
        <div class="simplegrid">
        	<table>
            	<thead>
                <tr>
                	<th valign="middle" align="center">ID</th>
                    <th valign="middle" align="center">Username</th>
                    <th valign="middle" align="center">Expires</th>
                    <th valign="middle" align="center"></th>
                </tr>
                </thead>
                <tbody>
				<?php
                $mQuery2 = mysql_query("SELECT d.`id`, d.`accountID`, d.`perkID`, d.`expirationDate`, a.`username` FROM `donators` d LEFT JOIN `accounts` a ON a.ID=d.`accountID` WHERE d.`expirationDate` > NOW() AND `perkID`=19", $MySQLConn);
                if (mysql_num_rows($mQuery2) == 0)
                {
                    echo "<tr>\r\n";
                    echo "<td colspan=4>No users currently obtain this perk, <a href=\"#vehcmd\" class=\"link\">add new</a> users?</td>\r\n";
                    echo "</tr>\r\n";
                }
                while ($row = mysql_fetch_assoc($mQuery2))
                {
                    echo "<tr>\r\n";
                    echo "<td align=\"center\" width=\"14px\">".$row['id']."</td>";
                    echo "<td align=\"center\" >".$row['username']."</td>\r\n";
                    echo "<td align=\"center\" >".$row["expirationDate"]."</td>\r\n";
                    echo "<td width=\"12px\"><form action=\"\" method=\"post\"><input type=\"hidden\" name=\"revokeID\" value=\"".$row['id']."\"><input type=\"image\" src=\"http://cdn1.iconfinder.com/data/icons/diagona/icon/16/150.png\" onsubmit=\"submit-form();\"></form></td>\r\n";
                    echo "</tr>\r\n";
                }
                ?>	
                </tbody>
                </table>
                </div>
         <h4 class="notopmargin">Add user to Weapon Permissions</h4>
        <form action="" id="vehcmd" method="post">
        <input type="input" name="grantUser" class="text-input" value=""><label for="grantUser">Username</label><input type="hidden" name="grantPerk" value="19">
        	<select name="days">
              <option value="1">Apply for 1 day</option>
              <option value="2">Apply for 2 days</option>
              <option value="3">Apply for 3 days</option>
              <option value="4">Apply for 4 days</option>
              <option value="5">Apply for 5 days</option>
              <option value="7">Apply for 1 week</option>
              <option value="14">Apply for 2 weeks</option>
              <option value="21">Apply for 21 days</option>
              <option value="28">Apply for 28 days</option>
            </select>
        <input type="submit" name="submitGrant" class="button" value="Grant Perk">
        </form> 
        </div>
		</div>
		<!-- END MAIN CONTENT -->            
<?php
}
?>