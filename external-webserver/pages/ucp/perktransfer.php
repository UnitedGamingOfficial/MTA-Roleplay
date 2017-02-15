<?php
//res. name "usercontrolpanel"
?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left"><?php echo $global['UCP']['PT']['Title']; ?></h3>
            <p class="left description "><?php echo $global['UCP']['PT']['Status'];  ?></p>
        </div>
        <!-- END WELCOME BLOCK -->
<?php require_once("././includes/sidebar.php"); ?>
<?php
error_reporting(0);
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
$mQuery1 = mysql_query("SELECT `username`,`transfers` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}

$host = "94.23.90.55";
$i = "3306";
$fp = fsockopen("$host",$i,$errno,$errstr,10);
if($fp){

$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$transfers = $userRow['transfers'];

$charArr = array();
$mQuery2 = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `account`='".$userID."' ORDER BY `charactername` ASC");
while ($characterRow = mysql_fetch_assoc($mQuery2))
{
	$charArr[ $characterRow['id'] ] = $characterRow['charactername'];
}


// /ucp/perktransfer/<name>/ $param2
/*

					
*/

if (!isset($_GET['param2']) || $_GET['param2'] == 'view' || $_GET['param2'] == 'step2' || $_GET['param2'] == 'step3')
{
	if (isset($_POST['fromcharacter']) AND isset($_POST['tocharacter']))
	{
		if (isset($charArr[$_POST['fromcharacter']]) AND isset($charArr[$_POST['tocharacter']]))
		{
			if ($_POST['fromcharacter'] != $_POST['tocharacter'])
			{
				require_once("././includes/mta_sdk.php");
				$mtaServer = new mta($Config['server']['hostname'], 22005, $Config['server']['username'], $Config['server']['password'] );
				$isPlayerOnline = $mtaServer->getResource("usercontrolpanel")->call("isPlayerOnline", $userID);
				if (!$isPlayerOnline[0]) { // if (true) { //
					$fromCharacterQry = mysql_query("SELECT `id`,`charactername`,`skin`,`bankmoney`,`money` FROM `characters` WHERE `account`='".mysql_real_escape_string($userID)."' AND `id`='".mysql_real_escape_string($_POST['fromcharacter'])."'");
					$toCharacterQry = mysql_query("SELECT `id`,`charactername`,`skin` FROM `characters` WHERE `account`='".mysql_real_escape_string($userID)."' AND `id`='".mysql_real_escape_string($_POST['tocharacter'])."'");
					if (mysql_num_rows($fromCharacterQry) == 1 AND mysql_num_rows($toCharacterQry) == 1)
					{
						$fromCharacterRow = mysql_fetch_assoc($fromCharacterQry);
						$toCharacterRow = mysql_fetch_assoc($toCharacterQry);
						
						while (strlen($fromCharacterRow['skin']) < 3)
							$fromCharacterRow['skin'] = '0'.$fromCharacterRow['skin'];
							
						while (strlen($toCharacterRow['skin']) < 3)
							$toCharacterRow['skin'] = '0'.$toCharacterRow['skin'];
						
						$vehicleArr = array();
						$fromCharacterVehicleQuery = mysql_query("SELECT `id`, `model` FROM `vehicles` WHERE `owner`='".mysql_real_escape_string($fromCharacterRow['id'])."'");
						while ($vehicleRow = mysql_fetch_assoc($fromCharacterVehicleQuery))
						{
							$ret = $mtaServer->getResource("carshop-system")->call("isForSale", $vehicleRow['model']);
							if($ret && $ret[0] === true)
							{
								$vehicleArr[ $vehicleRow['id'] ] = $vehicleRow['model'];
							}
						}
						
						$interiorArr = array();
						$fromCharacterInteriorQuery = mysql_query("SELECT `id`, `name` FROM `interiors` WHERE `owner`='".mysql_real_escape_string($fromCharacterRow['id'])."'");
						while ($interiorRow = mysql_fetch_assoc($fromCharacterInteriorQuery))
						{
							$interiorArr[ $interiorRow['id'] ] = $interiorRow['name'];
						}
						
						if (isset($_POST['bankmoney']) AND isset($_POST['money']))
						{
							$continue = true;
							$error = '';
							// Validate input
							if (!isDecimalNumber($_POST['bankmoney']) or $_POST['bankmoney'] > $fromCharacterRow['bankmoney'] or $_POST['bankmoney'] < 0)
							{
								$continue = false;
								$error .= 'Invalid amount of bankmoney. ';
							}
							
							if (!isDecimalNumber($_POST['money']) or $_POST['money'] > $fromCharacterRow['money'] or $_POST['money'] < 0)
							{	
								$continue = false;
								$error .= 'Invalid amount of money in pocket. ';
							}			
							
							if (isset($_POST['vehicle']))
							{
								foreach ($_POST['vehicle'] as $tempVehicleID)
								{
									if (!isset($vehicleArr[$tempVehicleID]))
									{
										$continue = false;
										$error .= 'Tried to transfer a vehicle thats not yours. ';
									}
								}
							}
							
							if (isset($_POST['interior']))
							{
								foreach ($_POST['interior'] as $tempInteriorID)
								{
									if (!isset($interiorArr[$tempInteriorID]))
									{
										$continue = false;
										$error .= 'Tried to transfer an interior thats not yours. ';
									}
								}
							}
							
							if ($transfers == 0)
							{
								$continue = false;
								$error .= 'No perk transfers available. ';
							}
							
							
							
							if ($continue)
							{ 	// TRANSFER THAT SHITZ
?>
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<5>Connected to server</h5>
			<h4 class="colored"><img src="/images/loading.gif" /> completing transaction...</h4>
			<h5>redirecting when transaction completes</h5>
			

<?php
								mysql_query("INSERT INTO `logtable` VALUES (NOW(), '1', 'ac".mysql_real_escape_string($userID)."', 'ac".mysql_real_escape_string($userID).";ch".$fromCharacterRow['id'].";ch".$toCharacterRow['id']."', 'Starting stattransfer between ".mysql_real_escape_string($fromCharacterRow["charactername"])." and ".mysql_real_escape_string($toCharacterRow["charactername"])."')");
mysql_query("INSERT INTO `adminhistory` (`user`, `user_char`,`admin_char`,`admin`,`date`, `action`,`duration`,`reason`,`hiddenadmin`) VALUES ('".mysql_real_escape_string($userID)."', 'N/A','N/A','".mysql_real_escape_string($userID)."', now(), 6, '0','Stattransfer from ".$fromCharacterRow['charactername']." to ".$toCharacterRow['charactername']."','0')");

								mysql_query("UPDATE `accounts` SET `transfers`=`transfers`-1 WHERE `id`='".mysql_real_escape_string($userID)."'");
								if ($_POST['money'] > 0 or $_POST['bankmoney'] > 0)
								{
									mysql_query("INSERT INTO `logtable` VALUES (NOW(), '1', 'ac".mysql_real_escape_string($userID)."', 'ac".mysql_real_escape_string($userID).";ch".$fromCharacterRow['id'].";ch".$toCharacterRow['id'].";', 'Transfering bank ".mysql_real_escape_string($_POST['bankmoney'])." and cash ".mysql_real_escape_string($_POST['money'])." from ".mysql_real_escape_string($fromCharacterRow["charactername"])." to ".mysql_real_escape_string($toCharacterRow["charactername"])."')");
									mysql_query("UPDATE `characters` SET `money`=`money`-".$_POST['money'].", `bankmoney`=`bankmoney`-".$_POST['bankmoney']." WHERE `id`='".$fromCharacterRow['id']."'");
									mysql_query("UPDATE `characters` SET `money`=`money`+".$_POST['money'].", `bankmoney`=`bankmoney`+".$_POST['bankmoney']." WHERE `id`='".$toCharacterRow['id']."'");
									echo '- Money transfered<BR />';
									flush();
								}
								
								if(isset($_POST['vehicle']))
								{
									foreach ($_POST['vehicle'] as $tempVehicleID)
									{
										mysql_query("INSERT INTO `logtable` VALUES (NOW(), '1', 'ac".mysql_real_escape_string($userID)."', 'ac".mysql_real_escape_string($userID).";ch".$fromCharacterRow['id'].";ch".$toCharacterRow['id'].";ve".$tempVehicleID.";', 'Transfering vehicle ".mysql_real_escape_string($tempVehicleID)." from ".mysql_real_escape_string($fromCharacterRow["charactername"])." to ".mysql_real_escape_string($toCharacterRow["charactername"])."')");
										$mtaServer->getResource("usercontrolpanel")->call("deleteItem", 3, $tempVehicleID);
										echo '- Removed old keys for vehicle '.$tempInteriorID.'<BR />';
										mysql_query("UPDATE `vehicles` SET `owner`='".$toCharacterRow['id']."' WHERE `id`='".$tempVehicleID."' AND `owner`='".$fromCharacterRow['id']."'");
										echo '- Vehicle '.$tempVehicleID.' transfered<BR />';
										mysql_query("INSERT INTO `items` (type, owner, itemID, itemValue) VALUES ('1', '".$toCharacterRow['id']."', '3', '".$tempVehicleID."')");
										echo '- Giving "'.$toCharacterRow['charactername']. '" a key for vehicle '.$tempVehicleID.'<BR />';
										flush();
									}
								}
								
								if (isset($_POST['interior']))
								{
									foreach ($_POST['interior'] as $tempInteriorID)
									{
										mysql_query("INSERT INTO `logtable` VALUES (NOW(), '1', 'ac".mysql_real_escape_string($userID)."', 'ac".mysql_real_escape_string($userID).";ch".$fromCharacterRow['id'].";ch".$toCharacterRow['id'].";in".$tempInteriorID.";', 'Transfering interior ".mysql_real_escape_string($tempInteriorID)." from ".mysql_real_escape_string($fromCharacterRow["charactername"])." to ".mysql_real_escape_string($toCharacterRow["charactername"])."')");
										$mtaServer->getResource("usercontrolpanel")->call("deleteItem", 4, $tempInteriorID);
										$mtaServer->getResource("usercontrolpanel")->call("deleteItem", 5, $tempInteriorID);
										echo '- Removed old keys for interior '.$tempInteriorID.'<BR />';
										mysql_query("UPDATE `interiors` SET `owner`='".$toCharacterRow['id']."' WHERE `id`='".$tempInteriorID."' AND `owner`='".$fromCharacterRow['id']."'");
										echo '- Interior '.$tempInteriorID.' transfered<BR />';
										mysql_query("INSERT INTO `items` (type, owner, itemID, itemValue) VALUES ('1', '".$toCharacterRow['id']."', '4', '".$tempInteriorID."')");
										echo '- Giving "'.$toCharacterRow['charactername']. '" a key for interior '.$tempInteriorID.'<BR />';
										flush();
									}
								}
							
								mysql_query("INSERT INTO `logtable` VALUES (NOW(), '1', 'ac".mysql_real_escape_string($userID)."', 'ac".mysql_real_escape_string($userID).";ch".$fromCharacterRow['id'].";ch".$toCharacterRow['id']."', 'Ending stattransfer between ".mysql_real_escape_string($fromCharacterRow["charactername"])." and ".mysql_real_escape_string($toCharacterRow["charactername"])."')");
								echo '<h5 class="colored">Transfer Complete!</h5>';
								$mtaServer->getResource("usercontrolpanel")->call("statTransfer", $userID, $fromCharacterRow['id'], $toCharacterRow['id']);
?>
			<meta http-equiv="REFRESH" content="1;url=/ucp/perktransfer/">
        </div>
<?php						}
							else { // Invalid Transfer
?>
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<h4 class="colored">The Transfer could not be completed.</h4>
			<h5>Make sure you aren't attempting to transfer things you don't have.</h5>
			<h5><?php echo $error;?></h5>

        </div>
<?php						}
							
						}
						else 
						{
?>
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<form action="/ucp/perktransfer/step3/" method="post">
				<input type="hidden" name="fromcharacter" value="<?php echo $_POST['fromcharacter']; ?>" />
				<input type="hidden" name="tocharacter" value="<?php echo $_POST['tocharacter']; ?>" /><?php echo "<a target=\"_new\" href=\"/ucp/character/".$fromCharacterRow["id"]."/\"><img src=\"/images/chars/".$fromCharacterRow['skin'].".png\"><BR />".str_replace("_", " ", $fromCharacterRow["charactername"])."</a>"; ?>
				<h6>To</h6>
				<?php echo "<a target=\"_new\" href=\"/ucp/character/".$toCharacterRow["id"]."/\"><img src=\"/images/chars/".$toCharacterRow['skin'].".png\"><BR />".str_replace("_", " ", $toCharacterRow["charactername"])."</a>"; ?>
				<p>Please select the perks you want to transfer to the character shown.</p>
				<h4>General Perks</h4>
				<input type="text" name="bankmoney" class="text-input" value="<?php echo $fromCharacterRow['bankmoney']; ?>" /><label for="bankmoney">Money in bank</label>
				<input type="text" name="money" class="text-input" value="<?php echo $fromCharacterRow['money']; ?>" /><label for="money">Money on hand</label>
				<h4>Vehicles</h4>
				<?php					
						foreach ($vehicleArr as $vehicleID => $vehicleModel)
						{
								echo "											<input type=\"checkbox\" name=\"vehicle[]\" value=\"".$vehicleID."\" CHECKED> ".$vehicleID." - ".$vehicleIDtoName[$vehicleModel]."<BR />";
				        }
				?>
				<h4>Properties</h4>
				<?php
						foreach ($interiorArr as $interiorID => $interiorName)
						{
							echo "											<input type=\"checkbox\" name=\"interior[]\" value=\"".$interiorID."\" CHECKED> ".$interiorID." - ".$interiorName."<BR />";
						}
				?>
				<input type="submit" name="submit" value="Next step >>" />
        </div>
<?php					}
					}
					else {
?>
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<h4 class="colored">There was an issue while transfering perks.</h4>
			<h4 class="colored">If the problem persists, make a ticket for a manual transfer</h4>

        </div>
<?php				}
				}
				else {
?>	
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<h4 class="colored">This account (<?php $_SESSION['ucp_username'];?>) is currently logged in, in-game. Log out and try again.</h4>

        </div>	
<?php			}
			}
			else {
?>
        <div class="three-fourth last">

			<h2>Perk Transfer</h2>
			<h4 class="colored">Transfer destination characters cannot be the same.</h4>

        </div>
<?php		}
		}
	}
	else {
?>	
        <div class="three-fourth last">
		
			<h2>Perk Transfer</h2>
			<h3>You have <?php echo $transfers;?> remaining on your account.</h3>
			<h4>Select the characters you wish to transfer from and to. Be disconnected from the server when making the transfer, or the transfer will not complete.</h4>
			<form action="/ucp/perktransfer/step2/" method="post">
			<h4>From Character</h4>
			<select name="fromcharacter">
<?php
foreach($charArr as $characterID => $characterName)
{
echo"													<option value=\"".$characterID."\">".str_replace("_", " ", $characterName)."</option>\r\n";
}
?>
			</select>
			<h4>To Character</h4>
			<select name="tocharacter">
<?php
foreach($charArr as $characterID => $characterName)
{
echo"													<option value=\"".$characterID."\">".str_replace("_", " ", $characterName)."</option>\r\n";
}
?>
			</select>
			<input type="submit" name="submit" value="Next step >>" />
		</form>
			
			</div>
<?php
	}

}
} else {
?>
        <div class="three-fourth last">

			<div class="big-round-icon-black left margin15"><div class="icon-black-big icon38-black"><img src="/images/1px.png" alt="" width="24px" height="24px"></div></div><center><h2 class="colored">Perk Transfers are <span class="highlight-orange">Offline</span></h2></center>
			<h4 class="" align="center">PLEASE TRY AGAIN LATER</h4>

        </div>
<?php }  flush();?>
 </div>
			<!-- END MAIN CONTENT -->