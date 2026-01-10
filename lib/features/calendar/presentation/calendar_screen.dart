import 'package:flutter/material.dart';
import '../domain/get_events_use_case.dart';
import '../domain/add_event_use_case.dart';
import '../data/calendar_repository_impl.dart';
import '../models/event_model.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/event_card.dart';
import 'widgets/floating_add_button.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarRepositoryImpl _repository;
  late final GetEventsUseCase _getEventsUseCase;
  late final AddEventUseCase _addEventUseCase;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<DateTime, List<EventModel>> _events = {};

  List<EventModel> get _selectedEvents => _events[_selectedDay] ?? [];

  @override
  void initState() {
    super.initState();
    _repository = CalendarRepositoryImpl();
    _getEventsUseCase = GetEventsUseCase(_repository);
    _addEventUseCase = AddEventUseCase(_repository);
    _loadEvents(_focusedDay);
  }

  void _loadEvents(DateTime month) async {
    final events = await _getEventsUseCase.execute(month);
    final Map<DateTime, List<EventModel>> groupedEvents = {};
    for (var event in events) {
      final key = DateTime(event.date.year, event.date.month, event.date.day);
      groupedEvents.putIfAbsent(key, () => []).add(event);
    }
    setState(() {
      _events = groupedEvents;
    });
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _loadEvents(focusedDay);
  }

  void _onAddEvent() async {
    // Example adding a dummy event to test
    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Nouvel événement',
      date: _selectedDay,
      timeRange: '12:00 - 13:00',
      color: Colors.purple,
    );

    await _addEventUseCase.execute(newEvent);
    _loadEvents(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendrier')),
      body: Column(
        children: [
          CalendarWidget(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            events: _events,
            onDaySelected: _onDaySelected,
            onPageChanged: _onPageChanged,
          ),
          SizedBox(height: 12),
          Expanded(
            child: _selectedEvents.isEmpty
                ? Center(child: Text("Aucun événement"))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: _selectedEvents[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingAddButton(
        onTap: _onAddEvent,
      ),
    );
  }
}
