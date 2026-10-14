import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:game_check_app/widgets/status_indicator.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../utils/quest_period.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/week_day_cell.dart';
import '../theme/app_colors.dart';

class GameDetailWeekPage extends StatefulWidget {
  final int gamesIndex;
  const GameDetailWeekPage({super.key, required this.gamesIndex});

  @override
  State<GameDetailWeekPage> createState() => _GameDetailWeekPageState();
}

class _GameDetailWeekPageState extends State<GameDetailWeekPage> {
  bool _isLoading = true;

  late Game _game;
  late DateTime weekStart;
  late List<DateTime> weekDates;

  List<Character> _characters = [];
  List<DailyQuestItem> _dailyQuests = [];

  Map<DateTime, DayQuestStatus> overallStatusMap = {};
  Map<String, List<DayQuestStatus>> characterDailyStatusMap = {};
  Map<String, int> weeklyCompletedByCharacter = {};
  Map<String, int> weeklyTotalByCharacter = {};

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    final gp = Provider.of<GameProvider>(context, listen: false);

    if (gp.games.length <= widget.gamesIndex) {
      await gp.loadGames();
    }
    _game = gp.games[widget.gamesIndex];

    weekStart = weekStartFor(_game);
    weekDates = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    await gp.loadCharacters(_game.id);
    await gp.loadDailyQuests(_game.id);
    await gp.loadCharacterQuests(_game.id);

    _characters = gp.characters(_game.id);
    _dailyQuests = gp.dailyQuests(_game.id);

    // 일일 퀘스트: 이번 주 7일 x 캐릭터마다 로드
    for (final daily in _dailyQuests) {
      for (final c in _characters) {
        for (final date in weekDates) {
          await gp.loadQuestLog(daily.id, characterId: c.id, periodDate: date);
        }
      }
    }

    // 주간 퀘스트: 캐릭터별 항목, periodDate = weekStart 하나로 통일
    for (int ci = 0; ci < _characters.length; ci++) {
      final List<CharacterQuestItem> weeklyQuests = gp.weeklyQuests(
        _game.id,
        _characters,
        ci,
      );
      for (final q in weeklyQuests) {
        await gp.loadQuestLog(q.id, periodDate: weekStart);
      }
    }

