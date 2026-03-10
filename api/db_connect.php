<?php

$host = getenv('DB_HOST') ?: '127.0.0.1';
$port = (int)(getenv('DB_PORT') ?: 3306);
$dbname = getenv('DB_NAME') ?: '';
$username = getenv('DB_USER') ?: '';
$password = getenv('DB_PASS') ?: '';

$conn = new mysqli($host, $username, $password, $dbname, $port);

if ($conn->connect_error) {
    die("❌ DB Error: " . $conn->connect_error);
}

$conn->set_charset("utf8");
?>