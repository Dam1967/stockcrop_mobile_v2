<?php

$host = "crossover.proxy.rlwy.net";
$port = 23490;
$dbname = "stockcrop_mobile_v2";
$username = "root";
$password = "TXIoowGcIIbRpYSWaKRhfhgSVTjSGGeT";

$conn = new mysqli($host, $username, $password, $dbname, $port);

if ($conn->connect_error) {
    die("❌ DB Error: " . $conn->connect_error);
}

$conn->set_charset("utf8");

?>