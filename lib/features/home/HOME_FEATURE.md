# Home Feature Documentation

## Overview

The **Home Feature** serves as the main dashboard of the mobile application, providing users with an at-a-glance view of their sales activities, prospects, contacts, and key performance indicators. It follows **Clean Architecture** principles and uses the **BLoC/Cubit pattern** for state management. The dashboard aggregates data from multiple sources (contacts, prospects, activities) to present a unified view.

---

## Feature Flow

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                          HomeScreen                                  │    │
│  │  ┌───────────────┐ ┌──────────────┐ ┌───────────────────────────┐   │    │
│  │  │ DashboardHeader│ │ StatCards    │ │ ProspectStatusCard        │   │    │
│  │  └───────────────┘ └──────────────┘ └───────────────────────────┘   │    │
│  │  ┌───────────────────────────┐ ┌─────────────────────────────────┐  │    │
│  │  │ QuickActionCards          │ │ RecentActivities Section        │  │    │
│  │  └───────────────────────────┘ └─────────────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                    │                                         │
│  ┌─────────────────────────────────▼───────────────────────────────────┐    │
│  │                        CUBITS (State Management)                     │    │
│  │           DashboardCubit          │       ActivitiesCubit            │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└───────────────────────────────────────┬─────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼─────────────────────────────────────┐
│                               DOMAIN LAYER                                   │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      GetDashboardDataUseCase                         │    │
│  └──────────────────────────────────┬──────────────────────────────────┘    │
│                                     │                                        │
│  ┌──────────────────────────────────▼──────────────────────────────────┐    │
│  │                      DashboardRepository (Abstract)                  │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└───────────────────────────────────────┬─────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼─────────────────────────────────────┐
│                                DATA LAYER                                    │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    DashboardRepositoryImpl                           │    │
│  │  ┌─────────────────┐  ┌──────────────────┐  ┌───────────────────┐   │    │
│  │  │ContactsRemote   │  │ProspectsRemote   │  │ActivitiesEndpoint │   │    │
│  │  │DataSource       │  │DataSource        │  │(optional)         │   │    │
│  │  └─────────────────┘  └──────────────────┘  └───────────────────┘   │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                        │                                     │
│  ┌─────────────────────────────────────▼────────────────────────────────┐   │
│  │                     DashboardRemoteDataSource                         │   │
│  │                     (Alternative: dedicated endpoint)                 │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## User Flow

### Dashboard Loading Flow

```
User Opens Home/Dashboard
         │
         ▼
┌─────────────────────────────────────────────┐
│   HomeScreen creates BlocProvider           │
│   with DashboardCubit                       │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│   DashboardCubit.loadDashboardData()        │
│   Emit: DashboardLoading                    │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Data Aggregation                                  │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  1. Fetch Contacts (ContactsRemoteDataSource)                 │  │
│  │  2. Fetch Prospects (ProspectsRemoteDataSource)               │  │
│  │  3. Get Activities (Activities endpoint or generate)          │  │
│  │  4. Calculate Prospect Status Counts                          │  │
│  │  5. Build DashboardData model                                 │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────┬───────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────┐
│   Emit: DashboardLoaded(DashboardData)      │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DASHBOARD UI                                    │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  DashboardHeader (Greeting + Date + Avatar)         │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  Statistics Section                                 │    │    │
│  │  │  ┌────────────────┐  ┌────────────────┐             │    │    │
│  │  │  │ Total Prospects│  │ Total Contacts │             │    │    │
│  │  │  │      XX        │  │      XX        │             │    │    │
│  │  │  └────────────────┘  └────────────────┘             │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  Prospects par statut                               │    │    │
│  │  │  ■ Intéressé: XX (progress bar)                     │    │    │
│  │  │  ■ Non intéressé: XX (progress bar)                 │    │    │
│  │  │  ■ Sans réponse: XX (progress bar)                  │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  Quick Actions                                      │    │    │
│  │  │  ┌──────────────┐  ┌──────────────┐                 │    │    │
│  │  │  │Ajouter Contact│  │Ajouter Prospect│               │    │    │
│  │  │  └──────────────┘  └──────────────┘                 │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  Activités récentes        [Voir tout →]            │    │    │
│  │  │  ▪ Prospect ajouté - Company XYZ - Il y a 2h       │    │    │
│  │  │  ▪ Client ajouté - John Doe - Il y a 1 jour        │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

### Pull-to-Refresh Flow

```
User Pulls Down on Dashboard
         │
         ▼
