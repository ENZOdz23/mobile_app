import 'package:flutter/material.dart';
import '../domain/get_offers_use_case.dart';
import '../domain/get_banners_use_case.dart';
import '../models/offer_model.dart';
import '../models/banner_model.dart';
import '../data/offer_repository.dart';
import '../data/banner_repository.dart';
import 'widgets/offer_card.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/config/routes.dart';

/// Main screen displaying B2B offers in a professional list format
/// Designed for sales representatives to present offers to companies
class OffresScreen extends StatefulWidget {
  const OffresScreen({super.key});

  @override
  State<OffresScreen> createState() => _OffresScreenState();
}

class _OffresScreenState extends State<OffresScreen> {
  late Future<List<OfferModel>> offers;
  late Future<List<BannerModel>> banners;
  late final OfferRepository _offerRepository;

  String? _selectedCategory;
  final List<String> _categories = [
    'Tous',
    'Internet',
    'Mobile',
    'Bundle',
    'Entreprise',
  ];

  @override
  void initState() {
    super.initState();
    _offerRepository = OfferRepository();
    final bannerRepository = BannerRepository();
    offers = GetOffersUseCase(_offerRepository).execute();
    banners = GetBannersUseCase(bannerRepository).execute();
  }

  /// Handle offer card tap: navigate to detail screen
  void _handleOfferTap(String offerId) {
    Navigator.of(context).pushNamed(AppRoutes.offerDetails, arguments: offerId);
  }

  /// Filter offers by category
  List<OfferModel> _filterOffers(List<OfferModel> allOffers, String? category) {
    if (category == null || category == 'Tous') {
      return allOffers;
    }
    return allOffers.where((offer) => offer.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Offres B2B',
      body: Column(
        children: [
          // Category filter chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected =
                    _selectedCategory == category ||
                    (_selectedCategory == null && category == 'Tous');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.onSurfaceLight,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Offers list
          Expanded(
            child: FutureBuilder<List<OfferModel>>(
              future: offers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur lors du chargement des offres',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              offers = GetOffersUseCase(
                                _offerRepository,
                              ).execute();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune offre disponible',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final allOffers = snapshot.data!;
                final filteredOffers = _filterOffers(
                  allOffers,
                  _selectedCategory ?? 'Tous',
                );

                if (filteredOffers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune offre dans cette catégorie',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: filteredOffers.length,
                  itemBuilder: (context, index) {
                    final offer = filteredOffers[index];
                    return OfferCard(
                      offer: offer,
                      onTap: () => _handleOfferTap(offer.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
