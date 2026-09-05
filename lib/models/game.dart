enum GameType { rpg, mobile }

class Game {
  final String id;
  final String? userId; // 로그인 후에만 값 존재
  final String name;
  final GameType gameType;
  final int dailyResetHour;   // 0~23
  final int dailyResetMinute; // 0~59
  final int weeklyResetWeekday; // 1(월)~7(일)
  final DateTime createdAt;

  Game({
    required this.id,
    this.userId,
    required this.name,
    required this.gameType,
    required this.dailyResetHour,
    required this.dailyResetMinute,
    required this.weeklyResetWeekday,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}