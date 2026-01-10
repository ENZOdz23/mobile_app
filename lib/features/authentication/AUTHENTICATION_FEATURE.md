# Authentication Feature Documentation

## Overview

The **Authentication Feature** handles user login via phone number with OTP (One-Time Password) verification. It follows **Clean Architecture** principles with clear separation between data, domain, and presentation layers. The feature uses the **BLoC/Cubit pattern** for state management and securely stores authentication tokens for session persistence.

---

## Feature Flow

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              PRESENTATION LAYER                              │
│  ┌─────────────────────┐              ┌─────────────────────┐               │
│  │    LoginScreen      │              │     OtpScreen       │               │
│  │  (Phone input)      │─────────────▶│  (OTP verification) │               │
│  └──────────┬──────────┘              └──────────┬──────────┘               │
│             │                                    │                          │
│  ┌──────────▼────────────────────────────────────▼──────────────────────┐   │
│  │                         AuthCubit (State Management)                  │   │
│  │   States: AuthInitial | AuthLoading | AuthSuccess | AuthError |       │   │
│  │           OtpVerificationSuccess | AuthAuthenticated                  │   │
│  └────────────────────────────────────┬─────────────────────────────────┘   │
└───────────────────────────────────────┼─────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼─────────────────────────────────────┐
│                               DOMAIN LAYER                                   │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                            Use Cases                                 │    │
│  │  CheckPhoneExistsUseCase │ RequestOtpUseCase │ VerifyOtpUseCase     │    │
│  │                          │                   │ ResendOtpUseCase     │    │
│  └──────────────────────────┼───────────────────┼──────────────────────┘    │
│                             │                   │                           │
│  ┌──────────────────────────▼───────────────────▼──────────────────────┐    │
│  │                      Repositories (Abstract)                         │    │
│  │           LoginRepository    │     OtpRepository                     │    │
│  └──────────────────────────────┴───────────────────────────────────────┘    │
└───────────────────────────────────────┬─────────────────────────────────────┘
                                        │
┌───────────────────────────────────────▼─────────────────────────────────────┐
│                                DATA LAYER                                    │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                    Repository Implementations                         │   │
│  │        LoginRepositoryImpl       │      OtpRepositoryImpl             │   │
│  └──────────────────────────────────┴───────────────────────────────────┘   │
│                                        │                                     │
│  ┌─────────────────────────────────────▼────────────────────────────────┐   │
│  │                       AuthRemoteDataSource                            │   │
│  │   checkPhoneNumberExists | requestOtp | verifyOtp | resendOtp         │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                        │                                     │
│                                        ▼                                     │
│                              Backend API (Dio HTTP)                          │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## User Flow

### Complete Authentication Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          USER AUTHENTICATION FLOW                            │
└─────────────────────────────────────────────────────────────────────────────┘

     ┌─────────────┐
     │   START     │
     └──────┬──────┘
            │
            ▼
┌─────────────────────────────────────────────┐
│            LOGIN SCREEN                      │
│  ┌─────────────────────────────────────┐    │
│  │ Enter Phone Number: [__________]    │    │
│  │                                     │    │
│  │ [  Demander le code OTP  ]          │    │
│  └─────────────────────────────────────┘    │
└─────────────────────┬───────────────────────┘
                      │ User submits phone
                      ▼
            ┌──────────────────┐
            │ Validate Phone   │
            │ Format (10 digits)│
            └────────┬─────────┘
                     │
                     ▼
    ┌─────────────────────────────────────┐
    │  Check Phone Exists in Database     │
    │  (checkPhoneNumberExists API call)  │
    └─────────────────┬───────────────────┘
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
   ┌─────────────┐        ┌────────────────┐
   │ Phone Found │        │ Phone Not Found │
   │   (200 OK)  │        │   (404/Error)   │
   └──────┬──────┘        └───────┬────────┘
          │                       │
          │                       ▼
          │              ┌────────────────────┐
          │              │ Show Error:        │
          │              │ "Ce numéro n'est   │
          │              │ pas enregistré"    │
          │              └────────────────────┘
          │
          ▼
