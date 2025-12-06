import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/add_contact_use_case.dart';
import '../../models/contact.dart';
import 'add_contact_state.dart';

class AddContactCubit extends Cubit<AddContactState> {
  final AddContactUseCase _addContactUseCase;

  AddContactCubit(this._addContactUseCase) : super(AddContactInitial());

  Future<void> addContact(Contact contact) async {
    emit(AddContactLoading());
    try {
      await _addContactUseCase(contact);
      emit(AddContactSuccess());
    } catch (e) {
      emit(AddContactFailure(e.toString()));
    }
  }
}
