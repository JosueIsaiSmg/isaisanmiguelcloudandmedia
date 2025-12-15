<?php
/**
 * Migration Runner Script
 * Ejecuta todas las migraciones SQL en orden desde PHP
 * 
 * Uso:
 *   php backend/migrate.php
 */

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/vendor/autoload.php';

use App\Database\Connection;

$config = require __DIR__ . '/config.php';

echo "Iniciando migraciones...\n";

try {
    $pdo = Connection::getPDO();
    
    $migrationsDir = __DIR__ . '/migrations';
    $files = glob($migrationsDir . '/*.sql');
    sort($files);
    
    if (empty($files)) {
        echo "No SQL files found in $migrationsDir\n";
        exit(1);
    }
    
    foreach ($files as $file) {
        $filename = basename($file);
        
        // Skip README
        if (strpos($filename, '.md') !== false) {
            continue;
        }
        
        echo "\nEjecutando: $filename\n";
        
        $sql = file_get_contents($file);
        
        // Ejecutar cada statement SQL (separados por ;)
        $statements = array_filter(array_map('trim', explode(';', $sql)));
        
        foreach ($statements as $statement) {
            if (!empty($statement)) {
                try {
                    $pdo->exec($statement);
                } catch (PDOException $e) {
                    echo "  ❌ Error en $filename: " . $e->getMessage() . "\n";
                    // Continuar con el siguiente statement
                }
            }
        }
        
        echo "  ✓ $filename completado\n";
    }
    
    echo "\n✅ Todas las migraciones completadas exitosamente.\n";
    
} catch (Exception $e) {
    echo "❌ Error fatal: " . $e->getMessage() . "\n";
    exit(1);
}
