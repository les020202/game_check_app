import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodel/provider/firestore_support_provider.dart';
import '/widgets/app_switch.dart';
import '/widgets/custom_app_bar.dart';

class TermsSettingsPage extends StatefulWidget {
  TermsSettingsPage({super.key});

  @override
  State<TermsSettingsPage> createState() => _TermsSettingsPageState();
}

class _TermsSettingsPageState extends State<TermsSettingsPage> {
  List<String> reqTerms=[];
  List<String> reqTermsText=[];
  List<String> reqTermsAddress=[];

  List<String> terms=[];
  List<String> termsText=[];
  List<String> termsAddress=[];

  bool? isOn;
  
  bool _isLoading=false;
  @override
  void initState(){
    super.initState();  
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData()); 
  }

  Future<void> _loadInitialData() async {
    final gp = Provider.of<FirestoreSupportProvider>(context, listen: false);
    await gp.loadAgreement();
    final agreement = gp.agreement;
    if (agreement == null) {
      // 동의 기록이 없으면 빈 화면으로 두되, 재시도 루프는 막는다
      if (mounted) setState(() => _isLoading = true);
      return;
    }
    isOn = agreement.marketingConsent;
    reqTerms = ['서비스 이용약관', '개인정보 수집 및 이용 동의'];
    reqTermsText = ['${DateFormat('yyyy.MM.dd').format(gp.agreement!.termsOfService.agreedAt)} 동의', '${DateFormat('yyyy.MM.dd').format(gp.agreement!.privacyPolicy.agreedAt)} 동의'];
    reqTermsAddress= ['/my_page/terms_settings_page/terms_detail_page/${0}','/my_page/terms_settings_page/terms_detail_page/${1}'];
    terms = ['마케팅 정보 수신 동의'];
    termsText = ['이벤트, 혜택 정보를 이메일로 받아요'];
    termsAddress= ['/my_page/terms_settings_page/terms_detail_page/${2}'];
    if (!mounted) return;
    setState(() {
      _isLoading=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final gp = Provider.of<FirestoreSupportProvider>(context, listen: false);
    if(!_isLoading) WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData()); 
    return Scaffold(
      appBar: CustomAppBar(title: '이용약관 및 개인정보처리방침'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '필수 약관  ',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '  서비스 이용을 위해 반드시 필요해요',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      getRequiredTerms(
                        textTheme, reqTerms, reqTermsText, 
                        getAgree(textTheme), reqTermsAddress
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24,),
                Row(
                  children: [
                    Text(
                      '선택 약관  ',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '  동의하지 않아도 서비스 이용 가능해요',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      getRequiredTerms(
                        textTheme, terms, termsText, 
                        AppSwitch(value: isOn ?? false, onChanged: (value) {
                          setState(() {
                            isOn=value;
                            gp.setMarketingConsent(value);
                          });
                        }, scale: 0.8),
                        termsAddress
                      )
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

  Container getAgree(TextTheme textTheme) {
    return Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.only(
                  left: 7,
                  right: 7,
                  top: 2,
                  bottom: 2,
                ),
                child: Text(
                  '동의함',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              );
  }

  Widget getRequiredTerms(
    TextTheme textTheme,
    List<String> terms,
    List<String> termTexts,
    Widget widget,
    List<String> termsAddress
  ) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: terms.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${terms[index]}',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${termTexts[index]}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                widget,
                IconButton(
                  onPressed: () {
                    context.go(termsAddress[index]);
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ); 
  }
}
