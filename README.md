# IdentityProvider

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![.NET](https://img.shields.io/badge/.NET-9.0-512BD4)](https://dotnet.microsoft.com/)
[![Blazor](https://img.shields.io/badge/Blazor-Server-512BD4)](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor)
[![Azure Container Apps](https://img.shields.io/badge/Azure-Container%20Apps-0078D4)](https://azure.microsoft.com/products/container-apps)
[![IaC](https://img.shields.io/badge/IaC-Bicep-orange)](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)

A Blazor Server identity management application built on ASP.NET Core Identity that provides secure authentication, authorization, and OAuth application registration capabilities, deployable to Azure Container Apps.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#-quick-start)
- [Requirements](#-requirements)
- [Usage](#-usage)
- [Deployment](#-deployment)
- [Configuration](#%EF%B8%8F-configuration)
- [Architecture](#%EF%B8%8F-architecture)
- [Contributing](#-contributing)
- [License](#-license)

## Overview

**Overview**

IdentityProvider (Contoso Identity Provider V2.0) is a full-featured identity management web application built with ASP.NET Core Blazor Server and ASP.NET Core Identity. It provides a complete set of user authentication workflows — including registration, login, two-factor authentication, password recovery, and account management — along with an OAuth application registration interface. The project uses Entity Framework Core with SQLite for data persistence and is pre-configured for deployment to Azure Container Apps using the Azure Developer CLI (`azd`).

## ✨ Features

**Overview**

IdentityProvider delivers a comprehensive identity management experience with enterprise-grade authentication workflows, interactive server-side rendering, and cloud-native deployment support out of the box.

| Feature                         | Description                                                                                                    | Source                                                                                       |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| User Registration & Login       | Complete account creation and sign-in flows with email confirmation                                            | `Components/Account/Pages/Register.razor`, `Login.razor`                                     |
| Two-Factor Authentication       | TOTP-based 2FA with authenticator app support and recovery codes                                               | `Components/Account/Pages/Manage/EnableAuthenticator.razor`, `TwoFactorAuthentication.razor` |
| Password Management             | Password reset, change password, and forgot-password workflows                                                 | `Components/Account/Pages/ForgotPassword.razor`, `ResetPassword.razor`                       |
| External Login Providers        | Support for third-party authentication providers                                                               | `Components/Account/Pages/ExternalLogin.razor`                                               |
| OAuth App Registration          | Form-based interface for registering OAuth client applications with Client ID, Secret, Scopes, and Grant Types | `Components/Pages/AppRegistrationForm.razor`, `Components/AppRegistration.cs`                |
| Account Management              | Profile management including email change, personal data export, and account deletion                          | `Components/Account/Pages/Manage/`                                                           |
| Interactive Server Rendering    | Blazor Server with SignalR for real-time interactive UI                                                        | `Program.cs:12-13`                                                                           |
| Azure Container Apps Deployment | Pre-configured IaC with Bicep for Azure Container Apps, Container Registry, and monitoring                     | `infra/resources.bicep`, `azure.yaml`                                                        |

## 🚀 Quick Start

**Overview**

Get the application running locally in a few steps.

> [!TIP]
> Run `dotnet restore` from the solution root to restore all projects (application and tests) at once.

**1. Clone the repository**

```bash
git clone https://github.com/Evilazaro/IdentityProvider.git
cd IdentityProvider
```

**2. Restore dependencies**

```bash
dotnet restore IdentityProvider.sln
```

**3. Run the application**

```bash
cd src/IdentityProvider
dotnet run
```

**Expected output:**

```text
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:7223
      Now listening on: http://localhost:5244
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

Open `https://localhost:7223` in your browser to access the application.

**4. Run tests**

```bash
cd src/identityProviderTests
dotnet test
```

**Expected output:**

```text
Passed!  - Failed:  0, Passed:  6, Skipped:  0, Total:  6
```

## 📋 Requirements

**Overview**

The following tools and runtimes are required to build, run, and deploy the application. Only the .NET SDK is needed for local development; Azure-related tools are required only for cloud deployment.

> [!TIP]
> **Why This Matters**: The .NET 9.0 SDK includes the runtime, build tools, and the SQLite database provider is bundled via NuGet — no separate database installation is needed for local development.

> [!IMPORTANT]
> **How It Works**: The application compiles and runs entirely with `dotnet run`. EF Core auto-applies migrations in development mode, creating the SQLite database file (`identityProviderDB.db`) on first launch.

| Requirement                    | Version | Purpose                                    |
| ------------------------------ | ------- | ------------------------------------------ |
| 🟣 .NET SDK                    | 9.0+    | Build and run the application              |
| 🗄️ SQLite                      | Bundled | Local data persistence (no install needed) |
| 🔧 Azure Developer CLI (`azd`) | Latest  | Deploy to Azure Container Apps             |
| ☁️ Azure Subscription          | —       | Required for cloud deployment              |
| 🐳 Docker                      | Latest  | Container image build (for deployment)     |

## 💻 Usage

**Overview**

Once running, the application provides a web-based identity management interface with the following key workflows.

**Register a new user account**

1. Navigate to the application URL.
2. Click **Register** to create a new account.
3. Provide an email and password, then confirm your email.

**Sign in**

1. Navigate to `/Account/Login`.
2. Enter your credentials.
3. Optionally enable two-factor authentication from account settings.

**Register an OAuth application**

1. Navigate to `/AppRegistrationForm`.
2. Fill in the required fields: Client ID, Client Secret, Tenant ID, Redirect URI, Scopes, Authority, App Name, Grant Types, and Response Types.
3. Submit the form to create the registration.

## 📦 Deployment

**Overview**

The project includes Bicep-based Infrastructure as Code for deploying to Azure Container Apps using the Azure Developer CLI (`azd`). The infrastructure provisions a Container App, Container Registry, Application Insights monitoring, and a user-assigned managed identity.

> [!WARNING]
> You must authenticate with Azure CLI before running deployment commands. Run `azd auth login` before `azd up` to avoid authentication errors.

**1. Authenticate with Azure**

```bash
azd auth login
```

**2. Initialize the environment**

```bash
azd init
```

Follow the prompts to select your Azure subscription and region.

**3. Deploy to Azure**

```bash
azd up
```

**Expected output:**

```text
Deploying services (azd deploy)

  (✓) Done: Deploying service identity-provider
  - Endpoint: https://identity-provider.<region>.azurecontainerapps.io

SUCCESS: Your application was provisioned and deployed to Azure.
```

**Provisioned Azure Resources:**

| Resource                                             | Purpose                                                    |
| ---------------------------------------------------- | ---------------------------------------------------------- |
| Azure Container Apps                                 | Hosts the application container (port 8080, 1–10 replicas) |
| Azure Container Registry                             | Stores container images                                    |
| Azure Monitor (Application Insights + Log Analytics) | Application monitoring and logging                         |
| User-Assigned Managed Identity                       | Secure, passwordless authentication to Azure services      |

## ⚙️ Configuration

**Overview**

The application is configured through standard ASP.NET Core configuration files. The primary settings control the database connection and logging behavior. Azure-specific environment variables are injected automatically during container deployment.

| Parameter                               | Description                                                | Default                              | Required        |
| --------------------------------------- | ---------------------------------------------------------- | ------------------------------------ | --------------- |
| `ConnectionStrings:DefaultConnection`   | SQLite database connection string                          | `Data Source=identityProviderDB.db;` | Yes             |
| `Logging:LogLevel:Default`              | Default log verbosity                                      | `Information`                        | No              |
| `Logging:LogLevel:Microsoft.AspNetCore` | ASP.NET Core framework log level                           | `Warning`                            | No              |
| `AllowedHosts`                          | Hosts permitted to make requests                           | `*`                                  | No              |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Application Insights connection (set via Azure deployment) | —                                    | No (Azure only) |
| `AZURE_CLIENT_ID`                       | Managed identity client ID (set via Azure deployment)      | —                                    | No (Azure only) |

Configuration files:

- [src/IdentityProvider/appsettings.json](src/IdentityProvider/appsettings.json) — Production settings
- [src/IdentityProvider/appsettings.Development.json](src/IdentityProvider/appsettings.Development.json) — Development overrides

## 🏗️ Architecture

**Overview**

The application follows a layered Blazor Server architecture with ASP.NET Core Identity for authentication, Entity Framework Core for data access, and Bicep-based Infrastructure as Code for Azure deployment. Interactive server-side rendering handles all UI interactions over a persistent SignalR connection.

```mermaid
---
title: IdentityProvider Architecture
config:
  theme: base
  look: classic
  layout: dagre
  flowchart:
    htmlLabels: true
---
flowchart TB
    accTitle: IdentityProvider Application Architecture
    accDescr: Layered architecture showing client browser connecting via SignalR to Blazor Server with Identity and App Registration components backed by EF Core and SQLite and deployed to Azure Container Apps with monitoring

    %% ═══════════════════════════════════════════════════════════════════════════
    %% AZURE / FLUENT ARCHITECTURE PATTERN v1.1
    %% (Semantic + Structural + Font + Accessibility Governance)
    %% ═══════════════════════════════════════════════════════════════════════════
    %% PHASE 1 - FLUENT UI: All styling uses approved Fluent UI palette only
    %% PHASE 2 - GROUPS: Every subgraph has semantic color via style directive
    %% PHASE 3 - COMPONENTS: Every node has semantic classDef + icon prefix
    %% PHASE 4 - ACCESSIBILITY: accTitle/accDescr present, WCAG AA contrast
    %% PHASE 5 - STANDARD: Governance block present, classDefs centralized
    %% ═══════════════════════════════════════════════════════════════════════════

    subgraph client["🌐 Client"]
        Browser["🖥️ Browser"]:::external
    end

    subgraph blazor["⚙️ Blazor Server Application"]
        direction TB
        Components["📄 Razor Components"]:::core
        Identity["🔐 ASP.NET Core Identity"]:::core
        AppReg["📋 App Registration"]:::core
    end

    subgraph data["🗄️ Data Layer"]
        EFCore["🔗 Entity Framework Core"]:::neutral
        SQLite["💾 SQLite Database"]:::neutral
    end

    subgraph azure["☁️ Azure Infrastructure"]
        ContainerApp["📦 Azure Container Apps"]:::success
        ACR["🐳 Azure Container Registry"]:::success
        Monitor["📊 Azure Monitor"]:::success
        ManagedId["🔑 Managed Identity"]:::success
    end

    Browser -->|"SignalR WebSocket"| Components
    Components -->|"Auth Flows"| Identity
    Components -->|"OAuth Mgmt"| AppReg
    Identity -->|"Query"| EFCore
    AppReg -->|"Query"| EFCore
    EFCore -->|"Read/Write"| SQLite
    blazor -->|"Deploy"| ContainerApp
    ContainerApp -->|"Pull Image"| ACR
    ContainerApp -->|"Telemetry"| Monitor
    ContainerApp -->|"Authenticate"| ManagedId

    style client fill:#E0F7F7,stroke:#038387,stroke-width:2px,color:#323130
    style blazor fill:#EFF6FC,stroke:#0078D4,stroke-width:2px,color:#323130
    style data fill:#F3F2F1,stroke:#8A8886,stroke-width:2px,color:#323130
    style azure fill:#DFF6DD,stroke:#107C10,stroke-width:2px,color:#323130

    %% Centralized semantic classDefs (Phase 5 compliant)
    classDef core fill:#EFF6FC,stroke:#0078D4,stroke-width:2px,color:#323130
    classDef success fill:#DFF6DD,stroke:#107C10,stroke-width:2px,color:#323130
    classDef neutral fill:#FAFAFA,stroke:#8A8886,stroke-width:2px,color:#323130
    classDef external fill:#E0F7F7,stroke:#038387,stroke-width:2px,color:#323130
```

## 🤝 Contributing

**Overview**

Contributions are welcome. Please follow the standard GitHub workflow to propose changes.

1. Fork the repository.
2. Create a feature branch from `main`.
3. Make your changes.
4. Run the test suite to verify:

   ```bash
   dotnet test IdentityProvider.sln
   ```

5. Submit a pull request with a clear description of your changes.

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

Copyright (c) 2025 Evilázaro Alves.
