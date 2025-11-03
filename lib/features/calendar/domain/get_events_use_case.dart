import '../models/event_model.dart';
import 'calendar_repository.dart';

class AddEventUseCase {
  final CalendarRepository repository;

  AddEventUseCase(this.repository);

  Future<void> execute(EventModel event) {
    return repository.addEvent(event);
  }
}
