
        <!-- OTHER -->
        <div class="one separator"></div>
        <div class="one notopmargin tweet">
			<div class="one-fourth notopmargin">
                <div class="small-round-icon-gray left">
					<div class="icon-gray-small icon76-gray"></div>
				</div>
                <h4 class="left">
                	<a href="mtasa://mta.unitedgaming.org:22003">Server IP: <span class="colored">91.121.79.80</span></a>
                </h4>
		</div>
        </div>
        <!-- END OTHER -->

<?php if ($_SESSION['ucp_adminlevel'] < 1){ ?>
       <!--<div class="one separator notopmargin"></div>
        <div class="one notopmargin footer">
        	<div id="" align="center" style=" vertical-align:middle; text-align:center;">
            <?php //displayAD(3);?>
            </div>
    	</div>-->
<?php } ?>
        

        <!-- BOTTOM LINE -->
        <div class="one separator notopmargin"></div>
        <div class="one bottom-line notopmargin">
            <p class="margin15 left">&copy; Copyright 2012 - <?php echo $global['Footer']['Year'];?> UnitedGaming, User Control Panel</p>
            <p class="right margin15">
            <?php if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ ?>
            <a class="link" href="/ucp/login/">Login</a> | 
            <a class="link" href="/ucp/register/">Register</a>
            <?php } else { ?>
            Logged in as, <?php echo $_SESSION['ucp_username'];?> | <a class="link" href="/ucp/logout/">Logout</a>
            <?php } ?>
            </p>
        </div>
        <!-- END BOTTOM LINE -->
    <div class="clear"></div> 
    </div>
    <!-- END MAIN WRAPPER -->
</body>
</html>