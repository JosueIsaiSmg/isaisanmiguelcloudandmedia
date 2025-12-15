<?php
namespace App\Controllers;

use PDO;

class OrderController extends BaseController
{
    public function index(): void
    {
        try {
            $stmt = $this->pdo->query("
                SELECT
                    o.id,
                    o.client_id,
                    o.package_id,
                    o.country,
                    o.price_cents,
                    o.currency,
                    o.status,
                    o.scheduled_at,
                    o.installed_at,
                    o.notes,
                    o.created_at,
                    c.name as client_name,
                    p.name as package_name
                FROM orders o
                LEFT JOIN clients c ON o.client_id = c.id
                LEFT JOIN packages p ON o.package_id = p.id
                ORDER BY o.created_at DESC
            ");
            $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $this->jsonResponse(['orders' => $orders]);
        } catch (\Exception $e) {
            echo "Database error in index: " . $e->getMessage();
        }
    }

    public function show(int $id): void
    {
        try {
            $stmt = $this->pdo->prepare("
                SELECT
                    o.id,
                    o.client_id,
                    o.package_id,
                    o.country,
                    o.price_cents,
                    o.currency,
                    o.status,
                    o.scheduled_at,
                    o.installed_at,
                    o.notes,
                    o.created_at,
                    o.updated_at,
                    c.name as client_name,
                    c.email as client_email,
                    c.phone as client_phone,
                    p.name as package_name,
                    p.slug as package_slug
                FROM orders o
                LEFT JOIN clients c ON o.client_id = c.id
                LEFT JOIN packages p ON o.package_id = p.id
                WHERE o.id = ?
            ");
            $stmt->execute([$id]);
            $order = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$order) {
                $this->jsonResponse(['error' => 'Order not found'], 404);
                return;
            }

            $this->jsonResponse(['order' => $order]);
        } catch (\Exception $e) {
            echo "Database error in show: " . $e->getMessage();
        }
    }

    public function store(): void
    {
        try {
            $data = $this->getJsonInput();

            $errors = $this->validateRequired($data, ['client_id', 'package_id', 'country']);
            if (!empty($errors)) {
                $this->jsonResponse(['errors' => $errors], 400);
                return;
            }

            // Get package price for the country
            $stmt = $this->pdo->prepare("
                SELECT price_cents, currency FROM package_prices
                WHERE package_id = ? AND country = ?
            ");
            $stmt->execute([$data['package_id'], $data['country']]);
            $priceInfo = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$priceInfo) {
                $this->jsonResponse(['error' => 'Package price not found for this country'], 400);
                return;
            }

            $stmt = $this->pdo->prepare("
                INSERT INTO orders (client_id, package_id, country, price_cents, currency, status, scheduled_at, notes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ");

            $stmt->execute([
                $data['client_id'],
                $data['package_id'],
                $data['country'],
                $priceInfo['price_cents'],
                $priceInfo['currency'],
                $data['status'] ?? 'pending',
                $data['scheduled_at'] ?? null,
                $data['notes'] ?? null
            ]);

            $orderId = $this->pdo->lastInsertId();

            $this->jsonResponse([
                'message' => 'Order created successfully',
                'order_id' => $orderId,
                'price_cents' => $priceInfo['price_cents'],
                'currency' => $priceInfo['currency']
            ], 201);
        } catch (\Exception $e) {
            echo "Database error in store: " . $e->getMessage();
        }
    }

    public function update(int $id): void
    {
        try {
            $data = $this->getJsonInput();

            // Check if order exists
            $stmt = $this->pdo->prepare("SELECT id FROM orders WHERE id = ?");
            $stmt->execute([$id]);
            if (!$stmt->fetch()) {
                $this->jsonResponse(['error' => 'Order not found'], 404);
                return;
            }

            $stmt = $this->pdo->prepare("
                UPDATE orders
                SET status = ?, scheduled_at = ?, installed_at = ?, notes = ?, updated_at = NOW()
                WHERE id = ?
            ");

            $installedAt = null;
            if (isset($data['status']) && $data['status'] === 'installed' && !isset($data['installed_at'])) {
                $installedAt = date('Y-m-d H:i:s');
            } elseif (isset($data['installed_at'])) {
                $installedAt = $data['installed_at'];
            }

            $stmt->execute([
                $data['status'] ?? null,
                $data['scheduled_at'] ?? null,
                $installedAt,
                $data['notes'] ?? null,
                $id
            ]);

            $this->jsonResponse(['message' => 'Order updated successfully']);
        } catch (\Exception $e) {
            echo "Database error in update: " . $e->getMessage();
        }
    }

    public function destroy(int $id): void
    {
        try {
            $stmt = $this->pdo->prepare("DELETE FROM orders WHERE id = ?");
            $stmt->execute([$id]);

            if ($stmt->rowCount() === 0) {
                $this->jsonResponse(['error' => 'Order not found'], 404);
                return;
            }

            $this->jsonResponse(['message' => 'Order deleted successfully']);
        } catch (\Exception $e) {
            echo "Database error in destroy: " . $e->getMessage();
        }
    }
}