RefreshIndicator triggered
         │
         ▼
DashboardCubit.refreshDashboardData()
         │
         ▼
Re-fetch all data from APIs
         │
         ▼
Emit DashboardLoaded with fresh data
         │
         ▼
UI rebuilds with updated stats
```

### Navigation Flows

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FROM DASHBOARD                                    │
└───────────────┬───────────────────────────────────────────┬─────────┘
                │                                           │
    ┌───────────▼───────────┐               ┌───────────────▼──────────┐
    │ Quick Action:         │               │ "Voir tout" Activities   │
    │ Ajouter Contact       │               └───────────────┬──────────┘
    └───────────┬───────────┘                               │
                │                                           ▼
                ▼                               ┌─────────────────────┐
    ┌───────────────────────┐                   │RecentActivitiesScreen│
    │ AddContact Route      │                   │ (Full activities list)│
    └───────────────────────┘                   └─────────────────────┘
                
    ┌───────────────────────┐
    │ Quick Action:         │
    │ Ajouter Prospect      │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ AddProspect Route     │
    └───────────────────────┘
```

---

## Data Flow

### Dashboard Data Aggregation

```
DashboardRepositoryImpl.getDashboardData()
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 1: Fetch Raw Data                                              │
│  ┌────────────────────┐  ┌────────────────────┐                     │
│  │ contactsRemote     │  │ prospectsRemote    │                     │
│  │ .fetchContacts()   │  │ .getProspects()    │                     │
│  └─────────┬──────────┘  └─────────┬──────────┘                     │
│            │                       │                                 │
│            ▼                       ▼                                 │
│      List<Contact>           List<Prospect>                          │
└─────────────────────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 2: Calculate Statistics                                        │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  totalProspects = prospects.length                            │  │
│  │  totalContacts = contacts.length (or API count)               │  │
│  │                                                               │  │
│  │  for each prospect:                                           │  │
│  │    if status == interested → interested++                     │  │
│  │    if status == notInterested → notInterested++               │  │
│  │    if status == notCompleted → notAnswered++                  │  │
│  │                                                               │  │
│  │  ProspectStatusCount = { interested, notInterested, notAnswered } │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 3: Get/Generate Activities                                     │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  TRY: Fetch from /activities/ endpoint                        │  │
│  │       ↓                                                       │  │
│  │  IF endpoint exists → Use API activities                      │  │
│  │  IF endpoint fails/empty → Generate from contacts + prospects │  │
│  │       ↓                                                       │  │
│  │  Generate Activity for each contact (type: client/prospect)   │  │
│  │  Generate Activity for each prospect (type: prospectAdded)    │  │
│  │  Sort by timestamp (most recent first)                        │  │
│  │  Take top 10                                                  │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────────┐
│  STEP 4: Build DashboardData Model                                   │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  DashboardData(                                               │  │
│  │    totalProspects: XX,                                        │  │
│  │    totalContacts: XX,                                         │  │
│  │    prospectStatusCount: ProspectStatusCount(...),             │  │
│  │    recentActivities: List<Activity>[...top 10...],            │  │
│  │  )                                                            │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
              │
              ▼
         Return to Cubit → Emit DashboardLoaded
```

---

## Folder Structure

```
lib/features/home/
├── data/                              # Data Layer
│   ├── dashboard_repository_impl.dart
│   └── datasources/
│       └── dashboard_remote_data_source.dart
│
├── domain/                            # Domain Layer
│   ├── dashboard_repository.dart
│   └── get_dashboard_data_usecase.dart
│
├── models/                            # Data Models
│   ├── activity.dart
│   ├── dashboard_data.dart
│   └── prospect_status_count.dart
│
└── presentation/                      # Presentation Layer
    ├── home_screen.dart
    ├── cubit/
    │   ├── activities_cubit.dart
    │   ├── dashboard_cubit.dart
    │   └── dashboard_state.dart
    ├── screens/
    │   ├── add_prospect_screen.dart
    │   ├── goals_screen.dart
    │   ├── kpis_screen.dart
    │   ├── plan_meeting_screen.dart
    │   └── recent_activities_screen.dart
    └── widgets/
        ├── activity_item.dart
        ├── dashboard_error_widget.dart
        ├── dashboard_header.dart
        ├── dashboard_loading_shimmer.dart
        ├── goals_section.dart
        ├── kpis_section.dart
        ├── prospect_status_card.dart
        ├── quick_action_card.dart
        ├── quick_actions_section.dart
        ├── recent_activities_section.dart
        ├── stat_card.dart
        └── welcome_card.dart
```

