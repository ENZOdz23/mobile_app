import 'package:flutter/material.dart';
import '../../../../core/config/routes.dart';

class KPIsSection extends StatelessWidget {
  const KPIsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final kpis = [
      {
        'title': 'Ventes du mois',
        'value': '1.2M DZD',
        'icon': Icons.trending_up,
        'color': const Color(0xFF4CAF50),
        'change': '+12%',
      },
      {
        'title': 'Nouveaux clients',
        'value': '24',
        'icon': Icons.person_add,
        'color': const Color(0xFF2196F3),
        'change': '+8',
      },
      {
        'title': 'RDV réalisés',
        'value': '18/22',
        'icon': Icons.event_available,
        'color': const Color(0xFFFF9800),
        'change': '82%',
      },
      {
        'title': 'Prospects actifs',
        'value': '42',
        'icon': Icons.people_outline,
        'color': const Color(0xFF9C27B0),
        'change': '+5',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mes Indicateurs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) {
            final kpi = kpis[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.kpis);
              },
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (kpi['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            kpi['icon'] as IconData,
                            color: kpi['color'] as Color,
                            size: 24,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            kpi['change'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      kpi['value'] as String,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kpi['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
