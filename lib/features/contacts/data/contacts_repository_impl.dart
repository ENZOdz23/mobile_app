// lib/features/contacts/data/contacts_repository_impl.dart

import '../models/contact.dart';
import 'datasources/contacts_remote_data_source.dart';
import '../domain/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final IContactsRemoteDataSource remoteDataSource;

  ContactsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Contact>> getContacts() async {
    try {
      return await remoteDataSource.fetchContacts();
    } catch (e) {
      throw Exception('Repository: Failed to get contacts - $e');
    }
  }

  @override
  Future<void> addContact(Contact contact) async {
    try {
      await remoteDataSource.createContact(contact);
    } catch (e) {
      throw Exception('Repository: Failed to add contact - $e');
    }
  }

  @override
  Future<void> updateContact(Contact contact) async {
    try {
      await remoteDataSource.updateContact(contact);
    } catch (e) {
      throw Exception('Repository: Failed to update contact - $e');
    }
  }

  @override
  Future<void> deleteContact(String id) async {
    try {
      await remoteDataSource.deleteContact(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete contact - $e');
    }
  }
}
