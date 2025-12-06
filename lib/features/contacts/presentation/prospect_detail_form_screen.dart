// lib/features/prospects/presentation/prospect_detail_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../models/prospect.dart';
import '../../contacts/models/contact.dart';
import '../../contacts/presentation/cubits/contacts_cubit.dart';
import '../../contacts/presentation/cubits/prospects_cubit.dart';
import '../../contacts/presentation/widgets/quick_action_button.dart';
import '../../contacts/presentation/widgets/detail_row.dart';
import '../../contacts/presentation/widgets/detail_card.dart';
import '../../contacts/presentation/widgets/interlocuteur_item.dart';
import '../../contacts/presentation/widgets/create_interlocuteur_form.dart';
import '../../contacts/presentation/widgets/edit_prospect_form.dart';
import '../../contacts/presentation/widgets/company_header.dart';
import '../../contacts/presentation/widgets/section_header.dart';
import '../../contacts/presentation/widgets/contact_utils.dart';

class ProspectDetailFormScreen extends StatelessWidget {
  final String prospectId; // Changed: accept ID instead of object
  final Future<void> Function(Prospect) onEdit;
  final Function(String) onDelete;
  final VoidCallback onConvertToClient;

  const ProspectDetailFormScreen({
    super.key,
    required this.prospectId, // Changed
    required this.onEdit,
    required this.onDelete,
    required this.onConvertToClient,
  });

