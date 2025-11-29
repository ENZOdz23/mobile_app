// lib/features/contacts/presentation/contacts_list_screen.dart

import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../domain/get_contacts_use_case.dart';
import '../domain/contacts_repository.dart';
import '../data/contacts_local_data_source.dart';
import '../data/contacts_repository_impl.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/config/routes.dart';
import 'contact_form_screen.dart';
import 'widgets/contact_item.dart';
import 'widgets/prospect_item.dart';
import 'prospect_detail_form_screen.dart';
import '../models/prospect.dart';
import '../domain/get_prospects_use_case.dart';
import '../domain/prospect_repository.dart';
import '../data/prospect_local_data_source.dart';
import '../data/prospect_repository_impl.dart';
import '../../home/presentation/home_screen.dart';

enum ContactType { client, prospect }

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  late ContactsRepository _contactRepository;
  late ProspectRepository _prospectRepository;
  late GetContactsUseCase _getContactsUseCase;
  late GetProspectsUseCase _getProspectsUseCase;
  late Future<List<Contact>> _contactsFuture;
  late Future<List<Prospect>> _prospectsFuture;
  ContactType _selectedType = ContactType.client;

  @override
  void initState() {
    super.initState();
    _contactRepository = ContactsRepositoryImpl(
      localDataSource: ContactsLocalDataSource(),
    );
    _prospectRepository = ProspectsRepositoryImpl(
      localDataSource: ProspectsLocalDataSource(),
    );
    _getContactsUseCase = GetContactsUseCase(_contactRepository);
    _getProspectsUseCase = GetProspectsUseCase(_prospectRepository);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _contactsFuture = _getContactsUseCase();
      _prospectsFuture = _getProspectsUseCase();
    });
  }

  // Get contacts (interlocuteurs) for a specific prospect company
  Future<List<Contact>> _getInterlocuteursForProspect(String prospectCompany) async {
    final allContacts = await _contactsFuture;
    return allContacts.where((contact) => contact.company == prospectCompany).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseScaffold(
      currentIndex: 1,
      onNavTap: (index) {
        if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRoutes.offres);
        }
        if (index == 0) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
        if (index == 3) {
          Navigator.pushReplacementNamed(context, AppRoutes.more);
        }
      },
      title: 'Liste des Contacts',
      body: Column(
        children: [
          // Tab selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = ContactType.client;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedType == ContactType.client
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Clients',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedType == ContactType.client
                              ? theme.colorScheme.primary
                              : Colors.grey[600],
                          fontWeight: _selectedType == ContactType.client
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = ContactType.prospect;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedType == ContactType.prospect
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Prospects',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedType == ContactType.prospect
                              ? theme.colorScheme.primary
                              : Colors.grey[600],
                          fontWeight: _selectedType == ContactType.prospect
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Contacts/Prospects list
          Expanded(
            child: _selectedType == ContactType.client
                ? _buildClientsList()
                : _buildProspectsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList() {
    return FutureBuilder<List<Contact>>(
      future: _contactsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Aucun client trouvé',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
            ),
          );
        } else {
          final contacts = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ContactItem(
                contact: contact,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ContactFormScreen(
                        contact: contact,
                        onEdit: (updated) async {
                          await _contactRepository.updateContact(updated);
                          _loadData();
                        },
                        onDelete: (id) async {
                          await _contactRepository.deleteContact(id);
                          _loadData();
                        },
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 8),
          );
        }
      },
    );
  }

  Widget _buildProspectsList() {
    return FutureBuilder<List<Prospect>>(
      future: _prospectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Aucun prospect trouvé',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
            ),
          );
        } else {
          final prospects = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: prospects.length,
            itemBuilder: (context, index) {
              final prospect = prospects[index];
              return ProspectItem(
                prospect: prospect,
                onTap: () async {
                  // Fetch interlocuteurs for this prospect
                  final interlocuteurs = await _getInterlocuteursForProspect(prospect.entreprise);
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProspectDetailFormScreen(
                        prospect: prospect,
                        onEdit: (updated) async {
                          await _prospectRepository.updateProspect(updated);
                          _loadData();
                        },
                        onDelete: (id) async {
                          await _prospectRepository.deleteProspect(id);
                          _loadData();
                        },
                        onConvertToClient: () async {
                          // Delete the prospect and reload
                          await _prospectRepository.deleteProspect(prospect.id);
                          _loadData();
                          Navigator.of(context).pop();
                        },
                        interlocuteurs: interlocuteurs,
                        contactRepository: _contactRepository,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 8),
          );
        }
      },
    );
  }
}