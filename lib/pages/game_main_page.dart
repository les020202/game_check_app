import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodel/provider/game_provider.dart';
import '../widgets/custom_dotted_button.dart';
import '../widgets/game_list_tile.dart';

class GameMainPage extends StatefulWidget {
  const GameMainPage({super.key});

  @override
  State<GameMainPage> createState() => _GameMainPageState();
}

class _GameMainPageState extends State<GameMainPage> {
  bool _isLoading = true;
  GameProvider? _lastGp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gp = Provider.of<GameProvider>(context); // 인스턴스 교체를 감지
    if (identical(_lastGp, gp)) return;
    _lastGp = gp;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll(gp));
  }

  Future<void> _loadAll(GameProvider gp) async {
    try {
      await gp.reloadAll();
    } catch (e) {
      debugPrint('loadAll error: $e');
    }
    if (mounted && identical(_lastGp, gp)) {
      setState(() => _isLoading = false);
    }
  }

  void _showGuide() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '퀘스트 완료 표시 기준',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _legendRow(AppColors.complete, '완료', '모든 퀘스트 완료'),
              _legendRow(AppColors.partial, '부분 완료', '완료 캐릭터 수 / 전체 캐릭터 수'),
              _legendRow(AppColors.incomplete, '미완료', '모든 퀘스트 미완료'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendRow(Color color, String label, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          Expanded(child: Text(desc)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내 게임',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: _showGuide,
            icon: const Icon(Icons.info_outline, size: 18),
            label: const Text('표시 기준'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.outline,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 8),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
                child: const GameListTile(),
              ),
            ),
            CustomDottedButton(
              customText: '+ 게임 추가',
              onPressed: () {
                context.go('/game_main_page/game_setup_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
