// models/company_model.dart
import "state_model.dart";

class CompanyModel {
  final String id;
  final String name;
  final StateModel state;

  CompanyModel({required this.id, required this.name, required this.state});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'].toString(),
      name: json['name'],
      state: StateModel.fromJson(json['state']),
    );
  }
}

