// lib/features/contacts/data/prospect_local_data_source.dart

import '../../../core/database/db_helper.dart';
import '../models/prospect.dart';

class ProspectsLocalDataSource {
  final DBHelper _dbHelper;
  static const String _tableName = 'prospects';

  ProspectsLocalDataSource({DBHelper? dbHelper}) 
      : _dbHelper = dbHelper ?? DBHelper();

  Future<List<Prospect>> getProspects() async {
    try {
      final maps = await _dbHelper.query(_tableName);
      return maps.map((map) => Prospect.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch prospects: $e');
    }
  }

  Future<Prospect?> getProspectById(String id) async {
    try {
      final map = await _dbHelper.queryById(_tableName, id);
      return map != null ? Prospect.fromMap(map) : null;
    } catch (e) {
      throw Exception('Failed to fetch prospect: $e');
    }
  }

  Future<void> addProspect(Prospect prospect) async {
    try {
      await _dbHelper.insert(_tableName, prospect.toMap());
    } catch (e) {
      throw Exception('Failed to add prospect: $e');
    }
  }

  Future<void> updateProspect(Prospect prospect) async {
    try {
      print('[ProspectsLocalDataSource] Updating prospect: ${prospect.id} - ${prospect.entreprise}');
      final result = await _dbHelper.update(_tableName, prospect.toMap(), prospect.id);
      print('[ProspectsLocalDataSource] Update result: $result');
      if (result == 0) {
        throw Exception('Prospect not found');
      }
    } catch (e) {
      print('[ProspectsLocalDataSource] Error updating prospect: $e');
      throw Exception('Failed to update prospect: $e');
    }
  }

  Future<void> deleteProspect(String id) async {
    try {
      final result = await _dbHelper.delete(_tableName, id);
      if (result == 0) {
        throw Exception('Prospect not found');
      }
    } catch (e) {
      throw Exception('Failed to delete prospect: $e');
    }
  }

  // Optional: Initialize with seed data
  Future<void> seedInitialData() async {
    final existingProspects = await getProspects();
    if (existingProspects.isEmpty) {
      final initialProspects = [
        Prospect(
          id: 'p1',
          entreprise: 'Boehm, Gleichner and Schmidt',
          adresse: '275405 Bartow Meadows',
          wilaya: 'Alger',
          commune: 'Bab Ezzouar',
          phoneNumber: '+213 555 123 456',
          email: 'contact@boehm-schmidt.dz',
          categorie: 'PME',
          formeLegale: 'SARL',
          secteur: 'Services',
          sousSecteur: 'Consulting',
          nif: '001234567890123',
          registreCommerce: 'RC-ALG-2023-12345',
          status: ProspectStatus.interested,
        ),
        Prospect(
          id: 'p2',
          entreprise: 'Tech Solutions Algeria',
          adresse: 'Zone Industrielle, Rouiba',
          wilaya: 'Alger',
          commune: 'Rouiba',
          phoneNumber: '+213 555 789 012',
          email: 'info@techsolutions.dz',
          categorie: 'Grande Entreprise',
          formeLegale: 'SPA',
          secteur: 'Technologie',
          sousSecteur: 'Développement',
          nif: '001234567890124',
          registreCommerce: 'RC-ALG-2023-67890',
          status: ProspectStatus.prospect,
        ),
        Prospect(
          id: 'p3',
          entreprise: 'Algeria Commerce Group',
          adresse: 'Rue Didouche Mourad, Alger Centre',
          wilaya: 'Alger',
          commune: 'Alger Centre',
          phoneNumber: '+213 555 345 678',
          email: 'contact@acg.dz',
          categorie: 'PME',
          formeLegale: 'EURL',
          secteur: 'Commerce',
          sousSecteur: 'Import-Export',
          nif: '001234567890125',
          registreCommerce: 'RC-ALG-2023-11111',
          status: ProspectStatus.notCompleted,
        ),
      ];

      for (final prospect in initialProspects) {
        await addProspect(prospect);
      }
    }
  }
}