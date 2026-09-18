//filename:profile_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? profileImageURL;
  bool _isEditing = false;
  bool isLoggedIn = false; //임시 로그인 상태 확인

  List<List<dynamic>> menu = [
    [Icon(Icons.notifications_none), Text('알림 설정'),'/my_page/notification_settings_page'],
    [Icon(Icons.help_outline), Text('자주 묻는 질문'),'/my_page/faq_page'],
    [Icon(Icons.headset_mic_outlined), Text('고객센터'),'/my_page/customer_service_page'],
    [Icon(Icons.description_outlined), Text('이용약관 및 개인정보처리방침'),'/my_page/terms_settings_page'],
  ];

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
      body: SingleChildScrollView(
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 1.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: profileImageURL != null
                                    ? NetworkImage(profileImageURL!)
                                    : const AssetImage('assets/me.png'),
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: textTheme.headlineMedium?.fontSize,
                                  color: Colors.grey,
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
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12,),
                      if (isLoggedIn) //임시 로그인 상태일때
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: '닉네임',
                                  labelStyle: textTheme.bodyLarge,
                                  hintText: 'Enter your name',
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
                              ),
                              TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: '이메일',
                                  labelStyle: textTheme.bodyLarge,
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (isLoggedIn) //임시 로그인 상태일때
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                      if (!isLoggedIn) //임시 로그아웃 상태일때
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
                      if (isLoggedIn) //임시 로그인 상태
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have you verified your email yet?',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.shadow,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Send Email',
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
                          isLoggedIn ? Icon(Icons.logout) : Icon(Icons.login),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLoggedIn = !isLoggedIn; // 임시 로그인/로그아웃 상태로 변경
                                if(isLoggedIn) context.go('my_page/login_page');
                              });
                            },
                            child: Text(
                              isLoggedIn ? '로그아웃' : '로그인',
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          ),
                          SizedBox(width: 12, child: Text('|')),
                          Icon(Icons.delete_outline),
                          TextButton(
                            onPressed: () {},
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
            onTap: (){
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
