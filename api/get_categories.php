<?php
header("Content-Type: application/json; charset=UTF-8");

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once 'config.php';

try {
    $conn = getDBConnection();

    $sql = "SELECT id, categoryName FROM categories ORDER BY categoryName ASC";
    $result = $conn->query($sql);

    if (!$result) {
        throw new Exception("Query failed: " . $conn->error);
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
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}
?>
