import 'package:drift/drift.dart';

import 'games_table.dart';

class DailyQuestItems extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id)();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}