// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/main.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
  });

  testWidgets('App loads with LoginPage when not logged in', (WidgetTester tester) async {
    // Open Hive box for testing
    await Hive.openBox('mybox');
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginPage is loaded
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
