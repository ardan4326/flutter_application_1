-- flutter_login_db.sql
-- Paste file ini ke phpMyAdmin -> SQL -> Run

CREATE DATABASE IF NOT EXISTS `flutter_login_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `flutter_login_db`;

CREATE TABLE IF NOT EXISTS `users` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) DEFAULT NULL,
  `email` VARCHAR(150) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(20) DEFAULT NULL,
  `address` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Contoh: jangan masukkan password plaintext.
-- Untuk menambahkan user pertama, gunakan script PHP register.php
-- Contoh penggunaan (curl):
-- curl -X POST -d "email=admin@example.com&password=secret123&name=Admin" http://your-server/backend/register.php
