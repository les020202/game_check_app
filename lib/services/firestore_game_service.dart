import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game.dart';
import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/game_type.dart';
import '../models/quest_category.dart';
import '../models/quest_log.dart';
import '../models/app_user.dart';
import '../models/weekday.dart';
import 'game_service.dart';

class FirestoreGameService implements GameService {
  final FirebaseFirestore _fs;
  final String uid;

  FirestoreGameService(this.uid, {FirebaseFirestore? firestore})
    : _fs = firestore ?? FirebaseFirestore.instance;

  // ---------- 매핑 변환 함수(Map <-> Model) ----------
  Map<String, dynamic> _gameToMap(Game g) => {
    'id': g.id,
    'userId': uid,
    'name': g.name,
    'gameType': g.gameType.name, // enum → 문자열
    'gameResetHour': g.gameResetHour,
    'gameResetMinute': g.gameResetMinute,
    'weeklyResetWeekday': g.weeklyResetWeekday.value, // enum → int
    'createdAt': Timestamp.fromDate(g.createdAt),
  };

  Game _toGame(Map<String, dynamic> data) => Game(
    id: data['id'] as String,
    userId: data['userId'] as String?,
    name: data['name'] as String,
    gameType: GameType.values.byName(data['gameType'] as String),
    gameResetHour: data['gameResetHour'] as int,
    gameResetMinute: data['gameResetMinute'] as int,
    weeklyResetWeekday: Weekday.fromValue(data['weeklyResetWeekday'] as int),
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  // ---------- Character ----------
  Map<String, dynamic> _characterToMap(Character c) => {
    'id': c.id,
    'userId': uid,
    'gameId': c.gameId,
    'name': c.name,
    'createdAt': Timestamp.now(), // 정렬용 (모델에는 없음)
  };

  Character _toCharacter(Map<String, dynamic> d) => Character(
    id: d['id'] as String,
    gameId: d['gameId'] as String,
    name: d['name'] as String,
  );

  // ---------- DailyQuestItem ----------
  Map<String, dynamic> _dailyToMap(DailyQuestItem q) => {
    'id': q.id,
    'userId': uid,
    'gameId': q.gameId,
    'name': q.name,
    'createdAt': Timestamp.now(),
  };

  DailyQuestItem _toDaily(Map<String, dynamic> d) => DailyQuestItem(
    id: d['id'] as String,
    gameId: d['gameId'] as String,
    name: d['name'] as String,
  );

  // ---------- CharacterQuestItem ----------
  Map<String, dynamic> _characterQuestToMap(CharacterQuestItem q) => {
    'id': q.id,
    'userId': uid,
    'gameId': q.gameId,
    'characterId': q.characterId,
    'category': q.category.name, // enum → 문자열
    'name': q.name,
    'dueDate': q.dueDate == null ? null : Timestamp.fromDate(q.dueDate!),
    'memo': q.memo,
    'createdAt': Timestamp.now(),
  };

  CharacterQuestItem _toCharacterQuest(Map<String, dynamic> d) =>
      CharacterQuestItem(
        id: d['id'] as String,
        gameId: d['gameId'] as String,
        characterId: d['characterId'] as String,
        category: QuestCategory.values.byName(d['category'] as String),
        name: d['name'] as String,
        dueDate: (d['dueDate'] as Timestamp?)?.toDate(),
        memo: d['memo'] as String?,
      );

  // ---------- QuestLog ----------
  Map<String, dynamic> _questLogToMap(QuestLog l) => {
    'id': l.id,
    'userId': uid,
    'questItemId': l.questItemId,
    'characterId': l.characterId, // null이어도 키를 넣어야 조회됨
    'periodDate': Timestamp.fromDate(l.periodDate),
    'isCompleted': l.isCompleted,
  };

  QuestLog _toQuestLog(Map<String, dynamic> d) => QuestLog(
    id: d['id'] as String,
    questItemId: d['questItemId'] as String,
    characterId: d['characterId'] as String?,
    periodDate: (d['periodDate'] as Timestamp).toDate(),
    isCompleted: d['isCompleted'] as bool,
  );

  //정렬용 함수
  List<T> _mapSorted<T>(
    QuerySnapshot<Map<String, dynamic>> snap,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    final docs = snap.docs.toList()
      ..sort((a, b) {
        final ta = a.data()['createdAt'] as Timestamp?;
        final tb = b.data()['createdAt'] as Timestamp?;
        if (ta == null || tb == null) return 0;
        return ta.compareTo(tb);
      });
    return docs.map((d) => fromMap(d.data())).toList();
  }

  //삭제 로직
  Future<void> _deleteRefs(List<DocumentReference> refs) async {
    for (var i = 0; i < refs.length; i += 450) {
      final batch = _fs.batch();
      for (final ref in refs.skip(i).take(450)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }

  //청크로 나눠 삭제하는 헬퍼
  Future<List<DocumentReference>> _logRefsByQuestIds(List<String> ids) async {
    final refs = <DocumentReference>[];
    // whereIn은 한 번에 최대 30개
    for (var i = 0; i < ids.length; i += 30) {
      final chunk = ids.skip(i).take(30).toList();
      final snap = await _fs
          .collection('questLogs')
          .where('userId', isEqualTo: uid)
          .where('questItemId', whereIn: chunk)
          .get();
      refs.addAll(snap.docs.map((d) => d.reference));
    }
    return refs;
  }

  // ---------- Game ----------
  @override
  Future<List<Game>> getGames() async {
    try {
      final snap = await _fs
          .collection('games')
          .where('userId', isEqualTo: uid)
          .get();

      final games = snap.docs.map((doc) => _toGame(doc.data())).toList();
      games.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // 생성 순서 유지
      return games;
    } catch (e) {
      throw Exception('getGame error');
    }
  }

  @override
  Future<void> addGame(Game game) async {
    try {
      await _fs.collection('games').doc(game.id).set(_gameToMap(game));
    } catch (e) {
      throw Exception('addGame error');
    }
  }

  @override
  Future<void> updateGame(String gameId, Game game) async {
    try {
      await _fs.collection('games').doc(gameId).update(_gameToMap(game));
    } catch (e) {
      throw Exception('updateGame error');
    }
  }

  @override
  Future<void> deleteGame(String gameId) async {
    try {
      Future<QuerySnapshot<Map<String, dynamic>>> byGame(String col) => _fs
          .collection(col)
          .where('userId', isEqualTo: uid)
          .where('gameId', isEqualTo: gameId)
          .get();

      final cq = await byGame('characterQuests');
      final dailys = await byGame('dailys');
      final chars = await byGame('characters');

      final questIds = [...cq.docs, ...dailys.docs].map((d) => d.id).toList();
      final logRefs = await _logRefsByQuestIds(questIds);

      await _deleteRefs([
        ...logRefs,
        ...cq.docs.map((d) => d.reference),
        ...dailys.docs.map((d) => d.reference),
        ...chars.docs.map((d) => d.reference),
        _fs.collection('games').doc(gameId),
      ]);
    } catch (e) {
      throw Exception('deleteGame error');
    }
  }

  // Character
  @override
  Future<List<Character>> getCharacters(String gameId) async {
    try {
      final snap = await _fs
          .collection('characters')
          .where('userId', isEqualTo: uid)
          .where('gameId', isEqualTo: gameId)
          .get();
      return _mapSorted(snap, _toCharacter);
    } catch (e) {
      throw Exception('getCharacters error');
    }
  }

  @override
  Future<void> addCharacter(Character character) async {
    try {
      await _fs
          .collection('characters')
          .doc(character.id)
          .set(_characterToMap(character));
    } catch (e) {
      throw Exception('addCharacter error');
    }
  }

  @override
  Future<void> updateCharacterName(String characterId, String newName) async {
    try {
      await _fs.collection('characters').doc(characterId).update({
        'name': newName,
      });
    } catch (e) {
      throw Exception('updateCharacterName error');
    }
  }

  @override
  Future<void> deleteCharacter(String characterId) async {
    try {
      final cq = await _fs
          .collection('characterQuests')
          .where('userId', isEqualTo: uid)
          .where('characterId', isEqualTo: characterId)
          .get();
      final logsByChar = await _fs
          .collection('questLogs')
          .where('userId', isEqualTo: uid)
          .where('characterId', isEqualTo: characterId)
          .get();
      final logsByQuest = await _logRefsByQuestIds(
        cq.docs.map((d) => d.id).toList(),
      );

      // 같은 문서가 중복되지 않도록 path 기준으로 합침 (로그가 먼저 오도록 순서 유지)
      final refs = <String, DocumentReference>{
        for (final r in [
          ...logsByChar.docs.map((d) => d.reference),
          ...logsByQuest,
          ...cq.docs.map((d) => d.reference),
          _fs.collection('characters').doc(characterId),
        ])
          r.path: r,
      };

      await _deleteRefs(refs.values.toList());
    } catch (e) {
      throw Exception('deleteCharacter error');
    }
  }

  // Daily
  @override
  Future<List<DailyQuestItem>> getDailyQuests(String gameId) async {
    try {
      final snap = await _fs
          .collection('dailys')
          .where('userId', isEqualTo: uid)
          .where('gameId', isEqualTo: gameId)
          .get();
      return _mapSorted(snap, _toDaily);
    } catch (e) {
      throw Exception('fetch error');
    }
  }

  @override
  Future<void> addDailyQuest(DailyQuestItem dailyQuest) async {
    try {
      await _fs
          .collection('dailys')
          .doc(dailyQuest.id)
          .set(_dailyToMap(dailyQuest));
    } catch (e) {
      throw Exception('addDailyQuest error');
    }
  }

  @override
  Future<void> updateDailyQuestName(String dailyId, String newName) async {
    try {
      await _fs.collection('dailys').doc(dailyId).update({'name': newName});
    } catch (e) {
      throw Exception('updateDailyQuestName error');
    }
  }

  @override
  Future<void> deleteDailyById(String dailyId) async {
    try {
      final refs = await _logRefsByQuestIds([dailyId]);
      await _deleteRefs([...refs, _fs.collection('dailys').doc(dailyId)]);
    } catch (e) {
      throw Exception('deleteDailyById error');
    }
  }

  // Character quest
  @override
  Future<List<CharacterQuestItem>> getCharacterQuests(String gameId) async {
    try {
      final snap = await _fs
          .collection('characterQuests')
          .where('userId', isEqualTo: uid)
          .where('gameId', isEqualTo: gameId)
          .get();
      return _mapSorted(snap, _toCharacterQuest);
    } catch (e) {
      throw Exception('getCharacterQuests error');
    }
  }

  @override
  Future<void> addCharacterQuest(CharacterQuestItem characterQuest) async {
    try {
      await _fs
          .collection('characterQuests')
          .doc(characterQuest.id)
          .set(_characterQuestToMap(characterQuest));
    } catch (e) {
      throw Exception('addCharacterQuest error');
    }
  }

  @override
  Future<void> updateCharacterQuest(
    String questId, {
    required String name,
    String? memo,
    DateTime? dueDate,
  }) async {
    try {
      await _fs.collection('characterQuests').doc(questId).update({
        'name': name,
        'memo': memo,
        'dueDate': dueDate,
      });
    } catch (e) {
      throw Exception('updateCharacterQuest error');
    }
  }

  @override
  Future<void> deleteCharacterQuestById(String questId) async {
    try {
      final refs = await _logRefsByQuestIds([questId]);
      await _deleteRefs([
        ...refs,
        _fs.collection('characterQuests').doc(questId),
      ]);
    } catch (e) {
      throw Exception('deleteCharacterQuestById error');
    }
  }

  // Quest log
  @override
  Future<QuestLog?> getQuestLog(
    String questItemId, {
    String? characterId,
    required DateTime periodDate,
  }) async {
    try {
      final snap = await _fs
          .collection('questLogs')
          .where('userId', isEqualTo: uid)
          .where('questItemId', isEqualTo: questItemId)
          .where('characterId', isEqualTo: characterId)
          .where('periodDate', isEqualTo: Timestamp.fromDate(periodDate))
          .limit(1)
          .get();
      return snap.docs.isEmpty ? null : _toQuestLog(snap.docs.first.data());
    } catch (e) {
      throw Exception('fetch error');
    }
  }

  @override
  Future<void> upsertQuestLog(QuestLog log) async {
    await _fs.collection('questLogs').doc(log.id).set(_questLogToMap(log));
  }

  // ---------- 로그인 시 로컬 데이터 이전용 ----------
  Future<void> importAll({
    required List<Game> games,
    required List<Character> characters,
    required List<DailyQuestItem> dailys,
    required List<CharacterQuestItem> characterQuests,
    required List<QuestLog> logs,
  }) async {
    final writes = <(DocumentReference, Map<String, dynamic>)>[
      for (final g in games) (_fs.collection('games').doc(g.id), _gameToMap(g)),
      for (final c in characters)
        (_fs.collection('characters').doc(c.id), _characterToMap(c)),
      for (final d in dailys)
        (_fs.collection('dailys').doc(d.id), _dailyToMap(d)),
      for (final q in characterQuests)
        (_fs.collection('characterQuests').doc(q.id), _characterQuestToMap(q)),
      for (final l in logs)
        (_fs.collection('questLogs').doc(l.id), _questLogToMap(l)),
    ];

    // batch는 최대 500개라 450개씩 나눠서 커밋
    for (var i = 0; i < writes.length; i += 450) {
      final batch = _fs.batch();
      for (final w in writes.skip(i).take(450)) {
        batch.set(w.$1, w.$2);
      }
      await batch.commit();
    }
  }
}
