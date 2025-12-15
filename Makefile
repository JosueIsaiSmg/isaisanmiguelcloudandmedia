# Makefile - Cloud & Media Project
# Comandos: make [comando]

.PHONY: help up down logs migrate build clean shell-php shell-db test

help:
	@echo "Cloud & Media - Comandos disponibles"
	@echo "===================================="
	@echo ""
	@echo "Docker:"
	@echo "  make up              - Levantar contenedores"
	@echo "  make down            - Detener contenedores"
	@echo "  make restart         - Reiniciar contenedores"
	@echo "  make logs            - Ver logs en tiempo real"
	@echo "  make build           - Reconstruir imágenes"
	@echo ""
	@echo "Base de datos:"
	@echo "  make migrate         - Ejecutar migraciones SQL"
	@echo "  make migrate-fresh   - Resetear BD y ejecutar migraciones"
	@echo "  make seed            - Ejecutar seeds"
	@echo "  make shell-db        - Entrar a MySQL"
	@echo ""
	@echo "Backend:"
	@echo "  make shell-php       - Entrar a contenedor PHP"
	@echo "  make composer-install - Instalar dependencias PHP"
	@echo ""
	@echo "Frontend:"
	@echo "  make npm-install     - Instalar dependencias frontend"
	@echo "  make dev             - Correr frontend en desarrollo"
	@echo ""
	@echo "Limpieza:"
	@echo "  make clean           - Eliminar contenedores y volúmenes"
	@echo "  make clean-logs      - Limpiar logs"
	@echo ""

up:
	docker compose up -d
	@echo "✓ Contenedores levantados"

down:
	docker compose down
	@echo "✓ Contenedores detenidos"

restart:
	docker compose restart
	@echo "✓ Contenedores reiniciados"

logs:
	docker compose logs -f

build:
	docker compose build
	@echo "✓ Imágenes reconstruidas"

migrate:
	@echo "Ejecutando migraciones..."
	@cat backend/migrations/*.sql | docker compose exec -T db mysql -uroot -psecret cloudmedia
	@echo "✓ Migraciones completadas"

migrate-fresh:
	@echo "Eliminando base de datos..."
	docker compose down -v
	@echo "Levantando servicios..."
	docker compose up -d
	@echo "Esperando a que MySQL esté listo..."
	@sleep 10
	@echo "Ejecutando migraciones..."
	@cat backend/migrations/*.sql | docker compose exec -T db mysql -uroot -psecret cloudmedia
	@echo "✓ Base de datos reiniciada"

seed:
	@echo "Ejecutando seeds..."
	@docker compose exec -T db mysql -uroot -psecret cloudmedia < backend/migrations/009_seed_base_data.sql
	@echo "✓ Seeds completados"

shell-php:
	docker compose exec php bash

shell-db:
	docker compose exec db mysql -uroot -psecret cloudmedia

composer-install:
	docker compose exec php composer install

npm-install:
	cd frontend && npm install

dev:
	cd frontend && npm run dev

clean:
	docker compose down -v
	@echo "✓ Contenedores y volúmenes eliminados"

clean-logs:
	rm -rf nginx_logs/*
	docker compose exec php sh -c 'rm -rf storage/logs/*'
	@echo "✓ Logs limpios"

# Combinaciones útiles
setup: up migrate seed
	@echo "✓ Setup completado"

full-setup: build up migrate seed
	@echo "✓ Full setup completado"
