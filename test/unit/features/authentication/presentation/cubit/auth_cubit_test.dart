import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/presentation/cubit/auth_state.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/domain/request_otp_usecase.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/domain/verify_otp_usecase.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/domain/resend_otp_usecase.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/models/auth_response.dart';
import 'package:crm_sales_performance_mobilis/features/authentication/models/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([RequestOtpUseCase, VerifyOtpUseCase, ResendOtpUseCase])
import 'auth_cubit_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late AuthCubit authCubit;
  late MockRequestOtpUseCase mockRequestOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockResendOtpUseCase mockResendOtpUseCase;

  setUp(() {
    mockRequestOtpUseCase = MockRequestOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockResendOtpUseCase = MockResendOtpUseCase();
    authCubit = AuthCubit(
      requestOtpUseCase: mockRequestOtpUseCase,
      verifyOtpUseCase: mockVerifyOtpUseCase,
      resendOtpUseCase: mockResendOtpUseCase,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit Tests', () {
    const phoneNumber = '0555123456';

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when requestOtp succeeds',
      build: () {
        when(
          mockRequestOtpUseCase.call(phoneNumber),
        ).thenAnswer((_) async => 'OTP Sent');
        return authCubit;
      },
      act: (cubit) => cubit.requestOtp(phoneNumber),
      expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when requestOtp fails',
      build: () {
        when(
          mockRequestOtpUseCase.call(phoneNumber),
        ).thenThrow(Exception('Failed'));
        return authCubit;
      },
      act: (cubit) => cubit.requestOtp(phoneNumber),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, OtpVerificationSuccess] when verifyOtp succeeds',
      build: () {
        when(mockVerifyOtpUseCase.call(any)).thenAnswer(
          (_) async => AuthResponse(
            token: 'test_token',
            phoneNumber: phoneNumber,
            userId: 'user_123',
          ),
        );
        return authCubit;
      },
      act: (cubit) => cubit.verifyOtp(phoneNumber, '123456'),
      expect: () => [isA<AuthLoading>(), isA<OtpVerificationSuccess>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthInitial] when logout is called',
      build: () => authCubit,
      act: (cubit) => cubit.logout(),
      expect: () => [isA<AuthInitial>()],
    );
  });
}
