<?php
include("./includes/mta_sdk.php");
include("./includes/auth.php");

$input = mta::getInput(); //$input[0] = username $input[1] = password $input[2] = Wants hash $input[3] = client var
mta::doReturn(authenticate($input[0], $input[1]), $input[0], $input[2], $input[3]);
?>