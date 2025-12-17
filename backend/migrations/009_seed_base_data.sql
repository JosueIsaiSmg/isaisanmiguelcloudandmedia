-- Migration 009: Seed/Update base packages con includes e ideal_for
INSERT INTO packages (slug, name, description, includes, ideal_for)
VALUES
(
  'owncloud',
  'OwnCloud - Nube Privada',
  'Instalación de servidor OwnCloud para almacenamiento privado de archivos, sincronización y seguridad.',
  'Instalación de servidor OwnCloud en equipo del cliente o VPS.
   1 usuario administrador listo para gestionar y crear más usuarios.
   Configuración básica de almacenamiento y sincronización de archivos.
   Acceso vía web y aplicaciones móviles.
   Seguridad: HTTPS, control de permisos y cifrado de datos.',
  'Empresas o usuarios que necesitan compartir documentos, fotos y archivos de forma privada y segura.'
),
(
  'jellyfin',
  'Jellyfin - Streaming Multimedia',
  'Instalación de servidor Jellyfin para streaming de música, películas y videos. Tu Netflix privado.',
  'Instalación de servidor Jellyfin para música, películas y videos.
   Configuración inicial para acceso desde cualquier dispositivo (TV, móvil, PC).
   Organización automática de biblioteca multimedia con carátulas y metadatos.
   1 usuario administrador para gestionar contenido.',
  'Usuarios que quieren un “Netflix privado” para su colección de música y películas.'
),
(
  'total',
  'Paquete Total - Nube + Streaming',
  'Instalación completa: OwnCloud + Jellyfin integrados en un solo servidor.',
  'Instalación de OwnCloud con usuario administrador y gestión de archivos.
   Instalación de Jellyfin para streaming multimedia.
   Integración opcional: acceso unificado con las mismas credenciales.
   Configuración de seguridad y optimización de red para ambos servicios.',
  'Clientes que desean tener todo en un solo servidor: nube privada para documentos y streaming multimedia para entretenimiento.'
)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  description = VALUES(description),
  includes = VALUES(includes),
  ideal_for = VALUES(ideal_for);


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
