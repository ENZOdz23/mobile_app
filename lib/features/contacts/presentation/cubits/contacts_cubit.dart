import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/contact.dart';
import '../../domain/get_contacts_use_case.dart';
import '../../domain/contacts_repository.dart';

// States
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Contact> contacts;

  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}

// Cubit
class ContactsCubit extends Cubit<ContactsState> {
  final GetContactsUseCase getContactsUseCase;
  final ContactsRepository contactsRepository;

  ContactsCubit({
    required this.getContactsUseCase,
    required this.contactsRepository,
  }) : super(ContactsInitial());

  Future<void> loadContacts() async {
    try {
      emit(ContactsLoading());
      final contacts = await getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError('Failed to load contacts: ${e.toString()}'));
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      await contactsRepository.updateContact(contact);
      await loadContacts(); // Reload contacts after update
    } catch (e) {
      emit(ContactsError('Failed to update contact: ${e.toString()}'));
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await contactsRepository.deleteContact(id);
      await loadContacts(); // Reload contacts after delete
    } catch (e) {
      emit(ContactsError('Failed to delete contact: ${e.toString()}'));
    }
  }

  List<Contact> getInterlocuteursForProspect(String prospectCompany) {
    final currentState = state;
    if (currentState is ContactsLoaded) {
      return currentState.contacts
          .where((contact) => contact.company == prospectCompany)
          .toList();
    }
    return [];
  }
}
