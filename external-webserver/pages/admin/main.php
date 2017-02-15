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
$mQuery1 = mysql_query("SELECT `username`,`admin`,`adminreports` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
if (mysql_num_rows($mQuery1) == 0)
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$userRow = mysql_fetch_assoc($mQuery1);
$username = $userRow['username'];
$adminLevel = $userRow['admin'];

$admotdquery = mysql_query("SELECT value FROM settings WHERE name='amotd'", $MySQLConn);
$settingsDB = mysql_fetch_assoc($admotdquery);
$adminMOTD = $settingsDB['value'];
if(empty($adminMOTD)){
	$adminMOTD = "Nothing to show, have a good day.";
}

if ($adminLevel < 1)
{
	header("Location: /ucp/main/");
	die();
}


$mQuery2 = mysql_query("SELECT `id, `admin`, `username` FROM `accounts` WHERE `admin` >= '1' ORDER BY `username` ASC");
if (mysql_num_rows($mQuery2) == 0)
{
	$showAllAdmins = "NONE";
}

$adminSire = "FALSE";
	if ($adminLevel < 1)
	{
		$adminSire = "!";
	}
	if ($adminLevel == 1)
	{
		$adminSire = "Suspended Administrator";
	}
	if ($adminLevel == 2)
	{
		$adminSire = "Trial Administrator";
	}
	if ($adminLevel == 3)
	{
		$adminSire = "Administrator";
	}
	if ($adminLevel == 4)
	{
		$adminSire = "Super Administrator";
	}
	if ($adminLevel == 5)
	{
		$adminSire = "Lead Administrator";
	}
	if ($adminLevel == 6)
	{
		$adminSire = "Head Administrator";
	}
	if ($adminLevel == 7)
	{
		$adminSire = "Master";
	}
	if ($adminLevel == 8)
	{
		$adminSire = "Developer";
	}
    if ($adminLevel > 8)
    {
        $adminSire = "Legend";
    }

$promoteDemoteDone = "";


$myAdmin = array();
$myAdmin['MyID'] = $_SESSION['ucp_userid'];
$myAdmin['MyReports'] = $userRow['adminreports'];

	#			Promote or Demote Action
	if($_POST['setcurrentadmin'] == "Update Admin"){
		if(empty($_POST['selectadmin'])){
			header("Location: /admin/main/");
		}
		if(empty($_POST['level'])){
			header("Location: /admin/main/");
		}

        	if($_POST['level'] == "-4"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-4' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
    		if($_POST['level'] == "-3"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-3' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			if($_POST['level'] == "-2"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-2' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
    		if($_POST['level'] == "-1"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-1' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
		
			if($_POST['level'] == "0"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='0' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}

			if($_POST['level'] == "1"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='1' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			
			if($_POST['level'] == "2"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='2' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			
			if($_POST['level'] == "3"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='3' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			
			if($_POST['level'] == "4"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='4' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			
			if($_POST['level'] == "5"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='5' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
			
			if($_POST['level'] == "6"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadmin = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `id`='" . $_POST['selectadmin'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='6' WHERE `id`='".$_POST['selectadmin']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadmin) == 0)
					{
						header ("Location: /admin/main/#");
					}
			}
	}


	#			Make New Admin
	if($_POST['createnewadmin'] == "Make Admin"){
		
		if(empty($_POST['newadminuser'])){
			header("Location: /admin/main/");
		}
		if(empty($_POST['levelm'])){
			header("Location: /admin/main/");
		}
		$selectedmLevel = $_POST['levelm'];
        
        	if($selectedmLevel == "-4m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-4' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			} 
    		if($selectedmLevel == "-3m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-3' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}        
			if($selectedmLevel == "-2m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-2' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
    		if($selectedmLevel == "-1m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='-1' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
			
			elseif($selectedmLevel == "2m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='2' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
			
			elseif($selectedmLevel == "3m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='3' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
			
			elseif($selectedmLevel == "4m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='4' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
			
			elseif($selectedmLevel == "5m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='5' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
			
			elseif($selectedmLevel == "6m"){
				$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
				$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
				$queryadminma = mysql_query("SELECT `admin`, `id` FROM `accounts` WHERE `username`='" . $_POST['newadminuser'] . "' LIMIT 1", $MySQLConn);
				mysql_query("UPDATE `accounts` SET `admin`='6' WHERE `username`='".$_POST['newadminuser']."' LIMIT 1", $MySQLConn);
				if (mysql_num_rows($queryadminma) == 0)
					{
						header ("Location: /admin/main/?invalid_entry");
					}
			}
		
	}

if (!isset($_GET['action']) or $_GET['action'] == array("main","overview"))
{
?>
        <!-- MAIN CONTENT -->
        
        <div class="one separator"></div>
        <style type="text/css">
		.radiox label {  
			display: inline-block;  
			cursor: pointer;  
			position: relative;  
			padding-left: 25px;  
			margin-right: 0px;  
			font-size: 13px;  
		}  
		
		.radiox input[type=radio] {  
			display: none;  
		}  
		
		.radiox label:before {  
			content: "";  
			display: inline-block;  
		  
			width: 16px;  
			height: 16px;  
		  
			margin-right: 0px;  
			position: absolute;  
			left: 0;  
			bottombottom: 1px;  
			background-color: #aaa;  
			box-shadow: inset 0px 2px 3px 0px rgba(0, 0, 0, .3), 0px 1px 0px 0px rgba(255, 255, 255, .8);  
		}  
		
		.radiox label:before {  
			border-radius: 8px;  
		}  
		
		.radiox input[type=radio]:checked + label:before {  
			content: "\2022";  
			color: #f3f3f3;  
			font-size: 35px;  
			text-align: center;  
			line-height: 18px;  
		}  
		</style>
        <script type="text/javascript">
		function showsa(){
				document.getElementById("sa").style.display="block";
		};
		function hidesa(){
				document.getElementById("sa").style.display="none";
		};
		
		function showna(){
				document.getElementById("na").style.display="block";
		};
		function hidena(){
				document.getElementById("na").style.display="none";
		};
		
		function doing_promote(){
				document.getElementById("doing_promote").style.display="block";
		};
		
		function doing_newadmin(){
				document.getElementById("doing_newadmin").style.display="block";
		};
		</script>
        <!-- WELCOME BLOCK -->
        <div class="one notopmargin">
            <h3 class="welcome nobottommargin left">Admin Overview</h3>
            <p class="left description "></p>
        </div>
        <!-- END WELCOME BLOCK -->
			<?php require_once("./././includes/sidebar.php"); ?>
        <div class="three-fourth last">
        <div class="three-fourth notopmargin last">
            <h3 align="center">Hello <?php echo $adminSire;?>, <span class="colored"><?php echo $_SESSION['ucp_username'];?></span>.</h3><br />
            <?php if ($adminLevel > 1){?>
				<center>
				<div class="simplegrid">
					<table>
						<thead>
					<tr>
						<th valign="middle" align="center">Admin MOTD</th>
					</tr>
						</thead>
						<tbody>
					<tr>
						<td valign="middle">
							<p align="center" class="ssp font500"><?php echo $adminMOTD;?></p>
						</td>
					</tr>
						</tbody>
				</table>
		
			</div><br />
            <?php $allowedpageID = "200"; //THIS IS CURRENT: RON?>
            <?php if($adminLevel >= 6 or $_SESSION['ucp_userid']==$allowedpageID){?>
				<div class="simplegrid">
					<table>
						<thead>
					<tr>
						<th valign="middle" colspan="2" align="center">Administrative</th>
                    </tr>
						</thead>
						<tbody>
					<tr>
						<td valign="middle" width="300px" align="left">
                        <br/>
                        
                        <table border="0">
                        <form action="" method="POST" name="promote">
                        <tr valign="middle" align="left"><td width="100px">
                        		<div class="radiox" id="4label" class="4label">  
                    <?php if($adminLevel >=6){?>
                                    <input id="0" type="radio" name="level" value="0"/>  
                                    <label id="4label" for="0">Remove (0)</label>  
                                    <br/><br />
                                    <input id="1" type="radio" name="level" value="1"/>  
                                    <label id="4label" for="1">Suspend Admin (1)</label>  
                                    <br/><br /><br />
                                    <input id="-1" type="radio" name="level" value="-1"/>  
                                    <label id="4label" for="-1">Trial Game Master (-1)</label>  
                                    <br/><br />
                                    <input id="-2" type="radio" name="level" value="-2"/>  
                                    <label id="4label" for="-2">Game Master (-2)</label>  
                                    <br/><br />
                                    <input id="-3" type="radio" name="level" value="-3"/>  
                                    <label id="4label" for="-3">Senior Game Master (-3)</label>  
                                    <br/><br />
                                    
                                    <input id="2" type="radio" name="level" value="2"/>  
                                    <label id="4label" for="2">Trial Admin (2)</label>
                                    <br/><br />
                                    <input id="3" type="radio" name="level" value="3"/>  
                                    <label id="4label" for="3">Full Admin (3)</label>  
                                    <br/><br />
                                    <input id="4" type="radio" name="level" value="4"/>  
                                    <label id="4label" for="4">Super Admin (4)</label>  
                                    <br/><br />
                                    <input id="5" type="radio" name="level" value="5"/>  
                                    <label id="4label" for="5">Lead Admin (5)</label>  
                                    <br/><br />
                                    <input id="6" type="radio" name="level" value="6"/>  
                                    <label id="4label" for="6">Head Admin (6)</label>
                    <?php } elseif($_SESSION['ucp_userid']==$allowedpageID){?>
                                    <input id="0" type="radio" name="level" value="0"/>  
                                    <label id="4label" for="0">Remove (0)</label>  
                                    <br/><br />
                                    <input id="-1" type="radio" name="level" value="-1"/>  
                                    <label id="4label" for="-1">Trial Game Master (-1)</label>  
                                    <br/><br />
                                    <input id="-2" type="radio" name="level" value="-2"/>  
                                    <label id="4label" for="-2">Game Master (-2)</label>  
                                    <br/><br />
                                    <input id="-3" type="radio" name="level" value="-3"/>  
                                    <label id="4label" for="-3">Senior Game Master (-3)</label>  
                                    <br/><br />
                                    <input id="-4" type="radio" name="level" value="-4"/>  
                                    <label id="4label" for="-4">Lead Game Master (-4)</label>  
                                    <br/><br />
                    <?php } ?>
                          </div> 
                                
               </td>
                         <td valign="middle" align="center" width="200px">
                        <div id="doing_promote" style="display: none;">
                        <br />
                        <center>
                        <img src="/images/doing.gif" border="0" />
                        </center>
                        <br />
                        </div>
                        <center>
                <?php if($adminLevel >= 6){?>
                                                         <div class="ddedit">
                                    <select id="selectadmin" name="selectadmin" onchange="showsa();">
                                    <option value="" disabled selected>Select Admin</option>
                                    <option value="" disabled>Level // ID // Username</option>
                                    <?php 
                                    $ga = mysql_query("SELECT `id`,`username`, `admin` FROM accounts WHERE admin BETWEEN '1' AND '6' ORDER BY admin ASC, username ASC, id ASC");
                                    while($as = mysql_fetch_array($ga))
                                    {
                                    ?>
                                    <option name="adminuser" onchange="" id="valueofnewadmin" value="<?php echo $as["id"]; ?>"><?php echo '('.$as["admin"].') ('.$as["id"].') '. $as["username"]; ?></option>
                                    <?php } ?>
                                    </select>
                                    </div>
                <?php } elseif ($_SESSION['ucp_userid']==$allowedpageID) {?>
                                                         <div class="ddedit">
                                    <select id="selectadmin" name="selectadmin" onchange="showsa();">
                                    <option value="" disabled selected>Select GM</option>
                                    <option value="" disabled>Level // ID // Username</option>
                                    <?php 
                                    $ga = mysql_query("SELECT `id`,`username`, `admin` FROM accounts WHERE admin BETWEEN '-4' AND '-1' ORDER BY admin ASC, username ASC, id ASC");
                                    while($as = mysql_fetch_array($ga))
                                    {
                                    ?>
                                    <option name="adminuser" onchange="" id="valueofnewadmin" value="<?php echo $as["id"]; ?>"><?php echo '('.$as["admin"].') ('.$as["id"].') '. $as["username"]; ?></option>
                                    <?php } ?>
                                    </select>
                                    </div>
                <?php }?>
                <br/>
                                    <div id="sa" style="display:none"><h4 class="notopmargin colored"><img src="/images/blue-checkmark.png" border="0" /> Ready</h4></div>
          						<input type="submit" class="button" name="setcurrentadmin" onclick="doing_promote();" value="Update Admin"/>
                                <input type="reset" class="button" onclick="hidesa();" name="reset" value="Clear"/>
                           </center>
                         </td>
                         </tr>
                        </form>
                        </table>
						</td>
						<td valign="middle" width="100px">
                        <div id="doing_newadmin" style="display: none;">
                        <br />
                        <center>
                        <img src="/images/doing.gif" border="0" />
                        </center>
                        <br />
                        </div><center><br/>
						<form action="" method="post" name="makenewadmin">
                          <div class="radiox" id="4label" class="4label">  
                                    <table border="0">
                                    <tr>
                                        <td><input id="-1m" type="radio" name="levelm" value="-1m"/><label id="4label" for="-1m">Trial Game Master (-1)</label></td></tr><tr>
                                        <td><input id="-2m" type="radio" name="levelm" value="-2m"/><label id="4label" for="-2m">Game Master (-2)</label></td></tr><tr>
                                        <td><input id="-3m" type="radio" name="levelm" value="-3m"/><label id="4label" for="-3m">Senior Game Master (-3)</label></td></tr><tr>
                    <?php if($adminLevel >= 6){?>
                                        <td><input id="2m" type="radio" name="levelm" value="2m"/><label id="4label" for="2m">Trial Admin (2)</label></td></tr><tr>
                                        <td><input id="3m" type="radio" name="levelm" value="3m"/><label id="4label" for="3m">Full Admin (3)</label></td></tr><tr>
                                        <td><input id="4m" type="radio" name="levelm" value="4m"/><label id="4label" for="4m">Super Admin (4)</label></td></tr><tr>
                                        <td><input id="5m" type="radio" name="levelm" value="5m"/><label id="4label" for="5m">Lead Admin (5)</label></td></tr><tr>
                                        <td><input id="6m" type="radio" name="levelm" value="6m"/><label id="4label" for="6m">Head Admin (6)</label></td>
                    <?php } ?>
                                    </tr>
                                    </table>
                               </div>
                            <input type="text" name="newadminuser" onkeyup="showna();" class="text-input"/><label for="newadminuser">Username</label><br/>
                            <div id="na" style="display:none"><h4 class="notopmargin colored"><img src="/images/blue-checkmark.png" border="0" /> Ready</h4></div>
                            <input type="submit" class="button" name="createnewadmin" onclick="doing_newadmin();" value="Make Admin"/>
                        </form>
                        </center>
						</td>
					</tr>
						</tbody>
				</table>
            </div>
		
            <?php }?>
            <br />
			</center>
            
			<?php } else { ?>
            <p align="center">As a suspended administrator, you are not granted access to these features.</p>
            <?php }?>
        </div>
        </div>
        
		<!-- END MAIN CONTENT -->
<?php


}
		elseif ($_GET['action'] == "perkslist")
	{
		if ($adminLevel < 6)
	{
		header("Location: /ucp/main/");
		die();
	}
		require_once("/pages/admin/players/perkslist.php");
	}
		elseif ($_GET['action'] == "logs")
	{
		if ($adminLevel < 3)
	{
		header("Location: /ucp/main/");
		die();
	}
		require_once("/pages/admin/players/logs.php");
	}
		elseif ($_GET['action'] == 'guntrace')
	{
	if ($adminLevel < 5)
	{
		header("Location: /ucp/main/");
		die();
	}
		require_once("/pages/admin/players/accountcharsearch.php");
	}
		elseif ($_GET['action'] == 'accountcharsearch')
	{
	if ($adminLevel < 2)
	{
		header("Location: /ucp/main/");
		die();
	}
		require_once("/pages/admin/players/accountcharsearch.php");
	}
		else {
			header("Location: /ucp/main/");
			die();
	}
		mysql_close($MySQLConn);
?>