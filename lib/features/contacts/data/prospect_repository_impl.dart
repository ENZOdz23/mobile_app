// lib/features/prospects/data/prospects_repository_impl.dart

import '../domain/prospect_repository.dart';
import '../models/prospect.dart';
import 'prospect_local_data_source.dart';

class ProspectsRepositoryImpl implements ProspectRepository {
  final ProspectsLocalDataSource localDataSource;

  ProspectsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Prospect>> getProspects() async {
    return await localDataSource.getProspects();
  }

  @override
  Future<void> addProspect(Prospect prospect) async {
    await localDataSource.addProspect(prospect);
  }

  @override
  Future<void> updateProspect(Prospect prospect) async {
    await localDataSource.updateProspect(prospect);
  }

  @override
  Future<void> deleteProspect(String id) async {
    await localDataSource.deleteProspect(id);
  }
}
