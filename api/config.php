<?php
// =============================================
// StockCrop API - Database Configuration
// =============================================

error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

function getDBConnection() {
    $host     = getenv('DB_HOST') ?: '127.0.0.1';
    $port     = (int)(getenv('DB_PORT') ?: 3306);
    $dbName   = getenv('DB_NAME') ?: '';
    $username = getenv('DB_USER') ?: '';
    $password = getenv('DB_PASS') ?: '';

    $conn = new mysqli($host, $username, $password, $dbName, $port);

    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => 'Database connection failed: ' . $conn->connect_error
        ]);
        exit();
    }

    $conn->set_charset("utf8");
    return $conn;
}
?>
