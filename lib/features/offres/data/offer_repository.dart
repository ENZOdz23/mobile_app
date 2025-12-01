import '../models/offer_model.dart';

class OfferRepository {
  Future<List<OfferModel>> fetchOffers() async {
    // Fetch offers from API
    // Parse JSON response to List<OfferModel>
    // ... implementation here
        return [// Example:
      for(int i=1;i<=9;i++)
        OfferModel(id: '$i', title: 'Offre $i', icon: 'gift', description: 'Offer $i description'),

    ];
  }

}


