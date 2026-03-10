<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json; charset=UTF-8');

require_once 'config.php';

echo json_encode([
    "success" => true,
    "message" => "get_products.php is running"
]);
