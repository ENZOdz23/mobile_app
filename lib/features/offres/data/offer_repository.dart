import '../models/offer_model.dart';

class OfferRepository {
  /// Fetch all B2B offers from the API
  /// Currently returns hardcoded data until API endpoint is ready
  Future<List<OfferModel>> fetchOffers() async {
    // TODO: Replace with real API call when available
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      OfferModel(
        id: '1',
        title: 'Internet Fibre Optique Entreprise',
        shortDescription: 'Connexion ultra-rapide et fiable pour votre entreprise',
        fullDescription:
            'Profitez d\'une connexion internet à très haut débit avec notre offre Fibre Optique Entreprise. Idéale pour les entreprises nécessitant une bande passante garantie et une connexion stable pour leurs opérations quotidiennes. Support technique dédié 24/7 inclus.',
        keyBenefit: 'Bande passante garantie jusqu\'à 1 Gbps',
        startingPrice: '15000',
        currency: 'DZD',
        targetCompanyType: CompanyType.enterprise,
        includedServices: [
          'Connexion fibre optique jusqu\'à 1 Gbps',
          'Support technique dédié 24/7',
          'IP fixe inclus',
          'Routeur professionnel fourni',
          'SLA 99.9% de disponibilité',
          'Installation gratuite',
        ],
        category: 'Internet',
        icon: 'wifi',
      ),
      OfferModel(
        id: '2',
        title: 'Solution Mobile Corporate',
        shortDescription: 'Forfaits mobiles adaptés à vos équipes sur terrain',
        fullDescription:
            'Offre mobile spécialement conçue pour les entreprises avec gestion centralisée de vos lignes mobiles. Bénéficiez d\'un volume de données important, d\'appels illimités, et d\'une facturation groupée pour simplifier votre gestion administrative.',
        keyBenefit: 'Gestion centralisée et facturation groupée',
        startingPrice: '2500',
        currency: 'DZD',
        targetCompanyType: CompanyType.sme,
        includedServices: [
          'Forfaits personnalisables',
          'Appels illimités vers tous les opérateurs',
          'Data jusqu\'à 50 Go',
          'Gestion centralisée via portail entreprise',
          'Facturation groupée',
          'Support dédié',
        ],
        category: 'Mobile',
        icon: 'phone_android',
      ),
      OfferModel(
        id: '3',
        title: 'Bundle Internet + Mobile PME',
        shortDescription: 'Solution tout-en-un économique pour PME',
        fullDescription:
            'Offre combinée Internet et Mobile spécialement conçue pour les PME. Réduisez vos coûts de communication avec cette solution complète incluant internet fixe, lignes mobiles, et services cloud de base. Parfait pour les petites entreprises cherchant à optimiser leur budget.',
        keyBenefit: 'Économie jusqu\'à 30% vs offre séparées',
        startingPrice: '12000',
        currency: 'DZD',
        targetCompanyType: CompanyType.sme,
        includedServices: [
          'Internet ADSL/Fibre jusqu\'à 100 Mbps',
          '3 à 10 lignes mobiles incluses',
          'Espace cloud 100 Go',
          'Email professionnel',
          'Installation gratuite',
          'Facture unique',
        ],
        category: 'Bundle',
        icon: 'device_hub',
      ),
      OfferModel(
        id: '4',
        title: 'Solution Cloud et Sécurité',
        shortDescription: 'Infrastructure cloud sécurisée pour vos données',
        fullDescription:
            'Protégez et centralisez vos données d\'entreprise avec notre solution cloud sécurisée. Sauvegarde automatique, accès multi-sites, et sécurité renforcée pour protéger vos informations sensibles. Conforme aux standards de sécurité internationaux.',
        keyBenefit: 'Sauvegarde automatique et sécurité renforcée',
        startingPrice: '8000',
        currency: 'DZD',
        targetCompanyType: CompanyType.enterprise,
        includedServices: [
          'Stockage cloud jusqu\'à 1 To',
          'Sauvegarde automatique quotidienne',
          'Chiffrement des données',
          'Accès multi-sites sécurisé',
          'Support technique 24/7',
          'Conformité RGPD',
        ],
        category: 'Entreprise',
        icon: 'cloud',
      ),
      OfferModel(
        id: '5',
        title: 'Téléphonie IP Entreprise',
        shortDescription: 'Communication unifiée pour votre organisation',
        fullDescription:
            'Système de téléphonie IP professionnel avec standard téléphonique virtuel, visioconférence, et messagerie unifiée. Optimisez la communication interne et externe de votre entreprise avec une solution complète et moderne.',
        keyBenefit: 'Communication unifiée et visioconférence intégrée',
        startingPrice: null, // Sur devis
        currency: 'DZD',
        targetCompanyType: CompanyType.enterprise,
        includedServices: [
          'Standard téléphonique virtuel',
          'Visioconférence HD',
          'Messagerie unifiée',
          'Numéro gratuit 0800',
          'Application mobile dédiée',
          'Configuration sur mesure',
        ],
        category: 'Entreprise',
        icon: 'call',
      ),
      OfferModel(
        id: '6',
        title: 'Internet Satellite Rural',
        shortDescription: 'Connexion internet pour zones non couvertes',
        fullDescription:
            'Solution internet par satellite pour les entreprises situées dans les zones rurales ou non couvertes par la fibre optique. Connexion stable et fiable, quel que soit votre emplacement en Algérie. Installation rapide et support local.',
        keyBenefit: 'Couverture 100% du territoire algérien',
        startingPrice: '20000',
        currency: 'DZD',
        targetCompanyType: CompanyType.all,
        includedServices: [
          'Installation complète incluse',
          'Débit jusqu\'à 50 Mbps',
          'Antenne parabolique fournie',
          'Support technique local',
          'Maintenance incluse',
          'Garantie équipement 2 ans',
        ],
        category: 'Internet',
        icon: 'satellite',
      ),
        OfferModel(
        id: '7',
        title: 'Offre Secteur Public',
        shortDescription: 'Solutions dédiées aux administrations publiques',
        fullDescription:
            'Offres spéciales conçues pour les administrations publiques, collectivités locales, et établissements publics. Conditions préférentielles, support prioritaire, et conformité aux exigences du secteur public algérien.',
        keyBenefit: 'Conditions préférentielles et conformité secteur public',
        startingPrice: null, // Sur devis selon besoins
        currency: 'DZD',
        targetCompanyType: CompanyType.government,
        includedServices: [
          'Solutions sur mesure',
          'Support prioritaire dédié',
          'Conformité réglementaire',
          'Facturation adaptée administration',
          'Audit de sécurité',
          'Formation du personnel',
        ],
        category: 'Entreprise',
        icon: 'account_balance',
        ),
        OfferModel(
        id: '8',
        title: 'Forfait Mobile Data Illimité',
        shortDescription: 'Internet mobile illimité pour vos équipes terrain',
        fullDescription:
            'Forfait mobile avec data illimité pour vos collaborateurs qui travaillent sur le terrain. Idéal pour les commerciaux, techniciens itinérants, et équipes mobiles nécessitant une connexion permanente sans limite de consommation.',
        keyBenefit: 'Data illimité sans limitation de vitesse',
        startingPrice: '3500',
        currency: 'DZD',
        targetCompanyType: CompanyType.sme,
        includedServices: [
          'Internet mobile illimité',
          'Appels illimités',
          'SMS illimités',
          'Hotspot mobile inclus',
          'Roaming Maghreb',
          'Gestion via portail entreprise',
        ],
        category: 'Mobile',
        icon: 'network_cell',
        ),
    ];
  }

  /// Fetch a single offer by ID
  /// Returns null if offer not found
  Future<OfferModel?> fetchOfferById(String offerId) async {
    // TODO: Replace with real API call when available
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final allOffers = await fetchOffers();
    try {
      return allOffers.firstWhere((offer) => offer.id == offerId);
    } catch (e) {
      return null;
    }
  }
}
