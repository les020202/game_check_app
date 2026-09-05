import 'package:flutter/material.dart';

class QuestProgressBadge extends StatelessWidget {
  const QuestProgressBadge({
    super.key,
    required this.textTheme,
    required this.colorScheme,
  });

  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.blue.shade100,
      ),
      child: Text(
        '2/4 완료',
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary
        ),
      ),
    );
  }
}
