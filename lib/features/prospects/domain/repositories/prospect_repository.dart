// lib/features/prospects/domain/repositories/prospect_repository.dart

import '../../../contacts/models/prospect.dart';

abstract class ProspectRepository {
  Future<List<Prospect>> getProspects();
  Future<void> addProspect(Prospect prospect);
  Future<void> updateProspect(Prospect prospect);
  Future<void> deleteProspect(String id);
}
