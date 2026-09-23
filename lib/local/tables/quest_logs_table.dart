import 'package:drift/drift.dart';

import 'characters_table.dart';

@DataClassName('QuestLogEntity')
class QuestLogs extends Table {
  TextColumn get id => text()();
  TextColumn get questItemId => text()();
  TextColumn get characterId => text().nullable().references(Characters, #id)();
  DateTimeColumn get periodDate => dateTime()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
  
  // questItemId + characterId 조합이 유니크하도록 제약 추가
  @override
  List<String> get customConstraints => [
    'UNIQUE(quest_item_id, character_id)',
  ];
}