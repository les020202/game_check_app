import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../viewmodel/provider/firebase_auth_provider.dart';

class GameShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const GameShell({super.key, required this.navigationShell});

  @override
  State<GameShell> createState() => _GameShellState();
}

class _GameShellState extends State<GameShell> {
  String? _lastUid;
  bool _initialized = false;
  bool _homeNeedsReset = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uid = Provider.of<FirebaseAuthProvider>(context).user?.id;

    if (_initialized && uid != _lastUid) {
      if (widget.navigationShell.currentIndex == 0) {
        // 홈 탭을 보고 있는 중에 바뀐 경우는 바로 초기화
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.navigationShell.goBranch(0, initialLocation: true);
          }
        });
      } else {
        // 프로필 탭에서 바뀐 경우는 다음에 홈 탭을 누를 때 초기화
        _homeNeedsReset = true;
      }
    }
    _lastUid = uid;
    _initialized = true;
  }

  void _onTap(int index) {
    final shell = widget.navigationShell;
    final resetHome = index == 0 && _homeNeedsReset;
    if (resetHome) _homeNeedsReset = false;

    shell.goBranch(
      index,
      initialLocation: resetHome || index == shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shell = widget.navigationShell;
    // 로그인 후 context.go('/game_main_page')로 홈에 도착하면
    // 스택이 이미 새로 만들어졌으니 표시를 지움
    if (shell.currentIndex == 0) _homeNeedsReset = false;

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.onPrimary),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colorScheme.onPrimary,
        ),
      ),
      child: Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 50,
          selectedIndex: shell.currentIndex,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: _onTap,
        ),
      ),
    );
  }
}