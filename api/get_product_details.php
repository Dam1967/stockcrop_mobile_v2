<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');

require_once 'config.php';

header("Content-Type: application/json; charset=UTF-8");

require_once 'config.php';

$conn = getDBConnection();

$categoryId = isset($_GET['category']) ? intval($_GET['category']) : 0;
$search     = isset($_GET['search']) ? trim($_GET['search']) : '';
$farmerId   = isset($_GET['farmer']) ? intval($_GET['farmer']) : 0;

$sql = "
    SELECT 
        p.id,
        p.productName,
        p.description,
        p.price,
        p.unitOfSale,
        p.stockQuantity,
        p.isAvailable,
        p.imagePath,
        p.farmerId,
        c.id AS categoryId,
        c.categoryName,
        f.firstName AS farmerFirstName,
        f.lastName AS farmerLastName,
        f.parish AS farmerParish
    FROM products p
    LEFT JOIN categories c ON p.categoryId = c.id
    LEFT JOIN farmers f ON p.farmerId = f.id
    WHERE p.isAvailable = 1
      AND p.stockQuantity > 0
";

$params = [];
$paramTypes = '';

if ($categoryId > 0) {
    $sql .= " AND p.categoryId = ?";
    $paramTypes .= 'i';
    $params[] = $categoryId;
}

if ($search !== '') {
    $sql .= " AND (p.productName LIKE ? OR p.description LIKE ?)";
    $paramTypes .= 'ss';
    $searchTerm = '%' . $search . '%';
    $params[] = $searchTerm;
    $params[] = $searchTerm;
}

if ($farmerId > 0) {
    $sql .= " AND p.farmerId = ?";
    $paramTypes .= 'i';
    $params[] = $farmerId;
}

$sql .= " ORDER BY p.productName ASC";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "success" => false,
        "stage" => "prepare",
        "message" => $conn->error
    ]);
    exit;
}

if (!empty($params)) {
    $stmt->bind_param($paramTypes, ...$params);
}

if (!$stmt->execute()) {
    echo json_encode([
        "success" => false,
        "stage" => "execute",
        "message" => $stmt->error
    ]);
    exit;
}

$result = $stmt->get_result();
$products = [];

while ($row = $result->fetch_assoc()) {
    $products[] = [
        "id" => (int)$row["id"],
        "productName" => $row["productName"],
        "description" => $row["description"],
        "price" => (float)$row["price"],
        "unitOfSale" => $row["unitOfSale"],
        "stockQuantity" => (int)$row["stockQuantity"],
        "isAvailable" => (bool)$row["isAvailable"],
        "imagePath" => $row["imagePath"],
        "farmerId" => (int)$row["farmerId"],
        "categoryId" => isset($row["categoryId"]) ? (int)$row["categoryId"] : null,
        "categoryName" => $row["categoryName"] ?? "",
        "farmerName" => trim(($row["farmerFirstName"] ?? "") . " " . ($row["farmerLastName"] ?? "")),
        "farmerParish" => $row["farmerParish"] ?? ""
    ];
}

$stmt->close();
$conn->close();

echo json_encode([
    "success" => true,
    "products" => $products,
    "total" => count($products)
]);
?>
