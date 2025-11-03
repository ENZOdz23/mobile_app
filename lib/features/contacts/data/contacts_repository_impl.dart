// lib/features/contacts/data/contacts_repository_impl.dart

import '../models/contact.dart';
import 'contacts_local_data_source.dart';
import '../domain/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsLocalDataSource localDataSource;

  ContactsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Contact>> getContacts() => localDataSource.fetchContacts();

  @override
  Future<void> addContact(Contact contact) => localDataSource.addContact(contact);

  @override
  Future<void> updateContact(Contact contact) => localDataSource.updateContact(contact);

  @override
  Future<void> deleteContact(String id) => localDataSource.deleteContact(id);
}
