import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/widgets/custom_button.dart';
import '../widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';
import '../models/inquiry.dart';
import '../models/inquiry_status.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../viewmodel/provider/firestore_support_provider.dart';

class CustomerServicePage extends StatefulWidget {
  const CustomerServicePage({super.key});

  @override
  State<CustomerServicePage> createState() => _CustomerServicePageState();
}

class _CustomerServicePageState extends State<CustomerServicePage> {
  List<bool> isCheckeds = [true, false, false, false, false, false];
  List<String> customerTypeNames = ['전체', '계정', '게임 설정', '알림', '오류 신고', '기타'];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!context.read<FirebaseAuthProvider>().isLoggedIn) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      await Provider.of<FirestoreSupportProvider>(
        context,
        listen: false,
      ).loadInquiries();
    } catch (e) {
      _error = '문의 내역을 불러오지 못했습니다.';
    }
    if (mounted) setState(() => _isLoading = false);
  }

  /// 선택된 태그로 필터링 ('전체'가 선택되어 있으면 전부)
  List<Inquiry> _filtered(List<Inquiry> all) {
    if (isCheckeds[0]) return all;
    final selected = [
      for (var i = 1; i < customerTypeNames.length; i++)
        if (isCheckeds[i]) customerTypeNames[i],
    ];
    return all.where((q) => selected.contains(q.tag)).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = context.watch<FirebaseAuthProvider>().isLoggedIn;
    final all = isLoggedIn
        ? Provider.of<FirestoreSupportProvider>(context).inquiries
        : <Inquiry>[];
    final filtered = _filtered(all);
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
                                isCheckeds = [
                                  true,
                                  false,
                                  false,
                                  false,
                                  false,
                                  false,
                                ];
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
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (!isLoggedIn)
                    const Text('로그인 후 문의 내역을 볼 수 있어요.')
                  else if (_error != null)
                    Text(_error!)
                  else if (filtered.isEmpty)
                    const Text('문의 내역이 없어요.')
                  else
                    ...getInquiry(textTheme, filtered),
                  CustomButton(
                    customText: '새 문의 작성하기',
                    onPressed: () {
                      if (!isLoggedIn) {
                        showSnackBar(context, '로그인 후 문의할 수 있어요.');
                        return;
                      }
                      context.go(
                        '/my_page/customer_service_page/inquiry_form_page',
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

  List<Widget> getInquiry(TextTheme textTheme, List<Inquiry> list) {
    return list.map((q) {
      final answered = q.status == InquiryStatus.answered;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(q.tag, style: textTheme.bodyMedium),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: answered
                                ? Colors.green.shade100
                                : Colors.yellow.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            answered ? '답변완료' : '대기중',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: answered
                                  ? Colors.green.shade800
                                  : Colors.yellow.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(DateFormat('yy.MM.dd').format(q.createdAt)),
            ],
          ),
        ),
      );
    }).toList();
  }
}
