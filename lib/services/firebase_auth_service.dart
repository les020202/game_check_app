import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  FirebaseAuthService() : _auth = FirebaseAuth.instance {
    _auth.setLanguageCode('ko');
  }

  String? _resolvePhotoUrl(User u) {
  final top = u.photoURL;

  // 직접 등록한 이미지(내 Storage URL)면 그대로 사용
  if (top != null && top.contains('firebasestorage.googleapis.com')) {
    return top;
  }

  // 아니면 구글 제공자 정보의 최신 사진 사용
  for (final p in u.providerData) {
    if (p.providerId == 'google.com' && p.photoURL != null) {
      return p.photoURL;
    }
  }
  return top; // 이메일 가입자 등: 없으면 null → 앱 기본 이미지
}

AppUser? _toAppUser(User? u) {
  if (u == null) return null;
  return AppUser(
    id: u.uid,
    nickname: u.displayName ?? '',
    email: u.email ?? '',
    profileImageUrl: _resolvePhotoUrl(u),
    emailVerified: u.emailVerified,
    createdAt: u.metadata.creationTime,
  );
}

  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  // authStateChanges 대신 userChanges: 로그인/로그아웃뿐 아니라
  // 프로필(닉네임, 사진) 변경도 스트림으로 흘러옴
  Stream<AppUser?> get userChanges => _auth.userChanges().map(_toAppUser);

  Future<AppUser?> reloadUser() async {
    await _auth.currentUser?.reload();
    return currentUser;
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? nickName,
  }) async {
    String? errorMessage;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser?.updateDisplayName(nickName);
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'weak-password':
          errorMessage = '취약한 패스워드입니다. 최소 6자리 이상의 문자를 입력하세요.';
          break;
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다. 다른 이메일을 입력하세요';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage = error.message ?? '알 수 없는 에러 발생';
      }
    } catch (error) {
      errorMessage = '알 수 없는 에러 발생';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    String? errorMessage;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          errorMessage = '해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'wrong-password':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        case 'invalid-credential':
          errorMessage = '비밀번호가 올바르지 않거나 유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage = error.message ?? '알 수 없는 에러 발생';
      }
    } catch (error) {
      errorMessage = '알 수 없는 에러 발생';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn.instance.signOut(); //소셜 로그아웃
    } catch (e) {
      throw Exception('$e');
    }
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<void> resetPassword({required String email}) async {
    String? errorMessage;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          errorMessage = '해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage = error.message ?? '알 수 없는 에러 발생';
      }
    } catch (error) {
      errorMessage = '알 수 없는 에러 발생';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  Future<void> updateName(String? nickName) async {
    try {
      await _auth.currentUser?.updateDisplayName(nickName);
    } catch (e) {
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> updatePhotoUrl(String? url) async {
    try {
      await _auth.currentUser?.updatePhotoURL(url);
    } catch (e) {
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> deletePhotoUrl() async {
    try {
      await _auth.currentUser?.updatePhotoURL(null);
    } catch (e) {
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다.');

    await user.reload(); // 최신 인증 상태로 갱신
    if (_auth.currentUser!.emailVerified) {
      throw Exception('이미 이메일 인증이 완료되었습니다.'); // try 밖이라 안 덮어씀
    }

    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw Exception('요청이 너무 많습니다. 잠시 후 다시 시도해주세요.');
      }
      throw Exception('인증 메일 전송에 실패했습니다.');
    } catch (_) {
      throw Exception('인증 메일 전송에 실패했습니다.');
    }
  }

  Future<void> reauthenticateWithPassword(String password) async {
    String? errorMessage;
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'user-not-found':
          errorMessage = '해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'wrong-password' || 'invalid-credential':
          errorMessage = '비밀번호가 올바르지 않습니다.';
          break;
        default:
          errorMessage = '재인증 중 오류 발생: ${error.message}';
      }
    } catch (error) {
      errorMessage = '탈퇴과정에 문제가 있습니다.';
    }
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
  }

  Future<void> signInWithGoogle() async {
    //소셜로그인(구글)
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('로그인이 취소되었습니다.');
      }
      throw Exception('구글 로그인 중 오류가 발생했습니다.$e');
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'account-exists-with-different-credential':
          errorMessage = '이미 다른 방법으로 가입된 이메일입니다. 이메일 로그인을 이용해주세요.';
          break;
        default:
          errorMessage = error.message ?? '구글 로그인 중 오류가 발생했습니다.';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('구글 로그인 중 오류가 발생했습니다.$e');
    }
  }

  //소셜 계정 탈퇴를 위한 재인증
  Future<void> reauthenticateWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      throw Exception('회원탈퇴 중 오류가 발생했습니다.$e');
    }
  }

  Future<void> deleteCurrentUser() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      throw Exception('탈퇴과정에 문제가 있습니다.');
    }
  }
}
