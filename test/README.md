# Tests

This directory contains unit and widget tests for each module.

## Structure
Mirror the lib/ directory structure here for corresponding tests.

Example:
```
test/
  features/
    authentication/
      authentication_test.dart
    dashboard/
      dashboard_test.dart
  shared/
    services/
      api_service_test.dart
```

## Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/authentication/authentication_test.dart

# Run with coverage
flutter test --coverage
```
