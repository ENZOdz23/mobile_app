import 'package:flutter/material.dart';
import '../../../../core/config/routes.dart';

class RecentActivitiesSection extends StatelessWidget {
  const RecentActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'icon': Icons.check_circle,
        'title': 'Contrat signé - Entreprise ABC',
        'time': 'Il y a 2 heures',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.event,
        'title': 'RDV avec Client XYZ',
        'time': 'Aujourd\'hui 14:00',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.phone,
        'title': 'Appel prospect - Société DEF',
        'time': 'Hier 16:30',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.email,
        'title': 'Email envoyé - Proposition GHI',
        'time': 'Hier 11:00',
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activités récentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: activities.map((activity) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.recentActivities);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['time'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
