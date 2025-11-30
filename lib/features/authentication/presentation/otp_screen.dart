// lib/features/authentication/presentation/screens/otp_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../../core/themes/app_theme.dart';
import '../../../../shared/validators/otp_validator.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int _otpLength = 5;
  final List<TextEditingController> _otpControllers = [];
  final List<FocusNode> _focusNodes = [];

  bool _isLoading = false;
  String? _errorMessage;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;
  int _attemptCount = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and focus nodes
    for (int i = 0; i < _otpLength; i++) {
      _otpControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }

    // Start resend timer
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

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

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _clearOtp() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  Future<void> _verifyOTP() async {
    final otpCode = _getOtpCode();

    // Validate OTP
    final validationError = OtpValidator.validateOtp(
      otpCode,
      length: _otpLength,
    );
    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement API call to verify OTP
      // API GET récupère l'OTP - Méthode Vérif FRONT

      // Simulated delay for demo
      await Future.delayed(const Duration(seconds: 2));

      // Check if OTP is valid (simulated)
      // In real implementation, compare with backend response
      bool isValid = true; // Replace with actual validation

      if (isValid) {
        // Navigate to main app
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _attemptCount++;

        if (_attemptCount >= _maxAttempts) {
          setState(() {
            _errorMessage = 'Compte temporairement bloqué pendant 1 heure.';
          });
          // TODO: Implement account lockout
        } else {
          setState(() {
            _errorMessage =
                'Code incorrect ou expiré. Veuillez ressayer. '
                '(${_maxAttempts - _attemptCount} tentatives restantes)';
          });
          _clearOtp();
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement API call to resend OTP
      // API GET récupère l'OTP

      // Simulated delay for demo
      await Future.delayed(const Duration(seconds: 1));

      _clearOtp();
      _startResendTimer();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Un nouveau code a été envoyé'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de renvoyer le code. Veuillez réessayer.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _errorMessage != null
              ? AppColors.error
              : _otpControllers[index].text.isNotEmpty
              ? AppColors.accent
              : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          setState(() {
            _errorMessage = null;
          });

          if (value.isNotEmpty) {
            // Move to next field
            if (index < _otpLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Last field, hide keyboard and verify
              _focusNodes[index].unfocus();
              _verifyOTP();
            }
          }
        },
        onTap: () {
          // Select all text when tapped
          _otpControllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _otpControllers[index].text.length,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            // Clear any ongoing processes
            _timer?.cancel();

            // Navigate back properly
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Mobilis Logo
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Adjust radius as you like
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Suivez et optimisez vos ventes à tout moment grâce à notre plateforme en ligne.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Phone number display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        widget.phoneNumber,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // OTP input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _otpLength,
                    (index) => _buildOtpField(index),
                  ),
                ),

                // Error message
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Verify button
                ElevatedButton(
                  onPressed: (_isLoading || _attemptCount >= _maxAttempts)
                      ? null
                      : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary,
                            ),
                          ),
                        )
                      : Text('Confirmer', style: AppTextStyles.button),
                ),

                const SizedBox(height: 24),

                // Resend link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore inscrit ?  ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    TextButton(
                      onPressed: _canResend && !_isLoading ? _resendOTP : null,
                      child: Text(
                        _canResend
                            ? 'Contactez-nous.'
                            : 'Renvoyer dans $_resendTimer s',
                        style: TextStyle(
                          color: _canResend ? AppColors.primary : Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
