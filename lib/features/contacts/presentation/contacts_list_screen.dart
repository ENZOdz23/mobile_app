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

class ContactsListScreen extends StatefulWidget {
  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  late ContactsRepository _repository;
  late GetContactsUseCase _getContactsUseCase;
  late Future<List<Contact>> _contactsFuture;
  ContactType _selectedType = ContactType.client;

  @override
  void initState() {
    super.initState();
    _repository = ContactsRepositoryImpl(
      localDataSource: ContactsLocalDataSource(),
    );
    _getContactsUseCase = GetContactsUseCase(_repository);
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      _contactsFuture = _getContactsUseCase();
    });
  }

  void _deleteContact(String id) async {
    final confirm = await showDialog(
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
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _repository.deleteContact(id);
      _loadContacts();
    }
  }

  List<Contact> _filterContactsByType(List<Contact> contacts) {
    return contacts.where((contact) => contact.type == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BaseScaffold(
      currentIndex: 1,
      onNavTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      title: 'Liste des Contacts',
      body: Column(
        children: [
          // UPDATED: Flat tab selector with underlines
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
          // Contacts list
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: _contactsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun contact trouvé',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  final allContacts = snapshot.data!;
                  final filteredContacts = _filterContactsByType(allContacts);
                  
                  if (filteredContacts.isEmpty) {
                    return Center(
                      child: Text(
                        _selectedType == ContactType.client
                            ? 'Aucun client trouvé'
                            : 'Aucun prospect trouvé',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      return ContactItem(
                        contact: contact,
                        onEdit: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContactFormScreen(
                                contact: contact,
                                onEdit: (updated) async {
                                  await _repository.updateContact(updated);
                                  _loadContacts();
                                },
                                onDelete: (id) async {
                                  await _repository.deleteContact(id);
                                  _loadContacts();
                                },
                              ),
                            ),
                          );
                        },
                        onDelete: () async {
                          await _repository.deleteContact(contact.id);
                          _loadContacts();
                        },
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
