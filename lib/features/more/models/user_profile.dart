class UserProfile {
  final String name;
  final String role;
  final String email;
  final String phoneNumber;
  final String initials;

  UserProfile({
    required this.name,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.initials,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      initials: json['initials'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'phoneNumber': phoneNumber,
      'initials': initials,
    };
  }
}
