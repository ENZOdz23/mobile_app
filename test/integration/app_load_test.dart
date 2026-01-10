import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:crm_sales_performance_mobilis/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify login screen loads', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that the login screen is displayed
      expect(
        find.text('Gérez vos ventes avec notre application'),
        findsOneWidget,
      );
    });
  });
}
