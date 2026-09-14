import 'package:drift/drift.dart';

import 'characters_table.dart';

class QuestLogs extends Table {
  TextColumn get id => text()();
  TextColumn get questItemId => text()();
  TextColumn get characterId => text().nullable().references(Characters, #id)();
  DateTimeColumn get periodDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}