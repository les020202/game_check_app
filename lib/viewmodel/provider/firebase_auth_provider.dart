import 'dart:async';
import 'dart:typed_data';
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) =>
      _authService.signInWithEmail(email: email, password: password);

  Future<void> signUp(String email, String password, String? nickName) =>
      _authService.signUpWithEmail(
        email: email,
        password: password,
        nickName: nickName,
      );

  Future<void> signOut() => _authService.signOut();

  Future<void> resetPassword(String email) =>
      _authService.resetPassword(email: email);

  Future<void> updateName(String? nickName) =>
      _authService.updateName(nickName);

  Future<void> updateProfileImage({
    required Uint8List bytes,
    required String path,
  }) async {
    final uid = _user?.id;
    if (uid == null) return;
    final url = await _storageService!.uploadProfileImage(
      bytes: bytes,
      path: path,
      uid: uid,
    );
    await _authService.updatePhotoUrl(
      '$url&v=${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<void> deleteProfileImage() async {
    final uid = _user?.id;
    if (uid == null) return;
    await _authService.deletePhotoUrl();
    await _storageService!.deleteProfileImage(uid);
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
}
