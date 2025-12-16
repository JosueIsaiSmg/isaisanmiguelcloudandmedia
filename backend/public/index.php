<?php
header('Content-Type: application/json; charset=UTF-8');

ini_set('display_errors', 1);
error_reporting(E_ALL);
// Front controller
require_once __DIR__ . '/../vendor/autoload.php'; // Composer autoloader first
require_once __DIR__ . '/../config.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

// CORS headers for frontend
header('Access-Control-Allow-Origin: http://localhost:5173');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($method === 'OPTIONS') {
    exit(0);
}

// API Routes
if (strpos($uri, '/api/') === 0) {
    $apiPath = str_replace('/api/', '', $uri);
    $parts = explode('/', trim($apiPath, '/'));
    $resource = $parts[0] ?? '';
    $id = isset($parts[1]) && is_numeric($parts[1]) ? (int)$parts[1] : null;

    try {
        switch ($resource) {
            case 'packages':
                $controller = new App\Controllers\PackageController();
                if ($method === 'GET') {
                    if ($id) {
                        $controller->show($id);
                    } else {
                        $controller->index();
                    }
                }
                break;

            case 'clients':
                $controller = new App\Controllers\ClientController();
                if ($method === 'GET') {
                    if ($id) {
                        $controller->show($id);
                    } else {
                        $controller->index();
                    }
                } elseif ($method === 'POST') {
                    $controller->store();
                } elseif ($method === 'PUT' && $id) {
                    $controller->update($id);
                } elseif ($method === 'DELETE' && $id) {
                    $controller->destroy($id);
                }
                break;

            case 'orders':
                $controller = new App\Controllers\OrderController();
                if ($method === 'GET') {
                    if ($id) {
                        $controller->show($id);
                    } else {
                        $controller->index();
                    }
                } elseif ($method === 'POST') {
                    $controller->store();
                } elseif ($method === 'PUT' && $id) {
                    $controller->update($id);
                } elseif ($method === 'DELETE' && $id) {
                    $controller->destroy($id);
                }
                break;

            default:
                http_response_code(404);
                echo json_encode(['error' => 'API endpoint not found']);
                break;
        }
    } catch (Throwable $e) {
        http_response_code(500);
        var_dump($e);
        exit;
    }
    exit;
}

// Web routes
if ($uri === '/' || $uri === '/index.php') {
    // Página estática sin conexión a BD
    $html = <<<HTML
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Cloud & Media - Backend</title>
</head>
<body>
  <h1>Backend API</h1>
  <p>API REST disponible en /api/</p>
  <ul>
    <li><a href="/api/packages">GET /api/packages</a></li>
    <li><a href="/api/clients">GET /api/clients</a></li>
    <li><a href="/api/orders">GET /api/orders</a></li>
  </ul>
  <p>Frontend: <a href="http://localhost:5173">http://localhost:5173</a></p>
</body>
</html>
HTML;
    echo $html;
    exit;
}

http_response_code(404);
echo "Not Found";
