import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<bool> isExpandeds = [false, false, false, false, false];
  List<bool> isCheckeds = [true, false, false, false, false];
  List<List<String>> faqs = [
    [
      '게임설정',
      '리셋 시간은 어떻게 설정하나요?',
      '리셋 시간은 게임 설정 페이지에서 초기화 시간을 직접 스크롤하여 지정하고 저장하면 됩니다',
    ],
    [
      '계정',
      '데이터가 기기 변경 시 사라지나요?',
      '회원가입 후 첫 로그인 시 클라우드 동기화를 사용하시면 기기를 바꾸거나 앱을 재설치해도 데이터가 유지돼요.',
    ],
    [
      '게임설정',
      '게임 템플릿은 어떻게 불러오나요?',
      '게임 설정 페이지에서 게임 이름 이후 해당 게임의 프리셋이 있으면 적용시킬건지 응답 이후 적용 가능합니다.',
    ],
    [
      '게임설정',
      '캐릭터별로 다른 퀘스트를 설정할 수 있나요?',
      'RPG 타입으로 설정한 게임의 경우 캐릭터별로 공통 일일퀘스트를 따로 체크할 수 있으며, 주간, 월간 퀘스트와 목표는 캐릭터별로 따로 설정 및 체크 가능합니다.',
    ],
    [
      '알림',
      '알림이 오지 않으신가요?',
      '알림 설정 페이지에서 off에서 on으로 변경 하셨는지 확인해주세요. 그래도 알림이 오지 않는다면 고객센터로 문의 바랍니다.',
    ],
  ];

  List<String> faqTypeNames = ['전체', '계정', '게임 설정', '알림', '기타'];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '자주 묻는 질문'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: '궁금한 내용을 검색해보세요.',
                    filled: true,
                    fillColor: colorScheme.onPrimary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        //검색한 내용이 관련된 것이 뜨게하는 로직
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12),
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
                              isCheckeds = [true, false, false, false, false];
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
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    List<String> faq = faqs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          shape: const Border(),
                          onExpansionChanged: (value) {
                            setState(() {
                              isExpandeds[index] = !isExpandeds[index];
                            });
                          },
                          leading: Text(
                            '${faq[0]}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            '${faq[1]}',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: AnimatedRotation(
                            turns: isExpandeds[index] ? 0.75 : 0.25,
                            duration: const Duration(milliseconds: 20),
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                          children: [
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text('${faq[2]}',
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
                Text('원하는 답변을 찾지 못하셨나요?'),
                TextButton(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
