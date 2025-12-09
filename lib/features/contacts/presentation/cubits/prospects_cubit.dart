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

  Future<void> addProspect(Prospect prospect) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ProspectsLoaded) {
        // Add prospect to current list
        final updatedProspects = [...currentState.prospects, prospect];
        // Emit the updated state immediately
        emit(ProspectsLoaded(updatedProspects));
      }
      // Then persist to database
      await prospectRepository.addProspect(prospect);
    } catch (e) {
      emit(ProspectsError('Failed to add prospect: ${e.toString()}'));
      // Reload to revert on error
      await loadProspects();
    }
  }

  Future<void> updateProspect(Prospect prospect) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ProspectsLoaded) {
        // Update prospect in current list
        final updatedProspects = currentState.prospects.map((p) {
          return p.id == prospect.id ? prospect : p;
        }).toList();
        // Emit the updated state immediately
        emit(ProspectsLoaded(updatedProspects));
      }
      // Then persist to database
      await prospectRepository.updateProspect(prospect);
    } catch (e) {
      emit(ProspectsError('Failed to update prospect: ${e.toString()}'));
      // Reload to revert on error
      await loadProspects();
    }
  }

  Future<void> deleteProspect(String id) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ProspectsLoaded) {
        // Remove prospect from current list
        final updatedProspects = currentState.prospects
            .where((prospect) => prospect.id != id)
            .toList();
        // Emit the updated state immediately
        emit(ProspectsLoaded(updatedProspects));
      }
      // Then persist to database
      await prospectRepository.deleteProspect(id);
    } catch (e) {
      emit(ProspectsError('Failed to delete prospect: ${e.toString()}'));
      // Reload to revert on error
      await loadProspects();
    }
  }

  Future<void> convertProspectToClient(String id) async {
    try {
      // Get current state
      final currentState = state;
      if (currentState is ProspectsLoaded) {
        // Remove prospect from current list
        final updatedProspects = currentState.prospects
            .where((prospect) => prospect.id != id)
            .toList();
        // Emit the updated state immediately
        emit(ProspectsLoaded(updatedProspects));
      }
      // Then persist to database
      await prospectRepository.deleteProspect(id);
    } catch (e) {
      emit(ProspectsError('Failed to convert prospect: ${e.toString()}'));
      // Reload to revert on error
      await loadProspects();
    }
  }
}
