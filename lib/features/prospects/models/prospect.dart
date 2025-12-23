// lib/features/prospects/models/prospect.dart

enum ProspectStatus {
  interested,
  notInterested,
  notCompleted,
  prospect,
  client,
}

class Prospect {
  final String id;
  final String entreprise;
  final String adresse;
  final String wilaya;
  final String commune;
  final String phoneNumber;
  final String email;
  final String categorie;
  final String formeLegale;
  final String secteur;
  final String sousSecteur;
  final String nif;
  final String registreCommerce;
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

  // fromJson for API responses
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

  // toJson for API requests
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

  // fromMap for SQLite
  factory Prospect.fromMap(Map<String, dynamic> map) {
    return Prospect(
      id: map['id'] as String,
      entreprise: map['entreprise'] as String,
      adresse: map['adresse'] as String? ?? '',
      wilaya: map['wilaya'] as String? ?? '',
      commune: map['commune'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String? ?? '',
      categorie: map['categorie'] as String? ?? '',
      formeLegale: map['formeLegale'] as String? ?? '',
      secteur: map['secteur'] as String? ?? '',
      sousSecteur: map['sousSecteur'] as String? ?? '',
      nif: map['nif'] as String? ?? '',
      registreCommerce: map['registreCommerce'] as String? ?? '',
      status: _statusFromString(map['status'] as String?),
    );
  }

  // toMap for SQLite
  Map<String, dynamic> toMap() {
    return {
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
  }

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

  Prospect copyWith({
    String? id,
    String? entreprise,
    String? adresse,
    String? wilaya,
    String? commune,
    String? phoneNumber,
    String? email,
    String? categorie,
    String? formeLegale,
    String? secteur,
    String? sousSecteur,
    String? nif,
    String? registreCommerce,
    ProspectStatus? status,
  }) {
    return Prospect(
      id: id ?? this.id,
      entreprise: entreprise ?? this.entreprise,
      adresse: adresse ?? this.adresse,
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      categorie: categorie ?? this.categorie,
      formeLegale: formeLegale ?? this.formeLegale,
      secteur: secteur ?? this.secteur,
      sousSecteur: sousSecteur ?? this.sousSecteur,
      nif: nif ?? this.nif,
      registreCommerce: registreCommerce ?? this.registreCommerce,
      status: status ?? this.status,
    );
  }
}
