import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'my_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.grey.shade100,
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
    );
  }
}


