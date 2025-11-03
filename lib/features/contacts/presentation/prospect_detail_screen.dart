// lib/features/prospects/presentation/prospect_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/prospect.dart';

class ProspectDetailScreen extends StatefulWidget {
  final Prospect prospect;
  final Function(Prospect) onUpdate;
  final Function(String) onDelete;
  final Function(Prospect) onConvertToClient;

  const ProspectDetailScreen({
    Key? key,
    required this.prospect,
    required this.onUpdate,
    required this.onDelete,
    required this.onConvertToClient,
  }) : super(key: key);

  @override
  State<ProspectDetailScreen> createState() => _ProspectDetailScreenState();
}

class _ProspectDetailScreenState extends State<ProspectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prospect.entreprise),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Modifier'),
                  ],
                ),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.transform, size: 20, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Convertir en client'),
                  ],
                ),
                value: 'convert',
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer'),
                  ],
                ),
                value: 'delete',
              ),
            ],
            onSelected: (value) {
              if (value == 'convert') {
                widget.onConvertToClient(widget.prospect);
              } else if (value == 'delete') {
                widget.onDelete(widget.prospect.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Base'),
            Tab(text: 'Contact'),
            Tab(text: 'Business'),
            Tab(text: 'Legal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBaseTab(),
          _buildContactTab(),
          _buildBusinessTab(),
          _buildLegalTab(),
        ],
      ),
    );
  }

  Widget _buildBaseTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusChip(),
          SizedBox(height: 24),
          _buildSectionTitle('Informations de Base'),
          SizedBox(height: 16),
          _buildDetailRow(Icons.business, 'Entreprise', widget.prospect.entreprise),
          _buildDetailRow(Icons.location_on, 'Adresse', widget.prospect.adresse),
          _buildDetailRow(Icons.map, 'Wilaya', widget.prospect.wilaya),
          _buildDetailRow(Icons.place, 'Commune', widget.prospect.commune),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informations Personnelles'),
          SizedBox(height: 16),
          _buildDetailRow(Icons.phone, 'Téléphone', widget.prospect.phoneNumber),
          _buildDetailRow(Icons.email, 'Email', widget.prospect.email),
        ],
      ),
    );
  }

  Widget _buildBusinessTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informations sur l\'Entreprise'),
          SizedBox(height: 16),
          _buildDetailRow(Icons.category, 'Catégorie', widget.prospect.categorie),
          _buildDetailRow(Icons.account_balance, 'Forme Légale', widget.prospect.formeLegale),
          _buildDetailRow(Icons.work, 'Secteur', widget.prospect.secteur),
          _buildDetailRow(Icons.work_outline, 'Sous-Secteur', widget.prospect.sousSecteur),
        ],
      ),
    );
  }

  Widget _buildLegalTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informations Juridiques'),
          SizedBox(height: 16),
          _buildDetailRow(Icons.badge, 'NIF', widget.prospect.nif),
          _buildDetailRow(Icons.assignment, 'Registre de Commerce', widget.prospect.registreCommerce),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    switch (widget.prospect.status) {
      case ProspectStatus.interested:
        statusColor = Colors.green;
        break;
      case ProspectStatus.notInterested:
        statusColor = Colors.red;
        break;
      case ProspectStatus.notCompleted:
        statusColor = Colors.orange;
        break;
      case ProspectStatus.client:
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 12, color: statusColor),
          SizedBox(width: 8),
          Text(
            widget.prospect.getStatusLabel(),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Non spécifié',
                  style: TextStyle(
                    fontSize: 15,
                    color: value.isNotEmpty ? Colors.black87 : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
