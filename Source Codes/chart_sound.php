<?php
  error_reporting(0);
  include 'config.php';
  include 'db.class.php';
  
	$DBConn = new MySQLDBConnection($dbhost, $dbname, $dbuser, $dbpw);
	$DBStmt = new MySQLStatement;
	
	$DBStmt->connection = $DBConn->connection;
	
	function getSoundData($DBStmt, $from, $to){
		$DBStmt->query = "SELECT * FROM `sounds` WHERE dDateTime BETWEEN '$from' and '$to'";
		$HasData = false;
		if ($DBStmt->execute()) {
			$str = "";
			while ($row = $DBStmt->fetch()){
				$time = date_format(date_create("{$row['dDateTime']}"),"H:i:s");
				$date = date_format(date_create("{$row['dDateTime']}"),"Y-m-d");
				if (!empty($str)) {
					$str = $str . ',';
				}
				//echo "xxx";
				$str = $str . "['".$time."', ".$row['iValue']."]";
				$HasData = true;
			}
		} else
			$str = "[]";
		echo $str;
		
		// free the results
		if ($HasData)
		  $DBStmt->free_result();
		
		// close the prepared statement
		$DBStmt->close();
		
		// disconnect 
		
	}

?>

<html><head><meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <script type="text/javascript" src="./fff_files/loader.js.download"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);


      function drawChart() {
		 
		 var arrdata = "<?php getSoundData($DBStmt, $_REQUEST['from'], $_REQUEST['to']);?>";
		 
		 if(arrdata.length > 0)
		 {
			//document.getElementById('curve_chart').innerHTML  = "With Data";
			var data = google.visualization.arrayToDataTable([
			  ['Date Time', ''],<?php getSoundData($DBStmt, $_REQUEST['from'], $_REQUEST['to']);?>
			]);
			var options = {
			  curveType: 'function',
			  legend: { position: 'bottom' }
			};
			var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));
			chart.draw(data, options);
		 }
		 else
		 {
			document.getElementById('curve_chart').innerHTML  = "<h2 style='color:red;'>No Data</h2>"; 
		 }
		 
		
    
		
      }
    </script><script type="text/javascript" charset="UTF-8" src="./fff_files/loader.js(1).download"></script>
  <link id="load-css-0" rel="stylesheet" type="text/css" href="./fff_files/tooltip.css"><link id="load-css-1" rel="stylesheet" type="text/css" href="./fff_files/util.css"><script type="text/javascript" charset="UTF-8" src="./fff_files/jsapi_compiled_format_module.js.download"></script><script type="text/javascript" charset="UTF-8" src="./fff_files/jsapi_compiled_default_module.js.download"></script><script type="text/javascript" charset="UTF-8" src="./fff_files/jsapi_compiled_ui_module.js.download"></script><script type="text/javascript" charset="UTF-8" src="./fff_files/jsapi_compiled_corechart_module.js.download"></script></head>
  <body style="background-image: url(img/slideshow/chart_sound.jpg);">
  <div align="center"/>
    <h1  style="color:green;">Sound Sensor <?php echo "'(".$_REQUEST['from'].'~'.$_REQUEST['to']. ")'";?></h1>
	<h1  style="color:green;">Sound Level</h1>
    <h2  style="color:green;">90-1000(Above Normal Level)</h2>
	<h2  style="color:green;">0-90(Normal Level)</h2>
    <div id="curve_chart" style="width: 100%; height: 100%"></div>

</body></html>