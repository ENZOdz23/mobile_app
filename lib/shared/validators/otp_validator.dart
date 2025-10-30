// lib/shared/validators/otp_validator.dart

class OtpValidator {
  /// Validates OTP code length and characters (numeric only).
  static String? validateOtp(String? otp, {int length = 6}) {
    if (otp == null || otp.isEmpty) {
      return 'OTP code is required';
    }
    if (otp.length != length) {
      return 'OTP code must be $length digits';
    }
    final otpRegExp = RegExp(r'^\d+$');
    if (!otpRegExp.hasMatch(otp)) {
      return 'OTP code must contain digits only';
    }
    return null;
  }
}
