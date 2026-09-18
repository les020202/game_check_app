import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/character.dart';
import '../../models/character_quest_item.dart';
import '../../models/daily_quest_item.dart';
import '../../models/game.dart';
import '../../models/game_type.dart';
import '../../models/quest_category.dart';
import '../../models/quest_log.dart';
import '../../models/weekday.dart';

class GameProvider extends ChangeNotifier {
  final List<Game> _games = [
    Game(
      id: '1',
      userId: null, // 로그인 전 상태
      name: '메이플스토리',
      gameType: GameType.rpg,
      gameResetHour: 0,
      gameResetMinute: 0,
      weeklyResetWeekday: Weekday.thursday, // 수요일 리셋
    ),
  ];
  final List<DailyQuestItem> _dailyQuests = [
    DailyQuestItem(id: 'd1', gameId: '1', name: '일일퀘'),
  ];
  final List<Character> _characters = [
    Character(id: 'c1', gameId: '1', name: '렌'),
    Character(id: 'c2', gameId: '1', name: '레테'),
  ];
  final List<CharacterQuestItem> _characterQuests = [
    CharacterQuestItem(
      id: 'cq1',
      gameId: '1',
      characterId: 'c1',
      category: QuestCategory.weekly,
      name: '스우',
    ),
    CharacterQuestItem(
      id: 'cq2',
      gameId: '1',
      characterId: 'c1',
      category: QuestCategory.weekly,
      name: '데미안',
    ),
    CharacterQuestItem(
      id: 'cq3',
      gameId: '1',
      characterId: 'c2',
      category: QuestCategory.weekly,
      name: '루시드',
    ),
    CharacterQuestItem(
      id: 'cq4',
      gameId: '1',
      characterId: 'c2',
      category: QuestCategory.weekly,
      name: '윌',
    ),
    CharacterQuestItem(
      id: 'cq5',
      gameId: '1',
      characterId: 'c1',
      category: QuestCategory.monthly,
      name: '검은마법사',
    ),
    CharacterQuestItem(
      id: 'cq6',
      gameId: '1',
      characterId: 'c1',
      category: QuestCategory.goal,
      name: '자석펫 구매',
      dueDate: DateTime.now(),
      memo: '150억 모으기',
    ),
  ];
  final List<QuestLog> _questLogs = [
    QuestLog(
      id: 'q0',
      questItemId: 'd1',
      characterId: 'c1',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
    QuestLog(
      id: 'q1',
      questItemId: 'd1',
      characterId: 'c2',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
    QuestLog(
      id: 'q2',
      questItemId: 'cq1',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
    QuestLog(
      id: 'q3',
      questItemId: 'cq4',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
    QuestLog(
      id: 'q4',
      questItemId: 'cq5',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
    QuestLog(
      id: 'q5',
      questItemId: 'cq6',
      periodDate: DateTime.now(),
      isCompleted: true,
    ),
  ];

  List<Game> get games {
    return UnmodifiableListView(_games);
  }

  Future<void> addGame(Game game) async {
    _games.add(game);
    notifyListeners();
  }

  Future<void> deleteGame(String gameId) async {
    _games.removeWhere((g) => g.id == gameId);
    notifyListeners();
  }

  void updateGame(String gameId, Game newGame) {
    final idx = _games.indexWhere((g) => g.id == gameId);
    if (idx != -1) {
      _games[idx] = newGame;
      notifyListeners();
    }
  }

  List<Character> characters(String id) {
    List<Character> list = [];
    for (int i = 0; i < _characters.length; i++) {
      if (_characters[i].gameId == id) list.add(_characters[i]);
    }
    return UnmodifiableListView(list);
  }

  Future<void> addCharacter(Character character) async {
    _characters.add(character);
    notifyListeners();
  }

  void updateCharacterName(String characterId, String newName) {
    final idx = _characters.indexWhere((c) => c.id == characterId);
    if (idx != -1) {
      _characters[idx] = Character(
        id: characterId,
        gameId: _characters[idx].gameId,
        name: newName,
      );
      notifyListeners();
    }
  }

  void deleteCharacterById(String characterId) {
    _characters.removeWhere((c) => c.id == characterId);
    _characterQuests.removeWhere(
      (q) => q.characterId == characterId,
    ); // 캐릭터 삭제 시 딸린 퀘스트도 정리
    notifyListeners();
  }

  List<DailyQuestItem> dailyQuests(String id) {
    List<DailyQuestItem> list = [];
    for (int i = 0; i < _dailyQuests.length; i++) {
      if (_dailyQuests[i].gameId == id) list.add(_dailyQuests[i]);
    }
    return UnmodifiableListView(list);
  }

  Future<void> addDaily(DailyQuestItem dailyQuest) async {
    _dailyQuests.add(dailyQuest);
    notifyListeners();
  }

  void updateDailyQuestName(String dailyId, String newName) {
    final idx = _dailyQuests.indexWhere((d) => d.id == dailyId);
    if (idx != -1) {
      _dailyQuests[idx] = DailyQuestItem(
        id: dailyId,
        gameId: _dailyQuests[idx].gameId,
        name: newName,
      );
      notifyListeners();
    }
  }

  void deleteDailyById(String dailyId) {
    _dailyQuests.removeWhere((d) => d.id == dailyId);
    notifyListeners();
  }

  List<CharacterQuestItem> characterQuests(String id) {
    List<CharacterQuestItem> list = [];
    for (int i = 0; i < _characterQuests.length; i++) {
      if (_characterQuests[i].gameId == id) list.add(_characterQuests[i]);
    }
    return UnmodifiableListView(list);
  }

  List<CharacterQuestItem> weeklyQuests(
    String id,
    List<Character> characters,
    int index,
  ) {
    List<CharacterQuestItem> _weekQuests = [];
    for (CharacterQuestItem quest in _characterQuests) {
      if (quest.category == QuestCategory.weekly &&
          quest.gameId == id &&
          quest.characterId == characters[index].id)
        _weekQuests.add(quest);
    }
    return UnmodifiableListView(_weekQuests);
  }

  List<CharacterQuestItem> monthlyQuests(
    String id,
    List<Character> characters,
    int index,
  ) {
    List<CharacterQuestItem> _monthlyQuests = [];
    for (CharacterQuestItem quest in _characterQuests) {
      if (quest.category == QuestCategory.monthly &&
          quest.gameId == id &&
          quest.characterId == characters[index].id)
        _monthlyQuests.add(quest);
    }
    return UnmodifiableListView(_monthlyQuests);
  }

  List<CharacterQuestItem> goalQuests(
    String id,
    List<Character> characters,
    int index,
  ) {
    List<CharacterQuestItem> _goalQuests = [];
    for (CharacterQuestItem quest in _characterQuests) {
      if (quest.category == QuestCategory.goal &&
          quest.gameId == id &&
          quest.characterId == characters[index].id)
        _goalQuests.add(quest);
    }
    return UnmodifiableListView(_goalQuests);
  }

  Future<void> addCharacterQuest(CharacterQuestItem characterQuest) async {
    _characterQuests.add(characterQuest);
    notifyListeners();
  }

  void updateCharacterQuest(
    String questId, {
    required String name,
    String? memo,
    DateTime? dueDate,
  }) {
    final idx = _characterQuests.indexWhere((q) => q.id == questId);
    if (idx != -1) {
      final old = _characterQuests[idx];
      _characterQuests[idx] = CharacterQuestItem(
        id: old.id,
        gameId: old.gameId,
        characterId: old.characterId,
        category: old.category,
        name: name,
        memo: memo,
        dueDate: dueDate,
      );
      notifyListeners();
    }
  }

  void deleteCharacterQuestById(String questId) {
    _characterQuests.removeWhere((q) => q.id == questId);
    notifyListeners();
  }

  QuestLog? questLogs(String questItemId, {String? characterId}) {
    for (final log in _questLogs) {
      if (log.questItemId == questItemId && log.characterId == characterId) {
        return log;
      }
    }
    return null;
  }

  Future<void> addQuestLog(QuestLog questLog) async {
    _questLogs.add(questLog);
    notifyListeners();
  }

  void updateQuestLog(
    String questItemId,
    bool isCompleted,
    String? characterId,
  ) {
    final idx = _questLogs.indexWhere(
      (q) => q.questItemId == questItemId && q.characterId == characterId,
    );
    if (idx != -1) {
      final old = _questLogs[idx];
      _questLogs[idx] = QuestLog(
        id: old.id,
        questItemId: old.questItemId,
        characterId: old.characterId,
        periodDate: old.periodDate,
        isCompleted: isCompleted,
      );
    } else {
      _questLogs.add(
        QuestLog(
          id: const Uuid().v4(),
          questItemId: questItemId,
          characterId: characterId,
          periodDate: DateTime.now(), // 임시, 실제로는 카테고리별 periodDate 계산 필요
          isCompleted: isCompleted,
        ),
      );
    }
    notifyListeners();
  }
}
