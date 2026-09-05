import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/game_detail_page.dart';
import 'pages/game_main_page.dart';
import 'pages/game_setup_page.dart';
import 'pages/landing_page.dart';
import 'pages/my_page.dart';
import 'pages/onboarding_game_preset_page.dart';
import 'pages/onboarding_game_select_page.dart';
import 'pages/workout_shell.dart';
import 'pages/onboarding_game_type_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _homeTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final GlobalKey<NavigatorState> _profileTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profileTab');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    //GoRoute(path: '/', builder: (context, state) => LandingPage()),
    GoRoute(
      path: '/',
      builder: (context, state) => OnboardingGameTypePage(),
      routes: [
        GoRoute(
          path: 'onboarding_game_select_page',
          builder: (context, state) => OnboardingGameSelectPage(),
          routes: [
            GoRoute(
              path: 'onboarding_game_preset_page',
              builder: (context, state) => OnboardingGamePresetPage(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return WorkoutShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeTabNavigatorKey,
          routes: [
            GoRoute(
              path: '/game_main_page',
              builder: (context, state) => GameMainPage(),
              routes: [
                GoRoute(
                  path: 'game_detail_page',
                  builder: (context, state) => GameDetailPage(),
                ),
                GoRoute(
                  path: 'game_setup_page',
                  builder: (context, state) => GameSetupPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileTabNavigatorKey,
          routes: [
            GoRoute(path: '/my_page', builder: (context, state) => MyPage()),
          ],
        ),
      ],
    ),
  ],
);
