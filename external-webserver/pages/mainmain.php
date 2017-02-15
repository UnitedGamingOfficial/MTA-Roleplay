<?php
/* *
    ___               ___   ___   ___   ___   ___   ___  
   |      \ /   \ /    |     |   |       |   |   | |     
   |-+-    +     +     +     +   |       +   |-+-| |     
   |      / \    |     |     |   |       |   |   | |     
    ---                     ---   ---               ---  

*/

#Don't change the feed URL, this pipe contains TWO feeds, which can be changed by ExyTicTac if needed.
$jurl = "http://pipes.yahoo.com/pipes/pipe.run?_id=b3183c9086c4e1834d5eb10264a470a2&_render=rss";
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

$pTitle = "Home";

?>
        <!-- MAIN CONTENT -->
        <div class="one separator"></div>
        <!-- WELCOME BLOCK -->
		
        <div class="one notopmargin">
            <div class="two-third notopmargin">
            	<h1 class="welcome nobottommargin">Welcome to <a class="link" href="">United Gaming</a></h1>
            	<p class="small-italic notopmargin">Where we combine all of your favorite aspects from Multi Theft Auto and Roleplay, putting them together into one server with fantastic enjoyment, made for you - the player.</p>
				
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
		<!-- SLIDER -->
        <div class="one margin30">
        	<div class="theme-default">
                <div id="slider" class="nivoSlider">
                    <img src="/images/slides/hd-rim-mod.jpg" alt=""/>
                    <img src="/images/slides/flood-pdi-rise.jpg" alt="" />
                </div>
            </div>
        </div>
        <!-- END SLIDER -->
        
        <?php  ##Static Slider. For contest maybe?
		/*<!-- SLIDER -->
        <div class="one margin30">
        	<div class="static">
			<div>
                <img src="/images/slides/hd-rim-mod.jpg" alt=" " style="width:590px;"/>
            </div>
            <div class="notopmargin left black">
                <h3 class="notopmargin">Hello <?php if (!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin']){ echo 'Guest'; } else { echo $_SESSION['ucp_username']; }?>! <a href="/" class="link">SUBMIT A SCREENSHOT</a></h3>
                <p>We want your screenshots...(continue)))</p>
            </div>
        </div>
        </div>
        <!-- END SLIDER -->*/?>
        <div class="one separator margin30"></div>
        <div class="one-third margin30">
        	<h1 class="nobottommargin welcome">LATEST NEWS:</h1>
            <h1 class="notopmargin welcome-small colored"><a href="<?php echo $jtrue_link;?>" title="<?php echo $jtitle;?>" target="_blank"><?php echo $jtitle;?></a></h1>
        </div>
        	<?php
			
			?>
        <div class="two-third margin30 last">

            <p class="blockquote9 margin30 small-italic"><?php echo $jdescription . '   <a href="' . $jtrue_link . '" title="Read more of ' . $jtitle . ' (Opens in New Tab)" target="_blank" class="link">Read More...</a>'; }}?></p>
            <?php /*>>OLD<< <a href="<?php echo $jlink;?>" title="Read more of <?php echo $jtitle;?> (Opens in New Tab)" target="_blank" class="link">Read More...</a>*/?>
        </div>
        	
        <div class="one separator margin30"></div>
        

        <!-- Donations -->
        <div class="one-third">
           	<div class="small-round-icon-gray left">
            	<div class="icon-gray-small icon87-gray"></div>
            </div>
            <h3 class=" notopmargin"><a href="/donate/" class="link" target="_blank"><?php echo $global['HOME']['Blocks']['Header']['Left']; ?></a></h3>
            <p><?php echo $global['HOME']['Blocks']['Desc']['Left']; ?></p>
        </div>
        <!-- END Donations -->
        <!-- MTA Ticket Center -->
        <div class="one-third">
        <div class="small-round-icon-gray left">
            	<div class="icon-gray-small icon139-gray"></div>
		</div>
        <h3 class="notopmargin"><a href="http://www.unitedgaming.org/forums/forumdisplay.php/89-Reports-amp-Unban-Requests" class="link"><?php echo $global['HOME']['Blocks']['Header']['Center']; ?></a></h3>
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
