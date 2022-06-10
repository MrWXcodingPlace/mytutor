<?php
if(!isset($_POST)) {
    echo "failed";
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$sqllogin = "SELECT * FROM tbl_user WHERE user_email = '$email' AND user_password = '$password'";

$result = $conn->query($sqllogin);
if($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $user['id'] = $row['user_id'];
        $user['name'] = $row['user_name'];
        $user['email'] = $row['user_email'];
        $user['password'] = $row['user_password'];
        $user['phone'] = $row['user_phone'];
        $user['home'] = $row['user_homeAddress'];
        $user['logtime'] = $row['user_logtime'];
    }
    $response = array('status' => 'success', 'data' =>$user);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
$conn->close();
?>