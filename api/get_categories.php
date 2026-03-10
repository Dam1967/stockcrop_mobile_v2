<?php
// =============================================
// StockCrop API - Get Categories
// GET: (no params)
// =============================================

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once 'config.php';

$conn   = getDBConnection();
$result = $conn->query("SELECT id, categoryName FROM categories ORDER BY categoryName ASC");

$categories = [];
while ($row = $result->fetch_assoc()) {
    $categories[] = [
        'id'           => intval($row['id']),
        'categoryName' => $row['categoryName'],
    ];
}

$conn->close();

echo json_encode([
    'success'    => true,
    'categories' => $categories,
    'total'      => count($categories),
]);
?>
