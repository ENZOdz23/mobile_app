import 'package:flutter/material.dart';
import '../domain/get_offers_use_case.dart';
import '../domain/get_banners_use_case.dart';
import '../models/offer_model.dart';
import '../models/banner_model.dart';
import '../data/offer_repository.dart';
import '../data/banner_repository.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/offer_card.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<OfferModel>> offers;
  late Future<List<BannerModel>> banners;

  @override
  void initState() {
    super.initState();
    final offerRepository = OfferRepository();
    final bannerRepository = BannerRepository();
    offers = GetOffersUseCase(offerRepository).execute();
    banners = GetBannersUseCase(bannerRepository).execute();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Bonjour !',
      body: Column(
        children: [
          SizedBox(height: 16),
          FutureBuilder<List<BannerModel>>(
            future: banners,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              var bannerImages = snapshot.data!.map((b) => b.imageUrl).toList();
              return BannerCarousel(imageUrls: bannerImages);
            },
          ),
          SizedBox(height: 30),
          Text('Offres', style: AppTextStyles.headlineMedium),
          SizedBox(height: 30),
          FutureBuilder<List<OfferModel>>(
            future: offers,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              var offerList = snapshot.data!;
              return SizedBox(
                height: 340, // or as tall as you want that section
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 cards per row (set 3, 4 if wanted)
                    crossAxisSpacing: 8, // space between columns
                    mainAxisSpacing: 8, // space between rows
                    childAspectRatio:
                        0.85, // width/height ratio, tweak for card proportion
                  ),
                  itemCount: offerList.length,
                  physics: BouncingScrollPhysics(), // adds nice iOS-like bounce
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) =>
                      OfferCard(offer: offerList[index]),
                ),
              );
            },
          ),
        ],
      ),
      currentIndex: 0,
      onNavTap: (int index) {
        // Navigation logic here
      },
    );
  }
}
