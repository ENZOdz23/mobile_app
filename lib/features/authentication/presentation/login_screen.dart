// lib/features/authentication/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../shared/validators/phone_validator.dart';

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

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call to verify Mobilis number and request OTP
      // API GET récupère l'OTP de la DSSI
      // Verify if phone number exists in database and belongs to a commercial

      // Simulated delay for demo
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to OTP screen
      if (mounted) {
        Navigator.pushNamed(context, '/otp', arguments: _phoneController.text);
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Seuls les numéros MOBILIS sont autorisés à accéder à cette application.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                      // Phone number input with country code
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _errorMessage != null
                                ? AppColors.error
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Country flag and code
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 16,
                            //     vertical: 16,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     border: Border(
                            //       right: BorderSide(color: Colors.grey[300]!),
                            //     ),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       // Algeria flag placeholder
                            //       Container(
                            //         width: 24,
                            //         height: 16,
                            //         decoration: BoxDecoration(
                            //           color: AppColors.primary,
                            //           borderRadius: BorderRadius.circular(2),
                            //         ),
                            //       ),
                            //       const SizedBox(width: 8),
                            //       Text(
                            //         '+213',
                            //         style: Theme.of(context).textTheme.bodyLarge
                            //             ?.copyWith(fontWeight: FontWeight.w600),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // Phone input field
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Numéro de téléphone',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  errorStyle: const TextStyle(height: 0),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                validator: PhoneValidator.validatePhoneNumber,
                                onChanged: (value) {
                                  if (_errorMessage != null) {
                                    setState(() {
                                      _errorMessage = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Confirm button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _requestOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onBackgroundDark,
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
                            : Text(
                                'Demander le code OTP',
                                style: AppTextStyles.button,
                              ),
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
