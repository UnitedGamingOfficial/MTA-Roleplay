<?php
/*
<!-- $Id: cronbackup.php 873 2012-05-24 01:03:17Z  $ -->

Paul M - Auto-Backup for vBulletin 4.2
Adapted from the original 3.0.x version by Trigunflame.
*/

error_reporting(E_ALL & ~E_NOTICE);
if (!is_object($vbulletin->db)) exit;

@ignore_user_abort(1);
@set_magic_quotes_runtime(0);

require_once(DIR.'/includes/adminfunctions.php');
require_once(DIR.'/includes/mysqlbackup.php');

$mysqlBackup = &new mysqlBackup($vbulletin->db, $vbulletin->options);

$mysqlBackup->cronBackup();

echo '<br />'.$mysqlBackup->STATUS;
log_cron_action($mysqlBackup->STATUS, $nextitem);

?>
