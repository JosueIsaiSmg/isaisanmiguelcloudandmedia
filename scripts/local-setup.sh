#!/bin/bash

# Local Development Setup (Sin Docker)
# Ejecutar: bash scripts/local-setup.sh

set -e

echo "🚀 Cloud & Media - Local Development Setup"
echo "=========================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar PHP
if ! command -v php &> /dev/null; then
    echo -e "${RED}❌ PHP no está instalado${NC}"
    exit 1
fi

PHP_VERSION=$(php -v | head -n 1)
echo -e "${GREEN}✓ $PHP_VERSION${NC}"

# Verificar MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}❌ MySQL no está instalado${NC}"
    echo "Instala con: sudo apt-get install mysql-server"
    exit 1
fi

MYSQL_VERSION=$(mysql --version)
echo -e "${GREEN}✓ $MYSQL_VERSION${NC}"

# Verificar Node/npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm no está instalado${NC}"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo -e "${GREEN}✓ npm v$NPM_VERSION${NC}"

# Crear .env
if [ ! -f backend/.env ]; then
    echo -e "${YELLOW}ℹ️  Creando backend/.env${NC}"
    cp backend/.env.example backend/.env
    # Para desarrollo local, usar localhost
    sed -i 's/DB_HOST=.*/DB_HOST=127.0.0.1/' backend/.env
    echo -e "${GREEN}✓ backend/.env creado${NC}"
fi

# Crear directorios
mkdir -p storage/logs storage/uploads
chmod -R 775 storage 2>/dev/null || true

# Instalar dependencias PHP
if [ ! -d "backend/vendor" ]; then
    echo -e "${YELLOW}ℹ️  Instalando dependencias PHP...${NC}"
    cd backend
    if command -v composer &> /dev/null; then
        composer install
    else
        echo -e "${YELLOW}⚠️  Composer no instalado. Instalando...${NC}"
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
        composer install
    fi
    cd ..
    echo -e "${GREEN}✓ Dependencias PHP instaladas${NC}"
fi

# Instalar dependencias frontend
if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}ℹ️  Instalando dependencias frontend...${NC}"
    cd frontend
    npm install
    cd ..
    echo -e "${GREEN}✓ Dependencias frontend instaladas${NC}"
fi

# Configurar MySQL
echo -e "${YELLOW}ℹ️  Configurando base de datos...${NC}"

# Verificar si la BD existe
if ! mysql -u root -e "USE cloudmedia" 2>/dev/null; then
    echo -e "${BLUE}  Creando base de datos cloudmedia...${NC}"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS cloudmedia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo -e "${GREEN}  ✓ Base de datos creada${NC}"
fi

# Ejecutar migraciones
echo -e "${BLUE}  Ejecutando migraciones...${NC}"
cat backend/migrations/*.sql | mysql -u root cloudmedia 2>/dev/null || true
echo -e "${GREEN}  ✓ Migraciones completadas${NC}"

echo ""
echo -e "${GREEN}✓ Setup local completado${NC}"
echo ""
echo "Próximos pasos:"
echo ""
echo "1️⃣  En una terminal, inicia el backend:"
echo -e "${BLUE}   cd backend && php -S 127.0.0.1:8000 -t public${NC}"
echo ""
echo "2️⃣  En otra terminal, inicia el frontend:"
echo -e "${BLUE}   cd frontend && npm run dev${NC}"
echo ""
echo "URLs disponibles:"
echo -e "  Backend (API):  ${BLUE}http://localhost:8000${NC}"
echo -e "  Frontend (UI):  ${BLUE}http://localhost:5173${NC}"
echo ""
echo "Comandos útiles:"
echo -e "  ${YELLOW}mysql -u root cloudmedia${NC}       # Acceder a MySQL"
echo -e "  ${YELLOW}php backend/migrate.php${NC}        # Ejecutar migraciones desde PHP"
echo -e "  ${YELLOW}cd frontend && npm run build${NC}   # Build para producción"
echo ""
