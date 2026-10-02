import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import 'drift_game_service.dart';
import 'firestore_game_service.dart';

/// 로컬(Drift) 데이터를 계정(Firestore)에 덮어쓰기
Future<void> overwriteCloudWithLocal(
  DriftGameService local,
  FirestoreGameService cloud,
) async {
  final games = await local.getGames();
  final characters = <Character>[];
  final dailys = <DailyQuestItem>[];
  final quests = <CharacterQuestItem>[];
  for (final g in games) {
    characters.addAll(await local.getCharacters(g.id));
    dailys.addAll(await local.getDailyQuests(g.id));
    quests.addAll(await local.getCharacterQuests(g.id));
  }
  final logs = await local.getAllQuestLogs();

  // 1) 먼저 업로드 (실패해도 계정의 기존 데이터는 그대로)
  await cloud.importAll(
    games: games,
    characters: characters,
    dailys: dailys,
    characterQuests: quests,
    logs: logs,
  );

  // 2) 업로드 성공 후, 로컬에 없는 기존 클라우드 게임만 삭제
  final localIds = games.map((g) => g.id).toSet();
  for (final g in await cloud.getGames()) {
    if (!localIds.contains(g.id)) {
      await cloud.deleteGame(g.id);
    }
  }
}