┌─────────────────────────────────┐
│  Request OTP                    │
│  (POST /otps/generate/)         │
│  Returns: otp_code              │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│               OTP SCREEN                            │
│  ┌─────────────────────────────────────────────┐   │
│  │      Your phone: 0542930649                 │   │
│  │                                             │   │
│  │   [ ] [ ] [ ] [ ] [ ]  ← 5-digit OTP        │   │
│  │                                             │   │
│  │        [  Confirmer  ]                      │   │
│  │                                             │   │
│  │   Renvoyer dans 30s / Renvoyer le code      │   │
│  └─────────────────────────────────────────────┘   │
│                                                    │
│  ┌─────────────────────────────────────────────┐   │
│  │  OTP Popup (Development Mode):              │   │
│  │  "Votre code OTP est: 12345"                │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────┬───────────────────────────────┘
                      │ User enters OTP code
                      ▼
┌─────────────────────────────────────────────┐
│  Verify OTP                                 │
│  (POST /otps/verify/)                       │
│  Payload: { otp_code, phone_number }        │
└─────────────────────┬───────────────────────┘
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
   ┌─────────────┐        ┌────────────────┐
   │ OTP Valid   │        │  OTP Invalid   │
   │ (200 OK)    │        │   (Error)      │
   └──────┬──────┘        └───────┬────────┘
          │                       │
          │                       ▼
          │              ┌────────────────────────┐
          │              │ Show Error:            │
          │              │ "Code OTP incorrect"   │
          │              │ Attempts: X/3          │
          │              │                        │
          │              │ After 3 failed:        │
          │              │ "Compte bloqué 1h"     │
          │              └────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────┐
│  Store Authentication Data                  │
│  ┌───────────────────────────────────────┐ │
│  │ LocalStorageService:                  │ │
│  │   - saveAuthToken(token)              │ │
│  │   - saveUserPhone(phoneNumber)        │ │
│  │   - saveUserId(userId)                │ │
│  │   - setLoggedIn(true)                 │ │
│  └───────────────────────────────────────┘ │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
               ┌─────────────┐
               │  DASHBOARD  │
               │   (Home)    │
               └─────────────┘
```

### Resend OTP Flow

```
User on OTP Screen
       │
       │ Timer expires (30s) OR clicks "Renvoyer le code"
       ▼
┌─────────────────────────────────┐
│  Resend OTP                     │
│  (POST /otps/generate/)         │
│  Returns: new otp_code          │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  Clear OTP input fields         │
│  Reset 30s timer                │
│  Show new OTP popup (dev mode)  │
└─────────────────────────────────┘
```

---

## Data Flow

### Login Phase

```
LoginScreen (UI)
       │
       │ 1. User enters phone number
       │ 2. Clicks "Demander le code OTP"
       ▼
┌─────────────────────────────────┐
│  CheckPhoneExistsUseCase.call() │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  LoginRepositoryImpl            │
│  .checkPhoneNumberExists()      │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  AuthRemoteDataSource           │
│  GET /phone-numbers/            │
│  ?phone_number=XXXXXXXXXX       │
└─────────────────┬───────────────┘
                  │
                  ▼
         API Response (200/404)
                  │
                  ▼
┌─────────────────────────────────┐
│  If 200: RequestOtpUseCase.call()│
│  POST /otps/generate/           │
└─────────────────┬───────────────┘
                  │
                  ▼
         Navigate to OtpScreen
         with phoneNumber & otpCode
```

### OTP Verification Phase

```
OtpScreen (UI)
       │
       │ 1. User enters 5-digit OTP
       │ 2. Auto-submits or clicks "Confirmer"
       ▼
┌─────────────────────────────────┐
│  AuthCubit.verifyOtp()          │
│  Emit: AuthLoading              │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  VerifyOtpUseCase.call(otp)     │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  OtpRepositoryImpl.verifyOtp()  │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  AuthRemoteDataSource           │
│  POST /otps/verify/             │
│  { otp_code, phone_number }     │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  Parse Response:                │
│  - Extract token                │
│  - Extract user_id              │
│  - Store in API client          │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  LocalStorageService:           │
│  - Save token, phone, userId    │
│  - Set logged in = true         │
└─────────────────┬───────────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  Emit: OtpVerificationSuccess   │
└─────────────────┬───────────────┘
                  │
                  ▼
         Navigate to Dashboard
