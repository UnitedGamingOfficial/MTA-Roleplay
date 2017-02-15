<?php
	require_once("../includes/config.php");
	
	$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
	if (!$MySQLConn) 
	{
		$_SESSION['ucp_loggedin'] = false;
		$_SESSION['errno'] = 2;
		header("Location: /ucp/login/");
		die();
	}
	$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

	$an = mysql_real_escape_string($_GET['id']);
	switch($_GET['show'])
	{
		case '1':
			$acc = mysql_query("SELECT * FROM accounts WHERE id='" . $an . "'");
			$acc = mysql_fetch_array($acc);

			if(!$acc)
			{
				echo("Invalid Account Information or Account does not exist.");
				exit;
			}

			header("Content-type: image/png");
			switch($_GET['layout'])
			{
				case '1':
					$image = imagecreatefrompng("../images/signature" . $_GET['layout'] . ".png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
				case '2':
					$image = imagecreatefrompng("../images/signature" . $_GET['layout'] . ".png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
				default:
					$image = imagecreatefrompng("../images/signature.png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
			}

			imagestring($image, 2, 60, 3, "Username:", $c1);
			imagestring($image, 2, 115, 3, $acc['username'], $c2);

			if($acc['admin'] > 0 && $acc['hiddenadmin'] == 0)
			{
				imagestring($image, 2, 200, 3, "Administrator:", $c1);
				$al = array('', 'Trial', 'Regular', 'Super', 'Lead', 'Head', 'Owner', 'Scriptor');
				imagestring($image, 2, 285, 3, $al[$acc['admin']], $c2);
			}
			
			imagestring($image, 2, 200, 15, "Achievements:", $c1);
			$na = mysql_query("SELECT * FROM achievements WHERE account='" . $an . "'");
			$na = mysql_num_rows($na);
			imagestring($image, 2, 282, 15, $na, $c2);
			
			imagestring($image, 2, 60, 15, "Donator:", $c1);
			$dn = array('N/A', 'Bronze', 'Silver', 'Gold', 'Platinum', 'Pearl', 'Diamond', 'Godly');
			imagestring($image, 2, 109, 15, $dn[$acc['donator']], $c2);

			imagestring($image, 2, 60, 26, "Registed:", $c1);
			imagestring($image, 2, 115, 26, $acc['registerdate'], $c2);
			
			imagestring($image, 2, 60, 37, "Status:", $c1);
			$banned = array('Not Banned', 'Banned');
			if($acc['banned'] == 0)
			{
				imagestring($image, 2, 104, 37, $banned[$acc['banned']], $c3);
			}else{
				imagestring($image, 2, 104, 37, $banned[$acc['banned']], $c4);
				$bi = imagecreatefrompng("banned.png");
			}

			imagestring($image, 2, 245, 57, "http:mtaroleplay.com", $c2);
			imagestring($image, 2, 5, 57, "74.222.2.333:22003", $c1);

			imagepng($image);
			imagedestroy($image);
			break;
		case '2':
			$acc = mysql_query("SELECT * FROM characters WHERE id='" . $an . "'");
			$acc = mysql_fetch_array($acc);

			if(!$acc)
			{
				echo("Invalid Character Information or Character does not exist.");
				exit;
			}

			header("Content-type: image/png");
			switch($_GET['layout'])
			{
				case '1':
					$image = imagecreatefrompng("../images/signature" . $_GET['layout'] . ".png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
				case '2':
					$image = imagecreatefrompng("../images/signature" . $_GET['layout'] . ".png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
				default:
					$image = imagecreatefrompng("../images/signature.png");
					$c1 = imagecolorallocate($image, 248, 248, 255); //White
					$c2 = imagecolorallocate($image, 255, 140, 0); //Orange
					$c3 = imagecolorallocate($image, 0, 255, 0); //Green
					$c4 = imagecolorallocate($image, 255, 0, 0); //Red
					break;
			}

			imagestring($image, 2, 60, 3, "Character:", $c1);
			imagestring($image, 2, 122, 3, $acc['charactername'], $c2);

			imagestring($image, 2, 60, 15, "Life Status:", $c1);
			if($acc['cked'] == 0)
			{
				imagestring($image, 2, 134, 15, "Alive", $c3);
			}else{
				imagestring($image, 2, 134, 15, "Dead", $c4);
			}

			imagestring($image, 2, 60, 26, "Hours Online:", $c1);
			imagestring($image, 2, 140, 26, $acc['hoursplayed'], $c2);
			
			imagestring($image, 2, 60, 37, "Last Login:", $c1);
			imagestring($image, 2, 128, 37, $acc['lastlogin'], $c2);
			
			$nv = mysql_query("SELECT * FROM vehicles WHERE owner='" . $an . "'");
			$nv = mysql_num_rows($nv);
			imagestring($image, 2, 230, 3, "Vehicles:", $c1);
			imagestring($image, 2, 286, 3, $nv, $c2);
			
			$np = mysql_query("SELECT * FROM interiors WHERE owner='" . $an . "'");
			$np = mysql_num_rows($np);
			imagestring($image, 2, 230, 15, "Properties:", $c1);
			imagestring($image, 2, 298, 15, $np, $c2);
			
			imagestring($image, 2, 245, 57, "http:mtaroleplay.com", $c2);
			imagestring($image, 2, 5, 57, "74.222.2.233:22003", $c1);

			imagepng($image);
			imagedestroy($image);
			break;
		default:
			break;
	}
?>