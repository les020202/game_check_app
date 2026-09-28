//filename:profile_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_service.dart';
import '../services/firebase_storage_service.dart';
import '../show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../reauthentication_dialog.dart';
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorageService _storage = FirebaseStorageService();
  
  bool _isEditing = false;
  bool _isUploading = false;

  List<List<dynamic>> menu = [
    // [
    //   Icon(Icons.notifications_none),
    //   Text('알림 설정'),
    //   '/my_page/notification_settings_page',
    // ], 알림설정 부분(비활성화)
    [
      Icon(Icons.help_outline), 
      Text('자주 묻는 질문'), 
      '/my_page/faq_page'
    ],
    [
      Icon(Icons.headset_mic_outlined),
      Text('고객센터'),
      '/my_page/customer_service_page',
    ],
    [
      Icon(Icons.description_outlined),
      Text('이용약관 및 개인정보처리방침'),
      '/my_page/terms_settings_page',
    ],
  ];

  Future<void> _pickImage() async {
    setState(() {
      _isUploading = true;
    });
    try {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        String? downloadURL;
        downloadURL = await _storage.uploadProfileImage(
          bytes: await pickedFile.readAsBytes(),
          path: pickedFile.path,
          uid: _auth.user?.uid,
        );
        await _auth.updatePhotoUrl(downloadURL);
        if (mounted) {
          context.read<FirebaseAuthProvider>().refreshUser();
        }
      }
    } catch (e) {
      showSnackBar(context, '$e');
    }
    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<FirebaseAuthProvider>(
        builder: (context, firebaseAuthProvider, snapshot) {
          final isLoggedIn = firebaseAuthProvider.isLoggedIn;
          final currentUser = firebaseAuthProvider.user;
          String? nickName = currentUser?.displayName;
          String? email = currentUser?.email;
          String? profileImageURL = currentUser?.photoURL;

          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Stack(
                                children: [
                                  if (isLoggedIn)
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: colorScheme.primary,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              profileImageURL != null
                                              ? NetworkImage(profileImageURL)
                                              : const AssetImage(
                                                  'assets/me.png',
                                                ),
                                          onBackgroundImageError: (_, __) {
                                            setState(() {
                                              profileImageURL = null;
                                            });
                                          },
                                          backgroundColor: Colors.transparent,
                                          child: _isUploading
                                              ? CircularProgressIndicator()
                                              : Icon(
                                                  Icons.camera_alt,
                                                  size: textTheme
                                                      .headlineMedium
                                                      ?.fontSize,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                      ),
                                    ),
                                  if (isLoggedIn)
                                    Positioned(
                                      bottom: 5,
                                      right: 20,
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceDim,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.close,
                                              color: colorScheme.onPrimary,
                                            ),
                                            onPressed: () async{
                                              if(!context.mounted) return;
                                              try{
                                                await _auth.deletePhotoUrl();
                                                await _storage.deleteProfileImage(_auth.user?.uid);
                                              }catch(e){
                                                showSnackBar(context, '$e');
                                              }
                                              firebaseAuthProvider.refreshUser();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            if (isLoggedIn)
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      minLines: 1,
                                      maxLines: 5,
                                      initialValue: nickName,
                                      decoration: InputDecoration(
                                        labelText: '닉네임',
                                        labelStyle: textTheme.bodyLarge,
                                        hintText: '닉네임을 입력하세요',
                                        border: UnderlineInputBorder(),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorScheme.outlineVariant,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                        enabled: _isEditing,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '이름을 입력하세요';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        nickName = value;
                                      },
                                    ),
                                    TextFormField(
                                      minLines: 1,
                                      maxLines: 5,
                                      enabled: false,
                                      initialValue: email,
                                      decoration: InputDecoration(
                                        labelText: '이메일',
                                        labelStyle: textTheme.bodyLarge,
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (isLoggedIn)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                  });
                                  if (!_isEditing) {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      if(!context.mounted) return;
                                      _formKey.currentState?.save();
                                      _auth.updateName(nickName)
                                          .then((_) {
                                            showSnackBar(context, '수정 되었습니다.');
                                            firebaseAuthProvider.refreshUser();
                                            
                                          })
                                          .catchError((error) {
                                            showSnackBar(context, '$error');
                                          });
                                    }
                                  }
                                },
                                icon: Icon(Icons.edit),
                              ),
                            if (!isLoggedIn)
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '로그인이 필요합니다',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '로그인하면 체크리스트를 저장할 수 있습니다',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...getMenuList(menu),
                            if (isLoggedIn)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '이메일 인증을 아직 안하셨나요?',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: colorScheme.shadow,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if(_auth.user?.emailVerified??false){
                                        showSnackBar(context, '이미 인증된 사용자입니다.');
                                        return;
                                      }
                                      try{
                                        _auth.sendVerificationEmail();
                                        showSnackBar(context, '인증 이메일이 다시 전송되었습니다.');
                                      }catch(e){
                                        showSnackBar(context, '$e');
                                      }
                                    },
                                    child: Text(
                                      '이메일 보내기',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isLoggedIn
                                    ? Icon(Icons.logout)
                                    : Icon(Icons.login),
                                TextButton(
                                  onPressed: () {
                                    if (isLoggedIn) {
                                      _auth
                                          .signOut()
                                          .then((_) {
                                            showSnackBar(context, '로그아웃되었습니다.');
                                          })
                                          .catchError((error) {
                                            showSnackBar(context, '$error');
                                          });
                                    } else {
                                      context.go('my_page/login_page');
                                    }
                                  },
                                  child: Text(
                                    isLoggedIn ? '로그아웃' : '로그인',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12, child: Text('|')),
                                Icon(Icons.delete_outline),
                                TextButton(
                                  onPressed: () async{
                                    if(!context.mounted || _auth.user==null) return;
                                    try{
                                      showReauthenticationDialog(context,_auth);
                                      showSnackBar(context, '탈퇴처리가 완료되었습니다.');  
                                    }on FirebaseAuthException catch (e){
                                      showReauthenticationDialog(context,_auth);
                                    }catch(e){
                                      showSnackBar(context, '$e');
                                    }
                                  },
                                  child: Text(
                                    '회원탈퇴',
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> getMenuList(List<List<dynamic>> menu) {
    List<Widget> menuList = [];
    for (int i = 0; i < menu.length; i++) {
      menuList.add(
        Material(
          color: Colors.transparent,
          child: ListTile(
            leading: menu[i][0],
            title: menu[i][1],
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.go(menu[i][2]);
            },
          ),
        ),
      );
      menuList.add(Divider());
    }
    return menuList;
  }
}
