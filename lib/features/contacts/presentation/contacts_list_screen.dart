import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/get_contacts_use_case.dart';
import '../data/contacts_local_data_source.dart';
import '../data/contacts_repository_impl.dart';
import '../../../shared/components/base_scaffold.dart';
import '../../../core/config/routes.dart';
import 'contact_form_screen.dart';
import 'widgets/contact_item.dart';
import 'widgets/prospect_item.dart';
import 'prospect_detail_form_screen.dart';
import '../domain/get_prospects_use_case.dart';
import '../data/prospect_local_data_source.dart';
import '../data/prospect_repository_impl.dart';
import 'cubits/contacts_cubit.dart';
import 'cubits/prospects_cubit.dart';
import 'cubits/contacts_list_cubit.dart';

class ContactsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize repositories and use cases
    final contactRepository = ContactsRepositoryImpl(
      localDataSource: ContactsLocalDataSource(),
    );
    final prospectRepository = ProspectRepositoryImpl(
      localDataSource: ProspectsLocalDataSource(),
    );
    final getContactsUseCase = GetContactsUseCase(contactRepository);
    final getProspectsUseCase = GetProspectsUseCase(prospectRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContactsCubit(
            getContactsUseCase: getContactsUseCase,
            contactsRepository: contactRepository,
          )..loadContacts(),
        ),
        BlocProvider(
          create: (context) => ProspectsCubit(
            getProspectsUseCase: getProspectsUseCase,
            prospectRepository: prospectRepository,
          )..loadProspects(),
        ),
        BlocProvider(create: (context) => ContactsListCubit()),
      ],
      child: _ContactsListScreenContent(),
    );
  }
}

class _ContactsListScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(
      title: 'Liste des Contacts',
      body: Column(
        children: [
          // Tab selector
          BlocBuilder<ContactsListCubit, ContactsListState>(
            builder: (context, state) {
              final cubit = context.read<ContactsListCubit>();
              final selectedType = cubit.selectedType;

              return Container(
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
                          cubit.changeTab(ContactType.client);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedType == ContactType.client
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
                              color: selectedType == ContactType.client
                                  ? theme.colorScheme.primary
                                  : Colors.grey[600],
                              fontWeight: selectedType == ContactType.client
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
                          cubit.changeTab(ContactType.prospect);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedType == ContactType.prospect
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
                              color: selectedType == ContactType.prospect
                                  ? theme.colorScheme.primary
                                  : Colors.grey[600],
                              fontWeight: selectedType == ContactType.prospect
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
              );
            },
          ),
          // Contacts/Prospects list
          Expanded(
            child: BlocBuilder<ContactsListCubit, ContactsListState>(
              builder: (context, state) {
                final cubit = context.read<ContactsListCubit>();
                return cubit.selectedType == ContactType.client
                    ? _buildClientsList(context)
                    : _buildProspectsList(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ContactsError) {
          return Center(child: Text(state.message));
        } else if (state is ContactsLoaded) {
          final contacts = state.contacts;

          if (contacts.isEmpty) {
            return Center(
              child: Text(
                'Aucun client trouvé',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ContactItem(
                contact: contact,
                onTap: () {
                  // Pass contact ID instead of contact object
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ContactsCubit>(),
                        child: ContactFormScreen(
                          contactId: contact.id, // Changed: pass ID
                          onEdit: (updated) => context.read<ContactsCubit>().updateContact(updated),
                          onDelete: (id) {
                            context.read<ContactsCubit>().deleteContact(id);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 8),
          );
        }

        return Center(child: Text('Aucun client trouvé'));
      },
    );
  }

  Widget _buildProspectsList(BuildContext context) {
    return BlocBuilder<ProspectsCubit, ProspectsState>(
      builder: (context, state) {
        if (state is ProspectsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProspectsError) {
          return Center(child: Text(state.message));
        } else if (state is ProspectsLoaded) {
          final prospects = state.prospects;

          if (prospects.isEmpty) {
            return Center(
              child: Text(
                'Aucun prospect trouvé',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: prospects.length,
            itemBuilder: (context, index) {
              final prospect = prospects[index];
              return ProspectItem(
                prospect: prospect,
                onTap: () {
                  // Pass prospect ID instead of prospect object
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<ContactsCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ProspectsCubit>(),
                          ),
                        ],
                        child: ProspectDetailFormScreen(
                          prospectId: prospect.id, // Changed: pass ID
                          onEdit: (updated) => context.read<ProspectsCubit>().updateProspect(updated),
                          onDelete: (id) {
                            context.read<ProspectsCubit>().deleteProspect(id);
                          },
                          onConvertToClient: () async {
                            await context
                                .read<ProspectsCubit>()
                                .convertProspectToClient(prospect.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  );
                  _loadData(context);
                },
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 8),
          );
        }

        return Center(child: Text('Aucun prospect trouvé'));
      },
    );
  }
  
  void _loadData(BuildContext context) {
    context.read<ContactsCubit>().loadContacts();
    context.read<ProspectsCubit>().loadProspects();
  }
}