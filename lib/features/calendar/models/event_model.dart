/// Data model representing a calendar event.
import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final String timeRange;
  final Color color;
  final bool isAllDay;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.timeRange,
    required this.color,
    this.isAllDay = false,
  });

  // Optionally, add fromJson/toJson for API integration
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      timeRange: json['timeRange'],
      color: Color(json['color']), // Save color as int in json if needed
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'timeRange': timeRange,
      'color': color.value,
      'isAllDay': isAllDay,
    };
  }
}
