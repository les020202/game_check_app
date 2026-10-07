import 'package:flutter/material.dart';
import 'package:game_check_app/models/quest_category.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../models/weekday.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/questProgressBadge.dart';
import '../utils/quest_period.dart';

class GameDetailPage extends StatefulWidget {
  final int gamesIndex;
  const GameDetailPage({super.key, required this.gamesIndex});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late DateTime _focusedDay;
  bool _isLoading = true;
  DateTime? _lastLoadedTodayPeriod;
  int characterSelectedIndex = 0;
  Map<String, bool> isDailyChecked = {};
  Map<String, bool> isWeeklyChecked = {};
  Map<String, bool> isMonthlyChecked = {};
  Map<String, bool> isGoalChecked = {};
  int dailyCheckedCount(List<DailyQuestItem> dailyQuests) {
    return dailyQuests.where((q) => isDailyChecked[q.id] == true).length;
  }

  int weeklyCheckedCount(List<CharacterQuestItem> weeklyQuests) {
    return weeklyQuests.where((q) => isWeeklyChecked[q.id] == true).length;
  }

  int monthlyCheckedCount(List<CharacterQuestItem> monthlyQuests) {
    return monthlyQuests.where((q) => isMonthlyChecked[q.id] == true).length;
  }

  int goalCheckedCount(List<CharacterQuestItem> goalQuests) {
    return goalQuests.where((q) => isGoalChecked[q.id] == true).length;
  }

  DateTime get now => DateTime.now();
  DateTime get firstDay => DateTime(now.year, now.month, 1);
  DateTime get lastDay => DateTime(now.year, now.month + 1, 0);
  String get formatted =>
      '${DateFormat('MM/dd').format(firstDay)}~${DateFormat('MM/dd').format(lastDay)}';

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    final gp = Provider.of<GameProvider>(context, listen: false);

    if (gp.games.length <= widget.gamesIndex) {
      await gp.loadGames();
    }
    final game = gp.games[widget.gamesIndex];

    await gp.loadCharacters(game.id);
    await gp.loadDailyQuests(game.id);
    await gp.loadCharacterQuests(game.id);

    final characters = gp.characters(game.id);
    final dailyQuests = gp.dailyQuests(game.id);
    final characterQuests = gp.characterQuests(game.id);

    // 일일퀘스트: 캐릭터별로 로그가 다르니 전부 로드
    final todayPeriod = _calcPeriodDate(null);
    for (final daily in dailyQuests) {
      for (final c in characters) {
        await gp.loadQuestLog(
          daily.id,
          characterId: c.id,
          periodDate: todayPeriod,
        );
      }
    }
    // 주간/월간/목표: characterId 없이 로드
    for (final q in characterQuests) {
      final period = _calcPeriodDate(
        q.category,
        dueDate: q.category == QuestCategory.goal ? q.dueDate : null,
      );
      await gp.loadQuestLog(q.id, periodDate: period);
    }

