-- Seed 001: Insert base packages (OwnCloud, Jellyfin, Total)
INSERT IGNORE INTO packages (slug, name, description) VALUES
('owncloud', 'OwnCloud - Nube Privada', 'Instalación de servidor OwnCloud para almacenamiento privado de archivos, sincronización y seguridad.'),
('jellyfin', 'Jellyfin - Streaming Multimedia', 'Instalación de servidor Jellyfin para streaming de música, películas y videos. Tu Netflix privado.'),
('total', 'Paquete Total - Nube + Streaming', 'Instalación completa: OwnCloud + Jellyfin integrados en un solo servidor.');

-- Seed 002: Insert package prices for Mexico (MXN)
INSERT IGNORE INTO package_prices (package_id, country, currency, price_cents, extra_ticket_price_cents) VALUES
(1, 'MX', 'MXN', 150000, 20000),  -- OwnCloud: $1,500 MXN
(2, 'MX', 'MXN', 150000, 20000),  -- Jellyfin: $1,500 MXN
(3, 'MX', 'MXN', 250000, 20000);  -- Total: $2,500 MXN

-- Seed 003: Insert package prices for USA (USD)
-- Aproximadamente: 1,500 MXN ≈ $89 USD (con tipo de cambio ~16.85)
-- 2,500 MXN ≈ $148 USD
INSERT IGNORE INTO package_prices (package_id, country, currency, price_cents, extra_ticket_price_cents) VALUES
(1, 'US', 'USD', 8900, 1200),   -- OwnCloud: $89 USD
(2, 'US', 'USD', 8900, 1200),   -- Jellyfin: $89 USD
(3, 'US', 'USD', 14800, 1200);  -- Total: $148 USD

-- Seed 004: Insert example clients
INSERT IGNORE INTO clients (name, company, email, phone, country, city, currency, notes) VALUES
('Juan Martínez', 'TechMX Corp', 'juan@techmx.com', '+52 55 1234 5678', 'MX', 'Ciudad de México', 'MXN', 'Cliente frecuente, requiere soporte en español.'),
('Sarah Johnson', 'CloudTech Inc', 'sarah@cloudtech.com', '+1 512 555 1234', 'US', 'Austin, TX', 'USD', 'Cliente en USA, requiere facturación en USD.');

-- Seed 005: Insert example orders
INSERT IGNORE INTO orders (client_id, package_id, country, price_cents, currency, status, scheduled_at, notes) VALUES
(1, 3, 'MX', 250000, 'MXN', 'pending', '2025-12-20 10:00:00', 'Orden inicial: Paquete Total para cliente México.'),
(2, 1, 'US', 8900, 'USD', 'scheduled', '2025-12-18 14:00:00', 'Orden de OwnCloud para cliente USA, programada para el 18 de diciembre.');

-- Seed 006: Insert example payment
INSERT IGNORE INTO payments (client_id, order_id, amount_cents, currency, method, status, reference, paid_at) VALUES
(2, 2, 8900, 'USD', 'card', 'completed', 'TXN-20251212-001', '2025-12-12 09:30:00');

-- Seed 007: Insert example ticket
INSERT IGNORE INTO tickets (client_id, order_id, title, description, status, priority) VALUES
(1, 1, 'Solicitud de instalación', 'Cliente solicita instalación del paquete total. Requiere acceso a OwnCloud y Jellyfin.', 'open', 'high');
