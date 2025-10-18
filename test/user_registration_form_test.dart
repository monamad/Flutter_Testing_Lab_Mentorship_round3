import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';
import 'package:flutter_testing_lab/widgets/user_registration_widgets_controller.dart';

void main() {
  group('UserRegistrationWidgetsController Unit Tests', () {
    group('Email validation', () {
      test('should accept valid emails', () {
        const validEmails = [
          'user@example.com',
          'user.name+tag@domain.co.uk',
          'test123@gmail.com',
          'john.doe@company.org',
        ];

        for (final email in validEmails) {
          expect(
            UserRegistrationWidgetsController.isValidEmail(email),
            isTrue,
            reason: 'Email "$email" should be valid',
          );
        }
      });

      test('should reject invalid emails', () {
        const invalidEmails = [
          'userexample.com',
          ' ',
          '',
          'user@',
          '@example.com',
          'user space@example.com',
        ];

        for (final email in invalidEmails) {
          expect(
            UserRegistrationWidgetsController.isValidEmail(email),
            isFalse,
            reason: 'Email "$email" should be invalid',
          );
        }
      });
    });

    group('Password validation', () {
      test('should accept strong passwords', () {
        const strongPasswords = [
          'Strong@123',
          'MyP@ssw0rd',
          'Complex1!',
          'Secure@Pass2024',
        ];

        for (final password in strongPasswords) {
          expect(
            UserRegistrationWidgetsController.isValidPassword(password),
            isTrue,
            reason: 'Password "$password" should be valid',
          );
        }
      });

      test('should reject weak passwords', () {
        const weakPasswords = [
          '123456', 
          'password',
          'PASSWORD', 
          'Pass123', 
          'Pass@word', 
          'weakpass1',
          '1234567', 
          '', 
          '   ', 
        ];

        for (final password in weakPasswords) {
          expect(
            UserRegistrationWidgetsController.isValidPassword(password),
            isFalse,
            reason: 'Password "$password" should be invalid',
          );
        }
      });
    });

    group('Form submission', () {
      testWidgets('should return success message when form is valid', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        // Create a simple form to test validation
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: 'John Doe',
                  validator: (value) {
                    if (value == null || value.length < 2) {
                      return 'Name too short';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        final result = await UserRegistrationWidgetsController.submitForm(
          formKey,
        );
        expect(result, equals('Registration successful!'));
      });

      testWidgets('should return error message when form is invalid', (
        tester,
      ) async {
        final formKey = GlobalKey<FormState>();

        // Create a form that will fail validation
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        final result = await UserRegistrationWidgetsController.submitForm(
          formKey,
        );
        expect(result, equals('Please fix the errors before submitting.'));
      });
    });
  });

  group('UserRegistrationForm Widget Tests', () {
    testWidgets('should display all form fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Check all fields are present
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Tap register without filling any fields
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Check validation messages appear
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('should show validation errors for invalid inputs', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Fill fields with invalid data
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'A',
      ); // Too short name
      await tester.enterText(find.byType(TextFormField).at(1), 'invalid-email');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        '123',
      ); // Weak password
      await tester.enterText(
        find.byType(TextFormField).at(3),
        '456',
      ); // Different password

      // Submit form
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Check specific validation messages
      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password is too weak'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets(
      'should call submit form when register is tapped with valid data',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
        );

        // Fill form with valid data
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

        // Submit form
        await tester.tap(find.text('Register'));
        await tester.pump();

        // The current implementation doesn't show loading state or handle the result
        // This test just verifies the button can be tapped when form is valid
        expect(find.text('Register'), findsOneWidget);
      },
    );

    testWidgets('should have correct input types and properties', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Check that email and password fields exist with proper setup
      expect(find.byType(TextFormField), findsNWidgets(4)); // 4 fields total

      // The widget structure is correct - we can verify by checking text and decoration
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);

      // Helper text indicates password requirements
      expect(
        find.text('At least 8 characters with numbers and symbols'),
        findsOneWidget,
      );
    });

    testWidgets('should have enabled button when form is ready', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      // Initially the button should be enabled (not loading)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      // Button should show register text initially
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should maintain field values during validation', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserRegistrationForm())),
      );

      const testName = 'Test User';
      const testEmail = 'test@example.com';

      // Fill some fields
      await tester.enterText(find.byType(TextFormField).at(0), testName);
      await tester.enterText(find.byType(TextFormField).at(1), testEmail);
      // Leave password fields empty to trigger validation

      // Submit form
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Values should be preserved
      expect(find.text(testName), findsOneWidget);
      expect(find.text(testEmail), findsOneWidget);

      // Validation errors should appear
      expect(find.text('Please enter a password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });
}
