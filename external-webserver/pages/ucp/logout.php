<?php
$_SESSION['ucp_loggedin'] = false;
session_destroy();
header("Location: /main/home/");
?>