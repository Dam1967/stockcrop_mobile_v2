<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');

require_once 'config.php';

$conn = getDBConnection();

$sql = "SELECT 
            p.id,
            p.farmerId,
            p.productName,
            p.description,
            p.price,
            p.unitOfSale,
            p.stockQuantity,
            p.categoryId,
            p.imagePath,
            p.isAvailable,
            p.allowBids,
            p.minBidPrice,
            p.created_at,
            p.updated_at,
            p.low_stock_threshold,
            p.last_out_of_stock_notified,
            c.categoryName
        FROM products p
        LEFT JOIN categories c ON p.categoryId = c.id
        WHERE p.isAvailable = 1
        ORDER BY p.id DESC";

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
