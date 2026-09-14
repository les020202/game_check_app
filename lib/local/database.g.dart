// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameType, int> gameType =
      GeneratedColumn<int>(
        'game_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<GameType>($GamesTable.$convertergameType);
  static const VerificationMeta _dailyResetHourMeta = const VerificationMeta(
    'dailyResetHour',
  );
  @override
  late final GeneratedColumn<int> dailyResetHour = GeneratedColumn<int>(
    'daily_reset_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyResetMinuteMeta = const VerificationMeta(
    'dailyResetMinute',
  );
  @override
  late final GeneratedColumn<int> dailyResetMinute = GeneratedColumn<int>(
    'daily_reset_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Weekday, int> weeklyResetWeekday =
      GeneratedColumn<int>(
        'weekly_reset_weekday',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Weekday>($GamesTable.$converterweeklyResetWeekday);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gameType,
    dailyResetHour,
    dailyResetMinute,
    weeklyResetWeekday,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('daily_reset_hour')) {
      context.handle(
        _dailyResetHourMeta,
        dailyResetHour.isAcceptableOrUnknown(
          data['daily_reset_hour']!,
          _dailyResetHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyResetHourMeta);
    }
    if (data.containsKey('daily_reset_minute')) {
      context.handle(
        _dailyResetMinuteMeta,
        dailyResetMinute.isAcceptableOrUnknown(
          data['daily_reset_minute']!,
          _dailyResetMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyResetMinuteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gameType: $GamesTable.$convertergameType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}game_type'],
        )!,
      ),
      dailyResetHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reset_hour'],
      )!,
      dailyResetMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_reset_minute'],
      )!,
      weeklyResetWeekday: $GamesTable.$converterweeklyResetWeekday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}weekly_reset_weekday'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameType, int, int> $convertergameType =
      const EnumIndexConverter<GameType>(GameType.values);
  static JsonTypeConverter2<Weekday, int, int> $converterweeklyResetWeekday =
      const EnumIndexConverter<Weekday>(Weekday.values);
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final String name;
  final GameType gameType;
  final int dailyResetHour;
  final int dailyResetMinute;
  final Weekday weeklyResetWeekday;
  final DateTime createdAt;
  const Game({
    required this.id,
    required this.name,
    required this.gameType,
    required this.dailyResetHour,
    required this.dailyResetMinute,
    required this.weeklyResetWeekday,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['game_type'] = Variable<int>(
        $GamesTable.$convertergameType.toSql(gameType),
      );
    }
    map['daily_reset_hour'] = Variable<int>(dailyResetHour);
    map['daily_reset_minute'] = Variable<int>(dailyResetMinute);
    {
      map['weekly_reset_weekday'] = Variable<int>(
        $GamesTable.$converterweeklyResetWeekday.toSql(weeklyResetWeekday),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      name: Value(name),
      gameType: Value(gameType),
      dailyResetHour: Value(dailyResetHour),
      dailyResetMinute: Value(dailyResetMinute),
      weeklyResetWeekday: Value(weeklyResetWeekday),
      createdAt: Value(createdAt),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gameType: $GamesTable.$convertergameType.fromJson(
        serializer.fromJson<int>(json['gameType']),
      ),
      dailyResetHour: serializer.fromJson<int>(json['dailyResetHour']),
      dailyResetMinute: serializer.fromJson<int>(json['dailyResetMinute']),
      weeklyResetWeekday: $GamesTable.$converterweeklyResetWeekday.fromJson(
        serializer.fromJson<int>(json['weeklyResetWeekday']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gameType': serializer.toJson<int>(
        $GamesTable.$convertergameType.toJson(gameType),
      ),
      'dailyResetHour': serializer.toJson<int>(dailyResetHour),
      'dailyResetMinute': serializer.toJson<int>(dailyResetMinute),
      'weeklyResetWeekday': serializer.toJson<int>(
        $GamesTable.$converterweeklyResetWeekday.toJson(weeklyResetWeekday),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Game copyWith({
    String? id,
    String? name,
    GameType? gameType,
    int? dailyResetHour,
    int? dailyResetMinute,
    Weekday? weeklyResetWeekday,
    DateTime? createdAt,
  }) => Game(
    id: id ?? this.id,
    name: name ?? this.name,
    gameType: gameType ?? this.gameType,
    dailyResetHour: dailyResetHour ?? this.dailyResetHour,
    dailyResetMinute: dailyResetMinute ?? this.dailyResetMinute,
    weeklyResetWeekday: weeklyResetWeekday ?? this.weeklyResetWeekday,
    createdAt: createdAt ?? this.createdAt,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      dailyResetHour: data.dailyResetHour.present
          ? data.dailyResetHour.value
          : this.dailyResetHour,
      dailyResetMinute: data.dailyResetMinute.present
          ? data.dailyResetMinute.value
          : this.dailyResetMinute,
      weeklyResetWeekday: data.weeklyResetWeekday.present
          ? data.weeklyResetWeekday.value
          : this.weeklyResetWeekday,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gameType: $gameType, ')
          ..write('dailyResetHour: $dailyResetHour, ')
          ..write('dailyResetMinute: $dailyResetMinute, ')
          ..write('weeklyResetWeekday: $weeklyResetWeekday, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gameType,
    dailyResetHour,
    dailyResetMinute,
    weeklyResetWeekday,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.name == this.name &&
          other.gameType == this.gameType &&
          other.dailyResetHour == this.dailyResetHour &&
          other.dailyResetMinute == this.dailyResetMinute &&
          other.weeklyResetWeekday == this.weeklyResetWeekday &&
          other.createdAt == this.createdAt);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<String> name;
  final Value<GameType> gameType;
  final Value<int> dailyResetHour;
  final Value<int> dailyResetMinute;
  final Value<Weekday> weeklyResetWeekday;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gameType = const Value.absent(),
    this.dailyResetHour = const Value.absent(),
    this.dailyResetMinute = const Value.absent(),
    this.weeklyResetWeekday = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required String name,
    required GameType gameType,
    required int dailyResetHour,
    required int dailyResetMinute,
    required Weekday weeklyResetWeekday,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       gameType = Value(gameType),
       dailyResetHour = Value(dailyResetHour),
       dailyResetMinute = Value(dailyResetMinute),
       weeklyResetWeekday = Value(weeklyResetWeekday);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? gameType,
    Expression<int>? dailyResetHour,
    Expression<int>? dailyResetMinute,
    Expression<int>? weeklyResetWeekday,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gameType != null) 'game_type': gameType,
      if (dailyResetHour != null) 'daily_reset_hour': dailyResetHour,
      if (dailyResetMinute != null) 'daily_reset_minute': dailyResetMinute,
      if (weeklyResetWeekday != null)
        'weekly_reset_weekday': weeklyResetWeekday,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<GameType>? gameType,
    Value<int>? dailyResetHour,
    Value<int>? dailyResetMinute,
    Value<Weekday>? weeklyResetWeekday,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gameType: gameType ?? this.gameType,
      dailyResetHour: dailyResetHour ?? this.dailyResetHour,
      dailyResetMinute: dailyResetMinute ?? this.dailyResetMinute,
      weeklyResetWeekday: weeklyResetWeekday ?? this.weeklyResetWeekday,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gameType.present) {
      map['game_type'] = Variable<int>(
        $GamesTable.$convertergameType.toSql(gameType.value),
      );
    }
    if (dailyResetHour.present) {
      map['daily_reset_hour'] = Variable<int>(dailyResetHour.value);
    }
    if (dailyResetMinute.present) {
      map['daily_reset_minute'] = Variable<int>(dailyResetMinute.value);
    }
    if (weeklyResetWeekday.present) {
      map['weekly_reset_weekday'] = Variable<int>(
        $GamesTable.$converterweeklyResetWeekday.toSql(
          weeklyResetWeekday.value,
        ),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gameType: $gameType, ')
          ..write('dailyResetHour: $dailyResetHour, ')
          ..write('dailyResetMinute: $dailyResetMinute, ')
          ..write('weeklyResetWeekday: $weeklyResetWeekday, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, gameId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final String id;
  final String gameId;
  final String name;
  const Character({required this.id, required this.gameId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['name'] = Variable<String>(name);
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      gameId: Value(gameId),
      name: Value(name),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'name': serializer.toJson<String>(name),
    };
  }

  Character copyWith({String? id, String? gameId, String? name}) => Character(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    name: name ?? this.name,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.name == this.name);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> name;
  final Value<int> rowid;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    required String id,
    required String gameId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       name = Value(name);
  static Insertable<Character> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestItemsTable extends DailyQuestItems
    with TableInfo<$DailyQuestItemsTable, DailyQuestItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, gameId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quest_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuestItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyQuestItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $DailyQuestItemsTable createAlias(String alias) {
    return $DailyQuestItemsTable(attachedDatabase, alias);
  }
}

class DailyQuestItem extends DataClass implements Insertable<DailyQuestItem> {
  final String id;
  final String gameId;
  final String name;
  const DailyQuestItem({
    required this.id,
    required this.gameId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['name'] = Variable<String>(name);
    return map;
  }

  DailyQuestItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestItemsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      name: Value(name),
    );
  }

  factory DailyQuestItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestItem(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'name': serializer.toJson<String>(name),
    };
  }

  DailyQuestItem copyWith({String? id, String? gameId, String? name}) =>
      DailyQuestItem(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        name: name ?? this.name,
      );
  DailyQuestItem copyWithCompanion(DailyQuestItemsCompanion data) {
    return DailyQuestItem(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestItem(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, gameId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestItem &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.name == this.name);
}

class DailyQuestItemsCompanion extends UpdateCompanion<DailyQuestItem> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> name;
  final Value<int> rowid;
  const DailyQuestItemsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestItemsCompanion.insert({
    required String id,
    required String gameId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       name = Value(name);
  static Insertable<DailyQuestItem> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return DailyQuestItemsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestItemsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterQuestItemsTable extends CharacterQuestItems
    with TableInfo<$CharacterQuestItemsTable, CharacterQuestItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterQuestItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id)',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuestCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<QuestCategory>(
        $CharacterQuestItemsTable.$convertercategory,
      );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameId,
    characterId,
    category,
    name,
    dueDate,
    memo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_quest_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterQuestItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharacterQuestItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterQuestItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      category: $CharacterQuestItemsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
    );
  }

  @override
  $CharacterQuestItemsTable createAlias(String alias) {
    return $CharacterQuestItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuestCategory, int, int> $convertercategory =
      const EnumIndexConverter<QuestCategory>(QuestCategory.values);
}

class CharacterQuestItem extends DataClass
    implements Insertable<CharacterQuestItem> {
  final String id;
  final String gameId;
  final String characterId;
  final QuestCategory category;
  final String name;
  final DateTime? dueDate;
  final String? memo;
  const CharacterQuestItem({
    required this.id,
    required this.gameId,
    required this.characterId,
    required this.category,
    required this.name,
    this.dueDate,
    this.memo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['game_id'] = Variable<String>(gameId);
    map['character_id'] = Variable<String>(characterId);
    {
      map['category'] = Variable<int>(
        $CharacterQuestItemsTable.$convertercategory.toSql(category),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  CharacterQuestItemsCompanion toCompanion(bool nullToAbsent) {
    return CharacterQuestItemsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      characterId: Value(characterId),
      category: Value(category),
      name: Value(name),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory CharacterQuestItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterQuestItem(
      id: serializer.fromJson<String>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      characterId: serializer.fromJson<String>(json['characterId']),
      category: $CharacterQuestItemsTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      name: serializer.fromJson<String>(json['name']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameId': serializer.toJson<String>(gameId),
      'characterId': serializer.toJson<String>(characterId),
      'category': serializer.toJson<int>(
        $CharacterQuestItemsTable.$convertercategory.toJson(category),
      ),
      'name': serializer.toJson<String>(name),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  CharacterQuestItem copyWith({
    String? id,
    String? gameId,
    String? characterId,
    QuestCategory? category,
    String? name,
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> memo = const Value.absent(),
  }) => CharacterQuestItem(
    id: id ?? this.id,
    gameId: gameId ?? this.gameId,
    characterId: characterId ?? this.characterId,
    category: category ?? this.category,
    name: name ?? this.name,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    memo: memo.present ? memo.value : this.memo,
  );
  CharacterQuestItem copyWithCompanion(CharacterQuestItemsCompanion data) {
    return CharacterQuestItem(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      category: data.category.present ? data.category.value : this.category,
      name: data.name.present ? data.name.value : this.name,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterQuestItem(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('characterId: $characterId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('dueDate: $dueDate, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameId, characterId, category, name, dueDate, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterQuestItem &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.characterId == this.characterId &&
          other.category == this.category &&
          other.name == this.name &&
          other.dueDate == this.dueDate &&
          other.memo == this.memo);
}

class CharacterQuestItemsCompanion extends UpdateCompanion<CharacterQuestItem> {
  final Value<String> id;
  final Value<String> gameId;
  final Value<String> characterId;
  final Value<QuestCategory> category;
  final Value<String> name;
  final Value<DateTime?> dueDate;
  final Value<String?> memo;
  final Value<int> rowid;
  const CharacterQuestItemsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.category = const Value.absent(),
    this.name = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterQuestItemsCompanion.insert({
    required String id,
    required String gameId,
    required String characterId,
    required QuestCategory category,
    required String name,
    this.dueDate = const Value.absent(),
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameId = Value(gameId),
       characterId = Value(characterId),
       category = Value(category),
       name = Value(name);
  static Insertable<CharacterQuestItem> custom({
    Expression<String>? id,
    Expression<String>? gameId,
    Expression<String>? characterId,
    Expression<int>? category,
    Expression<String>? name,
    Expression<DateTime>? dueDate,
    Expression<String>? memo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (characterId != null) 'character_id': characterId,
      if (category != null) 'category': category,
      if (name != null) 'name': name,
      if (dueDate != null) 'due_date': dueDate,
      if (memo != null) 'memo': memo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterQuestItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? gameId,
    Value<String>? characterId,
    Value<QuestCategory>? category,
    Value<String>? name,
    Value<DateTime?>? dueDate,
    Value<String?>? memo,
    Value<int>? rowid,
  }) {
    return CharacterQuestItemsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      characterId: characterId ?? this.characterId,
      category: category ?? this.category,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      memo: memo ?? this.memo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $CharacterQuestItemsTable.$convertercategory.toSql(category.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterQuestItemsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('characterId: $characterId, ')
          ..write('category: $category, ')
          ..write('name: $name, ')
          ..write('dueDate: $dueDate, ')
          ..write('memo: $memo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestLogsTable extends QuestLogs
    with TableInfo<$QuestLogsTable, QuestLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questItemIdMeta = const VerificationMeta(
    'questItemId',
  );
  @override
  late final GeneratedColumn<String> questItemId = GeneratedColumn<String>(
    'quest_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id)',
    ),
  );
  static const VerificationMeta _periodDateMeta = const VerificationMeta(
    'periodDate',
  );
  @override
  late final GeneratedColumn<DateTime> periodDate = GeneratedColumn<DateTime>(
    'period_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questItemId,
    characterId,
    periodDate,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quest_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quest_item_id')) {
      context.handle(
        _questItemIdMeta,
        questItemId.isAcceptableOrUnknown(
          data['quest_item_id']!,
          _questItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questItemIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    }
    if (data.containsKey('period_date')) {
      context.handle(
        _periodDateMeta,
        periodDate.isAcceptableOrUnknown(data['period_date']!, _periodDateMeta),
      );
    } else if (isInserting) {
      context.missing(_periodDateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      questItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quest_item_id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      ),
      periodDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_date'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $QuestLogsTable createAlias(String alias) {
    return $QuestLogsTable(attachedDatabase, alias);
  }
}

class QuestLog extends DataClass implements Insertable<QuestLog> {
  final String id;
  final String questItemId;
  final String? characterId;
  final DateTime periodDate;
  final bool isCompleted;
  const QuestLog({
    required this.id,
    required this.questItemId,
    this.characterId,
    required this.periodDate,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quest_item_id'] = Variable<String>(questItemId);
    if (!nullToAbsent || characterId != null) {
      map['character_id'] = Variable<String>(characterId);
    }
    map['period_date'] = Variable<DateTime>(periodDate);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  QuestLogsCompanion toCompanion(bool nullToAbsent) {
    return QuestLogsCompanion(
      id: Value(id),
      questItemId: Value(questItemId),
      characterId: characterId == null && nullToAbsent
          ? const Value.absent()
          : Value(characterId),
      periodDate: Value(periodDate),
      isCompleted: Value(isCompleted),
    );
  }

  factory QuestLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestLog(
      id: serializer.fromJson<String>(json['id']),
      questItemId: serializer.fromJson<String>(json['questItemId']),
      characterId: serializer.fromJson<String?>(json['characterId']),
      periodDate: serializer.fromJson<DateTime>(json['periodDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questItemId': serializer.toJson<String>(questItemId),
      'characterId': serializer.toJson<String?>(characterId),
      'periodDate': serializer.toJson<DateTime>(periodDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  QuestLog copyWith({
    String? id,
    String? questItemId,
    Value<String?> characterId = const Value.absent(),
    DateTime? periodDate,
    bool? isCompleted,
  }) => QuestLog(
    id: id ?? this.id,
    questItemId: questItemId ?? this.questItemId,
    characterId: characterId.present ? characterId.value : this.characterId,
    periodDate: periodDate ?? this.periodDate,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  QuestLog copyWithCompanion(QuestLogsCompanion data) {
    return QuestLog(
      id: data.id.present ? data.id.value : this.id,
      questItemId: data.questItemId.present
          ? data.questItemId.value
          : this.questItemId,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      periodDate: data.periodDate.present
          ? data.periodDate.value
          : this.periodDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestLog(')
          ..write('id: $id, ')
          ..write('questItemId: $questItemId, ')
          ..write('characterId: $characterId, ')
          ..write('periodDate: $periodDate, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questItemId, characterId, periodDate, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestLog &&
          other.id == this.id &&
          other.questItemId == this.questItemId &&
          other.characterId == this.characterId &&
          other.periodDate == this.periodDate &&
          other.isCompleted == this.isCompleted);
}

class QuestLogsCompanion extends UpdateCompanion<QuestLog> {
  final Value<String> id;
  final Value<String> questItemId;
  final Value<String?> characterId;
  final Value<DateTime> periodDate;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const QuestLogsCompanion({
    this.id = const Value.absent(),
    this.questItemId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.periodDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestLogsCompanion.insert({
    required String id,
    required String questItemId,
    this.characterId = const Value.absent(),
    required DateTime periodDate,
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       questItemId = Value(questItemId),
       periodDate = Value(periodDate);
  static Insertable<QuestLog> custom({
    Expression<String>? id,
    Expression<String>? questItemId,
    Expression<String>? characterId,
    Expression<DateTime>? periodDate,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questItemId != null) 'quest_item_id': questItemId,
      if (characterId != null) 'character_id': characterId,
      if (periodDate != null) 'period_date': periodDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? questItemId,
    Value<String?>? characterId,
    Value<DateTime>? periodDate,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return QuestLogsCompanion(
      id: id ?? this.id,
      questItemId: questItemId ?? this.questItemId,
      characterId: characterId ?? this.characterId,
      periodDate: periodDate ?? this.periodDate,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questItemId.present) {
      map['quest_item_id'] = Variable<String>(questItemId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (periodDate.present) {
      map['period_date'] = Variable<DateTime>(periodDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestLogsCompanion(')
          ..write('id: $id, ')
          ..write('questItemId: $questItemId, ')
          ..write('characterId: $characterId, ')
          ..write('periodDate: $periodDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationRulesTable extends NotificationRules
    with TableInfo<$NotificationRulesTable, NotificationRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> gameIds =
      GeneratedColumn<String>(
        'game_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($NotificationRulesTable.$convertergameIds);
  static const VerificationMeta _notifyHourMeta = const VerificationMeta(
    'notifyHour',
  );
  @override
  late final GeneratedColumn<int> notifyHour = GeneratedColumn<int>(
    'notify_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notifyMinuteMeta = const VerificationMeta(
    'notifyMinute',
  );
  @override
  late final GeneratedColumn<int> notifyMinute = GeneratedColumn<int>(
    'notify_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gameIds,
    notifyHour,
    notifyMinute,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('notify_hour')) {
      context.handle(
        _notifyHourMeta,
        notifyHour.isAcceptableOrUnknown(data['notify_hour']!, _notifyHourMeta),
      );
    } else if (isInserting) {
      context.missing(_notifyHourMeta);
    }
    if (data.containsKey('notify_minute')) {
      context.handle(
        _notifyMinuteMeta,
        notifyMinute.isAcceptableOrUnknown(
          data['notify_minute']!,
          _notifyMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notifyMinuteMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gameIds: $NotificationRulesTable.$convertergameIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}game_ids'],
        )!,
      ),
      notifyHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_hour'],
      )!,
      notifyMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notify_minute'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $NotificationRulesTable createAlias(String alias) {
    return $NotificationRulesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertergameIds =
      const StringListConverter();
}

class NotificationRule extends DataClass
    implements Insertable<NotificationRule> {
  final String id;
  final List<String> gameIds;
  final int notifyHour;
  final int notifyMinute;
  final bool isEnabled;
  const NotificationRule({
    required this.id,
    required this.gameIds,
    required this.notifyHour,
    required this.notifyMinute,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['game_ids'] = Variable<String>(
        $NotificationRulesTable.$convertergameIds.toSql(gameIds),
      );
    }
    map['notify_hour'] = Variable<int>(notifyHour);
    map['notify_minute'] = Variable<int>(notifyMinute);
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  NotificationRulesCompanion toCompanion(bool nullToAbsent) {
    return NotificationRulesCompanion(
      id: Value(id),
      gameIds: Value(gameIds),
      notifyHour: Value(notifyHour),
      notifyMinute: Value(notifyMinute),
      isEnabled: Value(isEnabled),
    );
  }

  factory NotificationRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRule(
      id: serializer.fromJson<String>(json['id']),
      gameIds: serializer.fromJson<List<String>>(json['gameIds']),
      notifyHour: serializer.fromJson<int>(json['notifyHour']),
      notifyMinute: serializer.fromJson<int>(json['notifyMinute']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gameIds': serializer.toJson<List<String>>(gameIds),
      'notifyHour': serializer.toJson<int>(notifyHour),
      'notifyMinute': serializer.toJson<int>(notifyMinute),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  NotificationRule copyWith({
    String? id,
    List<String>? gameIds,
    int? notifyHour,
    int? notifyMinute,
    bool? isEnabled,
  }) => NotificationRule(
    id: id ?? this.id,
    gameIds: gameIds ?? this.gameIds,
    notifyHour: notifyHour ?? this.notifyHour,
    notifyMinute: notifyMinute ?? this.notifyMinute,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  NotificationRule copyWithCompanion(NotificationRulesCompanion data) {
    return NotificationRule(
      id: data.id.present ? data.id.value : this.id,
      gameIds: data.gameIds.present ? data.gameIds.value : this.gameIds,
      notifyHour: data.notifyHour.present
          ? data.notifyHour.value
          : this.notifyHour,
      notifyMinute: data.notifyMinute.present
          ? data.notifyMinute.value
          : this.notifyMinute,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRule(')
          ..write('id: $id, ')
          ..write('gameIds: $gameIds, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, gameIds, notifyHour, notifyMinute, isEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRule &&
          other.id == this.id &&
          other.gameIds == this.gameIds &&
          other.notifyHour == this.notifyHour &&
          other.notifyMinute == this.notifyMinute &&
          other.isEnabled == this.isEnabled);
}

class NotificationRulesCompanion extends UpdateCompanion<NotificationRule> {
  final Value<String> id;
  final Value<List<String>> gameIds;
  final Value<int> notifyHour;
  final Value<int> notifyMinute;
  final Value<bool> isEnabled;
  final Value<int> rowid;
  const NotificationRulesCompanion({
    this.id = const Value.absent(),
    this.gameIds = const Value.absent(),
    this.notifyHour = const Value.absent(),
    this.notifyMinute = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationRulesCompanion.insert({
    required String id,
    required List<String> gameIds,
    required int notifyHour,
    required int notifyMinute,
    this.isEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       gameIds = Value(gameIds),
       notifyHour = Value(notifyHour),
       notifyMinute = Value(notifyMinute);
  static Insertable<NotificationRule> custom({
    Expression<String>? id,
    Expression<String>? gameIds,
    Expression<int>? notifyHour,
    Expression<int>? notifyMinute,
    Expression<bool>? isEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameIds != null) 'game_ids': gameIds,
      if (notifyHour != null) 'notify_hour': notifyHour,
      if (notifyMinute != null) 'notify_minute': notifyMinute,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationRulesCompanion copyWith({
    Value<String>? id,
    Value<List<String>>? gameIds,
    Value<int>? notifyHour,
    Value<int>? notifyMinute,
    Value<bool>? isEnabled,
    Value<int>? rowid,
  }) {
    return NotificationRulesCompanion(
      id: id ?? this.id,
      gameIds: gameIds ?? this.gameIds,
      notifyHour: notifyHour ?? this.notifyHour,
      notifyMinute: notifyMinute ?? this.notifyMinute,
      isEnabled: isEnabled ?? this.isEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gameIds.present) {
      map['game_ids'] = Variable<String>(
        $NotificationRulesTable.$convertergameIds.toSql(gameIds.value),
      );
    }
    if (notifyHour.present) {
      map['notify_hour'] = Variable<int>(notifyHour.value);
    }
    if (notifyMinute.present) {
      map['notify_minute'] = Variable<int>(notifyMinute.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRulesCompanion(')
          ..write('id: $id, ')
          ..write('gameIds: $gameIds, ')
          ..write('notifyHour: $notifyHour, ')
          ..write('notifyMinute: $notifyMinute, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $DailyQuestItemsTable dailyQuestItems = $DailyQuestItemsTable(
    this,
  );
  late final $CharacterQuestItemsTable characterQuestItems =
      $CharacterQuestItemsTable(this);
  late final $QuestLogsTable questLogs = $QuestLogsTable(this);
  late final $NotificationRulesTable notificationRules =
      $NotificationRulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    games,
    characters,
    dailyQuestItems,
    characterQuestItems,
    questLogs,
    notificationRules,
  ];
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String id,
      required String name,
      required GameType gameType,
      required int dailyResetHour,
      required int dailyResetMinute,
      required Weekday weeklyResetWeekday,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<GameType> gameType,
      Value<int> dailyResetHour,
      Value<int> dailyResetMinute,
      Value<Weekday> weeklyResetWeekday,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharactersTable, List<Character>>
  _charactersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characters,
    aliasName: 'games__id__characters__game_id',
  );

  $$CharactersTableProcessedTableManager get charactersRefs {
    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_charactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DailyQuestItemsTable, List<DailyQuestItem>>
  _dailyQuestItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyQuestItems,
    aliasName: 'games__id__daily_quest_items__game_id',
  );

  $$DailyQuestItemsTableProcessedTableManager get dailyQuestItemsRefs {
    final manager = $$DailyQuestItemsTableTableManager(
      $_db,
      $_db.dailyQuestItems,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyQuestItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterQuestItemsTable,
    List<CharacterQuestItem>
  >
  _characterQuestItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterQuestItems,
        aliasName: 'games__id__character_quest_items__game_id',
      );

  $$CharacterQuestItemsTableProcessedTableManager get characterQuestItemsRefs {
    final manager = $$CharacterQuestItemsTableTableManager(
      $_db,
      $_db.characterQuestItems,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterQuestItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameType, GameType, int> get gameType =>
      $composableBuilder(
        column: $table.gameType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get dailyResetHour => $composableBuilder(
    column: $table.dailyResetHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyResetMinute => $composableBuilder(
    column: $table.dailyResetMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Weekday, Weekday, int>
  get weeklyResetWeekday => $composableBuilder(
    column: $table.weeklyResetWeekday,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> charactersRefs(
    Expression<bool> Function($$CharactersTableFilterComposer f) f,
  ) {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dailyQuestItemsRefs(
    Expression<bool> Function($$DailyQuestItemsTableFilterComposer f) f,
  ) {
    final $$DailyQuestItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuestItems,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyQuestItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterQuestItemsRefs(
    Expression<bool> Function($$CharacterQuestItemsTableFilterComposer f) f,
  ) {
    final $$CharacterQuestItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterQuestItems,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterQuestItemsTableFilterComposer(
            $db: $db,
            $table: $db.characterQuestItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyResetHour => $composableBuilder(
    column: $table.dailyResetHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyResetMinute => $composableBuilder(
    column: $table.dailyResetMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyResetWeekday => $composableBuilder(
    column: $table.weeklyResetWeekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameType, int> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<int> get dailyResetHour => $composableBuilder(
    column: $table.dailyResetHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyResetMinute => $composableBuilder(
    column: $table.dailyResetMinute,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Weekday, int> get weeklyResetWeekday =>
      $composableBuilder(
        column: $table.weeklyResetWeekday,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> charactersRefs<T extends Object>(
    Expression<T> Function($$CharactersTableAnnotationComposer a) f,
  ) {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dailyQuestItemsRefs<T extends Object>(
    Expression<T> Function($$DailyQuestItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyQuestItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyQuestItems,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyQuestItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyQuestItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterQuestItemsRefs<T extends Object>(
    Expression<T> Function($$CharacterQuestItemsTableAnnotationComposer a) f,
  ) {
    final $$CharacterQuestItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterQuestItems,
          getReferencedColumn: (t) => t.gameId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterQuestItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.characterQuestItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({
            bool charactersRefs,
            bool dailyQuestItemsRefs,
            bool characterQuestItemsRefs,
          })
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<GameType> gameType = const Value.absent(),
                Value<int> dailyResetHour = const Value.absent(),
                Value<int> dailyResetMinute = const Value.absent(),
                Value<Weekday> weeklyResetWeekday = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                name: name,
                gameType: gameType,
                dailyResetHour: dailyResetHour,
                dailyResetMinute: dailyResetMinute,
                weeklyResetWeekday: weeklyResetWeekday,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required GameType gameType,
                required int dailyResetHour,
                required int dailyResetMinute,
                required Weekday weeklyResetWeekday,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                name: name,
                gameType: gameType,
                dailyResetHour: dailyResetHour,
                dailyResetMinute: dailyResetMinute,
                weeklyResetWeekday: weeklyResetWeekday,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GamesTable, Game>(table),
                  $$GamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                charactersRefs = false,
                dailyQuestItemsRefs = false,
                characterQuestItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (charactersRefs) db.characters,
                    if (dailyQuestItemsRefs) db.dailyQuestItems,
                    if (characterQuestItemsRefs) db.characterQuestItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (charactersRefs)
                        await $_getPrefetchedData<Game, $GamesTable, Character>(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._charactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).charactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dailyQuestItemsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          DailyQuestItem
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._dailyQuestItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).dailyQuestItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterQuestItemsRefs)
                        await $_getPrefetchedData<
                          Game,
                          $GamesTable,
                          CharacterQuestItem
                        >(
                          currentTable: table,
                          referencedTable: $$GamesTableReferences
                              ._characterQuestItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GamesTableReferences(
                                db,
                                table,
                                p0,
                              ).characterQuestItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.gameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({
        bool charactersRefs,
        bool dailyQuestItemsRefs,
        bool characterQuestItemsRefs,
      })
    >;
typedef $$CharactersTableCreateCompanionBuilder =
    CharactersCompanion Function({
      required String id,
      required String gameId,
      required String name,
      Value<int> rowid,
    });
typedef $$CharactersTableUpdateCompanionBuilder =
    CharactersCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('characters__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $CharacterQuestItemsTable,
    List<CharacterQuestItem>
  >
  _characterQuestItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterQuestItems,
        aliasName: 'characters__id__character_quest_items__character_id',
      );

  $$CharacterQuestItemsTableProcessedTableManager get characterQuestItemsRefs {
    final manager = $$CharacterQuestItemsTableTableManager(
      $_db,
      $_db.characterQuestItems,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterQuestItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuestLogsTable, List<QuestLog>>
  _questLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questLogs,
    aliasName: 'characters__id__quest_logs__character_id',
  );

  $$QuestLogsTableProcessedTableManager get questLogsRefs {
    final manager = $$QuestLogsTableTableManager(
      $_db,
      $_db.questLogs,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_questLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> characterQuestItemsRefs(
    Expression<bool> Function($$CharacterQuestItemsTableFilterComposer f) f,
  ) {
    final $$CharacterQuestItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterQuestItems,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterQuestItemsTableFilterComposer(
            $db: $db,
            $table: $db.characterQuestItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> questLogsRefs(
    Expression<bool> Function($$QuestLogsTableFilterComposer f) f,
  ) {
    final $$QuestLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questLogs,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestLogsTableFilterComposer(
            $db: $db,
            $table: $db.questLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> characterQuestItemsRefs<T extends Object>(
    Expression<T> Function($$CharacterQuestItemsTableAnnotationComposer a) f,
  ) {
    final $$CharacterQuestItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterQuestItems,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterQuestItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.characterQuestItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> questLogsRefs<T extends Object>(
    Expression<T> Function($$QuestLogsTableAnnotationComposer a) f,
  ) {
    final $$QuestLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questLogs,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.questLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (Character, $$CharactersTableReferences),
          Character,
          PrefetchHooks Function({
            bool gameId,
            bool characterQuestItemsRefs,
            bool questLogsRefs,
          })
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                id: id,
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                id: id,
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharactersTable, Character>(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gameId = false,
                characterQuestItemsRefs = false,
                questLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (characterQuestItemsRefs) db.characterQuestItems,
                    if (questLogsRefs) db.questLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gameId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.gameId,
                                    referencedTable: $$CharactersTableReferences
                                        ._gameIdTable(db),
                                    referencedColumn:
                                        $$CharactersTableReferences
                                            ._gameIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (characterQuestItemsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterQuestItem
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterQuestItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterQuestItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (questLogsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          QuestLog
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._questLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).questLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, $$CharactersTableReferences),
      Character,
      PrefetchHooks Function({
        bool gameId,
        bool characterQuestItemsRefs,
        bool questLogsRefs,
      })
    >;
typedef $$DailyQuestItemsTableCreateCompanionBuilder =
    DailyQuestItemsCompanion Function({
      required String id,
      required String gameId,
      required String name,
      Value<int> rowid,
    });
typedef $$DailyQuestItemsTableUpdateCompanionBuilder =
    DailyQuestItemsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$DailyQuestItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DailyQuestItemsTable, DailyQuestItem> {
  $$DailyQuestItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('daily_quest_items__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyQuestItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestItemsTable> {
  $$DailyQuestItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestItemsTable> {
  $$DailyQuestItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestItemsTable> {
  $$DailyQuestItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyQuestItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestItemsTable,
          DailyQuestItem,
          $$DailyQuestItemsTableFilterComposer,
          $$DailyQuestItemsTableOrderingComposer,
          $$DailyQuestItemsTableAnnotationComposer,
          $$DailyQuestItemsTableCreateCompanionBuilder,
          $$DailyQuestItemsTableUpdateCompanionBuilder,
          (DailyQuestItem, $$DailyQuestItemsTableReferences),
          DailyQuestItem,
          PrefetchHooks Function({bool gameId})
        > {
  $$DailyQuestItemsTableTableManager(
    _$AppDatabase db,
    $DailyQuestItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestItemsCompanion(
                id: id,
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestItemsCompanion.insert(
                id: id,
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyQuestItemsTable, DailyQuestItem>(table),
                  $$DailyQuestItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$DailyQuestItemsTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$DailyQuestItemsTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyQuestItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestItemsTable,
      DailyQuestItem,
      $$DailyQuestItemsTableFilterComposer,
      $$DailyQuestItemsTableOrderingComposer,
      $$DailyQuestItemsTableAnnotationComposer,
      $$DailyQuestItemsTableCreateCompanionBuilder,
      $$DailyQuestItemsTableUpdateCompanionBuilder,
      (DailyQuestItem, $$DailyQuestItemsTableReferences),
      DailyQuestItem,
      PrefetchHooks Function({bool gameId})
    >;
typedef $$CharacterQuestItemsTableCreateCompanionBuilder =
    CharacterQuestItemsCompanion Function({
      required String id,
      required String gameId,
      required String characterId,
      required QuestCategory category,
      required String name,
      Value<DateTime?> dueDate,
      Value<String?> memo,
      Value<int> rowid,
    });
typedef $$CharacterQuestItemsTableUpdateCompanionBuilder =
    CharacterQuestItemsCompanion Function({
      Value<String> id,
      Value<String> gameId,
      Value<String> characterId,
      Value<QuestCategory> category,
      Value<String> name,
      Value<DateTime?> dueDate,
      Value<String?> memo,
      Value<int> rowid,
    });

final class $$CharacterQuestItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterQuestItemsTable,
          CharacterQuestItem
        > {
  $$CharacterQuestItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('character_quest_items__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_quest_items__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterQuestItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterQuestItemsTable> {
  $$CharacterQuestItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuestCategory, QuestCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterQuestItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterQuestItemsTable> {
  $$CharacterQuestItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterQuestItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterQuestItemsTable> {
  $$CharacterQuestItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<QuestCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterQuestItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterQuestItemsTable,
          CharacterQuestItem,
          $$CharacterQuestItemsTableFilterComposer,
          $$CharacterQuestItemsTableOrderingComposer,
          $$CharacterQuestItemsTableAnnotationComposer,
          $$CharacterQuestItemsTableCreateCompanionBuilder,
          $$CharacterQuestItemsTableUpdateCompanionBuilder,
          (CharacterQuestItem, $$CharacterQuestItemsTableReferences),
          CharacterQuestItem,
          PrefetchHooks Function({bool gameId, bool characterId})
        > {
  $$CharacterQuestItemsTableTableManager(
    _$AppDatabase db,
    $CharacterQuestItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterQuestItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterQuestItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterQuestItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gameId = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<QuestCategory> category = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterQuestItemsCompanion(
                id: id,
                gameId: gameId,
                characterId: characterId,
                category: category,
                name: name,
                dueDate: dueDate,
                memo: memo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String gameId,
                required String characterId,
                required QuestCategory category,
                required String name,
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterQuestItemsCompanion.insert(
                id: id,
                gameId: gameId,
                characterId: characterId,
                category: category,
                name: name,
                dueDate: dueDate,
                memo: memo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterQuestItemsTable, CharacterQuestItem>(
                    table,
                  ),
                  $$CharacterQuestItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false, characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable:
                                    $$CharacterQuestItemsTableReferences
                                        ._gameIdTable(db),
                                referencedColumn:
                                    $$CharacterQuestItemsTableReferences
                                        ._gameIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable:
                                    $$CharacterQuestItemsTableReferences
                                        ._characterIdTable(db),
                                referencedColumn:
                                    $$CharacterQuestItemsTableReferences
                                        ._characterIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterQuestItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterQuestItemsTable,
      CharacterQuestItem,
      $$CharacterQuestItemsTableFilterComposer,
      $$CharacterQuestItemsTableOrderingComposer,
      $$CharacterQuestItemsTableAnnotationComposer,
      $$CharacterQuestItemsTableCreateCompanionBuilder,
      $$CharacterQuestItemsTableUpdateCompanionBuilder,
      (CharacterQuestItem, $$CharacterQuestItemsTableReferences),
      CharacterQuestItem,
      PrefetchHooks Function({bool gameId, bool characterId})
    >;
typedef $$QuestLogsTableCreateCompanionBuilder =
    QuestLogsCompanion Function({
      required String id,
      required String questItemId,
      Value<String?> characterId,
      required DateTime periodDate,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$QuestLogsTableUpdateCompanionBuilder =
    QuestLogsCompanion Function({
      Value<String> id,
      Value<String> questItemId,
      Value<String?> characterId,
      Value<DateTime> periodDate,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

final class $$QuestLogsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestLogsTable, QuestLog> {
  $$QuestLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias('quest_logs__character_id__characters__id');

  $$CharactersTableProcessedTableManager? get characterId {
    final $_column = $_itemColumn<String>('character_id');
    if ($_column == null) return null;
    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestLogsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestLogsTable> {
  $$QuestLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questItemId => $composableBuilder(
    column: $table.questItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get periodDate => $composableBuilder(
    column: $table.periodDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestLogsTable> {
  $$QuestLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questItemId => $composableBuilder(
    column: $table.questItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get periodDate => $composableBuilder(
    column: $table.periodDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestLogsTable> {
  $$QuestLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questItemId => $composableBuilder(
    column: $table.questItemId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get periodDate => $composableBuilder(
    column: $table.periodDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestLogsTable,
          QuestLog,
          $$QuestLogsTableFilterComposer,
          $$QuestLogsTableOrderingComposer,
          $$QuestLogsTableAnnotationComposer,
          $$QuestLogsTableCreateCompanionBuilder,
          $$QuestLogsTableUpdateCompanionBuilder,
          (QuestLog, $$QuestLogsTableReferences),
          QuestLog,
          PrefetchHooks Function({bool characterId})
        > {
  $$QuestLogsTableTableManager(_$AppDatabase db, $QuestLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> questItemId = const Value.absent(),
                Value<String?> characterId = const Value.absent(),
                Value<DateTime> periodDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestLogsCompanion(
                id: id,
                questItemId: questItemId,
                characterId: characterId,
                periodDate: periodDate,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String questItemId,
                Value<String?> characterId = const Value.absent(),
                required DateTime periodDate,
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestLogsCompanion.insert(
                id: id,
                questItemId: questItemId,
                characterId: characterId,
                periodDate: periodDate,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestLogsTable, QuestLog>(table),
                  $$QuestLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.characterId,
                                referencedTable: $$QuestLogsTableReferences
                                    ._characterIdTable(db),
                                referencedColumn: $$QuestLogsTableReferences
                                    ._characterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuestLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestLogsTable,
      QuestLog,
      $$QuestLogsTableFilterComposer,
      $$QuestLogsTableOrderingComposer,
      $$QuestLogsTableAnnotationComposer,
      $$QuestLogsTableCreateCompanionBuilder,
      $$QuestLogsTableUpdateCompanionBuilder,
      (QuestLog, $$QuestLogsTableReferences),
      QuestLog,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$NotificationRulesTableCreateCompanionBuilder =
    NotificationRulesCompanion Function({
      required String id,
      required List<String> gameIds,
      required int notifyHour,
      required int notifyMinute,
      Value<bool> isEnabled,
      Value<int> rowid,
    });
typedef $$NotificationRulesTableUpdateCompanionBuilder =
    NotificationRulesCompanion Function({
      Value<String> id,
      Value<List<String>> gameIds,
      Value<int> notifyHour,
      Value<int> notifyMinute,
      Value<bool> isEnabled,
      Value<int> rowid,
    });

class $$NotificationRulesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get gameIds => $composableBuilder(
    column: $table.gameIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameIds => $composableBuilder(
    column: $table.gameIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationRulesTable> {
  $$NotificationRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get gameIds =>
      $composableBuilder(column: $table.gameIds, builder: (column) => column);

  GeneratedColumn<int> get notifyHour => $composableBuilder(
    column: $table.notifyHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notifyMinute => $composableBuilder(
    column: $table.notifyMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);
}

class $$NotificationRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationRulesTable,
          NotificationRule,
          $$NotificationRulesTableFilterComposer,
          $$NotificationRulesTableOrderingComposer,
          $$NotificationRulesTableAnnotationComposer,
          $$NotificationRulesTableCreateCompanionBuilder,
          $$NotificationRulesTableUpdateCompanionBuilder,
          (
            NotificationRule,
            BaseReferences<
              _$AppDatabase,
              $NotificationRulesTable,
              NotificationRule
            >,
          ),
          NotificationRule,
          PrefetchHooks Function()
        > {
  $$NotificationRulesTableTableManager(
    _$AppDatabase db,
    $NotificationRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationRulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<List<String>> gameIds = const Value.absent(),
                Value<int> notifyHour = const Value.absent(),
                Value<int> notifyMinute = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationRulesCompanion(
                id: id,
                gameIds: gameIds,
                notifyHour: notifyHour,
                notifyMinute: notifyMinute,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required List<String> gameIds,
                required int notifyHour,
                required int notifyMinute,
                Value<bool> isEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationRulesCompanion.insert(
                id: id,
                gameIds: gameIds,
                notifyHour: notifyHour,
                notifyMinute: notifyMinute,
                isEnabled: isEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotificationRulesTable, NotificationRule>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotificationRulesTable,
                    NotificationRule
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationRulesTable,
      NotificationRule,
      $$NotificationRulesTableFilterComposer,
      $$NotificationRulesTableOrderingComposer,
      $$NotificationRulesTableAnnotationComposer,
      $$NotificationRulesTableCreateCompanionBuilder,
      $$NotificationRulesTableUpdateCompanionBuilder,
      (
        NotificationRule,
        BaseReferences<
          _$AppDatabase,
          $NotificationRulesTable,
          NotificationRule
        >,
      ),
      NotificationRule,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$DailyQuestItemsTableTableManager get dailyQuestItems =>
      $$DailyQuestItemsTableTableManager(_db, _db.dailyQuestItems);
  $$CharacterQuestItemsTableTableManager get characterQuestItems =>
      $$CharacterQuestItemsTableTableManager(_db, _db.characterQuestItems);
  $$QuestLogsTableTableManager get questLogs =>
      $$QuestLogsTableTableManager(_db, _db.questLogs);
  $$NotificationRulesTableTableManager get notificationRules =>
      $$NotificationRulesTableTableManager(_db, _db.notificationRules);
}
