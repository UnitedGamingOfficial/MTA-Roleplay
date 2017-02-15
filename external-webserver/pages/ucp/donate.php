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

require_once("././includes/mta_sdk.php");

if (isset($_GET['param2']) and $_GET['param2'] == 'pp-ipn')
{
	$paypal = new paypal_class;
	if ($paypal->validate_ipn()) {
		if($paypal->ipn_data['payment_status']=='Completed' and ($paypal->ipn_data['receiver_email'] == "kissor@chuevo.com" or $paypal->ipn_data['receiver_email'] == "donate@unitedgaming.org"))
		{
			$fuckingFaggot = $_SESSION['ucp_userid'];
			$amount = $paypal->ipn_data['mc_gross'];
			$realamount = $paypal->ipn_data['mc_gross'] - $paypal->ipn_data['mc_fee'];
			$itemNumber = $paypal->ipn_data['item_number'];
			$serialCode = strtoupper(sha1(sha1($paypal->ipn_data['txn_id']).sha1($Config['server']['donkey'])));
			$donPriceQuery = mysql_query("SELECT `ProductPrice` FROM `don_prices` WHERE ProductID='" . $itemNumber . "' LIMIT 1", $MySQLConn);
			$fetchPrice = mysql_fetch_assoc($donPriceQuery);
			$productprice = $fetchPrice['ProductPrice'];
			$pointsUsername = mysql_real_escape_string($paypal->ipn_data['custom']);
			if ($amount == $productprice) 
			{
				$insertQry = mysql_query("	INSERT INTO don_transactions (transaction_id,donator_email,username,amount,realamount,original_request,item_number,dt)
					VALUES (
						'".mysql_real_escape_string($paypal->ipn_data['txn_id'])."',
						'".mysql_real_escape_string($paypal->ipn_data['payer_email'])."',
						'".mysql_real_escape_string($paypal->ipn_data['custom'])."',
						".(float)$amount.",
						".(float)$realamount.",
						'".mysql_real_escape_string(http_build_query($_POST))." \r\n\r\n ".mysql_real_escape_string($paypal->ipn_response)." \r\n\r\n ".mysql_real_escape_string(http_build_query($paypal->ipn_data))."',
						".(int)$itemNumber.",
						NOW()
					)");
				$serialCode = strtoupper(sha1(sha1($paypal->ipn_data['txn_id']).sha1($Config['server']['donkey'])));
				$insertQryID = mysql_insert_id();
				$pointsUsername = mysql_real_escape_string($paypal->ipn_data['custom']);
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
						<p> You have successfully donated to UnitedGaming. </p>
						<p> Head in game and enter the following Serial Number to redeem your donation perks. </p>
						<p> ' . $serialCode . ' </p>
						<p> To redeem your code, press F7 and click the redeem now button. </p>
						</body>
						</html>
						';
        			
						// To send HTML mail, the Content-type header must be set
						$headers  = 'MIME-Version: 1.0' . "\r\n";
						$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
        			
						$headers .= 'To: ' . $to . "\r\n";
						$headers .= 'From: UnitedGaming <noreply@unitedgaming.org>' . "\r\n";
        			
						$status = mail($to, $subject, $message, $headers);
					}
					mysql_query("UPDATE `don_transactions` SET `handled`=1 WHERE `id`='".mysql_real_escape_string($insertQryID)."'");
					$mtaSex = new mta($Config['server']['hostname'], 22005, $Config['server']['username'], $Config['server']['password']);
					$mtaSex->getResource("usercontrolpanel")->call("userDonated", $pointsUsername, $amount, $productprice, $itemNumber);
				}
			}
			else 
			{ 
				$mtaServer = new mta($Config['server']['hostname'], 22005, $Config['server']['username'], $Config['server']['password']);
				$mtaServer->getResource("usercontrolpanel")->call("attemptedFraud", $pointsUsername , $amount, $productprice, $itemNumber);
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
 // https://www.paypal.com/cgi-bin/webscr
if (isset($_GET['param2']) and $_GET['param2'] == 'y')
{
?>				<!-- Middle Column - main content -->
		<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
							<h2>User Control Panel - Donation center</h2>
							<BR />
							Thank you for your donation. Your donation key has been emailed to you. <BR />
							<?php echo $serialCode; ?><BR/>
							Go in game, and press F7 to open the donation menu. Click on enter code, copy and paste this code there, then click "Validate"<BR />
							Your perks will then be added!<BR />
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
							<form action="https://www.paypal.com/cgi-bin/webscr" id="paypalSubmit" method="post">
								<script language="javascript">
									function handleRadioChange(theRadio){
										document.getElementById("submitButton").disabled = false;
										document.getElementById("itemNumber").value = theRadio.id;
									}
								</script>
								<input type="hidden" name="cmd" value="_xclick" />
								<input type="hidden" name="business" value="donate@unitedgaming.org" />
								<input type="hidden" name="item_name" value="Donation / Gift to support UnitedGaming" />
								<input type="hidden" name="notify_url" value="http://unitedgaming.org/ucp/newdonate/pp-ipn/" />
								<input type="hidden" name="cancel_return" value="http://unitedgaming.org/ucp/newdonate/n/" />
								<input type="hidden" name="return" value="http://unitedgaming.org/ucp/newdonate/y/" />
								<input type="hidden" name="item_number" value="000" id="itemNumber" />
								<input type="hidden" name="rm" value="2" />
								<input type="hidden" name="no_shipping" value="1" />
								<input type="hidden" name="currency_code" value="USD" />
								<input type="hidden" name="lc" value="CA" />
								<input type="hidden" name="custom" value="<?php echo $playerUserName; ?>" />
								Amount (in USD): <BR />

								<input type="radio" name="amount" id="001" onclick="handleRadioChange(this);" value="4" /> $4.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br><br>
								<input type="radio" name="amount" id="002" onclick="handleRadioChange(this);" value="5" /> $5.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="003" onclick="handleRadioChange(this);" value="9" /> $9.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 donPoints(s)
								<br><br>
								<input type="radio" name="amount" id="004" onclick="handleRadioChange(this);" value="13" /> $13.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="005" onclick="handleRadioChange(this);" value="20" /> $20.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;15 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="006" onclick="handleRadioChange(this);" value="20" /> $20.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="007" onclick="handleRadioChange(this);" value="25" /> $25.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;20 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="008" onclick="handleRadioChange(this);" value="38" /> $38.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;35 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="009" onclick="handleRadioChange(this);" value="40" /> $40.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;50 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="010" onclick="handleRadioChange(this);" value="70" /> $70.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;65 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="011" onclick="handleRadioChange(this);" value="100" /> $100.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;85 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="012" onclick="handleRadioChange(this);" value="200" /> $200.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;16 Stat transfer(s)
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;200 donPoint(s)
								<br><br>
								<input type="radio" name="amount" id="013" onclick="handleRadioChange(this);" value="25" /> $25.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Infernus
								<br><br>
								<input type="radio" name="amount" id="015" onclick="handleRadioChange(this);" value="25" /> $25.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Bullet
								<br><br>
								<input type="radio" name="amount" id="018" onclick="handleRadioChange(this);" value="25" /> $25.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Turismo
								<br><br>
								<input type="radio" name="amount" id="014" onclick="handleRadioChange(this);" value="20" /> $20.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Stafford
								<br><br>
								<input type="radio" name="amount" id="016" onclick="handleRadioChange(this);" value="17" /> $17.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cheetah
								<br><br>
								<input type="radio" name="amount" id="017" onclick="handleRadioChange(this);" value="17" /> $17.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Super GT
								<br><br>
								<input type="radio" name="amount" id="019" onclick="handleRadioChange(this);" value="17" /> $17.00
								<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Banshee
								<br><br>
								<h4 class="colored"><b><s>IMPORTANT:</s><br> YOU WILL NOT RECEIVE YOUR PERKS UNLESS YOU CLICK RETURN TO DONATE@UNITEDGAMING.ORG AFTER PAYMENT!<br></b></h4>
								<?php
								$faggotQuery = mysql_query("SELECT `email` FROM `accounts` WHERE id='" . $userID . "' LIMIT 1", $MySQLConn);
								$fetchDatFaggot = mysql_fetch_assoc($faggotQuery);
								$donateEmailAddress = $fetchDatFaggot['email'];
								if (empty($donateEmailAddress)) {
									$donateEmailAddress = '<span class="colored">You do not have an email address set to your account.<br><a href="/ucp/editdetails/">Click here to set one.</a></span>';
								} else {
									$donateEmailAddress = '<input type="submit" class="button black" name="I1" id="submitButton" disabled="true" value="Donate" />';
								}
								echo $donateEmailAddress;?>
							</form>
						</div>
					</div>
<?php } ?>