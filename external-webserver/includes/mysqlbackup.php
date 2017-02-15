<?php
/*
<!-- $Id: mysqlbackup.php 873 2012-05-24 01:03:17Z  $ -->

Paul M - Auto-Backup for vBulletin 4.2
Adapted from the original 3.0.x version by Trigunflame.
*/

define ('NO_ERRORS',1);
define ('DB_OPTIONS',2);
define ('DUMP_ERROR',3);

Class errorHandler
{
	var $STATUS;
	var $MESSAGES;
	
	// Load Codes
	function loadCodes()
	{
		$elapsed = $this->elapsed;
		$this->MESSAGES = array(
			NO_ERRORS 		=> 'Backup Completed Successfully',
			DB_OPTIONS 		=> 'Backup Aborted : vBulletin Options Error',
			DUMP_ERROR 		=> "Backup Error : \$details",
		);
	}

	// Error Handler
	function throwError($name,$details=false)
	{
		// Globalize
		global $nextitem;

		// Set Status
		eval("\$this->STATUS = \"".$this->MESSAGES[$name]."\";");
		echo $this->STATUS;
		// Unlock Tables
		if ($this->LOCK)
		{
			$this->MYSQL->query('UNLOCK TABLES;');
		}
		log_cron_action($this->STATUS, $nextitem);
		exit;
	}
}

