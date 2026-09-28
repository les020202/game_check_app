import 'package:drift/drift.dart';

import '../local/database.dart';

class DriftGameService {
  final AppDatabase _db;
  DriftGameService(this._db);

  Future<List<GameEntity>> getGames() {
    return _db.select(_db.games).get();
  }

  Future<void> addGame(GamesCompanion game) {
    return _db.into(_db.games).insert(game);
  }

  Future<void> updateGame(String gameId, GamesCompanion game) {
    return (_db.update(
      _db.games,
    )..where((g) => g.id.equals(gameId))).write(game);
  }

  Future<void> deleteGame(String gameId) {
    return (_db.delete(_db.games)..where((g) => g.id.equals(gameId))).go();
  }

  Future<List<CharacterEntity>> getCharacters(String gameId) {
    return (_db.select(
      _db.characters,
    )..where((c) => c.gameId.equals(gameId))).get();
  }

  Future<void> addCharacter(CharactersCompanion character) {
    return _db.into(_db.characters).insert(character);
  }

  Future<void> updateCharacterName(String characterId, String newName) {
    return (_db.update(_db.characters)..where((c) => c.id.equals(characterId)))
        .write(CharactersCompanion(name: Value(newName)));
  }

  Future<void> deleteCharacter(String characterId) async {
    await (_db.delete(
      _db.characterQuestItems,
    )..where((q) => q.characterId.equals(characterId))).go();
    await (_db.delete(
      _db.characters,
    )..where((c) => c.id.equals(characterId))).go();
  }

  Future<List<DailyQuestItemEntity>> getDailyQuests(String gameId) {
    return (_db.select(
      _db.dailyQuestItems,
    )..where((d) => d.gameId.equals(gameId))).get();
  }

  Future<void> addDailyQuest(DailyQuestItemsCompanion dailyQuest) {
    return _db.into(_db.dailyQuestItems).insert(dailyQuest);
  }

  Future<void> updateDailyQuestName(String dailyId, String newName) {
    return (_db.update(_db.dailyQuestItems)..where((d) => d.id.equals(dailyId)))
        .write(DailyQuestItemsCompanion(name: Value(newName)));
  }

  Future<void> deleteDailyById(String dailyId) {
    return (_db.delete(
      _db.dailyQuestItems,
    )..where((d) => d.id.equals(dailyId))).go();
  }

  Future<List<CharacterQuestItemEntity>> characterQuests(String gameId) {
    return (_db.select(
      _db.characterQuestItems,
    )..where((q) => q.gameId.equals(gameId))).get();
  }

  Future<void> addCharacterQuest(CharacterQuestItemsCompanion characterQuest) {
    return _db.into(_db.characterQuestItems).insert(characterQuest);
  }

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

  Future<void> deleteCharacterQuestById(String questId) {
    return (_db.delete(
      _db.characterQuestItems,
    )..where((q) => q.id.equals(questId))).go();
  }

  Future<QuestLogEntity?> getQuestLog(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  }) {
    return (_db.select(_db.questLogs)..where(
          (q) =>
              q.questItemId.equals(questItemId) &
              (characterId == null
                  ? q.characterId.isNull()
                  : q.characterId.equals(characterId)) &
              q.periodDate.equals(periodDate),
        ))
        .getSingleOrNull();
  }

  Future<void> upsertQuestLog(QuestLogsCompanion log) {
    return _db.into(_db.questLogs).insertOnConflictUpdate(log);
  }
}
