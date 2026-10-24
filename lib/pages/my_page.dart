//filename:my_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../dialogs/reauthentication_dialog.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  bool _isEditing = false;
  bool _isUploading = false;
  bool _isSendingMail = false;

  List<List<dynamic>> menu = [
    // [
    //   Icon(Icons.notifications_none),
    //   Text('알림 설정'),
    //   '/my_page/notification_settings_page',
    // ], 알림설정 부분(비활성화)
    [Icon(Icons.help_outline), Text('자주 묻는 질문'), '/my_page/faq_page'],
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshVerification());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 앱이 백그라운드에서 다시 앞으로 나왔을 때 (메일 앱/브라우저에서 돌아옴)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshVerification();
  }

  // 로그인했지만 아직 미인증일 때만 서버에서 최신 상태를 다시 받아옴
  Future<void> _refreshVerification() async {
    if (!mounted) return;
    final auth = context.read<FirebaseAuthProvider>();
    if (!auth.isLoggedIn || (auth.user?.emailVerified ?? true)) return;
    try {
      await auth.refreshUser();
    } catch (_) {
      // 네트워크 문제 등은 조용히 무시
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isUploading = true);
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        await context.read<FirebaseAuthProvider>().updateProfileImage(
          bytes: await picked.readAsBytes(),
          path: picked.path,
        );
      }
    } catch (e) {
      if (mounted) showSnackBar(context, errorText(e));
    }
    if (mounted) setState(() => _isUploading = false);
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
        builder: (context, authProvider, snapshot) {
          final isLoggedIn = authProvider.isLoggedIn;
          final user = authProvider.user;
          String? nickName = user?.nickname;
          String? email = user?.email;
          String? profileImageURL = user?.profileImageUrl;

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
                            if (isLoggedIn)
                              SizedBox(
                                width: 104,
                                height: 104,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
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
                                                    )
                                                    as ImageProvider,
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
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
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
                                            onPressed: () async {
                                              try {
                                                await authProvider
                                                    .deleteProfileImage();
                                              } catch (e) {
                                                if (context.mounted)
                                                  showSnackBar(
                                                    context,
                                                    errorText(e),
                                                  );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(width: 24),
                            if (isLoggedIn)
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      key: ValueKey(
                                        'nickname_${user?.id}_$nickName',
                                      ),
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
                                      key: ValueKey('email_${user?.id}_$email'),
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
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      if (!context.mounted) return;
                                      _formKey.currentState?.save();
                                      authProvider
                                          .updateName(nickName)
                                          .then((_) {
                                            showSnackBar(context, '수정 되었습니다.');
                                          })
                                          .catchError((error) {
                                            showSnackBar(
                                              context,
                                              errorText(error),
                                            );
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
                            if (isLoggedIn && !(user?.emailVerified ?? false))
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
                                    onPressed: _isSendingMail
                                        ? null
                                        : () async {
                                            setState(
                                              () => _isSendingMail = true,
                                            );
                                            try {
                                              final sent = await authProvider
                                                  .sendVerificationEmail();
                                              if (context.mounted) {
                                                showSnackBar(
                                                  context,
                                                  sent
                                                      ? '인증 이메일이 전송되었습니다.'
                                                      : '이미 이메일 인증이 완료되었어요.',
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted)
                                                showSnackBar(
                                                  context,
                                                  errorText(e),
                                                );
                                            } finally {
                                              if (mounted)
                                                setState(
                                                  () => _isSendingMail = false,
                                                );
                                            }
                                          },
                                    child: Text(
                                      '이메일 보내기',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: _isSendingMail
                                            ? Colors.grey
                                            : colorScheme.primary,
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
                                      authProvider
                                          .signOut()
                                          .then((_) {
                                            showSnackBar(context, '로그아웃되었습니다.');
                                          })
                                          .catchError((error) {
                                            showSnackBar(
                                              context,
                                              errorText(error),
                                            );
                                          });
                                    } else {
                                      context.go('/my_page/login_page');
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
                                  onPressed: () async {
                                    if (!isLoggedIn) {
                                      showSnackBar(context, '로그인 상태가 아닙니다.');
                                      return;
                                    }
                                    if (authProvider.isGoogleLogin) {
                                      try {
                                        await authProvider
                                            .deleteAccountWithGoogle();
                                        if (context.mounted) {
                                          showSnackBar(
                                            context,
                                            '탈퇴처리가 완료되었습니다.',
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted)
                                          showSnackBar(context, errorText(e));
                                      }
                                      return;
                                    }
                                    final ok = await showReauthenticationDialog(
                                      context,
                                      (password) =>
                                          authProvider.deleteAccount(password),
                                    );
                                    if (ok == true && context.mounted) {
                                      showSnackBar(context, '탈퇴처리가 완료되었습니다.');
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
