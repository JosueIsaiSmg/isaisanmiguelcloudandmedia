<?php
require_once 'config.php';
require_once 'app/Database/Connection.php';

try {
    $pdo = App\Database\Connection::getPDO();
    echo "Conexión exitosa.\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}