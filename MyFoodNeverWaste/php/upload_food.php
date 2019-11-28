<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$foodtitle = $_POST['foodtitle'];
$fooddesc = $_POST['fooddesc'];
$foodprice = $_POST['foodprice'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$encoded_string = $_POST["encoded_string"];
$credit = $_POST['credit'];
$rating = $_POST['rating'];
$decoded_string = base64_decode($encoded_string);
$mydate =  date('dmYhis');
$imagename = $mydate.'-'.$email;
$sqlinsert = "INSERT INTO food(FOODTITLE,FOODOWNER,FOODDESC,FOODPRICE,FOODIMAGE,LATITUDE,LONGITUDE,RATING) VALUES ('$foodtitle','$email','$fooddesc','$foodprice','$imagename','$latitude','$longitude','$rating')";
if ($credit>0){
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../images/'.$imagename.'.jpg';
        file_put_contents($path, $decoded_string);
        $newcredit = $credit - 1;
        $sqlcredit = "UPDATE user SET CREDIT = '$newcredit' WHERE EMAIL = '$email'";
        $conn->query($sqlcredit);
        echo "success";
    } else {
        echo "failed";
    }
}else{
    echo "low credit";
}
?>