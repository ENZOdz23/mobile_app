import 'package:flutter/material.dart';
import '../../models/network_speed.dart';
import '../../../../core/themes/app_theme.dart';

class NetworkSpeedCard extends StatelessWidget {
  final NetworkSpeed speed;
  final VoidCallback onTest;

  const NetworkSpeedCard({
    super.key,
    required this.speed,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,  // Changed
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),  // Changed
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Test de vitesse réseau',
                style: AppTextStyles.headlineMedium.copyWith(  // Changed
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: Icon(
                  speed.isLoading ? Icons.refresh : Icons.speed,
                  color: AppColors.primary,  // Changed
                ),
                onPressed: speed.isLoading ? null : onTest,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (speed.isLoading)
            Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,  // Changed
                  ),
                  const SizedBox(height: 12),
                  Text('Test en cours...', style: AppTextStyles.bodyMedium),  // Changed
                ],
              ),
            )
          else if (speed.downloadSpeed > 0)
            Column(
              children: [
                _buildSpeedItem(
                  'Téléchargement',
                  '${speed.downloadSpeed.toStringAsFixed(2)} Kbps',
                  Icons.download,
                ),
                const SizedBox(height: 12),
                _buildSpeedItem(
                  'Téléversement',
                  '${speed.uploadSpeed.toStringAsFixed(2)} Kbps',
                  Icons.upload,
                ),
              ],
            )
          else
            Center(
              child: ElevatedButton.icon(
                onPressed: onTest,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Démarrer le test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,  // Changed
                  foregroundColor: AppColors.onPrimary,  // Changed
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpeedItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),  // Changed
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(  // Changed
            color: AppColors.secondary.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(  // Changed
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
