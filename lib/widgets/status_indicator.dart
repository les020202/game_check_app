import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../models/day_quest_status.dart';
import '../theme/app_colors.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status, this.size = 24});

  final DayQuestStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (status) {
      case DayQuestStatus.upcoming:
        return DottedBorder(
          options: CircularDottedBorderOptions(
            color: AppColors.none,
            strokeWidth: 1,
            dashPattern: const [3, 2],
            padding: EdgeInsets.zero,
          ),
          child: SizedBox(width: size, height: size),
        );
      case DayQuestStatus.complete:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          child: Icon(Icons.check, size: size * 0.65, color: Colors.white),
        );
      case DayQuestStatus.partial:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.completeBg,
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 1.5),
          ),
        );
      case DayQuestStatus.incomplete:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xffD5D9E0),
            shape: BoxShape.circle,
          ),
        );
    }
  }
}