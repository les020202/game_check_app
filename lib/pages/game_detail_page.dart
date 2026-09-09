import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/questProgressBadge.dart';

class GameDetailPage extends StatefulWidget {
  GameDetailPage({super.key});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late DateTime _focusedDay;

  final characterList = [
    ['렌', 289],
    ['아크', 280],
    ['카인', 280],
    ['레테', 280],
  ]; //임시
  final dailyQuestList = ['일일 퀘스트', '몬스터 파크']; //임시
  final weeklyQuestList = [
    '스우(하드)',
    '데미안(하드)',
    '루시드(하드)',
    '스우(하드)',
    '데미안(하드)',
    '루시드(하드)',
    '스우(하드)',
    '데미안(하드)',
    '루시드(하드)',
    '스우(하드)',
    '데미안(하드)',
    '루시드(하드)',
  ]; //임시
  final monthlyQuestList = ['검은 마법사(하드)']; //임시
  final targetQuestList = ['자석펫 구매']; //임시

  List<bool> isCharacterChecked = [false, false, false, false];
  List<bool> isDailyChecked = [false, false]; //임시
  List<bool> isWeeklyChecked = [
    //임시
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  int? isWeeklyCheckedCount;//임시
  List<bool> isMonthlyChecked = [false]; //임시
  List<bool> isTargetChecked = [false]; //임시

  DateTime get now => DateTime.now();
  DateTime get firstDay => DateTime(now.year, now.month, 1);
  DateTime get lastDay => DateTime(now.year, now.month + 1, 0);
  String get formatted =>
      '${DateFormat('MM/dd').format(firstDay)}~${DateFormat('MM/dd').format(lastDay)}';

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    isWeeklyCheckedCount = isWeeklyChecked.where((e) => e).length;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: '메이플스토리',
        actions: [
          IconButton(
            onPressed: () {
              context.push('/game_main_page/game_setup_page');
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ), //임시 이름
      body: SafeArea(
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
                    color: Colors.white,
                  ),
                  child: TableCalendar(
                    locale: 'ko_KR',
                    firstDay: DateTime(DateTime.now().year - 1, 1, 1),
                    lastDay: DateTime(DateTime.now().year + 1, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
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
                      context.go('/game_main_page/game_detail_page/game_detail_week_page');
                    },
                  ),
                ),
                SizedBox(height: 12),
                getQuestList(
                  textTheme,
                  colorScheme,
                  '전체 일일 퀘스트',
                  '매일 00:00 초기화',
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
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: characterList.length,
                    itemBuilder: (context, index) {
                      final chracter = characterList[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isCharacterChecked[index] = !isCharacterChecked[index];
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isCharacterChecked[index]
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            constraints: BoxConstraints(minWidth: 90),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${chracter[0]}',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${chracter[1]}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
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
                          ),
                        ],
                      ),
                      getCheckList(textTheme, dailyQuestList, isDailyChecked),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                getQuestList(
                  textTheme,
                  colorScheme,
                  '주간 퀘스트',
                  '목 00:00 ~ 수 23:59',
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        child: LinearProgressIndicator(
                          value: isWeeklyCheckedCount == 0
                              ? 0
                              : isWeeklyCheckedCount! / weeklyQuestList.length,
                          backgroundColor: Colors.grey,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: weeklyQuestList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isWeeklyChecked[index] =
                                    !isWeeklyChecked[index];
                                isWeeklyCheckedCount = isWeeklyChecked
                                    .where((e) => e)
                                    .length;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isWeeklyChecked[index]
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              child: Text('${weeklyQuestList[index]}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                getQuestList(textTheme, colorScheme, '월간 퀘스트', '$formatted'),
                SizedBox(height: 12),
                getCheckList(textTheme, monthlyQuestList, isMonthlyChecked),
                SizedBox(height: 12),
                getQuestList(textTheme, colorScheme, '목표',null),
                SizedBox(height: 12),
                getCheckList(textTheme, targetQuestList, isTargetChecked),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container getQuestList(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String questType,
    String? questReset,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
              if(questReset!=null)
                Text(
                questReset,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),   
            ],
          ),
          QuestProgressBadge(textTheme: textTheme, colorScheme: colorScheme),
        ],
      ),
    );
  }

  Widget getCheckList(TextTheme textTheme, final QuestList, final isCheckeds) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: QuestList.length,
        itemBuilder: (context, index) {
          final quest = QuestList[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${quest}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              Checkbox(
                value: isCheckeds[index],
                onChanged: (isChecked) {
                  setState(() {
                    isCheckeds[index] = isChecked!;
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
