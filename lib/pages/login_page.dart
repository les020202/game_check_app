//filename:login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../dialogs/local_data_dialog.dart';
import '../dialogs/terms_consent_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '로그인'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '로그인',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        hintText: 'example@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력하세요';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return '올바른 이메일 형식을 입력하세요';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 최소 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            context.go(
                              'my_page/login_page/reset_password_page',
                            );
                          },
                          child: Text('비밀번호를 잊으셨나요?'),
                        ),
                      ],
                    ),
                    CustomButton(
                      customText: '로그인',
                      onPressed: () async {
                        if (!(_formKey.currentState?.validate() ?? false))
                          return;
                        _formKey.currentState?.save();
                        try {
                          await context.read<FirebaseAuthProvider>().signIn(
                            email!,
                            password!,
                          );
                          if (!mounted) return;
                          if (!await handleLocalDataOnLogin(context)) return;
                          if (!mounted) return;
                          showSnackBar(context, '로그인이 되었습니다.');
                          context.go('/game_main_page');
                        } catch (error) {
                          if (mounted) showSnackBar(context, '$error');
                        }
                      },
                      backgroundColors: colorScheme.primary,
                      fontStyle: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          Text(
                            '  또는  ',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      customText: 'Google로 계속하기',
                      onPressed: () async {
                        try {
                          await context
                              .read<FirebaseAuthProvider>()
                              .signInWithGoogle();
                          if (!context.mounted) return;
                          if (!await ensureTermsAgreement(context)) return;
                          if (!context.mounted) return;
                          if (!await handleLocalDataOnLogin(context)) return;
                          if (!context.mounted) return;
                          showSnackBar(context, '로그인이 되었습니다.');
                          context.go('/game_main_page');
                        } catch (error) {
                          if (context.mounted) showSnackBar(context, '$error');
                        }
                      },
                      backgroundColors: colorScheme.onPrimary,
                      fontStyle: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('계정이 없으신가요?'),
                        TextButton(
                          onPressed: () {
                            context.go('/my_page/login_page/registration_page');
                          },
                          child: Text('회원가입'),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
