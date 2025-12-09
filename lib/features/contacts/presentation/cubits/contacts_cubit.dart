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

  Future<void> addContact(Contact contact) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ContactsLoaded) {
        // Add contact to current list
        final updatedContacts = [...currentState.contacts, contact];
        // Emit the updated state immediately
        emit(ContactsLoaded(updatedContacts));
      }
      // Then persist to database
      await contactsRepository.addContact(contact);
    } catch (e) {
      emit(ContactsError('Failed to add contact: ${e.toString()}'));
      // Reload to revert on error
      await loadContacts();
    }
  }

  Future<void> updateContact(Contact contact) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ContactsLoaded) {
        // Update contact in current list
        final updatedContacts = currentState.contacts.map((c) {
          return c.id == contact.id ? contact : c;
        }).toList();
        // Emit the updated state immediately
        emit(ContactsLoaded(updatedContacts));
      }
      // Then persist to database
      await contactsRepository.updateContact(contact);
    } catch (e) {
      emit(ContactsError('Failed to update contact: ${e.toString()}'));
      // Reload to revert on error
      await loadContacts();
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ContactsLoaded) {
        // Remove contact from current list
        final updatedContacts = currentState.contacts
            .where((contact) => contact.id != id)
            .toList();
        // Emit the updated state immediately
        emit(ContactsLoaded(updatedContacts));
      }
      // Then persist to database
      await contactsRepository.deleteContact(id);
    } catch (e) {
      emit(ContactsError('Failed to delete contact: ${e.toString()}'));
      // Reload to revert on error
      await loadContacts();
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
