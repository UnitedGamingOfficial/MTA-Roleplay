<?php
/*
    Copyright 2012 Patrick Rombouts
*/

require_once("mta_sdk.php");

class MTAConnector
{
    private $serverConnection;
    public $databaseConnection;

    private $cache_player_userid = array();
    private $cache_player_username = array();

        private $cache_character_characterid = array();
        private $cache_character_charactername = array();

    private $cache_faction_factionid = array();

    private $cache_vehicle_vehicleid = array();

    private $cache_interior_interiorid = array();

    function __construct()
    {
        $this->databaseConnection = new mysqli('mta.unitedgaming.org', 'website', 'stefr4spubr@7aph2f9epreg65Rewre7', 'mtarpsf_ug');
        if (!$this->databaseConnection)
            return false;
        return true;
    }

    public function addCache_Faction( $factionClass )
    {
        $this->cache_faction_factionid[$factionClass->getDetail('id')] = $factionClass;
    }

    public function addCache_Player( $playerClass )
    {
        $this->cache_player_userid[$playerClass->getDetail('id')] = $playerClass;
        $this->cache_player_username[$playerClass->getDetail('username')] = $playerClass;
    }

     public function addCache_Character( $characterClass )
        {
                $this->cache_character_characterid[$characterClass->getDetail('id')] = $characterClass;
                $this->cache_character_charactername[$characterClass->getDetail('charactername')] = $characterClass;
        }

    public function addCache_Vehicle ( $vehicleClass )
    {
        $this->cache_vehicle_vehicleid[$vehicleClass->getDetail('id')] = $vehicleClass;
    }

    public function addCache_Interior ( $interiorClass)
    {
        $this->cache_interior_interiorid[$interiorClass->getDetail('id')] = $interiorClass;
    }

    public function getPlayerbyName($username)
        {
                 if (!$this->databaseConnection)
                        return false;

                $fetchPlayerQuery = $this->databaseConnection->prepare("SELECT `id` FROM `accounts` WHERE `username`=? LIMIT 1");

                if (!$fetchPlayerQuery)
                        return false;

                $fetchPlayerQuery->bind_param("s", $username);
                $fetchPlayerQuery->execute();
                $fetchPlayerQuery->store_result();
                if ($fetchPlayerQuery->num_rows == 0)
                {
                        $fetchPlayerQuery->close();
                        return false;
                }
                else
                { 
                        $fetchPlayerQuery->bind_result($mtaUserID);
                        $fetchPlayerQuery->fetch();
                        $fetchPlayerQuery->close();
                        return new MTAConnectorPlayer($this, $mtaUserID);
                }
        }

    public function getCharacterbyName($charactername)
        {
                 if (!$this->databaseConnection)
                        return false;

                $fetchPlayerQuery = $this->databaseConnection->prepare("SELECT `id` FROM `characters` WHERE `charactername`=? LIMIT 1");

                if (!$fetchPlayerQuery)
                        return false;

                $fetchPlayerQuery->bind_param("s", $charactername);
                $fetchPlayerQuery->execute();
                $fetchPlayerQuery->store_result();
                if ($fetchPlayerQuery->num_rows == 0)
                {
                        $fetchPlayerQuery->close();
                        return false;
                }
                else
                {
                        $fetchPlayerQuery->bind_result($mtaCharacterID);
                        $fetchPlayerQuery->fetch();
                        $fetchPlayerQuery->close();
                        return new MTAConnectorCharacter($this, $mtaCharacterID);
                }
        }


    public function getPlayerByID($userID)
    {
        return new MTAConnectorPlayer($this, $userID);
    }

    public function getCharacterByID( $characterID )
    {
        return new MTAConnectorCharacter( $this, $characterID );
    }

    public function getFactionByID( $factionID )
    {
        return new MTAConnectorFaction($this, $factionID);
    }

    public function initalizeLogSearch()
    {
        return new MTAConnectorLogs($this);
    }

    public function getServerConnection()
    {
        if (!isset($this->serverConnection))
            $this->serverConnection = new mta('mta.unitedgaming.org', 22003, 'website', '209572079502AHIAWPGHAWPGH');
        return $this->serverConnection;
    }

    public function sendRemoteCommand($res, $func)
    {
        if (!isset($this->serverConnection))
            $this->getServerConnection();

        $val = array();
        for ( $i = 2; $i < func_num_args(); $i++ )
        {
            $val[$i-2] = func_get_arg($i);
            }
        return $this->serverConnection->callFunction ( $res, $func, $val );
    }

    public function getVehicleByID( $vehicleID )
    {
        return new MTAConnectorVehicle( $this, $vehicleID );
    }

    public function getInteriorByID( $interiorID )
    {
        return new MTAConnectorInterior( $this, $interiorID );
    }

}

class MTAConnectorInterior
{
    private $databaseConnection;
    private $parentClass;

    private $details = array();

