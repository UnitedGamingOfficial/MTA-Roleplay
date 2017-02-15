<?php


		function EMAIL_tc($e_to,$e_to_name,$e_subject,$e_in_subject,$e_body){
					// Create the mail transport configuration
					$transport = Swift_MailTransport::newInstance();
					
					// Create the message
					$message = Swift_Message::newInstance();
					$message->setTo(array(
					  $e_to => $e_to_name
					));
					$message->setSubject($e_subject . " - UnitedGaming");
					
					$message->setBody(
					'<html>
					<link href=\'http://fonts.googleapis.com/css?family=Source+Sans+Pro\' rel=\'stylesheet\' type=\'text/css\'>
					<table border="0" align="center" width="99%">
					<tr>
					<td><a href="http://unitedgaming.org" target="_blank" title="UnitedGaming" alt="UnitedGaming"><img src="http://unitedgaming.org/mainlogo.png" alt="UnitedGaming" border="0"/></td>
					<td><span style="font-family: \'Source Sans Pro\', sans-serif;"><font size="6px" color="#BD3538">'.$e_in_subject.'</font></span></td>
					</tr>' 
					.
					'<br/><br /><br/><tr>
					<td colspan="2"><font size="3px" color="#303030">'.$e_body.'
					 </td></tr><tr><td><br/><span style="font-family: \'Source Sans Pro\', sans-serif;"><font size="2px">Kind Regards,<br/>Chuevo</font></span></td><td></td></tr></table></html>
					 ');
					$message->setFrom("chuevo@unitedgaming.org", "UnitedGaming");
					$type = $message->getHeaders()->get('Content-Type');
		
					$type->setValue('text/html');
					$type->setParameter('charset', 'utf-8');
					
					//echo $type->toString();
					
					/*
					
					Content-Type: text/html; charset=utf-8
					
					*/
					// Send the email
					$mailer = Swift_Mailer::newInstance($transport);
					$mailer->send($message);
		}




//testing email function template
function EMAIL_test($e_to,$e_to_name,$e_subject,$e_in_subject,$e_body){
			// Create the mail transport configuration
			$transport = Swift_MailTransport::newInstance();
			
			// Create the message
			$message = Swift_Message::newInstance();
			$message->setTo(array(
			  $e_to => $e_to_name
			));
			$message->setSubject($e_subject . " - UnitedGaming");
			$message->setBody(
			'<html>
			<link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700" rel="stylesheet" type="text/css"/>
			<table border="0" align="center">
			<tr>
			<td><a href="http://unitedgaming.org" target="_blank" title="UnitedGaming" alt="UnitedGaming"><img src="http://unitedgaming.org/mainlogo.png" alt="UnitedGaming" border="0"/></td>
			<td><font face="Source Sans Pro" size="6px" color="#BD3538">'.$e_in_subject.'</font></td>
			</tr>' 
			.
			'<br/><br /><br/><tr>
			<td colspan="2"><font face="Arial" size="3px" color="#303030">'.$e_body.'
			 </td></tr><tr><td><br/><font face="Source Sans Pro" size="2px">Kind Regards,<br/>Chuevo</font></td><td></td></tr></table></html>
			 ');
			$message->setFrom("chuevo@unitedgaming.org", "UnitedGaming");
			$type = $message->getHeaders()->get('Content-Type');

			$type->setValue('text/html');
			$type->setParameter('charset', 'utf-8');
			
			//echo $type->toString();
			
			/*
			
			Content-Type: text/html; charset=utf-8
			
			*/
			// Send the email
			$mailer = Swift_Mailer::newInstance($transport);
			$mailer->send($message);
}

?>