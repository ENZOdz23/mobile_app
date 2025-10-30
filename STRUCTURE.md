# Project Structure – Prospectra (Mobilis CRM & Sales App)

Hello dear team, I made this structure using AI to help us stay organized. Please read this file carefully until further discussion.

---

## 1. Overview

This project is a **Flutter-based mobile CRM & sales app** designed to support Mobilis B2B sales teams.  
It helps track sales performance, manage clients and prospects, plan visits, handle orders/invoices, and visualize KPIs.  
The app will integrate with backend APIs for synchronization and analytics.

---

## 2. Folder Descriptions

### lib/

Main Flutter application source folder.

#### lib/core/

Contains reusable global utilities and base logic.  
- `constants.dart` → App-wide constants like colors, fonts, API URLs.  
- `utils/` → Helpers for formatting dates, string manipulation, validation, etc.  
- `themes/` → App themes supporting light and dark mode.  
- `config/` → Environment configuration such as dev/staging/production settings.  
- `error/` → Centralized error handling and exceptions.

#### lib/features/

Organizes code by business domain with a clean layered architecture:  
Each feature has: `models/` (data structures), `data/` (repositories & data sources), `domain/` (business logic & use cases), `presentation/` (UI screens and widgets).

Features include:  
- **authentication/** → User login, OTP verification.  
- **dashboard/** → KPI display, sales goals, conversion charts.  
- **contacts/** → Contact management (CRUD, import/export).  
- **prospects/** → Prospect management and lead conversion.  
- **sales/** → Sales orders, invoices, contracts.  
- **calendar/** → Meeting scheduling, reminders, check-in/out.  
- **notifications/** → Push and local notifications.  
- **settings/** → User preferences: language, theme.  
- **crm/** → Customer portfolio and business workflows.

#### lib/shared/

Reusable UI components, services, adapters, and validators used across features.  
- `components/` → Buttons, form fields, custom widgets.  
- `services/` → API clients, notification handlers, local storage managers.  
- `adapters/` → Data serialization and mapping utilities.  
- `validators/` → Common form and business validation logic (phone, OTP, contacts).

---

### test/

Automated unit and widget tests, organized by feature for ease of maintenance and CI/CD pipelines.

---

## 3. How Flutter Connects to Backend

1. Flutter app makes REST or GraphQL API calls through shared API services.  
2. Responses with JSON data are parsed into typed models within each feature.  
3. Repositories encapsulate business logic, caching, and error handling.  
4. Use cases execute domain logic and update presentation state.  
5. UI listens to state changes and renders data accordingly.


