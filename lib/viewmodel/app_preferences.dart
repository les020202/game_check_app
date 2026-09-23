import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final SharedPreferencesAsync _prefs =
      SharedPreferencesAsync();

  // 온보딩 완료 여부 가져오기
  static Future<bool> isOnboardingDone() async {
    return await _prefs.getBool('onboarding_done') ?? false;
  }

  // 온보딩 완료 처리
  static Future<void> setOnboardingDone() async {
    await _prefs.setBool('onboarding_done', true);
  }
}
