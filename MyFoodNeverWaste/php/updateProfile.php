<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$radius = $_POST['radius'];
$usersql = "SELECT * FROM user WHERE EMAIL = '$email'";
if (isset($name) && (!empty($name))){
    $sql = "UPDATE user SET NAME = '$name' WHERE EMAIL = '$email'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE user SET PASSWORD = sha1($password) WHERE EMAIL = '$email'";
}
if (isset($radius)&& (!empty($radius))){
    $sql = "UPDATE user SET RADIUS = '$radius' WHERE EMAIL = '$email'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE user SET PHONE = '$phone' WHERE EMAIL = '$email'";
}
if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["NAME"].",".$row["EMAIL"].",".$row["PHONE"].",".$row["RADIUS"].",".$row["CREDIT"].",".$row["RATING"].",".$row["DATE"];
        }
    }else{
        echo "failed,null,null,null,null,null,null,null";
    }
} else {
    echo "error";
}
$conn->close();
?>