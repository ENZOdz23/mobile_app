// lib/features/authentication/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/../../../core/themes/app_theme.dart';
import '../../../../shared/validators/phone_validator.dart';

import '../data/login_repository_impl.dart';
import '../domain/check_phone_exists_usecase.dart';
import '../domain/request_otp_usecase.dart';
import '../models/login.dart';

// Widgets
import 'widgets/login/login_phone_field.dart';
import 'widgets/login/login_error_box.dart';
import 'widgets/login/login_request_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  // Use cases
  late final CheckPhoneExistsUseCase _checkPhoneExistsUseCase;
  late final RequestOtpUseCase _requestOtpUseCase;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final repository = LoginRepositoryImpl();
    _checkPhoneExistsUseCase = CheckPhoneExistsUseCase(repository);
    _requestOtpUseCase = RequestOtpUseCase(repository);
  }

  Future<void> _requestOTP() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phone = _phoneController.text;

      // Step 1: Check if phone number exists
      debugPrint('Checking if phone number exists...');
      final phoneExists = await _checkPhoneExistsUseCase.call(phone);

      if (!phoneExists) {
        setState(
          () => _errorMessage = 'Ce numéro de téléphone n\'est pas enregistré.',
        );
        return;
      }

      // Step 2: Phone exists, proceed with OTP request
      debugPrint('Phone number found. Requesting OTP...');
      final login = Login(phoneNumber: phone);
      final otpCode = await _requestOtpUseCase.call(login.phoneNumber);

      if (mounted) {
        // Navigate to OTP screen with phone number and OTP code
        Navigator.pushNamed(
          context,
          '/otp',
          arguments: {'phoneNumber': phone, 'otpCode': otpCode},
        );
      }
    } catch (e) {
      // Log and show errors
      debugPrint('requestOtp error: $e');
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() => _errorMessage = msg);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

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

                const SizedBox(height: 40),

                // Title
                Text(
                  'Gérez vos ventes avec notre application',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Gérez vos ventes à tout moment, avec notre application en ligne Prospectra.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Phone field (extracted widget)
                      LoginPhoneField(
                        controller: _phoneController,
                        hasError: _errorMessage != null,
                        validator: PhoneValidator.validatePhoneNumber,
                        onChanged: (value) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        LoginErrorBox(message: _errorMessage!),
                      ],

                      const SizedBox(height: 30),

                      // Confirm button (extracted)
                      LoginRequestButton(
                        loading: _isLoading,
                        onPressed: _requestOTP,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
