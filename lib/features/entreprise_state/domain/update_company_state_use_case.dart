import 'company_repository.dart';

/// Use case responsible for updating the state of a company.
/// Encapsulates the business logic to update the company status asynchronously.
class UpdateCompanyStateUseCase {
  final CompanyRepository repository;

  UpdateCompanyStateUseCase(this.repository);

  /// Calls the repository to update the state of a company given its ID and the new state ID.
  Future<bool> execute(String companyId, String newStateId) {
    return repository.updateCompanyState(companyId, newStateId);
  }
}
