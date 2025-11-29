import '../data/banner_repository.dart'; // match the filename and class name!
import '../models/banner_model.dart';

class GetBannersUseCase {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<BannerModel>> execute() async {
    return await repository.fetchBanners();
  }
}
