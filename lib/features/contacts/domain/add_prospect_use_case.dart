import 'prospect_repository.dart';
import '../models/prospect.dart';

class AddProspectUseCase {
  final ProspectRepository repository;

  AddProspectUseCase(this.repository);

  Future<void> call(Prospect prospect) async {
    return await repository.addProspect(prospect);
  }
}
