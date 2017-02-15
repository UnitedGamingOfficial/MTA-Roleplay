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
?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left"><?php echo $global['UCP']['CHAR']['Title']; ?></h3>
            <p class="left description ">Viewing Interior Information</p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth notopmargin last">	<br /><br />
		<h2>Interior Details</h2><br />
		<ul>
			<li>Interior Name: <?php echo $interiorData['name']; ?></li>
			<li>Interior Cost: $<?php echo $interiorData['cost']; ?></li>
			<li>Interior Last Used: <?php echo $interiorData['lastused']; ?></li>
		</ul>
		<br />
		<br />
        
<?php
if ($credits >= 10)
{
?>	
		<p class="small-italic">Upload a custom mapping for your interior for 10 donPoints*.</p>
        <p>After you upload your .map file, it will have to be approved by the mapping team.</p>
		<p><span style="color:red">*We require the usage of donPoints to avoid abuse, however we will not force you to pay for donPoints to upload.</span></p>
        <p><span style="color:#FFCC00">To get free donPoints for uploading interior mapping, please contact <a href="http://www.unitedgaming.org/forums/member.php/1" target="_blank" class="link">TamFire</a> or <a href="http://www.unitedgaming.org/forums/member.php/2-Chuevo" target="_blank" class="link">FrolicBeast</a> for more information.</span></p>
        <form enctype="multipart/form-data" action="/ucp/interior/<?php echo $interiorID; ?>/update/" method="POST">
            <table>
                <tr>
                    <td><input name="userfile" type="file" size="1"/></td>
                    
                </tr>
                <tr>
                    
                    <td><input type="submit" class="button" value="Upload" /></td>
                </tr>
            </table>
        </form>
        <?php } else { ?>
        <p class="small-italic">You can upload custom mapping for your interior for 10 donPoints</p>
        <p>However, you have <?php echo $credits; ?> and cannot afford to upload.</p>
        <!--<p><span style="color:red">*We require the usage of donPoints to avoid abuse, however we will not force you to pay for donPoints to upload.</span></p>
        <p><span style="color:#FFCC00">To get free donPoints for uploading interior mapping, please contact <a href="http://www.unitedgaming.org/forums/member.php/22-TamFire" target="_blank" class="link">TamFire</a> or <a href="http://www.unitedgaming.org/forums/member.php/2-Chuevo" target="_blank" class="link">Chuevo</a> for more information.</span></p>-->
		<?php } ?>
	</div>
		<!-- END MAIN CONTENT -->
        <?php
}
elseif ($_GET['param3'] == "update")
{
	$error = false;
	$hasmarker = false;
	?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Interior Upload</h3>
            <p class="left description ">Uploading Interior...</p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth notopmargin last">
        
    <?php

	$allowedExtensions = array("map");
	foreach ($_FILES as $file) {
		if ($file['tmp_name'] > '') {
			if (!in_array(end(explode(".", strtolower($file['name']))), $allowedExtensions)) {
				echo '<p>'.$file['name'].' is an invalid file type! Must be .map<br/>
				<a href="javascript:history.go(-1);" class="link">Return</a>';
				$error = true;
			}
		}
	} 
		
	if (!$error and !is_uploaded_file($_FILES['userfile']['tmp_name']))
	{
		$error = true;
		echo '<p>The uploaded file is not found on the server!</p><br/>
		<a href="javascript:history.go(-1);">Return</a>';	
	}
		
	$fileData = file_get_contents($_FILES['userfile']['tmp_name']);
	if (!$error and !$fileData)
	{
		echo '<p>Invalid file uploaded, unable to read content.</p><br/>
		<a href="javascript:history.go(-1);">Return</a>';		
		$error = true;
	}
	
	$comment = $username." ".date("d-m-Y");
	// $interiorID
	
	if (!$error)
	{
	
		echo "<p>Connecting...</p>";
		echo "<p>Connection successful</p>";
		
		echo "<p>Uploading...</p>";
		echo "<p><span style=\"color:green\">100%</span></p>";
		
		echo "<h4>Running validation</h4> ";
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
				echo '<p>Error with object model ID '.$value['model'].', placed outside the would boundaries on the X axis</p>';
			}
			
			if ($posY > 3000 or $posY < -3000) 
			{
				$error = true;
				echo '<p>Error with object model ID '.$value['model'].', placed outside the would boundaries on the Y axis</p>';
			}
			
			if ($posZ > 3000 or $posZ < -3000) 
			{
				$error = true;
				echo '<p>Error with object model ID '.$value['model'].', placed outside the would boundaries on the Z axis</p>';
			}
			
			if ($interior < 1) 
			{
				$error = true;
				echo '<p>Error with object model ID '.$value['model'].', placed in an invalid interior.</p>';
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
					echo '<p>Error: The entrance is placed outside the would boundaries on the X axis</p>';
				}
				
				if ($spawnY > 3000 or $spawnY < -3000) 
				{
					$error = true;
					echo '<p>Error: The entrance is placed outside the would boundaries on the Y axis</p>';
				}
				
				if ($spawnZ > 3000 or $spawnZ < -3000) 
				{
					$error = true;
					echo '<p>Error: The entrance is placed outside the would boundaries on the Z axis</p>';
				}
				
				if ($spawnInterior < 1) 
				{
					$error = true;
					echo '<p>Error: The entrance is placed in an invalid interior.</p>';
				}		
				
				$hasmarker = true;
				break; // just the first one, please.				
			}
		}
		
		if (!$hasmarker)
		{
			$error = true;
			echo '<p>Error: The map does not have any marker/spawnpoint.</p>';
		}
		
		if (count($queries) > 450)
		{
			$error = true;
			echo '<p>Error: The map has exceeded the maximum number of objects (450).<BR />';
		}
	}
	
	if ($error)
	{
		echo "<p><span color=\"red\">Failed</span></p>";
		echo "<p>Errors are found in the file submitted, these should be fixed before use.</p>";
	}
	else {
		echo "<p><span color=\"green\">Passed!</span></p>";
		
		echo "<p>Syncing objects with the server...</p>";
		foreach ($queries as $id => $query)
		{
			mysql_query($query);
			echo ".";
			flush(); // fancy!
		}
		mysql_query("UPDATE `accounts` SET `credits`=`credits`-10 WHERE id='" . $userID . "'", $MySQLConn);
		echo "<p><span color=\"green\">Complete!</span></p>";
		echo "<p>Your map has been submitted to the mapping team, it will be validated as soon as possible.</p>";	
	}

?>
	</div>
		<!-- END MAIN CONTENT -->
 <?php
}
?>