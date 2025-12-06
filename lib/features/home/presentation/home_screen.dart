// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/config/routes.dart';
import 'widgets/welcome_card.dart';
import 'widgets/kpis_section.dart';
import 'widgets/goals_section.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/recent_activities_section.dart';

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
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            WelcomeCard(),
            SizedBox(height: 20),

            // KPIs Section
            KPIsSection(),
            SizedBox(height: 24),

            // Goals Progress Section
            GoalsSection(),
            SizedBox(height: 24),

            // Quick Actions
            QuickActionsSection(),
            SizedBox(height: 24),

            // Recent Activities
            RecentActivitiesSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
