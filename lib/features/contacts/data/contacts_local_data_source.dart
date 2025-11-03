// lib/features/contacts/data/contacts_local_data_source.dart


import '../models/contact.dart';
class ContactsLocalDataSource {
  final List<Contact> _contacts = [
    Contact(id: '1', name: 'Abdelmalek Nedjar', phoneNumber: '0542930649', email: 'abdelmalek@example.com', company: 'ATM mobilis', type: ContactType.client),
    Contact(id: '2', name: 'Enzo Chaabnia', phoneNumber: '0542930649', email: 'enzo@example.com', company: 'EBEC', type: ContactType.client),
    Contact(id: '3', name: 'Ala Mezdoud', phoneNumber: '0523351610', email: 'ala@example.com', company: 'HostX', type: ContactType.client),
    Contact(id: '4', name: 'Ala Mezdoud', phoneNumber: '0523351610', email: 'ala@example.com', company: 'HostX', type: ContactType.prospect),
    Contact(id: '5', name: 'Ala Mezdoud', phoneNumber: '0523351610', email: 'ala@example.com', company: 'HostX', type: ContactType.prospect),
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
