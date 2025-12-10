// lib/features/contacts/presentation/widgets/create_interlocuteur_form.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/contact.dart';

class CreateInterlocuteurForm extends StatefulWidget {
  final String prospectCompany;
  final Future<void> Function(Contact) onSave;

  const CreateInterlocuteurForm({
    super.key,
    required this.prospectCompany,
    required this.onSave,
  });

  @override
  State<CreateInterlocuteurForm> createState() =>
      _CreateInterlocuteurFormState();
}

class _CreateInterlocuteurFormState extends State<CreateInterlocuteurForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _email = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      debugPrint(
        '[CreateInterlocuteurForm] Creating new contact for ${widget.prospectCompany}',
      );
      FocusScope.of(context).unfocus();
      setState(() {
        _isSubmitting = true;
      });

      final newContact = Contact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        phoneNumber: _phoneNumber,
        email: _email,
        company: widget.prospectCompany,
        type: ContactType.prospect,
      );

      try {
        await widget.onSave(newContact);
      } catch (e) {
        debugPrint('[CreateInterlocuteurForm] Error saving contact: $e');
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nouvel Interlocuteur',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom *'),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Nom requis' : null,
              onSaved: (value) => _name = value ?? '',
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Téléphone *'),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Téléphone requis' : null,
              onSaved: (value) => _phoneNumber = value ?? '',
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email *'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Email requis' : null,
              onSaved: (value) => _email = value ?? '',
            ),
            SizedBox(height: 16),
            Text(
              'Entreprise: ${widget.prospectCompany}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text('Créer'),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
