	<?php

					function showLevel($adminlevel)
					{
						global $admins;
						if (!isset($admins[$adminlevel])) {
							echo "<li>None</li>\r\n";
						} else {
							foreach ($admins[$adminlevel] as $admin)
								echo "<li>".$admin."</li>\r\n";
						}
					}

	?>
		<!-- MAIN CONTENT -->
		<div class="one separator"></div>
		<!-- WELCOME BLOCK -->
		<div class="one notopmargin">
			<h3 class="welcome nobottommargin left"><?php echo $global['Page']['Staff']['Title']; ?></h3>
			<p class="left description "><?php echo $global['Page']['Staff']['Status']; ?></p>
		</div>
		<!-- END WELCOME BLOCK -->
			<?php require_once("./includes/sidebar.php"); ?>
		<div class="three-fourth last">
		<div class="three-fourth notopmargin last">
	<?php
					$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);

					$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);
					echo mysql_error($MySQLConn);
					if (true == false) { //SERVER OFFLINE
					?>
			<div class="big-round-icon-black left margin15"><div class="icon-black-big icon38-black"><img src="/images/1px.png" alt="" width="24px" height="24px"></div></div><h2 class="colored">GAME SERVER IS <span class="highlight-orange">Offline</span></h2>
			<p>The database cannot be contacted at this time, try again later.</p>
					<?php
					}
					else {
						$admins = array();
						$mQuery1 = mysql_query("SELECT `username`, `admin`, `adminreports`, `monitored` FROM `accounts` WHERE `admin` > -4 ORDER BY `username` ASC");
						while ($row = mysql_fetch_assoc($mQuery1))
						{
							if (!isset($admins[ $row['admin'] ]))
								$admins[ $row['admin'] ] = array();
								
							$admins[ $row['admin'] ][] = $row['username'];
							$admins[ $row['admin'] ][] = $row['username'] = $row['adminreports'];
						}
					?>	
			<center>
				<h1>MTA Staff List w/Reports<h1>
				<p>Username <br> Reports</p>
				<h3 class="colored">Server Owners</h3>
				<ul>
					<span class="colored"><?php showLevel(7); ?></span>
				</ul>
				<h3 class="colored">Head Administrators</h3>
				<ul>
					<?php showLevel(6); ?>
				</ul>
				<h3 class="colored">Lead Administrators</h3>
				<ul>
					<?php showLevel(5); ?>
				</ul>
				<h3 class="colored">Super Administrators</h3>
				<ul>
					<?php showLevel(4); ?>
				</ul>
				<h3 class="colored">Administrators</h3>
				<ul>
					<?php showLevel(3); ?>
				</ul>
				<h3 class="colored">Trial Administrators</h3>
				<ul>
					<?php showLevel(2); ?>
				</ul>
				<h3 class="colored">Suspended Administrators</h3>
				<ul>
					<?php showLevel(1); ?>
				</ul>
				<h3 class="colored">Game Masters</h3>
				<ul>
					<?php showLevel(-2); ?>
				</ul>
			</center>
				
		</div>
		</div>
		<!-- END MAIN CONTENT -->
	<?php } ?>