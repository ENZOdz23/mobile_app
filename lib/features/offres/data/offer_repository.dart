import '../models/offer_model.dart';

class OfferRepository {
  Future<List<OfferModel>> fetchOffers() async {
    // Fetch offers from API
    // Parse JSON response to List<OfferModel>
    // ... implementation here
    return [
      // Example:
      for (int i = 1; i <= 9; i++)
        OfferModel(
          id: '$i',
          title: 'Offre $i',
          icon: 'gift',
          description: 'Offer $i description',
        ),
        OfferModel(
          id: '10',
          title: 'Offre 10',
          icon: 'gift',
          description: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        ),
    ];
  }

  /// Fetch a single offer by ID.
  /// Returns null if offer not found.
  Future<OfferModel?> fetchOfferById(String offerId) async {
    // TODO: Replace with real API call when available.
    // Hardcoded offers until API endpoint is ready.
    final allOffers = await fetchOffers();
    try {
      return allOffers.firstWhere((offer) => offer.id == offerId);
    } catch (e) {
      return null;
    }
  }
}
