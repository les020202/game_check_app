import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/faq_item.dart';
import '../widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<FaqItem> faqs = [
    FaqItem(
      tag: '게임설정',
      question: '리셋 시간은 어떻게 설정하나요?',
      answer: '리셋 시간은 게임 설정 페이지에서 초기화 시간을 직접 스크롤하여 지정하고 저장하면 됩니다',
    ),
    FaqItem(
      tag: '계정',
      question: '데이터가 기기 변경 시 사라지나요?',
      answer: '회원가입 후 첫 로그인 시 클라우드 동기화를 사용하시면 기기를 바꾸거나 앱을 재설치해도 데이터가 유지돼요.',
    ),
    FaqItem(
      tag: '게임설정',
      question: '게임 템플릿은 어떻게 불러오나요?',
      answer: '게임 설정 페이지에서 게임 이름 이후 해당 게임의 프리셋이 있으면 적용시킬건지 응답 이후 적용 가능합니다.',
    ),
    FaqItem(
      tag: '게임설정',
      question: '캐릭터별로 다른 퀘스트를 설정할 수 있나요?',
      answer:
          '게임 설정 페이지에서  공통 일일퀘스트를 캐릭터별로 따로 체크할 수 있으며, 주간, 월간 퀘스트와 목표는 캐릭터별로 따로 설정 및 체크 가능합니다.',
    ),
    FaqItem(
      tag: '기타',
      question: '약관을 취소하려면 어떻게 해야 하나요?',
      answer: '이용 약관 페이지에서 선택 약관만 on/off 가능합니다.',
    ),
    //FaqItem(tag: '알림', question: '알림이 오지 않으신가요?', answer: '알림 설정 페이지에서 off에서 on으로 변경 하셨는지 확인해주세요. 그래도 알림이 오지 않는다면 고객센터로 문의 바랍니다.'),
  ];
  List<bool> isCheckeds = [true, false, false, false]; //false
  List<String> faqTypeNames = ['전체', '계정', '게임설정', '기타']; //'알림'

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // 체크된 태그에 맞는 FAQ만 골라내기
    final filteredFaqs = faqs.where((faq) {
      if (isCheckeds[0]) return true; // '전체'
      final tagIndex = faqTypeNames.indexOf(faq.tag);
      return tagIndex != -1 && isCheckeds[tagIndex];
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(title: '자주 묻는 질문'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: faqTypeNames.length,
                      itemBuilder: (context, index) {
                        return TagFilter(
                          onTap: () {
                            setState(() {
                              isCheckeds[index] = !isCheckeds[index];
                              if (!isCheckeds.contains(true)) {
                                isCheckeds[0] = true;
                              } else if (isCheckeds[0] && index != 0) {
                                isCheckeds[0] = false;
                              } else if (isCheckeds[0]) {
                                isCheckeds = [true, false, false, false];
                              }
                            });
                          },
                          isCheckeds: isCheckeds,
                          typeNames: faqTypeNames,
                          index: index,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredFaqs.length,
                    itemBuilder: (context, index) {
                      FaqItem faq = filteredFaqs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: ExpansionTile(
                            key: ValueKey(faq.question),
                            initiallyExpanded: faq.isExpanded,
                            tilePadding: EdgeInsets.zero,
                            shape: const Border(),
                            onExpansionChanged: (value) {
                              if (faq.isExpanded == value) return;
                              setState(() {
                                faq.isExpanded = value;
                              });
                            },
                            leading: Text(
                              '${faq.tag}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              '${faq.question}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: AnimatedRotation(
                              turns: faq.isExpanded ? 0.75 : 0.25,
                              duration: const Duration(milliseconds: 20),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                            children: [
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    '${faq.answer}',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Center(child: Text('원하는 답변을 찾지 못하셨나요?')),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        context.go('/my_page/customer_service_page');
                      },
                      child: Text('고객센터에 문의하기(로그인 후 이용 가능)'),
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
