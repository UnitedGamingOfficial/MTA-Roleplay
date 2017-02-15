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
$mQuery1 = mysql_query("SELECT `username` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];

// /ucp/characters/<name>/ $param2
if (!isset($_GET['param2']))
{
	header("Location: /ucp/main/");
	exit;
}

$charactername = mysql_real_escape_string($_GET['param2']);

$mQuery2 = mysql_query("SELECT `id`,`charactername`,`skin`,`faction_id`,`faction_rank`,`money`,`bankmoney`,`age`,`height`,`hoursplayed`,`creationdate`,`lastlogin`,`active` FROM `characters` WHERE (`charactername`='".$charactername."' OR id='".$charactername."') AND `account`='".$userID."'");
if (mysql_num_rows($mQuery2) == 0 || mysql_num_rows($mQuery2) > 1)
{
	header("Location: /ucp/main/");
	exit;
}

$characterData = mysql_fetch_assoc($mQuery2);

$changed = false;

// start update fields
if (isset($_POST['heightval']))
{
	$newheight = $_POST['heightval'];
	if ($newheight >= 150 and $newheight <= 200)
	{
		mysql_query("UPDATE `characters` SET `height`='".$newheight."' WHERE `id`='".$characterData['id']."'");
		$changed = true;
	}
}

if (isset($_POST['ageval']))
{
	$newage = $_POST['ageval'];
	if ($newage >= 16 and $newage < 100)
	{
		mysql_query("UPDATE `characters` SET `age`='".$newage."' WHERE `id`='".$characterData['id']."'");
		$changed = true;
	}
}

if (isset($_POST['activatechar']))
{
	mysql_query("UPDATE `characters` SET `active`=1 WHERE `id`='".$characterData['id']."'");
	$changed = true;
}

if (isset($_POST['deactivatechar']))
{
	mysql_query("UPDATE `characters` SET `active`=0 WHERE `id`='".$characterData['id']."'");
	$changed = true;
}

if ($changed)
{
	header("Location: /ucp/character/".$characterData['charactername']."/");
	exit;
}
// end update fields

// workaround for the current image links
$add = '';
$addd = '';
if (strlen($characterData['skin']) != 3)
	$add='0';
if (strlen($characterData['skin'])+1 < 3)
	$addd='0';
// end workaround

// faction
$factionStr = "";

if ($characterData['faction_id'] != -1)
{
	$mQuery3 = mysql_query("SELECT `name`, `rank_". $characterData['faction_rank'] ."` FROM `factions` WHERE `id`='".mysql_real_escape_string($characterData['faction_id'])."'");
	if (mysql_num_rows($mQuery3) == 1)
	{
		$factionRow = mysql_fetch_assoc($mQuery3);
		$factionStr = $factionRow['rank_'. $characterData['faction_rank'] ] . ' at '. $factionRow['name'].'<BR />';
	}
}
// end faction

// Netto worth
$nettworth = 0;
$nettworth = $nettworth + $characterData['money'];
$nettworth = $nettworth + $characterData['bankmoney'];

$mQuery4 = mysql_query("SELECT sum(`cost`) AS 'inttotal' FROM `interiors` WHERE `owner`='".$characterData['id']."' ");
if (mysql_num_rows($mQuery4) > 0)
{
	$intWorthRow = mysql_fetch_assoc($mQuery4);
	$nettworth = $nettworth + $intWorthRow['inttotal'];
}
// End netto worth


// properties
$propArr = array();
if (!isset($_SESSION['houseallow']))
	$_SESSION['houseallow'] = array();
	
$mQuery5 = mysql_query("SELECT `id`,`name` FROM `interiors` WHERE `owner`='".$characterData['id']."'");
while ($introw = mysql_fetch_assoc($mQuery5))
{
	$_SESSION['houseallow'][$introw['id']] = true;
	$propArr[$introw['id']] = $introw['name'];
}
// end properties

if (!isset($_GET['param3']) || $_GET['param3'] == 'view')
{	// Show character details and edit fields
?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left"><?php echo $global['UCP']['CHAR']['Title']; ?></h3>
            <p class="left description "><?php echo $global['UCP']['CHAR']['Status'];  ?></p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth notopmargin last">	<br /><br />
			<form action="" method="post">
				<h2 class="colored">Character: <?php echo $characterData["charactername"];?></h2>
				<br />
					<table width="100%" border="0">
						<tr>
						<td><img class="UCPcharacterA" src="/images/chars/<?php echo $add.$addd.$characterData['skin']; ?>.png"></td>
						<td colspan="2" align="left">
						<h4>Character Stats</h4>
						<p>
						<?php echo $factionStr; ?>
						Nett worth: $ <?php echo $nettworth; ?><BR />
						Hours on Character: <?php echo $characterData['hoursplayed']; ?><BR />
						Created: <?php echo $characterData['creationdate']; ?><BR />
						Last Login: <?php echo $characterData['lastlogin']; ?><BR />
						</p>
						</td>
						</tr>
						<tr>
						<td valign="top">
						<h4>Character Information</h4>
						<input type="text" name="ageval" class="text-inputs" value="<?php echo $characterData['age']; ?>" maxlength="2" size="1" /><label for="ageval">Age (16-99)</label>
						<input type="text" name="heightval" class="text-inputs" value="<?php echo $characterData['height']; ?>" maxlength="3" size="1" /><label for="heightval">Height (150-200)</label>
						<?php if ($characterData['active'] == 1) { 
						//input type="checkbox" name="charactive" <?php if ($characterData['active'] == 1) echo 'CHECKED'; ?/>/><BR />
						?>
						<input type="submit" name="deactivatechar" value="Deactivate <?php echo $characterData['charactername'];?>" class="button2"/>
						<?php } else { ?>
						<input type="submit" name="activatechar" value="Activate <?php echo $characterData['charactername'];?>" class="button2"/>
						<?php } ?>
						<input type="submit" name="submitsave" value="Save Changes" class="button"/>
						</td>
						<td valign="top" colspan="2">
						<h4>Characters Properties</h4>
						<ul>
			<?php
				if (count($propArr) == 0)
				{
				?>
				<li><?php echo $characterData['charactername'];?> does not own any properties.</li>
				<?php
				}
				else {
					foreach ($propArr as $propertyID => $propertyName)
					{
						echo '						<p class="small-italic notopmargin">Select an interior for more information</p>';
						echo "<li><a class=\"link\" href=\"/ucp/interior/".$propertyID."/\">".$propertyName."</a> (ID: $propertyID)</li>\r\n";
					}
				}
			?>
						</ul>
						</td>
					</tr>
				</table>
			</form>
								
		</div>
        
		<?php } ?>
		<!-- END MAIN CONTENT -->