```

---

## Folder Structure

```
lib/features/authentication/
├── data/                              # Data Layer
│   ├── datasources/
│   │   └── auth_remote_data_source.dart
│   ├── login_repository_impl.dart
│   └── otp_repository_impl.dart
│
├── domain/                            # Domain Layer
│   ├── check_phone_exists_usecase.dart
│   ├── login_repository.dart
│   ├── otp_repository.dart
│   ├── request_otp_usecase.dart
│   ├── resend_otp_usecase.dart
│   └── verify_otp_usecase.dart
│
├── models/                            # Data Models
│   ├── auth_response.dart
│   ├── login.dart
│   └── otp.dart
│
└── presentation/                      # Presentation Layer
    ├── auth_bloc.dart                 # (Empty - not used)
    ├── login_screen.dart
    ├── otp_screen.dart
    ├── cubit/
    │   ├── auth_cubit.dart
    │   └── auth_state.dart
    ├── screens/
    │   └── auth_test_screen.dart
    └── widgets/
        ├── login/
        │   ├── login_error_box.dart
        │   ├── login_phone_field.dart
        │   └── login_request_button.dart
        └── opt/
            ├── otp_error_box.dart
            ├── otp_field.dart
            ├── otp_phone_box.dart
            └── otp_verify_button.dart
