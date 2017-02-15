<?php
// Validating etc has been done by the file that includes this one
	#require_once("includes/header.php");
	require_once("includes/mta_sdk.php");

	echo "<form action=\"\" method=\"POST\">";
	echo "Serial number: <input type=\"text\" name=\"serial\"";
	if (isset($_POST['serial']))
		echo " value=\"".$_POST['serial']."\"";
	echo "> <input type=submit name=submit value=Search>";
	echo "</form><BR /><BR />";
	
	echo "<form action=\"\" method=\"POST\">";
	echo "<input type=submit name=all value=Recent ammunation sales>";
	echo "</form><BR /><BR />";
	
	if (isset($_POST['serial']))
	{
		$mtaServer = new mta($Config['server']['hostname'], 22003, $Config['server']['username'], $Config['server']['password'] );
		$serverResource = $mtaServer->getResource("usercontrolpanel");
		trace($_POST['serial']);
	}
	elseif (isset($_POST['all']))
	{
		$mtaServer = new mta($Config['server']['hostname'], 22003, $Config['server']['username'], $Config['server']['password'] );
		$serverResource = $mtaServer->getResource("usercontrolpanel");
		$mQueryList = mysql_query("SELECT split_str(content, ':', 2) as 'serial', split_str(content, ' ', 3) as 'seriala',   split_str(content, ' ', 4) as 'serialb',content FROM `logtable` WHERE 
((`action`=36 and content not like '%ammo%') OR (`action`=4 and content like '%GIVEWEAPON%' )) AND
`time` > (NOW() - INTERVAL 2 WEEK) ORDER BY `time` ASC");
		while ($row = mysql_fetch_assoc($mQueryList))
		{
			if (strlen($row['serial']) > 14)
				trace($row['serial']);
			elseif (strlen($row['seriala']) > 14)
				trace($row['seriala']);
			elseif (strlen($row['serialb']) > 14)
				trace($row['serialb']);
			else
				echo "Error<HR />";
		}
	}
	function trace($serial)
	{
		global $MySQLConn, $Config, $mtaServer, $serverResource;
		echo "<h3>".$serial."</h3>";
		$mQueryItem = mysql_query("SELECT `index`,`type`,`owner`,`itemValue` FROM `items` WHERE itemID=115 AND itemValue LIKE '%".mysql_real_escape_string($serial)."%'", $MySQLConn);
		if (mysql_num_rows($mQueryItem) == 0)
			echo "No results found for this serialnumber in an inventory.<BR /> <BR />";
		else {
			while ($mQueryItemRow = mysql_fetch_assoc($mQueryItem))
			{
				$type = $mQueryItemRow['type'];
				echo "<table>";
				echo "<tr><td>ItemIndex</td><td>".$mQueryItemRow['index']."</td><td></td></tr>";
				echo "<tr><th>Current Owner</th><td></td><td></td></tr>";
				echo "<tr><td>Type Owner</td><td>".typeOwner($mQueryItemRow['type']) ."</td><td></td></tr>";
				
				if ($type == 4)
				{
					$mQueryCurrentOwner = mysql_query("select 
i.`id` as 'interiorID',
i.safePositionX as 'safePositionX',
i.safePositionX as 'safePositionY',
i.safePositionX as 'safePositionZ',
i.id as 'safeDimension',
i.interior as 'safeInterior',
i.name as 'interiorName',
i.owner as 'interiorOwnerID',
c.id as 'charid',
c.charactername as 'characterName',
a.username as 'accountName',
a.id as 'userid' 
from interiors i 
left join characters c on c.id=i.owner
left join accounts a on c.account=a.id
WHERE i.id='".mysql_real_escape_string($mQueryItemRow['owner'])."'", $MySQLConn);
					while ($mQueryCurrentOwnerRow = mysql_fetch_assoc($mQueryCurrentOwner))
					{
						echo "<tr><td></td><td>interiorID</td><td>".$mQueryCurrentOwnerRow['interiorID']."</td></tr>";

						echo "<tr><td></td><td>Safe Position</td><td>X: ".$mQueryCurrentOwnerRow['safePositionX']."</td></tr>";
						echo "<tr><td></td><td></td><td>Y: ".$mQueryCurrentOwnerRow['safePositionY']."</td></tr>";
						echo "<tr><td></td><td></td><td>Z: ".$mQueryCurrentOwnerRow['safePositionZ']."</td></tr>";
						echo "<tr><td></td><td></td><td>Interior: ".$mQueryCurrentOwnerRow['safeInterior']."</td></tr>";
						echo "<tr><td></td><td></td><td>Dimension: ".$mQueryCurrentOwnerRow['safeDimension']."</td></tr>";
						
						echo "<tr><td></td><td>interiorName</td><td>".$mQueryCurrentOwnerRow['interiorName']."</td></tr>";
						echo "<tr><td></td><td>interiorOwner Name</td><td>".$mQueryCurrentOwnerRow['characterName']."</td></tr>";
						echo "<tr><td></td><td>interiorOwner Account</td><td>".$mQueryCurrentOwnerRow['accountName']."</td></tr>";
					}
				}
				
				if ($type == 3)
				{
					$mQueryCurrentOwner = mysql_query("select 
w.`id` as 'worldItemIndex',
w.`itemid` as 'worldItemID',
w.x as 'itemPosX',
w.y as 'itemPosY',
w.z as 'itemPosZ',
w.dimension as 'itemDimension',
w.interior as 'itemInterior',
i.id as 'interiorID',
i.name as 'interiorName',
i.owner as 'interiorOwnerID',
c.charactername as 'characterName',
c.id as 'charid',
a.username as 'accountName',
a.id as 'userid',
from worlditems w 
left join interiors i on w.dimension=i.id
left join characters c on c.id=i.owner
left join accounts a on c.account=a.id
WHERE w.id='".mysql_real_escape_string($mQueryItemRow['owner'])."'", $MySQLConn);
					while ($mQueryCurrentOwnerRow = mysql_fetch_assoc($mQueryCurrentOwner))
					{
						echo "<tr><td></td><td>ObjectID</td><td>".$mQueryCurrentOwnerRow['worldItemIndex']."</td></tr>";
						echo "<tr><td></td><td>itemID</td><td>".$mQueryCurrentOwnerRow['worldItemID']."</td></tr>";
						echo "<tr><td></td><td>Position</td><td>X: ".$mQueryCurrentOwnerRow['itemPosX']."</td></tr>";
						echo "<tr><td></td><td></td><td>Y: ".$mQueryCurrentOwnerRow['itemPosY']."</td></tr>";
						echo "<tr><td></td><td></td><td>Z: ".$mQueryCurrentOwnerRow['itemPosZ']."</td></tr>";
						echo "<tr><td></td><td></td><td>Interior: ".$mQueryCurrentOwnerRow['itemInterior']."</td></tr>";
						echo "<tr><td></td><td></td><td>Dimension: ".$mQueryCurrentOwnerRow['itemDimension']."</td></tr>";
						
						echo "<tr><td></td><td>interiorID</td><td>".$mQueryCurrentOwnerRow['interiorID']."</td></tr>";
						echo "<tr><td></td><td>interiorName</td><td>".$mQueryCurrentOwnerRow['interiorName']."</td></tr>";
						echo "<tr><td></td><td>interiorOwner Name</td><td>".$mQueryCurrentOwnerRow['characterName']."</td></tr>";
						echo "<tr><td></td><td>interiorOwner Account</td><td>".$mQueryCurrentOwnerRow['accountName']."</td></tr>";
						
						$checkCharID = $mQueryCurrentOwnerRow['charid'];
						$checkAccountID = $mQueryCurrentOwnerRow['userid'];
					}
				}
				if ($type == 2)
				{
					$mQueryCurrentOwner = mysql_query("select v.`id` as 'vehicleID',v.`owner` as 'characterID',v.`faction` as 'factionID', c.`charactername` as 'charactername', c.id as 'charid', a.`username` AS 'accountname',a.id as 'userid', f.`name` as factionName  from vehicles v left join `characters` c on c.id=v.owner left join `accounts` a on a.id=c.account left join `factions` f on f.id=v.faction WHERE v.`id`='".mysql_real_escape_string($mQueryItemRow['owner'])."'", $MySQLConn);
					while ($mQueryCurrentOwnerRow = mysql_fetch_assoc($mQueryCurrentOwner))
					{
						echo "<tr><td></td><td>VehicleID</td><td>".$mQueryCurrentOwnerRow['vehicleID']."</td></tr>";
						if ($mQueryCurrentOwnerRow['factionID'] == -1)
						{
							echo "<tr><td></td><td>Vehicle Type</td><td>Player owned</td></tr>";
							echo "<tr><td></td><td>Owner Username</td><td>".$mQueryCurrentOwnerRow['accountname']."</td></tr>";
							echo "<tr><td></td><td>Owner Character</td><td>".$mQueryCurrentOwnerRow['charactername']."</td></tr>";
						}
						else 
						{
							echo "<tr><td></td><td>Vehicle Type</td><td>Faction owned</td></tr>";
							echo "<tr><td></td><td>Owner Faction</td><td>".$mQueryCurrentOwnerRow['factionname']."</td></tr>";
						}
						
						$checkCharID = $mQueryCurrentOwnerRow['charid'];
						$checkAccountID = $mQueryCurrentOwnerRow['userid'];
						

					}
				}
				if ($type == 1)
				{
					$mQueryCurrentOwner = mysql_query("SELECT `id` as 'charid',`charactername`, account as 'userid',(SELECT username FROM accounts where accounts.id=characters.account) as 'accountname', (SELECT `name` FROM `factions` WHERE factions.id=characters.faction_id) FROM `characters` WHERE `id`='".mysql_real_escape_string($mQueryItemRow['owner'])."'", $MySQLConn);
					while ($mQueryCurrentOwnerRow = mysql_fetch_assoc($mQueryCurrentOwner))
					{
						echo "<tr><td></td><td>Owner Username</td><td>".$mQueryCurrentOwnerRow['accountname']."</td></tr>";
						echo "<tr><td></td><td>Owner Character</td><td>".$mQueryCurrentOwnerRow['charactername']."</td></tr>";
						if (strlen($mQueryCurrentOwnerRow['factionname']) > 1)
							echo "<tr><td></td><td>Owner Faction</td><td>".$mQueryCurrentOwnerRow['factionname']."</td></tr>";
							
						$checkCharID = $mQueryCurrentOwnerRow['charid'];
						$checkAccountID = $mQueryCurrentOwnerRow['userid'];
					}
				}
				
				echo "</table>";
				
				
				
			}
		}
		
		
		$mQueryItem = mysql_query("select w.id,w.x,w.y,w.z,w.dimension,w.interior,w.creationdate,w.creator,w.itemValue,c.charactername,c.id as 'charid',a.username,a.id as 'userid',i.id as 'interiorID', i.name as 'interiorName', c2.charactername as 'interiorCharacterName', a2.username as 'interiorUsername' from worlditems w 
left join characters c on w.creator=c.id
left join accounts a on a.id=c.account
left join interiors i on w.dimension=i.id
 left join characters c2 on i.owner=c2.id
 left join accounts a2 on a2.id=c2.account WHERE itemID=115 AND itemValue LIKE '%".mysql_real_escape_string($serial)."%'", $MySQLConn);
		if (mysql_num_rows($mQueryItem) == 0)
			echo "No results found for this serialnumber in as worldobject.<BR /> <BR />";
		else {
			while ($mQueryCurrentOwnerRow = mysql_fetch_assoc($mQueryItem))
			{
				echo "<table>";
				echo "<tr><td>ItemIndex</td><td>".$mQueryItemRow['id']."</td><td></td></tr>";
				echo "<tr><th>Current Owner</th><td></td><td></td></tr>";
				echo "<tr><td>Type Owner</td><td> actual worlditem</td><td></td></tr>";
				echo "<tr><td></td><td>Position</td><td>X: ".$mQueryCurrentOwnerRow['x']."</td></tr>";
				echo "<tr><td></td><td></td><td>Y: ".$mQueryCurrentOwnerRow['y']."</td></tr>";
				echo "<tr><td></td><td></td><td>Z: ".$mQueryCurrentOwnerRow['z']."</td></tr>";
				echo "<tr><td></td><td></td><td>Interior: ".$mQueryCurrentOwnerRow['interior']."</td></tr>";
				echo "<tr><td></td><td></td><td>Dimension: ".$mQueryCurrentOwnerRow['dimension']."</td></tr>";
				echo "<tr><td></td><td>Dropped when</td><td>".$mQueryCurrentOwnerRow['creationdate']."</td></tr>";
				echo "<tr><td></td><td>Dropped by</td><td>".$mQueryCurrentOwnerRow['charactername']."</td></tr>";
				echo "<tr><td></td><td>InteriorID</td><td>".$mQueryCurrentOwnerRow['interiorID']."</td></tr>";
				echo "<tr><td></td><td>interiorName</td><td>".$mQueryCurrentOwnerRow['interiorName']."</td></tr>";
				echo "<tr><td></td><td>interior owner CharacterName</td><td>".$mQueryCurrentOwnerRow['interiorCharacterName']."</td></tr>";
				echo "<tr><td></td><td>interior owner Username</td><td>".$mQueryCurrentOwnerRow['interiorUsername']."</td></tr>";
				echo "</table>";
				$checkCharID = $mQueryCurrentOwnerRow['charid'];
				$checkAccountID = $mQueryCurrentOwnerRow['userid'];
			}
		}
		
		echo "<table>";
		echo "<tr><th>Actual decode</th><td></td><td></td></tr>";
		
		$serialTrace = $serverResource->call("retrieveWeaponDetails", mysql_real_escape_string($serial));
		echo "<tr><td>Time of spawn</td><td>".date("l jS \of F Y h:i:s A", $serialTrace[0][0] + 1314835200)."</td><td></td></tr>";
		echo "<tr><td>Method of Spawning</td><td>".methodOfSpawning($serialTrace[0][1])."</td><td></td></tr>";
		$mQueryItema = mysql_query("select charactername, account, (select username from accounts where accounts.id=characters.account) as 'username' from characters where id='".mysql_real_escape_string($serialTrace[0][2])."'");
		$mQueryItemb = mysql_fetch_assoc($mQueryItema);
		echo "<tr><td>Spawned By</td><td>".$mQueryItemb['username']."/".$mQueryItemb['charactername']."(".$serialTrace[0][2].")</td><td></td></tr>";
		echo "</table>";
		
		//print_r($mQueryCurrentOwnerRow);
		
		if (!isset($checkCharID ))
		{
			echo "<h3>Gun does not exist anymore?</h3>";
		}
		elseif ($checkCharID == $serialTrace[0][2])
		{
			echo "<h3 style=\"color: green;\">Gun is on same character as spawned</h3>";
		}
		elseif ($checkAccountID == $mQueryItemb['account'])
		{
			echo "<h3 style=\"color: red;\">Gun is on the same acocunt but other character (pls investigate, could be stattransfer (/history) )</h3>";
		}
		else
		{
			echo "<h3 style=\"color: yellow;\">Gun is not on the same acocunt anymore?</h3>";
		}
		
		echo "<hr /><BR />";

	}
	
	
	function methodOfSpawning($int)
	{
		if ($int == 1)
			return "Admin spawned";
		elseif ($int == 2)
			return "/duty";
		elseif ($int == 3)
			return "Ammunation";
		else
			return "Unknown";
	}
	
	function typeOwner($int)
	{
		if ($int == 1) 
			return "Player inventory";
		elseif ($int == 2) 
			return "Vehicle inventory";	
		elseif ($int == 3) 
			return "Worlditem inventory";	
		elseif ($int == 4) 
			return "Object inventory";	
		else
			return "Unknown"; 
	}

	
	
	#require_once("includes/footer.php");
?>