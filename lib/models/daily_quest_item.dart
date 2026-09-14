import 'package:uuid/uuid.dart';

class DailyQuestItem {
  final String id;
  final String gameId;
  final String name;

  DailyQuestItem({
    String? id,
    required this.gameId,
    required this.name,
  }) : id = id ?? const Uuid().v4();
}