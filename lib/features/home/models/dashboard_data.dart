// lib/features/home/models/dashboard_data.dart

import 'activity.dart';
import 'prospect_status_count.dart';

class DashboardData {
  final int totalProspects;
  final int totalContacts;
  final ProspectStatusCount prospectStatusCount;
  final List<Activity> recentActivities;

  DashboardData({
    required this.totalProspects,
    required this.totalContacts,
    required this.prospectStatusCount,
    required this.recentActivities,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalProspects: json['total_prospects'] as int? ?? 0,
      totalContacts: json['total_contacts'] as int? ?? 0,
      prospectStatusCount: json['prospect_status_count'] != null
          ? ProspectStatusCount.fromJson(
              json['prospect_status_count'] as Map<String, dynamic>)
          : ProspectStatusCount(interested: 0, notInterested: 0, notAnswered: 0),
      recentActivities: json['recent_activities'] != null
          ? (json['recent_activities'] as List)
              .map((item) => Activity.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_prospects': totalProspects,
        'total_contacts': totalContacts,
        'prospect_status_count': prospectStatusCount.toJson(),
        'recent_activities':
            recentActivities.map((activity) => activity.toJson()).toList(),
      };

  DashboardData copyWith({
    int? totalProspects,
    int? totalContacts,
    ProspectStatusCount? prospectStatusCount,
    List<Activity>? recentActivities,
  }) {
    return DashboardData(
      totalProspects: totalProspects ?? this.totalProspects,
      totalContacts: totalContacts ?? this.totalContacts,
      prospectStatusCount: prospectStatusCount ?? this.prospectStatusCount,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

