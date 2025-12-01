// lib/features/contacts/presentation/contact_form_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/themes/app_theme.dart';
import '../models/contact.dart';
import '../../../shared/validators/contact_validator.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact contact;
  final Function(Contact) onEdit;
  final Function(String) onDelete;

  const ContactFormScreen({
    Key? key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  void _showEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditContactForm(
        initialContact: widget.contact,
        onSave: (edited) {
          widget.onEdit(edited);
          Navigator.of(context).pop();
          setState(() {});
        },
      ),
    );
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Supprimer ce contact ?'),
          ],
        ),
        content: Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      widget.onDelete(widget.contact.id);
      Navigator.of(context).pop();
    }
  }

  Future<void> _makePhoneCall() async {
    final phone = widget.contact.phoneNumber;
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Numéro de téléphone non disponible')),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'appeler')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _sendEmail() async {
    final email = widget.contact.email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email non disponible')),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Suivi - ${widget.contact.name}',
      },
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d\'envoyer un email')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  Future<void> _startGoogleMeet() async {
    final email = widget.contact.email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email non disponible pour démarrer une réunion')),
      );
      return;
    }

    final meetUrl = 'https://meet.google.com/new';
    
    try {
      if (await canLaunchUrl(Uri.parse(meetUrl))) {
        await launchUrl(
          Uri.parse(meetUrl),
          mode: LaunchMode.externalApplication,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Partagez le lien Google Meet avec ${widget.contact.name}',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de démarrer Google Meet')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  String getInitials(String name) {
    if (name.isEmpty) return "?";
    var parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = widget.contact;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        actionsIconTheme: IconThemeData(color: AppColors.onPrimary),
        title: Text(
          'Contact',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: AppColors.onPrimary,
            onPressed: _showEditForm,
            tooltip: 'Modifier',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: AppColors.onPrimary,
            onPressed: _delete,
            tooltip: 'Supprimer',
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundLight,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                getInitials(c.name),
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Center(
            child: Text(
              c.name,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.call,
                label: 'Appel',
                color: AppColors.primary,
                onTap: _makePhoneCall,
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                color: AppColors.primary,
                onTap: _sendEmail,
              ),
              _QuickActionButton(
                icon: Icons.videocam,
                label: 'Vidéo',
                color: AppColors.primary,
                onTap: _startGoogleMeet,
              ),
            ],
          ),
          SizedBox(height: 28),
          Text(
            'Coordonnées',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  c.phoneNumber,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary),
                ),
              ),
              Text(
                'Mobile',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final Uri smsUri = Uri(
                    scheme: 'sms',
                    path: c.phoneNumber,
                  );
                  launchUrl(smsUri);
                },
                child: Icon(Icons.sms, color: AppColors.accent),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Détails du contact',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.business, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  c.company.isNotEmpty ? c.company : 'Aucune entreprise associée',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary),
                ),
              ),
              Icon(Icons.info_outline, color: AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }
}

class EditContactForm extends StatefulWidget {
  final Contact initialContact;
  final ValueChanged<Contact> onSave;

  const EditContactForm({
    super.key,
    required this.initialContact,
    required this.onSave,
  });

  @override
  State<EditContactForm> createState() => _EditContactFormState();
}

class _EditContactFormState extends State<EditContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialContact.name);
    _phoneController = TextEditingController(text: widget.initialContact.phoneNumber);
    _emailController = TextEditingController(text: widget.initialContact.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(Contact(
        id: widget.initialContact.id,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        company: widget.initialContact.company,
        type: widget.initialContact.type,
      ));
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
              SizedBox(height: 24),
              
              // Title
              Text(
                'Modifier le contact',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) => ContactValidator.validateName(value),
              ),
              SizedBox(height: 20),
              
              // Phone field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => (value == null || value.isEmpty) 
                    ? 'Téléphone requis' 
                    : null,
              ),
              SizedBox(height: 20),
              
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Email requis';
                  return ContactValidator.validateEmail(value);
                },
              ),
              SizedBox(height: 32),
              
              // Save button
              ElevatedButton(
                onPressed: _submit,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          shape: CircleBorder(),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(icon, size: 28, color: color),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.secondary),
        ),
      ],
    );
  }
}