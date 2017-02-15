<?php 
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
			return ldap_err2str(ldap_errno($ldap));
		}
	} else {
		return '3';
	}
}
?>