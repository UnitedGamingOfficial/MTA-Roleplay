<?php
include("./includes/mta_sdk.php");
include("./includes/auth.php");

$input = mta::getInput();
if(register($input[0], $input[1])){
	mta::doReturn(authenticate($input[0], $input[1]), $input[0], $input[2]);
}
?>