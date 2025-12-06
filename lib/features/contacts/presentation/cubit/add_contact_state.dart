abstract class AddContactState {}

class AddContactInitial extends AddContactState {}

class AddContactLoading extends AddContactState {}

class AddContactSuccess extends AddContactState {}

class AddContactFailure extends AddContactState {
  final String message;
  AddContactFailure(this.message);
}
