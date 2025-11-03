// lib/features/contacts/models/contact.dart

enum ContactType {
  client,
  prospect,
}

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String company;
  final ContactType type; // NEW FIELD

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.company = '',
    this.type = ContactType.client, // DEFAULT TO CLIENT
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      company: json['company'] as String? ?? '',
      type: json['type'] == 'prospect' ? ContactType.prospect : ContactType.client,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'company': company,
    'type': type == ContactType.prospect ? 'prospect' : 'client',
  };
}
