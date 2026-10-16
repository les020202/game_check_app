import 'package:flutter/material.dart';
import 'package:game_check_app/firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'local/database.dart';
import 'my_router.dart';
import 'services/firebase_auth_service.dart';
import 'services/drift_game_service.dart';
import 'services/firebase_storage_service.dart';
import 'services/firestore_game_service.dart';
import 'services/firestore_support_service.dart';
import 'services/game_service.dart';
import 'services/game_template_service.dart';
import 'viewmodel/app_preferences.dart';
import 'viewmodel/provider/firebase_auth_provider.dart';
import 'viewmodel/provider/firestore_support_provider.dart';
import 'viewmodel/provider/game_provider.dart';
import 'viewmodel/provider/game_template_provider.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  final db = AppDatabase();

  final onboardingDone = await AppPreferences.isOnboardingDone();
  final router = createRouter(onboardingDone);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GoogleSignIn.instance.initialize(
    serverClientId: const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
  );
  runApp(MyApp(db: db, router: router));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  final GoRouter router;

  const MyApp({super.key, required this.db, required this.router});

  String? _uidOf(GameService s) => s is FirestoreGameService ? s.uid : null;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthProvider(
            FirebaseAuthService(),
            storageService: FirebaseStorageService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => GameTemplateProvider(GameTemplateService()),
        ),
        ChangeNotifierProxyProvider<FirebaseAuthProvider, GameProvider>(
          create: (context) {
            final user = context.read<FirebaseAuthProvider>().user;
            return GameProvider(
              user == null
                  ? DriftGameService(db)
                  : FirestoreGameService(user.id),
            );
          },
          update: (_, auth, previous) {
            final uid = auth.user?.id;
            if (previous != null && _uidOf(previous.service) == uid) { // _uidOf: Drift면 null, Firestore면 uid
              return previous; // 같은 유저(또는 계속 비로그인)면 기존 인스턴스 유지
            }
            return GameProvider(
              uid == null ? DriftGameService(db) : FirestoreGameService(uid),
            );
          },
        ),
        ChangeNotifierProxyProvider<
          FirebaseAuthProvider,
          FirestoreSupportProvider?
        >(
          create: (context) {
            final uid = context.read<FirebaseAuthProvider>().user?.id;
            return uid == null
                ? null
                : FirestoreSupportProvider(FirestoreSupportService(uid));
          },
          update: (_, auth, previous) {
            final uid = auth.user?.id;
            if (uid == null) return null;
            if (previous != null) return previous;
            return FirestoreSupportProvider(FirestoreSupportService(uid));
          },
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: AppColors.bg,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.bg,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
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
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        title: 'game check app',
      ),
    );
  }
}
