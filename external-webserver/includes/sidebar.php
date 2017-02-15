		<?php error_reporting(1); if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ ?>
        <div class="one separator  margin15"></div>
        <div class="one-fourth left">
        <div class="one-fourth notopmargin sidebar last">
            <h3 class=" notopmargin">Hello Guest</h3>
            <ul class="content-navigation">
                <li class="margin15 sep"></li>
                <li><a href="/ucp/main/">Login to my account</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/perktransfer/">Register a new account</a></li>
            </ul>
        </div>	
		<?php } else { ?>
        <div class="one separator  margin15"></div>
        <div class="one-fourth left">
        <div class="one-fourth notopmargin sidebar last">
            <h3 class=" notopmargin">User Control Panel</h3>
            <ul class="content-navigation">
                <li class="margin15 sep"></li>
                <li><a href="/ucp/main/">Overview</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/perktransfer/">Perk Transfer</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/editdetails/">Settings</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/logout/">Logout</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/donate/" class="donatenow">Donate</a></li>
            </ul>
        </div>
        <?php if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ ?>
        <?php } else { ?>
		<?php if ($clientAdmin <=1)
			{
		?>
        
        <div class="one-fourth sidebar last">
        	<h3 class=" notopmargin">Ticket Center</h3>
            <ul class="content-navigation">
                <li class="margin15 sep"></li>
                <li><a href="/ticketcenter/main/">Dashboard</a></li>
                <li class="sep"></li>
                <li><a href="/support/new/">Create Ticket</a></li>
            </ul>
        </div>
			<?php } elseif ($clientAdmin >=2) { ?>
        <div class="one-fourth sidebar last">
            <h3 class=" notopmargin">Ticket Center</h3>
            <ul class="content-navigation">
                <li class="margin15 sep"></li>
                <li><a href="/ticketcenter/main/" class="">Dashboard</a></li>
                <li class="sep"></li>
                <li><a href="/ticketcenter/main/assigned/" class="">My Tickets</a></li>
                <li class="sep"></li>
                <li><a href="/ticketcenter/main/locked/" class="">Locked Tickets</a></li>
                <li class="sep"></li>
                <li><a href="/tc/new/" class="">Create Ticket</a></li>
            </ul>
        </div>
		<?php } } ?>
		<?php 
		if ($clientAdmin >= 1)
			{
		?>
		<div class="one-fourth sidebar last">
			<h3 class=" notopmargin">Admin Control Panel</h3>
			<ul class="content-navigation">
				<li class="margin15 sep"></li>
				<li><a href="/admin/main/">Dashboard</a> <img src="/images/new_4.png" /></li>
                <?php if ($clientAdmin >= 6){?>
				<li class="sep"></li>
				<li><a href="#">Mailing</a></li>	
				<?php } if ($clientAdmin >= 2){?>
				<li class="sep"></li>
				<li><h6 class="notopmargin">Player Management</h6></li>
				<li class="sep"></li>
				<li><a href="/admin/logs/">Admin Logs</a></li>
				<li class="sep"></li>
				<li><a href="/admin/accsearchm/">Account Search</a></li>
				<?php if ($clientAdmin >= 6){?>
				<li class="sep"></li>
				<li><h6 class="notopmargin">Admin Management</h6></li>
				<li class="sep"></li>
				<li><a href="/admin/perks/">Perk Control</a></li>
                <?php }?>
            </ul>		
            </div>
				<?php }?>
		<?php 
		if($clientAdmin <= -2)
			{
		?>
		<div class="one-fourth sidebar last">
			<h3 class=" notopmargin">Gamemaster Center</h3>
			<ul class="content-navigation">
				<li class="margin15 sep"></li>
				<li><a href="/admin/main/">Dashboard</a></li>
				<li class="sep"></li>
				<li><a href="/system/mail/">New Applications</a></li>	
				<li class="sep"></li>
				<li><a href="/system/mail/">Accepted Applications</a></li>
				<li class="sep"></li>
				<li><a href="/admin/logs/">Denied Applications</a></li>
                </ul>
               </div>
				<?php }?>


			
		<?php  } } ?>
     </div>