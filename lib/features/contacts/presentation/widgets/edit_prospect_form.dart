// lib/features/contacts/presentation/widgets/edit_prospect_form.dart

import '../../models/prospect.dart';
import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';

class EditProspectForm extends StatefulWidget {
  final Prospect initialProspect;
  final Future<void> Function(Prospect) onSave;

  const EditProspectForm({
    super.key,
    required this.initialProspect,
    required this.onSave,
  });

  @override
  State<EditProspectForm> createState() => _EditProspectFormState();
}

class _EditProspectFormState extends State<EditProspectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _entrepriseController;
  late TextEditingController _adresseController;
  late TextEditingController _wilayaController;
  late TextEditingController _communeController;
  late TextEditingController _categorieController;
  late TextEditingController _formeLegaleController;
  late TextEditingController _secteurController;
  late TextEditingController _nifController;
  late TextEditingController _registreCommerceController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _entrepriseController = TextEditingController(
      text: widget.initialProspect.entreprise,
    );
    _adresseController = TextEditingController(
      text: widget.initialProspect.adresse,
    );
    _wilayaController = TextEditingController(
      text: widget.initialProspect.wilaya,
    );
    _communeController = TextEditingController(
      text: widget.initialProspect.commune,
    );
    _categorieController = TextEditingController(
      text: widget.initialProspect.categorie,
    );
    _formeLegaleController = TextEditingController(
      text: widget.initialProspect.formeLegale,
    );
    _secteurController = TextEditingController(
      text: widget.initialProspect.secteur,
    );
    _nifController = TextEditingController(text: widget.initialProspect.nif);
    _registreCommerceController = TextEditingController(
      text: widget.initialProspect.registreCommerce,
    );
  }

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
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint(
        '[EditProspectForm] Submitting changes for ${widget.initialProspect.id}',
      );
      setState(() {
        _isSubmitting = true;
      });
      FocusScope.of(context).unfocus();

      try {
        await widget.onSave(
          Prospect(
            id: widget.initialProspect.id,
            entreprise: _entrepriseController.text.trim(),
            adresse: _adresseController.text.trim(),
            wilaya: _wilayaController.text.trim(),
            commune: _communeController.text.trim(),
            phoneNumber: widget.initialProspect.phoneNumber,
            email: widget.initialProspect.email,
            categorie: _categorieController.text.trim(),
            formeLegale: _formeLegaleController.text.trim(),
            secteur: _secteurController.text.trim(),
            sousSecteur: widget.initialProspect.sousSecteur,
            nif: _nifController.text.trim(),
            registreCommerce: _registreCommerceController.text.trim(),
            status: widget.initialProspect.status,
          ),
        );
        debugPrint(
          '[EditProspectForm] Save completed for ${widget.initialProspect.id}',
        );
      } catch (e) {
        debugPrint('[EditProspectForm] Error saving: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
                SizedBox(height: 20),

                // Title
                Text(
                  'Modifier le prospect',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Entreprise field
                TextFormField(
                  controller: _entrepriseController,
                  decoration: InputDecoration(
                    labelText: 'Entreprise',
                    prefixIcon: Icon(Icons.business, color: AppColors.primary),
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
                SizedBox(height: 16),

                // Adresse field
                TextFormField(
                  controller: _adresseController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                SizedBox(height: 16),

                // Wilaya and Commune in a row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _wilayaController,
                        decoration: InputDecoration(
                          labelText: 'Wilaya',
                          prefixIcon: Icon(Icons.map, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _communeController,
                        decoration: InputDecoration(
                          labelText: 'Commune',
                          prefixIcon: Icon(
                            Icons.place,
                            color: AppColors.primary,
                          ),
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
                SizedBox(height: 16),

                // Catégorie and Forme Légale in a row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _categorieController,
                        decoration: InputDecoration(
                          labelText: 'Catégorie',
                          prefixIcon: Icon(
                            Icons.category,
                            color: AppColors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _formeLegaleController,
                        decoration: InputDecoration(
                          labelText: 'Forme Légale',
                          prefixIcon: Icon(
                            Icons.account_balance,
                            color: AppColors.primary,
                          ),
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
                SizedBox(height: 16),

                // Secteur field
                TextFormField(
                  controller: _secteurController,
                  decoration: InputDecoration(
                    labelText: 'Secteur',
                    prefixIcon: Icon(Icons.work, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                SizedBox(height: 16),

                // NIF and RC in a row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nifController,
                        decoration: InputDecoration(
                          labelText: 'NIF',
                          prefixIcon: Icon(
                            Icons.badge,
                            color: AppColors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _registreCommerceController,
                        decoration: InputDecoration(
                          labelText: 'RC',
                          prefixIcon: Icon(
                            Icons.assignment,
                            color: AppColors.primary,
                          ),
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
                SizedBox(height: 28),

                // Save button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  child: Text(
                    'Mettre à jour',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
