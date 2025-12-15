-- Migration 002: Create package_prices table
-- Precios por país y moneda para cada paquete
CREATE TABLE IF NOT EXISTS package_prices (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  package_id INT UNSIGNED NOT NULL,
  country VARCHAR(2) NOT NULL COMMENT 'ISO country code: MX, US, etc.',
  currency VARCHAR(8) NOT NULL COMMENT 'MXN, USD, etc.',
  price_cents INT UNSIGNED NOT NULL COMMENT 'Precio en centavos (1500 MXN = 150000)',
  extra_ticket_price_cents INT UNSIGNED DEFAULT 20000 COMMENT 'Precio de soporte/ticket',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE,
  UNIQUE KEY unique_package_country (package_id, country),
  INDEX (country),
  INDEX (package_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