    function __construct( $parentClass, $interiorID )
    {
        $this->parentClass = $parentClass;
        $this->databaseConnection = $parentClass->databaseConnection;

        $fetchInteriorDetailsQuery = $this->databaseConnection->prepare("SELECT `id`, `x`, `y`, `z`, `type`, `owner`, `locked`, `cost`, `name`, `interior`, `interiorx`, `interiory`, `interiorz`, `dimensionwithin`, `interiorwithin`, `angle`, `angleexit`, `supplies`, `safepositionX`, `safepositionY`, `safepositionZ`, `safepositionRZ`, `fee`, `disabled`, `lastused` FROM `interiors` WHERE `id`=?");
        if (!$fetchInteriorDetailsQuery)
            return false;

        $fetchInteriorDetailsQuery->bind_param("i", $interiorID);
        $fetchInteriorDetailsQuery->execute();
        $fetchInteriorDetailsQuery->store_result();
        if ($fetchInteriorDetailsQuery->num_rows == 0)
        {
            $fetchInteriorDetailsQuery->close();
            return false;
        }
        else {
            $fetchInteriorDetailsQuery->bind_result($id, $x, $y, $z, $type, $owner, $locked, $cost, $name, $interior, $interiorx, $interiory, $interiorz, $dimensionwithin, $interiorwithin, $angle, $angleexit, $supplies, $safepositionX, $safepositionY, $safepositionZ, $safepositionRZ, $fee, $disabled, $lastused);
            $fetchInteriorDetailsQuery->fetch();

            $this->details['id'] = $id;
            $this->details['x'] = $x;
                        $this->details['y'] = $y;
                        $this->details['z'] = $z;
                        $this->details['type'] = $type;
                        $this->details['owner'] = $owner;
                        $this->details['locked'] = $locked;
                        $this->details['cost'] = $cost;
                        $this->details['name'] = $name;
                        $this->details['interior'] = $interior;
                        $this->details['interiorx'] = $interiorx;
                        $this->details['interiory'] = $interiory;
                        $this->details['interiorz'] = $interiorz;
                        $this->details['dimensionwithin'] = $dimensionwithin;
                        $this->details['interiorwithin'] = $interiorwithin;
                        $this->details['angle'] = $angle;
                        $this->details['angleexit'] = $angleexit;
                        $this->details['supplies'] = $supplies;
                        $this->details['safepositionX'] = $safepositionX;
                        $this->details['safepositionY'] = $safepositionY;
                        $this->details['safepositionZ'] = $safepostitionZ;
                        $this->details['safepositionRZ'] = $safepositionRZ;
                        $this->details['fee'] = $fee;
                        $this->details['disabled'] = $disabled;
                        $this->details['lastused'] = $lastused;

            $fetchInteriorDetailsQuery->close();
            $this->parentClass->addCache_Interior($this);
        }
    }

        public function getDetail( $detailname = '-1')
        {
                if ($detailname == '-1')
                        return $this->details;

                if (isset($this->details[$detailname]))
                        return $this->details[$detailname];

                return false;
        }

        public function setDetail ($detailname, $detailvalue)
        {
                if (!isset($this->details[$detailname]))
                        return false; // See if its an existing value

                if ($detailname == 'id')
                        return false; // Protected variables

                $updateDetailQuery = $this->databaseConnection->prepare("UPDATE `interiors` SET `".$detailname."`=? WHERE `id`=?");
                $updateDetailQuery->bind_param("si", $detailvalue, $this->details['id']);
                if (!$updateDetailQuery->execute())
                {
                        $updateDetailQuery->close();
                        return false;
                }
                $updateDetailQuery->close();
                $this->details[$detailname] = $detailvalue;
                return true;
        }

        public function deleteKeys()
        {
                if (isset($this->detail['id']) and strlen($this->detail['id']) > 0)
                {
                        $this->parentClass->sendRemoteCommand("mtavg", "deleteItem", 4, $this->detail['id']);
            $this->parentClass->sendRemoteCommand("mtavg", "deleteItem", 5, $this->detail['id']);
                        return true;
                }
        }

    public function removeTemporaryMapping()
    {
        $removeTemporaryQuery = $this->databaseConnection->prepare("DELETE FROM `tempobjects` WHERE `dimension` = ?");
        $removeTemporaryQuery->bind_param("i", $this->details['id']);
        $removeTemporaryQuery->execute();
        $removeTemporaryQuery->close();

         $removeTemporaryQuery = $this->databaseConnection->prepare("DELETE FROM `tempinteriors` WHERE `id` = ?");
                $removeTemporaryQuery->bind_param("i", $this->details['id']);
                $removeTemporaryQuery->execute();
                $removeTemporaryQuery->close();

        return true;
    }

    private function convertMapToArray( $mapContents )
    {
        if (!isset($mapContents) or !$mapContents)
            return false;

        $xml = @simplexml_load_string($mapContents);
        if (!$xml)
            return false;

        $outputArrayObjects = array();
        foreach ($xml->object as $id => $value)
        {
            $tempArr = array();
            $tempArr['model'] = $value['model'];
            $tempArr['posX'] = $value['posX'];
            $tempArr['posY'] = $value['posY'];
            $tempArr['posZ'] = $value['posZ'];
            $tempArr['rotX'] = $value['rotX'];
            $tempArr['rotY'] = $value['rotY'];
            $tempArr['rotZ'] = $value['rotZ'];
            $tempArr['interior'] = $value['interior'];

            $tempArr['doublesided'] = 0;
            if (isset($value['doublesided']) and ($value['doublesided'] == 'true'))
                $tempArr['doublesided'] = 1;

            $tempArr['solid'] = 1;
            if (isset($value['solid']) and ($value['solid'] == 'false'))
                $tempArr['solid'] = 0;

            $outputArrayObjects[] = $tempArr;
        }

        $outputMarkerObjects = array();
        foreach ($xml->marker as $id => $value)
        {
            $tempArr = array();
            $tempArr['posX'] = $value['posX'];
            $tempArr['posY'] = $value['posY'];
            $tempArr['posZ'] = $value['posZ'];
            $tempArr['interior'] = $value['interior'];

            $outputMarkerObjects[] = $tempArr;
        }

        return array($outputArrayObjects, $outputMarkerObjects);

    }

