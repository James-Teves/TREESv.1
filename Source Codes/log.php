<?php
  error_reporting(0);
  include 'config.php';
  include 'db.class.php';

	$did = $_REQUEST['did'];
	$snd = $_REQUEST['snd'];
	$smk = $_REQUEST['smk'];
    $tmp = $_REQUEST['tmp'];
	$volt = $_REQUEST['volt'];
	
    $datetime = DateTime::createFromFormat('Y-m-d H:i:s', date('Y-m-d H:i:s'));
    $datetime->modify('+7 hour');
    $DateTime = $datetime->format('Y,m,d H,i,s');
  
	$DBConn = new MySQLDBConnection($dbhost, $dbname, $dbuser, $dbpw);
	$DBStmt = new MySQLStatement;

	$DBStmt->connection = $DBConn->connection;
	
	if (isset($snd)){
		$DBStmt->query = "INSERT INTO `sounds` (iValue, device_id, dDateTime) VALUES ($snd, $did, STR_TO_DATE('$DateTime','%Y,%m,%d %H,%i,%s'))";
		if ($DBStmt->execute()) {
			echo 1;
		}	
	}
	
	if (isset($smk)){
		$DBStmt->query = "INSERT INTO `smokes` (iValue, device_id, dDateTime) VALUES ($smk, $did, STR_TO_DATE('$DateTime','%Y,%m,%d %H,%i,%s'))";
		if ($DBStmt->execute()) {
			echo 1;
		}
	}
	
	if (isset($tmp)){
		$DBStmt->query = "INSERT INTO `temperatures` (iValue, device_id, dDateTime) VALUES ($tmp, $did, STR_TO_DATE('$DateTime','%Y,%m,%d %H,%i,%s'))";
		if ($DBStmt->execute()) {
			echo 1;
		}	 
	}
	if (isset($scshot)){
		$DBStmt->query = "INSERT INTO `screenshot` (iValue, sFilename, dDateTime) VALUES ($scshot, $did, STR_TO_DATE('$DateTime','%Y,%m,%d %H,%i,%s'))";
		if ($DBStmt->execute()) {
			echo 1;
		}	 
	}
		if (isset($volt)){
		$DBStmt->query = "INSERT INTO `battery` (iValues, device_id, dDateTime) VALUES ($volt, $did, STR_TO_DATE('$DateTime','%Y,%m,%d %H,%i,%s'))";
		if ($DBStmt->execute()) {
			echo 1;
		}	
	}

	// free the results
	//$DBStmt->free_result();

	// close the prepared statement
	$DBStmt->close();
  
?>