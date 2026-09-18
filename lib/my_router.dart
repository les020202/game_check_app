import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/customer_service_page.dart';
import 'pages/faq_page.dart';
import 'pages/game_detail_page.dart';
import 'pages/game_detail_week_page.dart';
import 'pages/game_main_page.dart';
import 'pages/game_setup_page.dart';
import 'pages/inquiry_form_page.dart';
import 'pages/landing_page.dart';
import 'pages/login_page.dart';
import 'pages/mail_check_page.dart';
import 'pages/my_page.dart';
import 'pages/notification_settings_page.dart';
import 'pages/onboarding_game_preset_page.dart';
import 'pages/onboarding_game_select_page.dart';
import 'pages/registration_page.dart';
import 'pages/reset_password_page.dart';
import 'pages/terms_detail_page.dart';
import 'pages/terms_settings_page.dart';
import 'pages/game_shell.dart';
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
        return GameShell(navigationShell: navigationShell);
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
                  path: 'game_detail_page/:games_index',
                  builder: (context, state) {
                    String? gamesIndexString =
                        state.pathParameters['games_index'];
                    final gamesIndex = int.parse(gamesIndexString!);
                    return GameDetailPage(gamesIndex: gamesIndex);
                  },
                  routes: [
                    GoRoute(
                      path: 'game_detail_week_page',
                      builder: (context, state) => GameDetailWeekPage(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'game_setup_page',
                  builder: (context, state) {
                    final indexParam = state.uri.queryParameters['games_index'];
                    final gamesIndex = indexParam != null
                        ? int.parse(indexParam)
                        : null;
                    return GameSetupPage(gamesIndex: gamesIndex);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileTabNavigatorKey,
          routes: [
            GoRoute(
              path: '/my_page',
              builder: (context, state) => MyPage(),
              routes: [
                GoRoute(
                  path: 'login_page',
                  builder: (context, state) => LoginPage(),
                  routes: [
                    GoRoute(
                      path: 'registration_page',
                      builder: (context, state) => RegistrationPage(),
                    ),
                    GoRoute(
                      path: 'reset_password_page',
                      builder: (context, state) => ResetPasswordPage(),
                      routes: [
                        GoRoute(
                          path: 'mail_check_page',
                          builder: (context, state) => MailCheckPage(),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'notification_settings_page',
                  builder: (context, state) => NotificationSettingsPage(),
                ),
                GoRoute(
                  path: 'faq_page',
                  builder: (context, state) => FaqPage(),
                ),
                GoRoute(
                  path: 'customer_service_page',
                  builder: (context, state) => CustomerServicePage(),
                  routes: [
                    GoRoute(
                      path: 'inquiry_form_page',
                      builder: (context, state) => InquiryFormPage(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'terms_settings_page',
                  builder: (context, state) => TermsSettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'terms_detail_page',
                      builder: (context, state) => TermsDetailPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
