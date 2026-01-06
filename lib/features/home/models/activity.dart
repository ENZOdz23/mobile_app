// lib/features/home/models/activity.dart

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    DateTime timestamp;
    if (json['timestamp'] != null) {
      try {
        // Parse timestamp - handle both UTC and local time
        final timestampStr = json['timestamp'] as String;
        timestamp = DateTime.parse(timestampStr);
        // If timestamp is in UTC (ends with Z), convert to local time
        if (timestampStr.endsWith('Z') || timestampStr.contains('+00:00')) {
          timestamp = timestamp.toLocal();
        }
      } catch (e) {
        // If parsing fails, use current time
        timestamp = DateTime.now();
      }
    } else {
      timestamp = DateTime.now();
    }

    return Activity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: timestamp,
      type: _typeFromString(json['type'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'type': _typeToString(type),
      };

  static ActivityType _typeFromString(String? type) {
    switch (type) {
      case 'prospect_added':
        return ActivityType.prospectAdded;
      case 'client_added':
        return ActivityType.clientAdded;
      case 'status_updated':
        return ActivityType.statusUpdated;
      case 'meeting_scheduled':
        return ActivityType.meetingScheduled;
      default:
        return ActivityType.other;
    }
  }

  static String _typeToString(ActivityType type) {
    switch (type) {
      case ActivityType.prospectAdded:
        return 'prospect_added';
      case ActivityType.clientAdded:
        return 'client_added';
      case ActivityType.statusUpdated:
        return 'status_updated';
      case ActivityType.meetingScheduled:
        return 'meeting_scheduled';
      case ActivityType.other:
        return 'other';
    }
  }
}

enum ActivityType {
  prospectAdded,
  clientAdded,
  statusUpdated,
  meetingScheduled,
  other,
}

