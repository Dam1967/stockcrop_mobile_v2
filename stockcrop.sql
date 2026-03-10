-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2026 at 01:39 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `stockcrop_mobile_v2`
--
CREATE DATABASE IF NOT EXISTS `stockcrop_mobile_v2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `stockcrop_mobile_v2`;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
CREATE TABLE IF NOT EXISTS `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(11) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `first_name`, `last_name`, `email`, `password`, `role_id`, `created_at`) VALUES
(1, 'Admin', 'User', 'admin@stockcrop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, '2026-03-03 00:30:25');

-- --------------------------------------------------------

--
-- Table structure for table `bids`
--

DROP TABLE IF EXISTS `bids`;
CREATE TABLE IF NOT EXISTS `bids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `productId` int(11) NOT NULL,
  `customerId` int(11) NOT NULL,
  `farmerId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `originalPrice` decimal(10,2) NOT NULL COMMENT 'Product listing price at time of bid',
  `currentOffer` decimal(10,2) NOT NULL COMMENT 'Latest offer amount',
  `currentTurn` enum('farmer','customer') NOT NULL DEFAULT 'farmer' COMMENT 'Whose turn to respond',
  `status` enum('negotiating','accepted','rejected','cancelled','expired') NOT NULL DEFAULT 'negotiating',
  `acceptedPrice` decimal(10,2) DEFAULT NULL COMMENT 'Final agreed price',
  `cartExpiresAt` datetime DEFAULT NULL COMMENT 'When the accepted bid cart item expires',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_customer` (`customerId`),
  KEY `idx_farmer` (`farmerId`),
  KEY `idx_product` (`productId`),
  KEY `idx_status` (`status`),
  KEY `idx_cart_expires` (`cartExpiresAt`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bids`
--

INSERT INTO `bids` (`id`, `productId`, `customerId`, `farmerId`, `quantity`, `originalPrice`, `currentOffer`, `currentTurn`, `status`, `acceptedPrice`, `cartExpiresAt`, `created_at`, `updated_at`) VALUES
(11, 44, 2, 3, 1, 60000.00, 55000.00, 'customer', 'expired', 55000.00, '2026-03-06 21:43:36', '2026-03-06 19:41:05', '2026-03-07 14:08:41'),
(12, 43, 2, 1, 1, 100000.00, 90000.00, 'customer', 'expired', 90000.00, '2026-03-06 22:12:01', '2026-03-06 20:09:51', '2026-03-07 14:08:41');

-- --------------------------------------------------------

--
-- Table structure for table `bid_offers`
--

DROP TABLE IF EXISTS `bid_offers`;
CREATE TABLE IF NOT EXISTS `bid_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bidId` int(11) NOT NULL,
  `offeredBy` enum('customer','farmer') NOT NULL,
  `offerPrice` decimal(10,2) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `action` enum('offer','counter','accept','reject') NOT NULL DEFAULT 'offer',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_bid` (`bidId`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bid_offers`
--

INSERT INTO `bid_offers` (`id`, `bidId`, `offeredBy`, `offerPrice`, `message`, `action`, `created_at`) VALUES
(37, 11, 'customer', 50000.00, '', 'offer', '2026-03-06 19:41:05'),
(38, 11, 'farmer', 55000.00, '', 'counter', '2026-03-06 19:42:05'),
(39, 11, 'customer', 55000.00, '', 'accept', '2026-03-06 19:43:36'),
(40, 12, 'customer', 85000.00, '', 'offer', '2026-03-06 20:09:51'),
(41, 12, 'farmer', 90000.00, 'My best offer', 'counter', '2026-03-06 20:10:50'),
(42, 12, 'customer', 90000.00, '', 'accept', '2026-03-06 20:12:01');

-- --------------------------------------------------------

--
-- Table structure for table `cartitems`
--

DROP TABLE IF EXISTS `cartitems`;
CREATE TABLE IF NOT EXISTS `cartitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `addedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `bid_price` decimal(10,2) DEFAULT NULL,
  `bid_id` int(11) DEFAULT NULL,
  `bid_expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_cart_item` (`customerId`,`productId`),
  KEY `productId` (`productId`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `categoryName`) VALUES
(1, 'Vegetables'),
(2, 'Fruits'),
(3, 'Herbs'),
(4, 'Grains'),
(5, 'Ground Provisions'),
(6, 'Livestock');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `parish` varchar(50) DEFAULT NULL,
  `role_id` int(11) DEFAULT 3,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `first_name`, `last_name`, `email`, `password`, `phone`, `address1`, `address2`, `parish`, `role_id`, `created_at`) VALUES
