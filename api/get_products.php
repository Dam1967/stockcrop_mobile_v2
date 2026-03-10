<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once 'config.php';

$conn = getDBConnection();

$sql = "SELECT 
            p.id,
            p.productName,
            p.description,
            p.price,
            p.unitOfSale,
            p.stockQuantity,
            p.isAvailable,
            p.imagePath,
            p.farmerId,
            p.categoryId,
            c.categoryName,
            CONCAT(COALESCE(f.firstName, ''), ' ', COALESCE(f.lastName, '')) AS farmerName,
            f.parish AS farmerParish
        FROM products p
        LEFT JOIN categories c ON p.categoryId = c.id
        LEFT JOIN farmers f ON p.farmerId = f.id
        ORDER BY p.id DESC";

$result = $conn->query($sql);

if (!$result) {
    http_response_code(500);
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
