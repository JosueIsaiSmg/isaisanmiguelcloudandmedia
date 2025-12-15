<?php
namespace App\Repositories;

use App\Database\Connection;

class FileRepository implements RepositoryInterface
{
    private \PDO $pdo;

    public function __construct()
    {
        $this->pdo = Connection::getPDO();
    }

    public function findAll(): array
    {
        $stmt = $this->pdo->query('SELECT * FROM files ORDER BY id DESC');
        return $stmt->fetchAll();
    }

    public function findById(int $id): ?array
    {
        $stmt = $this->pdo->prepare('SELECT * FROM files WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    public function save(array $data): bool
    {
        if (isset($data['id'])) {
            $stmt = $this->pdo->prepare('UPDATE files SET name = :name, path = :path WHERE id = :id');
            return $stmt->execute(['name' => $data['name'], 'path' => $data['path'], 'id' => $data['id']]);
        }
        $stmt = $this->pdo->prepare('INSERT INTO files (name, path) VALUES (:name, :path)');
        return $stmt->execute(['name' => $data['name'], 'path' => $data['path']]);
    }

    public function delete(int $id): bool
    {
        $stmt = $this->pdo->prepare('DELETE FROM files WHERE id = :id');
        return $stmt->execute(['id' => $id]);
    }
}
