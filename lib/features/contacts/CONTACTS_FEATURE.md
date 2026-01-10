# Contacts Feature Documentation

## Overview

The **Contacts Feature** is a comprehensive module for managing business contacts and prospects within the mobile application. It follows **Clean Architecture** principles with clear separation between data, domain, and presentation layers. The feature uses the **BLoC/Cubit pattern** for state management.

---

## Feature Flow

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                              │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │ ContactsListScreen│    │ ContactFormScreen│    │ProspectDetailFormScreen│  │
│  └────────┬────────┘    └────────┬────────┘    └───────────┬─────────────┘  │
│           │                      │                          │                │
│  ┌────────▼──────────────────────▼──────────────────────────▼─────────────┐ │
│  │                           CUBITS (State Management)                     │ │
│  │  ContactsCubit  │  ProspectsCubit  │  ContactsListCubit                │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │
┌───────────────────────────────────▼─────────────────────────────────────────┐
│                               DOMAIN LAYER                                   │
│  ┌────────────────────┐    ┌──────────────────────┐                         │
│  │     Use Cases      │    │    Repositories      │                         │
│  │ - GetContactsUseCase│    │ - ContactsRepository │                         │
│  │ - AddContactUseCase │    │ - ProspectRepository │                         │
│  │ - GetProspectsUseCase│   │      (abstract)      │                         │
│  │ - AddProspectUseCase│    │                      │                         │
│  └─────────┬──────────┘    └──────────┬───────────┘                         │
└────────────┼──────────────────────────┼─────────────────────────────────────┘
             │                          │
┌────────────▼──────────────────────────▼─────────────────────────────────────┐
│                                DATA LAYER                                    │
│  ┌──────────────────────────┐    ┌─────────────────────────────────────┐    │
│  │   Repository Impl        │    │         Data Sources                │    │
│  │ - ContactsRepositoryImpl │    │ - ContactsRemoteDataSource (API)    │    │
│  │ - ProspectRepositoryImpl │    │ - ProspectsRemoteDataSource (API)   │    │
│  └──────────────────────────┘    │ - ContactsLocalDataSource (SQLite)  │    │
│                                  │ - ProspectsLocalDataSource (SQLite) │    │
│                                  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## User Flow

### 1. Viewing Contacts and Prospects

```
User Opens Contacts Screen
         │
         ▼
┌─────────────────────────────┐
│   ContactsListScreen loads  │
│   with MultiBlocProvider    │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────┐
│  ContactsCubit.loadContacts() + ProspectsCubit.loadProspects()│
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
         ┌────────────────────┴────────────────────┐
         │                                         │
         ▼                                         ▼
┌─────────────────┐                    ┌─────────────────────┐
│ Tab: Contacts   │                    │ Tab: Prospects      │
│ (ContactType.   │                    │ (ContactType.       │
│  client)        │                    │  prospect)          │
└────────┬────────┘                    └──────────┬──────────┘
         │                                        │
         ▼                                        ▼
┌─────────────────┐                    ┌─────────────────────┐
│ ContactItem     │                    │ ProspectItem        │
│ (list view)     │                    │ (list view)         │
└─────────────────┘                    └─────────────────────┘
```

### 2. Contact Detail Flow

```
User Taps on Contact Item
         │
         ▼
┌─────────────────────────────┐
│   Navigate to               │
│   ContactFormScreen         │
│   (with contactId)          │
└─────────────┬───────────────┘
              │
              ▼
┌─────────────────────────────────────────────┐
│   BlocBuilder finds contact from state       │
│   using contactId                            │
└─────────────┬───────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│   Display Contact Details:                           │
│   - ContactHeader (avatar, name)                     │
│   - QuickActionButtons (Call, Email, Video)          │
│   - Contact coordinates (phone, email)               │
│   - Company information                              │
└─────────────────────────────────────────────────────┘
              │
    ┌─────────┼─────────┬──────────────┐
    │         │         │              │
    ▼         ▼         ▼              ▼
  Edit     Delete     Call         Send Email
    │         │         │              │
    ▼         ▼         ▼              ▼
EditContact  Confirm  Direct       Open Email
Form Modal   Dialog   Phone Call   Client
```

### 3. Prospect Detail Flow

