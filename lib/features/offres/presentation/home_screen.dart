import 'package:flutter/material.dart';
import '../domain/get_offers_use_case.dart';
import '../domain/get_offer_detail_use_case.dart';
import '../domain/get_banners_use_case.dart';
import '../models/offer_model.dart';
import '../models/banner_model.dart';
import '../data/offer_repository.dart';
import '../data/banner_repository.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/offer_card.dart';
import 'dialogs/offer_detail_dialog.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/config/routes.dart';

class OffresScreen extends StatefulWidget {
  const OffresScreen({super.key});

  @override
  _OffresScreenState createState() => _OffresScreenState();
}

class _OffresScreenState extends State<OffresScreen> {
  late Future<List<OfferModel>> offers;
  late Future<List<BannerModel>> banners;
  late final OfferRepository _offerRepository;
  late final GetOfferDetailUseCase _getOfferDetailUseCase;

  @override
  void initState() {
    super.initState();
    _offerRepository = OfferRepository();
    final bannerRepository = BannerRepository();
    _getOfferDetailUseCase = GetOfferDetailUseCase(_offerRepository);
    offers = GetOffersUseCase(_offerRepository).execute();
    banners = GetBannersUseCase(bannerRepository).execute();
  }

  /// Handle offer card tap: fetch detail and show dialog.
  Future<void> _handleOfferTap(String offerId) async {
    final offerDetail = await _getOfferDetailUseCase.execute(offerId);
    if (offerDetail != null && mounted) {
      showDialog(
        context: context,
        builder: (ctx) => OfferDetailDialog(offer: offerDetail),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Bonjour !',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            FutureBuilder<List<BannerModel>>(
              future: banners,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                var bannerImages = snapshot.data!
                    .map((b) => b.imageUrl)
                    .toList();
                return BannerCarousel(imageUrls: bannerImages);
              },
            ),
            const SizedBox(height: 30),
            Text('Offres', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 30),
            FutureBuilder<List<OfferModel>>(
              future: offers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                var offerList = snapshot.data!;
                return SizedBox(
                  height: 244,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: offerList.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final offer = offerList[index];
                      return OfferCard(
                        offer: offer,
                        onTap: () => _handleOfferTap(offer.id),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // Navigation handled by BaseScaffold
    );
  }
}
