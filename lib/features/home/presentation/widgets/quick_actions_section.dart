import 'package:flutter/material.dart';
import '../../../../core/config/routes.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.person_add_outlined,
        'label': 'Ajouter prospect',
        'color': const Color(0xFF009640),
        'route': AppRoutes.addProspect,
      },
      {
        'icon': Icons.event,
        'label': 'Planifier RDV',
        'color': const Color(0xFF2196F3),
        'route': AppRoutes.planMeeting,
      },
      {
        'icon': Icons.description,
        'label': 'Nouveau contrat',
        'color': const Color(0xFFFF9800),
        'route': null,
      },
      {
        'icon': Icons.analytics,
        'label': 'Mes stats',
        'color': const Color(0xFF9C27B0),
        'route': AppRoutes.kpis,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    final route = action['route'] as String?;
                    if (route != null) {
                      Navigator.pushNamed(context, route);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${action['label']} sélectionné'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
