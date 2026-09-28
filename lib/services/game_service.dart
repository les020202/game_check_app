import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/game.dart';
import '../models/quest_log.dart';

abstract class GameService {
  // Game
  Future<List<Game>> getGames();
  Future<void> addGame(Game game);
  Future<void> updateGame(String gameId, Game game);
  Future<void> deleteGame(String gameId);

  // Character
  Future<List<Character>> getCharacters(String gameId);
  Future<void> addCharacter(Character character);
  Future<void> updateCharacterName(String characterId, String newName);
  Future<void> deleteCharacter(String characterId);

  // Daily
  Future<List<DailyQuestItem>> getDailyQuests(String gameId);
  Future<void> addDailyQuest(DailyQuestItem dailyQuest);
  Future<void> updateDailyQuestName(String dailyId, String newName);
  Future<void> deleteDailyById(String dailyId);

  // Character quest
  Future<List<CharacterQuestItem>> getCharacterQuests(String gameId);
  Future<void> addCharacterQuest(CharacterQuestItem characterQuest);
  Future<void> updateCharacterQuest(
    String questId, {
    required String name,
    String? memo,
    DateTime? dueDate,
  });
  Future<void> deleteCharacterQuestById(String questId);

  // Quest log
  Future<QuestLog?> getQuestLog(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  });
  Future<void> upsertQuestLog(QuestLog log);
}