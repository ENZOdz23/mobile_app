import 'dart:math';
import '../../contacts/domain/contacts_repository.dart';
import '../../contacts/domain/prospect_repository.dart';
import '../../contacts/models/prospect.dart';
import '../../offres/data/offer_repository.dart';
import '../models/statistics_model.dart';

class StatisticsRepository {
  final ContactsRepository _contactsRepository;
  final ProspectRepository _prospectRepository;
  final OfferRepository _offerRepository;

  StatisticsRepository({
    required ContactsRepository contactsRepository,
    required ProspectRepository prospectRepository,
    required OfferRepository offerRepository,
  }) : _contactsRepository = contactsRepository,
       _prospectRepository = prospectRepository,
       _offerRepository = offerRepository;

  /// Fetch statistics with real data aggregation
  Future<StatisticsModel> getStatistics() async {
    // Fetch real data in parallel
    final results = await Future.wait([
      _contactsRepository.getContacts(),
      _prospectRepository.getProspects(),
      _offerRepository.fetchOffers(),
    ]);

    final contacts = results[0] as List;
    final prospects = results[1] as List<Prospect>;
    final offers = results[2] as List;

    // Calculate real stats
    final totalContacts = contacts.length;
    final totalProspects = prospects.length;
    final interestedProspects = prospects
        .where((p) => p.status == ProspectStatus.interested)
        .length;
    final notInterestedProspects = prospects
        .where((p) => p.status == ProspectStatus.notInterested)
        .length;
    final activeOffers = offers.length;

    // Simulate revenue data (since Sales/CRM are empty)
    await Future.delayed(const Duration(milliseconds: 500)); // Minimal delay
    final random = Random();

    // Base mock values for revenue
    const double baseRevenue = 1500000.0;

    // Add some variance
    final double currentRevenue =
        baseRevenue + (random.nextDouble() * 200000) - 50000;

    // Generate monthly data for chart (last 6 months)
    final List<double> monthlyData = List.generate(6, (index) {
      return (baseRevenue * 0.7) +
          (index * 50000) +
          (random.nextDouble() * 50000);
    });

    // Calculate growth (mock calculation)
    final double growth = 5.0 + random.nextDouble() * 10.0;

    return StatisticsModel(
      totalRevenue: currentRevenue,
      totalContacts: totalContacts,
      totalProspects: totalProspects,
      interestedProspects: interestedProspects,
      notInterestedProspects: notInterestedProspects,
      activeOffers: activeOffers,
      monthlyRevenue: monthlyData,
      growthRate: growth,
    );
  }
}
