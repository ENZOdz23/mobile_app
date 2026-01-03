// lib/features/contacts/models/contact.dart

enum ContactType { client, prospect }

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String company;
  final ContactType type;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.company = '',
    this.type = ContactType.client,
  });

  // fromJson for API responses
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
      company: json['company'] as String? ?? '',
      type: json['type'] == 'prospect'
          ? ContactType.prospect
          : ContactType.client,
    );
  }

  // toJson for API requests
  Map<String, dynamic> toJson() => {
    'name': name,
    'phone_number': phoneNumber,
    'email': email,
    'company': company,
    'type': type == ContactType.prospect ? 'prospect' : 'client',
  };

  // fromMap for SQLite
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String? ?? '',
      company: map['company'] as String? ?? '',
      type: map['type'] == 'prospect'
          ? ContactType.prospect
          : ContactType.client,
    );
  }

  // toMap for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
      'type': type == ContactType.prospect ? 'prospect' : 'client',
    };
  }

  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? company,
    ContactType? type,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      company: company ?? this.company,
      type: type ?? this.type,
    );
  }
}
