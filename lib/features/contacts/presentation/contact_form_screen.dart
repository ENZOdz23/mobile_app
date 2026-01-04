// lib/features/contacts/presentation/contact_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/themes/app_theme.dart';
import '../models/contact.dart';
import 'widgets/edit_contact_form.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/contact_header.dart';
import 'widgets/contact_utils.dart';
import 'cubits/contacts_cubit.dart';

class ContactFormScreen extends StatelessWidget {
  final String contactId; // Changed: accept ID instead of object
  final Future<void> Function(Contact) onEdit;
  final Function(String) onDelete;

  const ContactFormScreen({
    Key? key,
    required this.contactId, // Changed
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  void _showEditForm(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditContactForm(
        initialContact: contact,
        onSave: (edited) async {
          await onEdit(edited);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _delete(BuildContext context, Contact contact) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer ce contact ?'),
        content: Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      onDelete(contact.id);
      // Navigator.of(context).pop(); // Removed to prevent double pop (handled by BlocListener)
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Impossible d\'appeler')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _sendEmail(BuildContext context, Contact contact) async {
    final email = contact.email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email non disponible')));
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Suivi - ${contact.name}'},
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _startGoogleMeet(BuildContext context, Contact contact) async {
    final email = contact.email;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email non disponible pour démarrer une réunion'),
        ),
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
            content: Text('Partagez le lien Google Meet avec ${contact.name}'),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de démarrer Google Meet')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use BlocBuilder to get fresh contact data
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        // Find the contact from the current state
        Contact? contact;

        if (state is ContactsLoaded) {
          try {
            contact = state.contacts.firstWhere((c) => c.id == contactId);
          } catch (e) {
            // Contact not found (maybe deleted)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return Scaffold(
              appBar: AppBar(title: Text('Contact')),
              body: Center(child: Text('Contact introuvable')),
            );
          }
        }

        // Show loading state
        if (contact == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.primaryColor,
              iconTheme: IconThemeData(color: AppColors.onPrimary),
              title: Text(
                'Contact',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final c = contact;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.primaryColor,
            iconTheme: IconThemeData(color: AppColors.onPrimary),
            actionsIconTheme: IconThemeData(color: AppColors.onPrimary),
            title: Text(
              'Contact',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                color: AppColors.onPrimary,
                onPressed: () => _showEditForm(context, c),
                tooltip: 'Modifier',
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: AppColors.onPrimary,
                onPressed: () => _delete(context, c),
                tooltip: 'Supprimer',
              ),
            ],
          ),
          backgroundColor: AppColors.backgroundLight,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              ContactHeader(
                name: c.name,
                initials: ContactUtils.getInitials(c.name),
              ),
              SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickActionButton(
                    icon: Icons.call,
                    label: 'Appel',
                    color: AppColors.primary,
                    onTap: () => _makePhoneCall(context, c.phoneNumber),
                  ),
                  QuickActionButton(
                    icon: Icons.email,
                    label: 'Email',
                    color: AppColors.primary,
                    onTap: () => _sendEmail(context, c),
                  ),
                  QuickActionButton(
                    icon: Icons.videocam,
                    label: 'Vidéo',
                    color: AppColors.primary,
                    onTap: () => _startGoogleMeet(context, c),
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
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
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
                      c.company.isNotEmpty
                          ? c.company
                          : 'Aucune entreprise associée',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Icon(Icons.info_outline, color: AppColors.accent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
