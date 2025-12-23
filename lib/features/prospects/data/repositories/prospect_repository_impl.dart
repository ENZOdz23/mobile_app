// lib/features/prospects/data/repositories/prospect_repository_impl.dart

import '../datasources/prospects_remote_data_source.dart';
import '../../../contacts/models/prospect.dart';
import '../../domain/repositories/prospect_repository.dart';

class ProspectRepositoryImpl implements ProspectRepository {
  final IProspectsRemoteDataSource remoteDataSource;

  ProspectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Prospect>> getProspects() async {
    try {
      return await remoteDataSource.getProspects();
    } catch (e) {
      throw Exception('Repository: Failed to get prospects - $e');
    }
  }

  @override
  Future<void> addProspect(Prospect prospect) async {
    try {
      await remoteDataSource.createProspect(prospect);
    } catch (e) {
      throw Exception('Repository: Failed to add prospect - $e');
    }
  }

  @override
  Future<void> updateProspect(Prospect prospect) async {
    try {
      await remoteDataSource.updateProspect(prospect);
    } catch (e) {
      throw Exception('Repository: Failed to update prospect - $e');
    }
  }

  @override
  Future<void> deleteProspect(String id) async {
    try {
      await remoteDataSource.deleteProspect(id);
    } catch (e) {
      throw Exception('Repository: Failed to delete prospect - $e');
    }
  }
}