    public function updateTemporaryMapping( $mapContents, $updateDB = true )
    {
        $this->removeTemporaryMapping();

        $convertOutput = $this->convertMapToArray( $mapContents );

        if (count($convertOutput[0]) == 0)
            return array(false, "No objects found in mapfile.");

        if (count($convertOutput[1]) != 1)
            return array(false, "The map should contain one entrance point as marker. This mapfile doesn't have one or multiple");

        if (count($convertOutput[0]) > 300)
                        return array(false, "You have exceeded the maximum of 300 objects.");

        foreach ($convertOutput[0] as $lineNumber => $lineDetails)
        {
            if ($lineDetails['posX'] > 3000 or $lineDetails['posX'] < -3000)
                return array(false, "This mapfile exceeds the world boundaries on the X axis.");
            if ($lineDetails['posY'] > 3000 or $lineDetails['posY'] < -3000)
                                return array(false, "This mapfile exceeds the world boundaries on the Y axis.");
                        if ($lineDetails['posZ'] > 3000 or $lineDetails['posZ'] < -3000)
                                return array(false, "This mapfile exceeds the world boundaries on the Z axis.");
            if ($lineDetails['interior'] == 0)
                return array(false, "This mapfile contains objects in interior 0, the `exterior`");
        }

        foreach ($convertOutput[1] as $lineNumber => $lineDetails)
                {
                        if ($lineDetails['posX'] > 3000 or $lineDetails['posX'] < -3000)
                                return array(false, "This mapfile exceeds the world boundaries on the X axis.");
                        if ($lineDetails['posY'] > 3000 or $lineDetails['posY'] < -3000)
                                return array(false, "This mapfile exceeds the world boundaries on the Y axis.");
                        if ($lineDetails['posZ'] > 3000 or $lineDetails['posZ'] < -3000)
                                return array(false, "This mapfile exceeds the world boundaries on the Z axis.");
                        if ($lineDetails['interior'] == 0)
                                return array(false, "This mapfile contains a marker in interior 0, the `exterior`");
                }

        // SQL it all in here!
        if ($updateDB)
        {
            $comment = 'import '.date("d-m-Y");
            $insertQuery = $this->databaseConnection->prepare("INSERT INTO `tempobjects` (`model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `doublesided`,`solid`, `comment`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
            foreach ($convertOutput[0] as $c => $d)
            {
                            $insertQuery->bind_param("iddddddiiiis", $d['model'], $d['posX'], $d['posY'], $d['posZ'], $d['rotX'], $d['rotY'], $d['rotZ'], $d['interior'], $this->details['id'], $d['doublesided'], $d['solid'], $comment);
                            $insertQuery->execute();
            }
            $insertQuery->close();

                    $insertQuery = $this->databaseConnection->prepare("INSERT INTO `tempinteriors` (`posX`, `posY`, `posZ`, `interior`, `id`) VALUES (?, ?, ?, ?, ?)");
                    foreach ($convertOutput[1] as $c => $d)
                    {
                            $insertQuery->bind_param("dddii", $d['posX'], $d['posY'], $d['posZ'], $d['interior'], $this->details['id']);
                            $insertQuery->execute();
                    }
                    $insertQuery->close();
        }
        return array(true, $convertOutput);
    }
}

class MTAConnectorVehicle
{
    private $databaseConnection;
    private $parentClass;

    private $details = array();

