<?php
// config.php - carga variables de entorno si existen y deja constantes para la app
if (file_exists(__DIR__ . '/vendor/autoload.php')) {
    // si se instaló vlucas/phpdotenv
    try {
        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
        $dotenv->safeLoad();
    } catch (Throwable $e) {
        // Fallback: cargar manualmente si dotenv falla
        if (file_exists(__DIR__ . '/.env')) {
            $lines = file(__DIR__ . '/.env');
            foreach ($lines as $line) {
                $line = trim($line);
                if (empty($line) || strpos($line, '#') === 0) continue;
                if (strpos($line, '=') !== false) {
                    list($key, $value) = explode('=', $line, 2);
                    $key = trim($key);
                    $value = trim($value);
                    putenv($key . '=' . $value);
                    $_ENV[$key] = $value;
                }
            }
        }
    }
}

return [
    'db' => [
        'host' => getenv('DB_HOST') ?: '127.0.0.1',
        'port' => getenv('DB_PORT') ?: '3306',
        'database' => getenv('DB_DATABASE') ?: 'cloudmedia',
        'username' => getenv('DB_USERNAME') ?: 'sir1sai',
        'password' => getenv('DB_PASSWORD') ?: 'password123',
        'charset' => 'utf8mb4'
    ]
];
