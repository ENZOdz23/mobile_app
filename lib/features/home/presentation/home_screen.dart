// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/config/routes.dart';
import '../../../core/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.contacts);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.offres);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.more);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Tableau de bord',
      currentIndex: _currentIndex,
      onNavTap: _onNavTap,
      body: const DashboardBody(),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeCard(),
            const SizedBox(height: 20),

            // KPIs Section
            const Text(
              'Mes Indicateurs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            _buildKPIsGrid(),
            const SizedBox(height: 24),

            // Goals Progress Section
            const Text(
              'Objectifs du mois',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            _buildGoalsSection(),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Recent Activities
            const Text(
              'Activités récentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentActivities(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF009640), Color(0xFF43B02A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 32, color: Color(0xFF009640)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bonjour, Mohamed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Novembre 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildKPIsGrid() {
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

    return GridView.builder(
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
        return Container(
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
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoalsSection() {
    final goals = [
      {'title': 'Chiffre d\'affaires', 'current': 1200000, 'target': 1500000},
      {'title': 'Nouveaux clients', 'current': 24, 'target': 30},
      {'title': 'Rendez-vous', 'current': 18, 'target': 25},
    ];

    return Column(
      children: goals.map((goal) {
        final progress = (goal['current']! as int) / (goal['target']! as int);
        return Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009640),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF009640),
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${goal['current']} / ${goal['target']}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.person_add_outlined,
        'label': 'Ajouter prospect',
        'color': const Color(0xFF009640),
      },
      {
        'icon': Icons.event,
        'label': 'Planifier RDV',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.description,
        'label': 'Nouveau contrat',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.analytics,
        'label': 'Mes stats',
        'color': const Color(0xFF9C27B0),
      },
    ];

    return SizedBox(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${action['label']} sélectionné')),
                );
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
    );
  }

  Widget _buildRecentActivities() {
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
      children: activities.map((activity) {
        return Container(
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
        );
      }).toList(),
    );
  }
}
