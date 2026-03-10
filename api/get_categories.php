<?php
header('Content-Type: application/json; charset=UTF-8');

require_once 'config.php';

$conn = getDBConnection();

$sql = "SELECT id, categoryName FROM categories ORDER BY categoryName ASC";
$result = $conn->query($sql);

if (!$result) {
    echo json_encode([
        "success" => false,
        "message" => $conn->error
    ]);
    exit;
}

$categories = [];

while ($row = $result->fetch_assoc()) {
    $categories[] = [
        "id" => (int)$row["id"],
        "categoryName" => $row["categoryName"]
    ];
}

echo json_encode([
    "success" => true,
    "categories" => $categories
]);

$conn->close();
?>
