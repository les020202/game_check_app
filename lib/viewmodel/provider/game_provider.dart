import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

import '../../local/database.dart';
import '../../services/drift_game_service.dart';
import '../../models/character.dart';
import '../../models/character_quest_item.dart';
import '../../models/daily_quest_item.dart';
import '../../models/game.dart';
import '../../models/quest_category.dart';
import '../../models/quest_log.dart';

class GameProvider extends ChangeNotifier {
  final DriftGameService _service;
  final Uuid _uuid = const Uuid();

  GameProvider(this._service);

  List<Game> _games = [];
  List<Character> _characters = [];
  List<DailyQuestItem> _dailyQuests = [];
  List<CharacterQuestItem> _characterQuests = [];
  List<QuestLog> _questLogs = [];

  List<Game> get games => List.unmodifiable(_games);

  // =========================================================
  // 매핑 함수 (Entity <-> Model)
  // =========================================================

  Game _toGame(GameEntity e) => Game(
    id: e.id,
    userId: null, // 로컬 DB엔 없음 — 나중에 Firebase 연동 시 처리
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

  // =========================================================
  // Game
  // =========================================================

  Future<void> loadGames() async {
    final entities = await _service.getGames();
    _games = entities.map(_toGame).toList();
    notifyListeners();
  }

  Future<void> addGame(Game game) async {
    await _service.addGame(_gameToCompanion(game));
    await loadGames();
  }

  Future<void> deleteGame(String gameId) async {
    await _service.deleteGame(gameId);
    await loadGames();
  }

  Future<void> updateGame(String gameId, Game newGame) async {
    await _service.updateGame(gameId, _gameToCompanion(newGame));
    await loadGames();
  }

  // =========================================================
  // Character
  // =========================================================

  List<Character> characters(String gameId) {
    return _characters.where((c) => c.gameId == gameId).toList();
  }

  Future<void> loadCharacters(String gameId) async {
    final entities = await _service.getCharacters(gameId);
    _characters = [
      ..._characters.where((c) => c.gameId != gameId), // 다른 게임 데이터는 유지
      ...entities.map(_toCharacter),
    ];
    notifyListeners();
  }

  Future<void> addCharacter(Character character) async {
    await _service.addCharacter(
      CharactersCompanion(
        id: Value(character.id),
        gameId: Value(character.gameId),
        name: Value(character.name),
      ),
    );
    await loadCharacters(character.gameId);
  }

  Future<void> updateCharacterName(String characterId, String newName) async {
    await _service.updateCharacterName(characterId, newName);
    final gameId = _characters.firstWhere((c) => c.id == characterId).gameId;
    await loadCharacters(gameId);
  }

  Future<void> deleteCharacterById(String characterId) async {
    final gameId = _characters.firstWhere((c) => c.id == characterId).gameId;
    await _service.deleteCharacter(characterId); // 딸린 퀘스트 삭제까지 Service가 처리
    await loadCharacters(gameId);
    await loadCharacterQuests(gameId);
  }

  // =========================================================
  // Daily Quest
  // =========================================================

  List<DailyQuestItem> dailyQuests(String gameId) {
    return _dailyQuests.where((d) => d.gameId == gameId).toList();
  }

  Future<void> loadDailyQuests(String gameId) async {
    final entities = await _service.getDailyQuests(gameId);
    _dailyQuests = [
      ..._dailyQuests.where((d) => d.gameId != gameId),
      ...entities.map(_toDaily),
    ];
    notifyListeners();
  }

  Future<void> addDaily(DailyQuestItem dailyQuest) async {
    await _service.addDailyQuest(
      DailyQuestItemsCompanion(
        id: Value(dailyQuest.id),
        gameId: Value(dailyQuest.gameId),
        name: Value(dailyQuest.name),
      ),
    );
    await loadDailyQuests(dailyQuest.gameId);
  }

  Future<void> updateDailyQuestName(String dailyId, String newName) async {
    await _service.updateDailyQuestName(dailyId, newName);
    final gameId = _dailyQuests.firstWhere((d) => d.id == dailyId).gameId;
    await loadDailyQuests(gameId);
  }

  Future<void> deleteDailyById(String dailyId) async {
    final gameId = _dailyQuests.firstWhere((d) => d.id == dailyId).gameId;
    await _service.deleteDailyById(dailyId);
    await loadDailyQuests(gameId);
  }

  // =========================================================
  // Character Quest (weekly / monthly / goal)
  // =========================================================

  List<CharacterQuestItem> characterQuests(String gameId) {
    return _characterQuests.where((q) => q.gameId == gameId).toList();
  }

  List<CharacterQuestItem> weeklyQuests(
    String gameId,
    List<Character> characters,
    int index,
  ) {
    return _characterQuests
        .where(
          (q) =>
              q.category == QuestCategory.weekly &&
              q.gameId == gameId &&
              q.characterId == characters[index].id,
        )
        .toList();
  }

  List<CharacterQuestItem> monthlyQuests(
    String gameId,
    List<Character> characters,
    int index,
  ) {
    return _characterQuests
        .where(
          (q) =>
              q.category == QuestCategory.monthly &&
              q.gameId == gameId &&
              q.characterId == characters[index].id,
        )
        .toList();
  }

  List<CharacterQuestItem> goalQuests(
    String gameId,
    List<Character> characters,
    int index,
  ) {
    return _characterQuests
        .where(
          (q) =>
              q.category == QuestCategory.goal &&
              q.gameId == gameId &&
              q.characterId == characters[index].id,
        )
        .toList();
  }

  Future<void> loadCharacterQuests(String gameId) async {
    final entities = await _service.characterQuests(gameId);
    _characterQuests = [
      ..._characterQuests.where((q) => q.gameId != gameId),
      ...entities.map(_toCharacterQuest),
    ];
    notifyListeners();
  }

  Future<void> addCharacterQuest(CharacterQuestItem characterQuest) async {
    await _service.addCharacterQuest(
      CharacterQuestItemsCompanion(
        id: Value(characterQuest.id),
        gameId: Value(characterQuest.gameId),
        characterId: Value(characterQuest.characterId),
        category: Value(characterQuest.category),
        name: Value(characterQuest.name),
        memo: Value(characterQuest.memo),
        dueDate: Value(characterQuest.dueDate),
      ),
    );
    await loadCharacterQuests(characterQuest.gameId);
  }

  Future<void> updateCharacterQuest(
    String questId, {
    required String name,
    String? memo,
    DateTime? dueDate,
  }) async {
    await _service.updateCharacterQuest(
      questId,
      name: name,
      memo: memo,
      dueDate: dueDate,
    );
    final gameId = _characterQuests.firstWhere((q) => q.id == questId).gameId;
    await loadCharacterQuests(gameId);
  }

  Future<void> deleteCharacterQuestById(String questId) async {
    final gameId = _characterQuests.firstWhere((q) => q.id == questId).gameId;
    await _service.deleteCharacterQuestById(questId);
    await loadCharacterQuests(gameId);
  }

  // =========================================================
  // Quest Log
  // =========================================================

  QuestLog? questLogs(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  }) {
    for (final log in _questLogs) {
      if (log.questItemId == questItemId &&
          log.characterId == characterId &&
          _isSameDay(log.periodDate, periodDate)) {
        return log;
      }
    }
    return null;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> loadQuestLog(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  }) async {
    final entity = await _service.getQuestLog(
      questItemId,
      characterId: characterId,
      periodDate: periodDate,
    );
    if (entity != null) {
      _questLogs.removeWhere(
        (q) =>
            q.questItemId == questItemId &&
            q.characterId == characterId &&
            _isSameDay(q.periodDate, periodDate),
      );
      _questLogs.add(_toQuestLog(entity));
      notifyListeners();
    }
  }

  Future<void> updateQuestLog(
    String questItemId,
    bool isCompleted,
    String? characterId,
    DateTime periodDate,
  ) async {
    final existing = questLogs(
      questItemId,
      characterId: characterId,
      periodDate: periodDate,
    );

    await _service.upsertQuestLog(
      QuestLogsCompanion(
        id: Value(existing?.id ?? _uuid.v4()),
        questItemId: Value(questItemId),
        characterId: Value(characterId),
        periodDate: Value(existing?.periodDate ?? periodDate),
        isCompleted: Value(isCompleted),
      ),
    );

    await loadQuestLog(
      questItemId,
      characterId: characterId,
      periodDate: periodDate,
    );
  }
}
