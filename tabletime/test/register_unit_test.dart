import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabletime/register.dart'; // Replace with the correct import path

class Login extends StatelessWidget {
  final String lang;

  const Login({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(); // Replace this with your Login widget implementation
  }
}

void main() {
  group('Register Widget Tests', () {
    testWidgets('Widget builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      expect(find.byType(Register), findsOneWidget);
    });

    testWidgets('Register button works when fields are filled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(0), 'John Doe'); // Full Name
      await tester.enterText(find.byType(TextField).at(1), '1234567890'); // Mobile
      await tester.enterText(find.byType(TextField).at(2), 'john.doe@example.com'); // Email
      await tester.enterText(find.byType(TextField).at(3), 'johndoe'); // Username
      await tester.enterText(find.byType(TextField).at(4), 'Password123!'); // Password
      await tester.tap(find.byType(Radio).first); // Select Owner role
      await tester.tap(find.text('Register')); // Tap register button
      // Check if registration process starts
    });

    testWidgets('Username already exists error message shown when trying to register with existing username', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField).at(3), 'existing_username'); // Username
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for toast message to appear
      expect(find.text('Username already exists'), findsOneWidget);
    });

    testWidgets('Login button navigates to login screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Login')); // Tap login button
      await tester.pump(); // Wait for navigation
      expect(find.byType(Login), findsOneWidget); // Check if navigation to login screen occurs
    });

    // Add more test cases as needed

    testWidgets('Full name validation error message shown when full name field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for error message to appear
      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('Email validation error message shown when email field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for error message to appear
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Password validation error message shown when password field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for error message to appear
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Mobile validation error message shown when mobile field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for error message to appear
      expect(find.text('Please enter your mobile number'), findsOneWidget);
    });

    testWidgets('Username validation error message shown when username field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp( // Wrap with MaterialApp
          home: Directionality(
            textDirection: TextDirection.ltr, // Set the text direction
            child: Register(lang: 'en', rows: []),
          ),
        ),
      );
      await tester.tap(find.text('Register')); // Tap register button
      await tester.pump(); // Wait for error message to appear
      expect(find.text('Please enter your username'), findsOneWidget);
    });
  });
}
