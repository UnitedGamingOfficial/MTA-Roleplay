				</div>
				<div id="sidebarright">
					<div id="sidebar-news">
						<p><?php
if (isset($_SESSION['ucp_loggedin']) and $_SESSION['ucp_loggedin'] and isset($_GET['ucp']) or isset($_GET['tc']))
{
?>
							
							- <a href="/ucp/main/">UCP HOME</a><BR />
							- <a href="/ucp/characterlist/">CHARACTER LIST</a><BR />
							- <a href="/ucp/editdetails/">EDIT YOUR DETAILS</a><BR />
							- <a href="/ucp/perktransfer/">PERK TRANSFER</a><BR />
							- <a href="/ucp/logout/">LOGOUT</a><br />
							<br />
<?php
	if (isset($_SESSION['ucp_adminlevel']) AND $_SESSION['ucp_adminlevel'] >= 2)
	{
?>							- <a href="/admin/interiors/main/">InteriorAdmin [Alpha]</a><br />
							- <a href="/admin/players/main/">PlayerAdmin [Alpha]</a><br />
<?php
	}
}
else 
{
?>
							<div style="margin-left:-25px;padding-top:10px;"></div>
<?php
	$rssURL = 'http://www.mtaroleplay.net/forums/external.php?type=RSS2&forumids=4';
	$cacheRSS= new fileCache(600, "cache/");
	$getCache = $cacheRSS->cache($rssURL);
	$output = '';
	if (!isset($getCache) or !$getCache) {	
		$rss = simplexml_load_file($rssURL);
		$i=0;
		if($rss){
			$items = $rss->channel->item;
			foreach($items as $item){
				if($i==3) // limit to three
					  break;    
					  
				$i++;
				$ns_dc = $item->children('http://purl.org/dc/elements/1.1/');  
				$output .= '						<h3 style="margin-bottom: 0pt"><a href="'.$item->guid.'" style="text-decoration: none;">'.$item->title.'</a></h3>'."\r\n";
				$output .= '						'.$item->pubDate.'<BR />'."\r\n";
				$output .= '						Posted by <a href="#">'.$ns_dc->creator.'</a><BR />'."\r\n";
				$output .= '						<p>'.$item->description.'</p>'."\r\n";
			}
			
			$cacheRSS->cache($rssURL,$output);//save cache	
		}   		
	}
	else {
		$output = $getCache;
	}
							
	echo $output;
}
?></p>
					</div>
				</div>
			</div>
			<div id="heavy-stone">
				<h6>
					Copyright © 2011-2012 MTA Roleplay. All rights reserved. 
Grand Theft Auto, Grand Theft Auto: San Andreas and their logos are registered trademarks of <BR />Take-Two Interactive Software Inc.
				</h6>
			</div>
		</div>
		
	</BODY>
</HTML>