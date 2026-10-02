import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/provider/firebase_auth_provider.dart';
import '../utils/show_snackbar.dart';
import '/widgets/custom_app_bar.dart';

class MailCheckPage extends StatelessWidget {
  MailCheckPage({super.key, required this.email});

  String? email;
  List<String> guides = [
    '메일함에서 받은 메일을 열어주세요',
    '메일 속 \'비밀번호 재설정\'링크를 눌려주세요',
    '열린 페이지에서 새 비밀번호를 설정하세요',
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '재설정 메일 체크'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.green),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '메일을 보냈어요',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$email 주소로\n재설정 링크를 발송했어요',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ...getMailGuide(textTheme, colorScheme, guides),
                        Divider(),
                        Text(
                          '* 링크는 보안을 위해 일정 시간 후에 만료돼요',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '메일이 오지 않았나요?',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await context
                            .read<FirebaseAuthProvider>()
                            .resetPassword(email!);
                        if (context.mounted)
                          showSnackBar(context, '비밀번호 재설정 이메일이 전송되었습니다.');
                      } catch (error) {
                        if (context.mounted) showSnackBar(context, '$error');
                      }
                    },
                    child: Text(
                      '재발송 요청하기',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
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

  List<Padding> getMailGuide(
    TextTheme textTheme,
    ColorScheme colorScheme,
    List<String> guides,
  ) {
    List<Padding> guideList = [];
    for (int i = 0; i < guides.length; i++) {
      guideList.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '${guides[i]}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return guideList;
  }
}