```
User Taps on Prospect Item
         │
         ▼
┌─────────────────────────────────────┐
│   Navigate to                       │
│   ProspectDetailFormScreen          │
│   (with prospectId)                 │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│   Display Prospect Details:                          │
│   - CompanyHeader (avatar, company name, address)    │
│   - Status Chip (Intéressé, Non intéressé, etc.)     │
│   - QuickActionButtons (État, Interlocuteur, etc.)   │
│   - Interlocuteurs List                              │
│   - Company Details Card                             │
└─────────────────────────────────────────────────────┘
              │
    ┌─────────┼─────────┬──────────────────────┐
    │         │         │                      │
    ▼         ▼         ▼                      ▼
Change    Add       Edit Prospect        Delete
Status  Interlocuteur  (modal)          Prospect
```

---

## Data Flow

### Fetching Data (Read)

```
Screen (UI) 
    │
    │ calls loadContacts() / loadProspects()
    ▼
Cubit (State Management)
    │
    │ emits Loading state, calls use case
    ▼
Use Case (Business Logic)
    │
    │ calls repository.getContacts() / getProspects()
    ▼
Repository Implementation
    │
    │ calls remoteDataSource.fetchContacts() / getProspects()
    ▼
Remote Data Source
    │
    │ makes HTTP request via Dio
    ▼
API Response
    │
    │ parses JSON to model objects
    ▼
Repository returns List<Contact> / List<Prospect>
    │
    ▼
Cubit emits Loaded state with data
    │
    ▼
UI rebuilds with BlocBuilder
```

### Modifying Data (Create/Update/Delete)

```
User Action (Add/Edit/Delete)
    │
    ▼
Form Widget / Action Button
    │
    │ validates input, creates model object
    ▼
Cubit Method (addContact, updateContact, deleteContact)
    │
    │ 1. Optimistically updates local state (immediate UI feedback)
    │ 2. Emits new state
    │ 3. Persists to remote/local storage
    ▼
Repository Implementation
    │
    │ calls appropriate data source method
    ▼
Data Source
    │
    │ executes API call or SQLite operation
    ▼
On Success: State already updated
On Error: Cubit reloads data to revert optimistic update
```

---

## Folder Structure

```
lib/features/contacts/
├── data/                              # Data Layer
│   ├── contacts_local_data_source.dart
│   ├── contacts_repository_impl.dart
│   ├── prospect_local_data_source.dart
│   ├── prospect_repository_impl.dart
│   └── datasources/
│       ├── contacts_remote_data_source.dart
│       └── prospects_remote_data_source.dart
│
├── domain/                            # Domain Layer
│   ├── add_contact_use_case.dart
│   ├── add_prospect_use_case.dart
│   ├── contacts_repository.dart
│   ├── get_contacts_use_case.dart
│   ├── get_prospects_use_case.dart
│   └── prospect_repository.dart
│
├── models/                            # Data Models
│   ├── contact.dart
│   └── prospect.dart
│
└── presentation/                      # Presentation Layer
    ├── contact_form_screen.dart
    ├── contacts_list_screen.dart
    ├── prospect_detail_form_screen.dart
    ├── cubits/
    │   ├── add_contact_cubit.dart
    │   ├── add_contact_state.dart
    │   ├── add_prospect_cubit.dart
    │   ├── add_prospect_state.dart
    │   ├── contacts_cubit.dart
    │   ├── contacts_list_cubit.dart
    │   ├── cubits.dart
    │   └── prospects_cubit.dart
    └── widgets/
        ├── add_contact_form.dart
        ├── add_prospect_form.dart
        ├── company_header.dart
        ├── contact_header.dart
        ├── contact_item.dart
        ├── contact_utils.dart
        ├── contacts_loading_shimmer.dart
        ├── create_interlocuteur_form.dart
        ├── detail_card.dart
        ├── detail_row.dart
        ├── edit_contact_form.dart
        ├── edit_prospect_form.dart
        ├── interlocuteur_item.dart
        ├── prospect_item.dart
        ├── quick_action_button.dart
        └── section_header.dart
```

---

## File Descriptions

### Models (`models/`)

#### `contact.dart`
**Purpose:** Defines the `Contact` data model and `ContactType` enum.

- **`ContactType`**: Enum with values `client` and `prospect` to differentiate contact types.
- **`Contact`**: Main contact model with properties:
  - `id`: Unique identifier
  - `name`: Contact's full name
  - `phoneNumber`: Phone number
  - `email`: Email address
  - `company`: Associated company name
  - `type`: ContactType (client or prospect)
