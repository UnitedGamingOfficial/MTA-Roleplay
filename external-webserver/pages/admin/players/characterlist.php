<?php

	if ($adminLevel < 2)
	{
		header("Location: /ucp/main/");
		die();
	}
	
	session_start();
?>

<style type="text/css">
table.sample {
	border-width: 1px;
	border-spacing: 5px;
	border-style: solid;
	border-color: gray;
	border-collapse: collapse;
}
table.sample th {
	border-width: 1px;
	padding: 2px;
	border-style: dotted;
	border-color: gray;
	-moz-border-radius: 0px 0px 0px 0px;
}
table.sample td {
	border-width: 1px;
	padding: 2px;
	border-style: dotted;
	border-color: gray;
	-moz-border-radius: 0px 0px 0px 0px;
}

tr.normal{
	
}

tr.normalon {

background-color: #999;
color: #000000; 

} 
</style>				<div id="content">
			<div class="news">
				<div class="news-info">
				  <h3 class="news-title">Character list</h3>
				</div>
			
				<div class="news-text">
					<p>
<?php

$sort = $_GET['sortby'];

if($sort == ''){
	$sort = 'id'; 
	$displaysort = 'ID';
	$way = 'ASC';
	}
	
	elseif($sort == 'name'){
	$sort = 'charactername'; 
	$displaysort = 'Name'; 
	$way = 'ASC'; 
	}
	
	elseif($sort == 'id'){
	$sort = 'id'; 
	$displaysort = 'ID'; 
	$way = 'ASC';
	}
	elseif($sort == 'playtime'){
	$sort = 'hoursplayed'; 
	$displaysort = 'Play time (hours)';
	$way = 'DESC';
	 }
	 
	elseif($sort == 'wealth'){
	$sort = 'bankmoney'; 
	$displaysort = 'Wealth';
	$way = 'DESC';
	 }
	
//echo "<font size='4'>Ordering by: " . $displaysort . "</font><br /><br />";

$MySQLConn = @mysql_connect($Config['database']['hostname'], $Config['database']['username'], $Config['database']['password']);

$selectdb = @mysql_select_db($Config['database']['database'], $MySQLConn);

$history = mysql_query("SELECT * FROM characters ORDER BY $sort $way")
or die(mysql_error());  



echo "<table class='sample' width='98%' border='0'>
  <tr>
    <td><U><strong><a><font>ID</font></a></strong></U></td>
    <td><U><strong><a><font>Name</font></a></strong></U></td>
    <td><U><strong><a><font>Play time (hours)</font></a></strong></U></td>
    <td><U><strong><a><font>Wealth</font></a></strong></U></td>
	
  </tr>";
while($row = mysql_fetch_array( $history )) {
	$id = $row['id'];
	$name = $row['charactername'];	 
	$wealth = $row['money'] + $row['bankmoney'];
	$playtime = $row['hoursplayed'];	 	
	$name2 = str_replace("_", " ", $name);
	
	echo "
  <tr class='normal' onmouseover=\"this.className='normalon'\" onmouseout=\"this.className='normal'\" height='30'>
    <td>$id</td>
    <td>$name2</td>
    <td>$playtime</td>
    <td>";echo "$";echo $english_format_number = number_format($wealth);; echo"</td>
  </tr>

";
} 
 echo "</table>";
 
 		$total = mysql_query("SELECT * FROM characters")
or die(mysql_error());  
		
		$totalcharacters = mysql_num_rows($total); 
		
 ?>
 </p>

				</div>
				<ul class="news-more">
					<li><a href="#"><span><?php echo $totalcharacters; ?> characters</span></a></li>
				</ul>
			</div>
            </div>
			<?php
 include 'includes/footer.php';

?>