import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    if (identical(_lastGp, gp)) return; // 같은 인스턴스면 무시
    _lastGp = gp;
    _isLoading = true; // setState 없이 대입 (곧 build가 이어짐)
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll(gp));
  }

  Future<void> _loadAll(GameProvider gp) async {
    try {
      await gp.reloadAll();
    } catch (e) {
      debugPrint('loadAll error: $e');
    }
    // 그 사이 Provider가 교체됐다면 새 인스턴스의 로딩이 처리하니 무시
    if (mounted && identical(_lastGp, gp)) {
      setState(() => _isLoading = false);
    }
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
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
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
                        ' 퀘스트 완료 표시 기준 안내',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '완료(파랑) : 모든 퀘스트 완료\n'
                    '부분 완료(주황) : 완료 캐릭터 수 / 전체 캐릭터 수 완료\n'
                    '미완료(빨강) : 모든 퀘스트 미완료',
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
