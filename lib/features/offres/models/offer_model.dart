/// Represents a B2B offer from ATM Mobilis
class OfferModel {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String keyBenefit;
  final String? startingPrice;
  final String currency;
  final CompanyType targetCompanyType;
  final List<String> includedServices;
  final String category; // Internet, Mobile, Bundle, Entreprise
  final String icon;

  OfferModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.keyBenefit,
    this.startingPrice,
    this.currency = 'DZD',
    required this.targetCompanyType,
    required this.includedServices,
    required this.category,
    this.icon = 'gift',
  });

  /// Convert OfferModel to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'keyBenefit': keyBenefit,
      'startingPrice': startingPrice,
      'currency': currency,
      'targetCompanyType': targetCompanyType.name,
      'includedServices': includedServices.join(
        '|||',
      ), // Use delimiter to store list as string
      'category': category,
      'icon': icon,
    };
  }

  /// Create OfferModel from database Map
  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      id: map['id'] as String,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
      fullDescription: map['fullDescription'] as String,
      keyBenefit: map['keyBenefit'] as String,
      startingPrice: map['startingPrice'] as String?,
      currency: map['currency'] as String? ?? 'DZD',
      targetCompanyType: CompanyType.values.firstWhere(
        (e) => e.name == map['targetCompanyType'],
        orElse: () => CompanyType.all,
      ),
      includedServices: (map['includedServices'] as String).split('|||'),
      category: map['category'] as String,
      icon: map['icon'] as String? ?? 'gift',
    );
  }
}

/// Company types that can be targeted by offers
enum CompanyType {
  sme, // Small and Medium Enterprise
  enterprise, // Large Enterprise
  government, // Government/Public Sector
  all, // All company types
}

extension CompanyTypeExtension on CompanyType {
  String get displayName {
    switch (this) {
      case CompanyType.sme:
        return 'PME';
      case CompanyType.enterprise:
        return 'Grande Entreprise';
      case CompanyType.government:
        return 'Secteur Public';
      case CompanyType.all:
        return 'Tous';
    }
  }

  String get description {
    switch (this) {
      case CompanyType.sme:
        return 'Petites et Moyennes Entreprises';
      case CompanyType.enterprise:
        return 'Grandes Entreprises';
      case CompanyType.government:
        return 'Administrations et Secteur Public';
      case CompanyType.all:
        return 'Tous types d\'entreprises';
    }
  }
}
