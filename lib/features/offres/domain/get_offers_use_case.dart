import '../data/offer_repository.dart';
import '../models/offer_model.dart';

class GetOffersUseCase {
  final OfferRepository repository;

  GetOffersUseCase(this.repository);

  Future<List<OfferModel>> execute() async {
    return await repository.fetchOffers();
  }
}
