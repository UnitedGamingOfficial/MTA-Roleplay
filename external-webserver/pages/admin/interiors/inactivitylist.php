<?php
		if ($adminLevel < 5)
	{
		header("Location: /ucp/main/");
		die();
	}
	require_once("includes/header.php");
?>				<!-- Middle Column - main content -->
					<div id="content-middle">
						<div class="content-box">
							<div class="content-holder">
								<h2>AdminCP - Property Inactivity Lists (PIL)</h2>
								<BR />
								<BR />
								<TABLE>
									<TR>
										<TH>ID</TH>
										<TH>Owner</TH>
										<TH>Name</TH>
										<TH>Cost</TH>
										<TH>Lastused</TH>
									</TR>

<?php
$mQuery2 = mysql_query("SELECT `id`, `type`, `owner`, `locked`, `cost`, `name`, `lastused` FROM interiors WHERE owner != -1 AND lastused < (NOW() - interval 2 week) ORDER BY `lastused` ASC", $MySQLConn);
if (mysql_num_rows($mQuery2) == 0)
{
	echo "									<TR>\r\n";
	echo "										<TD COLSPAN=5>Nothing to show here :'(</TD>\r\n";
	echo "									</TR>\r\n";
}
while ($row = mysql_fetch_assoc($mQuery2))
{
	echo "									<TR>\r\n";
	echo "										<TD>".$row['id']."</TD>";
	echo "										<TD>".getNamefromCharacterID($row['owner'], $MySQLConn)."</TD>\r\n";
	echo "										<TD>".$row["name"]."</TD>\r\n";
	echo "										<TD>$ ".$row['cost']."</TD>\r\n";
	echo "										<TD>".$row['lastused']."</TD>\r\n";
	echo "									</TR>\r\n";
}
?>								</TABLE>	
							</div>
						</div>
					</div>
<?php
	require_once("includes/footer.php");
?>