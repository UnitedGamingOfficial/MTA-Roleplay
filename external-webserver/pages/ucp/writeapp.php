<?php
if(!isset($_SESSION['ucp_loggedin']) or !$_SESSION['ucp_loggedin'])
{
	header("Location: /ucp/login/");
	die();
}

$userID = $_SESSION['ucp_userid'];
$appState = $_SESSION['ucp_appstate'];
/*
	---- App States ----
	3 = Accepted
	2 = Denied
	1 = Pending Review
	0 = Not Written
*/
if(!isset($_GET['param2']) || $_GET['param2'] == 'write')
{
?>
		<!-- MAIN CONTENT -->
		<div class="one separator"></div>
		<!-- WELCOME BLOCK -->
		<div class="one notopmargin">
			<h3 class="welcome nobottommargin left"><?php echo $global['UCP']['CHAR']['Title']; ?></h3>
			<p class="left description ">Writing a Server Application</p>
		</div>
		<!-- END WELCOME BLOCK -->
		<?php require_once("././includes/sidebar.php"); ?>
		<div class="three-fourth notopmargin last"> <br />
		<h4 class="colored">Welcome to the UnitedGaming Server Application!</h4>
		<h4><center> Here you can write a server application so that you can access the UnitedGaming MTA Server once again!
		It will only take a few minutes to write! So why not do it now! </center> </h4> <br />
		<?php if(isset($_SESSION['ucp_app_error'])) { echo '<span style="color:red"> ' . $_SESSION['ucp_app_error'] . ' </span>'; } ?>
		<form action="/ucp/serverapp/submit" method="POST">
			<!-- START OF SERVER APPLICATION -->
			<input type="hidden" name="isValid" value="false" id="validator">
			<script language="javascript">
				function checkCharacters(element) {
					var len = element.value.length;
					if(len >= 50) {
						document.getElementById("validator").value = "true";
					}
					else {
						document.getElementById("validator").value = "false";
					}
				}
			</script>
			<!-- Question One -->
			<p class="small-italic">Question One:</p>
			<p> Do you know English? If yes, rate your level of understanding on a scale of 1-10. </p>
			<input type="text" name="q1" value="<?php echo $_SESSION['ucp_app_q1']; ?>"><br /><br />
			<!-- Question Two -->
			<p class="small-italic">Question Two:</p>
			<p> What country do you reside in? </p>
			<input type="text" name="q2" value="<?php echo $_SESSION['ucp_app_q2']; ?>"><br /><br />
			<!-- Question Three -->
			<p class="small-italic">Question Three:</p>
			<p> Have you ever roleplayed before? If so, on what games/servers? </p>
			<input type="text" name="q3" value="<?php echo $_SESSION['ucp_app_q3']; ?>"><br /><br />
			<!-- Question Four -->
			<p class="small-italic">Question Four:</p>
			<p> What does the command /me do? Provide an example. </p>
			<textarea rows="4" cols="50" name="q4" value="<?php echo $_SESSION['ucp_app_q4']; ?>"></textarea>
			<!-- Question Five -->
			<p class="small-italic">Question Five:</p>
			<p> What does the command /do do? Provide an example. </p>
			<textarea rows="4" cols="50" name="q5" value="<?php echo $_SESSION['ucp_app_q5']; ?>"></textarea>
			<!-- Question Six -->
			<p class="small-italic">Question Six:</p>
			<p> What is powergaming? Provide an example. </p>
			<textarea rows="4" cols="50" name="q6" value="<?php echo $_SESSION['ucp_app_q6']; ?>"></textarea>
			<!-- Question Seven -->
			<p class="small-italic">Question Seven:</p>
			<p> What is metagaming? Provide an example. </p>
			<textarea rows="4" cols="50" name="q7" value="<?php echo $_SESSION['ucp_app_q7']; ?>"></textarea>
			<!-- Question Eight -->
			<p class="small-italic">Question Eight:</p>
			<p> What is the difference between IC and OOC? </p>
			<textarea rows="4" cols="50" name="q8" value="<?php echo $_SESSION['ucp_app_q8']; ?>"></textarea>
			<!-- Question Nine -->
			<p class="small-italic">Question Nine:</p>
			<p> What would you do if you had to travel a long distance without a vehicle? </p>
			<textarea rows="6" cols="75" name="q9" value="<?php echo $_SESSION['ucp_app_q9']; ?>"></textarea>
			<!-- Question Ten -->
			<p class="small-italic">Question Ten:</p>
			<p> What would you do if someone broke one of the server rules while in a roleplay situation with you? </p>
			<textarea rows="6" cols="75" name="q10" value="<?php echo $_SESSION['ucp_app_q10']; ?>"></textarea>
			<!-- Question Eleven -->
			<p class="small-italic">Question Eleven:</p>
			<p> Write a short story/plan (minimum 50 characters) for one of the characters you will be creating and playing as.</p>
			<textarea rows="6" cols="75" name="q11" onkeypress="checkCharacters(this);" value="<?php echo $_SESSION['ucp_app_q11']; ?>"></textarea>
			<!-- END OF SERVER APPLICATION -->
			<p> Thats it! Your done! Click the button below to submit your application to the UnitedGaming Gamemaster and Administation team! </p>
			<input type="submit" class="button" value="Submit!" />
		</form>
<?php
}
elseif ($_GET['param2'] == "submit")
{
	$answers = array();
	for($i = 1; $i <= 11; $i++)
	{
		$_SESSION['ucp_app_q'.$i] = $_POST['q'.$i];
		$answers[$i] = $_POST['q'.$i];
	}
	$coounter = 0;
	foreach($answers as $answer)
	{
		$counter++;
		if(strlen($answer) == 0)
		{
			$_SESSION['ucp_app_error'] = "You left a question blank! Please go back and fix this before trying again!";
			echo "$counter empty";
			//header("Location: /ucp/serverapp/write");
			exit();
		}
	}
	if($_POST['isValid'] == "false")
	{
		$_SESSION['ucp_app_error'] = "Your answer for question 11 was not long enough. Please lengthen it and try again!";
		echo "not valid";
		//header("Location: /ucp/serverapp/write");
		exit();
	}
}
?>