    function __construct( $parentClass, $vehicleID )
    {
        $this->parentClass = $parentClass;
        $this->databaseConnection = $parentClass->databaseConnection;

        $fetchVehicleDetailsQuery = $this->databaseConnection->prepare("SELECT `id`, `model`, `x`, `y`, `z`, `rotx`, `roty`, `rotz`, `currx`, `curry`, `currz`, `currrx`, `currry`, `currrz`, `fuel`, `engine`, `locked`, `lights`, `sirens`, `paintjob`, `hp`, `color1`, `color2`, `color3`, `color4`, `plate`, `faction`, `owner`, `job`, `tintedwindows`, `dimension`, `interior`, `currdimension`, `currinterior`, `enginebroke`, `items`, `itemvalues`, `Impounded`, `handbrake`, `safepositionX`, `safepositionY`, `safepositionZ`, `safepositionRZ`, `upgrades`, `wheelStates`, `panelStates`, `doorStates`, `odometer`, `headlights`, `variant1`, `variant2`, `description`, `description_a` FROM `vehicles` WHERE `id`=?");
                if (!$fetchVehicleDetailsQuery)
                        return false;

                $fetchVehicleDetailsQuery->bind_param("i", $vehicleID);
                $fetchVehicleDetailsQuery->execute();
                $fetchVehicleDetailsQuery->store_result();
                if ($fetchVehicleDetailsQuery->num_rows == 0)
                {
                        $fetchVehicleDetailsQuery->close();
                        return false;
                }
                else
                {
                        $fetchVehicleDetailsQuery->bind_result($id, $model, $x, $y, $z, $rotx, $roty, $rotz, $currx, $curry, $currz, $currrx, $currry, $currrz, $fuel, $engine, $locked, $lights, $sirens, $paintjob, $hp, $color1, $color2, $color3, $color4, $plate, $faction, $owner, $job, $tintedwindows, $dimension, $interior, $currdimension, $currinterior, $enginebroke, $items, $itemvalues, $Impounded, $handbrake,  $safepositionX, $safepositionY, $safepositionZ, $safepostitionRZ, $upgrades, $wheelStates, $panelStates, $doorStates, $odometer, $headlights, $variant1, $variant2, $description, $description_a);
                        $fetchVehicleDetailsQuery->fetch();

                        $this->details['id'] = $id;
                        $this->details['model'] = $model;
                        $this->details['x'] = $x;
                        $this->details['y'] = $y;
                        $this->details['z'] = $z;
                        $this->details['rotx'] = $rotx;
                        $this->details['roty'] = $roty;
                        $this->details['rotz'] = $rotz;
                        $this->details['currx'] = $currx;
                        $this->details['curry'] = $curry;
                        $this->details['currz'] = $currz;
                        $this->details['currrx'] = $currrx;
                        $this->details['currry'] = $currry;
                        $this->details['currrz'] = $currrz;
                        $this->details['fuel'] = $fuel;
                        $this->details['engine'] = $engine;
                        $this->details['locked'] = $locked;
                        $this->details['lights'] = $lights;
                        $this->details['sirens'] = $sirens;
                        $this->details['paintjob'] = $paintjob;
                        $this->details['hp'] = $hp;
                        $this->details['color1'] = $color1;
                        $this->details['color2'] = $color2;
                        $this->details['color3'] = $color3;
                        $this->details['color4'] = $color4;
                        $this->details['plate'] = $plate;
                        $this->details['faction'] = $faction;
                        $this->details['owner'] = $owner;
                        $this->details['job'] = $job;
                        $this->details['tintedwindows'] = $tintedwindows;
                        $this->details['dimension'] = $dimension;
                        $this->details['interior'] = $interior;
                        $this->details['currdimension'] = $currdimension;
                        $this->details['currinterior'] = $currinterior;
                        $this->details['enginebroke'] = $enginebroke;
                        $this->details['Impounded'] = $Impounded;
                        $this->details['handbrake'] = $handbrake;
                        $this->details['safepositionX'] = $safepositionX;
                        $this->details['safepositionY'] = $safepositionY;
                        $this->details['safepositionZ'] = $safepositionZ;
                        $this->details['safepositionRZ'] = $safepositionRZ;
                        $this->details['upgrades'] = $upgrades;
                        $this->details['wheelStates'] = $wheelStates;
                        $this->details['panelStates'] = $panelStates;
                        $this->details['doorStates'] = $doorStates;
                        $this->details['odometer'] = $odometer;
                        $this->details['headlights'] = $headlights;
                        $this->details['variant1'] = $variant1;
                        $this->details['variant2'] = $variant2;
                        $this->details['description'] = $description;
                        $this->details['description_a'] = $description_a;

            $fetchVehicleDetailsQuery->close();
            $this->parentClass->addCache_Vehicle($this);
                }
    }

    public function getDetail( $detailname = '-1')
    {
        if ($detailname == '-1')
            return $this->details;

        if (isset($this->details[$detailname]))
            return $this->details[$detailname];

        return false;
    }

        public function setDetail ($detailname, $detailvalue)
        {
                if (!isset($this->details[$detailname]))
                        return false; // See if its an existing value

                if ($detailname == 'id')
                        return false; // Protected variables

                $updateDetailQuery = $this->databaseConnection->prepare("UPDATE `vehicles` SET `".$detailname."`=? WHERE `id`=?");
                $updateDetailQuery->bind_param("si", $detailvalue, $this->details['id']);
                if (!$updateDetailQuery->execute())
                {
                        $updateDetailQuery->close();
                        return false;
                }
                $updateDetailQuery->close();
                $this->details[$detailname] = $detailvalue;
                return true;
        }

    public function deleteKeys()
    {
        if (isset($this->detail['id']) and strlen($this->detail['id']) > 0)
        {
            $this->parentClass->sendRemoteCommand("mtavg", "deleteItem", 3, $this->detail['id']);
            return true;
        }
    }
}

class MTAConnectorLogs
{
    private $databaseConnection;
    private $parentClass;

    private $elementdepth = 'all';
    private $searchelements = array();
    private $searchtext = array();
    private $selectedtypes;
    private $timespan = '24';
    private $limit = 2000;
    function __construct($parentClass)
    {
        if (!$parentClass)
            return false;
        $this->parentClass = $parentClass;
        $this->databaseConnection = $parentClass->databaseConnection;
        return true;
    }

    public function add($source, $actionID, $affected, $content)
    {
        if (is_array($affected))
        {
            $newstr =  '';
            foreach ($affected as $index => $value)
                $newstr .= $value.';';
            $affected = $newstr;
        }

        $queryResult = $this->databaseConnection->prepare("INSERT INTO `logtable` (`time`, `action`, `source`, `affected`, `content`) VALUES (now(), ?, ?, ? ,?)");
        if ($queryResult)
        {
            $queryResult->bind_param("isss", $actionID, $source, $affected, $content);
            $queryResult->execute();
            $queryResult->close();
            return true;
        }
        return false;
    }

