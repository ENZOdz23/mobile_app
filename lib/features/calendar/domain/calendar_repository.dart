import '../models/event_model.dart';

/// Abstract contract for event-related data operations.
abstract class CalendarRepository {
  /// Retrieve all events for a given month.
  Future<List<EventModel>> getEventsForMonth(DateTime month);

  /// Add a new event.
  Future<void> addEvent(EventModel event);
}
