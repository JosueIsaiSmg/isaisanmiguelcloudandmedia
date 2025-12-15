<?php
namespace App\Controllers;

use App\Database\Connection;
use PDO;
use Exception;

abstract class BaseController
{
    protected PDO $pdo;

    public function __construct()
    {
        try {
            $this->pdo = Connection::getPDO();
            error_log("BaseController: Conexión exitosa");
        } catch (Exception $e) {
            error_log("BaseController: Error de conexión - " . $e->getMessage());
            // Mostrar error en pantalla para debugging
            echo "Database connection error: " . $e->getMessage();
            exit;
        }
    }

    protected function jsonResponse(array $data, int $statusCode = 200): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    protected function getJsonInput(): array
    {
        $input = file_get_contents('php://input');
        return json_decode($input, true) ?: [];
    }

    protected function validateRequired(array $data, array $requiredFields): array
    {
        $errors = [];
        foreach ($requiredFields as $field) {
            if (!isset($data[$field]) || empty($data[$field])) {
                $errors[] = "Field '$field' is required";
            }
        }
        return $errors;
    }

    protected function getIdFromUri(): ?int
    {
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $parts = explode('/', trim($uri, '/'));
        $id = end($parts);
        return is_numeric($id) ? (int)$id : null;
    }
}
