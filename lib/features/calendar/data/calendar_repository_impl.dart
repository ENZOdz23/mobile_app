import 'package:flutter/material.dart';
import '../domain/calendar_repository.dart';
import '../models/event_model.dart';

/// Calendar data repository implementation (API placeholder).
class CalendarRepositoryImpl implements CalendarRepository {
  // TODO: Inject API client, data source, or database here

  CalendarRepositoryImpl();

  @override
  Future<List<EventModel>> getEventsForMonth(DateTime month) async {
    // TODO: Implement API call to fetch events for the month
    // Temporary: return mock data for testing
    return [
      EventModel(
        id: '1',
        title: 'MultiDay Event A',
        date: DateTime(month.year, month.month, 26),
        timeRange: '10:00 - 12:00',
        color: Color(0xFFFFA726),
      ),
      EventModel(
        id: '2',
        title: 'Allday Event B',
        date: DateTime(month.year, month.month, 24),
        timeRange: '14:30 - 17:00',
        color: Color(0xFFE040FB),
        isAllDay: true,
      ),
    ];
  }

  @override
  Future<void> addEvent(EventModel event) async {
    // TODO: Implement API call to add a new event
    // Temporary: do nothing (simulate network delay)
    await Future.delayed(Duration(milliseconds: 500));
  }
}
