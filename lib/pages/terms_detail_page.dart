import 'package:flutter/material.dart';
import '/widgets/custom_app_bar.dart';

class TermsDetailPage extends StatefulWidget {
  final int termsIndex;
  TermsDetailPage({super.key,required this.termsIndex});

  @override
  State<TermsDetailPage> createState() => _TermsDetailPageState();
}

class _TermsDetailPageState extends State<TermsDetailPage> {
  List<List<String>> terms0=[
    [
      '제1조 (목적)',
      '이 약관은 게임 체크 앱 개발자가\n제공하는 서비스의 이용조건 및 절차, 회사와\n이용자의 권리·의무 및 책임사항을 규정함을\n목적으로 합니다.'
    ],
    [
      '제2조 (정의)',
      '1. "서비스"란 이용자가 게임의 일일·주간·월간\n퀘스트 및 목표를 등록하고 관리할 수 있도록\n회사가 제공하는 모바일 애플리케이션을 말합니다.',
      '2. "이용자"란 이 약관에 따라 회사가 제공하는\n서비스를 이용하는 회원 및 비회원을 말합니다.'
    ],
    [
      '제3조 (약관의 효력 및 변경)',
      '1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 공지함으로써 효력이 발생합니다.',
      '2. 회사는 관련 법령을 위배하지 않는 범위에서 이 약관을 변경할 수 있으며, 변경 시 적용일자 및 변경사유를 명시하여 사전에 공지합니다.'
    ],
    [
      '제4조 (서비스의 제공 및 변경)',
      '1. 회사는 다음과 같은 서비스를 제공합니다.\n  ● 게임별 일일·주간·월간 퀘스트 체크 기능\n  ● 캐릭터별 목표 관리 기능\n  ● 계정 연동을 통한 데이터 동기화 기능',
      '2. 회사는 운영상, 기술상 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경할 수 있습니다.'
    ],
    [
      '제5조 (회원가입 및 탈퇴)',
      '1. 이용자는 회사가 정한 절차에 따라 회원가입을 신청하며, 회사가 이를 승낙함으로써 회원가입이 완료됩니다.',
      '2. 회원은 언제든지 마이페이지를 통해 탈퇴를 요청할 수 있으며, 회사는 관련 법령이 정하는 바에 따라 이를 즉시 처리합니다.'
    ],
  ];

  List<List<String>> terms1=[
    [
      '수집·이용 목적', '회원 가입 및 식별, 민원 처리, 서비스 부정이용 방지',
    ],
    [
      '수집 항목', '1. [일반 가입] 이메일 주소, 비밀번호, 닉네임',
      '2. [구글 소셜 가입] 구글 계정 이메일 주소, 소셜 고유 식별자(UID), 프로필 사진 및 닉네임'
    ],
    [
      '보유 및 이용 기간', '회원 탈퇴 시 즉시 파기 (단, 관련 법령에 따라 보존이 필요한 경우 해당 기간 동안 보관)'
    ],
    [
      '동의 거부 권리 및 불이익', '위 개인정보 수집·이용에 대한 동의를 거부할 수 있습니다. 단, 필수항목 동의 거부 시 회원가입이 불가능합니다.'
    ],
  ];

  List<List<String>> terms2=[
    [
      '수집·이용 목적', '신규 서비스 안내, 이벤트 정보 제공, 맞춤형 마케팅 활용',
    ],
    [
      '수집 항목','이메일 주소, 앱 푸시 토큰'
    ],
    [
      '보유 및 이용 기간', '회원 탈퇴 시 또는 동의 철회 시까지',
    ],
    [
      '전송 방법', '앱 푸시(Push), 이메일',
    ],
    [
      '동의 거부권 및 불이익',
      '위 마케팅 정보 수신 동의는 선택 사항입니다. 동의를 거부하시더라도 기본 서비스 이용은 제한되지 않으며, 앱 내 설정을 통해 언제든지 수신 동의를 철회할 수 있습니다.',
    ],
  ];
  List<List<String>> termsDetails=[];
  List<String> termsDays=[
    '시행일 : 2026.10.01 버전 1.0',
    '시행일 : 2026.10.01 버전 1.0',
    '시행일 : 2026.10.01 버전 1.0',
  ];

  @override
  void initState() {
    super.initState();
    if(widget.termsIndex==0){
      termsDetails=terms0;
    }else if(widget.termsIndex==1){
      termsDetails=terms1;
    }else{
      termsDetails=terms2;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '서비스 이용약관'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text('${termsDays[widget.termsIndex]}'),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: termsDetails.length,
                      itemBuilder: (context, index) {
                        List<String> termsDetail=termsDetails[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(int i=0;i<termsDetail.length;i++)
                              Text(
                                '${termsDetail[i]}',
                                style: i==0 ? 
                                  textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)
                                  :textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)
                              ),
                            SizedBox(height: 12,),
                          ],
                        );
                      },
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
}