    function execute()
    {
        $queryadd = 'SELECT `time` - INTERVAL 1 hour as \'time\', `action`, `source`, `affected`, `content` FROM `logtable` WHERE ';

        if (count($this->searchelements) > 0)
        {
            $queryadd .= '(';
            foreach ($this->searchelements as $element)
            {
                $queryadd .= '(';
                if ($elementdepth != 'affected') // source, all and allr
                    $queryadd .= "`source`='".$this->databaseConnection->real_escape_string($element)."' OR ";
                if ($elementdepth != 'source') //  affected, all and allr
                    $queryadd .= "`affected` LIKE '%".$this->databaseConnection->real_escape_string($element).";%'";
                if ($elementdepth == 'allr') $queryadd .= ') AND ';
                else $queryadd .= ')  OR ';
            }
            $queryadd = substr($queryadd, 0, -5).') AND ';
        }

        if  (count($this->searchtext) > 0)
        {
            $queryadd .= '(';
            foreach ($this->searchtext as $string)
            {
                $queryadd .= "`content` LIKE '%".$this->databaseConnection->real_escape_string($string)."%' OR ";
            }
            $queryadd = substr($queryadd, 0, -4).') AND ';
        }
        if  (count($this->selectedtypes) > 0)
        {
            $queryadd .= '(';
            foreach ($this->selectedtypes as $type)
            {
                $queryadd .= "`action`='".$this->databaseConnection->real_escape_string($type)."' OR ";
            }
            $queryadd = substr($queryadd, 0, -4).') AND ';
        }

        $queryadd .= '`time` > now() - INTERVAL '.$this->timespan.' HOUR ORDER BY `time` ASC LIMIT '.$this->limit.' ';
        $result = array();

        $queryResult = $this->databaseConnection->query($queryadd);
        if ($queryResult)
        {
            while ($row = $queryResult->fetch_assoc()) {
                $result[] = $row;
                }
        }
        return $result;
    }

    function setHours( $value )
    {
        if (!$value or !is_numeric($value))
            return false;
        $this->timespan = $value;
    }

    function setDays( $value )
    {
        $this->setHours( $value * 24 );
    }

    function setElementDepth( $type = 'all' )
    {
        if ($type != 'all' AND $type != 'source' AND $type != 'affected' and $type != 'allr')
            return false;
        $this->elementdepth = $type;
        return true;
    }

    function includeAccount($userDetails, $charactersToo = true)
    {
                if (!$userDetails)
                        return false;
        if ($charactersToo)
        {
            $accountCharacters = $userDetails->getCharacters();
            foreach($accountCharacters as $characterID => $characterName)
            {
                $this->searchelements[] = 'ch'.$characterID;
            }
        }

        $this->searchelements[] = 'ac'.$userDetails->getDetail('id');
        return true;
    }

    function includeCharacter($characterDetails, $accountToo = true)
    {
        if (!$characterDetails)
            return false;

        $this->searchelements[] = 'ch'.$characterDetails->getDetail('id');

        if ($accountToo)
            $this->searchelements[] = 'ac'.$characterDetails->getDetail('account');

        return true;
    }

     function includeInterior($interiorID)
        {
                if (!$interiorID)
                        return false;

                $this->searchelements[] = 'in'.$interiorID;
                return true;
        }


    function includeVehicle($vehicleID)
    {
        if (!$vehicleID)
            return false;

        $this->searchelements[] = 've'.$vehicleID;
        return true;
    }

        function includePhone($phoneNumber)
        {
                if (!$phoneNumber)
                        return false;

                $this->searchelements[] = 'ph'.$phoneNumber;
                return true;
        }


    function includeLogtype($logType)
    {
        if (!$logType)
            return false;

        $this->selectedtypes[] = $logType;
        return true;
    }

    function includeTextSearch($string)
    {
        if (!$string or strlen($string) < 3)
            return false;

        $this->searchtext[] = $string;
        return true;
    }
}

class MTAConnectorFaction
{
    private $databaseConnection;
    private $parentClass;
    private $factionID;
    private $ranks = array();
    private $wages = array();
    private $details = array();

