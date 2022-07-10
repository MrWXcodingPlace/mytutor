<?php
if(!isset($_POST)) {
    $response = array('status' =>'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];
$phone = $_POST['phone'];
$home = $_POST['home'];
$base64image = $_POST['image'];

$sqllinsert = "INSERT INTO tbl_user(user_name, user_email, user_password, user_phone, user_homeAddress) VALUES ('$name', '$email', '$password', '$phone', '$home')";
if($conn->query($sqllinsert) === TRUE) {
    $response = array('status' => 'success', 'data'=>null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/users/' .$filename . '.png';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type', 'application/json');
    echo json_encode($sentArray);
}

?>