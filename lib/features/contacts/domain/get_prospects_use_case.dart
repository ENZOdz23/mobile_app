// lib/features/prospects/domain/get_prospects_use_case.dart

import '../models/prospect.dart';
import 'prospect_repository.dart';

class GetProspectsUseCase {
  final ProspectRepository repository;

  GetProspectsUseCase(this.repository);

  Future<List<Prospect>> call() async {
    return await repository.getProspects();
  }
}
