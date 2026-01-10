// lib/features/more/presentation/more_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'more_cubit.dart';
import 'widgets/profile_header.dart';
import 'widgets/network_speed_card.dart';
import 'widgets/quick_links_section.dart';
import 'widgets/settings_section.dart';
import '../data/more_repository.dart';
import '../domain/get_user_profile_usecase.dart';
import '../domain/test_network_speed_usecase.dart';
import '../models/network_speed.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/i18n/l10n/app_localizations.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = MoreRepository();
        return MoreCubit(
          getUserProfileUseCase: GetUserProfileUseCase(repository),
          testNetworkSpeedUseCase: TestNetworkSpeedUseCase(repository),
        )..loadUserProfile();
      },
      child: const MoreScreenView(),
    );
  }
}

class MoreScreenView extends StatelessWidget {
  const MoreScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BaseScaffold(
      title: s.more,
      body: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          if (state is MoreLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is MoreError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MoreCubit>().loadUserProfile();
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is MoreLoaded ||
              state is NetworkSpeedTesting ||
              state is NetworkSpeedTested) {
            final profile = state is MoreLoaded
                ? state.userProfile
                : state is NetworkSpeedTesting
                ? state.userProfile
                : (state as NetworkSpeedTested).userProfile;

            final networkSpeed = state is MoreLoaded
                ? state.networkSpeed
                : state is NetworkSpeedTested
                ? state.networkSpeed
                : null;

            final isTestingSpeed = state is NetworkSpeedTesting;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileHeader(profile: profile),
                  const SizedBox(height: 16),
                  NetworkSpeedCard(
                    speed:
                        networkSpeed?.copyWith(isLoading: isTestingSpeed) ??
                        NetworkSpeed(isLoading: false),
                    onTest: () {
                      context.read<MoreCubit>().testNetworkSpeed();
                    },
                  ),
                  const SizedBox(height: 16),
                  const QuickLinksSection(),
                  const SizedBox(height: 16),
                  const SettingsSection(),
                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
