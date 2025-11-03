// lib/features/prospects/domain/prospects_repository.dart

import '../models/prospect.dart';

abstract class ProspectRepository {
  Future<List<Prospect>> getProspects();
  Future<void> addProspect(Prospect prospect);
  Future<void> updateProspect(Prospect prospect);
  Future<void> deleteProspect(String id);
}
