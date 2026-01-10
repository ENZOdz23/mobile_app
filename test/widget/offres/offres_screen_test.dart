import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crm_sales_performance_mobilis/features/offres/presentation/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('OffresScreen displays title and categories', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OffresScreen()));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    // Verify title
    expect(find.text('Offres B2B'), findsOneWidget);

    // Verify some categories are present
    expect(find.text('Tous'), findsOneWidget);
    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });
}
