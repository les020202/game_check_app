import 'package:flutter/material.dart';
import 'package:game_check_app/firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'local/database.dart';
import 'my_router.dart';
import 'services/game_service.dart';
import 'services/game_template_service.dart';
import 'viewmodel/app_preferences.dart';
import 'viewmodel/provider/game_provider.dart';
import 'viewmodel/provider/game_template_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  final db = AppDatabase();
  final gameService = GameService(db);

  final onboardingDone =
      await AppPreferences.isOnboardingDone();
  final router = createRouter(onboardingDone);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(
      gameProvider: GameProvider(gameService),
      router: router,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GameProvider gameProvider;
  final GoRouter router;

  const MyApp({
    super.key,
    required this.gameProvider,
    required this.router,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: gameProvider),
        ChangeNotifierProvider(
          create: (_) => GameTemplateProvider(GameTemplateService()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: Colors.grey.shade200,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xff006EFF),
            primary: Color(0xff006EFF),
            outline: Color(0xff717171),
            outlineVariant: Color(0xff818181),
            surfaceDim: Color(0xff979797),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Pretendard',
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Color(0xff006EFF),
            primary: Color(0xff006EFF),
            outline: Color(0xff717171),
            outlineVariant: Color(0xff818181),
            surfaceDim: Color(0xff979797),
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'game check app',
      ),
    );
  }
}