    function __construct( $parentClass, $factionID )
    {
        $this->databaseConnection = $parentClass->databaseConnection;
        $this->parentClass = $parentClass;
        $this->factionID = $factionID;

        $fetchFactionDetailsQuery = $this->databaseConnection->prepare("SELECT `id`, `name`, `bankbalance`, `type`, `rank_1`, `rank_2`, `rank_3`, `rank_4`, `rank_5`, `rank_6`, `rank_7`, `rank_8`, `rank_9`, `rank_10`, `rank_11`, `rank_12`, `rank_13`, `rank_14`, `rank_15`, `rank_16`, `rank_17`, `rank_18`, `rank_19`, `rank_20`,`wage_1`, `wage_2`, `wage_3`, `wage_4`, `wage_5`, `wage_6`, `wage_7`, `wage_8`, `wage_9`, `wage_10`, `wage_11`, `wage_12`, `wage_13`, `wage_14`, `wage_15`, `wage_16`, `wage_17`, `wage_18`, `wage_19`, `wage_20` FROM `factions` WHERE `id`=?");
        if (!$fetchFactionDetailsQuery)
            return false;

        $fetchFactionDetailsQuery->bind_param("i", $factionID);
        $fetchFactionDetailsQuery->execute();
        $fetchFactionDetailsQuery->store_result();
        if ($fetchFactionDetailsQuery->num_rows == 0)
        {
            $fetchFactionDetailsQuery->close();
            return false;
        }
        else
        {
            $fetchFactionDetailsQuery->bind_result($id, $name, $bankbalance, $type, $rank_1, $rank_2, $rank_3, $rank_4, $rank_5, $rank_6, $rank_7, $rank_8, $rank_9, $rank_10, $rank_11, $rank_12, $rank_13, $rank_14, $rank_15, $rank_16, $rank_17, $rank_18, $rank_19, $rank_20, $wage_1, $wage_2, $wage_3, $wage_4, $wage_5, $wage_6, $wage_7, $wage_8, $wage_9, $wage_10, $wage_11, $wage_12, $wage_13, $wage_14, $wage_15, $wage_16, $wage_17, $wage_18, $wage_19, $wage_20);

            $fetchFactionDetailsQuery->fetch();

            $this->details["id"] = $id;
            $this->details["name"] = $name;
            $this->details["bankbalance"] = $bankbalance;
            $this->details["type"] = $type;
            $this->ranks[1] = $rank_1;
            $this->ranks[2] = $rank_2;
            $this->ranks[3] = $rank_3;
            $this->ranks[4] = $rank_4;
            $this->ranks[5] = $rank_5;
            $this->ranks[6] = $rank_6;
            $this->ranks[7] = $rank_7;
            $this->ranks[8] = $rank_8;
            $this->ranks[9] = $rank_9;
            $this->ranks[10] = $rank_10;
            $this->ranks[11] = $rank_11;
            $this->ranks[12] = $rank_12;
            $this->ranks[13] = $rank_13;
            $this->ranks[14] = $rank_14;
            $this->ranks[15] = $rank_15;
            $this->ranks[16] = $rank_16;
            $this->ranks[17] = $rank_17;
            $this->ranks[18] = $rank_18;
            $this->ranks[19] = $rank_19;
            $this->ranks[20] = $rank_20;
            $this->wages[1] = $wage_1;
            $this->wages[2] = $wage_2;
            $this->wages[3] = $wage_3;
            $this->wages[4] = $wage_4;
            $this->wages[5] = $wage_5;
            $this->wages[6] = $wage_6;
            $this->wages[7] = $wage_7;
            $this->wages[8] = $wage_8;
            $this->wages[9] = $wage_9;
            $this->wages[10] = $wage_10;
            $this->wages[11] = $wage_11;
            $this->wages[12] = $wage_12;
            $this->wages[13] = $wage_13;
            $this->wages[14] = $wage_14;
            $this->wages[15] = $wage_15;
            $this->wages[16] = $wage_16;
            $this->wages[17] = $wage_17;
            $this->wages[18] = $wage_18;
            $this->wages[19] = $wage_19;
            $this->wages[20] = $wage_20;
            $fetchFactionDetailsQuery->close();
                        $this->parentClass->addCache_Faction($this);
                        return true;

        }
    }

    public function getDetail( $detailname = -1 )
        {
                if ($detailname == -1)
                        return $this->details;
                if (isset($this->details[$detailname]))
                        return $this->details[$detailname];
                return false;
        }

    public function getRank( $rankid = -1 )
        {
                if ($rankid == -1)
                        return $this->ranks;
                if (isset($this->ranks[$rankid]))
                        return $this->ranks[$rankid];
                return false;
        }

        public function getRankWage( $rankid = -1 )
        {
                if ($rankid == -1)
                        return $this->wages;
                if (isset($this->wages[$rankid]))
                        return $this->wages[$rankid];
                return false;
        }


}

class MTAConnectorCharacter
{
    private $databaseConnection;
    private $parentClass;
    private $characterID;
    private $details = array();