Class mysqlBackup Extends errorHandler
{
	var $MYSQL;
	var $DATE;
	var $DUMP_PATH;
	var $LOCK = 0;
	var $REPAIR = 0;
	var $COMBINE = 1;
	var $GZIP = 0;
	var $INNODB = 0;
	var $OPTIONS;
	var $FULL_PATH;
	var $SHORT_PATH;
	var $ERROR_OUT;
	var $USEBLOCK = 0;
	var $BLOCKSIZE = 0;

	// Error Handler
	function throwError($name,$details=false)
	{
		parent::throwError($name,($details ? $details : 0));
	}

	// Create Selected File
	function createFile($file)
	{
		// Check Existance
		if (file_exists($file)) { return; }

		// Try Creation
		@fclose(@fopen($file,'w+'));
		@chmod($file, 0666);

		// Clear Cache
		clearstatcache();

		// Check Again
		if (file_exists($file)) { return; }

		// Commands
		@exec("echo > ".$file,$o,$e);
		@exec("chmod 0666 ".$file,$o,$e);
	}

	// Remove Selected File
	function removeFile($file)
	{
		// Check Existance
		if (!file_exists($file)) { return; }

		// Try Removing
		@unlink($file);

		// Clear Cache
		clearstatcache();

		// Check Again
		if (!file_exists($file)) { return; }

		// Command
		@exec("rm -f ".$file,$o,$e); 
	}

	// Recursively Remove Directory
	function removeDir($directory)
	{
		// Delete File
		if (is_file($directory)) { $this->removeFile($directory); }
 
		// Open Directory?
		if (!$dir = @dir($directory)) { return; }

		// Loop
		while (false !== $file = $dir->read())
		{
			if ($file == '.' || $file == '..') { continue; }
			$this->removeDir("$directory/$file");
		}
 
		// Finish
		$dir->close();
		@rmdir($directory);

		// Clear Cache
		clearstatcache();

		// Check Again
		if (!is_dir($directory)) { return; }

		// Command
		@exec("rm -rf ".$directory,$o,$e);
	}

	// Create Directory
	function createDir($directory)
	{
		// Check Existance
		if (is_dir($directory)) { return; }

		// Make Directory
		$mask = umask(0); 
		@mkdir($directory, 0777);
		umask($mask);

		// Clear Cache
		clearstatcache();

		// Check Again
		if (is_dir($directory)) { return; }

		// Command
		@exec("mkdir -m 0777 ".$directory,$o,$e);
	}

	// Repair & Optimize Tables
	function repairTables()
	{
		// Predefined Variables
		$tables  = array();
		$lock    = 'LOCK TABLES';

		// Get Table List
		$result = $this->MYSQL->query('SHOW tables');

		// Store Table List
		while ($table = $this->MYSQL->fetch_array($result,DBARRAY_NUM))
		{
			$tables[] = $table[0];
			$lock .= ' `'.$table[0].'` WRITE,';
		}

		// Remove Ending of LockList
		$lock = rtrim($lock,",").';';

		// Lock Tables
		if ($this->LOCK)
		{
			$this->MYSQL->query($lock);
		}

		// Loop Tables
		foreach ($tables AS $table)
		{
			$error = 0;
			$optimize = 1;

			// Check Table
			$check = $this->MYSQL->query("CHECK TABLE `$table`");
			while ($status = $this->MYSQL->fetch_array($check,DBARRAY_NUM))
			{
				// Status
				if ($status[2] == 'error')
				{
					if ($status[3] == 'The handler for the table doesn\'t support check/repair')
					{
						$optimize = 0;
					}
					else
					{
						$error = 1;
					}
				}
			}

			// Check Table Error
			if ($error)
			{
				// Repair Table
				$repair = $this->MYSQL->query_first("REPAIR TABLE `$table`");

				// Status
				if ($repair[3] != 'OK')
				{
					$error2 = 1;
				}
				else
				{
					$error2 = 0;
					$error = 0;
				}
			}

			// Check Optimize
			if (!$error && !$error2 && $optimize)
			{
				// Optimize Table
				$optimize = $this->MYSQL->query("OPTIMIZE TABLE `$table`");
				while ($status = $this->MYSQL->fetch_array($optimize,DBARRAY_NUM))
				{
					// Status
					if ($status[2] == 'error')
					{
						$error = 1;
					}
				}
			}
		}

		// Unlock Tables
		if ($this->LOCK)
		{
			$this->MYSQL->query('UNLOCK TABLES;');
		}
	}

	// PHP Based Dump
	function phpDump()
	{
		// Predefined Variables
		$tables  = array();
		$lock    = 'LOCK TABLES';

		// Store Table List
		foreach ($this->TABLES AS $table)
		{
			$tables[] = $table;
			$lock .= ' `'.$table.'` READ,';
		}

		// Remove Ending of LockList
		$lock = rtrim($lock,",").';';

		// Lock Tables
		if ($this->LOCK)
		{
			$this->MYSQL->query($lock);
		}

		if ($this->COMBINE)
		{
			$this->FILE = $this->FULL_PATH.'-Full-Backup.sql';
			$this->removeFile($this->FILE);
			if ($this->GZIP)
			{
				$this->removeFile($this->FILE.'.gz');
			}
			$this->createFile($this->FILE);
		}

		// Start Parsing Rows
		$elapsed = 0;
		foreach ($tables AS $table)
		{
			$x = explode(' ',microtime());
			$start = intval(substr($x[1],-4))+floatval($x[0]);

			// Create a New File
			if (!$this->COMBINE)
			{
				$this->FILE = $this->FULL_PATH.'-'.ucfirst($table).'.sql';
				$this->removeFile($this->FILE); // Just in case
				if ($this->GZIP)
				{
					$this->removeFile($this->FILE.'.gz');
				}
				$this->createFile($this->FILE);
			}

			// Open Output
			if (!$output = @fopen($this->FILE,'a'))
			{
				$this->throwError(DUMP_ERROR,'Could not write to destination file ( '.$this->FILE.' )');
			}

			// Set Write Buffer
			@stream_set_write_buffer($output, 0);

			// InnoDb Optimization
			if ($this->INNODB)
			{
				// Construct AutoCommit Off
				fwrite($output,"SET AUTOCOMMIT = 0;\n");

				// Construct Foreign Key Checks Off
				fwrite($output,"SET FOREIGN_KEY_CHECKS = 0;\n\n\n");
			}

			// Create Header
			$tableheader = $this->MYSQL->query_first("SHOW CREATE TABLE `$table`");
			$tableheader = "DROP TABLE IF EXISTS `$table`;\n".$tableheader['Create Table'].";\n\n";

			// Write Header
			fwrite($output,$tableheader);

			// Get Total Rows
			$total = $this->MYSQL->query_first("SELECT COUNT(*) AS count FROM `$table`");

			// Check Total & Skip
			if (intval($total['count']) == 0) { 
				echo "Processing $table (No Row Data)"; vbflush();

				// Close Output
				@fclose($output);

				if (!$this->COMBINE AND $this->GZIP)
				{
					echo " <i>[Compressing File]</i> <br />"; vbflush();
					@exec("gzip ".$this->FILE,$o,$e);
				}
				else
				{
					echo "<br />"; vbflush();
				}

				continue; 
			}
			else
			{
				$rowcount = $total['count'];
				echo "Processing $table ($rowcount) "; vbflush();
			}

			// MySQL4+ Optimizations, Construct Disable Keys
			fwrite($output,"/*!40000 ALTER TABLE `$table` DISABLE KEYS */;\n");

			$flag = 0;
			$rcount = 0;
			$records = 0;
			$process = $this->USEBLOCK;
			if ($process AND ($rowcount <= $this->BLOCKSIZE)) { $process = 0; }
			if ($process) { echo "<br/>"; vbflush(); }
			
			do
			{
				// Set Timeout
				@set_time_limit(0);

				// Get Rows
				if ($process)
				{
					$flag = 1;
					$rows = $this->MYSQL->query_read("SELECT * FROM `$table` LIMIT $records, {$this->BLOCKSIZE}", false);
				}
				else
				{
					$rows = $this->MYSQL->query_read("SELECT * FROM `$table`", false); // (False = Unbuffered Query)
				}

				// Fields
				$fields = $this->MYSQL->num_fields($rows);

				// Get Data Rows
				while ($row = $this->MYSQL->fetch_array($rows,DBARRAY_NUM))
				{
					$values = array();
					for ($i=0;$i<$fields;$i++)
					{
						// Check Data
						if (!isset($row[$i]) || is_null($row[$i]))
						{
   	                		$values[] = 'NULL';
						}
						else
						{
							$values[] = "'".$this->MYSQL->escape_string($row[$i])."'";
						}
					}
					$rcount++;
	
					// Construct Insert
					fwrite($output,"INSERT INTO `$table` VALUES (".implode(',',$values).");\n");
				}

				if ($process)
				{
					$records = $records + $this->BLOCKSIZE;
					if ($records >= $rowcount) { $process = 0; }
					if ($rcount < $rowcount) { echo "--- Processed $rcount Rows <br />"; vbflush(); }
				}
			}
			while ($process) ;


			// MySQL4+ Optimizations, Construct Enable Keys
			fwrite($output,"/*!40000 ALTER TABLE `$table` ENABLE KEYS */;\n\n");

			// InnoDb Optimization
			if ($this->INNODB)
			{
				// Construct AutoCommit On
				fwrite($output,"\n"."SET AUTOCOMMIT = 1;\n");

				// Construct Commit
				fwrite($output,"COMMIT;\n");

				// Construct Foreign Key Checks On
				fwrite($output,"SET FOREIGN_KEY_CHECKS = 1;\n\n\n");
			}

			// Close Output
			@fclose($output);

			// Free Memory
			$this->MYSQL->free_result($rows);

			if (!$this->COMBINE AND $this->GZIP)
			{
				echo " <i>[Compressing File]</i> "; vbflush();
				@exec("gzip ".$this->FILE,$o,$e);
			}

			$x = explode(' ',microtime());
			$finish = intval(substr($x[1],-4))+floatval($x[0]);
			$time = round($finish - $start,3);
			$elapsed = $elapsed + $time;

			if ($flag)
			{
				echo "&nbsp;#&nbsp; ";
			}
			else
			{
				echo ": ";
			}

			echo "Processed $rcount Rows in $time Seconds <br />"; vbflush();
		}

		// Unlock Tables
		if ($this->LOCK)
		{
			$this->MYSQL->query('UNLOCK TABLES;');
		}

		echo "<br />Processed Database in $elapsed seconds<br />"; vbflush();

		if ($this->COMBINE AND $this->GZIP)
		{
			$start = $finish; // For compression timing
			echo "<br /><i>[Compressing Combined File]</i> : "; vbflush();
			@exec("gzip ".$this->FILE,$o,$e);

			$x = explode(' ',microtime());
			$finish = intval(substr($x[1],-4))+floatval($x[0]);
			$time = round($finish - $start,3);
			$elapsed = $time;

			echo "Processed File Compression in $elapsed seconds<br />"; vbflush();
		}
	}
	
	/* ------------- Primary Initiation Methods ------------- */

	// Cron Based Automated Backup
	function cronBackup()
	{
		// Set Full Dump Path.
		if ($this->COMBINE)
		{
			// No folder if combined
			$this->FULL_PATH  = $this->DUMP_PATH.$this->PREFIX.$this->DATE;
		}
		else
		{
			// Add folder for multiple files.
			$this->SHORT_PATH = $this->DUMP_PATH.$this->DATE;
			$this->FULL_PATH  = $this->SHORT_PATH.'/'.$this->PREFIX.$this->DATE;

			// Remove previous files.
			$this->removeDir($this->SHORT_PATH);

			// Recreate folder.
			$this->createDir($this->SHORT_PATH);
		}

		// Clear Cache 
		clearstatcache();

		// Repair & Optimize.
		if ($this->REPAIR)
		{
			$this->repairTables();
		}

		// Start Initial Dump.
		$this->phpDump();
	}

	// Initiate Constructor
	function mysqlBackup(&$dbclass, &$vboptions)
	{
		// Load Error Codes
		parent::loadCodes();

		// Get Options
		$this->OPTIONS = &$vboptions;

		// Check if loaded OK 
		if (!is_array($this->OPTIONS) OR empty($this->OPTIONS))
		{
			$this->throwError(DB_OPTIONS);
		}

		// Set Default Status 
		$this->STATUS = $this->MESSAGES[NO_ERRORS];

		// Reference Database Object
		$this->MYSQL = &$dbclass;

		// File Saving Information 
		$this->DATE = date($this->OPTIONS['cbu_date']);
		$this->PREFIX = &$this->OPTIONS['cbu_prefix'];
		$this->DUMP_PATH = &$this->OPTIONS['cbu_path'];

		// Backup Method & Lock & Repair
		$this->LOCK = &$this->OPTIONS['cbu_lock'];
		$this->REPAIR = &$this->OPTIONS['cbu_repair'];

		// Backup Type & Tables & Combine 
		$this->TABLES = array();
		$this->COMBINE = &$this->OPTIONS['cbu_combine'];

		// Backup Optimizations 
		$this->GZIP = &$this->OPTIONS['cbu_gzip'];
		$this->INNODB = &$this->OPTIONS['cbu_innodb'];

		// Block Options 
		$this->USEBLOCK = &$this->OPTIONS['cbu_split'];
		$this->BLOCKSIZE = &$this->OPTIONS['cbu_blocksize'];

		// Get Tables List 
		$list = $this->MYSQL->query('SHOW tables');
		while ($table = $this->MYSQL->fetch_array($list,DBARRAY_NUM))
		{
			$this->TABLES[] = $table[0];
		}
	}
}

?>
