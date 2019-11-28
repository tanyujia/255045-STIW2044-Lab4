<?php
error_reporting(0);
include_once("dbconnect.php");
$jobid = $_POST['foodid'];
$sql     = "DELETE FROM food WHERE foodid = $foodid";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }
$conn->close();
?>