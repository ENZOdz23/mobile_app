// lib/shared/validators/phone_validator.dart

class PhoneValidator {
  /// Validates Mobilis phone number format (must start with 06).
  /// Only accepts numbers starting with 06 followed by 8 digits.
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Only accept numbers starting with 06 (8 digits after 06 = 10 total digits)
    final phoneRegExp = RegExp(r'^06\d{8}$');
    if (!phoneRegExp.hasMatch(phone)) {
      return 'Phone number must start with 06 and contain 10 digits';
    }
    return null;
  }
}
