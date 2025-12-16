<?php
namespace App\Database;

class Connection
{
    private static ?\PDO $pdo = null;

    public static function getPDO(): \PDO
    {
        if (self::$pdo instanceof \PDO) {
            return self::$pdo;
        }

        $config = require __DIR__ . '/../../config.php';
        $db = $config['db'];

        $dsn = sprintf('mysql:host=%s;port=%s;dbname=%s;charset=%s', $db['host'], $db['port'], $db['database'], $db['charset']);

        try {
            self::$pdo = new \PDO($dsn, $db['username'], $db['password'], [
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
                \PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
                \PDO::ATTR_EMULATE_PREPARES => false,
            ]);
        } catch (\PDOException $e) {
            throw $e;
        }

        return self::$pdo;
    }
}
