// lib/features/contacts/data/contacts_local_data_source.dart


import 'package:crm_sales_performance_mobilis/features/contacts/models/prospect.dart';

import '../models/contact.dart';
class ContactsLocalDataSource {
  final List<Contact> _contacts = [
    Contact(id: '1', name: 'Abdelmalek Nedjar', phoneNumber: '0542930649', email: 'abdelmalek.nedjar@ensia.edu.dz', company: 'ATM mobilis', type: ContactType.client),
    Contact(id: '2', name: 'Enzo Chaabnia', phoneNumber: '0550361356', email: 'enzo.chaabnia@ensia.edu.dz', company: 'EBEC', type: ContactType.client),
    Contact(id: '3', name: 'Ala Mezdoud', phoneNumber: '0542930649', email: 'alaeddine.mezdoud@ensia.edu.dz', company: 'HostX', type: ContactType.client),

  ];

  final List<Prospect> _prospects = [
    Prospect(id: '4', entreprise: 'Abdelmalek Nedjar', phoneNumber: '0542930649', email: 'abdelmalek@example.com', wilaya: '', commune: '', categorie: '', formeLegale: '', secteur: '', sousSecteur: '', nif: '', registreCommerce: '', status: ProspectStatus.prospect),
    Prospect(id: '5', entreprise: 'Enzo Chaabnia', phoneNumber: '0542930649', email: 'enzo@example.com', wilaya: '', commune: '', categorie: '', formeLegale: '', secteur: '', sousSecteur: '', nif: '', registreCommerce: '', status: ProspectStatus.prospect),
    Prospect(id: '6', entreprise: 'Ala Mezdoud', phoneNumber: '0523351610', email: 'ala@example.com', wilaya: '', commune: '', categorie: '', formeLegale: '', secteur: '', sousSecteur: '', nif: '', registreCommerce: '', status: ProspectStatus.prospect),
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

  Future<List<Prospect>> fetchProspects() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List<Prospect>.from(_prospects);
  }

  Future<void> addProspect(Prospect prospect) async {
    _prospects.add(prospect);
  }

  Future<void> updateProspect(Prospect updatedProspect) async {
    final index = _prospects.indexWhere((p) => p.id == updatedProspect.id);
    if (index != -1) {
      _prospects[index] = updatedProspect;
    }
  }

  Future<void> deleteProspect(String id) async {
    _prospects.removeWhere((p) => p.id == id);
  }
}
