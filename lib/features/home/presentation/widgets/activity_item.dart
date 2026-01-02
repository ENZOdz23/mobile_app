// lib/features/home/presentation/widgets/activity_item.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/activity.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;

  const ActivityItem({
    super.key,
    required this.activity,
  });

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.prospectAdded:
        return Icons.person_add;
      case ActivityType.clientAdded:
        return Icons.person_add_alt_1;
      case ActivityType.statusUpdated:
        return Icons.update;
      case ActivityType.meetingScheduled:
        return Icons.event;
      case ActivityType.other:
        return Icons.notifications;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.prospectAdded:
        return AppColors.accent;
      case ActivityType.clientAdded:
        return AppColors.primary;
      case ActivityType.statusUpdated:
        return Colors.orange;
      case ActivityType.meetingScheduled:
        return Colors.blue;
      case ActivityType.other:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else if (difference.inSeconds > 0) {
      return 'Il y a ${difference.inSeconds} seconde${difference.inSeconds > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final iconColor = _getActivityColor(activity.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: onSurfaceColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: onSurfaceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: onSurfaceColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            _formatTime(activity.timestamp),
            style: AppTextStyles.bodyMedium.copyWith(
              color: onSurfaceColor.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