    function __construct( $parentClass, $characterID )
    {
        $this->databaseConnection = $parentClass->databaseConnection;
        $this->parentClass = $parentClass;
        $this->characterID = $characterID;
        $fetchCharacterQuery = $this->databaseConnection->prepare("SELECT `z`,`y`,`x`,`weight`,`truckingwage`,`truckingruns`,`timeinserver`,`tag`,`skincolor`,`skin`,`rotation`,`restrainedobj`,`restrainedby`,`photos`,`pdjail_time`,`pdjail_station`,`pdjail`,`money`,`maxvehicles`,`marriedto`,`lastlogin`,`lastarea`,`lang3skill`,`lang3`,`lang2skill`,`lang2`,`lang1skill`,`lang1`, `jobcontract`,`job`,`interior_id`,`id`,`hoursplayed`,`height`,`health`,`gun_license`,`gender`,`fish`,`fingerprint`,`fightstyle`,`faction_rank`,`faction_perks`,`faction_leader`,`faction_id`,`dutyskin`,`duty`,`dimension_id`,`description`,`deaths`,`currlang`,`cuffed`,`creationdate`,`cked`,`ck_info`,`charactername`,`casualskin`,`car_license`,`blindfold`,`bankmoney`,`armor`,`alcohollevel`,`age`,`active`,`account` FROM `characters` WHERE `id`=?");
        if (!$fetchCharacterQuery)
            return false;
        $fetchCharacterQuery->bind_param("i", $characterID);
        $fetchCharacterQuery->execute();
        $fetchCharacterQuery->store_result();
        if ($fetchCharacterQuery->num_rows == 0)
        {
            $fetchCharacterQuery->close();
            return false;
        }
        else
                {
            $fetchCharacterQuery->bind_result($z, $y, $x, $weight, $truckingwage, $truckingruns, $timeinserver, $tag, $skincolor, $skin, $rotation, $restrainedobj, $restrainedby, $photos, $pdjail_time, $pdjail_station, $pdjail, $money, $maxvehicles, $marriedto, $lastlogin, $lastarea, $lang3skill, $lang3, $lang2skill, $lang2, $lang1skill, $lang1, $jobcontract, $job, $interior_id, $id, $hoursplayed, $height, $health, $gun_license, $gender, $fish, $fingerprint, $fightstyle, $faction_rank, $faction_perks, $faction_leader, $faction_id, $dutyskin, $duty, $dimension_id, $description, $deaths, $currlang, $cuffed, $creationdate, $cked, $ck_info, $charactername, $casualskin, $car_license, $blindfold, $bankmoney, $armor, $alcohollevel, $age, $active, $account);

            $row = $fetchCharacterQuery->fetch();
            $this->details['z'] = $z;
                        $this->details['y'] = $y;
                        $this->details['x'] = $x;
                        $this->details['weight'] = $weight;
                        $this->details['truckingwage'] = $truckingwage;
                        $this->details['truckingruns'] = $truckingruns;
                        $this->details['timeinserver'] = $timeinserver;
                        $this->details['tag'] = $tag;
                        $this->details['skincolor'] = $skincolor;
                        $this->details['skin'] = $skin;
                        $this->details['rotation'] = $rotation;
                        $this->details['restainedobj'] = $restainedobj;
                        $this->details['restainedby'] = $restainedby;
                        $this->details['photos'] = $photos;
                        $this->details['pdjail_time'] = $pdjail_time;
                        $this->details['pdjail_station'] = $pdjail_station;
                        $this->details['pdjail'] = $pdjail;
                        $this->details['money'] = $money;
                        $this->details['maxvehicles'] = $maxvehicles;
                        $this->details['marriedto'] = $marriedto;
                        $this->details['lastlogin'] = $lastlogin;
                        $this->details['lastarea'] = $lastarea;
                        $this->details['lang3skill'] = $lang3skill;
                        $this->details['lang3'] = $lang3;
                        $this->details['lang2skill'] = $lang2skill;
                        $this->details['lang2'] = $lang2;
                        $this->details['lang1skill'] = $lang1skill;
                        $this->details['lang1'] = $lang1;
                        $this->details['jobcontract'] = $jobcontract;
                        $this->details['job'] = $job;
                        $this->details['interior_id'] = $interior_id;
                        $this->details['id'] = $id;
                        $this->details['hoursplayed'] = $hoursplayed;
                        $this->details['height'] = $height;
                        $this->details['health'] = $health;
                        $this->details['gun_license'] = $gun_license;
                        $this->details['gender'] = $gender;
                        $this->details['fish'] = $fish;
                        $this->details['fingerprint'] = $fingerprint;
                        $this->details['fightstyle'] = $fightstyle;
                        $this->details['faction_rank'] = $faction_rank;
                        $this->details['faction_perks'] = $faction_perks;
                        $this->details['faction_leader'] = $faction_leader;
                        $this->details['faction_id'] = $faction_id;
                        $this->details['dutyskin'] = $dutyskin;
                        $this->details['duty'] = $duty;
                        $this->details['dimension_id'] = $dimension_id;
                        $this->details['description'] = $description;
                        $this->details['deaths'] = $deaths;
                        $this->details['currlang'] = $currlang;
                        $this->details['cuffed'] = $cuffed;
                        $this->details['creationdate'] = $creationdate;
                        $this->details['cked'] = $cked;
                        $this->details['ck_info'] = $ck_info;
                        $this->details['charactername'] = $charactername;
                        $this->details['casualskin'] = $casualskin;
                        $this->details['car_license'] = $car_license;
                        $this->details['blindfold'] = $blindfold;
                        $this->details['bankmoney'] = $bankmoney;
                        $this->details['armor'] = $armor;
                        $this->details['alcohollevel'] = $alcohollevel;
                        $this->details['age'] = $age;
                        $this->details['active'] = $active;
                        $this->details['account'] = $account;

                        $fetchCharacterQuery->close();
                        $this->parentClass->addCache_Character($this);
                        return true;
        }


    }

    public function giveItem( $itemID, $itemValue )
    {
        $insertItemQuery = $this->databaseConnection->prepare("INSERT INTO `items` (`type`, `owner`, `itemID`, `itemValue`) VALUES (1, ?, ?, ?)");
        $insertItemQuery ->bind_param("iis", $this->details['id'], $itemID, $itemValue);
        if (!$insertItemQuery->execute())
                {
                        $insertItemQuery->close();
                        return false;
                }
        $insertItemQuery->close();
        return true;
    }

