import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/game_type.dart';
import '../models/quest_category.dart';
import '../models/weekday.dart';
import 'converters/string_list_converter.dart';
import 'tables/games_table.dart';
import 'tables/characters_table.dart';
import 'tables/daily_quest_items_table.dart';
import 'tables/character_quest_items_table.dart';
import 'tables/quest_logs_table.dart';
import 'tables/notification_rules_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Games,
    Characters,
    DailyQuestItems,
    CharacterQuestItems,
    QuestLogs,
    NotificationRules,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.drop(questLogs);
        await m.createTable(questLogs);
      }
    },
  );

  Future<void> resetAllTables() async {
    await transaction(() async {
      await delete(questLogs).go();
      await delete(characterQuestItems).go();
      await delete(dailyQuestItems).go();
      await delete(characters).go();
      await delete(games).go();
      await delete(notificationRules).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'game_quest_checklist.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
