# 🚛 FleetPulse

> Plataforma de monitoreo IoT para flotas vehiculares desarrollada con **.NET 9**, **Flutter**, **SignalR** y **MySQL**.

FleetPulse es un proyecto Full Stack que simula la operación de una flota de vehículos, permitiendo visualizar en tiempo real la ubicación de cada vehículo, su telemetría, históricos y alertas inteligentes mediante una arquitectura moderna basada en eventos.

---

# 👨‍💻 Desarrollador

## Luis David Barriga Garay

**Software Engineer | Flutter Developer | .NET Developer**

- 📍 Bogotá D.C., Colombia
- 💼 LinkedIn: https://www.linkedin.com/in/luis-david-barriga-garay-48b67b175/
- 🐙 GitHub: https://github.com/davit412v2/

---

# 📖 Descripción

FleetPulse es una plataforma compuesta por tres aplicaciones que trabajan de forma integrada:

- Un **Simulador** encargado de generar información de telemetría.
- Un **Backend** encargado del procesamiento, almacenamiento y publicación de eventos.
- Una aplicación **Flutter (Web y Mobile)** encargada de visualizar toda la información en tiempo real.

La solución fue diseñada como un proyecto demostrativo para mostrar la implementación de una arquitectura moderna utilizando tecnologías actuales del ecosistema .NET y Flutter.

---

# 🏗 Arquitectura General

```text
                    +---------------------------+
                    |   Simulator (.NET 9)      |
                    |---------------------------|
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
                    |     Backend (.NET 9)      |
                    |---------------------------|
                    | REST API                  |
                    | JWT Authentication        |
                    | SignalR                   |
                    | Alert Engine              |
                    | MySQL                     |
                    +-------------+-------------+
                                  |
              +-------------------+-------------------+
              |                                       |
         REST + SignalR                         REST + SignalR
              |                                       |
              ▼                                       ▼
     +----------------------+              +----------------------+
     | Flutter Mobile       |              | Flutter Web          |
     |----------------------|              |----------------------|
     | Dashboard            |              | Dashboard            |
     | Google Maps          |              | Google Maps          |
     | Históricos           |              | Históricos           |
     | Alertas              |              | Alertas              |
     +----------------------+              +----------------------+
```

---

# 🖥 Backend

El Backend fue construido utilizando **Clean Architecture**, permitiendo una clara separación de responsabilidades entre la capa de presentación, aplicación, dominio e infraestructura.

## Estructura

```text
Api
│
├── Controllers
├── Hubs
├── Services
│
Application
│
├── DTOs
├── Interfaces
├── Features
├── Alert Engine
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

### Tecnologías

- .NET 9
- ASP.NET Core Web API
- Entity Framework Core
- SignalR
- JWT Authentication
- MySQL
- Dependency Injection
- Repository Pattern

---

# 📱 Frontend

Se desarrolló un único proyecto Flutter compatible con:

- Android
- iOS
- Web

## Arquitectura

```text
lib
│
├── app
│
├── core
│   ├── constants
│   ├── network
│   ├── storage
│   ├── websocket
│   └── theme
│
├── features
│   ├── authentication
│   ├── dashboard
│   ├── telemetry
│   ├── alerts
│   ├── vehicles
│   └── routes
│
└── shared
```

### Tecnologías

- Flutter
- Riverpod
- GoRouter
- Google Maps
- SignalR
- Syncfusion Charts
- Flutter Secure Storage

---

# 🚀 Funcionalidades

## Backend

- ✅ Autenticación JWT
- ✅ Gestión de Telemetría
- ✅ Históricos
- ✅ Motor de Alertas
- ✅ WebSocket
- ✅ Persistencia en MySQL
- ✅ Simulador independiente

---

## Frontend

- ✅ Inicio de sesión
- ✅ Dashboard
- ✅ Google Maps
- ✅ Vehículos en tiempo real
- ✅ Históricos de velocidad
- ✅ Históricos de combustible
- ✅ Alertas en tiempo real
- ✅ Consumo de APIs REST
- ✅ Comunicación mediante SignalR

---

# 🔄 Flujo del proyecto

```text
                Simulador (.NET)

                       │
                       │
                 REST API
                       │
                       ▼

               Backend (.NET)

        ┌────────────────────────┐
        │ Guardar Telemetría     │
        └────────────────────────┘

                       │

        ┌────────────────────────┐
        │ Evaluar Reglas         │
        └────────────────────────┘

                       │

        ┌────────────────────────┐
        │ Generar Alertas        │
        └────────────────────────┘

                       │

                SignalR WebSocket

                       │

            ┌──────────┴──────────┐
            ▼                     ▼

      Flutter Web          Flutter Mobile
```

---

# ⚙ Requisitos

- .NET SDK 9
- Flutter SDK
- MySQL
- Google Chrome
- Android Studio (Opcional)

---

# 📂 Repositorios

### Backend

https://github.com/davit412v2/FleetPulse-backend

### Frontend

https://github.com/davit412v2/FleetPulse-Mobile-Web

---

# 📄 Licencia

Este proyecto fue desarrollado con fines educativos y de demostración técnica para mostrar la implementación de una solución completa de monitoreo IoT utilizando tecnologías modernas del ecosistema .NET y Flutter.
