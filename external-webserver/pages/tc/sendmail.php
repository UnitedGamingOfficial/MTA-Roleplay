<?php
	$sid = mysql_real_escape_string($_GET['view']);
	$gti = mysql_query("SELECT * FROM tc_tickets WHERE id ='" . $sid . "'");
	$gti = mysql_fetch_array($gti);

	if($admin >= 1 && $username != $gti['assigned'])
	{
		$gpia = mysql_query("SELECT * FROM accounts WHERE id='" . $gti['creator'] . "'");
		$gpi = mysql_fetch_array($gpia);
		$smtp = new SMTP($Config['SMTP']['hostname'], 465, true, 5);
		$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
		$smtp->mail_from($Config['SMTP']['from']);

		$smtp->send($gpi['email'], 'New Message On Your Ticket, #'.$_GET["view"].' - United Gaming Ticket Center', 'Hello ' . getNameFromUserID($gti["creator"],  $MySQLConn) . ',

Administrator '. $username .'  has responded to your ticket.

Your ticket URL: http://unitedgaming.org/ticketcenter/view/' . $_GET["view"] . '/

Kind Regards,
Chuevo');

	}else{
		$gpi = mysql_query("SELECT * FROM accounts WHERE id='" . $gti['assigned'] . "'");
		$gpi = mysql_fetch_array($gpi);

		$smtp = new SMTP($Config['SMTP']['hostname'], 465, true, 5);
		$smtp->auth($Config['SMTP']['username'], $Config['SMTP']['password']);
		$smtp->mail_from($Config['SMTP']['from']);

		$smtp->send($gpi['email'], 'New Message On Your Ticket, #'.$_GET["view"].' - United Gaming Ticket Center', 'Hello ' . getNameFromUserID($gti["assigned"],  $MySQLConn) . ',

'.$username.' has responded to your ticket.

Ticket URL: http://unitedgaming.org/ticketcenter/main/' . $_GET["view"] . '/

Kind Regards,
Chuevo');
	}
?>