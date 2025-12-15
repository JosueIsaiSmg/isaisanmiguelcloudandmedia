FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql pdo_sqlite mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy backend code
COPY backend/ /var/www/html/

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader

# Create necessary directories
RUN mkdir -p storage/logs storage/uploads && chmod -R 775 storage

# Expose port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
