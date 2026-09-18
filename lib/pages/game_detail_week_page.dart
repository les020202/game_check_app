import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:game_check_app/widgets/status_indicator.dart';

import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../models/game_type.dart';
import '../models/weekday.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/week_day_cell.dart';

class GameDetailWeekPage extends StatefulWidget {
  const GameDetailWeekPage({super.key});

  @override
  State<GameDetailWeekPage> createState() => _GameDetailWeekPageState();
}

class _GameDetailWeekPageState extends State<GameDetailWeekPage> {
  Game game = Game(
    id: 'game_2',
    userId: null,
    name: '메이플스토리',
    gameType: GameType.rpg,
    gameResetHour: 0,
    gameResetMinute: 0,
    weeklyResetWeekday: Weekday.thursday, // 목요일 리셋
  ); //임시
  late DateTime weekStart;

  late final List<DateTime> weekDates;

  Map<DateTime, DayQuestStatus> statusMap = {}; //주간 전체 일퀘 현황

  Map<DateTime, DayQuestStatus> characterStatusMap = {}; //주간 캐릭당 일퀘 현황

  @override
  void initState() {
    super.initState();
    weekStart = getWeekStart(DateTime.now(), game.weeklyResetWeekday.value);
    weekDates = List.generate(7, (i) => weekStart.add(Duration(days: i)));

    // 임시 데이터
    statusMap = {
      weekDates[0]: DayQuestStatus.complete,
      weekDates[1]: DayQuestStatus.complete,
      weekDates[2]: DayQuestStatus.partial,
      weekDates[3]: DayQuestStatus.incomplete,
      weekDates[4]: DayQuestStatus.upcoming,
      weekDates[5]: DayQuestStatus.upcoming,
      weekDates[6]: DayQuestStatus.upcoming,
    };
    // 임시 데이터
    characterStatusMap = {
      weekDates[0]: DayQuestStatus.complete,
      weekDates[1]: DayQuestStatus.complete,
      weekDates[2]: DayQuestStatus.partial,
      weekDates[3]: DayQuestStatus.incomplete,
      weekDates[4]: DayQuestStatus.upcoming,
      weekDates[5]: DayQuestStatus.upcoming,
      weekDates[6]: DayQuestStatus.upcoming,
    };
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '주간 현황'), //임시 이름
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
                              '8월 8일 ~ 8월 14일',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_back_ios_new),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        Text('목 00:00 ~ 수 23:59 전체 일일퀘스트'),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            7,
                            (i) => WeekDayCell(
                              date: weekDates[i],
                              status:
                                  statusMap[weekDates[i]] ??
                                  DayQuestStatus.upcoming,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
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
                        Text(
                          '일일 퀘스트',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(
                                  '렌',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 12),
                                for (int i = 0; i < 7; i++)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: Center(
                                        child: StatusIndicator(
                                          status:
                                              characterStatusMap[weekDates[i]] ??
                                              DayQuestStatus.upcoming,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
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
                        Text(
                          '주간 퀘스트',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '렌',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '3/12 완료',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6,),
                                ClipRRect(
                                  child: LinearProgressIndicator(
                                    value: 3 / 12,
                                    backgroundColor: Colors.grey,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 12,),
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
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            border: Border.all(color: Colors.blue, width: 1),
          ),
        ),
        Text('전체 완료'),
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.blue, width: 1),
          ),
        ),
        Text('일부 완료'),
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        ),
        Text('미완료'),
        DottedBorder(
          options: CircularDottedBorderOptions(
            color: Colors.grey,
            strokeWidth: 1,
            dashPattern: const [3, 2],
          ),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        Text('예정'),
      ],
    );
  }

  DateTime getWeekStart(DateTime date, int weeklyResetWeekday) {
    final diff = (date.weekday - weeklyResetWeekday + 7) % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: diff));
  }
}
