// Test script for offres local database
// Run this in Dart DevTools console or create a test file

import 'package:flutter_test/flutter_test.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offres_local_data_source.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offer_repository.dart';
import 'package:crm_sales_performance_mobilis/features/offres/models/offer_model.dart';

void main() {
  group('Offres Local Database Tests', () {
    late OffresLocalDataSource dataSource;
    late OfferRepository repository;

    setUp(() {
      dataSource = OffresLocalDataSource();
      repository = OfferRepository();
    });

    test('Database initialization - seed data should be created', () async {
      // Initialize seed data
      await dataSource.seedInitialData();

      // Fetch all offers
      final offers = await dataSource.fetchOffers();

      // Should have 8 offers
      expect(offers.length, 8);

      // Verify first offer
      expect(offers[0].id, '1');
      expect(offers[0].title, 'Internet Fibre Optique Entreprise');
      expect(offers[0].category, 'Internet');
      expect(offers[0].targetCompanyType, CompanyType.enterprise);
    });

    test('Fetch offer by ID should return correct offer', () async {
      await dataSource.seedInitialData();

      final offer = await dataSource.fetchOfferById('2');

      expect(offer, isNotNull);
      expect(offer!.id, '2');
      expect(offer.title, 'Solution Mobile Corporate');
      expect(offer.targetCompanyType, CompanyType.sme);
    });

    test('Fetch non-existent offer should return null', () async {
      final offer = await dataSource.fetchOfferById('999');
      expect(offer, isNull);
    });

    test('Add new offer should work correctly', () async {
      final newOffer = OfferModel(
        id: '100',
        title: 'Test Offer',
        shortDescription: 'Test description',
        fullDescription: 'Test full description',
        keyBenefit: 'Test benefit',
        startingPrice: '5000',
        currency: 'DZD',
        targetCompanyType: CompanyType.sme,
        includedServices: ['Service 1', 'Service 2'],
        category: 'Test',
        icon: 'test_icon',
      );

      await dataSource.addOffer(newOffer);

      final fetchedOffer = await dataSource.fetchOfferById('100');
      expect(fetchedOffer, isNotNull);
      expect(fetchedOffer!.title, 'Test Offer');
      expect(fetchedOffer.includedServices.length, 2);
    });

    test('Update offer should modify existing offer', () async {
      await dataSource.seedInitialData();

      // Fetch existing offer
      var offer = await dataSource.fetchOfferById('1');
      expect(offer, isNotNull);

      // Create updated version
      final updatedOffer = OfferModel(
        id: offer!.id,
        title: 'Updated Title',
        shortDescription: offer.shortDescription,
        fullDescription: offer.fullDescription,
        keyBenefit: offer.keyBenefit,
        startingPrice: '99999',
        currency: offer.currency,
        targetCompanyType: offer.targetCompanyType,
        includedServices: offer.includedServices,
        category: offer.category,
        icon: offer.icon,
      );

      await dataSource.updateOffer(updatedOffer);

      // Fetch updated offer
      final fetchedOffer = await dataSource.fetchOfferById('1');
      expect(fetchedOffer!.title, 'Updated Title');
      expect(fetchedOffer.startingPrice, '99999');
    });

    test('Delete offer should remove it from database', () async {
      await dataSource.seedInitialData();

      // Verify offer exists
      var offer = await dataSource.fetchOfferById('3');
      expect(offer, isNotNull);

      // Delete offer
      await dataSource.deleteOffer('3');

      // Verify offer is deleted
      offer = await dataSource.fetchOfferById('3');
      expect(offer, isNull);
    });

    test('Repository should use local data source', () async {
      await repository.initializeData();

      final offers = await repository.fetchOffers();
      expect(offers.length, greaterThan(0));

      final offer = await repository.fetchOfferById('1');
      expect(offer, isNotNull);
    });

    test('CompanyType enum serialization should work', () async {
      await dataSource.seedInitialData();

      final offers = await dataSource.fetchOffers();

      // Check different company types
      final enterpriseOffer = offers.firstWhere((o) => o.id == '1');
      expect(enterpriseOffer.targetCompanyType, CompanyType.enterprise);

      final smeOffer = offers.firstWhere((o) => o.id == '2');
      expect(smeOffer.targetCompanyType, CompanyType.sme);

      final govOffer = offers.firstWhere((o) => o.id == '7');
      expect(govOffer.targetCompanyType, CompanyType.government);

      final allOffer = offers.firstWhere((o) => o.id == '6');
      expect(allOffer.targetCompanyType, CompanyType.all);
    });

    test('IncludedServices list serialization should work', () async {
      await dataSource.seedInitialData();

      final offer = await dataSource.fetchOfferById('1');
      expect(offer, isNotNull);
      expect(offer!.includedServices, isA<List<String>>());
      expect(offer.includedServices.length, 6);
      expect(
        offer.includedServices[0],
        'Connexion fibre optique jusqu\'à 1 Gbps',
      );
    });
  });
}
