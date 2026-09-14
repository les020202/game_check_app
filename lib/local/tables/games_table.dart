import 'package:drift/drift.dart';

import '../../models/game_type.dart';
import '../../models/weekday.dart';

class Games extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get gameType => intEnum<GameType>()();
  IntColumn get dailyResetHour => integer()();
  IntColumn get dailyResetMinute => integer()();
  IntColumn get weeklyResetWeekday => intEnum<Weekday>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}