-- Hotel Booking Database Schema
-- Charset: utf8mb4

CREATE DATABASE IF NOT EXISTS `hotel_booking_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `hotel_booking_db`;

-- 1. Bảng users
CREATE TABLE IF NOT EXISTS `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `role` ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
  `avatar` VARCHAR(255) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_users_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng hotels
CREATE TABLE IF NOT EXISTS `hotels` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `star` TINYINT NOT NULL DEFAULT 4,
  `rating` DECIMAL(2,1) NOT NULL DEFAULT 4.5,
  `min_price` DECIMAL(12,2) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_hotels_city` (`city`),
  INDEX `idx_hotels_name` (`name`),
  INDEX `idx_hotels_star` (`star`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng hotel_images
CREATE TABLE IF NOT EXISTS `hotel_images` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `hotel_id` INT NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng room_types
CREATE TABLE IF NOT EXISTS `room_types` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `hotel_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `capacity` INT NOT NULL DEFAULT 2,
  `price` DECIMAL(12,2) NOT NULL,
  `image_url` VARCHAR(255) NULL,
  `amenities` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng rooms
CREATE TABLE IF NOT EXISTS `rooms` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `hotel_id` INT NOT NULL,
  `room_type_id` INT NOT NULL,
  `room_number` VARCHAR(20) NOT NULL,
  `status` ENUM('AVAILABLE', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`room_type_id`) REFERENCES `room_types`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_hotel_room` (`hotel_id`, `room_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng bookings
CREATE TABLE IF NOT EXISTS `bookings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `booking_code` VARCHAR(30) NOT NULL UNIQUE,
  `user_id` INT NOT NULL,
  `room_id` INT NOT NULL,
  `check_in` DATE NOT NULL,
  `check_out` DATE NOT NULL,
  `guest_name` VARCHAR(100) NOT NULL,
  `guest_phone` VARCHAR(20) NOT NULL,
  `guest_email` VARCHAR(100) NOT NULL,
  `total_price` DECIMAL(12,2) NOT NULL,
  `status` ENUM('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'CONFIRMED',
  `payment_method` VARCHAR(50) NOT NULL DEFAULT 'PAY_AT_HOTEL',
  `payment_status` ENUM('UNPAID', 'PAID') NOT NULL DEFAULT 'UNPAID',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`room_id`) REFERENCES `rooms`(`id`) ON DELETE CASCADE,
  INDEX `idx_bookings_user` (`user_id`),
  INDEX `idx_bookings_dates` (`room_id`, `check_in`, `check_out`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bảng reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `hotel_id` INT NOT NULL,
  `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  `comment` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`hotel_id`) REFERENCES `hotels`(`id`) ON DELETE CASCADE,
  INDEX `idx_reviews_hotel` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
