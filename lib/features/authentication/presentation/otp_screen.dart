// lib/features/authentication/presentation/screens/otp_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../models/otp.dart';
import '../domain/verify_otp_usecase.dart';
import '../domain/resend_otp_usecase.dart';
import '../data/otp_repository_impl.dart';

// Reusable widgetss
import 'widgets/opt/otp_field.dart';
import 'widgets/opt/otp_phone_box.dart';
import 'widgets/opt/otp_error_box.dart';
import 'widgets/opt/otp_verify_button.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int _otpLength = 5;

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;

  String? _errorMessage;
  int _attempts = 0;
  final int _maxAttempts = 3;

  // Use cases
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final ResendOtpUseCase _resendOtpUseCase;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and focus nodes
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    // Initialize repository and use cases
    final repository = OtpRepositoryImpl();
    _verifyOtpUseCase = VerifyOtpUseCase(repository);
    _resendOtpUseCase = ResendOtpUseCase(repository);

    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ------------------------ TIMER ------------------------

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // ------------------------ OTP HELPERS ------------------------

  String _getOtp() => _controllers.map((c) => c.text).join();

  void _clearOtp() {
    for (var c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  // ------------------------ VERIFY OTP ------------------------

  Future<void> _verifyOTP() async {
    final otpCode = _getOtp();

    // Validate OTP format
    final error = otpCode.length == _otpLength ? null : 'Code OTP invalide';
    if (error != null) {
      setState(() => _errorMessage = error);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final otp = Otp(code: otpCode, phoneNumber: widget.phoneNumber);
      final isValid = await _verifyOtpUseCase(otp);

      if (isValid) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _attempts++;
        if (_attempts >= _maxAttempts) {
          setState(() {
            _errorMessage = 'Compte temporairement bloqué pendant 1 heure.';
          });
        } else {
          setState(() {
            _errorMessage =
                'Code incorrect ou expiré. Veuillez ressayer. '
                '(${_maxAttempts - _attempts} tentatives restantes)';
          });
          _clearOtp();
        }
      }
    } catch (_) {
      setState(() {
        _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------------ RESEND OTP ------------------------

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _resendOtpUseCase(widget.phoneNumber);

      _clearOtp();
      _startResendTimer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Un nouveau code a été envoyé."),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } catch (_) {
      setState(() {
        _errorMessage = "Impossible de renvoyer le code. Veuillez réessayer.";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------------ BUILD OTP FIELD ------------------------

  Widget _buildOtpBox(int index) {
    return OtpField(
      controller: _controllers[index],
      focusNode: _focusNodes[index],
      hasError: _errorMessage != null,
      onChanged: (value) {
        setState(() => _errorMessage = null);

        if (value.isNotEmpty) {
          if (index < _otpLength - 1) {
            _focusNodes[index + 1].requestFocus();
          } else {
            _focusNodes[index].unfocus();
            _verifyOTP();
          }
        }
      },
      onTap: () {
        _controllers[index].selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controllers[index].text.length,
        );
      },
    );
  }

  // ------------------------ UI ------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/logo.png', height: 80),
              ),
              const SizedBox(height: 16),
              Text(
                'Suivez et optimisez vos ventes grâce à notre plateforme.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              OtpPhoneBox(phone: widget.phoneNumber),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_otpLength, _buildOtpBox),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                OtpErrorBox(message: _errorMessage!),
              ],
              const SizedBox(height: 32),
              OtpVerifyButton(
                loading: _isLoading,
                disabled: _attempts >= _maxAttempts,
                onPressed: _verifyOTP,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _canResend && !_isLoading ? _resendOTP : null,
                child: Text(
                  _canResend
                      ? "Renvoyer le code"
                      : "Renvoyer dans $_resendTimer s",
                  style: TextStyle(
                    color: _canResend ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
