-- Migration 007: Create files table
-- Metadata de archivos (contratos, recibos, pruebas de instalación)
CREATE TABLE IF NOT EXISTS files (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  client_id INT UNSIGNED DEFAULT NULL,
  order_id INT UNSIGNED DEFAULT NULL,
  ticket_id INT UNSIGNED DEFAULT NULL,
  name VARCHAR(255) NOT NULL,
  path VARCHAR(1024) NOT NULL COMMENT 'Ruta en storage o URL',
  mime VARCHAR(100) DEFAULT NULL COMMENT 'image/png, application/pdf, etc.',
  size BIGINT UNSIGNED DEFAULT NULL COMMENT 'Tamaño en bytes',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE SET NULL,
  INDEX (client_id),
  INDEX (order_id),
  INDEX (ticket_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
