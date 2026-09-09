import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../models/day_quest_status.dart';

class StatusIndicator extends StatelessWidget {
  StatusIndicator({
    super.key,
    required this.status,
  });
  final DayQuestStatus status;
  @override
  Widget build(BuildContext context) {
    if (status == DayQuestStatus.upcoming) {
      return DottedBorder(
        options: CircularDottedBorderOptions(
          color: Colors.grey,
          strokeWidth: 1,
          dashPattern: const [3, 2],
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      );
    }

    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgroundColor(status),
        border: status == DayQuestStatus.partial
            ? Border.all(color: Colors.blue, width: 1)
            : null,
      ),
    );
  }

  Color _backgroundColor(DayQuestStatus status) {
    switch (status) {
      case DayQuestStatus.complete:
        return Colors.blue;
      case DayQuestStatus.partial:
        return Colors.grey.shade300;
      case DayQuestStatus.incomplete:
        return Colors.grey;
      case DayQuestStatus.upcoming:
        return Colors.white;
    }
  }
}
