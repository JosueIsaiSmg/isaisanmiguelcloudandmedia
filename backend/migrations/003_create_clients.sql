-- Migration 003: Create clients table
-- Registro de clientes (mexicanos, americanos, etc.)
CREATE TABLE IF NOT EXISTS clients (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  company VARCHAR(200) DEFAULT NULL,
  email VARCHAR(255) DEFAULT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  country VARCHAR(2) DEFAULT 'MX' COMMENT 'ISO country code',
  city VARCHAR(150) DEFAULT NULL,
  address TEXT DEFAULT NULL,
  currency VARCHAR(8) DEFAULT 'MXN' COMMENT 'Moneda preferida del cliente',
  notes TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  INDEX (country),
  INDEX (email),
  INDEX (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
