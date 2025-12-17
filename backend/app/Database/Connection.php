<?php

namespace App\Database;

class Connection
{
    private static ?\PDO $pdo = null;

    public static function getPDO(): \PDO
    {
        if (self::$pdo === null) {
            $user = getenv('DB_USERNAME') ?: 'root';
            $pass = getenv('DB_PASSWORD') ?: 'secret';

            $dsn = "mysql:host=" . getenv('DB_HOST') .
                ";port=" . getenv('DB_PORT') .
                ";dbname=" . getenv('DB_DATABASE') .
                ";charset=utf8mb4";
            try {
                self::$pdo = new \PDO(
                    $dsn,
                    $user,
                    $pass,
                    [
                        \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                        \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
                        \PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
                    ]
                );
            } catch (\Exception $e) {
                error_log("Connection error: " . $e->getMessage());
                throw $e;
            }
        }
        return self::$pdo;
    }
}
