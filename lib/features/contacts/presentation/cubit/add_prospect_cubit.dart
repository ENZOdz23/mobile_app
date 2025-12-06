import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/add_prospect_use_case.dart';
import '../../models/prospect.dart';
import 'add_prospect_state.dart';

class AddProspectCubit extends Cubit<AddProspectState> {
  final AddProspectUseCase _addProspectUseCase;

  AddProspectCubit(this._addProspectUseCase) : super(AddProspectInitial());

  Future<void> addProspect(Prospect prospect) async {
    emit(AddProspectLoading());
    try {
      await _addProspectUseCase(prospect);
      emit(AddProspectSuccess());
    } catch (e) {
      emit(AddProspectFailure(e.toString()));
    }
  }
}
