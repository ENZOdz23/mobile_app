import '../models/company_model.dart';
import 'company_repository.dart';

/// Use case for fetching the list of companies.
/// This class acts as an intermediary between presentation and data layers.
class GetCompaniesUseCase {
  final CompanyRepository repository;

  GetCompaniesUseCase(this.repository);

  /// Executes the fetching of companies by calling the repository's fetch method.
  Future<List<CompanyModel>> execute() {
    return repository.fetchCompanies();
  }
}
