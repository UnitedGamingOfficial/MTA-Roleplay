<?php
include("./includes/auth.php");
include("./includes/mta_sdk.php");

$input = mta::getInput();
//mta::doReturn(changepass($input[0], $input[1], $input[2]), $input[3]);
mta::doReturn(false, $input[3]);
?>