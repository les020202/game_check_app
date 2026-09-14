import 'package:uuid/uuid.dart';

import 'weekday.dart';
import 'game_type.dart';

class Game {
  final String id;
  final String? userId; // 로그인 후에만 값 존재
  final String name;
  final GameType gameType;
  final int gameResetHour;   // 0~23
  final int gameResetMinute; // 0~59
  final Weekday weeklyResetWeekday; // 1(월)~7(일)
  final DateTime createdAt;

  Game({
    String? id,
    this.userId,
    required this.name,
    required this.gameType,
    required this.gameResetHour,
    required this.gameResetMinute,
    required this.weeklyResetWeekday,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(), createdAt = createdAt ?? DateTime.now();
}