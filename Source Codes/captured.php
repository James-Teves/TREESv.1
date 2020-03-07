<?php
  error_reporting(0);
  include 'config.php';
  include 'db.class.php';
  
	$DBConn = new MySQLDBConnection($dbhost, $dbname, $dbuser, $dbpw);
	$DBStmt = new MySQLStatement;
	
	$DBStmt->connection = $DBConn->connection;
	
	
?>
 
<html>
<head>
<style>
div.gallery {
  margin: 5px;
  border: 1px solid #ccc;
  float: left;
  width: 180px;
}

div.gallery:hover {
  border: 1px solid #777;
}

div.gallery img {
  width: 100%;
  height: auto;
}

div.desc {
  padding: 5px;
  text-align: center;
}
</style>
</head>
<body><center>

<?php 
	$dd = $_REQUEST['DATE'];
	$DBStmt->query = "SELECT * FROM `screenshot` WHERE DATE(dDatetime) = '$dd' ORDER BY camera_pos, dDatetime;";
	$ch1 = 0;
	$ch2 = 0;
	$ch3 = 0;
	if ($DBStmt->execute()) {
		while ($row = $DBStmt->fetch()){
			unset($f);
			$f['image'] = $row['sFilename']; 
			$f['date'] = $row['dDatetime']; 
			$f['esp'] = $row['esp_id'];
			$f['devNo'] = $row['device_id'];
			$data[$row['camera_pos']][] = $f;
			if ($row['camera_pos'] == 1)
				$ch1++;
			if ($row['camera_pos'] == 2)
				$ch2++;
			if ($row['camera_pos'] == 3)
				$ch3++;
		}
	}
	if ($ch1 >= $ch2 && $ch1 >= $ch3)
		$count = $ch1;
	else if ($ch2 >= $ch1 && $ch2 >= $ch3)
		$count = $ch3;
	else if ($ch3 >= $ch2 && $ch3 >= $ch1)
		$count = $ch3;

	for ($i = 0; $i<$count; $i++) {
              ?> 
		<div style="width:80%">
			<div class="gallery">
			  <a target="_blank" >
				<img onerror="this.src = 'blank.jpg'" src="screenshot/<?php  echo $data[1][$i]['image']; ?>" alt="Camera 1" width="200px" height="150px">
			  </a>
			  <div class="desc"><a>Device No.:</a><?php echo $data[1][$i]['devNo']; ?></div>
			  <div class="desc"><a>Camera No.:</a>1<br></div>
			  <div class="desc"><a>Date Time:</a><?php echo $data[1][$i]['date']; ?></div>
			  <div class="desc"><a>Filename:.</a><?php  echo $data[1][$i]['image']; ?><br></div>
			</div>
			
			<div class="gallery">
			  <a target="_blank" >
				<img onerror="this.src = 'blank.jpg'" src="screenshot/<?php  echo $data[2][$i]['image']; ?>" alt="Camera 2" width="200px" height="150px">
			  </a>
			  <div class="desc"><a>Device No.:</a><?php echo $data[1][$i]['devNo']; ?></div>
			  <div class="desc"><a>Camera No.:</a>2<br></div>
			  <div class="desc"><a>Date Time:</a><?php echo $data[2][$i]['date']; ?></div>
			  <div class="desc"><a>Filename:.</a><?php  echo $data[2][$i]['image']; ?><br></div>
			</div>
			
			<div class="gallery">
			  <a target="_blank" >
				<img onerror="this.src = 'blank.jpg'" src="screenshot/<?php  echo $data[3][$i]['image']; ?>" alt="Camera 3" width="200px" height="150px">
			  </a>
			  <div class="desc"><a>Device No.:</a><?php echo $data[1][$i]['devNo']; ?></div>
			  <div class="desc"><a>Camera No.:</a>3<br></div>
			  <div class="desc"><a>Date Time:</a><?php echo $data[3][$i]['date']; ?></div>
			  <div class="desc"><a>Filename:.</a><?php  echo $data[3][$i]['image']; ?><br></div>
			</div>
		</div>

                <?php
	}
?> 
</body>
</html>

<?php

	$DBStmt->close();
	
	// disconnect 
	$DBConn->disconnect();	
?>