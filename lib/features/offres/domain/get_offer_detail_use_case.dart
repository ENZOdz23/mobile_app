import '../data/offer_repository.dart';
import '../models/offer_model.dart';

class GetOfferDetailUseCase {
  final OfferRepository repository;

  GetOfferDetailUseCase(this.repository);

  Future<OfferModel?> execute(String offerId) async {
    return await repository.fetchOfferById(offerId);
  }
}
