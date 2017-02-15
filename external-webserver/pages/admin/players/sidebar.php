		<?php error_reporting(1); if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ ?>
        <div class="one separator  margin15"></div>
        <div class="one-fourth left">
        <div class="one-fourth notopmargin sidebar last">
            <h3 class=" notopmargin">Hello Guest</h3>
            <ul class="content-navigation">
                <li class="margin15 sep"></li>
                <li><a href="/ucp/main/">Login to My Account</a></li>
                <li class="sep"></li>
                <li><a href="/ucp/perktransfer/">Create a New Account</a></li>
            </ul>
        </div>
		<div class="one-fourth sidebar last">
			<h3 class=" notopmargin">Pages</h3>
			<ul class="content-navigation">
				<li class="margin15 sep"></li>
				<li><a href="/main/home/">Home</a></li>
				<li class="sep"></li>
				<li><a href="/main/staff/">Staff</a></li>
				<li class="sep"></li>
				<li><a href="/main/guides/">Guides</a></li>
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
            </ul>
        </div>
		<?php //	I don't feel this is that well needed.
		/*<div class="one-fourth sidebar last">
			<h3 class=" notopmargin">Pages</h3>
			<ul class="content-navigation">
				<li class="margin15 sep"></li>
				<li><a href="/main/home/">Home</a></li>
				<li class="sep"></li>
				<li><a href="/main/staff/">Staff</a></li>
				<li class="sep"></li>
				<li><a href="/main/guides/">Guides</a></li>
			</ul>
		</div>*/ ?>
		<?php 
		if ($adminLevel >= 1)
			{
		?>
		<div class="one-fourth sidebar last">
			<h3 class=" notopmargin">Admin Control Panel</h3>
			<ul class="content-navigation">
				<li class="margin15 sep"></li>
				<li><a href="/admin/main/">Dashboard</a></li>
				<?php if ($adminLevel >= 2){?>
				<li class="sep"></li>
				<li><h6 class="notopmargin">Player Management</h6></li>
				<li class="sep"></li>
				<li><a href="/admin/logs/">Admin Logs</a></li>
				<?php if ($adminLevel >= 5){?>
				<li class="sep"></li>
				<li><h6 class="notopmargin">Admin Management</h6></li>
				<li class="sep"></li>
				<li><a href="/admin/perks/">Perk Control</a></li>				
				<?php } } ?>

			</ul>
		</div>
		<?php } } ?>
        </div>