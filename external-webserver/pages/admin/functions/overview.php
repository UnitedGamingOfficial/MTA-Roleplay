<?php

/*
 * <?php/*<span style="font-size:18px;" class="colored">Promote or Demote Admin</span>
	<br />
	<br />
	<script type="text/javascript">
	function noNumbers(e)
	{
	var keynum;
	var keychar;
	var numcheck;	
	if(window.event) // IE
	{
	keynum = e.keyCode;
	}
	else if(e.which) // Netscape/Firefox/Opera
	{
	keynum = e.which;
	}
	keychar = String.fromCharCode(keynum);
	numcheck = /\d/;
	return !numcheck.test(keychar);
	}
	</script>
	<form name="prodemo" action="" method="POST">
	<?php echo $promoteDemoteDone;?>
	<div class="ddedit">
	<select>
	<option value="" disabled selected>Select Admin</option>
	<option value="" disabled>ID / Level / Username</option>
	<?php 
	$ga = mysql_query("SELECT `id`,`username`, `admin` FROM accounts WHERE admin >= '1' ORDER BY username ASC");
	while($as = mysql_fetch_array($ga))
	{
	?>
	<option name="adminuser" value="<?php echo $as["id"]; ?>"><?php echo '['.$as["id"].' / '.$as["admin"].'] '. $as["username"]; ?></option>
	<?php } ?>
	</select>
	</div>
	<br />
	<div class="ddedit">
	<select>
	<option value="" disabled selected>Select Admin Level</option>
	<option id="a0" name="al" value="0">[0] Player</option>
	<option id="a1" name="al" value="1">[1] Trial Administrator</option>
	<option id="a2" name="al" value="2">[2] Full Administrator</option>
	<option id="a3" name="al" value="3">[3] Super Administrator</option>
	<option id="a4" name="al" value="4">[4] Lead Administrator</option>
	<option id="a5" name="al" value="5">[5] Head Administrator</option>
	<option id="" value="" disabled>[6] Owner</option>
	</select>
	</div>
	<?php /*<input type="number" name="selectedLevel" maxlength="1" class="text-inputs"  onblur="if (this.value == '') {this.value = '0 - 6';}"
	onfocus="if (this.value == '0 - 6') {this.value = '';}" onkeydown="return noNumbers(event)" value="0 - 6"/>((///*?>///))
	<input type="submit" name="prodemo-submit" class="button" value="Set Admin"/>
	</form>
	
	<br />
	<h5>Set Admin (new)</h5>
 */?>
 