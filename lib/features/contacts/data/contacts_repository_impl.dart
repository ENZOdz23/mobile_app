// lib/features/contacts/data/contacts_repository_impl.dart

import '../models/contact.dart';
import 'contacts_local_data_source.dart';
import '../domain/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsLocalDataSource localDataSource;

  ContactsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Contact>> getContacts() async {
    try {
      return await localDataSource.fetchContacts();
    } catch (e) {
      throw Exception('Repository: Failed to get contacts - $e');
    }
  }

  @override
  Future<void> addContact(Contact contact) async {
    try {
      await localDataSource.addContact(contact);
    } catch (e) {
      throw Exception('Repository: Failed to add contact - $e');
    }
  }

  @override
  Future<void> updateContact(Contact contact) async {
    try {
      await localDataSource.updateContact(contact);
    } catch (e) {
      throw Exception('Repository: Failed to update contact - $e');
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await localDataSource.deleteContact(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete contact - $e');
    }
  }
}