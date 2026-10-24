import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_storage_service.dart';
import '../../services/user_data_service.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirebaseStorageService? _storageService;
  final UserDataService _userDataService = UserDataService();

  AppUser? _user;
  StreamSubscription<AppUser?>? _sub;
  bool _verificationChecked = false; // 같은 로그인 동안 한 번만 갱신

  FirebaseAuthProvider(this._authService, {this._storageService}) {
    _user = _authService.currentUser;
    _sub = _authService.userChanges.listen((user) {
      _user = user;
      notifyListeners();
      _refreshOnceIfUnverified(); 
    });
    _refreshOnceIfUnverified();
  }

  // 미인증 사용자에게만, 로그인 한 번당 한 번 서버의 최신 상태를 가져옴
  void _refreshOnceIfUnverified() {
    final u = _user;
    if (u == null) {
      _verificationChecked = false; // 로그아웃하면 다음 로그인에서 다시 확인
      return;
    }
    if (_verificationChecked) return;
    _verificationChecked = true;
    if (!u.emailVerified) {
      refreshUser().catchError((_) {});
    }
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  bool get isGoogleLogin {
    final user = FirebaseAuth.instance.currentUser;

    return user?.providerData.any(
          (provider) => provider.providerId == 'google.com',
        ) ??
        false;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) =>
      _authService.signInWithEmail(email: email, password: password);

  Future<String> signUp(String email, String password, String nickName) async {
    await _authService.signUpWithEmail(
      email: email,
      password: password,
      nickName: nickName,
    );
    final uid = _authService.currentUser?.id; // 가입 직후 즉시 읽음, 스트림 안 기다림
    if (uid == null) throw Exception('가입 후 사용자 정보를 가져오지 못했습니다.');
    await refreshUser();
    return uid;
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> resetPassword(String email) =>
      _authService.resetPassword(email: email);

  Future<void> updateName(String? nickName) async {
    await _authService.updateName(nickName);
    await refreshUser();
  }

  Future<void> updateProfileImage({
    required Uint8List bytes,
    required String path,
  }) async {
    final uid = _user?.id;
    final storage = _storageService;
    if (uid == null || storage == null) return;
    final url = await storage.uploadProfileImage(
      bytes: bytes,
      path: path,
      uid: uid,
    );
    await _authService.updatePhotoUrl(
      '$url&v=${DateTime.now().millisecondsSinceEpoch}',
    );
    await refreshUser();
  }

  Future<void> deleteProfileImage() async {
    final uid = _user?.id;
    if (uid == null) return;
    await _authService.deletePhotoUrl();
    await _storageService!.deleteProfileImage(uid);
    await refreshUser();
  }

  Future<bool> sendVerificationEmail() async {
    try {
      return await _authService.sendVerificationEmail();
    } finally {
      try {
        await refreshUser(); // 성공/실패와 상관없이 최신 인증 상태 반영
      } catch (_) {
        // 상태 갱신 실패가 메일 발송 결과를 덮어쓰지 않도록 무시
      }
    }
  }

  Future<void> deleteAccount(String password) async {
    await _authService.reauthenticateWithPassword(password);
    await _wipeDataAndDeleteUser();
  }

  Future<void> refreshUser() async {
    _user = await _authService.reloadUser();
    notifyListeners();
  }

  Future<void> signInWithGoogle() =>
      _authService.signInWithGoogle(); //소셜로그인 서비스

  Future<void> deleteAccountWithGoogle() async {
    await _authService.reauthenticateWithGoogle();
    await _wipeDataAndDeleteUser();
  } //소셜계정 회원탈퇴 서비스

  //계정 삭제시 관련 Data 지우기
  Future<void> _wipeDataAndDeleteUser() async {
    final uid = _authService.currentUser?.id;
    if (uid == null) throw Exception('로그인이 필요합니다.');
    try {
      await _userDataService.deleteAllUserData(uid);
    } catch (e) {
      debugPrint('deleteAllUserData error: $e');
      throw Exception('데이터 삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
    await _authService.deleteCurrentUser();
  }
}
