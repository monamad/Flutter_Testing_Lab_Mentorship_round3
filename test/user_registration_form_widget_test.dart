import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('UserRegistrationForm Widget Tests', () {
    testWidgets('should display all form fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);

      expect(
        find.text('At least 8 characters with numbers and symbols'),
        findsOneWidget,
      );
    });

    testWidgets('should show validation errors for empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show validation error for short name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show validation error for weak password', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(2), '123');
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Password is too weak'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(
        find.byType(TextFormField).at(2),
        'StrongPass@123',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'DifferentPass@456',
      );
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should not show validation errors with valid data', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'john@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'StrongPass@123',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'StrongPass@123',
      );

      await tester.tap(find.byType(TextFormField).at(0));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsNothing);
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a password'), findsNothing);
      expect(find.text('Please confirm your password'), findsNothing);
      expect(find.text('Name must be at least 2 characters'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
      expect(find.text('Password is too weak'), findsNothing);
      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('email field should have email keyboard type', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));

      final emailTextField = tester.widget<TextField>(textFields.at(1));
      expect(emailTextField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('password fields should be obscured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));

      final passwordTextField = tester.widget<TextField>(textFields.at(2));
      final confirmPasswordTextField = tester.widget<TextField>(
        textFields.at(3),
      );

      expect(passwordTextField.obscureText, isTrue);
      expect(confirmPasswordTextField.obscureText, isTrue);
    });

    testWidgets('should have 4 text form fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('should maintain field values after validation errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Fill some fields with valid data
      await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'john@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'StrongPass@123',
      );

      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(0),
      );
      final emailField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(1),
      );
      final passwordField = tester.widget<TextFormField>(
        find.byType(TextFormField).at(2),
      );

      expect(nameField.controller?.text, 'John Doe');
      expect(emailField.controller?.text, 'john@example.com');
      expect(passwordField.controller?.text, 'StrongPass@123');

      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });
}
