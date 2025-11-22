import '../models/event_model.dart';
import 'calendar_repository.dart';

/// Use case for retrieving events for a given month.
class GetEventsUseCase {
  final CalendarRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<EventModel>> execute(DateTime month) {
    return repository.getEventsForMonth(month);
  }
}
