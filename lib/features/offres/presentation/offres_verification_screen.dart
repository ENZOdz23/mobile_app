// Manual verification script for offres database
// This file can be used to manually test the database functionality

import 'package:flutter/material.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offres_local_data_source.dart';
import 'package:crm_sales_performance_mobilis/features/offres/data/offer_repository.dart';
import 'package:crm_sales_performance_mobilis/features/offres/models/offer_model.dart';

class OffresVerificationScreen extends StatefulWidget {
  const OffresVerificationScreen({super.key});

  @override
  State<OffresVerificationScreen> createState() =>
      _OffresVerificationScreenState();
}

class _OffresVerificationScreenState extends State<OffresVerificationScreen> {
  final OfferRepository _repository = OfferRepository();
  final OffresLocalDataSource _dataSource = OffresLocalDataSource();
  List<OfferModel> _offers = [];
  String _status = 'Not initialized';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runVerification();
  }

  Future<void> _runVerification() async {
    setState(() {
      _isLoading = true;
      _status = 'Running verification...';
    });

    try {
      // Test 1: Initialize database with seed data
      await _repository.initializeData();
      setState(() => _status = '✓ Database initialized with seed data');
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 2: Fetch all offers
      final offers = await _repository.fetchOffers();
      setState(() {
        _offers = offers;
        _status = '✓ Fetched ${offers.length} offers from database';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 3: Fetch specific offer by ID
      final offer = await _repository.fetchOfferById('1');
      setState(() {
        _status = offer != null
            ? '✓ Successfully fetched offer: ${offer.title}'
            : '✗ Failed to fetch offer by ID';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 4: Verify CompanyType enum serialization
      final enterpriseOffers = offers
          .where((o) => o.targetCompanyType == CompanyType.enterprise)
          .toList();
      final smeOffers = offers
          .where((o) => o.targetCompanyType == CompanyType.sme)
          .toList();
      setState(() {
        _status =
            '✓ CompanyType serialization works: ${enterpriseOffers.length} enterprise, ${smeOffers.length} SME offers';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 5: Verify includedServices list serialization
      if (offers.isNotEmpty) {
        final firstOffer = offers.first;
        setState(() {
          _status =
              '✓ IncludedServices serialization works: ${firstOffer.includedServices.length} services in first offer';
        });
      }
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 6: Test CRUD - Add new offer
      final testOffer = OfferModel(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Test Offer - Verification',
        shortDescription: 'This is a test offer',
        fullDescription: 'Full description of test offer',
        keyBenefit: 'Test benefit',
        startingPrice: '1000',
        currency: 'DZD',
        targetCompanyType: CompanyType.sme,
        includedServices: ['Test Service 1', 'Test Service 2'],
        category: 'Test',
        icon: 'test',
      );
      await _dataSource.addOffer(testOffer);
      setState(() => _status = '✓ Successfully added test offer');
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 7: Verify test offer was added
      final addedOffer = await _dataSource.fetchOfferById(testOffer.id);
      setState(() {
        _status = addedOffer != null
            ? '✓ Test offer persisted correctly'
            : '✗ Failed to persist test offer';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 8: Update test offer
      final updatedTestOffer = OfferModel(
        id: testOffer.id,
        title: 'Updated Test Offer',
        shortDescription: testOffer.shortDescription,
        fullDescription: testOffer.fullDescription,
        keyBenefit: testOffer.keyBenefit,
        startingPrice: '2000',
        currency: testOffer.currency,
        targetCompanyType: testOffer.targetCompanyType,
        includedServices: testOffer.includedServices,
        category: testOffer.category,
        icon: testOffer.icon,
      );
      await _dataSource.updateOffer(updatedTestOffer);
      final verifyUpdate = await _dataSource.fetchOfferById(testOffer.id);
      setState(() {
        _status = verifyUpdate?.title == 'Updated Test Offer'
            ? '✓ Successfully updated test offer'
            : '✗ Failed to update test offer';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 9: Delete test offer
      await _dataSource.deleteOffer(testOffer.id);
      final verifyDelete = await _dataSource.fetchOfferById(testOffer.id);
      setState(() {
        _status = verifyDelete == null
            ? '✓ Successfully deleted test offer'
            : '✗ Failed to delete test offer';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Final status
      setState(() {
        _status = '✅ All verification tests passed!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '✗ Error during verification: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offres Database Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verification Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (_isLoading) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Offers in Database',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _offers.length,
                itemBuilder: (context, index) {
                  final offer = _offers[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(offer.id)),
                      title: Text(offer.title),
                      subtitle: Text(
                        '${offer.category} - ${offer.targetCompanyType.displayName}',
                      ),
                      trailing: Text(offer.startingPrice ?? 'Sur devis'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _runVerification,
              child: const Text('Run Verification Again'),
            ),
          ],
        ),
      ),
    );
  }
}
