// lib/features/home/presentation/screens/recent_activities_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/components/base_scaffold.dart';
import '../../../../core/themes/app_theme.dart';
import '../cubit/activities_cubit.dart';
import '../widgets/activity_item.dart';
import '../widgets/dashboard_error_widget.dart';

class RecentActivitiesScreen extends StatelessWidget {
  const RecentActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivitiesCubit()..loadActivities(),
      child: BaseScaffold(
        title: 'Activités récentes',
        showBottomNav: false,
        body: BlocBuilder<ActivitiesCubit, ActivitiesState>(
          builder: (context, state) {
            if (state is ActivitiesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is ActivitiesError) {
              return DashboardErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<ActivitiesCubit>().loadActivities();
                },
              );
            }

            if (state is ActivitiesLoaded) {
              if (state.activities.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune activité récente',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Les activités apparaîtront ici lorsqu\'elles seront disponibles',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ActivitiesCubit>().refreshActivities();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.activities.length,
                  itemBuilder: (context, index) {
                    return ActivityItem(activity: state.activities[index]);
                  },
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
