import '../../models/game.dart';

DateTime todayPeriodFor(Game game) {
  final now = DateTime.now();
  final resetTime = DateTime(
    now.year,
    now.month,
    now.day,
    game.gameResetHour,
    game.gameResetMinute,
  );
  if (now.isBefore(resetTime)) {
    final yesterday = now.subtract(const Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day);
  }
  return DateTime(now.year, now.month, now.day);
}

DateTime weekStartFor(Game game) {
  final adjustedToday = todayPeriodFor(game);
  final resetWeekday = game.weeklyResetWeekday.value;
  final diff = (adjustedToday.weekday - resetWeekday + 7) % 7;
  return adjustedToday.subtract(Duration(days: diff));
}