import 'contacts_repository.dart';
import '../models/contact.dart';

class AddContactUseCase {
  final ContactsRepository repository;

  AddContactUseCase(this.repository);

  Future<void> call(Contact contact) async {
    return await repository.addContact(contact);
  }
}
