// lib/features/contacts/presentation/widgets/contact_utils.dart

class ContactUtils {
  static String getInitials(String name) {
    if (name.isEmpty) return "?";
    var parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}