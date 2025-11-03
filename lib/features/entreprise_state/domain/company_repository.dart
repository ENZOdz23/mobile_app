import '../models/company_model.dart';
import '../models/state_model.dart';

abstract class CompanyRepository {
  Future<List<CompanyModel>> fetchCompanies();
  Future<List<StateModel>> fetchStates();
  Future<bool> updateCompanyState(String companyId, String newStateId);
}
