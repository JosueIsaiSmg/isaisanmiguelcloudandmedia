<?php
namespace App\Controllers;

use PDO;

class PackageController extends BaseController
{
    public function index(): void
    {
        try {
            $country = $_GET['country'] ?? 'MX'; // Default México

            $stmt = $this->pdo->prepare("
                SELECT
                    p.id,
                    p.slug,
                    p.name,
                    p.description,
                    pp.price_cents,
                    pp.currency,
                    pp.extra_ticket_price_cents
                FROM packages p
                LEFT JOIN package_prices pp ON p.id = pp.package_id AND pp.country = ?
                ORDER BY p.id
            ");
            $stmt->execute([$country]);
            $packages = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $this->jsonResponse(['packages' => $packages]);
        } catch (\Exception $e) {
            echo "Database error in index: " . $e->getMessage();
        }
    }

    public function show(int $id): void
    {
        try {
            $country = $_GET['country'] ?? 'MX';

            $stmt = $this->pdo->prepare("
                SELECT
                    p.id,
                    p.slug,
                    p.name,
                    p.description,
                    pp.price_cents,
                    pp.currency,
                    pp.extra_ticket_price_cents
                FROM packages p
                LEFT JOIN package_prices pp ON p.id = pp.package_id AND pp.country = ?
                WHERE p.id = ?
            ");
            $stmt->execute([$country, $id]);
            $package = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$package) {
                $this->jsonResponse(['error' => 'Package not found'], 404);
                return;
            }

            $this->jsonResponse(['package' => $package]);
        } catch (\Exception $e) {
            echo "Database error in show: " . $e->getMessage();
        }
    }
}
