// lib/shared/validators/contact_validator.dart

class ContactValidator {
  /// Validates that a contact name is not empty and contains only letters, spaces, and basic punctuation.
  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    final nameRegExp = RegExp(r"^[a-zA-ZÀ-ÿ\s\.'-]+$");
    if (!nameRegExp.hasMatch(name)) {
      return 'Name contains invalid characters';
    }
    return null;
  }

  /// Validates the contact's email (optional but if provided must be valid format).
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return null; // email optional
    }
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    if (!emailRegExp.hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }

  /// Validates the contact's phone number. Returns a localized-ish message when invalid.
  /// This allows international formats with optional leading +, spaces, dashes and parentheses.
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Accept digits, spaces, dashes, parentheses and optional leading +.
    final digitsOnly = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length != 10) {
      return 'Invalid phone number';
    }
    final phoneRegExp = RegExp(r'^\+?[0-9\s\-\(\)]+$');
    if (!phoneRegExp.hasMatch(phone)) {
      return 'Invalid phone number';
    }
    return null;
  }
}
