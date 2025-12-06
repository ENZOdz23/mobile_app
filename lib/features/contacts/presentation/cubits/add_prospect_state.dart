abstract class AddProspectState {}

class AddProspectInitial extends AddProspectState {}

class AddProspectLoading extends AddProspectState {}

class AddProspectSuccess extends AddProspectState {}

class AddProspectFailure extends AddProspectState {
  final String message;
  AddProspectFailure(this.message);
}
