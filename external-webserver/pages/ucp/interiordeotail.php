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
$mQuery1 = mysql_query("SELECT `username`,`credits` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$credits = $userRow['credits'];

// /ucp/interiors/<name>/ $param2
if (!isset($_GET['param2']))
{
	header("Location: /ucp/main/");
	exit;
}

$interiorID = mysql_real_escape_string($_GET['param2']);

if (!isset($_SESSION['houseallow']) or !isset($_SESSION['houseallow'][$interiorID]))
{
	header("Location: /ucp/main/");
	exit;
}

$mQuery2 = mysql_query("SELECT * FROM `interiors` WHERE `id`='".$interiorID."'");
if (mysql_num_rows($mQuery2) == 0 || mysql_num_rows($mQuery2) > 1)
{
	header("Location: /ucp/main/");
	exit;
}

$interiorData = mysql_fetch_assoc($mQuery2);

$queries = array();

if (strlen($interiorData['lastused']) < 2) {
	$interiorData['lastused'] = 'Never';
} else {
	$interiorData['lastused'] = $interiorData['lastused']." (GMT +1)";
}


if (!isset($_GET['param3']) || $_GET['param3'] == 'view')
{
?>				<!-- Middle Column - main content -->
					<div id="content-middle">
						<div class="content-box">
							<div class="content-holder">
								<h2>User Control Panel - Interior information</h2>
								<BR />
								<BR />
								<table border="0">
									<tr>
										<td>Interior Name</td>
										<td><?php echo $interiorData['name']; ?></td>
										<td width="50%" rowspan="3">At this page, you can spend your vPoints on getting a custom interior for your property. The property you have selected has the following details at the moment as you see on the left side. The interior will stay like this until you put another interior on it. After you put the map in, the map is going to be reviewed by our mapping team. They will look if the interior is realistic, and fits the exterior. If they accept your uploaded map, it will be available ingame. You need 25 vPoints to use this feature. </td>									</tr>
									<tr>
										<td>Cost</td>
										<td>$ <?php echo $interiorData['cost']; ?></td>
									</tr>
									<tr>
										<td>Last used</td>
										<td><?php echo $interiorData['lastused']; ?></td>
									</tr>
								</table>
<?php
if ($credits >= 25)
{
?>								<form enctype="multipart/form-data" action="/ucp/interior/<?php echo $interiorID; ?>/update/" method="POST">
									<table>
										<tr>
											<td>Upload your .map file:</td>
											<td><input name="userfile" type="file" /></td>
										</tr>
										<tr>
											<td></td>
											<td><input type="submit" value="Continue >>" /></td>
										</tr>
									</table>
								</form>
<?php
} else {
?>									You have <?php echo $credits; ?> vPoints, and thusfar don't have enough vPoints to use this feature.<BR />
<?php
}
?>							</div>
						</div>
					</div>	
<?php
	require_once("././includes/footer.php");
}
elseif ($_GET['param3'] == "update" and $credits >= 25)
{
	$error = false;
	$hasmarker = false;
	require_once("././includes/header.php");
	echo "					<!-- Middle Column - main content -->";
	echo "					<div id=\"content-middle\">";
	echo "						<div class=\"content-box\">";
	echo "							<div class=\"content-holder\">";
	echo "								<h2>User Control Panel - Interior upload</h2>";
	
	$allowedExtensions = array("map");
	foreach ($_FILES as $file) {
		if ($file['tmp_name'] > '') {
			if (!in_array(end(explode(".", strtolower($file['name']))), $allowedExtensions)) {
				echo $file['name'].' is an invalid file type!<br/><a href="javascript:history.go(-1);">&lt;&lt Go Back</a>';
				$error = true;
			}
		}
	} 
		
	if (!$error and !is_uploaded_file($_FILES['userfile']['tmp_name']))
	{
		$error = true;
		echo 'The uploaded file is not found on the server!<br/><a href="javascript:history.go(-1);">&lt;&lt Go Back</a>';	
	}
		
	$fileData = file_get_contents($_FILES['userfile']['tmp_name']);
	if (!$error and !$fileData)
	{
		echo 'Error getting the content of the file.<br/><a href="javascript:history.go(-1);">&lt;&lt Go Back</a>';		
		$error = true;
	}
	
	$comment = $username." ".date("d-m-Y");
	// $interiorID
	
	if (!$error)
	{
	
		echo "Establishing a connection to the gameserver... ";
		echo "Connected!<BR />";
		
		echo "Uploading the map... ";
		echo "100%<BR />";
		
		echo "Validating the map... ";
		flush();
		
		// Cleanup old items
		$queries[] = "DELETE FROM `tempobjects` WHERE `dimension`='".$interiorID."'";
		$queries[] = "DELETE FROM `tempinteriors` WHERE `id`='".$interiorID."'";
		
		// Going to parse the map, try some checks here
		$xml = @simplexml_load_string($fileData);
		foreach ($xml->object as $id => $value){ 	
			$model = mysql_real_escape_string($value['model']);
			$posX = mysql_real_escape_string($value['posX']);
			$posY = mysql_real_escape_string($value['posY']);
			$posZ = mysql_real_escape_string($value['posZ']);
			$rotX = mysql_real_escape_string($value['rotX']);
			$rotY = mysql_real_escape_string($value['rotY']);
			$rotZ = mysql_real_escape_string($value['rotZ']);
			$interior = mysql_real_escape_string($value['interior']);
			
			if (isset($value['doublesided']) and ($value['doublesided'] == 'true'))
				$doublesided = 1;
			else
				$doublesided = 0;

			if (isset($value['solid']) and ($value['solid'] == 'false'))
                                $solid = 0;
                        else
                                $solid = 1;

			
			if ($posX > 3000 or $posX < -3000) 
			{
				$error = true;
				echo 'Error: Object with model ID '.$value['model'].' is placed outside the would boundaries on the X axis<BR />';
			}
			
			if ($posY > 3000 or $posY < -3000) 
			{
				$error = true;
				echo 'Error: Object with model ID '.$value['model'].' is placed outside the would boundaries on the Y axis<BR />';
			}
			
			if ($posZ > 3000 or $posZ < -3000) 
			{
				$error = true;
				echo 'Error: Object with model ID '.$value['model'].' is placed outside the would boundaries on the Z axis<BR />';
			}
			
			if ($interior < 1) 
			{
				$error = true;
				echo 'Error: Object with model ID '.$value['model'].' is placed in an invalid interior.<BR />';
			}
			flush();
			$makequery = "INSERT INTO `tempobjects` (`model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `doublesided`,`solid`, `comment`) VALUES ('" . $model . "', '" . $posX . "', '".$posY."', '".$posZ."', '".$rotX."', '".$rotY."', '".$rotZ."', '".$interior."', '".$interiorID."', '".$doublesided."', '".$solid."', '".$comment."')";	
			$queries[] = $makequery;
		}
		
		if (isset($xml->marker))
		{ // Update the interior spawn location
			foreach ($xml->marker as $id => $value){ 
				$spawnX = mysql_real_escape_string($value["posX"]);
				$spawnY = mysql_real_escape_string($value["posY"]);
				$spawnZ = mysql_real_escape_string($value["posZ"]);
				$spawnInterior = mysql_real_escape_string($value['interior']);
				$queries[] = "INSERT into `tempinteriors` SET `posX`='".$spawnX."', `posY`='".$spawnY."', `posZ`='".$spawnZ."', `interior`='". $spawnInterior ."', `id`='".$interiorID."'";
				
				if ($spawnX > 3000 or $spawnX < -3000) 
				{
					$error = true;
					echo 'Error: The entrance is placed outside the would boundaries on the X axis<BR />';
				}
				
				if ($spawnY > 3000 or $spawnY < -3000) 
				{
					$error = true;
					echo 'Error: The entrance is placed outside the would boundaries on the Y axis<BR />';
				}
				
				if ($spawnZ > 3000 or $spawnZ < -3000) 
				{
					$error = true;
					echo 'Error: The entrance is placed outside the would boundaries on the Z axis<BR />';
				}
				
				if ($spawnInterior < 1) 
				{
					$error = true;
					echo 'Error: The entrance is placed in an invalid interior.<BR />';
				}		
				
				$hasmarker = true;
				break; // just the first one, please.				
			}
		}
		
		if (!$hasmarker)
		{
			$error = true;
			echo 'Error: The map does not have any marker/spawnpoint.<BR />';
		}
		
		if (count($queries) > 450)
		{
			$error = true;
			echo 'Error: The map has exceeded the maximum number of objects (450).<BR />';
		}
	}
	
	if ($error)
	{
		echo "<font color=\"red\">Failed</font><BR />";
		echo "<BR />One or more errors are found in the file. The errors should be described above and be fixed before you can use the mapfile as an interior.";
	}
	else {
		echo " Passed!<BR /><BR />";
		
		echo "Syncronizing the new objects with the server...";
		foreach ($queries as $id => $query)
		{
			mysql_query($query);
			echo ".";
			flush(); // fancy!
		}
		mysql_query("UPDATE `accounts` SET `credits`=`credits`-25 WHERE id='" . $userID . "'", $MySQLConn);
		echo " Done<BR /><BR />";
		echo "The map has been submitted to the MTA:RP mapping team, and they will validate the map as soon as possible.";	
	}

	echo "							</div>";
	echo "						</div>";
	echo "					</div>";
}

?>