---

## File Descriptions

### Models (`models/`)

#### `dashboard_data.dart`
**Purpose:** Main data model containing all dashboard information.

- **`DashboardData`**: Aggregated dashboard data with properties:
  - `totalProspects`: Total number of prospects
  - `totalContacts`: Total number of contacts
  - `prospectStatusCount`: Breakdown by status (ProspectStatusCount)
  - `recentActivities`: List of recent Activity items
- **Methods:**
  - `fromJson()`: Factory constructor for API responses
  - `toJson()`: Converts model to JSON
  - `copyWith()`: Creates a copy with optional field overrides

---

#### `activity.dart`
**Purpose:** Data model for user activities displayed in dashboard.

- **`ActivityType`**: Enum with values:
  - `prospectAdded`: New prospect created
  - `clientAdded`: New client added
  - `statusUpdated`: Prospect status changed
  - `meetingScheduled`: Meeting planned
  - `other`: General activity
- **`Activity`**: Activity model with properties:
  - `id`: Unique identifier
  - `title`: Activity title (e.g., "Prospect ajouté")
  - `description`: Details (e.g., company name)
  - `timestamp`: When the activity occurred
  - `type`: ActivityType enum value
- **Methods:**
  - `fromJson()`: Parses JSON with timezone handling
  - `toJson()`: Converts to JSON
  - `_typeFromString()` / `_typeToString()`: Type conversion helpers

---

#### `prospect_status_count.dart`
**Purpose:** Data model for prospect status breakdown.

- **`ProspectStatusCount`**: Status counts with properties:
  - `interested`: Count of interested prospects
  - `notInterested`: Count of not interested prospects
  - `notAnswered`: Count of prospects without response
- **Computed Properties:**
  - `total`: Sum of all statuses (getter)
- **Methods:**
  - `fromJson()`, `toJson()`, `copyWith()`

---

### Domain Layer (`domain/`)

#### `dashboard_repository.dart`
**Purpose:** Abstract repository interface for dashboard operations.

- **Methods:**
  - `getDashboardData()`: Returns aggregated `DashboardData`

---

#### `get_dashboard_data_usecase.dart`
**Purpose:** Use case for fetching dashboard data.

- Takes `DashboardRepository` as dependency
- `call()`: Executes use case, returns `DashboardData`
- Single responsibility: orchestrates dashboard data retrieval

---

### Data Layer (`data/`)

#### `dashboard_repository_impl.dart`
**Purpose:** Concrete implementation of `DashboardRepository`.

**Dependencies:**
- `IContactsRemoteDataSource`: Fetches contacts
- `IProspectsRemoteDataSource`: Fetches prospects
- `Dio`: For direct API calls (activities, phone-numbers)

**Key Methods:**

| Method | Description |
|--------|-------------|
| `getDashboardData()` | Main method - aggregates all dashboard data |
| `_getActivitiesFromEndpoint()` | Tries to fetch from `/activities/` |
| `_getPhoneNumbersCount()` | Gets count from `/phone-numbers/` |
| `_getContactsCount()` | Gets count from `/contacts/` (handles pagination) |

**Data Aggregation Logic:**
1. Fetch contacts and prospects from remote data sources
2. Get contacts count (handles paginated responses)
3. Calculate prospect status counts (interested/notInterested/notAnswered)
4. Try to fetch activities from API, fallback to generating from contacts/prospects
5. Sort activities by timestamp, take top 10
6. Return assembled `DashboardData`

---

#### `datasources/dashboard_remote_data_source.dart`
**Purpose:** Remote API data source for dedicated dashboard endpoint.

