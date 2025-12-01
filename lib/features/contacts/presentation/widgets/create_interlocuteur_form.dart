// lib/features/contacts/presentation/widgets/create_interlocuteur_form.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/contact.dart';

class CreateInterlocuteurForm extends StatefulWidget {
  final String prospectCompany;
  final ValueChanged<Contact> onSave;

  const CreateInterlocuteurForm({
    super.key,
    required this.prospectCompany,
    required this.onSave,
  });

  @override
  State<CreateInterlocuteurForm> createState() => _CreateInterlocuteurFormState();
}

class _CreateInterlocuteurFormState extends State<CreateInterlocuteurForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _email = '';

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      final newContact = Contact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        phoneNumber: _phoneNumber,
        email: _email,
        company: widget.prospectCompany,
        type: ContactType.prospect,
      );
      
      widget.onSave(newContact);
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
        child: Wrap(
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
              validator: (value) => (value == null || value.isEmpty) ? 'Nom requis' : null,
              onSaved: (value) => _name = value ?? '',
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Téléphone *'),
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.isEmpty) ? 'Téléphone requis' : null,
              onSaved: (value) => _phoneNumber = value ?? '',
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email *'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value == null || value.isEmpty) ? 'Email requis' : null,
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
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text('Créer'),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}