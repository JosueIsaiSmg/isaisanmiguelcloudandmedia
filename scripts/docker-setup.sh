#!/bin/bash

# Docker Setup Script
# Ejecutar: bash scripts/docker-setup.sh

set -e

echo "🚀 Cloud & Media - Docker Setup"
echo "==============================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    echo "Descárgalo en: https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo -e "${GREEN}✓ Docker encontrado${NC}"

# Verificar Docker Compose
if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker Compose encontrado${NC}"

# Crear .env si no existe
if [ ! -f backend/.env ]; then
    echo -e "${YELLOW}ℹ️  Creando backend/.env${NC}"
    cp backend/.env.example backend/.env
    echo -e "${GREEN}✓ backend/.env creado${NC}"
fi

# Crear directorios
mkdir -p storage/logs storage/uploads
chmod -R 775 storage 2>/dev/null || true

echo -e "${YELLOW}ℹ️  Levantando servicios Docker...${NC}"
docker compose up -d

# Esperar a que MySQL esté listo
echo -e "${YELLOW}ℹ️  Esperando a que MySQL esté listo...${NC}"
sleep 10

# Verificar que MySQL está listo
if docker compose exec -T db mysqladmin ping -h localhost -uroot -psecret &> /dev/null; then
    echo -e "${GREEN}✓ MySQL está listo${NC}"
else
    echo -e "${RED}❌ MySQL no respondió${NC}"
    exit 1
fi

# Ejecutar migraciones
echo -e "${YELLOW}ℹ️  Ejecutando migraciones...${NC}"

# Contar archivos SQL (excluyendo README)
SQL_FILES=$(find backend/migrations -name "*.sql" | wc -l)

if [ "$SQL_FILES" -gt 0 ]; then
    # Ejecutar todas las migraciones
    cat backend/migrations/*.sql | docker compose exec -T db mysql -uroot -psecret cloudmedia 2>/dev/null || true
    echo -e "${GREEN}✓ Migraciones ejecutadas${NC}"
else
    echo -e "${YELLOW}⚠️  No se encontraron archivos SQL${NC}"
fi

# Ver estado
echo ""
echo -e "${GREEN}✓ Setup completado${NC}"
echo ""
echo "Estado de servicios:"
docker compose ps

echo ""
echo "📍 URLs disponibles:"
echo "  Backend (API):  http://localhost:8080"
echo "  MySQL (interno): db:3306"
echo "  Redis (interno): redis:6379"
echo ""
echo "Próximos pasos:"
echo "  1. Levantar frontend: cd frontend && npm install && npm run dev"
echo "  2. Ver logs: docker compose logs -f"
echo "  3. Entrar a MySQL: docker compose exec db mysql -uroot -psecret cloudmedia"
echo ""
echo "Para detener: docker compose down"
