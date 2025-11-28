// lib/features/contacts/domain/contacts_repository.dart

import '../models/contact.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(String id);
}