    if (!mounted) return;
    _computeStatuses(gp);
    setState(() => _isLoading = false);
  }

  void _computeStatuses(GameProvider gp) {
    final today = todayPeriodFor(_game);

    overallStatusMap = {};
    characterDailyStatusMap = {};
    weeklyCompletedByCharacter = {};
    weeklyTotalByCharacter = {};

    for (final date in weekDates) {
      if (date.isAfter(today)) {
        overallStatusMap[date] = DayQuestStatus.upcoming;
        continue;
      }
      if (_dailyQuests.isEmpty || _characters.isEmpty) {
        overallStatusMap[date] = DayQuestStatus.incomplete;
        continue;
      }
      int completeCharCount = 0;
      int anyCheckedCharCount = 0;
      for (final character in _characters) {
        int checked = 0;
        for (final item in _dailyQuests) {
          final log = gp.questLogs(
            item.id,
            characterId: character.id,
            periodDate: date,
          );
          if (log?.isCompleted == true) checked++;
        }
        if (checked == _dailyQuests.length) completeCharCount++;
        if (checked > 0) anyCheckedCharCount++;
      }
      if (completeCharCount == _characters.length) {
        overallStatusMap[date] = DayQuestStatus.complete;
      } else if (anyCheckedCharCount > 0) {
        overallStatusMap[date] = DayQuestStatus.partial;
      } else {
        overallStatusMap[date] = DayQuestStatus.incomplete;
      }
    }

    for (int ci = 0; ci < _characters.length; ci++) {
      final character = _characters[ci];

      final statuses = <DayQuestStatus>[];
      for (final date in weekDates) {
        if (date.isAfter(today)) {
          statuses.add(DayQuestStatus.upcoming);
          continue;
        }
        if (_dailyQuests.isEmpty) {
          statuses.add(DayQuestStatus.incomplete);
          continue;
        }
        int checked = 0;
        for (final item in _dailyQuests) {
          final log = gp.questLogs(
            item.id,
            characterId: character.id,
            periodDate: date,
          );
          if (log?.isCompleted == true) checked++;
        }
        if (checked == _dailyQuests.length) {
          statuses.add(DayQuestStatus.complete);
        } else if (checked > 0) {
          statuses.add(DayQuestStatus.partial);
        } else {
          statuses.add(DayQuestStatus.incomplete);
        }
      }
      characterDailyStatusMap[character.id] = statuses;

      final weeklyQuests = gp.weeklyQuests(_game.id, _characters, ci);
      int completed = 0;
      for (final q in weeklyQuests) {
        final log = gp.questLogs(q.id, periodDate: weekStart);
        if (log?.isCompleted == true) completed++;
      }
      weeklyCompletedByCharacter[character.id] = completed;
      weeklyTotalByCharacter[character.id] = weeklyQuests.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final resetTotal = _game.gameResetHour * 60 + _game.gameResetMinute;
    final endTotal = (resetTotal + 1440 - 1) % 1440; // 1분 전
    final endHour = endTotal ~/ 60;
    final endMinute = endTotal % 60;
    String two(int n) => n.toString().padLeft(2, '0');

    return Scaffold(
      appBar: CustomAppBar(title: '주간 현황'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 전체 현황 ──
                _card(
                  children: [
                    Text(
                      '${weekDates.first.month}월 ${weekDates.first.day}일 ~ '
                      '${weekDates.last.month}월 ${weekDates.last.day}일',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '전체 일일퀘스트 ${two(_game.gameResetHour)}:${two(_game.gameResetMinute)} ~ '
                      '${two(endHour)}:${two(endMinute)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        7,
                        (i) => WeekDayCell(
                          date: weekDates[i],
                          isToday: _isSameDay(
                            weekDates[i],
                            todayPeriodFor(_game),
                          ),
                          status:
                              overallStatusMap[weekDates[i]] ??
                              DayQuestStatus.upcoming,
                        ),
                      ),
                    ),
                  ],
                ),

                // ── 캐릭터별 일일 퀘스트 ──
                _card(
                  children: [
                    Text(
                      '일일 퀘스트',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    for (final character in _characters)
                      Row(
                        children: [
                          SizedBox(
                            width: 64,
                            child: Text(
                              character.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          for (int i = 0; i < 7; i++)
                            Expanded(
                              child: Center(
                                child: StatusIndicator(
                                  status:
                                      i <
                                          (characterDailyStatusMap[character.id]
                                                  ?.length ??
                                              0)
                                      ? characterDailyStatusMap[character
                                            .id]![i]
                                      : DayQuestStatus.upcoming,
                                ),
                              ),
                            ),
                        ],
                      ),
                    const Divider(height: 1, color: AppColors.bg),
                    getGuideStatus(colorScheme),
                  ],
                ),

                // ── 캐릭터별 주간 퀘스트 ──
                _card(
                  children: [
                    Text(
                      '주간 퀘스트',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    for (final character in _characters)
                      _weeklyRow(
                        textTheme,
                        colorScheme,
                        character.name,
                        weeklyCompletedByCharacter[character.id] ?? 0,
                        weeklyTotalByCharacter[character.id] ?? 0,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
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
        children: children,
      ),
    );
  }

  Widget _weeklyRow(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String name,
    int completed,
    int total,
  ) {
    return Column(
      spacing: 6,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              total == 0 ? '퀘스트 없음' : '$completed/$total 완료',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.outline,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : completed / total,
            minHeight: 8,
            backgroundColor: AppColors.bg,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget getGuideStatus(ColorScheme colorScheme) {
    Widget item(DayQuestStatus status, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        StatusIndicator(status: status, size: 14),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        item(DayQuestStatus.complete, '전체 완료'),
        item(DayQuestStatus.partial, '일부 완료'),
        item(DayQuestStatus.incomplete, '미완료'),
        item(DayQuestStatus.upcoming, '예정'),
      ],
    );
  }
}
