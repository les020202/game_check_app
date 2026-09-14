import 'package:uuid/uuid.dart';
import 'quest_category.dart';

class CharacterQuestItem {
  final String id;
  final String gameId;
  final String characterId; 
  final QuestCategory category; 
  final String name; 
  final DateTime? dueDate; 
  final String? memo;   

  CharacterQuestItem({
    String? id,
    required this.gameId,
    required this.characterId,
    required this.category,
    required this.name,
    this.dueDate,
    this.memo,
  }) : id = id ?? const Uuid().v4();
}