  void _showEditForm(BuildContext context, Prospect prospect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProspectForm(
        initialProspect: prospect,
        onSave: (edited) async {
          await onEdit(edited);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _delete(BuildContext context, Prospect prospect) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Supprimer ce prospect ?'),
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
      onDelete(prospect.id);
      Navigator.of(context).pop();
    }
  }

  void _convertToClient(
    BuildContext context,
    Prospect prospect,
    List<Contact> interlocuteurs,
  ) async {
    // Check if there are interlocuteurs
    if (interlocuteurs.isEmpty) {
      final createContact = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Aucun interlocuteur'),
          content: Text(
            'Ce prospect n\'a pas d\'interlocuteur. Voulez-vous en créer un avant de convertir en client ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Créer'),
            ),
          ],
        ),
      );

      if (createContact == true) {
        _showCreateInterlocuteurForm(context, prospect);
      }
      return;
    }

    // Show status selection dialog
    final selectedStatus = await showDialog<ProspectStatus>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Intéressé'),
              onTap: () => Navigator.pop(context, ProspectStatus.interested),
            ),
            ListTile(
              title: Text('Non intéressé'),
              onTap: () => Navigator.pop(context, ProspectStatus.notInterested),
            ),
            ListTile(
              title: Text('Non abouti'),
              onTap: () => Navigator.pop(context, ProspectStatus.notCompleted),
            ),
            ListTile(
              title: Text('Convertir en Client'),
              onTap: () => Navigator.pop(context, ProspectStatus.client),
            ),
          ],
        ),
      ),
    );

    if (selectedStatus != null) {
      if (selectedStatus == ProspectStatus.client) {
        // Convert all interlocuteurs to clients using Cubit
        final contactsCubit = context.read<ContactsCubit>();
        for (var contact in interlocuteurs) {
          final updatedContact = Contact(
            id: contact.id,
            name: contact.name,
            phoneNumber: contact.phoneNumber,
            email: contact.email,
            company: contact.company,
            type: ContactType.client,
          );
          await contactsCubit.updateContact(updatedContact);
        }

        // Delete the prospect
        onConvertToClient();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prospect converti en client avec succès!')),
        );
      } else {
        // Update prospect status
        final updatedProspect = Prospect(
          id: prospect.id,
          entreprise: prospect.entreprise,
          adresse: prospect.adresse,
          wilaya: prospect.wilaya,
          commune: prospect.commune,
          phoneNumber: prospect.phoneNumber,
          email: prospect.email,
          categorie: prospect.categorie,
          formeLegale: prospect.formeLegale,
          secteur: prospect.secteur,
          sousSecteur: prospect.sousSecteur,
          nif: prospect.nif,
          registreCommerce: prospect.registreCommerce,
          status: selectedStatus,
        );

        onEdit(updatedProspect);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Statut mis à jour')));
      }
    }
  }

  void _showCreateInterlocuteurForm(BuildContext context, Prospect prospect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateInterlocuteurForm(
        prospectCompany: prospect.entreprise,
        onSave: (newContact) async {
          await context.read<ContactsCubit>().contactsRepository.addContact(
            newContact,
          );
          await context.read<ContactsCubit>().loadContacts();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Interlocuteur créé avec succès')),
          );
        },
      ),
    );
  }

  Color _getStatusColor(ProspectStatus status) {
    switch (status) {
      case ProspectStatus.interested:
        return Colors.green;
      case ProspectStatus.notInterested:
        return Colors.red;
      case ProspectStatus.notCompleted:
        return Colors.orange;
      case ProspectStatus.client:
        return Colors.blue;
      case ProspectStatus.prospect:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to listen to both Cubits
    return BlocBuilder<ProspectsCubit, ProspectsState>(
      builder: (context, prospectsState) {
        return BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, contactsState) {
            // Find the prospect from the current state
            Prospect? prospect;
            List<Contact> interlocuteurs = [];

            if (prospectsState is ProspectsLoaded) {
              try {
                prospect = prospectsState.prospects.firstWhere(
                  (p) => p.id == prospectId,
                );
              } catch (e) {
                // Prospect not found (maybe deleted)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
                return Scaffold(
                  appBar: AppBar(title: Text('Prospect')),
                  body: Center(child: Text('Prospect introuvable')),
                );
              }
            }

            // Get interlocuteurs for this prospect
            if (contactsState is ContactsLoaded && prospect != null) {
              interlocuteurs = contactsState.contacts
                  .where((contact) => contact.company == prospect!.entreprise)
                  .toList();
            }

            // Show loading state
            if (prospect == null) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.primary,
                  iconTheme: IconThemeData(color: AppColors.onPrimary),
                  title: Text(
                    'Fiche Entreprise',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final p = prospect;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                iconTheme: IconThemeData(color: AppColors.onPrimary),
                actionsIconTheme: IconThemeData(color: AppColors.onPrimary),
                title: Text(
                  'Fiche Entreprise',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: AppColors.onPrimary,
                    onPressed: () => _showEditForm(context, p),
                    tooltip: 'Modifier',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: AppColors.onPrimary,
                    onPressed: () => _delete(context, p),
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
              backgroundColor: AppColors.backgroundLight,
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  // Company header
                  CompanyHeader(
                    companyName: p.entreprise,
                    address: p.adresse,
                    initials: ContactUtils.getInitials(p.entreprise),
                  ),
                  SizedBox(height: 12),

                  // Status chip
                  Center(
                    child: Chip(
                      label: Text(
                        p.getStatusLabel(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: _getStatusColor(p.status),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Quick action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QuickActionButton(
                        icon: Icons.change_circle,
                        label: 'État',
                        color: AppColors.primary,
                        onTap: () =>
                            _convertToClient(context, p, interlocuteurs),
                      ),
                      QuickActionButton(
                        icon: Icons.person_add,
                        label: 'Interlocuteur',
                        color: AppColors.primary,
                        onTap: () => _showCreateInterlocuteurForm(context, p),
                      ),
                      QuickActionButton(
                        icon: Icons.calendar_today,
                        label: 'Calendrier',
                        color: AppColors.primary,
                        onTap: () {
                          // TODO: Open calendar
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Interlocuteurs section
                  SectionHeader(
                    title: 'Interlocuteurs',
                    actionIcon: Icons.add_circle,
                    onActionPressed: () =>
                        _showCreateInterlocuteurForm(context, p),
                    actionTooltip: 'Ajouter un interlocuteur',
                  ),
                  SizedBox(height: 12),

                  if (interlocuteurs.isEmpty)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey[600]),
                          SizedBox(width: 12),
                          Text(
                            'Aucun interlocuteur',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  else
                    ...interlocuteurs.map(
                      (contact) => InterlocuteurItem(contact: contact),
                    ),
                  SizedBox(height: 24),

                  // Company details section
                  SectionHeader(title: 'Détails de l\'entreprise'),
                  SizedBox(height: 12),
                  DetailCard(
                    details: [
                      DetailRow(
                        icon: Icons.location_on,
                        label: 'Adresse',
                        value: p.adresse.isNotEmpty
                            ? p.adresse
                            : 'Non spécifié',
                      ),
                      if (p.wilaya.isNotEmpty)
                        DetailRow(
                          icon: Icons.map,
                          label: 'Wilaya',
                          value: p.wilaya,
                        ),
                      if (p.commune.isNotEmpty)
                        DetailRow(
                          icon: Icons.place,
                          label: 'Commune',
                          value: p.commune,
                        ),
                      if (p.categorie.isNotEmpty)
                        DetailRow(
                          icon: Icons.category,
                          label: 'Catégorie',
                          value: p.categorie,
                        ),
                      if (p.formeLegale.isNotEmpty)
                        DetailRow(
                          icon: Icons.account_balance,
                          label: 'Forme Légale',
                          value: p.formeLegale,
                        ),
                      if (p.secteur.isNotEmpty)
                        DetailRow(
                          icon: Icons.work,
                          label: 'Secteur',
                          value: p.secteur,
                        ),
                      if (p.nif.isNotEmpty)
                        DetailRow(
                          icon: Icons.badge,
                          label: 'NIF',
                          value: p.nif,
                        ),
                      if (p.registreCommerce.isNotEmpty)
                        DetailRow(
                          icon: Icons.assignment,
                          label: 'Registre de Commerce',
                          value: p.registreCommerce,
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
