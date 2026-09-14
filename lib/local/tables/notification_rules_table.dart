import 'package:drift/drift.dart';

import '../converters/string_list_converter.dart';

class NotificationRules extends Table {
  TextColumn get id => text()();
  TextColumn get gameIds => text().map(const StringListConverter())();
  IntColumn get notifyHour => integer()();
  IntColumn get notifyMinute => integer()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}