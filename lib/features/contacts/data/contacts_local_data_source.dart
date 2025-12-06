// lib/features/contacts/data/contacts_local_data_source.dart

import '../../../core/database/db_helper.dart';
import '../models/contact.dart';

class ContactsLocalDataSource {
  final DBHelper _dbHelper;
  static const String _tableName = 'contacts';

  ContactsLocalDataSource({DBHelper? dbHelper}) 
      : _dbHelper = dbHelper ?? DBHelper();

  Future<List<Contact>> fetchContacts() async {
    try {
      final maps = await _dbHelper.query(_tableName);
      return maps.map((map) => Contact.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  Future<Contact?> fetchContactById(String id) async {
    try {
      final map = await _dbHelper.queryById(_tableName, id);
      return map != null ? Contact.fromMap(map) : null;
    } catch (e) {
      throw Exception('Failed to fetch contact: $e');
    }
  }

  Future<void> addContact(Contact contact) async {
    try {
      await _dbHelper.insert(_tableName, contact.toMap());
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      final result = await _dbHelper.update(_tableName, contact.toMap(), contact.id);
      if (result == 0) {
        throw Exception('Contact not found');
      }
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      final result = await _dbHelper.delete(_tableName, id);
      if (result == 0) {
        throw Exception('Contact not found');
      }
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  // Optional: Initialize with seed data
  Future<void> seedInitialData() async {
    final existingContacts = await fetchContacts();
    if (existingContacts.isEmpty) {
      final initialContacts = [
        Contact(
          id: '1',
          name: 'Abdelmalek Nedjar',
          phoneNumber: '0542930649',
          email: 'abdelmalek.nedjar@ensia.edu.dz',
          company: 'ATM mobilis',
          type: ContactType.client,
        ),
        Contact(
          id: '2',
          name: 'Enzo Chaabnia',
          phoneNumber: '0550361356',
          email: 'enzo.chaabnia@ensia.edu.dz',
          company: 'EBEC',
          type: ContactType.client,
        ),
        Contact(
          id: '3',
          name: 'Ala Mezdoud',
          phoneNumber: '0542930649',
          email: 'alaeddine.mezdoud@ensia.edu.dz',
          company: 'HostX',
          type: ContactType.client,
        ),
        Contact(
          id: 'p1-c1',
          name: 'Sarah Benali',
          phoneNumber: '+213 555 123 456',
          email: 'sarah.benali@boehm-schmidt.dz',
          company: 'Boehm, Gleichner and Schmidt',
          type: ContactType.prospect,
        ),
        Contact(
          id: 'p1-c2',
          name: 'Karim Meziane',
          phoneNumber: '+213 555 123 789',
          email: 'karim.meziane@boehm-schmidt.dz',
          company: 'Boehm, Gleichner and Schmidt',
          type: ContactType.prospect,
        ),
        Contact(
          id: 'p2-c1',
          name: 'Amina Khelifi',
          phoneNumber: '+213 555 789 012',
          email: 'amina.khelifi@techsolutions.dz',
          company: 'Tech Solutions Algeria',
          type: ContactType.prospect,
        ),
      ];

      for (final contact in initialContacts) {
        await addContact(contact);
      }
    }
  }
}