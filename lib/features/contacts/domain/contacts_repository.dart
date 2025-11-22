// lib/features/contacts/domain/contacts_repository.dart

import '../models/contact.dart';
import '../models/prospect.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getContacts();
  Future<void> addContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(String id);
}

abstract class ProspectsRepository {
  Future<List<Prospect>> getProspects();
  Future<void> addProspect(Prospect prospect);
  Future<void> updateProspect(Prospect prospect);
  Future<void> deleteProspect(String id);
}

