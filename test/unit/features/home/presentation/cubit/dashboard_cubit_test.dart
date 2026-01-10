import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:crm_sales_performance_mobilis/features/home/presentation/cubit/dashboard_state.dart';
import 'package:crm_sales_performance_mobilis/features/home/domain/get_dashboard_data_usecase.dart';
import 'package:crm_sales_performance_mobilis/features/home/models/dashboard_data.dart';
import 'package:crm_sales_performance_mobilis/features/home/models/prospect_status_count.dart';

@GenerateMocks([GetDashboardDataUseCase])
import 'dashboard_cubit_test.mocks.dart';

void main() {
  late DashboardCubit cubit;
  late MockGetDashboardDataUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetDashboardDataUseCase();
    cubit = DashboardCubit(getDashboardDataUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('DashboardCubit Tests', () {
    final tDashboardData = DashboardData(
      totalProspects: 10,
      totalContacts: 5,
      prospectStatusCount: ProspectStatusCount(
        interested: 3,
        notInterested: 2,
        notAnswered: 5,
      ),
      recentActivities: [],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardLoaded] when data is loaded successfully',
      build: () {
        when(mockUseCase.call()).thenAnswer((_) async => tDashboardData);
        return cubit;
      },
      act: (cubit) => cubit.loadDashboardData(),
      expect: () => [isA<DashboardLoading>(), isA<DashboardLoaded>()],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits [DashboardLoading, DashboardError] when loading fails',
      build: () {
        when(mockUseCase.call()).thenThrow(Exception('Failed'));
        return cubit;
      },
      act: (cubit) => cubit.loadDashboardData(),
      expect: () => [isA<DashboardLoading>(), isA<DashboardError>()],
    );
  });
}
