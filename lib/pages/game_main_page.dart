import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_dotted_button.dart';
import '../widgets/game_list_tile.dart';
import '../quest_period.dart';


class GameMainPage extends StatefulWidget {
  const GameMainPage({super.key});

  @override
  State<GameMainPage> createState() => _GameMainPageState();
}

class _GameMainPageState extends State<GameMainPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _loadAll() async {
    final gp = Provider.of<GameProvider>(context, listen: false);

    await gp.loadGames();

    for (final game in gp.games) {
      await gp.loadCharacters(game.id);
      await gp.loadDailyQuests(game.id);

      final characters = gp.characters(game.id);
      final dailyQuests = gp.dailyQuests(game.id);
      final todayPeriod = todayPeriodFor(game);

      for (final daily in dailyQuests) {
        for (final character in characters) {
          await gp.loadQuestLog(daily.id, characterId: character.id, periodDate: todayPeriod,);
        }
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 게임',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        // actions: [ //알림설정 이동 부분(비활성화)
        //   IconButton(
        //     onPressed: () {
        //       context.go('/my_page/notification_settings_page');
        //     },
        //     icon: Icon(Icons.notifications_outlined, size: 30),
        //   ),
        // ],
        // actionsPadding: EdgeInsets.only(right: 20),
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
