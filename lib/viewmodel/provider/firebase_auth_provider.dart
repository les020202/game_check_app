import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_auth_service.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService;
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  FirebaseAuthProvider(this._firebaseAuthService) {
    _firebaseAuthService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> refreshUser() async {
    await _firebaseAuthService.user?.reload();
    _user = _firebaseAuthService.auth.currentUser; // reload 후 최신 유저 다시 받아오기
    notifyListeners();
  }
}
