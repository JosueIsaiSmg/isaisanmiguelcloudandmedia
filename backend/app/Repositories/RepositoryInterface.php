<?php
namespace App\Repositories;

interface RepositoryInterface
{
    public function findAll(): array;
    public function findById(int $id): ?array;
    public function save(array $data): bool;
    public function delete(int $id): bool;
}
