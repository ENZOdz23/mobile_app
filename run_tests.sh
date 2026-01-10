# Test Generation Script
# Run this to generate mock files for testing

# Generate mocks for all test files
flutter pub run build_runner build --delete-conflicting-outputs

# Run all tests
flutter test

# Run specific test suites
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
