// lib/features/home/presentation/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/config/routes.dart';
import '../../../core/themes/app_theme.dart';
import 'cubit/dashboard_cubit.dart';
import 'cubit/dashboard_state.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stat_card.dart';
import 'widgets/prospect_status_card.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/activity_item.dart';
import 'widgets/dashboard_loading_shimmer.dart';
import 'widgets/dashboard_error_widget.dart';
import '../../contacts/data/datasources/contacts_remote_data_source.dart';
import '../../contacts/data/datasources/prospects_remote_data_source.dart';
import '../data/dashboard_repository_impl.dart';
import '../domain/get_dashboard_data_usecase.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        getDashboardDataUseCase: GetDashboardDataUseCase(
          DashboardRepositoryImpl(
            contactsRemoteDataSource: ContactsRemoteDataSource(),
            prospectsRemoteDataSource: ProspectsRemoteDataSource(),
          ),
        ),
      )..loadDashboardData(),
      child: BaseScaffold(
        title: 'Tableau de bord',
        body: const DashboardBody(),
      ),
    );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const DashboardLoadingShimmer();
        }

        if (state is DashboardError) {
          return DashboardErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<DashboardCubit>().loadDashboardData();
            },
          );
        }

        if (state is DashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<DashboardCubit>().refreshDashboardData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    const DashboardHeader(),
                    const SizedBox(height: 20),

                    // Statistics Cards
                    Text(
                      'Statistiques',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return StatCard(
                            title: 'Total Prospects',
                            value: state.data.totalProspects.toString(),
                            icon: Icons.people_outline,
                            iconColor: AppColors.accent,
                          );
                        } else {
                          return StatCard(
                            title: 'Total Contacts',
                            value: state.data.totalContacts.toString(),
                            icon: Icons.contacts,
                            iconColor: AppColors.primary,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Prospects by Status
                    Text(
                      'Prospects par statut',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProspectStatusCard(
                      statusCount: state.data.prospectStatusCount,
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Actions rapides',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        QuickActionCard(
                          label: 'Ajouter Contact',
                          icon: Icons.person_add,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.addContact);
                          },
                        ),
                        const SizedBox(width: 12),
                        QuickActionCard(
                          label: 'Ajouter Prospect',
                          icon: Icons.person_add_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.addProspect);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Recent Activities
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Activités récentes',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (state.data.recentActivities.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.recentActivities,
                              );
                            },
                            child: Text(
                              'Voir tout',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (state.data.recentActivities.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Aucune activité récente',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...state.data.recentActivities
                          .take(5)
                          .map((activity) => ActivityItem(activity: activity))
                          ,
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }

        // Initial state
        return const DashboardLoadingShimmer();
      },
    );
  }
}
