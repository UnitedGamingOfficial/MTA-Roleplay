<?php

// Fetch the XML
$xml = simplexml_load_file('http://www.unitedgaming.org/forums/external.php?type=RSS2&forumids=10&count=120');

// Grab both title and content
for($i = 0; $i <= 120; $i++)
{
	$item = $xml->channel->item[$i];
	$title = (string)$item->title;
	if($title == "Server Rules")
	{
		break;
	}
}
$content = (string)$item->children('content',true)->encoded;
$author = (string)$item->children('dc',true)->creator;
$date = date('F jS, Y',strtotime((string)$item->pubDate));

// Reformat html code in content
$content = strip_tags($content);

// Output it MTA-friendly
echo json_encode(array($title, $content));
?>