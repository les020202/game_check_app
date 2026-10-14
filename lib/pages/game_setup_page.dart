import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../dialogs/game_template_picker.dart';
import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/editable_quest_item.dart';
import '../models/game.dart';
import '../models/game_template.dart';
import '../models/game_type.dart';
import '../models/quest_category.dart';
import '../models/weekday.dart';
import '../services/firebase_auth_service.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dotted_button.dart';
import '../theme/app_colors.dart';

class GameSetupPage extends StatefulWidget {
  final int? gamesIndex;
  const GameSetupPage({super.key, this.gamesIndex});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuthProvider(FirebaseAuthService());

  bool _isLoading = false;
  int _templateGeneration = 0;
  final weekList = ['월', '화', '수', '목', '금', '토', '일'];

  int weekSelectedIndex = 1;
  bool isDailyChecked = false;
  bool isChracterChecked = false;

  String? selectedCharacterId;
  final uuid = Uuid();
  String? gameId;
  bool isEditing = false;

  String? newUserId;
  String? newGameName;
  List<bool> isTypeChecked = [true, false];
  int? newGameResetHour;
  int? newGameResetMinute;
  int? newGoalMonth;
  int? newGoalDay;

  List<String> newCharacterIds = [];
  List<String> newCharacterName = [];
  List<EditableQuestItem> dailyQuests = [];
  Map<String, List<EditableQuestItem>> weeklyQuestsByCharacter = {};
  Map<String, List<EditableQuestItem>> monthlyQuestsByCharacter = {};
  Map<String, List<EditableQuestItem>> goalQuestsByCharacter = {};

  Set<String> originalDailyIds = {};
  Set<String> originalCharacterIds = {};
  Set<String> originalCharacterQuestIds = {};

  FixedExtentScrollController _hourController = FixedExtentScrollController();
  FixedExtentScrollController _minuteController = FixedExtentScrollController();

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isEditing = widget.gamesIndex != null;

