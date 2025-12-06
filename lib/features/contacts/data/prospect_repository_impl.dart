// lib/features/contacts/data/prospect_repository_impl.dart

import '../domain/prospect_repository.dart';
import '../models/prospect.dart';
import 'prospect_local_data_source.dart';

class ProspectRepositoryImpl implements ProspectRepository {
  final ProspectsLocalDataSource localDataSource;

  ProspectRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Prospect>> getProspects() async {
    try {
      return await localDataSource.getProspects();
    } catch (e) {
      throw Exception('Repository: Failed to get prospects - $e');
    }
  }

  @override
  Future<void> addProspect(Prospect prospect) async {
    try {
      await localDataSource.addProspect(prospect);
    } catch (e) {
      throw Exception('Repository: Failed to add prospect - $e');
    }
  }

  @override
  Future<void> updateProspect(Prospect prospect) async {
    try {
      await localDataSource.updateProspect(prospect);
    } catch (e) {
      throw Exception('Repository: Failed to update prospect - $e');
    }
  }

  @override
  Future<void> deleteProspect(String id) async {
    try {
      await localDataSource.deleteProspect(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete prospect - $e');
    }
  }
}