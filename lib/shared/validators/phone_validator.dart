// lib/shared/validators/phone_validator.dart

class PhoneValidator {
  /// Validates Mobilis phone number format (example: Algerian mobile numbers).
  /// Replace with specific regex based on Mobilis number format if needed.
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Mobile numbers in Algeria typically start with +213 or 0 followed by 9 digits
    // Example pattern: optional +213 country code or 0, then 9 digits
    final phoneRegExp = RegExp(r'^(\+213|0)(5|6|7)\d{8}$');
    if (!phoneRegExp.hasMatch(phone)) {
      return 'Invalid Mobilis phone number format';
    }
    return null;
  }
}
