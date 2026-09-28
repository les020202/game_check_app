import 'package:drift/drift.dart';

import '../local/database.dart';
import '../models/game.dart';
import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/quest_log.dart';
import 'game_service.dart';

class DriftGameService implements GameService{
  final AppDatabase _db;
  DriftGameService(this._db);

  // ---------- 매핑 변환 함수(Entity <-> Model) ----------
  Game _toGame(GameEntity e) => Game(
        id: e.id,
        userId: null,
        name: e.name,
        gameType: e.gameType,
        gameResetHour: e.gameResetHour,
        gameResetMinute: e.gameResetMinute,
        weeklyResetWeekday: e.weeklyResetWeekday,
        createdAt: e.createdAt,
      );

  GamesCompanion _gameToCompanion(Game g) => GamesCompanion(
        id: Value(g.id),
        name: Value(g.name),
        gameType: Value(g.gameType),
        gameResetHour: Value(g.gameResetHour),
        gameResetMinute: Value(g.gameResetMinute),
        weeklyResetWeekday: Value(g.weeklyResetWeekday),
        createdAt: Value(g.createdAt),
      );

  Character _toCharacter(CharacterEntity e) =>
      Character(id: e.id, gameId: e.gameId, name: e.name);

  DailyQuestItem _toDaily(DailyQuestItemEntity e) =>
      DailyQuestItem(id: e.id, gameId: e.gameId, name: e.name);

  CharacterQuestItem _toCharacterQuest(CharacterQuestItemEntity e) =>
      CharacterQuestItem(
        id: e.id,
        gameId: e.gameId,
        characterId: e.characterId,
        category: e.category,
        name: e.name,
        memo: e.memo,
        dueDate: e.dueDate,
      );

  QuestLog _toQuestLog(QuestLogEntity e) => QuestLog(
        id: e.id,
        questItemId: e.questItemId,
        characterId: e.characterId,
        periodDate: e.periodDate,
        isCompleted: e.isCompleted,
      );

  //game
  @override
  Future<List<Game>> getGames() async {
    final rows = await _db.select(_db.games).get();
    return rows.map(_toGame).toList();
  }

  @override
  Future<void> addGame(Game game,{String? uid}) {
    return _db.into(_db.games).insert(_gameToCompanion(game));
  }

  @override
  Future<void> updateGame(String gameId, Game game) {
    return (_db.update(_db.games)..where((g) => g.id.equals(gameId)))
        .write(_gameToCompanion(game));
  }

  @override
  Future<void> deleteGame(String gameId) {
    return (_db.delete(_db.games)..where((g) => g.id.equals(gameId))).go();
  }

  //character
  @override
  Future<List<Character>> getCharacters(String gameId) async {
    final rows = await (_db.select(_db.characters)
          ..where((c) => c.gameId.equals(gameId)))
        .get();
    return rows.map(_toCharacter).toList();
  }

  @override
  Future<void> addCharacter(Character character) {
    return _db.into(_db.characters).insert(
          CharactersCompanion(
            id: Value(character.id),
            gameId: Value(character.gameId),
            name: Value(character.name),
          ),
        );
  }

  @override
  Future<void> updateCharacterName(String characterId, String newName) {
    return (_db.update(_db.characters)..where((c) => c.id.equals(characterId)))
        .write(CharactersCompanion(name: Value(newName)));
  }

  @override
  Future<void> deleteCharacter(String characterId) async {
    await (_db.delete(
      _db.characterQuestItems,
    )..where((q) => q.characterId.equals(characterId))).go();
    await (_db.delete(
      _db.characters,
    )..where((c) => c.id.equals(characterId))).go();
    await (_db.delete(
      _db.questLogs,
    )..where((c) => c.id.equals(characterId))).go();
  }

  //DailyQuest
  @override
  Future<List<DailyQuestItem>> getDailyQuests(String gameId) async {
    final rows = await (_db.select(_db.dailyQuestItems)
          ..where((d) => d.gameId.equals(gameId)))
        .get();
    return rows.map(_toDaily).toList();
  }

  @override
  Future<void> addDailyQuest(DailyQuestItem dailyQuest) {
    return _db.into(_db.dailyQuestItems).insert(
          DailyQuestItemsCompanion(
            id: Value(dailyQuest.id),
            gameId: Value(dailyQuest.gameId),
            name: Value(dailyQuest.name),
          ),
        );
  }

  @override
  Future<void> updateDailyQuestName(String dailyId, String newName) {
    return (_db.update(_db.dailyQuestItems)..where((d) => d.id.equals(dailyId)))
        .write(DailyQuestItemsCompanion(name: Value(newName)));
  }

  @override
  Future<void> deleteDailyById(String dailyId) {
    return (_db.delete(
      _db.dailyQuestItems,
    )..where((d) => d.id.equals(dailyId))).go();
  }
  
  //CharacterQuest
  @override
  Future<List<CharacterQuestItem>> getCharacterQuests(String gameId) async {
    final rows = await (_db.select(_db.characterQuestItems)
          ..where((q) => q.gameId.equals(gameId)))
        .get();
    return rows.map(_toCharacterQuest).toList();
  }

  @override
  Future<void> addCharacterQuest(CharacterQuestItem q) {
    return _db.into(_db.characterQuestItems).insert(
          CharacterQuestItemsCompanion(
            id: Value(q.id),
            gameId: Value(q.gameId),
            characterId: Value(q.characterId),
            category: Value(q.category),
            name: Value(q.name),
            memo: Value(q.memo),
            dueDate: Value(q.dueDate),
          ),
        );
  }

  @override
  Future<void> updateCharacterQuest(
    String questId, {
    required String name,
    String? memo,
    DateTime? dueDate,
  }) {
    return (_db.update(
      _db.characterQuestItems,
    )..where((q) => q.id.equals(questId))).write(
      CharacterQuestItemsCompanion(
        name: Value(name),
        memo: Value(memo),
        dueDate: Value(dueDate),
      ),
    );
  }

  @override
  Future<void> deleteCharacterQuestById(String questId) {
    return (_db.delete(
      _db.characterQuestItems,
    )..where((q) => q.id.equals(questId))).go();
  }

  //QuestLog
  @override
  Future<QuestLog?> getQuestLog(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  }) async {
    final row = await (_db.select(_db.questLogs)
          ..where((q) =>
              q.questItemId.equals(questItemId) &
              (characterId == null
                  ? q.characterId.isNull()
                  : q.characterId.equals(characterId)) &
              q.periodDate.equals(periodDate)))
        .getSingleOrNull();
    return row == null ? null : _toQuestLog(row);
  }

  @override
  Future<void> upsertQuestLog(QuestLog log) {
    return _db.into(_db.questLogs).insertOnConflictUpdate(
          QuestLogsCompanion(
            id: Value(log.id),
            questItemId: Value(log.questItemId),
            characterId: Value(log.characterId),
            periodDate: Value(log.periodDate),
            isCompleted: Value(log.isCompleted),
          ),
        );
  }
}
