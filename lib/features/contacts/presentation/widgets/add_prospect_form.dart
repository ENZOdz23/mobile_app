import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/prospect.dart';
import '../cubit/add_prospect_cubit.dart';
import '../cubit/add_prospect_state.dart';

class AddProspectForm extends StatefulWidget {
  const AddProspectForm({super.key});

  @override
  State<AddProspectForm> createState() => _AddProspectFormState();
}

class _AddProspectFormState extends State<AddProspectForm> {
  final _formKey = GlobalKey<FormState>();
  final _entrepriseController = TextEditingController();
  final _adresseController = TextEditingController();
  final _wilayaController = TextEditingController();
  final _communeController = TextEditingController();
  final _categorieController = TextEditingController();
  final _formeLegaleController = TextEditingController();
  final _secteurController = TextEditingController();
  final _nifController = TextEditingController();
  final _registreCommerceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _entrepriseController.dispose();
    _adresseController.dispose();
    _wilayaController.dispose();
    _communeController.dispose();
    _categorieController.dispose();
    _formeLegaleController.dispose();
    _secteurController.dispose();
    _nifController.dispose();
    _registreCommerceController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final prospect = Prospect(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        entreprise: _entrepriseController.text.trim(),
        adresse: _adresseController.text.trim(),
        wilaya: _wilayaController.text.trim(),
        commune: _communeController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        categorie: _categorieController.text.trim(),
        formeLegale: _formeLegaleController.text.trim(),
        secteur: _secteurController.text.trim(),
        nif: _nifController.text.trim(),
        registreCommerce: _registreCommerceController.text.trim(),
        status: ProspectStatus.prospect,
      );
      context.read<AddProspectCubit>().addProspect(prospect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProspectCubit, AddProspectState>(
      listener: (context, state) {
        if (state is AddProspectSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prospect ajouté avec succès')),
          );
          Navigator.of(context).pop();
        } else if (state is AddProspectFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.message}')),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'Nouveau prospect',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Entreprise field
                  TextFormField(
                    controller: _entrepriseController,
                    decoration: InputDecoration(
                      labelText: 'Entreprise',
                      prefixIcon: const Icon(Icons.business, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) 
                        ? 'Entreprise requise' 
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Adresse field
                  TextFormField(
                    controller: _adresseController,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Wilaya and Commune in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _wilayaController,
                          decoration: InputDecoration(
                            labelText: 'Wilaya',
                            prefixIcon: const Icon(Icons.map, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _communeController,
                          decoration: InputDecoration(
                            labelText: 'Commune',
                            prefixIcon: const Icon(Icons.place, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Catégorie and Forme Légale in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _categorieController,
                          decoration: InputDecoration(
                            labelText: 'Catégorie',
                            prefixIcon: const Icon(Icons.category, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _formeLegaleController,
                          decoration: InputDecoration(
                            labelText: 'Forme Légale',
                            prefixIcon: const Icon(Icons.account_balance, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Secteur field
                  TextFormField(
                    controller: _secteurController,
                    decoration: InputDecoration(
                      labelText: 'Secteur',
                      prefixIcon: const Icon(Icons.work, color: AppColors.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // NIF and RC in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nifController,
                          decoration: InputDecoration(
                            labelText: 'NIF',
                            prefixIcon: const Icon(Icons.badge, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _registreCommerceController,
                          decoration: InputDecoration(
                            labelText: 'RC',
                            prefixIcon: const Icon(Icons.assignment, color: AppColors.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  
                  // Save button
                  BlocBuilder<AddProspectCubit, AddProspectState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AddProspectLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                        child: state is AddProspectLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Ajouter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
