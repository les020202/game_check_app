import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';
import '/widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';

class InquiryFormPage extends StatefulWidget {
  InquiryFormPage({super.key});

  @override
  State<InquiryFormPage> createState() => _InquiryFormPageState();
}

class _InquiryFormPageState extends State<InquiryFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<bool> isCheckeds = [true, false, false, false, false, false];

  List<String> customerTypeNames = ['계정', '게임 설정', '알림', '오류 신고', '기타'];

  List<List<String>> inquirys = [
    ['주간 리셋이 초기화되지 않아요', '답변완료', '26.08.17'],
    ['게임 삭제는 어떻게 하나요?', '대기중', '26.08.20'],
    ['알림이 오지 않습니다', '답변완료', '26.08.31'],
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '문의하기'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '태그   ',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '   하나만 선택해주세요',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: customerTypeNames.length,
                      itemBuilder: (context, index) {
                        return TagFilter(
                          onTap: () {
                            setState(() {
                              if (isCheckeds.contains(true)) {
                                isCheckeds = [
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ];
                              }
                              isCheckeds[index] = !isCheckeds[index];
                            });
                          },
                          isCheckeds: isCheckeds,
                          typeNames: customerTypeNames,
                          index: index,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '제목',
                      labelStyle: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText: '문의 제목을 입력해주세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    maxLines: 8,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      labelText: '내용',
                      labelStyle: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      filled: true,
                      fillColor: colorScheme.onPrimary,
                      hintText:
                          '어떤 문제가 있으셨나요?\n어떤 화면에서 발생했는지,\n언제부터 그랬는지 적어주시면\n더 빠르게 도와드릴 수 있어요.',
                      hintMaxLines: 5,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: [6, 3],
                        strokeWidth: 1.5,
                        radius: Radius.circular(12),
                        color: Colors.grey,
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate),
                            SizedBox(height: 6),
                            Text(
                              '이미지 첨부',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '(선택)',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: colorScheme.primary),
                        SizedBox(width: 6),
                        Text(
                          '답변은 가입하신 계정의 이메일로 보내드립니다.\n(답변 메일이 안보일 경우 스펨함을 확인해주세요.)',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    customText: '문의 보내기',
                    onPressed: () {
                      context.go(
                        '/my_page/customer_service_page',
                      );
                    },
                    backgroundColors: colorScheme.primary,
                    fontStyle: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
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
}
