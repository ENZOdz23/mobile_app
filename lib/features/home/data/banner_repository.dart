import '../models/banner_model.dart';

class BannerRepository {
  Future<List<BannerModel>> fetchBanners() async {
    // Fetch from API and parse, but for now, use example banners:
    return [
      BannerModel(id: '1', imageUrl: 'https://raw.githubusercontent.com/ENZOdz23/lab5/main/mobilis_banner.png'),
      BannerModel(id: '2', imageUrl: 'https://raw.githubusercontent.com/ENZOdz23/lab5/main/mobilis_banner.png'),
    ];
  }
}
