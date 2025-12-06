import 'package:flutter_bloc/flutter_bloc.dart';

// Enum for contact type
enum ContactType { client, prospect }

// States
abstract class ContactsListState {}

class ContactsListInitial extends ContactsListState {}

class ContactsListTabChanged extends ContactsListState {
  final ContactType selectedType;

  ContactsListTabChanged(this.selectedType);
}

// Cubit
class ContactsListCubit extends Cubit<ContactsListState> {
  ContactType _selectedType = ContactType.client;

  ContactsListCubit() : super(ContactsListInitial());

  ContactType get selectedType => _selectedType;

  void changeTab(ContactType type) {
    _selectedType = type;
    emit(ContactsListTabChanged(type));
  }
}
