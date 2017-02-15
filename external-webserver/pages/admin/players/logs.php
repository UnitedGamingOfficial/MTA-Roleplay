<?php
		if ($adminLevel < 2)
	{
		header("Location: /ucp/main/");
		die();
	}
	// Validating etc has been done by the file that includes this one
	require_once("includes/header.php");
	require_once("includes/mta_sdk.php");
	
	$logTypes = array (
	'1'     => array('Admin - /h',             6,    false,    20.3),
        '2'     => array('Admin - /l',             5,    false,    20.2),
        '3'     => array('Admin - /a',             5,    false,    20.1),
        '4'     => array('Admin - Commands',         5,    false,    20),
        '5'    => array('Anticheat warnings',         5,    false,    30),
        '6'    => array('Action - Vehicles',        4,    false,    15.6),
        '7'    => array('IC - say',            2,    false,    5),
        '8'    => array('OOC - Local',            2,    false,    10),
        '9'    => array('IC - Radio',            2,    false,    5.5),
        '10'    => array('IC - Department Radio',    2,    false,    5.51),
        '11'    => array('OOC - Faction',        2,    false,    10.5),
        '12'    => array('IC - /me',            2,    false,    5.1),
        '13'    => array('IC - District',        2,    false,    5.98),
        '14'    => array('IC - /do',            2,    false,    5.11),
        '15'    => array('OOC - PM',            5,    false,    10.3),
        '16'    => array('IC - Gov. Announcement',    2,    true,    5.95),
        '17'    => array('OOC - Donator',        4,    false,    10.8),
        '18'    => array('OOC - Global',        4,    false,    10.1),
        '19'    => array('IC - Shout',            2,    false,    5.7),
        '20'    => array('IC - Megaphone',        2,    false,    5.6),
        '21'    => array('IC - Whisper (/w)',        2,    false,    5.71),
        '22'    => array('IC - close Whisper (/c)',    2,    false,    5.72),
        '23'    => array('IC - News',            2,    true,    5.9),
        '24'    => array('Gamemaster chat',        5,    false,    20.7),
        '25'    => array('Action - Cash transfer',    2,    false,    15.2),
        '27'    => array('Connection/Charselect',    2,    false,    15),
        '28'    => array('Roadblock & Spikes',    2,    true,    15.7),
        '29'    => array('IC - Phone',            2,    false,    5.3),
        '30'    => array('IC - SMS',            2,    false,    5.31),
        '31'    => array('Action - Lock/Unlock',    2,    false,    15.4),
        '32'    => array('UCP',                6,    false,    20.8),
        '33'    => array('Stattransfers',        2,    false,    25.1),
        '34'    => array('Kills/Lost items',        2,    false,    25),
        '35'    => array('Action - Factions',        2,    true,    15.5),
        '36'    => array('Ammunation',            2,    true,    25.2),
        '37'    => array('Action - Interiors',        2,    false,    15.7),
		'38'    => array('Admin Reports',         5,     false, 21),
        '39'    => array('Item movement',         2,     false, 30),

	);

	$characterCache = array();
	
	function nameCache($id)
	{
		global $characterCache, $MySQLConn;
		if (isset($characterCache[$id]))
			return $characterCache[$id];
		
		$pos = strpos($id, "ch");
		if ($pos === false) {
			$pos = strpos($id, "fa");
			if ($pos === false) {
				$pos = strpos($id, "ve");
				if ($pos === false) {
					$pos = strpos($id, "ac");
					if ($pos === false) {
						$pos = strpos($id, "in");
						if ($pos === false) {
							$pos = strpos($id, "ph");
							if ($pos === false) {
								$characterCache[$id] = $id.'[unrec]';
								return $id;
							}
							else {
								$tempid = substr($id, 2);
								$characterCache[$id] = "phone ".$tempid;
								return $id;
							}
						}
						else {
							$tempid = substr($id, 2);
							$characterCache[$id] = "interior ".$tempid;
							return $id;
						}
					}
					else {
						$tempid = substr($id, 2);
						$awsQry = mysql_query("SELECT `username` FROM `accounts` WHERE `id`='".$tempid."'");
						if (mysql_num_rows($awsQry) == 1)
						{
							$awsRow = mysql_fetch_assoc($awsQry);
							$characterCache[$id] = $awsRow['username'];
							return $awsRow['username'];
						}
						else {
							$characterCache[$id] = $id;
							return $id;
						}
					}
				}
				else {
					$tempid = substr($id, 2);
					$characterCache[$id] = "vehicle ".$tempid;
					return $characterCache[$id];
				}
			}
			else {
				$tempid = substr($id, 2);
				$awsQry = mysql_query("SELECT `name` FROM `factions` WHERE `id`='".$tempid."'");
				if (mysql_num_rows($awsQry) == 1)
				{
					$awsRow = mysql_fetch_assoc($awsQry);
					$characterCache[$id] = '[F]'.$awsRow['name'];
					return $awsRow['name'];
				}
				else {
					$characterCache[$id] = $id;
					return $id;
				}
			}
		}
		else
		{
			$tempid = substr($id, 2);
			$awsQry = mysql_query("SELECT `charactername` FROM `characters` WHERE `id`='".$tempid."'");
			if (mysql_num_rows($awsQry) == 1)
			{
				$awsRow = mysql_fetch_assoc($awsQry);
				$characterCache[$id] = $awsRow['charactername'];
				return $awsRow['charactername'];
			}
			else {
				$characterCache[$id] = $id.'['.$tempid.']';
				return $id;
			}
		}
	}

	$selectarr = array();
	if (isset($_POST['logtype']))
		foreach ($_POST['logtype'] as $entry)
			$selectarr[$entry] = true;

	