- **Methods:**
  - `fromJson()`: Factory constructor for API responses
  - `toJson()`: Converts model to JSON for API requests
  - `fromMap()`: Factory constructor for SQLite data
  - `toMap()`: Converts model to Map for SQLite
  - `copyWith()`: Creates a copy with optional field overrides

---

#### `prospect.dart`
**Purpose:** Defines the `Prospect` data model and `ProspectStatus` enum.

- **`ProspectStatus`**: Enum representing prospect stages:
  - `interested`: Prospect is interested
  - `notInterested`: Prospect is not interested
  - `notCompleted`: Follow-up not completed
  - `prospect`: Initial prospect status
  - `client`: Converted to client
- **`Prospect`**: Business prospect model with properties:
  - `id`, `entreprise` (company name), `adresse`, `wilaya`, `commune`
  - `phoneNumber`, `email`
  - `categorie`, `formeLegale`, `secteur`, `sousSecteur`
  - `nif`, `registreCommerce`, `status`
- **Methods:**
  - `fromJson()`, `toJson()`: JSON serialization
  - `fromMap()`, `toMap()`: SQLite serialization
  - `getStatusLabel()`: Returns French label for status
  - `copyWith()`: Creates a copy with modifications

---

### Domain Layer (`domain/`)

#### `contacts_repository.dart`
**Purpose:** Abstract repository interface defining the contract for contact operations.

- **Methods:**
  - `getContacts()`: Retrieves all contacts
  - `addContact()`: Creates a new contact
  - `updateContact()`: Updates an existing contact
  - `deleteContact()`: Removes a contact by ID

---

#### `prospect_repository.dart`
**Purpose:** Abstract repository interface for prospect operations.

- **Methods:**
  - `getProspects()`: Retrieves all prospects
  - `addProspect()`: Creates a new prospect
  - `updateProspect()`: Updates an existing prospect
  - `deleteProspect()`: Removes a prospect by ID

---

#### `get_contacts_use_case.dart`
**Purpose:** Use case for fetching contacts list.

- Encapsulates the business logic for retrieving contacts
- Takes `ContactsRepository` as dependency
- `call()` method executes the use case

---

#### `add_contact_use_case.dart`
**Purpose:** Use case for creating a new contact.

- Validates and adds a contact through the repository
- Implements single responsibility principle

---

#### `get_prospects_use_case.dart`
**Purpose:** Use case for fetching prospects list.

- Similar to `GetContactsUseCase` but for prospects
- Takes `ProspectRepository` as dependency

---

#### `add_prospect_use_case.dart`
**Purpose:** Use case for creating a new prospect.

- Handles business logic for prospect creation
- Delegates persistence to repository

---

### Data Layer (`data/`)

#### `contacts_repository_impl.dart`
**Purpose:** Concrete implementation of `ContactsRepository`.

- Implements all repository interface methods
- Delegates to `IContactsRemoteDataSource` for data operations
- Handles error wrapping and exception translation

---

#### `prospect_repository_impl.dart`
**Purpose:** Concrete implementation of `ProspectRepository`.

- Similar to `ContactsRepositoryImpl` but for prospects
- Uses `IProspectsRemoteDataSource` for API calls

---

#### `contacts_local_data_source.dart`
**Purpose:** SQLite local storage for contacts (offline support).

- Uses `DBHelper` for database operations
- **Methods:**
  - `fetchContacts()`: Queries all contacts from local DB
  - `fetchContactById()`: Gets single contact
  - `addContact()`: Inserts new contact
  - `updateContact()`: Updates existing contact
  - `deleteContact()`: Removes contact
  - `seedInitialData()`: Populates initial test data

---

#### `prospect_local_data_source.dart`
**Purpose:** SQLite local storage for prospects (offline support).

- Similar structure to contacts local data source
- Includes debug logging for troubleshooting
- Has `seedInitialData()` for initial prospect data

---

#### `datasources/contacts_remote_data_source.dart`
**Purpose:** Remote API data source for contacts.

- **Interface:** `IContactsRemoteDataSource` - abstraction for testing
- **Implementation:** `ContactsRemoteDataSource`
- Uses `Dio` HTTP client
- **Endpoints:** `/contacts/` for CRUD operations
- Handles response parsing and error handling

---

#### `datasources/prospects_remote_data_source.dart`
**Purpose:** Remote API data source for prospects.

