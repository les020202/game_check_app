import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/widgets/custom_button.dart';
import '../widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  List<bool> isCheckeds = [true, false, false, false, false, false];
  List<String> customerTypeNames = ['전체', '계정', '게임 설정', '알림', '오류 신고', '기타'];

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
      appBar: CustomAppBar(title: '고객센터'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '빠른 도움말',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
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
                              isCheckeds[index] = !isCheckeds[index];
                              if (!isCheckeds.contains(true)) {
                                isCheckeds[0] = true;
                              } else if (isCheckeds[0] && index != 0) {
                                isCheckeds[0] = false;
                              } else if (isCheckeds[0]) {
                                isCheckeds = [true, false, false, false, false,false];
                              }
                            });
                          },
                          isCheckeds: isCheckeds,
                          typeNames: customerTypeNames,
                          index: index,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '내 문의 내역',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12),
                  ...getInquiry(textTheme),
                  CustomButton(
                    customText: '새 문의 작성하기', 
                    onPressed: (){
                      context.go('/my_page/customer_service_page/inquiry_form_page');
                    }, 
                    backgroundColors: colorScheme.primary, 
                    fontStyle: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Padding> getInquiry(TextTheme textTheme) {
    List<Padding> inquiryWidget = [];
    for (int i = 0; i < inquirys.length; i++) {
      inquiryWidget.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inquirys[i][0],
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6,),
                    Container(
                      decoration: BoxDecoration(
                        color: inquirys[i][1] == '답변완료'
                              ? Colors.green.shade100
                              : Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(right: 10.0,left: 10.0,top: 5.0,bottom: 5.0),
                      child: Text(
                        inquirys[i][1],
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: inquirys[i][1] == '답변완료'
                              ? Colors.green.shade800
                              : Colors.yellow.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(inquirys[i][2]),
              ],
            ),
          ),
        ),
      );
    }
    return inquiryWidget;
  }
}
