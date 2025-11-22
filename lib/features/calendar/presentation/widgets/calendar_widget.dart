import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/event_model.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Map<DateTime, List<EventModel>> events;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay)? onPageChanged;

  const CalendarWidget({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.events,
    required this.onDaySelected,
    this.onPageChanged,
  }) : super(key: key);

  List<EventModel> _getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<EventModel>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      eventLoader: _getEventsForDay,
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay, focusedDay);
      },
      onPageChanged: (focusedDay) {
        if (onPageChanged != null) {
          onPageChanged!(focusedDay);
        }
      },
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