        public function getDetail( $detailname = -1 )
        {
                if ($detailname == -1)
                        return $this->details;
                if (isset($this->details[$detailname]))
                        return $this->details[$detailname];
                return false;
        }

        public function setDetail ($detailname, $detailvalue)
        {
                if (!isset($this->details[$detailname]))
                        return false; // See if its an existing value

                if ($detailname == 'id' or $detailname == 'account')
                        return false; // Protected variables

                $updateDetailQuery = $this->databaseConnection->prepare("UPDATE `characters` SET `".$detailname."`=? WHERE `id`=?");
                $updateDetailQuery->bind_param("si", $detailvalue, $this->details['id']);
                if (!$updateDetailQuery->execute())
                {
                        $updateDetailQuery->close();
                        return false;
                }
                $updateDetailQuery->close();
                $this->details[$detailname] = $detailvalue;
                return true;
        }

    public function getVehicles()
        {
                $output = array();
                $fetchVehiclesQuery = $this->databaseConnection->prepare("SELECT `id`,`model` from `vehicles` where `owner`=?");
                $fetchVehiclesQuery->bind_param("i", $this->characterID);
                $fetchVehiclesQuery->execute();
                $fetchVehiclesQuery->bind_result($vehicleID, $vehicleModel);
                while ($fetchVehiclesQuery->fetch())
                        $output[ $vehicleID ] = $vehicleModel;
        $fetchVehiclesQuery->close();
                return $output;
        }

    public function getInteriors()
    {
        $output = array();
        $fetchInteriorsQuery = $this->databaseConnection->prepare("SELECT `id`,`name` FROM `interiors` WHERE `owner`=?");
        $fetchInteriorsQuery->bind_param("i", $this->characterID);
        $fetchInteriorsQuery->execute();
        $fetchInteriorsQuery->bind_result($interiorID, $interiorName);
        while ($fetchInteriorsQuery->fetch())
            $output[ $interiorID ] = $interiorName;
        $fetchInteriorsQuery->close();
        return $output; 
    }


}

class MTAConnectorPlayer
{
    private $databaseConnection;
    private $parentClass;
    private $userID;
    private $details = array();

    function __construct( $parentClass, $userID )
    {
        $this->databaseConnection = $parentClass->databaseConnection;
        $this->parentClass = $parentClass;
        $this->userID = $userID;
        $fetchPlayerQuery = $this->databaseConnection->prepare("SELECT `id`,`username`,`appstate`,`mtaserial`,`credits`,`transfers`, `ip`, `banned`, `banned_by`, `banned_reason` FROM `accounts` WHERE `id`=?");
                if (!$fetchPlayerQuery)
                {
                        return false;
                }
                $fetchPlayerQuery->bind_param("i", $userID);
                $fetchPlayerQuery->execute();
                $fetchPlayerQuery->store_result();
                if ($fetchPlayerQuery->num_rows == 0)
                {
            $fetchPlayerQuery->close();
                return false;
                }
        else
                {
                        $fetchPlayerQuery->bind_result($dbUserID, $dbUsername, $dbAppstate, $dbMTASerial, $dbvPoints, $dbTransfers, $dbIP, $dbBanned, $dbBannedBy, $dbBannedReason);
                        $fetchPlayerQuery->fetch();

            $this->details['id'] = $dbUserID;
            $this->details['username'] = $dbUsername;
            $this->details['appstate'] = $dbAppState;
            $this->details['mtaserial'] = $dbMTASerial;
            $this->details['credits'] = $dbvPoints;
            $this->details['transfers'] = $dbTransfers;
            $this->details['ip'] = $dbIP;
            $this->details['banned'] = $dbBanned;
            $this->details['banned_by'] = $dbBannedBy;
            $this->details['banned_reason'] = $dbBannedReason;
            $fetchPlayerQuery->close();
            $this->parentClass->addCache_Player($this);
                        return true;
                }
    }

    public function getCharacters()
    {
        $output = array();
        $fetchCharactersQuery = $this->databaseConnection->prepare("SELECT `id`,`charactername` from `characters` where `account`=?");
        $fetchCharactersQuery->bind_param("i", $this->userID);
        $fetchCharactersQuery->execute();
        $fetchCharactersQuery->bind_result($characterID, $characterName);
        while ($fetchCharactersQuery->fetch())
            $output[ $characterID ] = $characterName;
        $fetchCharactersQuery->close();
        return $output;
    }

    public function getDetail( $detailname = -1 )
    {
        if ($detailname == -1)
            return $this->details;
        if (isset($this->details[$detailname]))
            return $this->details[$detailname];
        return false;
    }

    public function setDetail ($detailname, $detailvalue)
    {
        if (!isset($this->details[$detailname]) and $detailname != "password" and $detailname != "salt")
            return false; // See if its an existing value

        if ($detailname == 'id' or $detailname == 'mtaserial')
            return false; // Protected variables

        $updateDetailQuery = $this->databaseConnection->prepare("UPDATE `accounts` SET `".$detailname."`=? WHERE `id`=?");
        $updateDetailQuery->bind_param("si", $detailvalue, $this->details['id']);
        if (!$updateDetailQuery->execute())
        {
            $updateDetailQuery->close();
            return false;
        }
        $updateDetailQuery->close();
        $this->details[$detailname] = $detailvalue;
        return true;
    }
}