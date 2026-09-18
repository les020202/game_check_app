import 'package:flutter/material.dart';

import '../models/character.dart';
import '../models/day_quest_status.dart';

class QuestProgressBadge extends StatelessWidget {
  QuestProgressBadge({
    super.key,
    required this.textTheme,
    required this.colorScheme,
    this.questStatus,
    this.characters,
    this.completedCount,
    this.allCount,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;
  Map<String, DayQuestStatus>? questStatus;
  List<Character>? characters;
  int? completedCount;
  int? allCount;

  @override
  Widget build(BuildContext context) {
    if (questStatus != null && questStatus!.isNotEmpty) {
      completedCount = questStatus!.values
          .where((status) => status == DayQuestStatus.complete)
          .length;
      allCount = questStatus!.length;
    }

    final String label;
    final Color color;
    final Color textColor;
    if (allCount == 0 || allCount==null) {
      label = '퀘스트 없음';
      color = Colors.grey.shade100;
      textColor=Colors.grey;
    } else if (completedCount == allCount) {
      label = allCount==1 ? '완료':'$completedCount/$allCount 완료';
      color = Colors.blue.shade100;
      textColor = colorScheme.primary;
    } else if (completedCount == 0) {
      label = '미완료';
      color = Colors.red.shade100;
      textColor = Colors.red;
    } else {
      label = '$completedCount/$allCount 완료';
      color = Colors.orange.shade100;
      textColor = Colors.orange;
    }
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: color
      ),
      child: Text(
        label,
        style: textTheme.bodyMedium?.copyWith(color: textColor),
      ),
    );
  }
}
