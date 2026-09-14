import 'package:uuid/uuid.dart';

class QuestLog {
  final String id;
  final String questItemId; 
  final String? characterId; 
  final DateTime periodDate;
  final bool isCompleted;

  QuestLog({
    String? id,
    required this.questItemId,
    this.characterId,
    required this.periodDate,
    required this.isCompleted,
  }) : id = id ?? const Uuid().v4();
}