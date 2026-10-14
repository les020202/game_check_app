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
import '../theme/app_colors.dart';

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
          final resetTotal = game.gameResetHour * 60 + game.gameResetMinute;
          final endTotal = (resetTotal + 1440 - 1) % 1440; // 1분 전
          final endHour = endTotal ~/ 60;
          final endMinute = endTotal % 60;

          final prevWeekdayValue = game.weeklyResetWeekday.value == 1
              ? 7
              : game.weeklyResetWeekday.value - 1;
          // 게임 기준 한 주는 시작 요일의 전날에 끝난다 (월 시작 → 일 종료)
          final endWeekday = Weekday.fromValue(prevWeekdayValue);

          String two(int n) => n.toString().padLeft(2, '0');
          final weeklyResetText =
              '${game.weeklyResetWeekday.label} ${two(game.gameResetHour)}:${two(game.gameResetMinute)} ~ '
              '${endWeekday.label} ${two(endHour)}:${two(endMinute)}';
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    _section(
                      title: '캘린더',
                      subtitle: '날짜를 누르면 주간 현황으로 이동',
                      child: TableCalendar(
                        locale: 'ko_KR',
                        firstDay: DateTime(DateTime.now().year - 1, 1, 1),
                        lastDay: DateTime(DateTime.now().year + 1, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        availableGestures: AvailableGestures.none,
                        rowHeight: 44,
                        onPageChanged: (newFocusedDay) {
                          setState(() => _focusedDay = newFocusedDay);
                        },
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          headerPadding: EdgeInsets.symmetric(vertical: 4),
                          titleTextStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            color: Colors.white,
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

                    _section(
                      title: '전체 일일 퀘스트',
                      subtitle:
                          '매일 ${two(game.gameResetHour)}:${two(game.gameResetMinute)} 초기화',
                      badge: QuestProgressBadge(
                        questStatus: questStatus,
                        characters: characters,
                      ),
                    ),

                    if (characters.isNotEmpty)
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: characters.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final selected = characterSelectedIndex == index;
                            return ChoiceChip(
                              label: Text(characters[index].name),
                              selected: selected,
                              showCheckmark: false,
                              selectedColor: colorScheme.primary,
                              backgroundColor: AppColors.card,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selected ? Colors.white : Colors.black87,
                              ),
                              onSelected: (_) {
                                setState(() => characterSelectedIndex = index);
                                _refreshCheckedMaps(
                                  gameProvider,
                                  game,
                                  characters,
                                );
                              },
                            );
                          },
                        ),
                      ),

                    _section(
                      title: '일일 퀘스트',
                      badge: QuestProgressBadge(
                        completedCount: dailyCheckedCount(dailyQuests),
                        allCount: dailyQuests.length,
                      ),
                      child: (dailyQuests.isNotEmpty && characters.isNotEmpty)
                          ? getCheckList(
                              textTheme,
                              colorScheme,
                              dailyQuests,
                              isDailyChecked,
                              characterId:
                                  characters[characterSelectedIndex].id,
                            )
                          : null,
                    ),

                    _section(
                      title: '주간 퀘스트',
                      subtitle: weeklyResetText,
                      badge: QuestProgressBadge(
                        completedCount: weeklyCheckedCount(weeklyQuests),
                        allCount: weeklyQuests.length,
                      ),
                      child: weeklyQuests.isEmpty
                          ? null
                          : Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value:
                                        weeklyCheckedCount(weeklyQuests) /
                                        weeklyQuests.length,
                                    minHeight: 8,
                                    backgroundColor: AppColors.bg,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: weeklyQuests.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 2.2,
                                      ),
                                  itemBuilder: (context, index) {
                                    final quest = weeklyQuests[index];
                                    final checked =
                                        isWeeklyChecked[quest.id] ?? false;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isWeeklyChecked[quest.id] = !checked;
                                          gameProvider.updateQuestLog(
                                            quest.id,
                                            !checked,
                                            null,
                                            _calcPeriodDate(quest.category),
                                          );
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: checked
                                              ? colorScheme.primary
                                              : AppColors.bg,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          quest.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: checked
                                                ? Colors.white
                                                : null,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),

                    _section(
                      title: '월간 퀘스트',
                      subtitle: formatted,
                      badge: QuestProgressBadge(
                        completedCount: monthlyCheckedCount(monthlyQuests),
                        allCount: monthlyQuests.length,
                      ),
                      child: monthlyQuests.isEmpty
                          ? null
                          : getCheckList(
                              textTheme,
                              colorScheme,
                              monthlyQuests,
                              isMonthlyChecked,
                            ),
                    ),

                    _section(
                      title: '목표',
                      badge: QuestProgressBadge(
                        completedCount: goalCheckedCount(goalQuests),
                        allCount: goalQuests.length,
                      ),
                      child: goalQuests.isEmpty
                          ? null
                          : getCheckList(
                              textTheme,
                              colorScheme,
                              goalQuests,
                              isGoalChecked,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 제목 + 배지 + 내용이 한 장의 카드로 묶이는 섹션
  Widget _section({
    required String title,
    String? subtitle,
    Widget? badge,
    Widget? child,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (badge != null) badge,
            ],
          ),
          if (child != null) ...[const SizedBox(height: 8), child],
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
    return Column(
      children: [
        for (int i = 0; i < quests.length; i++) ...[
          if (i > 0)
            const Divider(height: 1, thickness: 1, color: AppColors.bg),
          _checkRow(textTheme, colorScheme, quests[i], isCheckeds, characterId),
        ],
      ],
    );
  }

  Widget _checkRow(
    TextTheme textTheme,
    ColorScheme colorScheme,
    dynamic quest,
    Map<String, bool> isCheckeds,
    String? characterId,
  ) {
    final checked = isCheckeds[quest.id] ?? false;
    final isDaily = quest.runtimeType == DailyQuestItem;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _toggleQuest(quest, !checked, isCheckeds, characterId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.name,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: checked ? colorScheme.outline : null,
                      decoration: checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (!isDaily && quest.dueDate != null)
                    Text(
                      '날짜: ~ ${DateFormat('MM/dd').format(quest.dueDate)} 까지',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  if (!isDaily && quest.memo != null && quest.memo != '')
                    Text(
                      '메모: ${quest.memo}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: checked,
              shape: const CircleBorder(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (v) =>
                  _toggleQuest(quest, v ?? false, isCheckeds, characterId),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleQuest(
    dynamic quest,
    bool value,
    Map<String, bool> isCheckeds,
    String? characterId,
  ) {
    setState(() {
      isCheckeds[quest.id] = value;
      final gp = Provider.of<GameProvider>(context, listen: false);
      final isDaily = quest.runtimeType == DailyQuestItem;
      gp.updateQuestLog(
        quest.id,
        value,
        characterId,
        _calcPeriodDate(
          isDaily ? null : quest.category,
          dueDate: !isDaily && quest.category == QuestCategory.goal
              ? quest.dueDate
              : null,
        ),
      );
    });
  }
}
