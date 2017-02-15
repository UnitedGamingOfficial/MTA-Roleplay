<?php 
function authenticate($user, $password) {
	if(empty($user) || empty($password)) return false;
 
	// Active Directory server
	$ldap_host = "ugdev01.ug.unitedgaming.org";
 
	// Active Directory DN
	$ldap_dn = 'OU=UG Users,DC=ug,DC=unitedgaming,DC=org';
 
	// Active Directory user group
	$ldap_user_group = "MTA Users";
 
	// Domain, for purposes of constructing $user
	$ldap_usr_dom = '@ug.unitedgaming.org';
 
	// connect to active directory
	$ldap = ldap_connect($ldap_host);
 
	// verify user and password
	if($bind = @ldap_bind($ldap, $user.$ldap_usr_dom, $password)) {
		// valid
		// check presence in groups
		$filter = "(sAMAccountName=".$user.")";
		$attr = array("memberof");
		$result = ldap_search($ldap, $ldap_dn, $filter, $attr) or exit("Unable to search LDAP server ".ldap_error($ldap));
		$entries = ldap_get_entries($ldap, $result);
		ldap_unbind($ldap);
		
		//if the user was found
		if(array_key_exists(0, $entries)){
		// check groups
			foreach($entries[0]['memberof'] as $grps) {
				// is user
				if(strpos($grps, $ldap_user_group)) $access = 1;
			}
		}
 
		if(isset($access) != 0) {
			// establish session variables
			return true;
		} else {
			// user has no rights
			return false;
		}
 
	} else {
		// invalid name or password
		return false;
	}
}

function register($user, $password) {
	// Active Directory server
	$ldap_host = "ldaps://UGDEV01.ug.unitedgaming.org";
	//Admin Credentials (With permission to bind to AD)
	$ldap_user = "ldapbind@ug.unitedgaming.org";
	$ldap_password = 'SecretPassword123';
	// connect to active directory
	$ldap = ldap_connect($ldap_host);
	ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
	if(@ldap_bind($ldap, $ldap_user, $ldap_password)) {	
		$adduserAD["cn"][0] = $user;
		$adduserAD["objectclass"][0] = "top";
		$adduserAD["objectclass"][1] = "person";
		$adduserAD["objectclass"][2] = "organizationalPerson";
		$adduserAD["objectclass"][3] = "user";
		$adduserAD["displayname"][0] = $user;
		$adduserAD["name"][0] = $user;
		$adduserAD['userPrincipalName'] = $user.'@ug.unitedgaming.org';
		$adduserAD["sAMAccountname"][0] = $user;
		$password = "\"" . $password . "\"";
		$len = strlen($password);
		for ($i = 0; $i < $len; $i++) $newpass .= "{$password{$i}}\000";
		$adduserAD["unicodePwd"] = $newpass;
		//$addUserAD['userPassword'] = make_ssha_password($password);
		$adduserAD['userAccountControl'] = 66048;
		$adduserDN = 'CN='.$user.',OU=UG Users,DC=ug,DC=unitedgaming,DC=org';
		if (ldap_add($ldap, $adduserDN, $adduserAD)){
			$entry['member'] = $adduserDN;
			if(ldap_mod_add($ldap, "cn=MTA Users,ou=MTA Groups,dc=ug,dc=unitedgaming,dc=org", $entry)){
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	} else {
		return false;
	}
}

function changepass($username, $oldPassword, $password){
	if(empty($user) || empty($password)) return false;
 
	// Active Directory server
	$ldap_host = "ug-ad.ug.unitedgaming.org";
	//Admin Credentials (With permission to modify to AD users)
	$ldap_user = "ldapbind@ug.unitedgaming.org";
	$ldap_password = 'SecretPassword123';
	// connect to active directory
	$ldap = ldap_connect($ldap_host);
 
	if($bind = @ldap_bind($ldap, $ldap_user, $ldap_password)) {	
		
	}
}
?>