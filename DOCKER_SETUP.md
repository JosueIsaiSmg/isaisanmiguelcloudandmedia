# Docker Setup Guide - Cloud & Media

Guía completa para ejecutar el proyecto con Docker (PHP-FPM + Nginx + MySQL + Redis).

## Requisitos Previos

- **Docker**: https://www.docker.com/products/docker-desktop
- **Docker Compose**: Incluido en Docker Desktop

## Estructura de Servicios

```
┌─────────────┐
│   Nginx     │ (Puerto 8080)
│  Web Server │
└──────┬──────┘
       │
┌──────▼──────┐     ┌──────────┐     ┌───────┐
│   PHP-FPM   │────▶│  MySQL   │     │ Redis │
│  Backend    │     │ Database │     │ Cache │
└─────────────┘     └──────────┘     └───────┘
                    (Puerto 3306)    (Port 6379)
```

## Paso 1: Clonar/Preparar el proyecto

```bash
cd /home/sir1sai/projects/isaisanmiguelcloudandmedia

# Crear .env en backend (copiar del ejemplo)
cp backend/.env.example backend/.env

# Editar .env si es necesario (para Docker, mantén DB_HOST=db)
```

## Paso 2: Levantar los contenedores

```bash
# Levantar todos los servicios en background
docker compose up -d

# Ver logs en tiempo real (opcional)
docker compose logs -f

# Ver estado de los servicios
docker compose ps
```

Esto va a:
1. Construir la imagen Docker del backend (PHP 8.2 con extensiones)
2. Descargar imagen de Nginx Alpine
3. Descargar imagen de MySQL 8.0
4. Descargar imagen de Redis
5. Crear los volúmenes necesarios
6. Iniciar todos los servicios

## Paso 3: Ejecutar las migraciones SQL

Cuando MySQL esté listo (esperar ~10 segundos después de `docker compose up`):

```bash
# Opción A: Copiar SQL a la BD automáticamente (via docker-entrypoint-initdb.d)
# Los archivos en backend/migrations/ se ejecutan automáticamente al iniciar MySQL por primera vez

# Opción B: Ejecutar migraciones manualmente
docker compose exec db mysql -uroot -psecret cloudmedia < backend/migrations/001_create_packages.sql
docker compose exec db mysql -uroot -psecret cloudmedia < backend/migrations/002_create_package_prices.sql
# ... (resto de migraciones)

# Opción C: Ejecutar todas de una vez
cat backend/migrations/*.sql | docker compose exec -T db mysql -uroot -psecret cloudmedia

# Opción D: Desde PHP (si instalaste composer en el contenedor)
docker compose exec php php migrate.php
```

**Nota**: La primera vez que levantas Docker, MySQL puede tardar unos segundos en iniciar. Espera a que esté listo antes de ejecutar migraciones.

## Paso 4: Verificar que todo funciona

### Backend (API)
```bash
curl http://localhost:8080

# Deberías ver la página "Backend mínimo"
```

### Base de datos
```bash
# Acceder a MySQL
docker compose exec db mysql -uroot -psecret cloudmedia

# Comandos útiles dentro de MySQL:
SHOW TABLES;
SELECT COUNT(*) FROM packages;
SELECT * FROM clients;
```

### Logs
```bash
# Ver logs de todos los servicios
docker compose logs

# Ver logs de un servicio específico
docker compose logs php
docker compose logs nginx
docker compose logs db
```

## Paso 5: Levantar el frontend (opcional, en otra terminal)

```bash
cd frontend
npm install
npm run dev

# Abierto en http://localhost:5173
```

## Comandos útiles de Docker Compose

```bash
# Ver estado
docker compose ps

# Ver logs
docker compose logs [service_name]

# Detener servicios (sin eliminar volúmenes)
docker compose stop

# Reiniciar servicios
docker compose restart

# Eliminar todo (incluidos volúmenes) - ¡CUIDADO!
docker compose down -v

# Entrar en un contenedor
docker compose exec php bash
docker compose exec db bash
docker compose exec nginx sh

# Reconstruir imágenes (si cambian Dockerfile o composer.json)
docker compose up -d --build

# Verificar recursos
docker stats
```

## Troubleshooting

### "Cannot connect to Docker daemon"
```bash
# Asegurate de que Docker está corriendo
# En Linux: sudo systemctl start docker
# En Mac/Windows: Abre Docker Desktop
```

### "Port 8080 already in use"
```bash
# Cambiar puerto en docker-compose.yml
# ports: ['9090:80']  # Usar puerto 9090 en lugar de 8080
```

### "MySQL connection refused"
```bash
# Esperar a que MySQL esté listo
docker compose logs db

# Ver healthcheck
docker compose exec db mysqladmin ping -h localhost -uroot -psecret
```

### "Migrations no se ejecutaron"
```bash
# Si MySQL ya estaba inicializado, elimina el volumen
docker compose down -v
docker compose up -d

# O ejecuta manualmente
docker compose exec db mysql -uroot -psecret cloudmedia < backend/migrations/001_create_packages.sql
```

### "Permission denied" en archivos
```bash
# Asegurar permisos de storage
docker compose exec php chmod -R 775 /var/www/html/storage
```

## Variables de entorno

El archivo `backend/.env` se carga automáticamente. Para Docker usa:

```env
DB_HOST=db           # Nombre del servicio (no localhost)
DB_PORT=3306
DB_DATABASE=cloudmedia
DB_USERNAME=root
DB_PASSWORD=secret
APP_ENV=development
APP_DEBUG=true
FRONTEND_URL=http://localhost:5173
```

## Volúmenes compartidos

```
./backend              ↔ /var/www/html       (código PHP)
./storage              ↔ /var/www/html/storage (uploads/logs)
db_data                ↔ /var/lib/mysql      (datos persistentes)
nginx_logs             ↔ /var/log/nginx      (logs de Nginx)
```

Los cambios en `./backend` se reflejan inmediatamente en el contenedor.

## Próximos pasos

1. ✅ Levantar Docker (este documento)
2. ⏭️ Implementar endpoints REST (Controllers)
3. ⏭️ Integrar frontend con axios
4. ⏭️ Añadir autenticación JWT
5. ⏭️ Deploy a producción (considerar Docker Swarm o Kubernetes)

## Soporte

- Documentación oficial: https://docs.docker.com/
- Documentación de Docker Compose: https://docs.docker.com/compose/
- MySQL en Docker: https://hub.docker.com/_/mysql
- PHP-FPM en Docker: https://hub.docker.com/_/php

---

**¿Listo?** Ejecuta: `docker compose up -d` 🚀
