import 'package:drift/drift.dart';

import '../../models/quest_category.dart';
import 'characters_table.dart';
import 'games_table.dart';

@DataClassName('CharacterQuestItemEntity')
class CharacterQuestItems extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get characterId => text().references(Characters, #id)();
  IntColumn get category => intEnum<QuestCategory>()();
  TextColumn get name => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get memo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}