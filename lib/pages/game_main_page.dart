import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_dotted_button.dart';
import '../widgets/game_list_tile.dart';


class GameMainPage extends StatelessWidget {
  const GameMainPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 게임',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/my_page/notification_settings_page');
            },
            icon: Icon(Icons.notifications_outlined, size: 30),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 20),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                child: GameListTile(),
              ),
            ),
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
                    children: [
                      Icon(Icons.error_outline),
                      Text(
                        ' 표시 방식 안내',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '● RPG(멀티 캐릭터형) : 완료 캐릭터 수 / 전체 캐릭터 수 \n    (예: 3/4 완료)',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '● 모바일 게임(단일 계정형) : 완료 / 미완료',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
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

  
}
