// filename: registration_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user_agreement.dart';
import '../services/firestore_support_service.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../dialogs/local_data_dialog.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  // [체크 여부, 라벨, 필수 여부, 약관 상세 index(없으면 null)]
  List<List<dynamic>> isCheckeds = [
    [false, '[필수] 만 14세 이상입니다', true, null],
    [false, '[필수] 이용약관 동의', true, 0],
    [false, '[필수] 개인정보 수집 및 이용 동의', true, 1],
    [false, '[선택] 마케팅 정보 수신 동의', false, 2],
  ];

  bool get isAllChecked =>
      isCheckeds.where((e) => e[2] == true).every((e) => e[0] as bool);

  String? nickName;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '회원가입'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '회원 정보 입력',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText: '멋진 사용자',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nickName = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '이메일',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText: 'example@example.com',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력하세요';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return '유효한 이메일을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText: '비밀번호를 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        helperText: '*비밀번호는 6자 이상 입력해주세요.',
                        helperStyle: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '비밀번호확인',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText: '비밀번호를 한번더 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 다시 한번 입력하세요';
                        } else if (value != _passwordController.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAllChecked,
                            onChanged: (value) {
                              setState(() {
                                for (final e in isCheckeds) {
                                  if (e[2] == true)
                                    e[0] = value ?? false; // 필수만 변경
                                }
                              });
                            },
                          ),
                          Text(
                            '약관 전체 동의',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
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
                      child: Column(children: [...getTermsList(textTheme)]),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (isCheckeds.any(
                            (e) => e[2] == true && e[0] == false,
                          )) {
                            showSnackBar(context, '필수 약관에 동의해주세요.');
                            return;
                          }
                          _formKey.currentState!.save();
                          try {
                            final uid = await context
                                .read<FirebaseAuthProvider>()
                                .signUp(email!, password!, nickName!);

                            final now = DateTime.now();
                            final agreement = UserAgreement(
                              uid: uid,
                              termsOfService: AgreementStatus(
                                agreed: isCheckeds[1][0],
                                agreedAt: now,
                              ),
                              privacyPolicy: AgreementStatus(
                                agreed: isCheckeds[2][0],
                                agreedAt: now,
                              ),
                              marketingConsent: isCheckeds[3][0],
                              marketingUpdatedAt: now,
                            );
                            await FirestoreSupportService(
                              uid,
                            ).setUserAgreement(agreement);

                            if (!mounted) return;
                            final ok = await handleLocalDataOnLogin(
                              context,
                              isNewAccount: true,
                            );
                            if (!mounted) return;
                            if (!ok) {
                              context.go(
                                '/my_page/login_page',
                              ); // 실패 시 이미 signOut됨
                              return;
                            }
                            showSnackBar(context, '회원가입이 완료되었습니다.');
                            context.go('/my_page/login_page');
                          } catch (error) {
                            if (mounted) showSnackBar(context, '$error');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          '가입하기',
                          style: TextStyle(
                            fontSize: 20,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTermsList(TextTheme textTheme) {
    return [
      for (int i = 0; i < isCheckeds.length; i++)
        ListTile(
          leading: Checkbox(
            value: isCheckeds[i][0],
            onChanged: (value) =>
                setState(() => isCheckeds[i][0] = value ?? false),
          ),
          title: Text(
            isCheckeds[i][1],
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          trailing: isCheckeds[i][3] == null
              ? null
              : IconButton(
                  onPressed: () {
                    context.push(
                      '/my_page/terms_settings_page/terms_detail_page/${isCheckeds[i][3]}',
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios, size: 20),
                ),
        ),
    ];
  }
}
