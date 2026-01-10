import '../models/offer_model.dart';
import 'offres_local_data_source.dart';

class OfferRepository {
  final OffresLocalDataSource _localDataSource;

  OfferRepository({OffresLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? OffresLocalDataSource();

  /// Fetch all B2B offers from local database
  Future<List<OfferModel>> fetchOffers() async {
    // Simulate network delay for consistency
    await Future.delayed(const Duration(milliseconds: 500));

    return await _localDataSource.fetchOffers();
  }

  /// Fetch a single offer by ID from local database
  /// Returns null if offer not found
  Future<OfferModel?> fetchOfferById(String offerId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return await _localDataSource.fetchOfferById(offerId);
  }

  /// Initialize database with seed data
  Future<void> initializeData() async {
    await _localDataSource.seedInitialData();
  }
}
