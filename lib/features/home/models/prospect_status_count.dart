// lib/features/home/models/prospect_status_count.dart

class ProspectStatusCount {
  final int interested;
  final int notInterested;
  final int notAnswered;

  ProspectStatusCount({
    required this.interested,
    required this.notInterested,
    required this.notAnswered,
  });

  int get total => interested + notInterested + notAnswered;

  factory ProspectStatusCount.fromJson(Map<String, dynamic> json) {
    return ProspectStatusCount(
      interested: json['interested'] as int? ?? 0,
      notInterested: json['not_interested'] as int? ?? 0,
      notAnswered: json['not_answered'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'interested': interested,
        'not_interested': notInterested,
        'not_answered': notAnswered,
      };

  ProspectStatusCount copyWith({
    int? interested,
    int? notInterested,
    int? notAnswered,
  }) {
    return ProspectStatusCount(
      interested: interested ?? this.interested,
      notInterested: notInterested ?? this.notInterested,
      notAnswered: notAnswered ?? this.notAnswered,
    );
  }
}

