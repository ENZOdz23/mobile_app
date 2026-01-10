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
                  speed.isLoading ? Icons.cancel : Icons.speed,
                  color: AppColors.primary,
                ),
                onPressed: onTest,
                tooltip: speed.isLoading ? 'Annuler le test' : 'Démarrer le test',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (speed.isLoading)
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: speed.progressPercent / 100,
                          strokeWidth: 8,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${speed.progressPercent}%',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    speed.isDownloadComplete
                        ? 'Test de téléversement...'
                        : 'Test de téléchargement...',
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (speed.downloadSpeed > 0) ...[
                    const SizedBox(height: 16),
                    _buildSpeedItem(
                      'Téléchargement',
                      speed.getDownloadSpeedDisplay(),
                      Icons.download,
                      isComplete: speed.isDownloadComplete,
                    ),
                  ],
                  if (speed.uploadSpeed > 0) ...[
                    const SizedBox(height: 12),
                    _buildSpeedItem(
                      'Téléversement',
                      speed.getUploadSpeedDisplay(),
                      Icons.upload,
                      isComplete: speed.isUploadComplete,
                    ),
                  ],
                ],
              ),
            )
          else if (speed.downloadSpeed > 0 || speed.uploadSpeed > 0)
            Column(
              children: [
                if (speed.downloadSpeed > 0) ...[
                  _buildSpeedItem(
                    'Téléchargement',
                    speed.getDownloadSpeedDisplay(),
                    Icons.download,
                    isComplete: true,
                  ),
                  const SizedBox(height: 12),
                ],
                if (speed.uploadSpeed > 0) ...[
                  _buildSpeedItem(
                    'Téléversement',
                    speed.getUploadSpeedDisplay(),
                    Icons.upload,
                    isComplete: true,
                  ),
                ],
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

  Widget _buildSpeedItem(
    String label,
    String value,
    IconData icon, {
    bool isComplete = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isComplete ? AppColors.primary : AppColors.primary.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary.withOpacity(0.6),
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isComplete ? AppColors.onSurfaceLight : AppColors.primary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
