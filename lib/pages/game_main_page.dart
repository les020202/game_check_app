import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/widgets/custom_app_bar.dart';
import '../models/game.dart';
import '../models/weekday.dart';
import '../widgets/custom_dotted_button.dart';
import '../widgets/questProgressBadge.dart';

class GameMainPage extends StatelessWidget {
  GameMainPage({super.key});
  final dummyGames = [
    Game(
      id: 'game_1',
      userId: null, // 로그인 전 상태
      name: '로스트아크',
      gameType: GameType.rpg,
      dailyResetHour: 6,
      dailyResetMinute: 0,
      weeklyResetWeekday: Weekday.wednesday.value, // 수요일 리셋
    ),
    Game(
      id: 'game_2',
      userId: null,
      name: '메이플스토리',
      gameType: GameType.rpg,
      dailyResetHour: 0,
      dailyResetMinute: 0,
      weeklyResetWeekday: Weekday.thursday.value, // 목요일 리셋
    ),
    Game(
      id: 'game_3',
      userId: null,
      name: '명조',
      gameType: GameType.mobile,
      dailyResetHour: 5,
      dailyResetMinute: 0,
      weeklyResetWeekday: Weekday.monday.value, // 목요일 리셋
    ),
    Game(
      id: 'game_4',
      userId: null,
      name: '젠레스존제로',
      gameType: GameType.mobile,
      dailyResetHour: 5,
      dailyResetMinute: 0,
      weeklyResetWeekday: Weekday.monday.value, // 목요일 리셋
    ),
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('내 게임',style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/game_main_page/game_detail_page');
            },
            icon: Icon(Icons.notifications_outlined, size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ...GameListTile(context, textTheme, colorScheme, dummyGames.length),
            CustomDottedButton(
              customText: '+ 게임 추가',
              onPressed: () {
                context.go('/game_main_page/game_setup_page');
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade300,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: 
                      [
                        Icon(Icons.error_outline), Text(' 표시 방식 안내'
                          ,style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,),
                        ),
                      ]
                  ),
                  Text('● RPG(멀티 캐릭터형) : 완료 캐릭터 수 / 전체 캐릭터 수 \n(예: 3/4 완료)'
                    ,style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,),
                  ),
                  Text('● 모바일 게임(단일 계정형) : 완료 / 미완료'
                    ,style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> GameListTile(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    int leng,
  ) {
    List<Widget> list = [];
    List<Color> colors = [Colors.red, Colors.blue, Colors.yellow];
    List<Color> colorsShade = [
      Colors.red.shade100,
      Colors.blue.shade100,
      Colors.yellow.shade100,
    ];
    int count = 0;
    for (int i = 0; i < leng; i++) {
      if (count % colors.length == 0) count = 0;
      list.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            tileColor: Colors.white,
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: colorsShade[count],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${dummyGames[i].name[0]}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors[count],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dummyGames[i].name}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${dummyGames[i].gameType.name}',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                QuestProgressBadge(
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                context.push('/game_main_page/game_detail_page');
              },
              icon: Icon(Icons.arrow_forward_ios),
            ), //trailing: ,
          ),
        ),
      );
      count++;
    }
    return list;
  }
}
