// lib/features/clients/models/client.dart

enum ClientStatus {
  interested,      // Intéressé
  notInterested,   // Non intéressé
  active,          // Active client
}

class Client {
  final String id;
  
  // Base Information
  final String entreprise;
  final String adresse;
  final String wilaya;
  final String commune;
  
  // Contact Information
  final String phoneNumber;
  final String email;
  
  // Business Information
  final String categorie;
  final String formeLegale;
  final String secteur;
  final String sousSecteur;
  
  // Legal Information
  final String nif;
  final String registreCommerce;
  
  // Status
  final ClientStatus status;
  
  // Relationships
  final List<String> interlocuteurIds; // Contact IDs

  Client({
    required this.id,
    required this.entreprise,
    this.adresse = '',
    this.wilaya = '',
    this.commune = '',
    this.phoneNumber = '',
    this.email = '',
    this.categorie = '',
    this.formeLegale = '',
    this.secteur = '',
    this.sousSecteur = '',
    this.nif = '',
    this.registreCommerce = '',
    this.status = ClientStatus.active,
    this.interlocuteurIds = const [],
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      entreprise: json['entreprise'] as String,
      adresse: json['adresse'] as String? ?? '',
      wilaya: json['wilaya'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      categorie: json['categorie'] as String? ?? '',
      formeLegale: json['formeLegale'] as String? ?? '',
      secteur: json['secteur'] as String? ?? '',
      sousSecteur: json['sousSecteur'] as String? ?? '',
      nif: json['nif'] as String? ?? '',
      registreCommerce: json['registreCommerce'] as String? ?? '',
      status: _statusFromString(json['status'] as String?),
      interlocuteurIds: (json['interlocuteurIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'entreprise': entreprise,
    'adresse': adresse,
    'wilaya': wilaya,
    'commune': commune,
    'phoneNumber': phoneNumber,
    'email': email,
    'categorie': categorie,
    'formeLegale': formeLegale,
    'secteur': secteur,
    'sousSecteur': sousSecteur,
    'nif': nif,
    'registreCommerce': registreCommerce,
    'status': _statusToString(status),
    'interlocuteurIds': interlocuteurIds,
  };

  static ClientStatus _statusFromString(String? status) {
    switch (status) {
      case 'interested':
        return ClientStatus.interested;
      case 'notInterested':
        return ClientStatus.notInterested;
      default:
        return ClientStatus.active;
    }
  }

  static String _statusToString(ClientStatus status) {
    switch (status) {
      case ClientStatus.interested:
        return 'interested';
      case ClientStatus.notInterested:
        return 'notInterested';
      case ClientStatus.active:
        return 'active';
    }
  }

  String getStatusLabel() {
    switch (status) {
      case ClientStatus.interested:
        return 'Intéressé';
      case ClientStatus.notInterested:
        return 'Non intéressé';
      case ClientStatus.active:
        return 'Client';
    }
  }
}
