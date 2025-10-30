# Flutter Project Structure

## Overview
This Flutter project follows a **feature-based clean architecture** pattern with clear separation of concerns.

## Complete Directory Structure

```
lib/
├── main.dart                          # App entrypoint, bootstraps core dependencies
│
├── core/                              # Core application utilities
│   ├── constants.dart                 # Shared app constants
│   ├── utils/                         # Utility classes and helpers
│   ├── config/                        # Global config, environment switching
│   ├── themes/                        # App styling, light/dark mode
│   └── error/                         # Global error and result handling
│
├── features/                          # Feature modules (clean architecture)
│   │
│   ├── authentication/                # OTP flow, Mobilis phone verification
│   │   ├── models/                    # Data models
│   │   ├── data/                      # Data sources and repositories
│   │   ├── domain/                    # Business logic and use cases
│   │   └── presentation/              # UI screens and widgets
│   │
│   ├── dashboard/                     # Lead KPIs, goals, conversion charts
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── contacts/                      # Contact management
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── prospects/                     # Prospect and lead management
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── sales/                         # Sales ops, order, invoice management
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── calendar/                      # Visit/Meeting events, reminders, check-in/out
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── notifications/                 # Notification management
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── settings/                      # Preferences, language, dark mode
│   │   ├── models/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── crm/                          # Portfolio client, business logic
│       ├── models/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/                            # Shared resources across features
    ├── components/                    # Reusable UI components
    │   ├── buttons/                   # Custom button widgets
    │   ├── forms/                     # Form widgets
    │   ├── input_fields/              # Input field widgets
    │   └── custom_widgets/            # Other custom widgets
    │
    ├── services/                      # Global services
    │   ├── api_service.dart           # REST/GraphQL integration
    │   ├── notification_service.dart  # Notification handling
    │   └── local_storage_service.dart # Local data persistence
    │
    ├── adapters/                      # Data mapping, serialization
    └── validators/                    # Field and business logic validation

test/                                  # Unit and widget tests
└── (mirrors lib/ structure)
```

## Architecture Pattern

Each feature follows **Clean Architecture** principles:

### 1. Models Layer (`models/`)
- Data transfer objects (DTOs)
- Entity models
- Response/Request models

### 2. Data Layer (`data/`)
- Data sources (remote API, local database)
- Repository implementations
- Data mappers

### 3. Domain Layer (`domain/`)
- Use cases (business logic)
- Repository interfaces
- Business entities

### 4. Presentation Layer (`presentation/`)
- Screens/Pages
- Widgets
- State management (Provider, Bloc, Riverpod, etc.)
- View models

## Benefits of This Structure

1. **Scalability**: Easy to add new features without affecting existing ones
2. **Maintainability**: Clear separation of concerns
3. **Testability**: Each layer can be tested independently
4. **Reusability**: Shared components and services reduce code duplication
5. **Team Collaboration**: Multiple developers can work on different features simultaneously

## Getting Started

1. **Core Setup**: Configure constants, themes, and utilities in `core/`
2. **Shared Services**: Implement API, storage, and notification services in `shared/services/`
3. **Feature Development**: Build features one at a time following the clean architecture pattern
4. **Testing**: Write tests mirroring the lib/ structure in test/

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- See individual feature README files for specific implementation details