?>
		<!-- MAIN CONTENT -->
		<div class="one separator"></div>
		<!-- WELCOME BLOCK -->
		<div class="one notopmargin">
			<h3 class="welcome nobottommargin left">LOGS</h3>
			<p class="left description ">All actions on MTA and the CP are logged, admins may see specified criterea searches for those logged actions.</p>
			<p class="small-italic notopmargin clear"><a href="/admin/main/" class="link">RETURN TO ADMIN OVERVIEW</a></p>
		</div>
		<!-- END WELCOME BLOCK -->
		<script language="javascript">
function checkAll(){
	for (var i=0;i<document.forms[0].elements.length;i++)
	{
		var e=document.forms[0].elements[i];
		if ((e.name != 'allbox') && (e.type=='checkbox'))
		{
			e.checked=document.forms[0].allbox.checked;
		}
	}
}
</script>
		<form name='searchform' action='' method='POST'>
		<div class="one separator  margin15"></div>
		<div class="one last">
			<h1 align="center">MTA Logs</h1>
			<br />
			<center>
				<table border="0">
					<tr>
					<td rowspan="4">
					<input type="checkbox" value="on" name="allbox" onclick="checkAll();">Select All Options</input><br />
					<?php foreach ($logTypes as $id => $detailarr) if ($detailarr[1] <= $adminLevel) { ?>
						<input type="checkbox" id="<?php echo $id;?>" name=logtype[] value="<?php echo $id;?>"<?php if (isset($selectarr[$id])) echo ' CHECKED';?>><?php echo $detailarr[0];?><div/>
					<?php } ?>
						
					</td>
					<td valign="top">
						<label for="charname"><center>Search Term</center></label><input type="input" class="text-input" name="charname"<?php if (isset($_POST['charname'])) echo ' VALUE="'.$_POST['charname'].'"'; ?>>
						<label for="charname"><center>Search Term 2</center></label><input type="input" class="text-input" name="charname2"<?php if (isset($_POST['charname2'])) echo ' VALUE="'.$_POST['charname2'].'"'; ?>>
						<label for="charname"><center>Search Term 3</center></label><input type="input" class="text-input" name="charname3"<?php if (isset($_POST['charname3'])) echo ' VALUE="'.$_POST['charname3'].'"'; ?>>
						<label for="charname"><center>Search Term 4</center></label><input type="input" class="text-input" name="charname4"<?php if (isset($_POST['charname4'])) echo ' VALUE="'.$_POST['charname4'].'"'; ?>>
					</td>
					
					</tr>
					
					<tr>
					<td valign="top">
						<select name="type">
							<option value="-1" selected disabled>Type of search...</option>
							<option value="player"<?php if (isset($_POST['type']) and $_POST['type']=="player") echo ' SELECTED'; ?>>Players (Character Name)</option>
							<option value="vehicle"<?php if (isset($_POST['type']) and $_POST['type']=="vehicle") echo ' SELECTED'; ?>>Vehicles (ID)</option>
							<option value="interior"<?php if (isset($_POST['type']) and $_POST['type']=="interior") echo ' SELECTED'; ?>>Interior (ID)</option>
							<option value="account"<?php if (isset($_POST['type']) and $_POST['type']=="account") echo ' SELECTED'; ?>>Account Name</option>
							<option value="phone"<?php if (isset($_POST['type']) and $_POST['type']=="phone") echo ' SELECTED'; ?>>Phone Number</option>
							<option value="logtext"<?php if (isset($_POST['type']) and $_POST['type']=="logtext") echo ' SELECTED'; ?>>Plain Text</option>
						</select>
					</td>
					</tr>
					
					<tr>
					<td valign="top">
						<select name="time">
							<option value="-1" selected disabled>Select timespan...</option>
							<option value="1"<?php if (isset($_POST['time']) and $_POST['time']==1) echo ' SELECTED'; ?>>In The Past Hour</option>
							<option value="2"<?php if (isset($_POST['time']) and $_POST['time']==2) echo ' SELECTED'; ?>>2 Hours Ago Till Now</option>
							<option value="3"<?php if (isset($_POST['time']) and $_POST['time']==3) echo ' SELECTED'; ?>>3 Hours Ago Till Now</option>
							<option value="6"<?php if (isset($_POST['time']) and $_POST['time']==6) echo ' SELECTED'; ?>>6 Hours Ago Till Now</option>
							<option value="12"<?php if (isset($_POST['time']) and $_POST['time']==12) echo ' SELECTED'; ?>>12 Hours Ago Till Now</option>
							<option value="24"<?php if (isset($_POST['time']) and $_POST['time']==24) echo ' SELECTED'; ?>>1 Day Ago Till Now</option>
							<option value="48"<?php if (isset($_POST['time']) and $_POST['time']==48) echo ' SELECTED'; ?>>2 Days Ago Till Now</option>
							<option value="72"<?php if (isset($_POST['time']) and $_POST['time']==72) echo ' SELECTED'; ?>>3 Days Ago Till Now</option>
							<option value="168"<?php if (isset($_POST['time']) and $_POST['time']==168) echo ' SELECTED'; ?>>1 Week Ago Till Now</option>
							<option value="8736"<?php if (isset($_POST['time']) and $_POST['time']==8736) echo ' SELECTED'; ?>>All Time
							</option>
						</select>
					</td>
					</tr>
					
					<tr>
					<td>
						<input type="submit" name="dosearch" class="button" value="Search" />
					</td>
					</tr>
					</table></center>
					<div class="datagrid">
						<table>
							<thead>
								<tr>
									<th>Time</th>
									<th>Action</th>
									<th>Player</th>
									<th>Data</th>
									<th>Affected</th>
								</tr>
							</thead>
							<tfoot><tr><td colspan="5"><div id="no-paging">&nbsp;</div></tr></tfoot>
							<tbody>
							<?php 
							if (isset($_POST['charname'])) 
							{
								$foundElement = "none";
								$error = 'none';
								if (isset($_POST['type']))
								{
									if ($_POST['type'] == 'player')
									{
										if (strlen($_POST['charname']) > 4)
										{
											$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` LIKE '%".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname']))."%'");
											if (mysql_num_rows($fetchIDquery) == 1)
											{
												$sqlRow = mysql_fetch_assoc($fetchIDquery);
												$foundElement = 'ch'.$sqlRow['id'];
											}
											elseif (mysql_num_rows($fetchIDquery) == 0) {
												$error = 'No one found between those critereas.';
											}
											else 
											{
												$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` = '".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname']))."'");
												if (mysql_num_rows($fetchIDquery) == 1)
												{
													$sqlRow = mysql_fetch_assoc($fetchIDquery);
													$foundElement = 'ch'.$sqlRow['id'];
												}
												else
												{
													$error = 'The following people matched your query:<BR />';
													while($sqlRow = mysql_fetch_assoc($fetchIDquery))
														$error .= ' '.htmlspecialchars($sqlRow['charactername']).'<BR />';
												}
											}
										}
										else {
											$error = 'none';
										}
									}
									elseif ($_POST['type'] == 'vehicle')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `vehicles` WHERE `id`='".mysql_real_escape_string($_POST['charname'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 've'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No vehicle found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'interior')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `interiors` WHERE `id`='".mysql_real_escape_string($_POST['charname'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'in'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No interior found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'account')
									{
										$fetchIDquery = mysql_query("SELECT `id`,`username` FROM `accounts` WHERE `username` = '".mysql_real_escape_string($_POST['charname'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ac'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No account found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'phone')
									{
										$fetchIDquery = mysql_query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber`='".mysql_real_escape_string($_POST['charname'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ph'.$sqlRow['phonenumber'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No phone found between those critereas.';
										}
									}
								}

								
								//if ($foundElement != 'none' or $_POST['type'] == 'logtext')
								if ($error == 'none')
								{
									$selecterror = false;
									$qryadd = '';
									foreach ($_POST['logtype'] as $logID)
										if (isset($logTypes[$logID]))
											if ($logTypes[$logID][1] <= $adminLevel)
												if ((!$logTypes[$logID][2] and $foundElement != 'none') or (!$logTypes[$logID][2] and $_POST['type'] == 'logtext') or $logTypes[$logID][2])
													$qryadd .= "`action`='".mysql_real_escape_string($logID)."' OR ";

									if ($qryadd != '')
									{
										if (isset($_POST['time']) and is_numeric($_POST['time']) and $_POST['time'] > 0 and $_POST['time'] < 999999)
										{
											if ($_POST['time'] != mysql_real_escape_string($_POST['time']) or !is_numeric($_POST['time']))
											{
												die();
											}
											
											if ($_POST['type'] != 'logtext')
											{
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE ";
												if ($foundElement != 'none')
													$awesomeQuery .= "(`source`='".mysql_real_escape_string($foundElement)."' or `affected` LIKE '%".mysql_real_escape_string($foundElement).";%') AND ";
												$awesomeQuery .= "(".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
											}
											else
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE `content` LIKE '%".mysql_real_escape_string($_POST['charname'])."%' AND (".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
												
											$awesomeQryExe = mysql_query($awesomeQuery);
											//echo $awesomeQuery;
											if (mysql_num_rows($awesomeQryExe) > 0)
											{
												while ($row = mysql_fetch_assoc($awesomeQryExe) )
												{
													$explodedArr = explode(';', $row['affected']);
													$explodedStr = "";
													foreach ($explodedArr as $objectid)
														if ($objectid != '')
														
															$explodedStr .= htmlspecialchars(nameCache($objectid))."<span class='strong'> +</span><br/> ";
													
													
													echo "<tr class=\"alt\"><td>".htmlspecialchars($row['newtime'])."</td><td>".$logTypes[$row['action']][0]."</td><td>".htmlspecialchars(nameCache($row['source']))."</td><td>".htmlspecialchars($row['content'])."</td><td>".$explodedStr."</td></tr>\r\n";
													
												}
											}
											
											else 
												echo "<tr><td colspan=5>No results for the critereas searched. If you want to search without any terms, use Plain Text search with no terms.</td></tr>";
												
											echo mysql_error();
										}
										else
											echo "<tr><td colspan=5>Please select a time criterea.</td></tr>";
									}											
									else 
										echo "<tr><td colspan=5>Please select filter criterea.</td></tr>";
								}
								else 
									echo "<tr><td colspan=5>".$error."</td></tr>";
							}
							if (isset($_POST['charname2'])) 
							{
								$foundElement = "none";
								$error = 'none';
								if (isset($_POST['type']))
								{
									if ($_POST['type'] == 'player')
									{
										if (strlen($_POST['charname2']) > 4)
										{
											$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` LIKE '%".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname2']))."%'");
											if (mysql_num_rows($fetchIDquery) == 1)
											{
												$sqlRow = mysql_fetch_assoc($fetchIDquery);
												$foundElement = 'ch'.$sqlRow['id'];
											}
											elseif (mysql_num_rows($fetchIDquery) == 0) {
												$error = 'No one found between those critereas.';
											}
											else 
											{
												$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` = '".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname2']))."'");
												if (mysql_num_rows($fetchIDquery) == 1)
												{
													$sqlRow = mysql_fetch_assoc($fetchIDquery);
													$foundElement = 'ch'.$sqlRow['id'];
												}
												else
												{
													$error = 'The following people matched your query:<BR />';
													while($sqlRow = mysql_fetch_assoc($fetchIDquery))
														$error .= ' '.htmlspecialchars($sqlRow['charactername']).'<BR />';
												}
											}
										}
										else {
											$error = 'none';
										}
									}
									elseif ($_POST['type'] == 'vehicle')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `vehicles` WHERE `id`='".mysql_real_escape_string($_POST['charname2'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 've'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No vehicle found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'interior')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `interiors` WHERE `id`='".mysql_real_escape_string($_POST['charname2'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'in'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No interior found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'account')
									{
										$fetchIDquery = mysql_query("SELECT `id`,`username` FROM `accounts` WHERE `username` = '".mysql_real_escape_string($_POST['charname2'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ac'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No account found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'phone')
									{
										$fetchIDquery = mysql_query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber`='".mysql_real_escape_string($_POST['charname2'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ph'.$sqlRow['phonenumber'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No phone found between those critereas.';
										}
									}
								}

								
								//if ($foundElement != 'none' or $_POST['type'] == 'logtext')
								if ($error == 'none')
								{
									$selecterror = false;
									$qryadd = '';
									foreach ($_POST['logtype'] as $logID)
										if (isset($logTypes[$logID]))
											if ($logTypes[$logID][1] <= $adminLevel)
												if ((!$logTypes[$logID][2] and $foundElement != 'none') or (!$logTypes[$logID][2] and $_POST['type'] == 'logtext') or $logTypes[$logID][2])
													$qryadd .= "`action`='".mysql_real_escape_string($logID)."' OR ";

									if ($qryadd != '')
									{
										if (isset($_POST['time']) and is_numeric($_POST['time']) and $_POST['time'] > 0 and $_POST['time'] < 999999)
										{
											if ($_POST['time'] != mysql_real_escape_string($_POST['time']) or !is_numeric($_POST['time']))
											{
												die();
											}
											
											if ($_POST['type'] != 'logtext')
											{
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE ";
												if ($foundElement != 'none')
													$awesomeQuery .= "(`source`='".mysql_real_escape_string($foundElement)."' or `affected` LIKE '%".mysql_real_escape_string($foundElement).";%') AND ";
												$awesomeQuery .= "(".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
											}
											else
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE `content` LIKE '%".mysql_real_escape_string($_POST['charname2'])."%' AND (".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
												
											$awesomeQryExe = mysql_query($awesomeQuery);
											//echo $awesomeQuery;
											if (mysql_num_rows($awesomeQryExe) > 0)
											{
												while ($row = mysql_fetch_assoc($awesomeQryExe) )
												{
													$explodedArr = explode(';', $row['affected']);
													$explodedStr = "";
													foreach ($explodedArr as $objectid)
														if ($objectid != '')
														
															$explodedStr .= htmlspecialchars(nameCache($objectid))."<span class='strong'> +</span><br/> ";
													
													
													echo "<tr class=\"alt\"><td>".htmlspecialchars($row['newtime'])."</td><td>".$logTypes[$row['action']][0]."</td><td>".htmlspecialchars(nameCache($row['source']))."</td><td>".htmlspecialchars($row['content'])."</td><td>".$explodedStr."</td></tr>\r\n";
													
												}
											}
										}
									}											
								}
							}
							if (isset($_POST['charname3'])) 
							{
								$foundElement = "none";
								$error = 'none';
								if (isset($_POST['type']))
								{
									if ($_POST['type'] == 'player')
									{
										if (strlen($_POST['charname3']) > 4)
										{
											$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` LIKE '%".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname3']))."%'");
											if (mysql_num_rows($fetchIDquery) == 1)
											{
												$sqlRow = mysql_fetch_assoc($fetchIDquery);
												$foundElement = 'ch'.$sqlRow['id'];
											}
											elseif (mysql_num_rows($fetchIDquery) == 0) {
												$error = 'No one found between those critereas.';
											}
											else 
											{
												$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` = '".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname3']))."'");
												if (mysql_num_rows($fetchIDquery) == 1)
												{
													$sqlRow = mysql_fetch_assoc($fetchIDquery);
													$foundElement = 'ch'.$sqlRow['id'];
												}
												else
												{
													$error = 'The following people matched your query:<BR />';
													while($sqlRow = mysql_fetch_assoc($fetchIDquery))
														$error .= ' '.htmlspecialchars($sqlRow['charactername']).'<BR />';
												}
											}
										}
										else {
											$error = 'none';
										}
									}
									elseif ($_POST['type'] == 'vehicle')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `vehicles` WHERE `id`='".mysql_real_escape_string($_POST['charname3'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 've'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No vehicle found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'interior')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `interiors` WHERE `id`='".mysql_real_escape_string($_POST['charname3'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'in'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No interior found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'account')
									{
										$fetchIDquery = mysql_query("SELECT `id`,`username` FROM `accounts` WHERE `username` = '".mysql_real_escape_string($_POST['charname3'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ac'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No account found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'phone')
									{
										$fetchIDquery = mysql_query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber`='".mysql_real_escape_string($_POST['charname3'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ph'.$sqlRow['phonenumber'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No phone found between those critereas.';
										}
									}
								}

								
								//if ($foundElement != 'none' or $_POST['type'] == 'logtext')
								if ($error == 'none')
								{
									$selecterror = false;
									$qryadd = '';
									foreach ($_POST['logtype'] as $logID)
										if (isset($logTypes[$logID]))
											if ($logTypes[$logID][1] <= $adminLevel)
												if ((!$logTypes[$logID][2] and $foundElement != 'none') or (!$logTypes[$logID][2] and $_POST['type'] == 'logtext') or $logTypes[$logID][2])
													$qryadd .= "`action`='".mysql_real_escape_string($logID)."' OR ";

									if ($qryadd != '')
									{
										if (isset($_POST['time']) and is_numeric($_POST['time']) and $_POST['time'] > 0 and $_POST['time'] < 999999)
										{
											if ($_POST['time'] != mysql_real_escape_string($_POST['time']) or !is_numeric($_POST['time']))
											{
												die();
											}
											
											if ($_POST['type'] != 'logtext')
											{
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE ";
												if ($foundElement != 'none')
													$awesomeQuery .= "(`source`='".mysql_real_escape_string($foundElement)."' or `affected` LIKE '%".mysql_real_escape_string($foundElement).";%') AND ";
												$awesomeQuery .= "(".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
											}
											else
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE `content` LIKE '%".mysql_real_escape_string($_POST['charname3'])."%' AND (".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
												
											$awesomeQryExe = mysql_query($awesomeQuery);
											//echo $awesomeQuery;
											if (mysql_num_rows($awesomeQryExe) > 0)
											{
												while ($row = mysql_fetch_assoc($awesomeQryExe) )
												{
													$explodedArr = explode(';', $row['affected']);
													$explodedStr = "";
													foreach ($explodedArr as $objectid)
														if ($objectid != '')
														
															$explodedStr .= htmlspecialchars(nameCache($objectid))."<span class='strong'> +</span><br/> ";
													
													
													echo "<tr class=\"alt\"><td>".htmlspecialchars($row['newtime'])."</td><td>".$logTypes[$row['action']][0]."</td><td>".htmlspecialchars(nameCache($row['source']))."</td><td>".htmlspecialchars($row['content'])."</td><td>".$explodedStr."</td></tr>\r\n";
													
												}
											}
										}
									}											
								}
							}
							if (isset($_POST['charname4'])) 
							{
								$foundElement = "none";
								$error = 'none';
								if (isset($_POST['type']))
								{
									if ($_POST['type'] == 'player')
									{
										if (strlen($_POST['charname4']) > 4)
										{
											$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` LIKE '%".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname4']))."%'");
											if (mysql_num_rows($fetchIDquery) == 1)
											{
												$sqlRow = mysql_fetch_assoc($fetchIDquery);
												$foundElement = 'ch'.$sqlRow['id'];
											}
											elseif (mysql_num_rows($fetchIDquery) == 0) {
												$error = 'No one found between those critereas.';
											}
											else 
											{
												$fetchIDquery = mysql_query("SELECT `id`,`charactername` FROM `characters` WHERE `charactername` = '".mysql_real_escape_string(str_replace(" ", "_", $_POST['charname4']))."'");
												if (mysql_num_rows($fetchIDquery) == 1)
												{
													$sqlRow = mysql_fetch_assoc($fetchIDquery);
													$foundElement = 'ch'.$sqlRow['id'];
												}
												else
												{
													$error = 'The following people matched your query:<BR />';
													while($sqlRow = mysql_fetch_assoc($fetchIDquery))
														$error .= ' '.htmlspecialchars($sqlRow['charactername']).'<BR />';
												}
											}
										}
										else {
											$error = 'none';
										}
									}
									elseif ($_POST['type'] == 'vehicle')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `vehicles` WHERE `id`='".mysql_real_escape_string($_POST['charname4'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 've'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No vehicle found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'interior')
									{
										$fetchIDquery = mysql_query("SELECT `id` FROM `interiors` WHERE `id`='".mysql_real_escape_string($_POST['charname4'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'in'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No interior found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'account')
									{
										$fetchIDquery = mysql_query("SELECT `id`,`username` FROM `accounts` WHERE `username` = '".mysql_real_escape_string($_POST['charname4'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ac'.$sqlRow['id'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No account found between those critereas.';
										}
									}
									elseif ($_POST['type'] == 'phone')
									{
										$fetchIDquery = mysql_query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber`='".mysql_real_escape_string($_POST['charname4'])."'");
										if (mysql_num_rows($fetchIDquery) == 1)
										{
											$sqlRow = mysql_fetch_assoc($fetchIDquery);
											$foundElement = 'ph'.$sqlRow['phonenumber'];
										}
										elseif (mysql_num_rows($fetchIDquery) == 0) {
											$error = 'No phone found between those critereas.';
										}
									}
								}

								
								//if ($foundElement != 'none' or $_POST['type'] == 'logtext')
								if ($error == 'none')
								{
									$selecterror = false;
									$qryadd = '';
									foreach ($_POST['logtype'] as $logID)
										if (isset($logTypes[$logID]))
											if ($logTypes[$logID][1] <= $adminLevel)
												if ((!$logTypes[$logID][2] and $foundElement != 'none') or (!$logTypes[$logID][2] and $_POST['type'] == 'logtext') or $logTypes[$logID][2])
													$qryadd .= "`action`='".mysql_real_escape_string($logID)."' OR ";

									if ($qryadd != '')
									{
										if (isset($_POST['time']) and is_numeric($_POST['time']) and $_POST['time'] > 0 and $_POST['time'] < 999999)
										{
											if ($_POST['time'] != mysql_real_escape_string($_POST['time']) or !is_numeric($_POST['time']))
											{
												die();
											}
											
											if ($_POST['type'] != 'logtext')
											{
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE ";
												if ($foundElement != 'none')
													$awesomeQuery .= "(`source`='".mysql_real_escape_string($foundElement)."' or `affected` LIKE '%".mysql_real_escape_string($foundElement).";%') AND ";
												$awesomeQuery .= "(".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
											}
											else
												$awesomeQuery = "SELECT `time` - INTERVAL 1 hour as 'newtime',`action`,`source`,`affected`,`content` FROM `logtable` WHERE `content` LIKE '%".mysql_real_escape_string($_POST['charname4'])."%' AND (".$qryadd." 1=2) AND `time` > (NOW() - INTERVAL ".$_POST['time']." HOUR) ORDER BY `time` ASC";
												
											$awesomeQryExe = mysql_query($awesomeQuery);
											//echo $awesomeQuery;
											if (mysql_num_rows($awesomeQryExe) > 0)
											{
												while ($row = mysql_fetch_assoc($awesomeQryExe) )
												{
													$explodedArr = explode(';', $row['affected']);
													$explodedStr = "";
													foreach ($explodedArr as $objectid)
														if ($objectid != '')
														
															$explodedStr .= htmlspecialchars(nameCache($objectid))."<span class='strong'> +</span><br/> ";
													
													
													echo "<tr class=\"alt\"><td>".htmlspecialchars($row['newtime'])."</td><td>".$logTypes[$row['action']][0]."</td><td>".htmlspecialchars(nameCache($row['source']))."</td><td>".htmlspecialchars($row['content'])."</td><td>".$explodedStr."</td></tr>\r\n";
													
												}
											}
										}
									}											
								}
							}
							else 
								echo "<tr><td colspan=5>No search started.</td></tr>";
							?>
						</tbody>
						</table>
						</div>
					</form>
	
		</div>
		<!-- END MAIN CONTENT -->
<?php
	echo mysql_error();
?>