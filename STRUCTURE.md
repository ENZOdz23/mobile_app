# Project Structure – CME GoalSync (CRM & Sales Performance)

hello dear team, i made this structure using ai, to help us be orgnized. read this file carefull untill further discussion.
## 1. Overview
This project is a **Flutter-based mobile CRM** designed for B2B sales teams.  
It helps track sales performance, manage clients, plan visits, and visualize KPIs.  
The app will integrate with a backend (Node.js / NestJS / Firebase) for synchronization and analytics.

---

## 2. Folder Descriptions

### lib/
Main Flutter application source.

#### lib/core/
Contains reusable configuration and global logic.
- `constants/` → Colors, fonts, app constants.
- `utils/` → Helpers for formatting dates, validating forms, etc.
- `theme/` → App themes (light/dark).
- `config.dart` → Environment constants such as API base URL.

#### lib/data/
Manages data interaction (API + local storage).
- `models/` → Classes representing data entities (`Client`, `Lead`, `KPI`, `SalesOrder`, etc.)
- `services/` → HTTP clients and local database handlers.
- `repositories/` → Combine multiple services, apply business rules.

#### lib/presentation/
All visual components (UI/UX).
- `screens/` → Main screens organized by module:
  - `auth/` (login, signup, forgot password)
  - `dashboard/` (KPI display, charts)
  - `clients/` (prospecting, customer management)
  - `sales/` (sales pipeline, contracts, performance)
  - `calendar/` (visits, itinerary, GPS check-in/out)
  - `settings/` (profile, preferences)
- `widgets/` → Reusable custom widgets (buttons, cards, charts)
- `components/` → Smaller UI parts used across screens
- `app.dart` → Global MaterialApp widget, themes, routes.

#### lib/routes/
Defines application routes and navigation guards.

#### lib/main.dart
App entry point — initializes services, routes, and runs the app.

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
