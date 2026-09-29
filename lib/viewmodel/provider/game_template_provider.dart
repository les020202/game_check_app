import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/character.dart';
import '../../models/character_quest_item.dart';
import '../../models/daily_quest_item.dart';
import '../../models/game.dart';
import '../../models/game_template.dart';
import '../../models/game_type.dart';
import '../../models/quest_category.dart';
import 'game_provider.dart';
import '../../services/game_template_service.dart';

class GameTemplateProvider extends ChangeNotifier {
  final GameTemplateService _templateService;
  GameTemplateProvider(this._templateService);

  final Set<GameType> selectedGameTypes = {};
  List<GameTemplate> filteredTemplates = [];
  GameTemplate? selectedTemplate;
  bool isLoading = false;

  bool isTypeSelected(GameType type) => selectedGameTypes.contains(type);

  void toggleGameType(GameType type) {
    if (!selectedGameTypes.remove(type)) {
      selectedGameTypes.add(type);
    }
    notifyListeners();
  }

  Future<List<GameTemplate>> getTemplatesForType(GameType type) {
    return _templateService.getTemplatesByTypes({type});
  }//게임 설정 페이지에서의 템플릿

  Future<void> loadFilteredTemplates() async {
    isLoading = true;
    notifyListeners();
    filteredTemplates =
        await _templateService.getTemplatesByTypes(selectedGameTypes);
    isLoading = false;
    notifyListeners();
  }

  bool isTemplateSelected(GameTemplate template) =>
      selectedTemplate?.gameName == template.gameName;

  void selectTemplate(GameTemplate template) {
    selectedTemplate = template;
    notifyListeners();
  }

  Future<void> createGameFromSelectedTemplate(GameProvider gp) async {
    final template = selectedTemplate!;
    final uuid = const Uuid();
    final gameId = uuid.v4();

    await gp.addGame(Game(
      id: gameId,
      userId: null,
      name: template.gameName,
      gameType: template.gameType,
      gameResetHour: template.gameResetHour,
      gameResetMinute: template.gameResetMinute,
      weeklyResetWeekday: template.weeklyResetWeekday,
      createdAt: DateTime.now(),
    ));

    for (final d in template.dailyItems) {
      await gp.addDaily(
        DailyQuestItem(id: uuid.v4(), gameId: gameId, name: d.name),
      );
    }

    final characterId = uuid.v4();
    if (template.gameType == GameType.rpg) {
      await gp.addCharacter(
        Character(id: characterId, gameId: gameId, name: '캐릭터'),
      );
    }else{
      await gp.addCharacter(
        Character(id: characterId, gameId: gameId, name: '계정'),
      );
    }

    Future<void> addAll(
      List<CharacterQuestItemTemplate> items,
      QuestCategory category,
    ) async {
      for (final q in items) {
        await gp.addCharacterQuest(CharacterQuestItem(
          id: uuid.v4(),
          gameId: gameId,
          characterId: characterId,
          category: category,
          name: q.name,
          memo: q.memo,
          dueDate: q.dueDateOffsetDays != null
              ? DateTime.now().add(Duration(days: q.dueDateOffsetDays!))
              : null,
        ));
      }
    }

    await addAll(template.characterTemplate.weeklyItems, QuestCategory.weekly);
    await addAll(template.characterTemplate.monthlyItems, QuestCategory.monthly);
    await addAll(template.characterTemplate.goalItems, QuestCategory.goal);

    await gp.loadGames();
  }

  void reset() {
    selectedGameTypes.clear();
    filteredTemplates = [];
    selectedTemplate = null;
  }
}