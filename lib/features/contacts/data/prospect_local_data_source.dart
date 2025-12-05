// lib/features/prospects/data/prospects_local_data_source.dart

import '../models/prospect.dart';

class ProspectsLocalDataSource {
  // Mock data for now - replace with actual database later
  static final List<Prospect> _mockProspects = [
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

  Future<List<Prospect>> getProspects() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_mockProspects);
  }

  Future<void> addProspect(Prospect prospect) async {
    await Future.delayed(Duration(milliseconds: 100));
    _mockProspects.add(prospect);
  }

  Future<void> updateProspect(Prospect prospect) async {
    await Future.delayed(Duration(milliseconds: 100));
    final index = _mockProspects.indexWhere((p) => p.id == prospect.id);
    if (index != -1) {
      _mockProspects[index] = prospect;
    }
  }

  Future<void> deleteProspect(String id) async {
    await Future.delayed(Duration(milliseconds: 100));
    _mockProspects.removeWhere((p) => p.id == id);
  }
}
