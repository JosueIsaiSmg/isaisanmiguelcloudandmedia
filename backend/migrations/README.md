# Migraciones de Base de Datos

Este directorio contiene las migraciones SQL para el proyecto Cloud & Media.

## Estructura

- `001_create_packages.sql` — Tabla de paquetes de servicio
- `002_create_package_prices.sql` — Precios por país y moneda
- `003_create_clients.sql` — Registro de clientes
- `004_create_orders.sql` — Órdenes/instalaciones
- `005_create_tickets.sql` — Tickets de soporte
- `006_create_payments.sql` — Registro de pagos
- `007_create_files.sql` — Metadata de archivos
- `008_create_users.sql` — Usuarios admin/operators (opcional)
- `009_seed_base_data.sql` — Datos iniciales (paquetes, clientes ejemplo)

## Cómo ejecutar

### Opción 1: Ejecutar con Docker Compose (recomendado)

Si tienes MySQL en Docker:

```bash
# Levantar MySQL si no está corriendo
docker compose up -d

# Ejecutar todas las migraciones de una vez
cat backend/migrations/*.sql | docker compose exec -T db mysql -uroot -psecret cloudmedia

# O ejecutar archivo por archivo
docker compose exec -T db mysql -uroot -psecret cloudmedia < backend/migrations/001_create_packages.sql
docker compose exec -T db mysql -uroot -psecret cloudmedia < backend/migrations/002_create_package_prices.sql
# ... (etc para cada archivo)
```

### Opción 2: Ejecutar localmente (sin Docker)

Si tienes MySQL instalado localmente:

```bash
# Ejecutar todas las migraciones
cat backend/migrations/*.sql | mysql -u root -p cloudmedia

# O entrada interactiva
mysql -u root -p cloudmedia < backend/migrations/001_create_packages.sql
```

### Opción 3: Ejecutar desde PHP (futuro)

Podrías crear un script PHP que lea y ejecute las migraciones automáticamente. Por ahora, ejecuta manualmente.

## Verificar datos

```bash
# Desde la terminal MySQL
mysql -u root -p cloudmedia

# Comandos útiles
SHOW TABLES;
SELECT * FROM packages;
SELECT * FROM clients;
SELECT * FROM orders;
```

## Notas

- Las migraciones crean tablas con `IF NOT EXISTS`, así que son idempotentes (seguro ejecutarlas múltiples veces).
- El seed (`009_seed_base_data.sql`) inserta datos de ejemplo (paquetes, clientes, órdenes).
- Todos los precios están en centavos para evitar problemas de precisión decimal.
- El campo `country` utiliza códigos ISO (MX = México, US = USA).

## Siguiente paso

Una vez ejecutadas las migraciones, puedes:
1. Crear endpoints REST en `backend/app/Controllers/Api/` para CRUD de clientes, órdenes, etc.
2. Integrar consumo desde el frontend Vue con `axios`.
3. Añadir autenticación y CORS.
