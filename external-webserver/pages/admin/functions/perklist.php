<?php

$grantWho = strtoupper($_REQUEST['grantUser']);
if(isset($grantWho)){
	$output = "<div /><span color=\"green\">User ".$grantWho." has been added to the table.</span>";
	print($output);
	
}



?>