// lib/features/prospects/presentation/prospect_detail_form_screen.dart

import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../models/prospect.dart';
import '../../contacts/models/contact.dart';
import '../../contacts/domain/contacts_repository.dart';

class ProspectDetailFormScreen extends StatefulWidget {
  final Prospect prospect;
  final Function(Prospect) onEdit;
  final Function(String) onDelete;
  final VoidCallback onConvertToClient;
  final List<Contact> interlocuteurs;
  final ContactsRepository contactRepository;

  const ProspectDetailFormScreen({
    super.key,
    required this.prospect,
    required this.onEdit,
    required this.onDelete,
    required this.onConvertToClient,
    this.interlocuteurs = const [],
    required this.contactRepository,
  });

  @override
  State<ProspectDetailFormScreen> createState() => _ProspectDetailFormScreenState();
}

class _ProspectDetailFormScreenState extends State<ProspectDetailFormScreen> {
  void _showEditForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProspectForm(
        initialProspect: widget.prospect,
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

  void _convertToClient() async {
    // Check if there are interlocuteurs
    if (widget.interlocuteurs.isEmpty) {
      final createContact = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Aucun interlocuteur'),
          content: Text('Ce prospect n\'a pas d\'interlocuteur. Voulez-vous en créer un avant de convertir en client ?'),
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
        _showCreateInterlocuteurForm();
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
        // Convert all interlocuteurs to clients
        for (var contact in widget.interlocuteurs) {
          final updatedContact = Contact(
            id: contact.id,
            name: contact.name,
            phoneNumber: contact.phoneNumber,
            email: contact.email,
            company: contact.company,
            type: ContactType.client,
          );
          await widget.contactRepository.updateContact(updatedContact);
        }

        // Delete the prospect
        widget.onConvertToClient();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Prospect converti en client avec succès!')),
        );
      } else {
        // Update prospect status
        final updatedProspect = Prospect(
          id: widget.prospect.id,
          entreprise: widget.prospect.entreprise,
          adresse: widget.prospect.adresse,
          wilaya: widget.prospect.wilaya,
          commune: widget.prospect.commune,
          phoneNumber: widget.prospect.phoneNumber,
          email: widget.prospect.email,
          categorie: widget.prospect.categorie,
          formeLegale: widget.prospect.formeLegale,
          secteur: widget.prospect.secteur,
          sousSecteur: widget.prospect.sousSecteur,
          nif: widget.prospect.nif,
          registreCommerce: widget.prospect.registreCommerce,
          status: selectedStatus,
        );
        
        widget.onEdit(updatedProspect);
        setState(() {});
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Statut mis à jour')),
        );
      }
    }
  }

  void _showCreateInterlocuteurForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateInterlocuteurForm(
        prospectCompany: widget.prospect.entreprise,
        onSave: (newContact) async {
          await widget.contactRepository.addContact(newContact);
          Navigator.of(context).pop();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Interlocuteur créé avec succès')),
          );
        },
      ),
    );
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
              _QuickActionButton(
                icon: Icons.change_circle,
                label: 'État',
                color: AppColors.primary,
                onTap: _convertToClient,
              ),
              _QuickActionButton(
                icon: Icons.person_add,
                label: 'Interlocuteur',
                color: AppColors.primary,
                onTap: _showCreateInterlocuteurForm,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interlocuteurs',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontSize: 18,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: _showCreateInterlocuteurForm,
                tooltip: 'Ajouter un interlocuteur',
              ),
            ],
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

// Create Interlocuteur Form
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

// Edit Prospect Form
class EditProspectForm extends StatefulWidget {
  final Prospect initialProspect;
  final ValueChanged<Prospect> onSave;

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

  @override
  void initState() {
    super.initState();
    _entrepriseController = TextEditingController(text: widget.initialProspect.entreprise);
    _adresseController = TextEditingController(text: widget.initialProspect.adresse);
    _wilayaController = TextEditingController(text: widget.initialProspect.wilaya);
    _communeController = TextEditingController(text: widget.initialProspect.commune);
    _categorieController = TextEditingController(text: widget.initialProspect.categorie);
    _formeLegaleController = TextEditingController(text: widget.initialProspect.formeLegale);
    _secteurController = TextEditingController(text: widget.initialProspect.secteur);
    _nifController = TextEditingController(text: widget.initialProspect.nif);
    _registreCommerceController = TextEditingController(text: widget.initialProspect.registreCommerce);
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(Prospect(
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
                    prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
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
                          prefixIcon: Icon(Icons.place, color: AppColors.primary),
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
                          prefixIcon: Icon(Icons.category, color: AppColors.primary),
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
                          prefixIcon: Icon(Icons.account_balance, color: AppColors.primary),
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
                          prefixIcon: Icon(Icons.badge, color: AppColors.primary),
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
                          prefixIcon: Icon(Icons.assignment, color: AppColors.primary),
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