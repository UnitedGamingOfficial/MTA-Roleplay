<?php

$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);
if (!$MySQLConn) 
{
	$_SESSION['ucp_loggedin'] = false;
	$_SESSION['errno'] = 2;
	header("Location: /ucp/login/");
	die();
}
$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

if (isset($_GET['param2']) and $_GET['param2'] == 'pp-ipn')
{
	$paypal = new paypal_class;
	if ($paypal->validate_ipn()) {
		if($paypal->ipn_data['payment_status']=='Completed' and ($paypal->ipn_data['receiver_email'] == "donate@unitedgaming.org" or $paypal->ipn_data['receiver_email'] == "donate@unitedgaming.org"))
		{
			
			$amount = $paypal->ipn_data['mc_gross'];
			$realamount = $paypal->ipn_data['mc_gross'] - $paypal->ipn_data['mc_fee'];
			$insertQry = mysql_query("	INSERT INTO don_transactions (transaction_id,donator_email,username,amount,realamount,original_request,dt)
				VALUES (
					'".mysql_real_escape_string($paypal->ipn_data['txn_id'])."',
					'".mysql_real_escape_string($paypal->ipn_data['payer_email'])."',
					'".mysql_real_escape_string($paypal->ipn_data['custom'])."',
					".(float)$amount.",
					".(float)$realamount.",
					'".mysql_real_escape_string(http_build_query($_POST))." \r\n\r\n ".mysql_real_escape_string($paypal->ipn_response)." \r\n\r\n ".mysql_real_escape_string(http_build_query($paypal->ipn_data))."',
					NOW()
				)");
			$insertQryID = mysql_insert_id();
			$pointsUsername = mysql_real_escape_string($paypal->ipn_data['custom']);
			
			$statTransfers = 0;
			$vPoints = 0;
			$admin = 0;
			
			switch ($amount)
			{
				case 5:
					$statTransfers = 0;
					$vPoints = 5;	

					break;
				case 4:
					$statTransfers = 1;
					$vPoints = 0;	
					break;
				case 9:
					$statTransfers = 1;
					$vPoints = 5;
					break;
				case 13:
					$statTransfers = 1;
					$vPoints = 15;
					break;
				case 20:
					$statTransfers = 2;
					$vPoints = 15;
					break;
				case 20:
					$statTransfers = 0;
					$vPoints = 20;
					break;
				case 25:
					$statTransfers = 3;
					$vPoints = 20;
					break;
				case 40:
					$statTransfers = 0;
					$vPoints = 50;
					break;
				case 38:
					$statTransfers = 4;
					$vPoints = 35;
					break;
				case 70:
					$statTransfers = 5;
					$vPoints = 65;
					break;
				case 100:
					$statTransfers = 10;
					$vPoints = 85;
					break;
				case 200:
					$statTransfers = 16;
					$vPoints = 800;
					break;
				case 123413;
					$statTrasnfer = 0;
					$vPoints = 0;

				// Promotion package! 
				case 75:
					$statTransfers=5;
					$vPoints = 500;
					break;
					
				default:
					die();
					break;
			}
			echo 'hai';
                        
			$fetchUserQry = mysql_query("SELECT `id`, username, email FROM `accounts` WHERE `username`='".$pointsUsername."'");
			if (mysql_num_rows($fetchUserQry) == 1)
			{
				$fetchArr = mysql_fetch_array($fetchUserQry);
				
    			$to = $fetchArr['email'];
                
                if($to)
                {    			
        			$subject = 'Donation';
        			
        			$message = '
        			<html>
        			<body>
        			  <p> You have recieved a donation package from someone donating on your behalf, at UnitedGaming Roleplay. Log in to see what you got! </p>
        			</body>
        			</html>
        			';
        			
        			// To send HTML mail, the Content-type header must be set
        			$headers  = 'MIME-Version: 1.0' . "\r\n";
        			$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
        			
        			$headers .= 'To: ' . $getEmail['user_email'] . "\r\n";
        			$headers .= 'From: UnitedGaming <chuevo@unitedgaming.org>' . "\r\n";
        			
        			$status = mail($to, $subject, $message, $headers);
                }
                
				mysql_query("UPDATE `accounts` SET credits=credits+".$vPoints.", transfers=transfers+".$statTransfers." WHERE `id`=".$fetchArr['id']);
				mysql_query("UPDATE `don_transactions` SET `handled`=1 WHERE `id`='".mysql_real_escape_string($insertQryID)."'");
			}
		}
		else {
			mysql_query("	INSERT INTO don_transaction_failed (output, ip)
				VALUES (
					'FRAUD ".mysql_real_escape_string(http_build_query($_POST))." \r\n\r\n ".mysql_real_escape_string($paypal->ipn_response)." \r\n\r\n ".mysql_real_escape_string(http_build_query($paypal->ipn_data))."',
					'".mysql_real_escape_string($_SERVER['REMOTE_ADDR'])."'
				)");
		}
	}
	else {
		mysql_query("	INSERT INTO don_transaction_failed (output, ip)
			VALUES (
				'".mysql_real_escape_string(http_build_query($_POST))." \r\n\r\n ".mysql_real_escape_string(http_build_query($paypal->ipn_data))."',
				'".mysql_real_escape_string($_SERVER['REMOTE_ADDR'])."'
			)");
	}
	echo mysql_error();
	mysql_close($MySQLConn);
	die();
}

if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	header("Location: /ucp/login/");
	die();
}

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

// Application stuff
$playerUserName = $userRow['username'];
 // https://www.sandbox.paypal.com/cgi-bin/webscr -->

if (isset($_GET['param2']) and $_GET['param2'] == 'y')
{
?>				<!-- Middle Column - main content -->
		<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
							<h2>User Control Panel - Donation center</h2>
							<BR />
							Thank you for your donation. You should receive your donation perks ASAP. If it does not add to your account after one hour, please contact Chuevo on the forums.<BR />
							<BR />
							- MTA Head Administration Team
						</div>
					</div>
<?php
}
elseif (isset($_GET['param2']) and $_GET['param2'] == 'n')
{
?>				<!-- Middle Column - main content -->
		<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
							<h2>User Control Panel - Donation center</h2>
							<BR />
							Looks like that donation wasn't valid. Sorry.
						</div>
					</div>
<?php
} else
{
?>				<!-- Middle Column - main content -->
		<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
							<h3>User Control Panel - Donation center</h3>
							<p>Thank you for considering to donate. You can see our current donation perks below.
							<br><h4 class="colored"><b><s>IMPORTANT:</s><br> YOU WILL NOT RECEIVE YOUR PERKS UNLESS YOU CLICK RETURN TO DONATE@UNITEDGAMING.ORG AFTER PAYMENT!</b></h4>
							<br></p>
							<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
								<input type="hidden" name="cmd" value="_xclick" />
								<input type="hidden" name="business" value="donate@unitedgaming.org" />
								<input type="hidden" name="item_name" value="Donation / Gift to support UnitedGaming" />
								<input type="hidden" name="item_number" value="001" />
								<input type="hidden" name="notify_url" value="http://unitedgaming.org/ucp/donate/pp-ipn/" />
								<input type="hidden" name="cancel_return" value="http://unitedgaming.org/ucp/donate/n/" />
								<input type="hidden" name="return" value="http://unitedgaming.org/ucp/donate/y/" />
								<input type="hidden" name="rm" value="2" />
								<input type="hidden" name="no_shipping" value="1" />
								
								Amount (in USD): <BR />

								<input type="radio" name="amount" value="5" /> $5.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="4" /> $4.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br><br>								
								<input type="radio" name="amount" value="9" /> $9.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 donPoints(s)
								<br><br>
								<input type="radio" name="amount" value="13" /> $13.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="20" /> $20.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="20" /> $20.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="25" /> $25.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="38" /> $38.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;35 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="40" /> $40.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="70" /> $70.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;65 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="100" /> $100.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;85 donPoint(s)
								<br><br>
								<input type="radio" name="amount" value="200" /> $200.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;200 donPoint(s)
								<br><br>
								<h4 class="colored"><b><s>IMPORTANT:</s><br> YOU WILL NOT RECEIVE YOUR PERKS UNLESS YOU CLICK RETURN TO DONATE@UNITEDGAMING.ORG AFTER PAYMENT!</b></h4>
								<input type="hidden" name="currency_code" value="USD" />
								<input type="hidden" name="lc" value="US" />
								Donation for the account: <input type="text" name="custom" value="<?php echo $playerUserName; ?>" />
											
								<input type="submit" class="button black" name="I1" value="Donate" />
							</form>
						</div>
					</div>
<?php } ?>