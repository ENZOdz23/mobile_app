// models/state_model.dart
class StateModel {
  final String id;
  final String label;

  StateModel({required this.id, required this.label});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(id: json['id'].toString(), label: json['label']);
  }
}
