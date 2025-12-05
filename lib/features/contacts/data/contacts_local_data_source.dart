// lib/features/contacts/data/contacts_local_data_source.dart

import '../models/contact.dart';

class ContactsLocalDataSource {
  static final List<Contact> _contacts = [
    // Client contacts
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
    
    // Prospect contacts (interlocuteurs)
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

  Future<List<Contact>> fetchContacts() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List<Contact>.from(_contacts);
  }

  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
  }

  Future<void> updateContact(Contact updatedContact) async {
    final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
    }
  }

  Future<void> deleteContact(String id) async {
    _contacts.removeWhere((c) => c.id == id);
  }
}