    if (isEditing) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingGame());
    } else {
      gameId = uuid.v4();
      final firstId = uuid.v4();
      newCharacterIds.add(firstId);
      newCharacterName.add('캐릭터');
      weeklyQuestsByCharacter[firstId] = [];
      monthlyQuestsByCharacter[firstId] = [];
      goalQuestsByCharacter[firstId] = [];
      selectedCharacterId = firstId;
    }
  }

  Future<void> _loadExistingGame() async {
    final gp = Provider.of<GameProvider>(context, listen: false);

    if (gp.games.length <= widget.gamesIndex!) {
      await gp.loadGames();
    }
    final game = gp.games[widget.gamesIndex!];
    gameId = game.id;

    await gp.loadDailyQuests(game.id);
    await gp.loadCharacters(game.id);
    await gp.loadCharacterQuests(game.id);

    newGameName = game.name;
    isTypeChecked = game.gameType == GameType.rpg
        ? [true, false]
        : [false, true];
    newGameResetHour = game.gameResetHour;
    newGameResetMinute = game.gameResetMinute;
    _hourController.dispose();
    _minuteController.dispose();
    _hourController = FixedExtentScrollController(
      initialItem: game.gameResetHour,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: game.gameResetMinute,
    );
    weekSelectedIndex = game.weeklyResetWeekday.value;

    final allDailyQuests = gp.dailyQuests(game.id);
    dailyQuests = allDailyQuests
        .map((q) => EditableQuestItem(id: q.id, name: q.name))
        .toList();
    originalDailyIds = allDailyQuests.map((q) => q.id).toSet();

    final characters = gp.characters(game.id);
    originalCharacterIds = characters.map((c) => c.id).toSet();

    final allCharacterQuests = gp.characterQuests(game.id);
    originalCharacterQuestIds = allCharacterQuests.map((q) => q.id).toSet();

    for (final c in characters) {
      newCharacterIds.add(c.id);
      newCharacterName.add(c.name);

      weeklyQuestsByCharacter[c.id] = allCharacterQuests
          .where(
            (q) => q.category == QuestCategory.weekly && q.characterId == c.id,
          )
          .map((q) => EditableQuestItem(id: q.id, name: q.name))
          .toList();

      monthlyQuestsByCharacter[c.id] = allCharacterQuests
          .where(
            (q) => q.category == QuestCategory.monthly && q.characterId == c.id,
          )
          .map((q) => EditableQuestItem(id: q.id, name: q.name))
          .toList();

      goalQuestsByCharacter[c.id] = allCharacterQuests
          .where(
            (q) => q.category == QuestCategory.goal && q.characterId == c.id,
          )
          .map(
            (q) => EditableQuestItem(
              id: q.id,
              name: q.name,
              memo: q.memo,
              dueMonth: q.dueDate?.month,
              dueDay: q.dueDate?.day,
            ),
          )
          .toList();
    }

    if (characters.isNotEmpty) {
      selectedCharacterId = characters.first.id;
    } else {
      final firstId = uuid.v4();
      newCharacterIds.add(firstId);
      newCharacterName.add('');
      weeklyQuestsByCharacter[firstId] = [];
      monthlyQuestsByCharacter[firstId] = [];
      goalQuestsByCharacter[firstId] = [];
      selectedCharacterId = firstId;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _applyTemplate(GameTemplate template) {
    //템플릿 폼 상태 채우기
    setState(() {
      _templateGeneration++;
      newGameName = template.gameName;
      isTypeChecked = template.gameType == GameType.rpg
          ? [true, false]
          : [false, true];
      newGameResetHour = template.gameResetHour;
      newGameResetMinute = template.gameResetMinute;
      weekSelectedIndex = template.weeklyResetWeekday.value;

      isDailyChecked = template.dailyItems.isEmpty;
      dailyQuests = template.dailyItems
          .map((d) => EditableQuestItem(name: d.name))
          .toList();

      final newId = uuid.v4();
      newCharacterIds = [newId];
      newCharacterName = [template.gameType == GameType.rpg ? '캐릭터' : '계정'];

      weeklyQuestsByCharacter = {
        newId: template.characterTemplate.weeklyItems
            .map((q) => EditableQuestItem(name: q.name))
            .toList(),
      };
      monthlyQuestsByCharacter = {
        newId: template.characterTemplate.monthlyItems
            .map((q) => EditableQuestItem(name: q.name))
            .toList(),
      };
      goalQuestsByCharacter = {
        newId: template.characterTemplate.goalItems.map((q) {
          final due = q.dueDateOffsetDays != null
              ? DateTime.now().add(Duration(days: q.dueDateOffsetDays!))
              : DateTime.now();
          return EditableQuestItem(
            name: q.name,
            memo: q.memo,
            dueMonth: due.month,
            dueDay: due.day,
          );
        }).toList(),
      };
      selectedCharacterId = newId;

      isChracterChecked =
          template.characterTemplate.weeklyItems.isEmpty &&
          template.characterTemplate.monthlyItems.isEmpty &&
          template.characterTemplate.goalItems.isEmpty;
    });
    if (_hourController.hasClients) {
      _hourController.jumpToItem(template.gameResetHour);
      _minuteController.jumpToItem(template.gameResetMinute);
    }
  }

  Future<void> _save() async {
    final gp = Provider.of<GameProvider>(context, listen: false);

    final newGame = Game(
      id: gameId,
      userId: newUserId,
      name: newGameName ?? 'noName',
      gameType: isTypeChecked[0] ? GameType.rpg : GameType.mobile,
      gameResetHour: newGameResetHour ?? 0,
      gameResetMinute: newGameResetMinute ?? 0,
      weeklyResetWeekday: Weekday.fromValue(weekSelectedIndex),
      createdAt: isEditing
          ? gp.games[widget.gamesIndex!].createdAt
          : DateTime.now(),
    );

    if (isEditing) {
      await gp.updateGame(gp.games[widget.gamesIndex!].id, newGame);
    } else {
      await gp.addGame(newGame);
    }

    final dailyQuestsToSave = isDailyChecked
        ? <EditableQuestItem>[]
        : dailyQuests;
    final weeklyToSave = isChracterChecked
        ? <String, List<EditableQuestItem>>{}
        : weeklyQuestsByCharacter;
    final monthlyToSave = isChracterChecked
        ? <String, List<EditableQuestItem>>{}
        : monthlyQuestsByCharacter;
    final goalToSave = isChracterChecked
        ? <String, List<EditableQuestItem>>{}
        : goalQuestsByCharacter;

    // --- 일일 퀘스트 diff ---
    if (isEditing) {
      final currentDailyIds = dailyQuestsToSave
          .where((e) => e.id != null)
          .map((e) => e.id!)
          .toSet();
      final removedDailyIds = originalDailyIds.difference(currentDailyIds);
      for (final id in removedDailyIds) {
        await gp.deleteDailyById(id);
      }
    }
    for (final item in dailyQuestsToSave) {
      if (item.id != null) {
        await gp.updateDailyQuestName(item.id!, item.name);
      } else {
        await gp.addDaily(
          DailyQuestItem(id: uuid.v4(), gameId: gameId!, name: item.name),
        );
      }
    }

    // --- 캐릭터 diff ---
    if (isEditing) {
      final currentCharacterIds = newCharacterIds.toSet();
      final removedCharacterIds = originalCharacterIds.difference(
        currentCharacterIds,
      );
      for (final id in removedCharacterIds) {
        await gp.deleteCharacterById(id, reload: false);
      }
      if (removedCharacterIds.isNotEmpty) {
        await gp.loadCharacters(gameId!);
        await gp.loadCharacterQuests(gameId!);
      }
    }
    for (int i = 0; i < newCharacterIds.length; i++) {
      final id = newCharacterIds[i];
      if (isEditing && originalCharacterIds.contains(id)) {
        await gp.updateCharacterName(id, newCharacterName[i]);
      } else {
        await gp.addCharacter(
          Character(id: id, gameId: gameId!, name: newCharacterName[i]),
        );
      }
    }

    // --- 캐릭터 퀘스트(weekly+monthly+goal) diff ---
    final allCurrentQuestIds = <String>{};

    Future<void> syncQuestList(
      Map<String, List<EditableQuestItem>> byCharacter,
      QuestCategory category,
    ) async {
      for (final characterId in byCharacter.keys) {
        // 이미 삭제된 캐릭터에 딸린 항목은 건너뜀 (deleteCharacterById가 이미 정리함)
        if (!newCharacterIds.contains(characterId)) continue;

        for (final item in byCharacter[characterId]!) {
          if (item.id != null) {
            allCurrentQuestIds.add(item.id!);
            await gp.updateCharacterQuest(
              item.id!,
              name: item.name,
              memo: item.memo,
              dueDate: (item.dueMonth != null && item.dueDay != null)
                  ? DateTime(DateTime.now().year, item.dueMonth!, item.dueDay!)
                  : null,
              reload: false,
            );
          } else {
            await gp.addCharacterQuest(
              CharacterQuestItem(
                id: uuid.v4(),
                gameId: gameId!,
                characterId: characterId,
                category: category,
                name: item.name,
                memo: item.memo,
                dueDate: (item.dueMonth != null && item.dueDay != null)
                    ? DateTime(
                        DateTime.now().year,
                        item.dueMonth!,
                        item.dueDay!,
                      )
                    : null,
              ),
              reload: false,
            );
          }
        }
      }
    }

    await syncQuestList(weeklyToSave, QuestCategory.weekly);
    await syncQuestList(monthlyToSave, QuestCategory.monthly);
    await syncQuestList(goalToSave, QuestCategory.goal);

    if (isEditing) {
      final removedQuestIds = originalCharacterQuestIds.difference(
        allCurrentQuestIds,
      );
      // 캐릭터 삭제로 이미 정리된 퀘스트는 제외
      final existingQuestIds = gp
          .characterQuests(gameId!)
          .map((q) => q.id)
          .toSet();
      for (final id in removedQuestIds.where(existingQuestIds.contains)) {
        await gp.deleteCharacterQuestById(id, reload: false);
      }
    }
    await gp.loadCharacterQuests(gameId!);
    if (context.mounted) context.go('/game_main_page');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: newGameName ?? (isEditing ? '게임 설정' : '새 게임 추가'),
      ),
      // 스크롤 없이 항상 보이는 저장 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: CustomButton(
            customText: '설정 완료',
            backgroundColors: colorScheme.primary,
            fontStyle: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
            onPressed: _save,
          ),
        ),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. 기본 정보 ──
                  _card(
                    title: '기본 정보',
                    children: [
                      TextFormField(
                        key: ValueKey('game_name_$_templateGeneration'),
                        initialValue: newGameName,
                        onChanged: (v) => newGameName = v,
                        decoration: _inputDecoration('게임 이름을 입력하세요.'),
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          _typeCard(
                            'RPG',
                            '캐릭터 여러 개',
                            isTypeChecked[0],
                            () => setState(() => isTypeChecked = [true, false]),
                          ),
                          _typeCard(
                            '모바일 게임',
                            '계정 1개',
                            isTypeChecked[1],
                            () => setState(() => isTypeChecked = [false, true]),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final currentType = isTypeChecked[0]
                                ? GameType.rpg
                                : GameType.mobile;
                            final template = await showGameTemplatePicker(
                              context,
                              currentType,
                              textTheme,
                              colorScheme,
                            );
                            if (template != null) _applyTemplate(template);
                          },
                          icon: const Icon(Icons.list_alt, size: 18),
                          label: const Text('템플릿 불러오기'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(46),
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── 2. 게임 초기화 설정 ──
                  _card(
                    title: '게임 초기화 설정',
                    children: [
                      if (isEditing)
                        Text(
                          '설정을 바꾸면 오늘/이번 주 체크가 풀려 보일 수 있어요.',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      Text(
                        '초기화 시간',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: _hourController,
                                itemExtent: 32,
                                onSelectedItemChanged: (int index) {
                                  setState(() => newGameResetHour = index);
                                },
                                children: List.generate(24, (index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const Text(':', style: TextStyle(fontSize: 24)),
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: _minuteController,
                                itemExtent: 32,
                                onSelectedItemChanged: (int index) {
                                  setState(() => newGameResetMinute = index);
                                },
                                children: List.generate(60, (index) {
                                  return Center(
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '주간 초기화 요일',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ...getWeekButton(colorScheme),
                    ],
                  ),

                  // ── 3. 일일 퀘스트 ──
                  _card(
                    children: [
                      getCheckBox(
                        textTheme,
                        '일일 퀘스트 종류',
                        isDailyChecked,
                        (value) => setState(() => isDailyChecked = value),
                      ),
                      if (!isDailyChecked)
                        ..._questInputs(
                          dailyQuests,
                          'daily_$_templateGeneration',
                          '일일 퀘스트를 입력하세요.',
                        ),
                      if (!isDailyChecked)
                        CustomDottedButton(
                          customText: '+ 일일 퀘스트 추가',
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          height: 44,
                          onPressed: () {
                            setState(() {
                              dailyQuests.add(EditableQuestItem(name: ''));
                            });
                          },
                        ),
                    ],
                  ),

                  // ── 4. 캐릭터별 설정 ──
                  _card(
                    children: [
                      getCheckBox(
                        textTheme,
                        '캐릭터별 설정',
                        isChracterChecked,
                        (value) => setState(() => isChracterChecked = value),
                      ),
                      Text(
                        '캐릭터별로 주/월 퀘스트와 목표를 설정할 수 있어요.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      ...getCharacterButton(colorScheme),
                      if (!isChracterChecked) ...[
                        const Divider(height: 8, color: AppColors.bg),

                        Text(
                          '주간 퀘스트',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ..._questInputs(
                          weeklyQuestsByCharacter[selectedCharacterId!]!,
                          'weekly_${_templateGeneration}_$selectedCharacterId',
                          '주간 퀘스트를 입력하세요.',
                        ),
                        CustomDottedButton(
                          customText: '+ 주간 퀘스트 추가',
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          height: 44,
                          onPressed: () {
                            setState(() {
                              weeklyQuestsByCharacter[selectedCharacterId!]!
                                  .add(EditableQuestItem(name: ''));
                            });
                          },
                        ),

                        Text(
                          '월간 퀘스트',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ..._questInputs(
                          monthlyQuestsByCharacter[selectedCharacterId!]!,
                          'monthly_${_templateGeneration}_$selectedCharacterId',
                          '월간 퀘스트를 입력하세요.',
                        ),
                        CustomDottedButton(
                          customText: '+ 월간 퀘스트 추가',
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          height: 44,
                          onPressed: () {
                            setState(() {
                              monthlyQuestsByCharacter[selectedCharacterId!]!
                                  .add(EditableQuestItem(name: ''));
                            });
                          },
                        ),

                        Text(
                          '목표',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ...getTargetlyInputText(colorScheme),
                        CustomDottedButton(
                          customText: '+ 목표 추가',
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          height: 44,
                          onPressed: () {
                            setState(() {
                              goalQuestsByCharacter[selectedCharacterId!]!.add(
                                EditableQuestItem(
                                  name: '',
                                  memo: '',
                                  dueMonth: DateTime.now().month,
                                  dueDay: DateTime.now().day,
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 입력창 공통 스타일
  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    final primary = Theme.of(context).colorScheme.primary;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      filled: true,
      fillColor: AppColors.bg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  // 섹션 카드
  Widget _card({String? title, required List<Widget> children}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          if (title != null)
            Text(
              title,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ...children,
        ],
      ),
    );
  }

  // 게임 유형 선택 카드
  Widget _typeCard(
    String title,
    String sub,
    bool selected,
    VoidCallback onTap,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? cs.primary.withValues(alpha: 0.08) : AppColors.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? cs.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: selected ? cs.primary : null,
                ),
              ),
              Text(sub, style: tt.bodySmall?.copyWith(color: cs.outline)),
            ],
          ),
        ),
      ),
    );
  }

  // 퀘스트 이름 입력창 목록 (일일/주간/월간 공통)
  // keyPrefix 예: 일일 'daily_$_templateGeneration'
  //               주간 'weekly_${_templateGeneration}_$selectedCharacterId'
  List<Widget> _questInputs(
    List<EditableQuestItem> list,
    String keyPrefix,
    String hint,
  ) {
    return [
      for (int i = 0; i < list.length; i++)
        TextFormField(
          key: ValueKey('${keyPrefix}_${list[i].id ?? 'new_$i'}'),
          initialValue: list[i].name,
          onChanged: (String name) => list[i].name = name,
          decoration: _inputDecoration(
            hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => list.removeAt(i)),
            ),
          ),
        ),
    ];
  }

  Row getCheckBox(
    TextTheme textTheme,
    String text,
    bool isChecked,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => onChanged(!isChecked)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) =>
                    setState(() => onChanged(value ?? false)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Text(
                text == '캐릭터별 설정' ? '주간/월간/목표 없음' : '없음',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getTargetlyInputText(ColorScheme colorScheme) {
    final currentCharacterId = selectedCharacterId!;
    final currentList = goalQuestsByCharacter[currentCharacterId]!;
    List<Widget> targetQuestWidget = [];
    for (int i = 0; i < currentList.length; i++) {
      final goal = currentList[i];
      final keySuffix =
          '${_templateGeneration}_${currentCharacterId}_${goal.id ?? 'new_$i'}';
      targetQuestWidget.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            spacing: 8,
            children: [
              TextFormField(
                key: ValueKey('goal_$keySuffix'),
                initialValue: goal.name,
                onChanged: (value) => goal.name = value,
                decoration: _inputDecoration(
                  '목표를 입력하세요',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => currentList.removeAt(i)),
                  ),
                ),
              ),
              TextFormField(
                key: ValueKey('goal_memo_$keySuffix'),
                initialValue: goal.memo,
                onChanged: (value) => goal.memo = value,
                decoration: _inputDecoration('목표 내용을 자세히 입력 해주세요'),
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        key: ValueKey('goal_month_$keySuffix'),
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: (goal.dueMonth as int) - 1,
                        ),
                        onSelectedItemChanged: (int index) {
                          final selectedMonth = index + 1;
                          setState(() {
                            goal.dueMonth = selectedMonth;
                            final year = DateTime.now().year;
                            final maxDay = DateUtils.getDaysInMonth(
                              year,
                              selectedMonth,
                            );
                            if (goal.dueDay! > maxDay) {
                              goal.dueDay = maxDay;
                            }
                          });
                        },
                        children: List.generate(12, (index) {
                          return Center(
                            child: Text((index + 1).toString().padLeft(2, '0')),
                          );
                        }),
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: CupertinoPicker(
                        key: ValueKey('goal_day_$keySuffix'),
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: (goal.dueDay as int) - 1,
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() => goal.dueDay = index + 1);
                        },
                        children: List.generate(
                          DateUtils.getDaysInMonth(
                            DateTime.now().year,
                            goal.dueMonth!,
                          ),
                          (index) => Center(
                            child: Text((index + 1).toString().padLeft(2, '0')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return targetQuestWidget;
  }

  List<Widget> getWeekButton(ColorScheme colorScheme) {
    return [
      Row(
        children: List.generate(weekList.length, (index) {
          final isSelected = weekSelectedIndex == index + 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == weekList.length - 1 ? 0 : 6,
              ),
              child: GestureDetector(
                onTap: () => setState(() => weekSelectedIndex = index + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary : AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    weekList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ];
  }

  List<Widget> getCharacterButton(ColorScheme colorScheme) {
    List<Widget> chracterButton = [];
    bool isSelected;
    chracterButton.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (newCharacterName.isNotEmpty)
              ...List.generate(newCharacterName.length, (index) {
                final itemId = newCharacterIds[index];
                final isThisSelected = selectedCharacterId == itemId;
                return Padding(
                  key: ValueKey(itemId),
                  padding: EdgeInsets.only(right: 5),
                  child: InputChip(
                    label: IntrinsicWidth(
                      child: TextField(
                        controller:
                            TextEditingController(text: newCharacterName[index])
                              ..selection = TextSelection.collapsed(
                                offset: newCharacterName[index].length,
                              ),
                        onChanged: (String name) {
                          newCharacterName[index] = name;
                        },
                        onTap: () {
                          setState(() {
                            selectedCharacterId = itemId;
                          });
                        },
                        style: TextStyle(
                          fontSize: 14,
                          color: isThisSelected
                              ? colorScheme.onPrimary
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    selected: isSelected = isThisSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCharacterId = itemId;
                      });
                    },
                    showCheckmark: false,
                    labelPadding: EdgeInsets.symmetric(horizontal: 8),
                    selectedColor: colorScheme.primary,
                    backgroundColor: AppColors.bg,
                    side: BorderSide.none,
                    labelStyle: TextStyle(
                      color: isSelected ? colorScheme.onPrimary : Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        final removedId = newCharacterIds[index];
                        final wasSelected = selectedCharacterId == removedId;

                        newCharacterIds.removeAt(index);
                        newCharacterName.removeAt(index);
                        weeklyQuestsByCharacter.remove(removedId);
                        monthlyQuestsByCharacter.remove(removedId);
                        goalQuestsByCharacter.remove(removedId);

                        if (newCharacterIds.isEmpty) {
                          // 캐릭터가 하나도 없으면 빈 캐릭터 하나 새로 생성
                          final newId = uuid.v4();
                          newCharacterIds.add(newId);
                          newCharacterName.add('캐릭터');
                          weeklyQuestsByCharacter[newId] = [];
                          monthlyQuestsByCharacter[newId] = [];
                          goalQuestsByCharacter[newId] = [];
                          selectedCharacterId = newId;
                        } else if (wasSelected) {
                          // 삭제된 게 선택된 캐릭터였으면, 남은 것 중 가장 마지막 것을 자동 선택
                          selectedCharacterId = newCharacterIds.last;
                        }
                        // 삭제된 게 선택된 캐릭터가 아니었으면 selectedCharacterId는 그대로 유지 (자동으로 여전히 유효함)
                      });
                    },
                  ),
                );
              }),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DottedBorder(
                options: CircularDottedBorderOptions(
                  dashPattern: [6, 3],
                  strokeWidth: 1.5,
                  color: colorScheme.primary,
                  padding: EdgeInsets.zero,
                ),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final newId = uuid.v4();
                        newCharacterIds.add(newId);
                        newCharacterName.add('캐릭터');
                        weeklyQuestsByCharacter[newId] = [];
                        monthlyQuestsByCharacter[newId] = [];
                        goalQuestsByCharacter[newId] = [];
                        selectedCharacterId = newId;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: colorScheme.onPrimary,
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      side: BorderSide.none,
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return chracterButton;
  }
}
