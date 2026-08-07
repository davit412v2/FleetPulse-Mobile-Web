# FleetPulse Simulator v1.0

## Descripción

FleetPulse es una plataforma para el monitoreo en tiempo real de flotas vehiculares. La solución está compuesta por tres aplicaciones independientes que trabajan de manera integrada mediante APIs REST y WebSockets.

---

# Arquitectura General

```text
                    +---------------------------+
                    |  Simulador (.NET)         |
                    |---------------------------|
                    | Genera telemetría         |
                    | GPS                       |
                    | Velocidad                 |
                    | Combustible               |
                    | Temperatura               |
                    +-------------+-------------+
                                  |
                                  |
                            REST API
                                  |
                                  ▼
                    +---------------------------+
                    | Backend (.NET 9)          |
                    |---------------------------|
                    | REST API                  |
                    | JWT Authentication        |
                    | SignalR WebSocket         |
                    | Reglas de negocio         |
                    | Gestión de Alertas        |
                    | Persistencia MySQL        |
                    +-------------+-------------+
                                  |
             +--------------------+--------------------+
             |                                         |
             |                                         |
      SignalR + REST                           SignalR + REST
             |                                         |
             ▼                                         ▼
   +----------------------+               +----------------------+
   | Flutter Mobile       |               | Flutter Web          |
   |----------------------|               |----------------------|
   | Dashboard            |               | Dashboard            |
   | Mapas                |               | Mapas                |
   | Históricos           |               | Históricos           |
   | Alertas              |               | Alertas              |
   +----------------------+               +----------------------+
```

---

# Arquitectura Backend

El backend fue desarrollado utilizando **Clean Architecture**, separando las responsabilidades en diferentes proyectos.

```text
Api
│
├── Controllers
├── Hubs (SignalR)
├── Services
│
Application
│
├── Features
├── DTOs
├── Interfaces
│
Domain
│
├── Entities
├── Interfaces
├── Enums
│
Infrastructure
│
├── Persistence
├── Repositories
├── Configurations
├── Migrations
```

### Tecnologías utilizadas

- .NET 9
- ASP.NET Core Web API
- Entity Framework Core
- WebSocket
- JWT Authentication
- MySQL
- Repository Pattern
- Dependency Injection

---

# Arquitectura Frontend

Se desarrolló un único proyecto Flutter compatible con Android, iOS y Web.

```text
lib
│
├── app
│
├── core
│   ├── constants
│   ├── network
│   ├── websocket
│   ├── storage
│   └── theme
│
├── features
│   ├── authentication
│   ├── dashboard
│   ├── telemetry
│   ├── alerts
│   ├── master_data
└── 
```

### Tecnologías utilizadas

- Flutter
- Riverpod
- GoRouter
- SignalR
- Google Maps
- Syncfusion Charts
- Flutter Secure Storage

---

# Flujo de la solución

1. El **Simulador** genera datos de telemetría para múltiples vehículos.
2. La información es enviada al **Backend** mediante una API REST.
3. El Backend:
   - Almacena la información en MySQL.
   - Evalúa las reglas de negocio.
   - Genera alertas cuando corresponde.
   - Publica la telemetría y las alertas mediante WebSocket.
4. Las aplicaciones Flutter reciben la información en tiempo real mediante WebSocket y consumen los servicios REST para consultar históricos y demás información.

---

# Ejecución del proyecto en local

## 1. Clonar los repositorios

Backend

```bash
git clone https://github.com/davit412v2/FleetPulse-backend
```

Frontend

```bash
git clone https://github.com/davit412v2/FleetPulse-Mobile-Web
```

---

## 2. Instalar MySQL

Instalar una instancia de MySQL y verificar que esté disponible en el puerto:

```
3306
```

La cadena de conexión se encuentra en:

```
FleetPulse-backend/Api/appsettings.json
```

Modificarla si es necesario.

---

## 3. Crear la base de datos

Desde la raíz del proyecto Backend ejecutar:

```bash
dotnet ef database update
```

Este comando aplicará todas las migraciones existentes y creará automáticamente la estructura de la base de datos.

---

## 4. Configurar el Firewall

Permitir conexiones de entrada para el puerto:

```
5116
```

---

## 5. Configurar la IP del Backend

Consultar la dirección IP local del equipo y modificar el archivo:

```
Api/Properties/launchSettings.json
```

Actualizar los valores de:

```json
"http": "http://IP_LOCAL:5116"

"https": "https://localhost:7253;http://IP_LOCAL:5116"
```

---

## 6. Ejecutar el Backend

Desde la raíz del proyecto:

```bash
dotnet run --project Api
```

Durante el inicio se ejecutará automáticamente el proceso de carga de datos iniciales (Seed), creando la información necesaria para trabajar con el sistema, incluyendo:

- Usuarios
- Conductores
- Vehículos
- Rutas

---

## 7. Ejecutar el Simulador

Abrir una nueva terminal.

Ir a:

```
FleetPulse-backend/Simulator
```

Ejecutar:

```bash
dotnet run
```

El simulador comenzará a generar información de telemetría para todos los vehículos registrados.

En la consola se podrá observar un mensaje similar a:

```
📡 Telemetría enviada para 8 vehículos
```

Sin el simulador no será posible visualizar:

- Movimiento de vehículos.
- Historial de telemetría.
- Alertas en tiempo real.

---

# Ejecutar Flutter Web

## 8. Configurar la URL del Backend

Modificar el archivo:

```
lib/core/constants/app_constants.dart
```

Actualizar únicamente la dirección IP en:

```dart
baseUrl
```

```dart
wsUrl
```

No modificar los puertos ni las rutas.

---

## 9. Generar archivos de Riverpod

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 10. Ejecutar Flutter Web

```bash
flutter run -d chrome
```

---

# Ejecutar Flutter Android

Realizar previamente los pasos **1 al 9**.

Generar el APK:

```bash
flutter build apk --debug
```

El APK será generado en:

```
build/app/outputs/flutter-apk
```

Instalar el APK en el dispositivo Android.

> **Importante:** El dispositivo móvil debe estar conectado a la misma red local donde se encuentra ejecutándose el Backend. Se recomienda utilizar la misma red WiFi y evitar el uso de repetidores o redes aisladas.

---

# Credenciales por defecto

```
Usuario:
admin@fp.com

Contraseña:
Admin123
```

---

# Puertos utilizados

| Servicio | Puerto |
|----------|--------|
| Backend API | 5116 |
| Backend HTTPS | 7253 |
| MySQL | 3306 |

---

# Tecnologías

## Backend

- .NET 9
- ASP.NET Core
- Entity Framework Core
- SignalR
- JWT
- MySQL

## Frontend

- Flutter
- Riverpod
- GoRouter
- Google Maps
- Syncfusion Charts
- SignalR