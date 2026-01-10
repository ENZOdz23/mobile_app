import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_theme.dart';
import '../../contacts/data/contacts_repository_impl.dart';
import '../../contacts/data/datasources/contacts_remote_data_source.dart';
import '../../contacts/data/datasources/prospects_remote_data_source.dart';
import '../../contacts/data/prospect_repository_impl.dart';
import '../../offres/data/offer_repository.dart';
import '../data/statistics_repository.dart';
import 'cubit/statistics_cubit.dart';
import '../../../shared/components/base_scaffold.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(
        StatisticsRepository(
          contactsRepository: ContactsRepositoryImpl(
            remoteDataSource: ContactsRemoteDataSource(),
          ),
          prospectRepository: ProspectRepositoryImpl(
            remoteDataSource: ProspectsRemoteDataSource(),
          ),
          offerRepository: OfferRepository(),
        ),
      )..loadStatistics(),
      child: const StatisticsScreenView(),
    );
  }
}

class StatisticsScreenView extends StatelessWidget {
  const StatisticsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Format currency
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_DZ',
      symbol: 'DZD',
      decimalDigits: 0,
    );

    return BaseScaffold(
      title: 'Statistiques',
      showBackButton: true,
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is StatisticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(state.message, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StatisticsCubit>().loadStatistics();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is StatisticsLoaded) {
            final stats = state.statistics;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<StatisticsCubit>().refreshStatistics();
              },
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with growth
                    const SizedBox(height: 24),

                    // Detailed breakdown
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.contacts_outlined,
                            label: 'Contacts',
                            value: stats.totalContacts.toString(),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            icon: Icons.local_offer_outlined,
                            label: 'Offres Actives',
                            value: stats.activeOffers.toString(),
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildProspectsCard(stats), // Prospects Breakdown
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getMonthLabel(int index) {
    // Return M-5 to M labels
    final now = DateTime.now();
    final month = DateTime(now.year, now.month - 5 + index);
    return DateFormat('MMM').format(month);
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProspectsCard(dynamic stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people_alt, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prospects',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    stats.totalProspects.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats.interestedProspects.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Intéressés',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: const Color(0xFFEEEEEE)),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats.notInterestedProspects.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Non Intéressés',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
