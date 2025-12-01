// lib/features/contacts/presentation/widgets/detail_card.dart

import 'package:flutter/material.dart';
import 'detail_row.dart';

class DetailCard extends StatelessWidget {
  final List<DetailRow> details;

  const DetailCard({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: details
            .map((detail) => DetailRowWidget(detail: detail))
            .toList(),
      ),
    );
  }
}