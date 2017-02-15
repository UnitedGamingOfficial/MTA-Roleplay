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
$mQuery1 = mysql_query("SELECT `username`,`admin` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	#header("Location: /ucp/login/");
	#die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$adminLevel = $userRow['admin'];

if ($adminLevel < 2)
{
	header("Location: /ucp/main/");
	die();
}

if (!isset($_GET['action']) or $_GET['action'] == "accsearch")
{
}
?>

<div class="one notopmargin">
<?php require_once("./././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
<h3 class="welcome nobottommargin left">ACCOUNT SEARCH</h3>
			<p class="small-italic notopmargin clear"><a href="/admin/main/" class="link">Admin Dashboard</a></p>
		
<?php

	require_once("./././includes/ucp_functions.php");

	$termacc = $_POST['termacc'];
 
	$sql_1 = mysql_query("SELECT * FROM accounts WHERE username LIKE '%$termacc%'") or die ('Error: '.mysql_error ());	
		
	while ($result_1 = mysql_fetch_assoc($sql_1)){
		echo '<b><a href="/admin/accsearchm"><p class="colored">Go back for a new search</p></a></b>';
		echo '<br/><br/><b><h2>SEARCH RESULTS</h2></b>';
		echo '<br/><br/>ID: '.$result_1['id'];
		echo '<br/> Username: '.$result_1['username'];
		echo '<br/> E-Mail address: '.$result_1['email'];
		echo '<br><br><hr></hr><br> Registration Date: '.$result_1['registerdate'];
		echo '<br/> Last Login: '.$result_1['lastlogin'];
		echo '<br/> IP: '.$result_1['ip'];
		echo '<br/> MTA Serial: '.$result_1['mtaserial'];
		echo '<br/><br/> Donator Points: '.$result_1['credits'];
		echo '<br/> Stat Transfers Remaining: '.$result_1['transfers'];
		echo '<br/><br/> Admin Level: '.$adminIDtoName[$result_1['admin']];
		echo ' (ID: '.$result_1['admin'];
		echo ')';
		echo '<br/> Admin Reports handled: '.$result_1['adminreports'];
		echo '<br/><br/> Admin Note: '.$result_1['adminnote'];
		echo '<br/><br/> Monitor Note: '.$result_1['monitored'];
		echo '<br><br><hr></hr><br>';
		
	$sql_2 =  mysql_query("SELECT * FROM characters WHERE account = '$result_1[id]'") or die ('Error: '.mysql_error ());
	
	while ($result_2 = mysql_fetch_assoc($sql_2)){
		echo '<b><h2>CHARACTER DETAILS</h2></b>';
		echo '<br/><br/>ID: '.$result_2['id'];
		echo '<br/> Character Name: '.$result_2['charactername'];
		echo '<br/> Gender: '.$result_2['gender'];
		echo '<br/> Skin: '.$result_1['skin'];
		echo '<br/> Age: '.$result_2['age'];
		echo '<br/> Weight: '.$result_2['weight'];
		echo '<br/> Height: '.$result_2['height'];
		echo '<br/> Description: '.$result_2['description'];
		echo '<br/>';
		echo '<br/> Money on Hand: '.$result_2['money'];
		echo '<br/> Bank Money: '.$result_2['bankmoney'];
		echo '<br/> Drivers License: '.$result_2['car_license'];
		echo '<br/> Firearms License: '.$result_2['gun_license'];
		echo '<br/> Last area: '.$result_2['lastarea'];
		echo '<br/> Interior ID: '.$result_2['interior_id'];
		echo '<br/> Dimension ID: '.$result_2['dimension_id'];
		echo '<br/> Hours played: '.$result_2['hoursplayed'];
		echo '<br/> CKd: '.$result_2['cked'];
		echo '<br/> Last login: '.$result_2['lastlogin'];
		echo '<br/> Created: '.$result_2['creationdate'];
		echo '<br/>';
		echo '<br/>';
		echo 'Faction ID: '.$result_2['faction_id'];
		echo '<br/> Faction Rank: '.$result_2['faction_rank'];
		echo '<br/><br/>';
		echo '<blockquote><b><h2>INVENTORY ITEM DETAILS</h2></b></blockquote>';
		
	$sql_9 = mysql_query("SELECT * FROM items WHERE type = 1 AND owner = '$result_2[id]'") or die ('Error: '.mysql_error());
	
	if(mysql_num_rows($sql_9) != 0)
	{
		echo '<blockquote><blockquote>';
		echo '<p class="colored">Name -- ID -- Value</p>' ;
		while($result_9 = mysql_fetch_assoc($sql_9))
		{
			
			echo '<li>' . $itemIDtoName[$result_9['itemID']] .' -- ' . $result_9['itemID'] . ' -- ' .$result_9['itemValue'] .  '</li>' ;
		
		}
		echo '</blockquote></blockquote>';
	}
	else
	{
	echo '<blockquote><blockquote>';
	echo 'No items in characters inventory.' ;
	echo '</blockquote></blockquote>';
	}
		
	$sql_3 =  mysql_query("SELECT * FROM interiors WHERE owner = '$result_2[id]'") or die ('Error: '.mysql_error ());
	
	while ($result_3 = mysql_fetch_assoc($sql_3)){
		echo '<br/><br/>';
		echo '<b><h2>INTERIOR DETAILS</h2></b>';
		echo '<br/><br/> ID: '.$result_3['id'];
		echo '<br/> Interior Name: '.$result_3['name'];
		echo '<br/> Interior Type: '.$result_3['type'];
		echo '<br/> Cost: $'.$result_3['cost'];
		echo '<br/> Supplies: '.$result_3['supplies'];
		echo '<br/> Safe Position:';
		echo ' X: '.$result_3['safepositionX'];
		echo ', Y: '.$result_3['safepositionY'];
		echo ', Z: '.$result_3['safepositionZ'];
		echo '<br/><br/> Last Used: '.$result_3['lastused'];
		echo '<br/><br/>';
		echo '<blockquote><b><h2>INTERIOR ITEM DETAILS</h2></b></blockquote>';
		
		$sql_6 =  mysql_query("SELECT * FROM worlditems WHERE dimension ='$result_3[id]' AND interior ='$result_3[interior]'") or die ('Error: '.mysql_error ());
	
		if(mysql_num_rows($sql_6) != 0)
		{
			echo '<blockquote><blockquote>';
			echo '<p class="colored">Name -- ID -- Value</p>' ;
			while($result_6 = mysql_fetch_assoc($sql_6))
			{
				
				echo '<li>' . $itemIDtoName[$result_6['itemid']] .' -- ' . $result_6['itemid'] . ' -- ' .$result_6['itemvalue'] .  '</li>' ;
			
			}
			echo '</blockquote></blockquote>';
		}
		else
		{
		echo '<blockquote><blockquote>';
		echo 'No items dropped in interior.' ;
		echo '</blockquote></blockquote>';
		}
		echo '<br/>';
		echo '<blockquote><b><h2>INTERIORS SAFE ITEM DETAILS</h2></b></blockquote>';
		
		$sql_7 =  mysql_query("SELECT * FROM items WHERE type ='4' AND owner ='$result_3[id]'") or die ('Error: '.mysql_error ());
	
		if(mysql_num_rows($sql_7) != 0)
		{
			echo '<blockquote><blockquote>';
			echo '<p class="colored">Name -- ID -- Value</p>' ;
			while($result_7 = mysql_fetch_assoc($sql_7))
			{
				
				echo '<li>' . $itemIDtoName[$result_7['itemID']] .' -- ' . $result_7['itemID'] . ' -- ' .$result_7['itemValue'] .  '</li>' ;
			
			}
			echo '</blockquote></blockquote>';
		}
		else
		{
		echo '<blockquote><blockquote>';
		echo 'No items dropped in interiors safe.' ;
		echo '</blockquote></blockquote>';
		}
		echo '<br/><br/>';
	}
	
	$sql_4 =  mysql_query("SELECT * FROM vehicles WHERE owner = '$result_2[id]'") or die ('Error: '.mysql_error ());
	
	while ($result_4 = mysql_fetch_assoc($sql_4)){
		echo '<b><h2>VEHICLE DETAILS</h2></b>';
		echo '<br/><br/> ID: '.$result_4['id'];
		echo '<br/> Model ID: '.$result_4['model'];
		echo '<br/> Model Name: '.$vehicleIDtoName[$result_4['model']];
		echo '<br/> Tinted: '.$result_4['tintedwindows'];
		echo '<br/><br/>';
		echo '<blockquote><b><h2>VEHICLE ITEM DETAILS</h2></b></blockquote>';
		
	$sql_5 =  mysql_query("SELECT * FROM items WHERE type ='2' AND owner ='$result_4[id]'") or die ('Error: '.mysql_error ());
	
		if(mysql_num_rows($sql_5) != 0)
		{
			echo '<blockquote><blockquote>';
			echo '<p class="colored">Name -- ID -- Value</p>' ;
			while($result_5 = mysql_fetch_assoc($sql_5))
			{
				
				echo '<li>' . $itemIDtoName[$result_5['itemID']] .' -- ' . $result_5['itemID'] . ' -- ' .$result_5['itemValue'] .  '</li>' ;
			
			}
			echo '</blockquote></blockquote>';
		}
		else
		{
		echo '<blockquote><blockquote>';
		echo 'No items dropped in interiors shelves.' ;
		echo '</blockquote></blockquote>';
		}
		echo '<hr>';
	}
	echo '<p class="colored"><a href="/admin/accsearchm/">Go back for a new search</a></p>';
	echo '<br/><br/>';
    }
    }

?>
			</div>
		</div>
	</div>
	
<?php
	echo mysql_error();
?>