// lib/features/contacts/domain/get_contacts_use_case.dart

import 'contacts_repository.dart';
import '../models/contact.dart';
import '../models/prospect.dart';

class GetContactsUseCase {
  final ContactsRepository repository;

  GetContactsUseCase(this.repository);

  Future<List<Contact>> call() async {
    return await repository.getContacts();
  }
}