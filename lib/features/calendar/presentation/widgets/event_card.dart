import 'package:flutter/material.dart';
import '../../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: event.color, radius: 12),
        title: Text(event.title),
        subtitle: Text(event.timeRange),
        trailing: Icon(Icons.calendar_today, size: 18),
      ),
    );
  }
}
