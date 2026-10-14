import 'package:flutter/material.dart';

import '../models/character.dart';
import '../models/day_quest_status.dart';
import '../theme/app_colors.dart';

class QuestProgressBadge extends StatelessWidget {
  const QuestProgressBadge({
    super.key,
    this.textTheme, // 기존 호출 호환용 (사용 안 함)
    this.colorScheme, // 기존 호출 호환용 (사용 안 함)
    this.questStatus,
    this.characters,
    this.completedCount,
    this.allCount,
  });

  final TextTheme? textTheme;
  final ColorScheme? colorScheme;
  final Map<String, DayQuestStatus>? questStatus;
  final List<Character>? characters;
  final int? completedCount;
  final int? allCount;

  @override
  Widget build(BuildContext context) {
    var done = completedCount;
    var total = allCount;
    if (questStatus != null && questStatus!.isNotEmpty) {
      done = questStatus!.values
          .where((s) => s == DayQuestStatus.complete)
          .length;
      total = questStatus!.length;
    }

    final String label;
    final Color fg;
    final Color bg;
    if (total == null || total == 0) {
      label = '퀘스트 없음';
      fg = AppColors.none;
      bg = AppColors.noneBg;
    } else if (done == total) {
      label = total == 1 ? '완료' : '$done/$total 완료';
      fg = AppColors.complete;
      bg = AppColors.completeBg;
    } else if ((done ?? 0) == 0) {
      label = '미완료';
      fg = AppColors.incomplete;
      bg = AppColors.incompleteBg;
    } else {
      label = '$done/$total 완료';
      fg = AppColors.partial;
      bg = AppColors.partialBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}