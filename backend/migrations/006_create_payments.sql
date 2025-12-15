-- Migration 006: Create payments table
-- Registro de pagos por órdenes o a cuenta del cliente
CREATE TABLE IF NOT EXISTS payments (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  client_id INT UNSIGNED NOT NULL,
  order_id INT UNSIGNED DEFAULT NULL,
  amount_cents INT UNSIGNED NOT NULL COMMENT 'Monto en centavos',
  currency VARCHAR(8) NOT NULL DEFAULT 'MXN',
  method VARCHAR(50) DEFAULT NULL COMMENT 'cash, card, bank_transfer, etc.',
  status ENUM('pending','completed','failed','refunded') NOT NULL DEFAULT 'pending',
  reference VARCHAR(255) DEFAULT NULL COMMENT 'ID de transacción o comprobante',
  paid_at DATETIME DEFAULT NULL COMMENT 'Fecha en que se completó',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  INDEX (status),
  INDEX (client_id),
  INDEX (order_id),
  INDEX (paid_at),
  INDEX (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
