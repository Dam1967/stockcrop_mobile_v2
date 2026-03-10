<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');

require_once 'config.php';

$conn = getDBConnection();

$sql = "SELECT * FROM products LIMIT 5";
$result = $conn->query($sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => "Query failed",
        "error" => $conn->error
    ]);
    exit;
}

$products = [];

while ($row = $result->fetch_assoc()) {
    $products[] = $row;
}

echo json_encode([
    "success" => true,
    "products" => $products
]);