```

---

## File Descriptions

### Models (`models/`)

#### `login.dart`
**Purpose:** Simple data model for login request.

- **`Login`**: Contains only `phoneNumber` field
- Used to encapsulate phone number for OTP request
- Lightweight model for the login step

---

#### `otp.dart`
**Purpose:** Data model for OTP verification.

- **`Otp`**: Contains:
  - `code`: The 5-digit OTP code entered by user
  - `phoneNumber`: Phone number for verification
- Used to bundle OTP data for verification request

---

#### `auth_response.dart`
**Purpose:** Response model for successful authentication.

- **`AuthResponse`**: Contains:
  - `token`: JWT authentication token
  - `userId`: Optional user identifier
  - `phoneNumber`: Authenticated phone number
- Returned after successful OTP verification
- Used to persist authentication data

---

### Domain Layer (`domain/`)

#### `login_repository.dart`
**Purpose:** Abstract repository interface for login operations.

- **Methods:**
  - `checkPhoneNumberExists(phoneNumber)`: Verifies if phone is registered
  - `requestOtp(phoneNumber)`: Triggers OTP generation and sending

---

#### `otp_repository.dart`
**Purpose:** Abstract repository interface for OTP operations.

- **Methods:**
  - `verifyOtp(otp)`: Validates OTP and returns `AuthResponse` with token
  - `resendOtp(phoneNumber)`: Generates and sends a new OTP code

---

#### `check_phone_exists_usecase.dart`
**Purpose:** Use case for validating phone number registration.

- Takes `LoginRepository` as dependency
- `call(phoneNumber)`: Returns `bool` indicating if phone exists
- First step in authentication flow to ensure phone is registered

---

#### `request_otp_usecase.dart`
**Purpose:** Use case for requesting OTP generation.

- Takes `LoginRepository` as dependency
- `call(phoneNumber)`: Triggers OTP creation, returns OTP code (for dev)
- Called after phone validation succeeds

---

#### `verify_otp_usecase.dart`
**Purpose:** Use case for OTP verification and token retrieval.

- Takes `OtpRepository` as dependency
- `call(otp)`: Validates OTP, returns `AuthResponse` with token
- Core authentication step that grants access

---

#### `resend_otp_usecase.dart`
**Purpose:** Use case for requesting a new OTP.

- Takes `OtpRepository` as dependency
- `call(phoneNumber)`: Generates new OTP, returns code
- Used when user needs a fresh OTP code

---

### Data Layer (`data/`)

#### `login_repository_impl.dart`
**Purpose:** Concrete implementation of `LoginRepository`.

- Implements `checkPhoneNumberExists` and `requestOtp`
- Delegates to `IAuthRemoteDataSource`
- Handles error propagation via rethrow

---

#### `otp_repository_impl.dart`
**Purpose:** Concrete implementation of `OtpRepository`.

- Implements `verifyOtp` and `resendOtp`
- Delegates to `IAuthRemoteDataSource`
- Wraps exceptions with descriptive messages

---

#### `datasources/auth_remote_data_source.dart`
**Purpose:** Remote API data source for all authentication operations.

- **Interface:** `IAuthRemoteDataSource` - abstraction for testing
- **Implementation:** `AuthRemoteDataSource` using `Dio` HTTP client

**Key Methods:**

| Method | Endpoint | Description |
|--------|----------|-------------|
| `checkPhoneNumberExists` | `GET /phone-numbers/` | Checks if phone is registered (200=exists, 404=not found) |
| `requestOtp` | `POST /otps/generate/` | Generates OTP, returns `otp_code` |
| `verifyOtp` | `POST /otps/verify/` | Validates OTP, returns token + user info |
| `resendOtp` | `POST /otps/generate/` | Same as requestOtp (generates new code) |

**Helper Methods:**
- `_extractUserId()`: Safely extracts user ID from various response formats
- `_extractErrorMessage()`: Parses error messages from DioException responses

**Token Handling:**
- On successful verification, stores token via `Api.setToken(token)`
- Extracts token from `token`, `auth_token`, or `access_token` fields

---

### Presentation Layer - Cubit (`presentation/cubit/`)

#### `auth_cubit.dart`
**Purpose:** Main state management for authentication flow.

- **Dependencies:**
  - `RequestOtpUseCase`: For requesting OTP
  - `VerifyOtpUseCase`: For OTP verification
  - `ResendOtpUseCase`: For resending OTP
  - `LocalStorageService`: For persisting auth data

**Methods:**

| Method | Description |
|--------|-------------|
| `_checkAuthStatus()` | Called on init, emits `AuthAuthenticated` if token exists |
| `requestOtp(phone)` | Requests OTP, emits Loading → Success/Error |
| `verifyOtp(phone, code)` | Verifies OTP, stores token, emits Success/Error |
| `resendOtp(phone)` | Resends OTP, emits Loading → Success with new code |
| `logout()` | Clears all auth data, emits `AuthInitial` |

**Token Storage on Verification:**
- `saveAuthToken(token)`
- `saveUserPhone(phoneNumber)`
- `saveUserId(userId)` - if available
- `setLoggedIn(true)`

---

#### `auth_state.dart`
**Purpose:** State definitions for AuthCubit.

| State | Description |
|-------|-------------|
| `AuthInitial` | Initial state, no authentication |
| `AuthLoading` | Operation in progress |
| `AuthSuccess` | Operation succeeded, contains message and optional otpCode |
| `AuthError` | Operation failed with error message |
| `OtpVerificationSuccess` | OTP verified successfully, ready to navigate |
| `AuthAuthenticated` | User has valid stored credentials |

---

### Presentation Layer - Screens (`presentation/`)

#### `login_screen.dart`
**Purpose:** Phone number input screen for initiating login.

**Features:**
- Phone number input with validation (10 digits, Algeria format)
- Error display for invalid/unregistered numbers
- Loading state during API calls
- Navigation to OTP screen on success

**Flow:**
1. User enters phone number
2. Form validation (PhoneValidator)
3. Check if phone exists (CheckPhoneExistsUseCase)
4. Request OTP if phone exists (RequestOtpUseCase)
5. Navigate to OtpScreen with phone and OTP code

**Widgets Used:**
- `LoginPhoneField`: Phone input with formatting
- `LoginErrorBox`: Error message display
- `LoginRequestButton`: Submit button with loading state

---

#### `otp_screen.dart`
**Purpose:** OTP input and verification screen.

**Features:**
- 5-digit OTP input (individual boxes)
- Auto-submit when all digits entered
- 30-second resend timer
- Maximum 3 attempts before lockout
- OTP popup display (development mode)
- Error handling with clear messages

**State Management:**
- Uses `BlocListener` for `AuthCubit` state changes
- Local state for timer, attempts, loading, errors

**Security Features:**
- `_maxAttempts = 3`: Account lockout after 3 failed attempts
- `_resendTimer = 30`: Cooldown between resend requests
- Lockout message: "Compte temporairement bloqué pendant 1 heure"

**Widgets Used:**
- `OtpField`: Individual digit input box
- `OtpPhoneBox`: Displays phone number
- `OtpErrorBox`: Error message display
- `OtpVerifyButton`: Submit button with loading state

---

#### `screens/auth_test_screen.dart`
**Purpose:** Development/testing screen for authentication APIs.

- Manual testing interface for auth endpoints
- Input fields for phone and OTP
- Buttons: Request OTP, Verify OTP, Resend OTP
- Log display showing API responses
- Useful for debugging authentication issues

---

### Presentation Layer - Widgets

#### `widgets/login/login_phone_field.dart`
**Purpose:** Styled phone number input field.

- Phone keyboard type
- Digit-only filter
- 10 character limit
- Error state border styling
- Change callback for clearing errors

---

#### `widgets/login/login_error_box.dart`
**Purpose:** Error message container for login screen.

- Red-tinted background
- Error icon
- Error message text
- Consistent styling with theme

---

#### `widgets/login/login_request_button.dart`
**Purpose:** OTP request button with loading state.

- Accent color background
- Loading spinner when processing
- Disabled during loading
- "Demander le code OTP" label

---

#### `widgets/opt/otp_field.dart`
**Purpose:** Single digit OTP input box.

- Fixed 50x60 size
- Centered text input
- Single character limit
- Border color changes: grey (empty) → accent (filled) → red (error)
- Focus management support

---

#### `widgets/opt/otp_phone_box.dart`
**Purpose:** Display box showing phone number on OTP screen.

- Light background with border
- Shows the phone number being verified
- Read-only display

---

#### `widgets/opt/otp_error_box.dart`
**Purpose:** Error message container for OTP screen.

- Same styling as `LoginErrorBox`
- Red background, error icon, message text
- Used for incorrect OTP messages

---

#### `widgets/opt/otp_verify_button.dart`
**Purpose:** OTP verification button with states.

- Loading spinner during verification
- Disabled when max attempts reached
- "Confirmer" label
- Accent color styling

---

## API Endpoints

| Endpoint | Method | Purpose | Request | Response |
|----------|--------|---------|---------|----------|
| `/phone-numbers/` | GET | Check phone exists | `?phone_number=X` | 200 (exists) / 404 (not found) |
| `/otps/generate/` | POST | Generate OTP | `{ phone_number }` | `{ otp_code }` |
| `/otps/verify/` | POST | Verify OTP | `{ otp_code, phone_number }` | `{ token, user_id }` |

---

## Security Features

1. **Phone Verification**: Only registered phone numbers can request OTP
2. **Rate Limiting**: 30-second cooldown between OTP requests
3. **Attempt Limiting**: 3 failed attempts = 1-hour lockout
4. **Token Storage**: Secure local storage via `LocalStorageService`
5. **Session Persistence**: Auto-login if valid token exists

---

## Key Design Patterns

1. **Clean Architecture**: Clear separation of data, domain, presentation
2. **Repository Pattern**: Abstract data access behind interfaces
3. **Use Case Pattern**: Single-responsibility business logic
4. **Cubit Pattern**: Simplified state management
5. **Dependency Injection**: Repositories/use cases injected into cubits

---

## Dependencies

- **flutter_bloc**: State management (Cubit)
- **dio**: HTTP client for API calls
- **LocalStorageService**: Secure token/credential storage
- **PhoneValidator**: Input validation utility
- **Api**: Centralized API client configuration

---

## Session Lifecycle

```
App Start
    │
    ▼
┌─────────────────────────────────┐
│  AuthCubit._checkAuthStatus()   │
│  Check LocalStorageService      │
└─────────────────┬───────────────┘
                  │
    ┌─────────────┴─────────────┐
    │                           │
    ▼                           ▼
Token Exists               No Token
    │                           │
    ▼                           ▼
AuthAuthenticated         AuthInitial
→ Dashboard               → LoginScreen
```

### Logout Flow

```
User clicks Logout
       │
       ▼
AuthCubit.logout()
       │
       ▼
LocalStorageService.clearAllAuthData()
       │
       ▼
Emit AuthInitial
       │
       ▼
Navigate to LoginScreen
```
