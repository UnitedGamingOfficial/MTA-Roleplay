<?php
require_once ('GameQ/GameQ.php'); //class
// IP will be changeable through the Admin Panel in 2.0,
// ~Chase xx

function gameServerStats(){

$server['mtasa'] = array ('mtasa', '69.197.38.155', 22003+123); //ip & port
$query = new GameQ;
$query -> addServers ($server);
$data = $query->requestData();
foreach ($server AS $server_id => $values) {
	$info = $data[$server_id];
	if (!$info["servername"]) { ?>
		<a href="mtasa://69.197.38.155:22003">Server IP: <span style="color:red">69.197.38.155 </span></a>- Offline
	<?php 
	} else { ?>
		<a href="mtasa://69.197.38.155:22003"><span style="color:green">69.197.38.155</span></a> - <?php echo $info["num_players"];?> Online
		<?php
	}
}
}

function gameServerStatsCP(){

$server['mtasa'] = array ('mtasa', '69.197.38.155', 22003+123); //ip & port
$query = new GameQ;
$query -> addServers ($server);
$data = $query->requestData();
foreach ($server AS $server_id => $values) {
	$info = $data[$server_id];
	if (!$info["servername"]) {
		echo '<p style="color:red">Connection to game server failed, <a href="" class="link">try again</a><br><br>THIS FUNCTION IS CURRENTLY BROKEN <br>Take care,<br>    Chuevo</p>';
	} else { ?>
		<p><?php echo $info["servername"];?>
		<br /><span style="color:green">Server Online</span><br />
		Players: <?php echo $info["num_players"] . "/" . $info["max_players"];?>
		<br />Playerlist: <?php echo $info["mapname"];?></p>
		<?php
	}
}
}

?>