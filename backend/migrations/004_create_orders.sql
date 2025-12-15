-- Migration 004: Create orders table
-- Órdenes de instalación/contratación de paquetes
CREATE TABLE IF NOT EXISTS orders (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  client_id INT UNSIGNED NOT NULL,
  package_id INT UNSIGNED NOT NULL,
  country VARCHAR(2) DEFAULT NULL COMMENT 'País donde se instala',
  price_cents INT UNSIGNED NOT NULL COMMENT 'Precio final en centavos',
  currency VARCHAR(8) NOT NULL DEFAULT 'MXN',
  status ENUM('pending','scheduled','installed','cancelled') NOT NULL DEFAULT 'pending',
  scheduled_at DATETIME DEFAULT NULL COMMENT 'Fecha programada para instalación',
  installed_at DATETIME DEFAULT NULL COMMENT 'Fecha en que se completó la instalación',
  notes TEXT DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (package_id) REFERENCES packages(id),
  INDEX (status),
  INDEX (country),
  INDEX (client_id),
  INDEX (package_id),
  INDEX (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
