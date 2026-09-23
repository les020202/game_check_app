import 'game_type.dart';
import 'quest_category.dart';
import 'weekday.dart';

class DailyItemTemplate {
  final String name;

  DailyItemTemplate({required this.name});

  factory DailyItemTemplate.fromJson(Map<String, dynamic> json) {
    return DailyItemTemplate(name: json['name'] as String);
  }
}

class CharacterQuestItemTemplate {
  final QuestCategory category;
  final String name;
  final int? dueDateOffsetDays;
  final String? memo;

  CharacterQuestItemTemplate({
    required this.category,
    required this.name,
    this.dueDateOffsetDays,
    this.memo,
  });

  factory CharacterQuestItemTemplate.fromJson(Map<String, dynamic> json) {
    return CharacterQuestItemTemplate(
      category: QuestCategory.values.byName(json['category'] as String),
      name: json['name'] as String,
      dueDateOffsetDays: json['dueDateOffsetDays'] as int?,
      memo: json['memo'] as String?,
    );
  }
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

  factory CharacterTemplate.fromJson(Map<String, dynamic> json) {
    List<CharacterQuestItemTemplate> parseList(String key) =>
        (json[key] as List<dynamic>? ?? [])
            .map((e) => CharacterQuestItemTemplate.fromJson(e as Map<String, dynamic>))
            .toList();

    return CharacterTemplate(
      weeklyItems: parseList('weeklyItems'),
      monthlyItems: parseList('monthlyItems'),
      goalItems: parseList('goalItems'),
    );
  }
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

  factory GameTemplate.fromJson(Map<String, dynamic> json) {
    return GameTemplate(
      gameName: json['gameName'] as String,
      gameType: GameType.values.byName(json['gameType'] as String),
      gameResetHour: json['gameResetHour'] as int,
      gameResetMinute: json['gameResetMinute'] as int,
      weeklyResetWeekday: Weekday.values.byName(json['weeklyResetWeekday'] as String),
      dailyItems: (json['dailyItems'] as List<dynamic>? ?? [])
          .map((e) => DailyItemTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      characterTemplate: CharacterTemplate.fromJson(
        json['characterTemplate'] as Map<String, dynamic>,
      ),
    );
  }
}