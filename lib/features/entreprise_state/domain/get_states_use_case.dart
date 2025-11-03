import '../models/state_model.dart';
import 'company_repository.dart';

/// Use case for fetching the list of possible company states.
/// Abstracts data fetching logic from UI.
class GetStatesUseCase {
  final CompanyRepository repository;

  GetStatesUseCase(this.repository);

  /// Executes the fetching of states by delegating to the repository.
  Future<List<StateModel>> execute() {
    return repository.fetchStates();
  }
}
