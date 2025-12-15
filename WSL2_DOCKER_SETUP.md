# Docker Desktop + WSL2 Integration Guide

## Problema actual

Docker Desktop está instalado en Windows, pero WSL2 no está integrado con él.

## Solución: Habilitar WSL2 Integration en Docker Desktop

### Paso 1: Abre Docker Desktop (en Windows)

1. Presiona `Win + R`
2. Escribe `Docker Desktop` y presiona Enter
3. Espera a que inicie

### Paso 2: Abre Settings

1. Haz clic en el ícono de Docker en la bandeja del sistema
2. Selecciona **Settings** (Configuración)
3. Ve a **Resources** en el menú izquierdo
4. Haz clic en **WSL Integration**

### Paso 3: Habilita WSL Integration

1. Verifica que esté marcado el checkbox **Enable integration with my default WSL distro**
2. En **Enabled distros:**, marca la distro que uses (probablemente `Ubuntu`)
3. Haz clic en **Apply & Restart**
4. Espera a que Docker Desktop reinicie (~30 segundos)

### Paso 4: Verifica la integración

Vuelve a WSL2 y ejecuta:

```bash
docker --version
docker ps
```

Si ves la versión de Docker y una lista vacía de contenedores, ¡funciona!

## Alternativa: Sin Docker (Desarrollo Local)

Si prefieres no usar Docker ahora, puedo ayudarte a:

1. **Instalar MySQL localmente** (Windows + WSL2)
2. **Ejecutar PHP con servidor interno** (`php -S`)
3. **Levantar frontend con npm**

Esto requiere:
- PHP 8.2 (probablemente ya instalado en WSL2)
- MySQL 8 (necesita instalación)
- Node.js + npm (probablemente ya instalado)

¿Cuál prefieres?
- ✅ Habilitar Docker + WSL2 Integration (recomendado, 5 minutos)
- 📝 Desarrollo local sin Docker (requiere más setup)
