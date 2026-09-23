import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/editable_quest_item.dart';
import '../models/game.dart';
import '../models/game_type.dart';
import '../models/quest_category.dart';
import '../models/weekday.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dotted_button.dart';

class GameSetupPage extends StatefulWidget {
  final int? gamesIndex;
  const GameSetupPage({super.key, this.gamesIndex});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
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
    isTypeChecked = game.gameType == GameType.rpg ? [true, false] : [false, true];
    newGameResetHour = game.gameResetHour;
    newGameResetMinute = game.gameResetMinute;
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
          .where((q) => q.category == QuestCategory.weekly && q.characterId == c.id)
          .map((q) => EditableQuestItem(id: q.id, name: q.name))
          .toList();

      monthlyQuestsByCharacter[c.id] = allCharacterQuests
          .where((q) => q.category == QuestCategory.monthly && q.characterId == c.id)
          .map((q) => EditableQuestItem(id: q.id, name: q.name))
          .toList();

      goalQuestsByCharacter[c.id] = allCharacterQuests
          .where((q) => q.category == QuestCategory.goal && q.characterId == c.id)
          .map((q) => EditableQuestItem(
                id: q.id,
                name: q.name,
                memo: q.memo,
                dueMonth: q.dueDate?.month,
                dueDay: q.dueDate?.day,
              ))
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

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: CustomAppBar(title: newGameName ?? '새 게임 추가'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '게임 이름',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        initialValue: newGameName,
                        onChanged: (String newName) {
                          newGameName = newName;
                        },
                        decoration: InputDecoration(
                          hintText: '게임 이름을 입력하세요.',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '게임 유형',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isTypeChecked[1] == true) {
                                  isTypeChecked[1] = false;
                                }
                                isTypeChecked[0] = !isTypeChecked[0];
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isTypeChecked[0]
                                    ? colorScheme.primary
                                    : colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'RPG',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '캐릭터 여러 개',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isTypeChecked[0] == true) {
                                  isTypeChecked[0] = false;
                                }
                                isTypeChecked[1] = !isTypeChecked[1];
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isTypeChecked[1]
                                    ? colorScheme.primary
                                    : colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '모바일 게임',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '계정 1개',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '게임 초기화 설정',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '초기화 시간',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 32,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  newGameResetHour = index;
                                });
                              },
                              children: List.generate(24, (index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                  ), // 00, 01, 02 ...
                                );
                              }),
                            ),
                          ),
                          Text(':', style: TextStyle(fontSize: 24)),
                          Expanded(
                            child: CupertinoPicker(
                              itemExtent: 32,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  newGameResetMinute = index;
                                });
                              },
                              children: List.generate(60, (index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                  ), // 00, 01, 02 ...
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '주간 초기화 요일',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ...getWeekButton(colorScheme),
                    SizedBox(height: 12),
                    getCheckBox(
                      textTheme,
                      '일일 퀘스트 종류',
                      isDailyChecked,
                      (value) => setState(() => isDailyChecked = value),
                    ),
                    if (!isDailyChecked) ...getDailyInputText('일일 퀘스트를 입력하세요.'),
                    if (!isDailyChecked)
                      CustomDottedButton(
                        customText: '+ 일일 퀘스트 추가',
                        onPressed: () {
                          setState(() {
                            dailyQuests.add(EditableQuestItem(name: ''));
                          });
                        },
                      ),
                    SizedBox(height: 12),
                    getCheckBox(
                      textTheme,
                      '캐릭터별 설정',
                      isChracterChecked,
                      (value) => setState(() => isChracterChecked = value),
                    ),
                    Text(
                      '캐릭터별로 주/월 퀘스트와 목표를 설정할 수 있어요.',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ...getCharacterButton(colorScheme),
                    SizedBox(height: 12),
                    if (!isChracterChecked)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '캐릭터 개별 설정', //'${characters[chracterSelectedIndex]} 캐릭터 개별 설정',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Divider(
                              height: 24, // 위아래 여백 포함 전체 높이
                              thickness: 1, // 선 두께
                              color: Colors.grey.shade300,
                              indent: 5, // 왼쪽 여백
                              endIndent: 5, // 오른쪽 여백
                            ),
                            Text(
                              '주간 퀘스트',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            ...getWeeklyInputText('주간 퀘스트를 입력하세요.'),
                            CustomDottedButton(
                              customText: '+ 주간 퀘스트 추가',
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
                                color: Colors.grey.shade800,
                              ),
                            ),
                            ...getMonthlyInputText('월간 퀘스트를 입력하세요.'),
                            CustomDottedButton(
                              customText: '+ 월간 퀘스트 추가',
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
                                color: Colors.grey.shade800,
                              ),
                            ),
                            ...getTargetlyInputText(colorScheme),
                            CustomDottedButton(
                              customText: '+ 목표 추가',
                              onPressed: () {
                                setState(() {
                                  goalQuestsByCharacter[selectedCharacterId!]!
                                      .add(
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
                        ),
                      ),
                    SizedBox(height: 12),
                    CustomButton(
                      customText: '설정 완료',
                      backgroundColors: colorScheme.primary,
                      fontStyle: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                      onPressed: () async{
                        final gp = Provider.of<GameProvider>(
                          context,
                          listen: false,
                        );

                        final newGame = Game(
                          id: gameId,
                          userId: newUserId,
                          name: newGameName ?? 'noName',
                          gameType: isTypeChecked[0]
                              ? GameType.rpg
                              : GameType.mobile,
                          gameResetHour: newGameResetHour ?? 0,
                          gameResetMinute: newGameResetMinute ?? 0,
                          weeklyResetWeekday: Weekday.fromValue(
                            weekSelectedIndex,
                          ),
                          createdAt: isEditing
                              ? gp.games[widget.gamesIndex!].createdAt
                              : DateTime.now(),
                        );

                        if (isEditing) {
                          await gp.updateGame(
                            gp.games[widget.gamesIndex!].id,
                            newGame,
                          );
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
                          final removedDailyIds = originalDailyIds.difference(
                            currentDailyIds,
                          );
                          for (final id in removedDailyIds) {
                            await gp.deleteDailyById(id);
                          }
                        }
                        for (final item in dailyQuestsToSave) {
                          if (item.id != null) {
                            await gp.updateDailyQuestName(item.id!, item.name);
                          } else {
                            await gp.addDaily(
                              DailyQuestItem(
                                id: uuid.v4(),
                                gameId: gameId!,
                                name: item.name,
                              ),
                            );
                          }
                        }

                        // --- 캐릭터 diff ---
                        if (isEditing) {
                          final currentCharacterIds = newCharacterIds.toSet();
                          final removedCharacterIds = originalCharacterIds
                              .difference(currentCharacterIds);
                          for (final id in removedCharacterIds) {
                            await gp.deleteCharacterById(id);
                          }
                        }
                        for (int i = 0; i < newCharacterIds.length; i++) {
                          final id = newCharacterIds[i];
                          if (isEditing && originalCharacterIds.contains(id)) {
                            await gp.updateCharacterName(id, newCharacterName[i]);
                          } else {
                            await gp.addCharacter(
                              Character(
                                id: id,
                                gameId: gameId!,
                                name: newCharacterName[i],
                              ),
                            );
                          }
                        }

                        // --- 캐릭터 퀘스트(weekly+monthly+goal) diff ---
                        final allCurrentQuestIds = <String>{};

                        Future<void> syncQuestList(
                          Map<String, List<EditableQuestItem>> byCharacter,
                          QuestCategory category,
                        ) async{
                          for (final characterId in byCharacter.keys) {
                            // 이미 삭제된 캐릭터에 딸린 항목은 건너뜀 (deleteCharacterById가 이미 정리함)
                            if (!newCharacterIds.contains(characterId))
                              continue;

                            for (final item in byCharacter[characterId]!) {
                              if (item.id != null) {
                                allCurrentQuestIds.add(item.id!);
                                await gp.updateCharacterQuest(
                                  item.id!,
                                  name: item.name,
                                  memo: item.memo,
                                  dueDate:
                                      (item.dueMonth != null &&
                                          item.dueDay != null)
                                      ? DateTime(
                                          DateTime.now().year,
                                          item.dueMonth!,
                                          item.dueDay!,
                                        )
                                      : null,
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
                                    dueDate:
                                        (item.dueMonth != null &&
                                            item.dueDay != null)
                                        ? DateTime(
                                            DateTime.now().year,
                                            item.dueMonth!,
                                            item.dueDay!,
                                          )
                                        : null,
                                  ),
                                );
                              }
                            }
                          }
                        }

                        await syncQuestList(
                          weeklyToSave,
                          QuestCategory.weekly,
                        );
                        await syncQuestList(
                          monthlyToSave,
                          QuestCategory.monthly,
                        );
                        await syncQuestList(
                          goalToSave,
                          QuestCategory.goal,
                        );

                        if (isEditing) {
                          final removedQuestIds = originalCharacterQuestIds
                              .difference(allCurrentQuestIds);
                          for (final id in removedQuestIds) {
                            await gp.deleteCharacterQuestById(id);
                          }
                        }

                        if (context.mounted) context.go('/game_main_page');
                      },
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  onChanged(value ?? false);
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            text=='캐릭터별 설정' ? Text('주간/월간/목표 없음'):Text('없음'),
          ],
        ),
      ],
    );
  }

  List<Widget> getDailyInputText(String text) {
    List<Widget> dailyQuestWidget = [];
    for (int i = 0; i < dailyQuests.length; i++) {
      dailyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            key: ValueKey('daily_${dailyQuests[i].id ?? 'new_$i'}'),
            initialValue: dailyQuests[i].name,
            onChanged: (String name) {
              dailyQuests[i].name = name;
            },
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    dailyQuests.removeAt(i);
                  });
                },
              ),
            ),
          ),
        ),
      );
    }
    return dailyQuestWidget;
  }

  List<Widget> getWeeklyInputText(String text) {
    final currentCharacterId = selectedCharacterId!;
    final currentList = weeklyQuestsByCharacter[currentCharacterId]!;
    List<Widget> weeklyQuestWidget = [];
    for (int i = 0; i < currentList.length; i++) {
      weeklyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            key: ValueKey(
              'weekly_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
            ),
            initialValue: currentList[i].name,
            onChanged: (String name) {
              currentList[i].name = name;
            },
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    currentList.removeAt(i);
                  });
                },
              ),
            ),
          ),
        ),
      );
    }
    return weeklyQuestWidget;
  }

  List<Widget> getMonthlyInputText(String text) {
    final currentCharacterId = selectedCharacterId!;
    final currentList = monthlyQuestsByCharacter[currentCharacterId]!;
    List<Widget> monthlyQuestWidget = [];
    for (int i = 0; i < currentList.length; i++) {
      monthlyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            key: ValueKey(
              'monthly_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
            ),
            initialValue: currentList[i].name,
            onChanged: (String name) {
              currentList[i].name = name;
            },
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    currentList.removeAt(i);
                  });
                },
              ),
            ),
          ),
        ),
      );
    }
    return monthlyQuestWidget;
  }

  List<Widget> getTargetlyInputText(ColorScheme colorScheme) {
    final currentCharacterId = selectedCharacterId!;
    final currentList = goalQuestsByCharacter[currentCharacterId]!;
    List<Widget> targetQuestWidget = [];
    for (int i = 0; i < currentList.length; i++) {
      final goal = currentList[i];
      targetQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              TextFormField(
                key: ValueKey(
                  'goal_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
                ),
                initialValue: goal.name,
                onChanged: (value) {
                  goal.name = value;
                },
                decoration: InputDecoration(
                  hintText: '목표를 입력하세요',
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        currentList.removeAt(i);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 6,),
              TextFormField(
                key: ValueKey(
                  'goal_memo_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
                ),
                initialValue: goal.memo,
                onChanged: (value) {
                  goal.memo = value;
                },
                decoration: InputDecoration(
                  hintText: '목표 내용을 자세히 입력 해주세요',
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              SizedBox(height: 6,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        key: ValueKey(
                          'goal_month_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
                        ),
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
                    Text(':', style: TextStyle(fontSize: 24)),
                    Expanded(
                      child: CupertinoPicker(
                        key: ValueKey(
                          'goal_day_${currentCharacterId}_${currentList[i].id ?? 'new_$i'}',
                        ),
                        itemExtent: 32,
                        scrollController: FixedExtentScrollController(
                          initialItem: (goal.dueDay as int) - 1,
                        ),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            goal.dueDay = index + 1;
                          });
                        },
                        children: List.generate(
                          DateUtils.getDaysInMonth(
                            DateTime.now().year,
                            goal.dueMonth!,
                          ),
                          (index) {
                            return Center(
                              child: Text(
                                (index + 1).toString().padLeft(2, '0'),
                              ),
                            );
                          },
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
    List<Widget> weekButton = [];
    bool isSelected;
    weekButton.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(weekList.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 1),
              child: ChoiceChip(
                label: Text(weekList[index]),
                selected: isSelected = weekSelectedIndex == index + 1,
                onSelected: (bool selected) {
                  setState(() {
                    weekSelectedIndex = index + 1;
                  });
                },
                showCheckmark: false,
                labelPadding: EdgeInsets.symmetric(horizontal: 4),
                selectedColor: colorScheme.primary,
                backgroundColor: colorScheme.onPrimary,
                labelStyle: TextStyle(
                  color: isSelected ? colorScheme.onPrimary : Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
      ),
    );
    return weekButton;
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
                          color: isThisSelected ? colorScheme.onPrimary : Colors.black,
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
                    selectedColor: Colors.blue,
                    backgroundColor: colorScheme.onPrimary,
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
                  color: Colors.blue,
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
