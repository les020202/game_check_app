import 'package:flutter/material.dart';

import '../models/day_quest_status.dart';
import '../models/weekday.dart';
import 'status_indicator.dart';

class WeekDayCell extends StatelessWidget {
  const WeekDayCell({super.key,required this.date,required this.status});
  final DateTime date;
  final DayQuestStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
  children: [
    Text(Weekday.fromValue(date.weekday).label),      // 목/금/토/일/월/화/수
    SizedBox(height: 4),
    Text('${date.day}'),
    StatusIndicator(status: status,),
  ],
);
  }
}