<?php
$jurl = "http://www.unitedgaming.org/forums/external.php?type=RSS2&forumids=10";
$jrss = simplexml_load_file($jurl); 
  if($jrss)
{ 
$jitems = $jrss->channel->item;
foreach($jitems as $jitem)
{
$jtitle = $jitem->title;
$jlink = $jitem->link;
$jpublished_on = $jitem->pubDate;
$jdescription = $jitem->description;
$jtrue_link = $jitem->guid;
}
}
		?>
<!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
		
        <div class="one notopmargin">
            <div class="two-third notopmargin">
            	<h1 class="welcome nobottommargin">Welcome to <a class="link" href="">United Gaming</a></h1>
            	<p class="small-italic notopmargin">The sky is the limit, and that is just where we are headed. A community raised by great ownership since December 1st, 2012, UnitedGaming has grown with over 10,000 members registered. We don't know the future, but construing the conflicts, we will go far. Together.</p>
				
        	</div>
            <div class="one-third notopmargin last">
				<?php error_reporting(0); if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ ?>
            	<a class="mega_button left right"  href="<?php echo $global['HOME']['Welcome']['Button']['Text']['LOUTURL'];?>"><?php echo $global['HOME']['Welcome']['Button']['Text']['LOUT'];?></a>
				<?php } else { ?>
				<a class="mega_button left right"  href="<?php echo $global['HOME']['Welcome']['Button']['Text']['LINURL'];?>"><?php echo $global['HOME']['Welcome']['Button']['Text']['LIN'];?></a>
				<?php } ?>
            </div>
        </div>
        <!-- END WELCOME BLOCK -->

        
		
        <div class="one separator  margin15"></div>		
	 <?php /*<!-- SLIDER --> ## Video Static
        <div class="one margin30">
        	<div id="video-block">
                <iframe src="http://player.vimeo.com/video/23534361?title=0&lt;amp;byline=0&lt;amp;portrait=0" width="940" height="350" >
                </iframe>
            </div>
        </div>
        <!-- END SLIDER -->*/?>
		
		<?php /*<!-- SLIDER --> ##Image Slider
        <div class="one margin30">
        	<div class="theme-default">
                <div id="slider" class="nivoSlider">
                    <img src="/images/slides/hd-rim-mod.jpg" alt=""/>
                    <img src="/images/slides/flood-pdi-rise.jpg" alt="" />
                </div>
            </div>
        </div>
        <!-- END SLIDER -->*/?>
        
        <!-- SLIDER -->
        <div class="one margin30">
        	<div class="static">
            <div class="notopmargin left black">
                <h3 class="notopmargin shadowcheese"><a href="http://youtu.be/3VdXtF19mwQ" target="_blank">San Andreas United Automotive Drifting Championship</a></h3>
            </div>
			<div>
                <iframe width="515" height="290" src="http://www.youtube.com/embed/3VdXtF19mwQ?rel=0" frameborder="0" allowfullscreen></iframe>
            </div>
            <table border="0" height="330px" align="right">
            <tr valign="bottom"><td valign="bottom">
            
            <center>
            <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
            <h4 class="redcheeseh4">Credits to</h4>
            <h2 class="colored notopmargin shadowcheese"><a href="http://www.unitedgaming.org/forums/member.php/1405-PinkPanda" target="_blank">PinkPanda</a></h2>
            </center>
            
            </td></tr></table>
        </div>
        </div>
        <!-- END SLIDER -->
        <div class="one separator margin30"></div>
        <div class="one-third margin30">
        	<h1 class="nobottommargin welcome">LATEST NEWS:</h1>
            <h2 class="notopmargin welcome-small colored"><a href="<?php echo $jtrue_link;?>" title="<?php echo $jtitle;?>" target="_blank"><?php echo $jtitle;?></a></h2>
        </div>
        	<?php
			
			?>
        <div class="two-third margin30 last">

            <p class="blockquote9 margin30"><?php echo $jdescription . '   <a href="' . $jtrue_link . '" title="Read more of ' . $jtitle . ' (Opens in New Tab)" target="_blank" class="strong link"> Read more</a>'; ?></p>
            <?php /*>>OLD<< <a href="<?php echo $jlink;?>" title="Read more of <?php echo $jtitle;?> (Opens in New Tab)" target="_blank" class="link">Read More...</a>*/?>
        </div>
        	
        <div class="one separator margin30"></div>
        

        <!-- Donations -->
        <div class="one-third">
           	<div class="small-round-icon-gray left">
            	<div class="icon-gray-small icon87-gray"></div>
            </div>
            <h3 class=" notopmargin"><a href="/ucp/donate/" class="link" target="_blank"><?php echo $global['HOME']['Blocks']['Header']['Left']; ?></a></h3>
            <p><?php echo $global['HOME']['Blocks']['Desc']['Left']; ?></p>
        </div>
        <!-- END Donations -->
        <!-- MTA Ticket Center -->
        <div class="one-third">
        <div class="small-round-icon-gray left">
            	<div class="icon-gray-small icon139-gray"></div>
		</div>
        <h3 class="notopmargin"><a href="/ticketcenter/main" class="link"><?php echo $global['HOME']['Blocks']['Header']['Center']; ?></a></h3>
		<p><?php echo $global['HOME']['Blocks']['Desc']['Center']; ?></p> 
        </div>
        <!-- END MTA Ticket Center -->
        <!-- MTA UCP -->
        <div class="one-third last">
           	<div class="small-round-icon-gray left">
            	<div class="icon-gray-small icon158-gray"></div>
            </div>
            <h3 class="notopmargin"><a href="/ucp/" class="link"><?php echo $global['HOME']['Blocks']['Header']['Right']; ?></a></h3>
            <p><?php echo $global['HOME']['Blocks']['Desc']['Right']; ?></p>
        </div>
		<!-- END MTA UCP -->
        <!-- END MAIN CONTENT -->
