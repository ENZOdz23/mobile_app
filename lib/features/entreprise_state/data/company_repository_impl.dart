import '../domain/company_repository.dart';
import '../models/company_model.dart';
import '../models/state_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  
  // TODO: Replace these with your API base URL or client instance
  // final String baseUrl = "https://yourapi.com";
  // final ApiClient apiClient;

  CompanyRepositoryImpl();

  @override
  Future<List<CompanyModel>> fetchCompanies() async {
    // TODO: implement API call to fetch companies
    // Example:
    // final response = await apiClient.get("/companies");
    // parse response and convert to List<CompanyModel>

    // Temporary mocked data for testing:
    return Future.delayed(Duration(seconds: 1), () {
      return [
        CompanyModel(id: '1', name: 'Entreprise A', state: StateModel(id: '1', label: 'Intéressé')),
        CompanyModel(id: '2', name: 'Entreprise B', state: StateModel(id: '2', label: 'Non intéressé')),

      ];
    });
  }

  @override
  Future<List<StateModel>> fetchStates() async {
    // TODO: implement API call to fetch states
    // Example:
    // final response = await apiClient.get("/states");

    // Temporary mocked data for testing:
    return Future.delayed(Duration(seconds: 1), () {
      return [
        StateModel(id: '1', label: 'Intéressé'),
        StateModel(id: '2', label: 'Non intéressé'),
        StateModel(id: '3', label: 'Non abouti'),
        StateModel(id: '4', label: 'Prospect'),
        StateModel(id: '5', label: 'Client'),
      ];
    });
  }

  @override
  Future<bool> updateCompanyState(String companyId, String newStateId) async {
    // TODO: implement API call to update company state
    // Example:
    // final response = await apiClient.put("/companies/$companyId/state", {"stateId": newStateId});

    // For now, just simulate success:
    return Future.delayed(Duration(seconds: 1), () => true);
  }
}
