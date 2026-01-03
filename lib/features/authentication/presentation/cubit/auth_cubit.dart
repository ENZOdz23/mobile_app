// lib/features/authentication/presentation/cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/request_otp_usecase.dart';
import '../../domain/verify_otp_usecase.dart';
import '../../domain/resend_otp_usecase.dart';
import '../../models/otp.dart';
import '../../../../core/storage/local_storage_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AuthCubit({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final storage = await LocalStorageService.getInstance();
    if (storage.isLoggedIn() && storage.getAuthToken() != null) {
      emit(AuthAuthenticated());
    }
  }

  Future<void> requestOtp(String phoneNumber) async {
    try {
      emit(AuthLoading());
      await requestOtpUseCase(phoneNumber);
      emit(AuthSuccess('OTP sent successfully'));
    } catch (e) {
      emit(AuthError('Failed to request OTP: ${e.toString()}'));
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      emit(AuthLoading());
      final otp = Otp(code: otpCode, phoneNumber: phoneNumber);
      final authResponse = await verifyOtpUseCase(otp);
      
      // Store token and user info
      final storage = await LocalStorageService.getInstance();
      await storage.saveAuthToken(authResponse.token);
      await storage.saveUserPhone(authResponse.phoneNumber);
      if (authResponse.userId != null) {
        await storage.saveUserId(authResponse.userId!);
      }
      await storage.setLoggedIn(true);
      
      emit(OtpVerificationSuccess(true));
    } catch (e) {
      emit(AuthError('Failed to verify OTP: ${e.toString()}'));
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    try {
      emit(AuthLoading());
      await resendOtpUseCase(phoneNumber);
      emit(AuthSuccess('OTP resent successfully'));
    } catch (e) {
      emit(AuthError('Failed to resend OTP: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    final storage = await LocalStorageService.getInstance();
    await storage.clearAllAuthData();
    emit(AuthInitial());
  }
}
