import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tabletime/Register.dart';

// Mocking the dependencies if needed

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // Boundary test cases
  testWidgets('Register widget boundary test - empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Register(lang: 'en', rows: [])));

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your fullname'), findsOneWidget);
    expect(find.text('Please enter your mobile'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Register widget boundary test - max length fields', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Register(lang: 'en', rows: [])));

    await tester.enterText(find.byType(TextField).at(0), 'a' * 50); // Full name
    await tester.enterText(find.byType(TextField).at(1), '1' * 10); // Mobile number
    await tester.enterText(find.byType(TextField).at(2), 'a' * 50 + '@example.com'); // Email
    await tester.enterText(find.byType(TextField).at(3), 'a' * 20); // Username
    await tester.enterText(find.byType(TextField).at(4), 'a' * 20); // Password

    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify max length validation
  });

  // Successful registration test case
  testWidgets('Register widget test - successful registration', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Register(lang: 'en', rows: [])));

    await tester.enterText(find.byType(TextField).at(0), 'John Doe'); // Full name
    await tester.enterText(find.byType(TextField).at(1), '1234567890'); // Mobile number
    await tester.enterText(find.byType(TextField).at(2), 'john.doe@example.com'); // Email
    await tester.enterText(find.byType(TextField).at(3), 'johndoe'); // Username
    await tester.enterText(find.byType(TextField).at(4), 'password'); // Password

    await tester.tap(find.byType(Radio).first); // Owner

    await tester.tap(find.text('Register'));
    await tester.pump();

    // Verify successful registration
  });
}
