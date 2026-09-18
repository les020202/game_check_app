// filename: registration_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_app_bar.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  bool isAllChecked = false;
  List<List<dynamic>> isCheckeds = [
    [false, '[필수] 이용약관 동의'],
    [false, '[필수] 개인정보 수집 및 이용 동의'],
    [false, '[선택] 마케팅 정보 수신 동의'],
  ];

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
                      labelStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText: '멋진 사용자',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '이메일',
                      labelStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText: 'example@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    //controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText: '비밀번호를 입력하세요',
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
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: '비밀번호확인',
                      labelStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText: '비밀번호를 한번더 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
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
                              isAllChecked = !isAllChecked;
                              isAllChecked
                                  ? isCheckeds[0][0] = true
                                  : isCheckeds[0][0] = false;
                              isAllChecked
                                  ? isCheckeds[1][0] = true
                                  : isCheckeds[1][0] = false;
                              isAllChecked ? null : isCheckeds[2][0] = false;
                            });
                          },
                        ),
                        Text('약관 전체 동의',style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),),
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [...getTermsList(isCheckeds, textTheme)],
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/my_page/login_page');
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
                        style: TextStyle(fontSize: 20, color: colorScheme.onPrimary,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getTermsList(List<dynamic> isCheckeds, TextTheme textTheme) {
    List<Widget> termsList = [];
    for (int i = 0; i < isCheckeds.length; i++) {
      termsList.add(
        ListTile(
          leading: Checkbox(
            value: isCheckeds[i][0],
            onChanged: (value) {
              setState(() {
                isCheckeds[i][0] = !isCheckeds[i][0];
              });
            },
          ),
          title: Text(
            isCheckeds[i][1],
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            onPressed: () {
              context.go(''); //약관페이지로 이동부분
            },
            icon: Icon(Icons.arrow_forward_ios, size: 20),
          ),
        ),
      );
    }
    return termsList;
  }
}
