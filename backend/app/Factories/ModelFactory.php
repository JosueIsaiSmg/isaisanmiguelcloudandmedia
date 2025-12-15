<?php
namespace App\Factories;

class ModelFactory
{
    public static function make(string $model, array $attributes = [])
    {
        $class = '\\stdClass';
        // aquí podrías mapear nombres a clases reales
        $obj = new $class();
        foreach ($attributes as $k => $v) {
            $obj->{$k} = $v;
        }
        return $obj;
    }
}
