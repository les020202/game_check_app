import 'package:flutter/material.dart';

import '../models/day_quest_status.dart';
import '../models/weekday.dart';
import '../theme/app_colors.dart';
import 'status_indicator.dart';

class WeekDayCell extends StatelessWidget {
  const WeekDayCell({
    super.key,
    required this.date,
    required this.status,
    this.isToday = false,
  });

  final DateTime date;
  final DayQuestStatus status;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? AppColors.bg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 4,
        children: [
          Text(
            Weekday.fromValue(date.weekday).label,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
          ),
          Text(
            '${date.day}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isToday ? colorScheme.primary : null,
            ),
          ),
          StatusIndicator(status: status),
        ],
      ),
    );
  }
}