- **Interface:** `IDashboardRemoteDataSource`
- **Implementation:** `DashboardRemoteDataSource`
- **Endpoint:** `GET /dashboard/`
- Alternative to aggregated approach in repository
- Returns pre-computed `DashboardData` from backend

---

### Presentation Layer - Cubits (`presentation/cubit/`)

#### `dashboard_cubit.dart`
**Purpose:** Main state management for dashboard.

- **Dependencies:**
  - `GetDashboardDataUseCase`: For fetching data
- **Methods:**
  - `loadDashboardData()`: Fetches and emits dashboard data
  - `refreshDashboardData()`: Re-fetches data (for pull-to-refresh)

---

#### `dashboard_state.dart`
**Purpose:** State definitions for DashboardCubit.

| State | Description |
|-------|-------------|
| `DashboardInitial` | Initial state before data load |
| `DashboardLoading` | Data fetch in progress |
| `DashboardLoaded` | Data loaded successfully with `DashboardData` |
| `DashboardError` | Error occurred with message |

---

#### `activities_cubit.dart`
**Purpose:** State management for full activities list.

- **States:** `ActivitiesInitial`, `ActivitiesLoading`, `ActivitiesLoaded`, `ActivitiesError`
- **Methods:**
  - `loadActivities()`: Fetches from `/activities/` endpoint
  - `refreshActivities()`: Re-fetches activities
- Sorts activities by timestamp (most recent first)
- Used by `RecentActivitiesScreen`

---

### Presentation Layer - Screens (`presentation/`)

#### `home_screen.dart`
**Purpose:** Main dashboard screen displaying all sections.

**Structure:**
- `HomeScreen`: StatelessWidget that creates `BlocProvider`
- `DashboardBody`: Builds UI based on `DashboardState`

**Sections Displayed:**
1. **DashboardHeader**: Greeting, date, avatar
2. **Statistics Grid**: Total Prospects, Total Contacts (2x2 grid)
3. **ProspectStatusCard**: Status breakdown with progress bars
4. **Quick Actions Row**: Add Contact, Add Prospect buttons
5. **Recent Activities**: Latest 5 activities with "Voir tout" link

**Features:**
- Pull-to-refresh functionality
- Loading shimmer placeholder
- Error widget with retry button
- Empty state for activities

---

#### `screens/recent_activities_screen.dart`
**Purpose:** Full-screen activities list.

- Uses `ActivitiesCubit` for dedicated activities loading
- Pull-to-refresh support
- Empty state when no activities
- Displays all activities (not limited to 10)

---

#### `screens/add_prospect_screen.dart`
**Purpose:** Simple form for adding a prospect.

- Form fields: Name, Company, Email, Phone
- Basic UI (not connected to actual prospect creation logic)
- Shows success snackbar on submit

---

#### `screens/kpis_screen.dart`
**Purpose:** Key Performance Indicators display.

- Static/demo data showing:
  - Sales of the month
  - New clients
  - Completed meetings
  - Active prospects
- Visual cards with icons and trend indicators

---

#### `screens/goals_screen.dart`
**Purpose:** Monthly goals progress tracking.

- Displays progress bars for:
  - Revenue target
  - New clients target
  - Meetings target
  - Signed contracts target
- Shows current vs target with percentage

---

#### `screens/plan_meeting_screen.dart`
**Purpose:** Meeting scheduling form.

- Form fields: Client/Prospect, Date, Time, Location, Notes
- Basic UI (not connected to calendar integration)
- Shows success snackbar on submit

---

### Presentation Layer - Widgets (`presentation/widgets/`)

#### `dashboard_header.dart`
**Purpose:** Header section with greeting and date.

**Features:**
- Dynamic greeting based on time of day:
  - Morning (< 12h): "Bonjour"
  - Afternoon (12-18h): "Bon après-midi"
  - Evening (> 18h): "Bonsoir"
- Formatted date in French (e.g., "Mercredi, 8 Jan 2026")
- User avatar
- Gradient background (primary → accent)

---

#### `stat_card.dart`
**Purpose:** Statistics display card.

- Displays: title, value, icon with color
- Compact design with icon badge
- Optional `onTap` callback
- Adapts to theme (light/dark)

---

#### `prospect_status_card.dart`
**Purpose:** Card showing prospect status breakdown.

