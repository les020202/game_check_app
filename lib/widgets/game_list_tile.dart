import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../dialogs/game_delete_dialog.dart';
import '../models/character.dart';
import '../models/day_quest_status.dart';
import '../models/game.dart';
import '../theme/app_colors.dart';
import '../utils/quest_period.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/game_provider.dart';
import 'questProgressBadge.dart';

class GameListTile extends StatelessWidget {
  const GameListTile({super.key});

  // 상태 색(파랑/주황/빨강)과 겹치지 않는 아바타 팔레트
  static const _accents = <MaterialColor>[
    Colors.indigo,
    Colors.teal,
    Colors.deepPurple,
    Colors.blueGrey,
  ];

  // 게임 id 기준으로 색 고정 (game.id가 String이 아니면 game.id.toString()으로)
  MaterialColor _accentOf(Game game) {
    final sum = game.id.codeUnits.fold<int>(0, (a, b) => a + b);
    return _accents[sum % _accents.length];
  }

  Map<String, DayQuestStatus> _questStatusOf(
    GameProvider gp,
    Game game,
    List<Character> characters,
  ) {
    final result = <String, DayQuestStatus>{};
    final dailyQuests = gp.dailyQuests(game.id);
    if (dailyQuests.isEmpty) return result;

    final todayPeriod = todayPeriodFor(game);
    for (final character in characters) {
      final allDone = dailyQuests.every(
        (item) =>
            gp
                .questLogs(
                  item.id,
                  characterId: character.id,
                  periodDate: todayPeriod,
                )
                ?.isCompleted ==
            true,
      );
      result[character.id] =
          allDone ? DayQuestStatus.complete : DayQuestStatus.incomplete;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<GameProvider>(
      builder: (context, gp, child) {
        final games = gp.games;

        if (games.isEmpty) {
          return Center(
            child: Text(
              '아직 등록된 게임이 없어요\n아래 버튼으로 첫 게임을 추가해 보세요',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: games.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final game = games[index];
            final characters = gp.characters(game.id);
            final questStatus = _questStatusOf(gp, game, characters);
            final accent = _accentOf(game);
            final initial = game.name.isEmpty
                ? '?'
                : String.fromCharCode(game.name.runes.first);

            return Material(
              color: AppColors.card,
              elevation: 1,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () =>
                    context.push('/game_main_page/game_detail_page/$index'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accent.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          initial,
                          style: textTheme.titleLarge?.copyWith(
                            color: accent.shade600,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              game.gameType.name,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      QuestProgressBadge(
                        questStatus: questStatus,
                        characters: characters,
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: colorScheme.outline),
                        onSelected: (value) async {
                          if (value != 'delete') return;
                          final confirmed = await showGameDeleteDialog(
                            context,
                            game.id,
                          );
                          if (confirmed == true && context.mounted) {
                            showSnackBar(context, '삭제되었습니다.');
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Text('삭제', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}