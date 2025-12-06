import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/prospect.dart';
import '../../domain/get_prospects_use_case.dart';
import '../../domain/prospect_repository.dart';

// States
abstract class ProspectsState {}

class ProspectsInitial extends ProspectsState {}

class ProspectsLoading extends ProspectsState {}

class ProspectsLoaded extends ProspectsState {
  final List<Prospect> prospects;

  ProspectsLoaded(this.prospects);
}

class ProspectsError extends ProspectsState {
  final String message;
  ProspectsError(this.message);
}

// Cubit
class ProspectsCubit extends Cubit<ProspectsState> {
  final GetProspectsUseCase getProspectsUseCase;
  final ProspectRepository prospectRepository;

  ProspectsCubit({
    required this.getProspectsUseCase,
    required this.prospectRepository,
  }) : super(ProspectsInitial());

  Future<void> loadProspects() async {
    try {
      emit(ProspectsLoading());
      final prospects = await getProspectsUseCase();
      emit(ProspectsLoaded(prospects));
    } catch (e) {
      emit(ProspectsError('Failed to load prospects: ${e.toString()}'));
    }
  }

  Future<void> updateProspect(Prospect prospect) async {
    try {
      await prospectRepository.updateProspect(prospect);
      await loadProspects(); // Reload prospects after update
    } catch (e) {
      emit(ProspectsError('Failed to update prospect: ${e.toString()}'));
    }
  }

  Future<void> deleteProspect(String id) async {
    try {
      await prospectRepository.deleteProspect(id);
      await loadProspects(); // Reload prospects after delete
    } catch (e) {
      emit(ProspectsError('Failed to delete prospect: ${e.toString()}'));
    }
  }

  Future<void> convertProspectToClient(String id) async {
    try {
      await prospectRepository.deleteProspect(id);
      await loadProspects(); // Reload prospects after conversion
    } catch (e) {
      emit(ProspectsError('Failed to convert prospect: ${e.toString()}'));
    }
  }
}