(1, 'Jane', 'Doe', 'jane@customer.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '876-555-5678', '123 Main Street, Kingston', NULL, 'Kingston', 3, '2026-03-03 00:30:25'),
(2, 'Test', 'Customer', 'test@customer.com', '$2y$10$WGAiQNkvKselXshgOfxtIO1JcV/dv/dOzHL2jscMM5Ub7wnYPwmea', '876-555-1233', '456 Oak Avenue', '', 'St. Andrew', 3, '2026-03-03 00:30:25'),
(3, 'Vanessa', 'Hinds', 'vanessahinds@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '876-555-0001', 'Kingston', NULL, 'Kingston', 3, '2026-03-03 00:39:37');

-- --------------------------------------------------------

--
-- Table structure for table `farmers`
--

DROP TABLE IF EXISTS `farmers`;
CREATE TABLE IF NOT EXISTS `farmers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `farm_name` varchar(100) DEFAULT NULL,
  `parish` varchar(50) DEFAULT NULL,
  `rada_number` varchar(50) DEFAULT NULL,
  `role_id` int(11) DEFAULT 2,
  `verification_status` enum('pending','verified','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `farmers`
--

INSERT INTO `farmers` (`id`, `first_name`, `last_name`, `email`, `password`, `phone`, `farm_name`, `parish`, `rada_number`, `role_id`, `verification_status`, `created_at`) VALUES
(1, 'John', 'Brown', 'john@farmer.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '876-555-9999', 'Brown Family Farm', 'St. Mary', 'RADA-001', 2, 'verified', '2026-03-03 00:30:25'),
(2, 'Dave', 'Green', 'dave@farmer.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '876-555-8888', 'Green Valley Farm', 'Clarendon', 'RADA-002', 2, 'verified', '2026-03-03 00:30:25'),
(3, 'John', 'Brown', 'johnbrown@gmail.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '876-555-0002', 'Brown Farm', 'St. Mary', 'RADA-003', 2, 'verified', '2026-03-03 00:39:37');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `userType` enum('customer','farmer','admin') NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `isRead` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `userId`, `userType`, `title`, `message`, `isRead`, `created_at`) VALUES
(1, 2, 'customer', 'Order Placed', 'Your order #1 has been placed successfully. Total: $300.00', 0, '2026-03-03 01:45:14'),
(2, 2, 'customer', 'Order Placed', 'Your order #2 has been placed successfully. Total: $150,000.00', 0, '2026-03-03 01:51:51'),
(3, 2, 'customer', 'Order Placed', 'Your order #3 has been placed successfully. Total: $150,000.00', 0, '2026-03-04 02:00:23'),
(4, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Confirmed', 0, '2026-03-04 02:37:38'),
(5, 2, 'customer', 'Order Update', 'Your order #2 status has been updated to: Processing', 0, '2026-03-04 02:37:48'),
(6, 2, 'customer', 'Order Update', 'Your order #1 status has been updated to: Shipped', 0, '2026-03-04 02:38:19'),
(7, 2, 'customer', 'Order Update', 'Your order #2 status has been updated to: Ready for pickup', 0, '2026-03-04 03:16:33'),
(8, 2, 'customer', 'Order Update', 'Your order #1 status has been updated to: Delivered', 0, '2026-03-04 03:16:54'),
(9, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Processing', 0, '2026-03-04 03:41:05'),
(10, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Delivered', 0, '2026-03-04 03:41:23'),
(11, 2, 'customer', 'Order Placed', 'Your order #4 has been placed successfully. Total: JMD $1,180.00', 0, '2026-03-04 04:18:05'),
(12, 2, 'customer', 'Order Placed', 'Your order #5 has been placed successfully. Total: JMD $151,180.00', 0, '2026-03-04 04:18:58'),
(13, 2, 'customer', 'Order Update', 'Your order #5 status has been updated to: Processing', 0, '2026-03-04 04:22:22'),
(14, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Shipped', 0, '2026-03-04 04:22:29'),
(15, 2, 'customer', 'Order Placed', 'Your order #6 has been placed successfully. Total: JMD $1,810.00', 0, '2026-03-04 13:37:22'),
(16, 2, 'customer', 'Order Update', 'Your order #6 status has been updated to: Processing', 0, '2026-03-04 14:40:49'),
(17, 2, 'customer', 'Order Update', 'Your order #6 status has been updated to: Shipped', 0, '2026-03-04 14:40:54'),
(18, 2, 'customer', 'Order Update', 'Your order #6 status has been updated to: Delivered', 0, '2026-03-04 14:40:57'),
(19, 2, 'customer', 'Order Update', 'Your order #5 status has been updated to: Shipped', 0, '2026-03-04 14:41:19'),
(20, 2, 'customer', 'Order Update', 'Your order #5 status has been updated to: Delivered', 0, '2026-03-04 14:41:24'),
(21, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Delivered', 0, '2026-03-04 14:41:36'),
(22, 2, 'customer', 'Order Placed', 'Your order #1 has been placed successfully. Total: JMD $1,580.00', 0, '2026-03-04 16:44:34'),
(23, 2, 'customer', 'Order Placed', 'Your order #2 has been placed successfully. Total: JMD $280.00', 0, '2026-03-04 16:45:12'),
(24, 2, 'customer', 'Order Update', 'Your order #2 status has been updated to: Processing', 0, '2026-03-04 16:57:07'),
(25, 2, 'customer', 'Order Update', 'Your order #2 status has been updated to: Ready for pickup', 0, '2026-03-04 16:57:21'),
(26, 2, 'customer', 'Order Update', 'Your order #1 status has been updated to: Processing', 0, '2026-03-04 16:57:33'),
(27, 2, 'customer', 'Order Update', 'Your order #1 status has been updated to: Shipped', 0, '2026-03-04 16:57:42'),
(28, 2, 'customer', 'Order Update', 'Your order #1 status has been updated to: Delivered', 0, '2026-03-04 16:57:47'),
(29, 2, 'customer', 'Order Placed', 'Your order #3 has been placed successfully. Total: JMD $150,000.00', 0, '2026-03-04 17:41:44'),
(30, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Processing', 0, '2026-03-04 17:42:59'),
(31, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Shipped', 0, '2026-03-04 17:43:05'),
(32, 2, 'customer', 'Order Update', 'Your order #3 status has been updated to: Delivered', 0, '2026-03-04 17:43:09'),
(33, 2, 'customer', 'Order Update', 'Your order #2 status has been updated to: Delivered', 0, '2026-03-04 17:45:59'),
(34, 2, 'customer', 'Order Placed', 'Your order #4 has been placed successfully. Total: JMD $153,000.00', 0, '2026-03-05 03:37:22'),
(35, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Processing', 0, '2026-03-05 03:39:00'),
(36, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Ready for pickup', 0, '2026-03-05 03:39:27'),
(37, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Shipped', 0, '2026-03-05 03:40:49'),
(38, 2, 'customer', 'Order Update', 'Your order #4 status has been updated to: Delivered', 0, '2026-03-05 03:41:59'),
(39, 2, 'customer', 'Order Placed', 'Your order #5 has been placed successfully. Total: JMD $1,280.00', 0, '2026-03-05 11:54:27'),
(40, 2, 'customer', 'Order Placed', 'Your order #6 has been placed successfully. Total: JMD $180,500.00', 0, '2026-03-06 14:15:19'),
(41, 3, 'farmer', 'New Bid Received', 'New bid of $54,000.00 on \'Goat (Livestock) \'', 0, '2026-03-06 14:34:05'),
(42, 2, 'customer', 'Counter Offer', 'Farmer countered with $55,000.00', 0, '2026-03-06 16:04:51'),
(43, 3, 'farmer', 'Bid Rejected', 'Customer rejected your counter offer', 0, '2026-03-06 17:41:11'),
(44, 3, 'farmer', 'New Bid Received', 'New bid of $50,000.00 on \'Goat (Livestock) \'', 0, '2026-03-06 17:41:57'),
(45, 2, 'customer', 'Counter Offer', 'Farmer countered with $55,000.00', 0, '2026-03-06 17:43:20'),
(46, 3, 'farmer', 'Bid Accepted', 'Customer accepted your offer of $55,000.00', 0, '2026-03-06 17:57:00'),
(47, 3, 'farmer', 'New Bid Received', 'New bid of $50,000.00 on \'Goat (Livestock) \'', 0, '2026-03-06 18:34:23'),
(48, 2, 'customer', 'Counter Offer', 'Farmer countered with $55,000.00', 0, '2026-03-06 18:35:46'),
(49, 3, 'farmer', 'Counter Offer', 'Customer countered with $54,999.00', 0, '2026-03-06 18:37:01'),
(50, 2, 'customer', 'Counter Offer', 'Farmer countered with $55,000.00', 0, '2026-03-06 18:38:30'),
(51, 3, 'farmer', 'Bid Accepted', 'Customer accepted your offer of $55,000.00', 0, '2026-03-06 18:41:41'),
(52, 2, 'customer', 'Order Placed', 'Your order #7 has been placed successfully. Total: JMD $60,000.00', 0, '2026-03-06 18:42:19'),
(53, 1, 'farmer', 'New Bid Received', 'New bid of $80,000.00 on \'Cow (Livestock)\'', 0, '2026-03-06 18:53:38'),
(54, 2, 'customer', 'Counter Offer', 'Farmer countered with $90,000.00', 0, '2026-03-06 19:02:27'),
(55, 1, 'farmer', 'Counter Offer', 'Customer countered with $85,000.00', 0, '2026-03-06 19:03:29'),
(56, 2, 'customer', 'Bid Rejected', 'The farmer rejected your bid', 0, '2026-03-06 19:04:26'),
(57, 1, 'farmer', 'New Bid Received', 'New bid of $80,000.00 on \'Cow (Livestock)\'', 0, '2026-03-06 19:14:13'),
(58, 1, 'farmer', 'New Bid Received', 'New bid of $80,000.00 on \'Cow (Livestock)\'', 0, '2026-03-06 19:21:45'),
(59, 2, 'customer', 'Counter Offer', 'Farmer countered with $90,000.00', 0, '2026-03-06 19:22:46'),
(60, 1, 'farmer', 'Bid Accepted', 'Customer accepted your offer of $90,000.00', 0, '2026-03-06 19:23:59'),
(61, 2, 'customer', 'Order Placed', 'Your order #8 has been placed successfully. Total: JMD $100,000.00', 0, '2026-03-06 19:24:18'),
(62, 1, 'farmer', 'New Bid Received', 'New bid of $80,000.00 on \'Cow (Livestock)\'', 0, '2026-03-06 19:35:09'),
(63, 2, 'customer', 'Counter Offer', 'Farmer countered with $91,000.00', 0, '2026-03-06 19:36:13'),
(64, 1, 'farmer', 'Bid Rejected', 'Customer rejected your counter offer', 0, '2026-03-06 19:36:58'),
(65, 3, 'farmer', 'New Bid Received', 'New bid of $50,000.00 on \'Goat (Livestock) \'', 0, '2026-03-06 19:41:05'),
(66, 2, 'customer', 'Counter Offer', 'Farmer countered with $55,000.00', 0, '2026-03-06 19:42:05'),
(67, 3, 'farmer', 'Bid Accepted', 'Customer accepted your offer of $55,000.00', 0, '2026-03-06 19:43:36'),
(68, 2, 'customer', 'Order Placed', 'Your order #9 has been placed successfully. Total: JMD $55,000.00', 0, '2026-03-06 19:43:46'),
(69, 2, 'customer', 'Order Placed', 'Your order #10 has been placed successfully. Total: JMD $100,000.00', 0, '2026-03-06 19:53:35'),
(70, 2, 'customer', 'Order Update', 'Your order #10 status has been updated to: Processing', 0, '2026-03-06 19:54:34'),
(71, 2, 'customer', 'Order Update', 'Your order #9 status has been updated to: Processing', 0, '2026-03-06 19:56:38'),
(72, 2, 'customer', 'Order Update', 'Your order #9 status has been updated to: Shipped', 0, '2026-03-06 19:56:42'),
(73, 1, 'farmer', 'New Bid Received', 'New bid of $85,000.00 on \'Cow (Livestock)\'', 0, '2026-03-06 20:09:51'),
(74, 2, 'customer', 'Counter Offer', 'Farmer countered with $90,000.00', 0, '2026-03-06 20:10:50'),
(75, 1, 'farmer', 'Bid Accepted', 'Customer accepted your offer of $90,000.00', 0, '2026-03-06 20:12:01'),
(76, 2, 'customer', 'Order Placed', 'Your order #11 has been placed successfully. Total: JMD $90,000.00', 0, '2026-03-06 20:12:09'),
(77, 2, 'customer', 'Order Update', 'Your order #11 status has been updated to: Processing', 0, '2026-03-06 21:58:43'),
(78, 2, 'customer', 'Order Update', 'Your order #11 status has been updated to: Shipped', 0, '2026-03-06 21:58:47'),
(79, 2, 'customer', 'Order Update', 'Your order #11 status has been updated to: Delivered', 0, '2026-03-06 21:58:51'),
(80, 2, 'customer', 'Order Update', 'Your order #10 status has been updated to: Shipped', 0, '2026-03-06 21:59:04'),
(81, 2, 'customer', 'Order Update', 'Your order #10 status has been updated to: Delivered', 0, '2026-03-06 21:59:36'),
(82, 2, 'customer', 'Order Placed', 'Your order #12 has been placed successfully. Total: JMD $100,000.00', 0, '2026-03-07 00:29:20'),
(83, 2, 'customer', 'Order Update', 'Your order #12 status has been updated to: Processing', 0, '2026-03-07 00:30:41'),
(84, 2, 'customer', 'Order Update', 'Your order #9 status has been updated to: Delivered', 0, '2026-03-07 00:58:02'),
(85, 2, 'customer', 'Order Update', 'Your order #12 status has been updated to: Shipped', 0, '2026-03-07 09:56:34'),
(86, 2, 'customer', 'Order Placed', 'Your order #13 has been placed successfully. Total: JMD $1,800.00', 0, '2026-03-07 14:13:19'),
(87, 2, 'customer', 'Order Placed', 'Your order #14 has been placed successfully. Total: JMD $450.00', 0, '2026-03-07 14:40:47'),
(88, 2, 'customer', 'Order Placed', 'Your order #15 has been placed successfully. Total: JMD $100,000.00', 0, '2026-03-07 15:14:46'),
(89, 2, 'customer', 'Order Placed', 'Your order #16 has been placed successfully. Total: JMD $280.00', 0, '2026-03-07 16:09:12'),
(90, 2, 'customer', 'Order Placed', 'Your order #17 has been placed successfully. Total: JMD $380.00', 0, '2026-03-07 17:06:37'),
(91, 2, 'customer', 'Order Placed', 'Your order #18 has been placed successfully. Total: JMD $3,190.00', 0, '2026-03-07 17:10:27'),
(92, 2, 'customer', 'Order Update', 'Your order #12 status has been updated to: Delivered', 0, '2026-03-07 17:12:09'),
(93, 2, 'customer', 'Order Update', 'Your order #18 status has been updated to: Confirmed', 0, '2026-03-07 17:12:20'),
(94, 2, 'customer', 'Order Update', 'Your order #17 status has been updated to: Confirmed', 0, '2026-03-07 17:12:25'),
(95, 2, 'customer', 'Order Update', 'Your order #14 status has been updated to: Processing', 0, '2026-03-07 17:12:38');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `orderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `totalAmount` decimal(10,2) NOT NULL,
  `shippingFee` decimal(10,2) DEFAULT 0.00,
  `deliveryMethod` varchar(50) DEFAULT 'delivery',
  `deliveryAddress` text DEFAULT NULL,
  `recipientPhone` varchar(20) DEFAULT NULL,
  `paymentMethod` varchar(50) DEFAULT 'cash_on_delivery',
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `customerId` (`customerId`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customerId`, `orderDate`, `totalAmount`, `shippingFee`, `deliveryMethod`, `deliveryAddress`, `recipientPhone`, `paymentMethod`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(9, 2, '2026-03-06 19:43:46', 55000.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'delivered', '', '2026-03-06 19:43:46', '2026-03-07 00:58:02'),
(10, 2, '2026-03-06 19:53:35', 100000.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'delivered', '', '2026-03-06 19:53:35', '2026-03-06 21:59:36'),
(11, 2, '2026-03-06 20:12:09', 90000.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'delivered', '', '2026-03-06 20:12:09', '2026-03-06 21:58:51'),
(12, 2, '2026-03-07 00:29:20', 100000.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'delivered', '', '2026-03-07 00:29:20', '2026-03-07 17:12:09'),
(13, 2, '2026-03-07 14:13:19', 1800.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'pending', '', '2026-03-07 14:13:19', '2026-03-07 14:13:19'),
(14, 2, '2026-03-07 14:40:47', 450.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'processing', '', '2026-03-07 14:40:47', '2026-03-07 17:12:38'),
(15, 2, '2026-03-07 15:14:46', 100000.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'pending', '', '2026-03-07 15:14:46', '2026-03-07 15:14:46'),
(16, 2, '2026-03-07 16:09:12', 280.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'pending', '', '2026-03-07 16:09:12', '2026-03-07 16:09:12'),
(17, 2, '2026-03-07 17:06:37', 380.00, 0.00, 'Pickup', '', '876-555-1233', 'COD', 'confirmed', '', '2026-03-07 17:06:37', '2026-03-07 17:12:25'),
(18, 2, '2026-03-07 17:10:27', 3190.00, 500.00, 'Delivery', '456 Oak Avenue, St. Andrew', '876-555-1233', 'COD', 'confirmed', '', '2026-03-07 17:10:27', '2026-03-07 17:12:20');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `farmerId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `priceAtPurchase` decimal(10,2) NOT NULL,
  `lineTotal` decimal(10,2) NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `orderId` (`orderId`),
  KEY `productId` (`productId`),
  KEY `farmerId` (`farmerId`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `orderId`, `productId`, `farmerId`, `quantity`, `priceAtPurchase`, `lineTotal`, `status`) VALUES
(12, 9, 44, 3, 1, 55000.00, 55000.00, 'Pending'),
(13, 10, 43, 1, 1, 100000.00, 100000.00, 'Pending'),
(14, 11, 43, 1, 1, 90000.00, 90000.00, 'Pending'),
(15, 12, 43, 1, 1, 100000.00, 100000.00, 'Pending'),
(16, 13, 52, 2, 2, 280.00, 560.00, 'Pending'),
(17, 13, 46, 1, 2, 300.00, 600.00, 'Pending'),
(18, 13, 53, 2, 2, 320.00, 640.00, 'Pending'),
(19, 14, 51, 1, 3, 150.00, 450.00, 'Pending'),
(20, 15, 43, 1, 1, 100000.00, 100000.00, 'Pending'),
(21, 16, 52, 2, 1, 280.00, 280.00, 'Pending'),
(22, 17, 55, 2, 1, 380.00, 380.00, 'Pending'),
(23, 18, 52, 2, 3, 280.00, 840.00, 'Pending'),
(24, 18, 48, 1, 1, 400.00, 400.00, 'Pending'),
(25, 18, 49, 3, 2, 200.00, 400.00, 'Pending'),
(26, 18, 53, 2, 1, 320.00, 320.00, 'Pending'),
(27, 18, 55, 2, 1, 380.00, 380.00, 'Pending'),
(28, 18, 38, 1, 1, 350.00, 350.00, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `farmerId` int(11) NOT NULL,
  `productName` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `unitOfSale` varchar(50) DEFAULT NULL,
  `stockQuantity` int(11) NOT NULL DEFAULT 0,
  `categoryId` int(11) NOT NULL,
  `imagePath` text DEFAULT NULL,
  `isAvailable` tinyint(1) DEFAULT 1,
  `allowBids` tinyint(1) NOT NULL DEFAULT 0,
  `minBidPrice` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `low_stock_threshold` int(11) DEFAULT 5,
  `last_out_of_stock_notified` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_farmer_product` (`farmerId`,`productName`,`categoryId`,`unitOfSale`),
  KEY `categoryId` (`categoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `farmerId`, `productName`, `description`, `price`, `unitOfSale`, `stockQuantity`, `categoryId`, `imagePath`, `isAvailable`, `allowBids`, `minBidPrice`, `created_at`, `updated_at`, `low_stock_threshold`, `last_out_of_stock_notified`) VALUES
(38, 1, 'Fresh Tomatoes', 'Organic vine-ripened tomatoes from St. Mary', 350.00, 'lb', 98, 1, 'uploads/products/tomato.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 17:10:27', 5, 0),
(39, 1, 'Watermelon', 'Sweet juicy watermelon', 500.00, 'piece', 40, 2, 'uploads/products/watermelon.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(40, 1, 'Yam', 'Fresh yellow yam - ground provision', 450.00, 'lb', 90, 5, 'uploads/products/yamGroundProvision.png', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(41, 1, 'Broccoli', 'Fresh green broccoli', 400.00, 'lb', 73, 1, 'uploads/products/broccoliVegetables.png', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(42, 1, 'Callaloo', 'Fresh leafy callaloo bundle', 250.00, 'bundle', 120, 1, 'uploads/products/callaloo.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(43, 1, 'Cow (Livestock)', 'Healthy farm-raised cattle', 100000.00, 'head', 15, 6, 'uploads/products/cowLivestock.png', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 15:14:46', 5, 0),
(44, 3, 'Goat (Livestock) ', 'Healthy farm-raised cattle', 60000.00, 'head', 10, 6, 'uploads/products/goat.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 19:43:46', 5, 0),
(45, 1, 'Onion', 'Fresh cooking onions', 300.00, 'lb', 200, 1, 'uploads/products/onion.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(46, 1, 'Fresh Oranges', 'Sweet juicy oranges from Clarendon', 300.00, 'lb', 61, 2, 'uploads/products/orange.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 14:13:19', 5, 0),
(47, 3, 'Pineapple', 'Sweet golden pineapple', 350.00, 'piece', 60, 2, 'uploads/products/Pineapple.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(48, 1, 'Sweet Peppers', 'Fresh green sweet peppers', 400.00, 'lb', 99, 1, 'uploads/products/sweet_peppers.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 17:10:27', 5, 0),
(49, 3, 'Ripe Bananas', 'Fresh ripe bananas', 200.00, 'bunch', 148, 2, 'uploads/products/ripeBanana.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 17:10:27', 5, 0),
(50, 3, 'Sweet Potato', 'Fresh sweet potato', 350.00, 'lb', 85, 5, 'uploads/products/sweet_potato.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-06 14:18:08', 5, 0),
(51, 1, 'Thyme Bundle', 'Fresh thyme herbs', 150.00, 'bundle', 197, 3, 'uploads/products/thyme-bundle.jpg', 1, 1, NULL, '2026-03-03 00:52:13', '2026-03-07 14:40:47', 5, 0),
(52, 2, 'Fresh Onion', 'Quality cooking onions from Clarendon', 280.00, 'lb', 140, 1, 'uploads/products/onion.jpg', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-07 17:10:27', 5, 0),
(53, 2, 'Sweet Potato', 'Fresh sweet potato from local farm', 320.00, 'lb', 97, 5, 'uploads/products/sweet_potato.jpg', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-07 17:10:27', 5, 0),
(54, 2, 'Thyme Bundle', 'Aromatic fresh thyme herbs', 180.00, 'bundle', 80, 3, 'uploads/products/thyme-bundle.jpg', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-06 14:18:08', 5, 0),
(55, 2, 'Broccoli', 'Fresh organic broccoli', 380.00, 'lb', 54, 1, 'uploads/products/broccoliVegetables.png', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-07 17:10:27', 5, 0),
(56, 2, 'Watermelon', 'Large sweet watermelon', 550.00, 'piece', 30, 2, 'uploads/products/watermelon.jpg', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-06 14:18:08', 5, 0),
(57, 2, 'Callaloo', 'Fresh green callaloo bundle', 220.00, 'bundle', 89, 1, 'uploads/products/callaloo.jpg', 1, 1, NULL, '2026-03-03 22:25:19', '2026-03-06 14:18:08', 5, 0),
(58, 1, 'Goat (Livestock)', 'Healthy farm-raised cattle', 60000.00, 'per head', 25, 6, 'uploads/products/livestockImage.png', 1, 1, NULL, '2026-03-04 01:39:22', '2026-03-06 14:18:08', 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roleName` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `roleName`) VALUES
(1, 'Admin'),
(2, 'Farmer'),
(3, 'Customer');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE IF NOT EXISTS `wishlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customerId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `addedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_wishlist_item` (`customerId`,`productId`),
  KEY `productId` (`productId`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bid_offers`
--
ALTER TABLE `bid_offers`
  ADD CONSTRAINT `bid_offers_ibfk_1` FOREIGN KEY (`bidId`) REFERENCES `bids` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`farmerId`) REFERENCES `farmers` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`farmerId`) REFERENCES `farmers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`id`);

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
