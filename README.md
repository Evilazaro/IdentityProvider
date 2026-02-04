# IdentityProvider

![.NET](https://img.shields.io/badge/.NET-9.0-512BD4?logo=dotnet)
![License](https://img.shields.io/github/license/Evilazaro/IdentityProvider)
![Build](https://img.shields.io/badge/build-passing-brightgreen)
![Azure](https://img.shields.io/badge/Azure-Container%20Apps-0078D4?logo=microsoft-azure)

A modern ASP.NET Core Blazor Server application providing secure user authentication and identity management with Azure deployment support.

This project implements ASP.NET Core Identity with Entity Framework Core, offering user registration, login, email validation, and session management. Built with Blazor Server components, it provides a responsive UI with real-time authentication state management and deploys seamlessly to Azure Container Apps using Infrastructure as Code.

## Table of Contents

- [Quick Start](#-quick-start)
- [Deployment](#-deployment)
- [Usage](#-usage)
- [Features](#-features)
- [Requirements](#-requirements)
- [Configuration](#-configuration)
- [Architecture](#-architecture)
- [Contributing](#-contributing)
- [License](#-license)

## 🚀 Quick Start

Clone the repository and run the application locally:

```bash
git clone https://github.com/Evilazaro/IdentityProvider.git
cd IdentityProvider
dotnet run --project src/IdentityProvider
```

The application starts at `https://localhost:5001` with automatic database migrations applied in development mode.

## 📦 Deployment

### Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) (for Azure deployment)
- [Azure Developer CLI (azd)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd)

### Local Development

1. **Restore dependencies:**

```bash
dotnet restore
```

2. **Apply database migrations:**

```bash
dotnet ef database update --project src/IdentityProvider
```

> 💡 **Tip**: In development mode, migrations apply automatically on application startup.

3. **Run the application:**

```bash
dotnet run --project src/IdentityProvider
```

4. **Run tests:**

```bash
dotnet test
```

### Azure Deployment

Deploy to Azure Container Apps using Azure Developer CLI:

```bash
azd auth login
azd up
```

> ⚠️ **Prerequisites**: Ensure you have Contributor access to the target Azure subscription.

This command provisions Azure resources (Container Apps, Container Registry, Log Analytics, Application Insights) and deploys the application. Infrastructure is defined in [`infra/main.bicep`](infra/main.bicep) and [`infra/resources.bicep`](infra/resources.bicep).

## 💻 Usage

### User Registration

Navigate to `/Account/Register` and create a new account with email and password:

```csharp
// Email validation example from eMail.cs
var emailChecker = new eMail();
bool isValid = emailChecker.checkEmail("user@example.com"); // Returns true
```

**Valid email domains**: `example.com`, `test.com`

### Authentication Flow

1. User registers with email and password
2. Account confirmation required (configured in [`Program.cs`](src/IdentityProvider/Program.cs))
3. User logs in to access protected pages
4. Session managed via ASP.NET Core Identity cookies

### Expected Output

After successful login, users access protected Blazor components with authentication state:

- `/` - Home page (public)
- `/counter` - Protected counter page
- `/weather` - Protected weather data page
- `/Account/Manage` - User profile management

## ✨ Features

**Overview**

This identity provider delivers a complete authentication solution built on ASP.NET Core's proven security framework. The architecture combines modern Blazor Server technology for responsive user interfaces with Entity Framework Core for robust data persistence. Every component is designed for production deployment on Azure Container Apps, enabling automatic scaling and enterprise-grade reliability.

The system implements industry-standard security practices including secure password hashing, token-based authentication, and configurable email validation. Infrastructure as Code with Bicep ensures reproducible deployments across environments, while Application Insights provides real-time monitoring and diagnostics. This integrated approach reduces development time while maintaining the flexibility to customize authentication workflows for specific business requirements.

| Feature                        | Description                                                                                       | Benefits                                                                  |
| ------------------------------ | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| ASP.NET Core Identity          | Built-in authentication system with user management, password hashing, and security token service | Industry-standard security with minimal configuration required            |
| Blazor Server Components       | Interactive UI with real-time updates using SignalR                                               | Responsive user experience without complex JavaScript frameworks          |
| Entity Framework Core          | Code-first database migrations with SQLite (dev) and SQL Server (production) support              | Type-safe data access with automatic schema management                    |
| Email Validation               | Custom email domain validation with extensible rule engine                                        | Control user registration with configurable domain whitelisting           |
| Azure Container Apps           | Serverless container deployment with automatic scaling                                            | Cost-effective hosting with built-in HTTPS, load balancing, and logging   |
| Infrastructure as Code (Bicep) | Declarative Azure resource provisioning with versioned templates                                  | Reproducible deployments with automated resource management and rollbacks |

## 📋 Requirements

**Overview**

The application targets .NET 9.0, leveraging the latest performance improvements and security features in the ASP.NET Core framework. Development environments support cross-platform development on Windows, macOS, and Linux, with SQLite providing a zero-configuration database for rapid local iteration. Production deployments can scale to Azure SQL Database or SQL Server for enterprise workloads.

All dependencies are managed through NuGet packages with specific version pinning to ensure consistent builds across development teams. The optional Azure deployment path requires an active subscription but includes free tier options for development and testing scenarios. This flexible architecture allows teams to start development immediately while maintaining a clear path to production-grade infrastructure.

| Category         | Requirements                                                                  | More Information                                                                                    |
| ---------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Runtime          | .NET 9.0 SDK or later                                                         | [Download .NET](https://dotnet.microsoft.com/download)                                              |
| System           | Windows 10+, macOS 12+, or Linux with .NET support                            | [.NET Supported OS](https://github.com/dotnet/core/blob/main/release-notes/9.0/supported-os.md)     |
| Database         | SQLite 3.x (development), SQL Server 2019+ or Azure SQL (production)          | [EF Core Database Providers](https://learn.microsoft.com/ef/core/providers)                         |
| Dependencies     | See [`IdentityProvider.csproj`](src/IdentityProvider/IdentityProvider.csproj) | Microsoft.AspNetCore.Identity.EntityFrameworkCore 9.0.3, Microsoft.EntityFrameworkCore.Sqlite 9.0.4 |
| Azure (optional) | Azure subscription with Container Apps and Container Registry                 | [Azure Free Account](https://azure.microsoft.com/free/)                                             |

## 🔧 Configuration

**Overview**

The application uses ASP.NET Core's hierarchical configuration system, combining JSON files with environment variables for maximum flexibility. Development settings in `appsettings.json` provide sensible defaults for local testing, while production configurations leverage Azure Key Vault or Container Apps environment variables for secure credential management. This separation ensures sensitive data never appears in source control.

Configuration follows the twelve-factor app methodology, allowing the same application binary to deploy across multiple environments with environment-specific settings. Identity options, database connections, and email validation rules are all externalized and can be modified without code changes. The system automatically applies Entity Framework migrations in development mode, while production deployments require explicit migration commands for controlled schema updates.

### Connection Strings

Update [`appsettings.json`](src/IdentityProvider/appsettings.json) with your database connection:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=identityProviderDB.db;"
  }
}
```

For production with SQL Server:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=tcp:yourserver.database.windows.net,1433;Database=identitydb;User ID=admin;Password=YourPassword;Encrypt=True;"
  }
}
```

### Environment Variables

Azure Container Apps automatically inject these variables (defined in [`infra/resources.bicep`](infra/resources.bicep)):

```bash
APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx
AZURE_CLIENT_ID=managed-identity-client-id
PORT=8080
```

### Email Validation Rules

Customize allowed email domains in [`src/IdentityProvider/Components/eMail.cs`](src/IdentityProvider/Components/eMail.cs):

```csharp
string[] validDomains = { "example.com", "test.com", "yourdomain.com" };
```

### Identity Options

Modify identity settings in [`Program.cs`](src/IdentityProvider/Program.cs):

```csharp
builder.Services.AddIdentityCore<ApplicationUser>(options =>
{
    options.SignIn.RequireConfirmedAccount = true; // Email confirmation required
    options.Password.RequireDigit = true;
    options.Password.RequiredLength = 8;
    options.Password.RequireNonAlphanumeric = true;
});
```

## 🏗️ Architecture

**Overview**

The system implements a layered architecture separating presentation, business logic, and data access concerns. Blazor Server components handle the interactive user interface through a persistent SignalR connection, eliminating the need for complex client-side JavaScript frameworks while maintaining rich interactivity. The presentation layer communicates exclusively with the application layer, ensuring proper separation of concerns and testability.

ASP.NET Core Identity forms the core of the application layer, managing authentication workflows, password policies, and user session state. The authentication state provider synchronizes user identity across all Blazor components in real-time, while the custom email validator enforces domain-based registration policies. Entity Framework Core abstracts database operations through a repository pattern, supporting both SQLite for development and SQL Server for production without code changes.

Azure Container Apps provides the hosting infrastructure with automatic HTTPS termination, health monitoring, and horizontal scaling based on demand. The container registry stores versioned application images, while Application Insights collects telemetry for performance monitoring and diagnostics. This cloud-native design ensures the application can scale from development workloads to production traffic seamlessly.

```mermaid
%%{init: {"flowchart": {"htmlLabels": false}} }%%
flowchart TB
    %% ============================================
    %% STANDARD COLOR SCHEME
    %% ============================================
    %% Main Group (Neutral background - MANDATORY)
    classDef mainGroup fill:#E8EAF6,stroke:#3F51B5,stroke-width:3px,color:#000

    %% Content (Semantic colors)
    classDef mdBlue fill:#BBDEFB,stroke:#1976D2,stroke-width:2px,color:#000
    classDef mdGreen fill:#C8E6C9,stroke:#388E3C,stroke-width:2px,color:#000
    classDef mdOrange fill:#FFE0B2,stroke:#E64A19,stroke-width:2px,color:#000
    classDef mdPurple fill:#E1BEE7,stroke:#7B1FA2,stroke-width:2px,color:#000

    %% ============================================
    %% ARCHITECTURE LAYERS
    %% ============================================
    %% Layer 1: Presentation handles user interface and interaction
    %% Layer 2: Application manages business logic and authentication
    %% Layer 3: Data provides persistence and storage
    %% Layer 4: Azure Services host, deploy, and monitor the application
    %% ============================================

    subgraph system["IdentityProvider Architecture"]
        direction TB

        subgraph presentation["Presentation Layer"]
            direction LR
            blazor["Blazor Server<br/>Components"]:::mdBlue
            razor["Razor Pages<br/>(Account UI)"]:::mdBlue
        end

        subgraph application["Application Layer"]
            direction LR
            identity["ASP.NET Core<br/>Identity"]:::mdGreen
            auth["Authentication<br/>State Provider"]:::mdGreen
            email["Email<br/>Validator"]:::mdGreen
        end

        subgraph data["Data Layer"]
            direction LR
            efcore["Entity Framework<br/>Core"]:::mdOrange
            db[("SQLite / SQL<br/>Database")]:::mdOrange
        end

        subgraph azure["Azure Services"]
            direction LR
            containerapp["Container Apps"]:::mdPurple
            acr["Container<br/>Registry"]:::mdPurple
            insights["Application<br/>Insights"]:::mdPurple
        end

        %% Presentation Layer interactions
        %% Blazor components authenticate users via Identity
        blazor --> identity
        %% Razor Pages handle account management through Identity
        razor --> identity

        %% Application Layer interactions
        %% Identity stores user data via EF Core
        identity --> efcore
        %% Auth state provider syncs with Identity system
        auth --> identity
        %% Email validator enforces registration policies
        email --> identity

        %% Data Layer interactions
        %% EF Core persists data to SQLite/SQL database
        efcore --> db

        %% Azure deployment relationships
        %% Container Apps host Blazor components
        containerapp -.deploys.-> blazor
        %% Container Apps host Razor Pages
        containerapp -.deploys.-> razor
        %% Registry provides container images
        acr -.stores.-> containerapp
        %% Application Insights tracks telemetry
        insights -.monitors.-> containerapp
    end

    class system mainGroup
```

**Key Components:**

- **Presentation Layer**: Blazor Server components with real-time UI updates via SignalR
- **Application Layer**: ASP.NET Core Identity handles authentication, authorization, and session management
- **Data Layer**: Entity Framework Core with code-first migrations for database operations
- **Azure Services**: Containerized deployment with monitoring and logging

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Ensure all tests pass before submitting:

```bash
dotnet test
```

## 📝 License

This project is licensed under the MIT License - see the [`LICENSE`](LICENSE) file for details.

Copyright (c) 2025 Evilázaro Alves
