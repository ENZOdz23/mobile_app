// lib/features/prospects/models/prospect.dart

enum ProspectStatus {
  interested,      // Intéressé
  notInterested,   // Non intéressé
  notCompleted,    // Non abouti
  prospect,        // Prospect
  client,          // Converted to client
}

class Prospect {
  final String id;
  
  // Base Information
  final String entreprise;
  final String adresse;
  final String wilaya;
  final String commune;
  
  // Personal Information (Contact)
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
  final ProspectStatus status;

  Prospect({
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
    this.status = ProspectStatus.prospect,
  });

  factory Prospect.fromJson(Map<String, dynamic> json) {
    return Prospect(
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
  };

  static ProspectStatus _statusFromString(String? status) {
    switch (status) {
      case 'interested':
        return ProspectStatus.interested;
      case 'notInterested':
        return ProspectStatus.notInterested;
      case 'notCompleted':
        return ProspectStatus.notCompleted;
      case 'client':
        return ProspectStatus.client;
      default:
        return ProspectStatus.prospect;
    }
  }

  static String _statusToString(ProspectStatus status) {
    switch (status) {
      case ProspectStatus.interested:
        return 'interested';
      case ProspectStatus.notInterested:
        return 'notInterested';
      case ProspectStatus.notCompleted:
        return 'notCompleted';
      case ProspectStatus.client:
        return 'client';
      case ProspectStatus.prospect:
        return 'prospect';
    }
  }

  String getStatusLabel() {
    switch (status) {
      case ProspectStatus.interested:
        return 'Intéressé';
      case ProspectStatus.notInterested:
        return 'Non intéressé';
      case ProspectStatus.notCompleted:
        return 'Non abouti';
      case ProspectStatus.client:
        return 'Client';
      case ProspectStatus.prospect:
        return 'Prospect';
    }
  }
}
