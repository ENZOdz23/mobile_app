import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/presentation/login_screen.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/presentation/widgets/login/login_phone_field.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/presentation/widgets/login/login_request_button.dart';

void main() {
  testWidgets('LoginScreen displays basic UI elements', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify that the title and subtitle are present.
    expect(
      find.text('Gérez vos ventes avec notre application'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Gérez vos ventes à tout moment'),
      findsOneWidget,
    );

    // Verify that the phone field and button are present.
    expect(find.byType(LoginPhoneField), findsOneWidget);
    expect(find.byType(LoginRequestButton), findsOneWidget);
  });

  testWidgets('LoginScreen shows error when phone number is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap the button without entering anything
    await tester.tap(find.byType(LoginRequestButton));
    await tester.pump();

    // The validator should trigger.
    // We can't easily check internal state, but we can check if it shows validation error.
    // Assuming PhoneValidator.validatePhoneNumber returns 'Ce champ est obligatoire' or similar.
    expect(find.text('Phone number is required'), findsOneWidget);
  });
}
