import 'package:flutter/material.dart';

class UserRegistrationWidgetsController {
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    final pattern =
        r"^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
        r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    final regex = RegExp(pattern);
    return regex.hasMatch(email.trim());
  }

  static bool isValidPassword(String password) {
    if (password.trim().isEmpty) return false;
    if (password.length < 8) return false;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacter = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
    return hasUppercase && hasLowercase && hasNumber && hasSpecialCharacter;
  }

  static Future<String> submitForm(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return 'Please fix the errors before submitting.';
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return 'Registration successful!';
  }
}