    if (!mounted) return;
    _refreshCheckedMaps(gp, game, characters);
    setState(() => _isLoading = false);
  }

  void _refreshCheckedMaps(
    GameProvider gp,
    Game game,
    List<Character> characters,
  ) {
    if (characters.isEmpty) return;
    if (characterSelectedIndex >= characters.length) {
      characterSelectedIndex = characters.length - 1;
    }
    List<DailyQuestItem> dailyQuests = gp.dailyQuests(game.id);
    List<CharacterQuestItem> weeklyQuests = gp.weeklyQuests(
      game.id,
      characters,
      characterSelectedIndex,
    );
    List<CharacterQuestItem> monthlyQuests = gp.monthlyQuests(
      game.id,
      characters,
      characterSelectedIndex,
    );
    List<CharacterQuestItem> goalQuests = gp.goalQuests(
      game.id,
      characters,
      characterSelectedIndex,
    );

    final currentCharacterId = characters[characterSelectedIndex].id;
    final todayPeriod = _calcPeriodDate(null);

    for (var item in dailyQuests) {
      isDailyChecked[item.id] =
          gp
              .questLogs(
                item.id,
                characterId: currentCharacterId,
                periodDate: todayPeriod,
              )
              ?.isCompleted ??
          false;
    }
    for (var item in weeklyQuests) {
      isWeeklyChecked[item.id] =
          gp
              .questLogs(item.id, periodDate: _calcPeriodDate(item.category))
              ?.isCompleted ??
          false;
    }
    for (var item in monthlyQuests) {
      isMonthlyChecked[item.id] =
          gp
              .questLogs(item.id, periodDate: _calcPeriodDate(item.category))
              ?.isCompleted ??
          false;
    }
    for (var item in goalQuests) {
      isGoalChecked[item.id] =
          gp
              .questLogs(
                item.id,
                periodDate: _calcPeriodDate(
                  item.category,
                  dueDate: item.dueDate,
                ),
              )
              ?.isCompleted ??
          false;
    }
  }

  DateTime _calcPeriodDate(QuestCategory? category, {DateTime? dueDate}) {
    final gp = Provider.of<GameProvider>(context, listen: false);
    Game game = gp.games[widget.gamesIndex];

    // 리셋 시각을 기준으로 "게임 하루"의 시작점을 계산
    final todayPeriod = todayPeriodFor(game);

    switch (category) {
      case null:
        return todayPeriod;
      case QuestCategory.weekly:
        final weekStart = weekStartFor(game);
        return DateTime(weekStart.year, weekStart.month, weekStart.day);
      case QuestCategory.monthly:
        final adjustedNow = todayPeriod;
        return DateTime(adjustedNow.year, adjustedNow.month, 1);
      case QuestCategory.goal:
        return DateTime(dueDate!.year, dueDate.month, dueDate.day);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (!_isLoading) {
      final currentTodayPeriod = _calcPeriodDate(null);
      if (_lastLoadedTodayPeriod != null &&
          !_isSameDay(_lastLoadedTodayPeriod!, currentTodayPeriod)) {
        _lastLoadedTodayPeriod = currentTodayPeriod;
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
      } else {
        _lastLoadedTodayPeriod ??= currentTodayPeriod;
      }
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: '게임 상세',
        actions: [
          IconButton(
            onPressed: () {
              context.push(
                '/game_main_page/game_setup_page?games_index=${widget.gamesIndex}',
              );
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.games.length <= widget.gamesIndex) {
            // 게임 목록이 아직 로드되지 않았거나, 로그인 전환으로 인덱스가 어긋난 상태
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/game_main_page');
            });
            return const Center(child: CircularProgressIndicator());
          }
          Game game = gameProvider.games[widget.gamesIndex];
          List<DailyQuestItem> dailyQuests = gameProvider.dailyQuests(game.id);
          List<Character> characters = gameProvider.characters(game.id);
          if (characters.isNotEmpty && // 캐릭터가 줄어서 선택 인덱스가 범위를 벗어난 경우 보정
              characterSelectedIndex >= characters.length) {
            characterSelectedIndex = characters.length - 1;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _refreshCheckedMaps(gameProvider, game, characters);
              setState(() {});
            });
          }
          List<CharacterQuestItem> weeklyQuests = gameProvider.weeklyQuests(
            game.id,
            characters,
            characterSelectedIndex,
          );
          List<CharacterQuestItem> monthlyQuests = gameProvider.monthlyQuests(
            game.id,
            characters,
            characterSelectedIndex,
          );
          List<CharacterQuestItem> goalQuests = gameProvider.goalQuests(
            game.id,
            characters,
            characterSelectedIndex,
          );
          final prevWeekdayValue = game.weeklyResetWeekday.value == 1
              ? 7
              : game.weeklyResetWeekday.value - 1;
          final prevWeekday = Weekday.fromValue(prevWeekdayValue);
          final endHour = game.gameResetHour == 0 ? 23 : game.gameResetHour - 1;
          final endMinute = game.gameResetMinute == 0
              ? 59
              : game.gameResetMinute - 1;
          final weeklyResetText =
              '${game.weeklyResetWeekday.label} ${game.gameResetHour.toString().padLeft(2, '0')}:${game.gameResetMinute.toString().padLeft(2, '0')} ~ '
              '${prevWeekday.label} $endHour:$endMinute';
          Map<String, DayQuestStatus> questStatus = {};
          final todayPeriod = _calcPeriodDate(null);
          for (var character in characters) {
            int dailyCount = 0;
            int allDailyCount = dailyQuests.length;
            for (var item in dailyQuests) {
              final log = gameProvider.questLogs(
                item.id,
                characterId: character.id,
                periodDate: todayPeriod,
              );
              if (log?.isCompleted == true) dailyCount++;
            }
            if (dailyQuests.isEmpty) {
            } else if (dailyCount == allDailyCount)
              questStatus[character.id] = DayQuestStatus.complete;
            else
              questStatus[character.id] = DayQuestStatus.incomplete;
          }
          return SafeArea(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '캘린더',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.onPrimary,
                        ),
                        child: TableCalendar(
                          locale: 'ko_KR',
                          firstDay: DateTime(DateTime.now().year - 1, 1, 1),
                          lastDay: DateTime(DateTime.now().year + 1, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: CalendarFormat.month,
                          availableGestures: AvailableGestures.none,
                          onPageChanged: (newFocusedDay) {
                            setState(() {
                              _focusedDay = newFocusedDay;
                            });
                          },
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                            titleTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            context.go(
                              '/game_main_page/game_detail_page/${widget.gamesIndex}/game_detail_week_page/${widget.gamesIndex}',
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      getQuestList(
                        textTheme,
                        colorScheme,
                        '전체 일일 퀘스트',
                        questReset:
                            '매일 ${game.gameResetHour.toString().padLeft(2, '0')}:${game.gameResetMinute.toString().padLeft(2, '0')} 초기화',
                        questStatus: questStatus,
                        characters: characters,
                      ),
                      SizedBox(height: 12),
                      Text(
                        '캐릭터',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            final chracter = characters[index];
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    characterSelectedIndex = index;
                                  });
                                  final gp = Provider.of<GameProvider>(
                                    context,
                                    listen: false,
                                  );
                                  final characters = gp.characters(game.id);
                                  _refreshCheckedMaps(gp, game, characters);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: characterSelectedIndex == index
                                        ? Colors.blue
                                        : colorScheme.onPrimary,
                                  ),
                                  constraints: BoxConstraints(minWidth: 70),
                                  child: Text(
                                    '${chracter.name}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.onPrimary,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '일일 퀘스트',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                QuestProgressBadge(
                                  textTheme: textTheme,
                                  colorScheme: colorScheme,
                                  completedCount: dailyCheckedCount(
                                    dailyQuests,
                                  ),
                                  allCount: dailyQuests.length,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      if (dailyQuests.isNotEmpty && characters.isNotEmpty)
                        getCheckList(
                          textTheme,
                          colorScheme,
                          dailyQuests,
                          isDailyChecked,
                          characterId: characters[characterSelectedIndex].id,
                        ),
                      SizedBox(height: 12),
                      getQuestList(
                        textTheme,
                        colorScheme,
                        '주간 퀘스트',
                        questReset: weeklyResetText,
                        completedcount: weeklyCheckedCount(weeklyQuests),
                        allCount: weeklyQuests.length,
                      ),
                      SizedBox(height: 12),
                      if (weeklyQuests.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.onPrimary,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                child: LinearProgressIndicator(
                                  value: weeklyQuests.isEmpty
                                      ? 0
                                      : weeklyCheckedCount(weeklyQuests) /
                                            weeklyQuests.length,
                                  backgroundColor: Colors.grey,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 12),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: weeklyQuests.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                      childAspectRatio: 2,
                                    ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final id = weeklyQuests[index].id;
                                        final newValue =
                                            !(isWeeklyChecked[id] ?? false);
                                        isWeeklyChecked[id] = newValue;
                                        gameProvider.updateQuestLog(
                                          id,
                                          newValue,
                                          null,
                                          _calcPeriodDate(
                                            weeklyQuests[index].category,
                                          ),
                                        );
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color:
                                            (isWeeklyChecked[weeklyQuests[index]
                                                    .id] ??
                                                false)
                                            ? Colors.blue
                                            : colorScheme.onPrimary,
                                      ),
                                      child: Text(
                                        '${weeklyQuests[index].name}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 12),
                      getQuestList(
                        textTheme,
                        colorScheme,
                        '월간 퀘스트',
                        questReset: '$formatted',
                        completedcount: monthlyCheckedCount(monthlyQuests),
                        allCount: monthlyQuests.length,
                      ),
                      SizedBox(height: 12),
                      if (monthlyQuests.isNotEmpty)
                        getCheckList(
                          textTheme,
                          colorScheme,
                          monthlyQuests,
                          isMonthlyChecked,
                        ),
                      SizedBox(height: 12),
                      getQuestList(
                        textTheme,
                        colorScheme,
                        '목표',
                        questReset: '$formatted',
                        completedcount: goalCheckedCount(goalQuests),
                        allCount: goalQuests.length,
                      ),
                      SizedBox(height: 12),
                      if (goalQuests.isNotEmpty)
                        getCheckList(
                          textTheme,
                          colorScheme,
                          goalQuests,
                          isGoalChecked,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container getQuestList(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String questType, {
    Map<String, DayQuestStatus>? questStatus,
    List<Character>? characters,
    String? questReset,
    int? completedcount,
    int? allCount,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.onPrimary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                questType,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (questReset != null)
                Text(
                  questReset,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          if (questType == '전체 일일 퀘스트')
            QuestProgressBadge(
              textTheme: textTheme,
              colorScheme: colorScheme,
              questStatus: questStatus,
              characters: characters,
            ),
          if (questType == '주간 퀘스트' ||
              questType == '월간 퀘스트' ||
              questType == '목표')
            QuestProgressBadge(
              textTheme: textTheme,
              colorScheme: colorScheme,
              completedCount: completedcount,
              allCount: allCount,
            ),
        ],
      ),
    );
  }

  Widget getCheckList(
    TextTheme textTheme,
    ColorScheme colorScheme,
    List<dynamic> quests,
    Map<String, bool> isCheckeds, {
    String? characterId,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.onPrimary,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${quest.name}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (quest.runtimeType != DailyQuestItem &&
                      quest.dueDate != null)
                    Text(
                      '날짜 : ~ ${DateFormat('MM/dd').format(quest.dueDate)} 까지',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (quest.runtimeType != DailyQuestItem && quest.memo != null)
                    Text(
                      '메모 : ${quest.memo}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              Checkbox(
                value: isCheckeds[quest.id] ?? false,
                onChanged: (isChecked) {
                  setState(() {
                    isCheckeds[quest.id] = isChecked!;
                    final gb = Provider.of<GameProvider>(
                      context,
                      listen: false,
                    );
                    gb.updateQuestLog(
                      quest.id,
                      isChecked,
                      characterId,
                      _calcPeriodDate(
                        quest.runtimeType == DailyQuestItem
                            ? null
                            : quest.category,
                        dueDate:
                            quest.runtimeType != DailyQuestItem &&
                                quest.category == QuestCategory.goal
                            ? quest.dueDate
                            : null,
                      ),
                    );
                  });
                },
                shape: const CircleBorder(),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
