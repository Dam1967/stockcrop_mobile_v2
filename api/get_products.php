<?php
// =============================================
// StockCrop API - Get Products (Marketplace)
// GET: ?category=1&search=tomato&farmer=1
// =============================================

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');

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

$result = mysqli_query($conn, $sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "error" => mysqli_error($conn),
        "sql" => $sql
    ]);
    exit;
}

$products = [];

while ($row = mysqli_fetch_assoc($result)) {
    $products[] = $row;
}

echo json_encode([
    "success" => true,
    "products" => $products
]);
