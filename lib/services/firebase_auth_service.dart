import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  FirebaseAuthService() : _auth = FirebaseAuth.instance{
    _auth.setLanguageCode('kr');
  }
  FirebaseAuth get auth => _auth;

  User? get user => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? nickName,
  }) async{
    String? errorMessage;
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.updateDisplayName(nickName);
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (error){
      switch (error.code){
        case 'weak-password':
          errorMessage='취약한 패스워드입니다. 최소 6자리 이상의 문자를 입력하세요.';
          break;
        case 'email-already-in-use':
          errorMessage='이미 사용 중인 이메일입니다. 다른 이메일을 입력하세요';
          break;
        case 'invalid-email':
          errorMessage='유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage=error.message ?? '알 수 없는 에러 발생';
      }
    } catch(error){
      errorMessage='알 수 없는 에러 발생';
    }
    if(errorMessage!=null){
      throw Exception(errorMessage);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async{
    String? errorMessage;
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error){
      switch (error.code){
        case 'user-not-found':
          errorMessage='해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'wrong-password':
          errorMessage='비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          errorMessage='유효하지 않은 이메일입니다.';
          break;
        case 'invalid-credential':
          errorMessage='비밀번호가 올바르지 않거나 유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage=error.message ?? '알 수 없는 에러 발생';
      }
    } catch(error){
      errorMessage='알 수 없는 에러 발생';
    }
    if(errorMessage!=null){
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      throw Exception('$e');
    }
  }

  bool isLoggedIn(){
    return user != null;
  }

  Future<void> resetPassword({
    required String email,
  }) async{
    String? errorMessage;
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error){
      switch (error.code){
        case 'auth/user-not-found':
          errorMessage='해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'auth/invalid-email':
          errorMessage='유효하지 않은 이메일입니다.';
          break;
        default:
          errorMessage=error.message ?? '알 수 없는 에러 발생';
      }
    } catch(error){
      errorMessage='알 수 없는 에러 발생';
    }
    if(errorMessage!=null){
      throw Exception(errorMessage);
    }
  }

  Future<void> updateName(String? nickName) async{
    try{
      await user?.updateDisplayName(nickName);
    }catch(e){
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> updatePhotoUrl(String? url) async{
    try{
      await user?.updatePhotoURL(url);
    }catch(e){
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> deletePhotoUrl() async{
    try{
      await _auth.currentUser?.updatePhotoURL(null);
    }catch(e){
      throw Exception('수정 실패:$e');
    }
  }

  Future<void> sendVerificationEmail()async{
    try{
      if(!(_auth.currentUser?.emailVerified??true)){
        await _auth.currentUser?.sendEmailVerification();
      }else{
        throw Exception('이미 이메일 인증이 완료되었습니다.');
      }
    }catch(e){
      throw Exception('인증 메일 전송에 실패했습니다.');
    }
  }

  Future<void> reauthenticateAndDeleteAccount(String password) async{
    String? errorMessage;
    try{
      AuthCredential credential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (error){
      switch (error.code){
        case 'user-not-found':
          errorMessage='해당 이메일로 가입된 사용자가 없습니다.';
          break;
        case 'wrong-password':
          errorMessage='비밀번호가 올바르지 않습니다.';
          break;
        default:
          errorMessage='재인증 중 오류 발생: ${error.message}';
      }
    } catch(error){
      errorMessage='탈퇴과정에 문제가 있습니다.';
    }
    if(errorMessage!=null){
      throw Exception(errorMessage);
    }
  }
}