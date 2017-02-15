<?php
error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);
ini_set("display_errors",1);
// Initialize session
session_start();
 
function authenticate($user, $password) {
	if(empty($user) || empty($password)) return false;
 
	// Active Directory server
	$ldap_host = "UGDEV01.ug.unitedgaming.org";
 
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
			$_SESSION['user'] = $user;
			$_SESSION['access'] = $access;
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
?>