- Similar to contacts remote data source
- Includes user ID injection from `LocalStorageService`
- More detailed error handling with field-level error extraction
- **Endpoints:** `/prospects/` for CRUD operations

---

### Presentation Layer - Cubits (`presentation/cubits/`)

#### `contacts_cubit.dart`
**Purpose:** Main state management for contacts.

- **States:**
  - `ContactsInitial`: Initial state
  - `ContactsLoading`: Loading in progress
  - `ContactsLoaded`: Data loaded successfully with contacts list
  - `ContactsError`: Error occurred with message
- **Methods:**
  - `loadContacts()`: Fetches contacts from repository
  - `addContact()`: Adds new contact with optimistic update
  - `updateContact()`: Updates contact with optimistic update
  - `deleteContact()`: Removes contact with optimistic update
  - `getInterlocuteursForProspect()`: Filters contacts by company

---

#### `prospects_cubit.dart`
**Purpose:** Main state management for prospects.

- **States:** `ProspectsInitial`, `ProspectsLoading`, `ProspectsLoaded`, `ProspectsError`
- **Methods:**
  - `loadProspects()`: Fetches all prospects
  - `addProspect()`: Creates new prospect
  - `updateProspect()`: Updates prospect
  - `deleteProspect()`: Removes prospect
  - `convertProspectToClient()`: Handles conversion workflow

---

#### `contacts_list_cubit.dart`
**Purpose:** Manages tab selection state in contacts list screen.

- **`ContactType` enum:** `client`, `prospect` for tab identification
- **States:** `ContactsListInitial`, `ContactsListTabChanged`
- Tracks `selectedType` for current active tab
- `changeTab()`: Switches between Contacts and Prospects tabs

---

#### `add_contact_cubit.dart`
**Purpose:** Handles add contact form submission state.

- Uses `AddContactUseCase` for business logic
- **States:** Initial, Loading, Success, Failure
- Simpler cubit for single action (form submission)

---

#### `add_contact_state.dart`
**Purpose:** State definitions for AddContactCubit.

- `AddContactInitial`: Form ready state
- `AddContactLoading`: Submission in progress
- `AddContactSuccess`: Contact created successfully
- `AddContactFailure`: Error with message

---

#### `add_prospect_cubit.dart` & `add_prospect_state.dart`
**Purpose:** Similar to add contact cubit but for prospects.

- Handles prospect form submission workflow
- Same state pattern as AddContactCubit

---

#### `cubits.dart`
**Purpose:** Barrel file for exporting all cubits.

- Simplifies imports in other files
- Exports: `contacts_cubit.dart`, `prospects_cubit.dart`, `contacts_list_cubit.dart`

---

### Presentation Layer - Screens (`presentation/`)

#### `contacts_list_screen.dart`
**Purpose:** Main screen displaying contacts and prospects in tabs.

- **Structure:**
  - Uses `MultiBlocProvider` to provide multiple cubits
  - Tab bar for switching between Contacts and Prospects
  - Pull-to-refresh functionality
- **Features:**
  - Loading shimmer during data fetch
  - Error handling with retry option
  - Empty state messages
  - Navigation to detail screens on item tap

---

#### `contact_form_screen.dart`
**Purpose:** Contact detail view and action screen.

- **Features:**
  - Displays contact information with `ContactHeader`
  - Quick action buttons: Call, Email, Video (Google Meet)
  - Edit contact via `EditContactForm` modal
  - Delete contact with confirmation dialog
- **Actions:**
  - `_makePhoneCall()`: Direct phone call using `flutter_phone_direct_caller`
  - `_sendEmail()`: Opens email client with pre-filled subject
  - `_startGoogleMeet()`: Launches Google Meet
- Uses `BlocBuilder` to keep data fresh

---

#### `prospect_detail_form_screen.dart`
**Purpose:** Prospect detail view with interlocuteurs management.

- **Features:**
  - Company header with status chip
  - Quick actions: Change status, Add interlocuteur, Calendar
  - Interlocuteurs list (contacts linked to prospect)
  - Company details card with all business information
- **Methods:**
  - `_showEditForm()`: Opens edit prospect modal
  - `_delete()`: Deletes prospect with confirmation
  - `_convertToClient()`: Changes prospect status
  - `_showCreateInterlocuteurForm()`: Adds new contact linked to prospect
- Uses both `ProspectsCubit` and `ContactsCubit` via `BlocBuilder`

