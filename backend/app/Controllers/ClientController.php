<?php
namespace App\Controllers;

use PDO;

class ClientController extends BaseController
{
    public function index(): void
    {
        try {
            $stmt = $this->pdo->query("
                SELECT id, name, company, email, phone, country, city, currency, notes, created_at
                FROM clients
                ORDER BY created_at DESC
            ");
            $clients = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $this->jsonResponse(['clients' => $clients]);
        } catch (\Exception $e) {
            echo "Database error in ClientController index: " . $e->getMessage();
        }
    }

    public function show(int $id): void
    {
        try {
            $stmt = $this->pdo->prepare("
                SELECT id, name, company, email, phone, country, city, address, currency, notes, created_at, updated_at
                FROM clients
                WHERE id = ?
            ");
            $stmt->execute([$id]);
            $client = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$client) {
                $this->jsonResponse(['error' => 'Client not found'], 404);
                return;
            }

            $this->jsonResponse(['client' => $client]);
        } catch (\Exception $e) {
            echo "Database error in ClientController show: " . $e->getMessage();
        }
    }

    public function store(): void
    {
        try {
            $data = $this->getJsonInput();

            $errors = $this->validateRequired($data, ['name', 'country']);
            if (!empty($errors)) {
                $this->jsonResponse(['errors' => $errors], 400);
                return;
            }

            $stmt = $this->pdo->prepare("
                INSERT INTO clients (name, company, email, phone, country, city, address, currency, notes)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");

            $stmt->execute([
                $data['name'],
                $data['company'] ?? null,
                $data['email'] ?? null,
                $data['phone'] ?? null,
                $data['country'] ?? 'MX',
                $data['city'] ?? null,
                $data['address'] ?? null,
                $data['currency'] ?? 'MXN',
                $data['notes'] ?? null
            ]);

            $clientId = $this->pdo->lastInsertId();

            $this->jsonResponse([
                'message' => 'Client created successfully',
                'client_id' => $clientId
            ], 201);
        } catch (\Exception $e) {
            echo "Database error in ClientController store: " . $e->getMessage();
        }
    }

    public function update(int $id): void
    {
        try {
            $data = $this->getJsonInput();

            // Check if client exists
            $stmt = $this->pdo->prepare("SELECT id FROM clients WHERE id = ?");
            $stmt->execute([$id]);
            if (!$stmt->fetch()) {
                $this->jsonResponse(['error' => 'Client not found'], 404);
                return;
            }

            $stmt = $this->pdo->prepare("
                UPDATE clients
                SET name = ?, company = ?, email = ?, phone = ?, country = ?, city = ?, address = ?, currency = ?, notes = ?, updated_at = NOW()
                WHERE id = ?
            ");

            $stmt->execute([
                $data['name'] ?? null,
                $data['company'] ?? null,
                $data['email'] ?? null,
                $data['phone'] ?? null,
                $data['country'] ?? null,
                $data['city'] ?? null,
                $data['address'] ?? null,
                $data['currency'] ?? null,
                $data['notes'] ?? null,
                $id
            ]);

            $this->jsonResponse(['message' => 'Client updated successfully']);
        } catch (\Exception $e) {
            echo "Database error in ClientController update: " . $e->getMessage();
        }
    }

    public function destroy(int $id): void
    {
        try {
            $stmt = $this->pdo->prepare("DELETE FROM clients WHERE id = ?");
            $stmt->execute([$id]);

            if ($stmt->rowCount() === 0) {
                $this->jsonResponse(['error' => 'Client not found'], 404);
                return;
            }

            $this->jsonResponse(['message' => 'Client deleted successfully']);
        } catch (\Exception $e) {
            echo "Database error in ClientController destroy: " . $e->getMessage();
        }
    }
}
