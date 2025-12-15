<?php
namespace App\Controllers;

use App\Database\Connection;

class HomeController
{
    public function index(): string
    {
        // Página sencilla que explica que el frontend corre por separado (Vite)
        $html = <<<HTML
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Cloud & Media - Backend</title>
</head>
<body>
  <h1>Backend mínimo</h1>
  <p>El frontend está pensado para correr con Vite (puerto 5173). Visita <a href="http://localhost:5173">http://localhost:5173</a></p>
</body>
</html>
HTML;

        return $html;
    }
}
