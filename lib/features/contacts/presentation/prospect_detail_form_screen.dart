// lib/features/prospects/presentation/prospect_detail_form_screen.dart

import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../models/prospect.dart';
import '../../contacts/models/contact.dart';

class ProspectDetailFormScreen extends StatefulWidget {
  final Prospect prospect;
  final Function(Prospect) onEdit;
  final Function(String) onDelete;
  final List<Contact> interlocuteurs; // Contacts associated with this prospect

  const ProspectDetailFormScreen({
    Key? key,
    required this.prospect,
    required this.onEdit,
    required this.onDelete,
    this.interlocuteurs = const [],
  }) : super(key: key);

  @override
  State<ProspectDetailFormScreen> createState() => _ProspectDetailFormScreenState();
}

class _ProspectDetailFormScreenState extends State<ProspectDetailFormScreen> {
  void _showEditForm() {
    // TODO: Implement edit form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier le prospect')),
    );
  }

  void _delete() async {
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
      widget.onDelete(widget.prospect.id);
      Navigator.of(context).pop();
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
    final p = widget.prospect;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        actionsIconTheme: IconThemeData(color: AppColors.onPrimary),
        title: Text(
          'Fiche Entreprise',
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
          // Company header section
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Text(
                getInitials(p.entreprise),
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
              p.entreprise,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (p.adresse.isNotEmpty) ...[
            SizedBox(height: 8),
            Center(
              child: Text(
                p.adresse,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          SizedBox(height: 28),

          // Quick action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.phone,
                label: 'Tel',
                color: AppColors.primary,
                onTap: () {
                  // TODO: Make phone call
                },
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                color: AppColors.primary,
                onTap: () {
                  // TODO: Send email
                },
              ),
              _QuickActionButton(
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
          Text(
            'Interlocuteurs',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          if (widget.interlocuteurs.isEmpty)
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
            ...widget.interlocuteurs.map((contact) => _buildInterlocuteurItem(contact)),
          SizedBox(height: 24),

          // Détails de l'entreprise section
          Text(
            'Détails de l\'entreprise',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          _buildDetailCard([
            _DetailRow(
              icon: Icons.location_on,
              label: 'Adresse',
              value: p.adresse.isNotEmpty ? p.adresse : 'Non spécifié',
            ),
            if (p.wilaya.isNotEmpty)
              _DetailRow(
                icon: Icons.map,
                label: 'Wilaya',
                value: p.wilaya,
              ),
            if (p.commune.isNotEmpty)
              _DetailRow(
                icon: Icons.place,
                label: 'Commune',
                value: p.commune,
              ),
            if (p.categorie.isNotEmpty)
              _DetailRow(
                icon: Icons.category,
                label: 'Catégorie',
                value: p.categorie,
              ),
            if (p.formeLegale.isNotEmpty)
              _DetailRow(
                icon: Icons.account_balance,
                label: 'Forme Légale',
                value: p.formeLegale,
              ),
            if (p.secteur.isNotEmpty)
              _DetailRow(
                icon: Icons.work,
                label: 'Secteur',
                value: p.secteur,
              ),
            if (p.nif.isNotEmpty)
              _DetailRow(
                icon: Icons.badge,
                label: 'NIF',
                value: p.nif,
              ),
            if (p.registreCommerce.isNotEmpty)
              _DetailRow(
                icon: Icons.assignment,
                label: 'Registre de Commerce',
                value: p.registreCommerce,
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInterlocuteurItem(Contact contact) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: Text(
              getInitials(contact.name),
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (contact.phoneNumber.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        contact.phoneNumber,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<_DetailRow> details) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: details
            .map((detail) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(detail.icon, color: AppColors.primary, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              detail.value,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.secondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (detail.hasInfo)
                        Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                    ],
                  ),
                ))
            .toList(),
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
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _DetailRow {
  final IconData icon;
  final String label;
  final String value;
  final bool hasInfo;

  _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.hasInfo = false,
  });
}
