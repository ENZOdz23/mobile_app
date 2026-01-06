// lib/features/contacts/presentation/widgets/contacts_loading_shimmer.dart

import 'package:flutter/material.dart';

class ContactsLoadingShimmer extends StatelessWidget {
  const ContactsLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8, // Show 8 shimmer items
      itemBuilder: (context, index) {
        return _buildShimmerItem(surfaceColor);
      },
    );
  }

  Widget _buildShimmerItem(Color surfaceColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar shimmer
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: surfaceColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            // Text content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name shimmer
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Company/address shimmer
                  Container(
                    height: 13,
                    width: 150,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Phone shimmer
                  Container(
                    height: 13,
                    width: 120,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron shimmer
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
