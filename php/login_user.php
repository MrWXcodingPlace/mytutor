<?php
if (!isset($_POST)) {
    echo "failed";
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$sqllogin = "SELECT * FROM tbl_user WHERE user_email = '$email' AND user_password = '$password'";

$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $user['user_id'] = $row['user_id'];
        $user['user_name'] = $row['user_name'];
        $user['user_email'] = $row['user_email'];
        $user['user_password'] = $row['user_password'];
        $user['user_phone'] = $row['user_phone'];
        $user['user_home'] = $row['user_homeAddress'];
        $user['user_logtime'] = $row['user_logtime'];
    }
    $response = array('status' => 'success', 'data' => $user);
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