---

### Presentation Layer - Widgets (`presentation/widgets/`)

#### `contact_item.dart`
**Purpose:** List item widget for displaying a single contact.

- Shows avatar with initials, name, company, phone number
- Uses `Card` with `InkWell` for tap handling
- Different avatar color based on contact type

---

#### `prospect_item.dart`
**Purpose:** List item widget for displaying a single prospect.

- Shows company initials, name, and address
- Similar structure to `ContactItem`
- Navigates to `ProspectDetailFormScreen` on tap

---

#### `add_contact_form.dart`
**Purpose:** Modal form for creating new contacts.

- Form fields: name, phone, email, company
- Uses `ContactValidator` for input validation
- Integrates with `AddContactCubit` for submission
- Shows success/error snackbars

---

#### `add_prospect_form.dart`
**Purpose:** Modal form for creating new prospects.

- Extended form fields for business information
- Fields: entreprise, adresse, wilaya, commune, categorie, etc.
- Integrates with `AddProspectCubit`

---

#### `edit_contact_form.dart`
**Purpose:** Modal form for editing existing contacts.

- Pre-populates fields with current contact data
- Validates changes before submission
- Calls `onSave` callback with updated contact
- Shows loading indicator during submission

---

#### `edit_prospect_form.dart`
**Purpose:** Modal form for editing existing prospects.

- Pre-populates all prospect fields
- Preserves unchanged fields (phone, email, etc.)
- Handles async save with error handling

---

#### `create_interlocuteur_form.dart`
**Purpose:** Form for adding a new interlocuteur (contact linked to prospect).

- Fields: name, phone, email
- Auto-assigns company from prospect
- Creates contact with `ContactType.prospect`

---

#### `contact_header.dart`
**Purpose:** Reusable header component for contact details.

- Displays large circular avatar with initials
- Shows contact name prominently

---

#### `company_header.dart`
**Purpose:** Reusable header component for prospect/company details.

- Similar to `ContactHeader` but for companies
- Shows company name and address

---

#### `contact_utils.dart`
**Purpose:** Utility class with helper functions.

- `getInitials()`: Extracts initials from a name (e.g., "John Doe" → "JD")
- Used throughout the feature for avatar generation

---

#### `quick_action_button.dart`
**Purpose:** Circular action button with icon and label.

- Customizable icon, label, and color
- Used for call, email, video, and other quick actions
- Material design with ripple effect

---

#### `section_header.dart`
**Purpose:** Section title with optional action button.

- Displays section title (e.g., "Interlocuteurs")
- Optional action icon button on the right
- Reusable across detail screens

---

#### `detail_row.dart`
**Purpose:** Single row for displaying labeled information.

- `DetailRow` class: Data container with icon, label, value
- `DetailRowWidget`: Renders the row with icon, label, and value
- Used in `DetailCard` for company information

---

#### `detail_card.dart`
**Purpose:** Card container for multiple detail rows.

- Takes list of `DetailRow` objects
- Renders them in a styled card with border

---

#### `interlocuteur_item.dart`
**Purpose:** List item for displaying an interlocuteur.

- Shows contact avatar, name, and phone
- Tappable with optional callback
- Used in prospect detail screen

---

#### `contacts_loading_shimmer.dart`
**Purpose:** Loading placeholder animation.

- Displays 8 shimmer items mimicking contact list structure
- Provides visual feedback during data loading
- Uses surface color from theme

---

## Key Design Patterns

1. **Clean Architecture**: Clear separation of data, domain, and presentation layers
2. **Repository Pattern**: Abstract data access behind interfaces
3. **Cubit Pattern**: Simplified BLoC for state management
4. **Optimistic Updates**: UI updates immediately, reverts on error
5. **Dependency Injection**: Repositories and use cases injected into cubits
6. **Factory Pattern**: `fromJson()` and `fromMap()` factory constructors

---

## State Management Flow

```
User Action → Widget → Cubit.method() → 
  → Emit Loading State → 
  → Execute Use Case / Repository → 
  → On Success: Emit Loaded State → 
  → On Error: Emit Error State → 
  → BlocBuilder rebuilds UI
```

---

## Dependencies

- **flutter_bloc**: State management
- **dio**: HTTP client for API calls
- **sqflite**: Local SQLite database
- **url_launcher**: Opening URLs, email, SMS
- **flutter_phone_direct_caller**: Direct phone calls
