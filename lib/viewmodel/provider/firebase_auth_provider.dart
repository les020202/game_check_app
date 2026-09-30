import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/firebase_storage_service.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirebaseStorageService? _storageService;

  AppUser? _user;
  StreamSubscription<AppUser?>? _sub;

  FirebaseAuthProvider(this._authService, {this._storageService}) {
    _user = _authService.currentUser; // 앱 시작 시 이미 로그인된 상태를 바로 반영
    _sub = _authService.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
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
    debugPrint('signUp 직후 displayName: ${_authService.currentUser?.nickname}');
    await refreshUser();
    debugPrint('refreshUser 이후 displayName: ${_user?.nickname}');
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

  Future<void> sendVerificationEmail() async {
    try {
      await _authService.sendVerificationEmail();
    } finally {
      await refreshUser(); // 성공/실패와 상관없이 최신 인증 상태 반영
    }
  }

  Future<void> deleteAccount(String password) =>
      _authService.reauthenticateAndDeleteAccount(password);

  Future<void> refreshUser() async {
    _user = await _authService.reloadUser();
    notifyListeners();
  }

  Future<void> signInWithGoogle() => _authService.signInWithGoogle(); //소셜로그인 서비스
  Future<void> deleteAccountWithGoogle() => 
      _authService.deleteAccountWithGoogle(); //소셜계정 회원탈퇴 서비스
}
