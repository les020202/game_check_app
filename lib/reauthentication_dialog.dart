
import 'package:flutter/material.dart';
import 'services/firebase_auth_service.dart';
import 'show_snackbar.dart';

Future<String?> showReauthenticationDialog(BuildContext context, FirebaseAuthService auth ){
  final TextEditingController passwordController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('비밀번호 확인'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: '비밀번호를 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context,null);
            },
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async{
              if(!context.mounted) return;
              try{
                await auth.reauthenticateAndDeleteAccount(passwordController.text);
                showSnackBar(context, '탈퇴처리가 완료되었습니다.');
              }catch(e){
                showSnackBar(context, '$e');
              }
              Navigator.pop(context);
            },
            child: Text('탈퇴하기'),
          ),
        ],
      );
    }
  );
}