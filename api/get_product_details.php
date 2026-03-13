<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json; charset=UTF-8');
require_once 'config.php';

$conn = getDBConnection();

$id = isset($_GET['id']) ? intval($_GET['id']) : 0;

if ($id <= 0) {
    echo json_encode(["success" => false, "message" => "Invalid product ID"]);
    exit;
}

// ── Main product ─────────────────────────────────────────────────
$stmt = $conn->prepare("
    SELECT 
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
        c.categoryName,
        CONCAT(f.first_name, ' ', f.last_name) AS farmerName,
        f.parish AS farmerParish
    FROM products p
    LEFT JOIN categories c ON p.categoryId = c.id
    LEFT JOIN farmers f ON p.farmerId = f.id
    WHERE p.id = ?
    LIMIT 1
");

if (!$stmt) {
    echo json_encode(["success" => false, "message" => $conn->error]);
    exit;
}

$stmt->bind_param('i', $id);
$stmt->execute();
$result = $stmt->get_result();
$product = $result->fetch_assoc();
$stmt->close();

if (!$product) {
    echo json_encode(["success" => false, "message" => "Product not found"]);
    exit;
}

// ── Related products (same category, same farmer, exclude self) ──
$catId    = intval($product['categoryId']);
$farmerId = intval($product['farmerId']);

$stmt2 = $conn->prepare("
    SELECT 
        p.id,
        p.productName,
        p.price,
        p.unitOfSale,
        p.imagePath,
        p.stockQuantity
    FROM products p
    WHERE p.farmerId = ?
      AND p.categoryId = ?
      AND p.id != ?
      AND p.isAvailable = 1
    LIMIT 6
");

$relatedProducts = [];

if ($stmt2) {
    $stmt2->bind_param('iii', $farmerId, $catId, $id);
    $stmt2->execute();
    $res2 = $stmt2->get_result();
    while ($row = $res2->fetch_assoc()) {
        $relatedProducts[] = $row;
    }
    $stmt2->close();
}

echo json_encode([
    "success"         => true,
    "product"         => $product,
    "relatedProducts" => $relatedProducts
]);

$conn->close();
