import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../game_delete_dialog.dart';
import '../models/character.dart';
import '../models/daily_quest_item.dart';
import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../show_snackbar.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/questProgressBadge.dart';
import '../quest_period.dart';

class GameListTile extends StatelessWidget {
  GameListTile({super.key});

  List<Widget> list = [];
  List<Color> colors = [Colors.red, Colors.blue, Colors.yellow];
  List<Color> colorsShade = [
    Colors.red.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
  ];
  int count = 0;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        List<Game> games = gameProvider.games;
        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: games.length,
          itemBuilder: (context, index) {
            count = index % colors.length;
            Map<String, DayQuestStatus> questStatus = {};
            Game game = gameProvider.games[index];
            List<Character> characters = gameProvider.characters(game.id);
            List<DailyQuestItem> dailyQuests = gameProvider.dailyQuests(
              game.id,
            );
            final todayPeriod = todayPeriodFor(game);

            for (var character in characters) {
              int dailyCount = 0;
              int allCount = dailyQuests.length;
              for (var item in dailyQuests) {
                final log = gameProvider.questLogs(
                  item.id,
                  characterId: character.id,
                  periodDate: todayPeriod,
                );
                if (log?.isCompleted == true) dailyCount++;
              }
              if (dailyQuests.isEmpty) {
              } else if (dailyCount == allCount)
                questStatus[character.id] = DayQuestStatus.complete;
              else
                questStatus[character.id] = DayQuestStatus.incomplete;
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                tileColor: colorScheme.onPrimary,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: colorsShade[count],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${game.name[0]}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors[count],
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${game.name}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('${game.gameType.name}', style: textTheme.bodyMedium),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QuestProgressBadge(
                      textTheme: textTheme,
                      colorScheme: colorScheme,
                      questStatus: questStatus,
                      characters: characters,
                    ),
                    IconButton(
                      onPressed: () {
                        context.push('/game_main_page/game_detail_page/$index');
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                    IconButton(
                      onPressed: () async {
                        final confirmed = await showGameDeleteDialog(
                          context,
                          game.id,
                        );
                        if (confirmed == true && context.mounted) {
                          showSnackBar(context, '삭제되었습니다.');
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ), //trailing: ,
              ),
            );
          },
        );
      },
    );
  }
}
