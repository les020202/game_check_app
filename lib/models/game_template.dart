import 'game_type.dart';
import 'quest_category.dart';
import 'weekday.dart';

class DailyItemTemplate {
  final String name;

  DailyItemTemplate({required this.name});
}

class CharacterQuestItemTemplate {
  final QuestCategory category;
  final String name;
  final int? dueDateOffsetDays; // goal 전용, 프리셋 적용 시점 기준 마감일 오프셋(선택)
  final String? memo;           // goal 전용

  CharacterQuestItemTemplate({
    required this.category,
    required this.name,
    this.dueDateOffsetDays,
    this.memo,
  });
}

class CharacterTemplate {
  final List<CharacterQuestItemTemplate> weeklyItems;
  final List<CharacterQuestItemTemplate> monthlyItems;
  final List<CharacterQuestItemTemplate> goalItems;

  CharacterTemplate({
    required this.weeklyItems,
    required this.monthlyItems,
    required this.goalItems,
  });
}

class GameTemplate {
  final String gameName;
  final GameType gameType;
  final int gameResetHour;
  final int gameResetMinute;
  final Weekday weeklyResetWeekday;
  final List<DailyItemTemplate> dailyItems;
  final CharacterTemplate characterTemplate;

  GameTemplate({
    required this.gameName,
    required this.gameType,
    required this.gameResetHour,
    required this.gameResetMinute,
    required this.weeklyResetWeekday,
    required this.dailyItems,
    required this.characterTemplate,
  });
}