- Displays three status rows with progress bars:
  - Intéressé (green/accent)
  - Non intéressé (red/error)
  - Sans réponse (grey)
- Each row shows count and percentage bar
- Progress calculated from `total` count

---

#### `quick_action_card.dart`
**Purpose:** Tappable action button card.

- Icon with colored background
- Label text below icon
- `onTap` callback for navigation
- Expands to fill available space (uses `Expanded`)

---

#### `activity_item.dart`
**Purpose:** Single activity list item.

**Features:**
- Dynamic icon based on `ActivityType`:
  - `prospectAdded`: person_add
  - `clientAdded`: person_add_alt_1
  - `statusUpdated`: update
  - `meetingScheduled`: event
  - `other`: notifications
- Color-coded by type
- Relative time formatting:
  - "À l'instant"
  - "Il y a X minute(s)"
  - "Il y a X heure(s)"
  - "Il y a X jour(s)"

---

#### `dashboard_loading_shimmer.dart`
**Purpose:** Loading placeholder for dashboard.

- Mimics dashboard layout with grey boxes
- Shows placeholder for:
  - Header
  - Stats grid (2 boxes)
  - Status card
  - Quick actions (2 boxes)
- Provides visual feedback during loading

---

#### `dashboard_error_widget.dart`
**Purpose:** Error state display.

- Error icon (red)
- "Erreur" title
- Error message text
- "Réessayer" button to retry loading

---

#### `welcome_card.dart`
**Purpose:** Alternative welcome header (static version).

- Hardcoded greeting "Bonjour, Mohamed"
- Notifications icon button
- Gradient background
- Used as alternative to `DashboardHeader`

---

## API Endpoints Used

| Endpoint | Method | Purpose | Response |
|----------|--------|---------|----------|
| `/contacts/` | GET | Fetch contacts list | List of contacts or paginated |
| `/prospects/` | GET | Fetch prospects list | List of prospects |
| `/activities/` | GET | Fetch activities (optional) | List of activities |
| `/phone-numbers/` | GET | Get registered phone count | Count or list |
| `/dashboard/` | GET | Get pre-computed dashboard (alternative) | DashboardData |

---

## Key Design Patterns

1. **Clean Architecture**: Data, domain, and presentation separation
2. **Repository Pattern**: Abstract data access
3. **Use Case Pattern**: Single-responsibility business logic
4. **Cubit Pattern**: Simplified state management
5. **Aggregation Pattern**: Combining data from multiple sources
6. **Fallback Pattern**: Generate activities if API unavailable

---

## Dashboard Data Model

```
DashboardData
├── totalProspects: int
├── totalContacts: int
├── prospectStatusCount: ProspectStatusCount
│   ├── interested: int
│   ├── notInterested: int
│   ├── notAnswered: int
│   └── total (computed): int
└── recentActivities: List<Activity>
    └── Activity
        ├── id: String
        ├── title: String
        ├── description: String
        ├── timestamp: DateTime
        └── type: ActivityType
```

---

## State Management Flow

```
HomeScreen mounted
       │
       ▼
BlocProvider creates DashboardCubit
       │
       │ loadDashboardData() called
       ▼
┌───────────────────────────────────────┐
│  Emit: DashboardLoading               │
│  UI shows: DashboardLoadingShimmer    │
└─────────────────┬─────────────────────┘
                  │
                  ▼
       GetDashboardDataUseCase.call()
                  │
                  ▼
       DashboardRepositoryImpl.getDashboardData()
                  │
    ┌─────────────┴─────────────┐
    │                           │
    ▼                           ▼
 Success                      Error
    │                           │
    ▼                           ▼
DashboardLoaded          DashboardError
    │                           │
    ▼                           ▼
Dashboard UI             DashboardErrorWidget
with data                with retry button
```

---

## Dependencies

- **flutter_bloc**: State management (Cubit)
- **dio**: HTTP client for API calls
- **contacts feature**: Reuses data sources for contacts/prospects
- **shared components**: BaseScaffold for consistent UI

---

## Internationalization

The feature uses French language throughout:
- Greetings: "Bonjour", "Bon après-midi", "Bonsoir"
- Dates: French weekday and month names
- Labels: "Statistiques", "Activités récentes", etc.
- Time: "Il y a X jour(s)", "À l'instant"
