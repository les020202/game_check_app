import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:game_check_app/widgets/status_indicator.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../models/character_quest_item.dart';
import '../models/daily_quest_item.dart';
import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../quest_period.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/week_day_cell.dart';

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
      final List<CharacterQuestItem> weeklyQuests = gp.weeklyQuests(_game.id, _characters, ci);
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
          final log = gp.questLogs(item.id, characterId: character.id, periodDate: date);
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
          final log = gp.questLogs(item.id, characterId: character.id, periodDate: date);
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

    final endHour = _game.gameResetHour == 0 ? 23 : _game.gameResetHour - 1;
    final endMinute = _game.gameResetMinute == 0 ? 59 : _game.gameResetMinute - 1;

    return Scaffold(
      appBar: CustomAppBar(title: '주간 현황'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${weekDates.first.month}월 ${weekDates.first.day}일 ~ '
                              '${weekDates.last.month}월 ${weekDates.last.day}일',
                              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            // const Spacer(),
                            // IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios_new)),
                            // IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
                          ],
                        ),
                        Text(
                          '전체 일일퀘스트 ${_game.gameResetHour.toString().padLeft(2, '0')}:'
                          '${_game.gameResetMinute.toString().padLeft(2, '0')} ~ '
                          '$endHour:$endMinute',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            7,
                            (i) => WeekDayCell(
                              date: weekDates[i],
                              status: overallStatusMap[weekDates[i]] ?? DayQuestStatus.upcoming,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        getGuideStatus(colorScheme),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('일일 퀘스트', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _characters.length,
                          itemBuilder: (context, index) {
                            final character = _characters[index];
                            final statuses = characterDailyStatusMap[character.id] ?? [];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      character.name,
                                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  for (int i = 0; i < 7; i++)
                                    Expanded(
                                      child: Center(
                                        child: StatusIndicator(
                                          status: i < statuses.length ? statuses[i] : DayQuestStatus.upcoming,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        getGuideStatus(colorScheme),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주간 퀘스트', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _characters.length,
                          itemBuilder: (context, index) {
                            final character = _characters[index];
                            final completed = weeklyCompletedByCharacter[character.id] ?? 0;
                            final total = weeklyTotalByCharacter[character.id] ?? 0;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(character.name,
                                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                                    Text('$completed/$total 완료',
                                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  child: LinearProgressIndicator(
                                    value: total == 0 ? 0 : completed / total,
                                    backgroundColor: Colors.grey,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row getGuideStatus(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 15, height: 15,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue,
              border: Border.all(color: Colors.blue, width: 1)),
        ),
        const Text('전체 완료'),
        Container(
          width: 15, height: 15,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300,
              border: Border.all(color: Colors.blue, width: 1)),
        ),
        const Text('일부 완료'),
        Container(
          width: 15, height: 15,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        ),
        const Text('미완료'),
        DottedBorder(
          options: const CircularDottedBorderOptions(
            color: Colors.grey, strokeWidth: 1, dashPattern: [3, 2],
          ),
          child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.onPrimary),
          ),
        ),
        const Text('예정'),
      ],
    );
  }
}