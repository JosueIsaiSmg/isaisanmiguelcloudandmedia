# isaisanmiguelcloudandmedia
Landing page to show services to install a private cloud and media streaming.

## Objetivo
Página promocional estilo Google Drive.

## Stack
- Backend: PHP 8.2 (MVC, PDO)
- Frontend: Vue 3 + Vite + Tailwind CSS
- DB: MySQL 8

## Estructura creada
- `backend/` : Esqueleto MVC con `public/index.php`, conexión PDO en `app/Database/Connection.php`, patrones `Repository` y `Factory` como ejemplo.
- `frontend/` : Proyecto Vite + Vue 3 con componentes `Card` y `PricingTable`, configuración Tailwind.
- `docker-compose.yml` : MySQL 8 para desarrollo.

## 🚀 Quick Start (Docker - Recomendado)

```bash
# Opción 1: Script automático
bash scripts/docker-setup.sh

# Opción 2: Comandos Makefile
make setup

# Opción 3: Manual
docker compose up -d
docker compose exec -T db mysql -uroot -psecret cloudmedia < backend/migrations/*.sql
```

Luego, en otra terminal:

```bash
cd frontend && npm install && npm run dev
```

**URLs disponibles:**
- Backend (API): http://localhost:8080
- Frontend: http://localhost:5173

---

## 💻 Desarrollo local (sin Docker)

1) **MySQL con Docker** (solo BD, sin PHP ni Nginx):

```bash
docker compose -f docker-compose.yml --profile db up -d
```

2) **Backend (PHP):**

```bash
cd backend
composer install
cp .env.example .env
php -S 127.0.0.1:8000 -t public
```

3) **Frontend (Vue):**

```bash
cd frontend
npm install
npm run dev
```

Para ejecutar migraciones (local):

```bash
mysql -u root -p cloudmedia < backend/migrations/001_create_packages.sql
# ... (resto de migraciones)
```

## Recomendaciones de librerías y herramientas

- Backend PHP:
	- `vlucas/phpdotenv` — gestionar variables de entorno.
	- `symfony/http-foundation` — manejo de requests/responses si quieres más organización.
	- `twig/twig` — motor de plantillas si prefieres render en server.
	- Usar Composer y PSR-4 para autoload.

- Frontend Vue:
	- `vue-router` — rutas si añades páginas.
	- `pinia` — estado global moderno para Vue 3.
	- `axios` o `ky` — para llamadas HTTP al backend.
	- `@headlessui/vue` + `heroicons` — componentes accesibles y iconografía.

## Siguientes pasos sugeridos
- Añadir migraciones SQL y seeders para la tabla `files`.
- Implementar endpoints REST para CRUD de archivos (API) y autenticación básica.
- Añadir CI, pruebas unitarias y linters (PHPStan/PSalm para PHP, ESLint+Prettier para frontend).

---
Si quieres, puedo:
- Crear las migraciones SQL y seeds.
- Añadir un endpoint API REST básico para `files`.
- Configurar autenticación mínima (token-based) y ejemplo de consumo desde Vue.

