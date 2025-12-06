import 'package:flutter/material.dart';
import '../../models/offer_model.dart';

/// Pure UI widget for displaying an offer card.
/// Does NOT handle click events or communicate with business logic.
/// Parent screen is responsible for handling tap events and navigation.
class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onTap;

  const OfferCard({required this.offer, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 160,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.card_giftcard, size: 32),
              const SizedBox(height: 8),
              Text(offer.title, style: Theme.of(context).textTheme.bodyMedium),
              // Description intentionally hidden in grid to avoid overflow.
              // Full description is available in the detail dialog when tapped.
            ],
          ),
        ),
      ),
    );
  }
}
