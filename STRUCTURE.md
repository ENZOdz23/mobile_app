# Project Structure – CME GoalSync (CRM & Sales Performance)

hello dear team, i made this structure using ai, to help us be orgnized. read this file carefull untill further discussion.

**✨ NEW: The complete project structure has been implemented!** See [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) for full details.

## 1. Overview
This project is a **Flutter-based mobile CRM** designed for B2B sales teams.  
It helps track sales performance, manage clients, plan visits, and visualize KPIs.  
The app will integrate with a backend (Node.js / NestJS / Firebase) for synchronization and analytics.

---

## 2. Current Project Structure

The project now follows a **feature-based clean architecture** pattern:

### lib/
Main Flutter application source.

#### lib/main.dart
App entrypoint that bootstraps core dependencies.

#### lib/core/
Contains reusable configuration and global logic.
- `constants.dart` → App-wide constants (API URLs, configuration values)
- `utils/` → Helpers for formatting dates, validating forms, etc.
- `config/` → Environment configuration and feature flags
- `themes/` → App themes (light/dark mode)
- `error/` → Global error and result handling

#### lib/features/
Feature modules following clean architecture (models → data → domain → presentation):
- `authentication/` → OTP flow, Mobilis phone verification
- `dashboard/` → Lead KPIs, goals, conversion charts
- `contacts/` → Contact management
- `prospects/` → Prospect and lead management
- `sales/` → Sales operations, order and invoice management
- `calendar/` → Visit/meeting events, reminders, GPS check-in/check-out
- `notifications/` → Notification management
- `settings/` → Preferences, language, dark mode
- `crm/` → Portfolio client management, core CRM business logic

Each feature contains:
- `models/` → Data models and entities
- `data/` → Data sources and repositories
- `domain/` → Business logic and use cases
- `presentation/` → UI screens and widgets

#### lib/shared/
Shared resources used across multiple features.
- `components/` → Reusable UI components
  - `buttons/` → Custom button widgets
  - `forms/` → Form widgets
  - `input_fields/` → Input field widgets
  - `custom_widgets/` → Other custom widgets (cards, lists, etc.)
- `services/` → Global services
  - `api_service.dart` → REST/GraphQL integration
  - `notification_service.dart` → Notification handling
  - `local_storage_service.dart` → Local data persistence
- `adapters/` → Data mapping and serialization
- `validators/` → Field and business logic validation scripts

---

### test/
Unit and widget tests for each module (mirrors lib/ structure).

---

### assets/
Holds images, icons, and translations (for multi-language support).

---

### backend/
Server-side logic (if self-hosted backend is used).
- `src/api/controllers/` → Business logic per route (e.g., `authController.js`).
- `src/api/routes/` → REST endpoints.
- `src/models/` → Database schemas.
- `src/services/` → Reusable backend services (auth, KPIs, reports).
- `src/config/` → Environment variables, DB setup.
- `.env.example` → Example environment configuration.

---

### docs/
Documentation folder.
- `ui_mockups/` → Screen designs, prototypes.
- `api_documentation/` → API specs, endpoint descriptions.
- `structure_diagrams/` → UMLs, ER diagrams, app flow.

---

## 3. How Flutter Connects to Backend
1. Flutter calls backend APIs (via `Dio` or `http`).
2. Backend returns JSON data (clients, sales, KPIs).
3. Data is parsed into Flutter models (`lib/data/models`).
4. Repositories manage business logic and feed data to UI.

Example:
```dart
final response = await dio.get('${Config.baseUrl}/clients');
final clients = (response.data as List)
    .map((e) => Client.fromJson(e))
    .toList();
```

---

## 4. Implementation Status

✅ **Complete Project Structure**: The lib/ directory now contains the complete folder structure as specified.

📁 **Key Directories Created**:
- Core utilities (constants, utils, config, themes, error)
- 9 Feature modules (authentication, dashboard, contacts, prospects, sales, calendar, notifications, settings, crm)
- Shared components and services
- Test directory structure

📚 **Documentation**:
- Each feature has a README explaining its purpose
- Complete structure documentation in `docs/PROJECT_STRUCTURE.md`
- Quick reference for lib cleanup in `LIB_CLEANUP.md`

🚀 **Next Steps**:
1. Implement core utilities and services
2. Set up state management (Provider, Bloc, or Riverpod)
3. Build features incrementally following the clean architecture pattern
4. Write tests for each component
5. Configure CI/CD for automated testing

For detailed information about the architecture and implementation guidelines, see [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md).
