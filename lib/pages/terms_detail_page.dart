import 'package:flutter/material.dart';
import '/widgets/custom_app_bar.dart';

class TermsDetailPage extends StatefulWidget {
  final int termsIndex;
  TermsDetailPage({super.key, required this.termsIndex});

  @override
  State<TermsDetailPage> createState() => _TermsDetailPageState();
}

String devName = '개발자 실명 교체';
String supportEmail = '문의 이메일 교체';

class _TermsDetailPageState extends State<TermsDetailPage> {
  // 1) 서비스 이용약관
  List<List<String>> terms0 = [
    [
      '제1조 (목적)',
      '이 약관은 게임 체크 앱 개발자($devName, 이하 "회사")가 제공하는 서비스의 이용조건 및 절차, 회사와 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.',
    ],
    [
      '제2조 (정의)',
      '1. "서비스"란 이용자가 게임의 일일·주간·월간 퀘스트 및 목표를 등록하고 관리할 수 있도록 회사가 제공하는 모바일 애플리케이션을 말합니다.',
      '2. "이용자"란 이 약관에 따라 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다.',
      '3. "회원"이란 회원가입을 하고 계정으로 로그인하여 서비스를 이용하는 자를, "비회원"이란 로그인 없이 기기 내 저장 기능만 이용하는 자를 말합니다.',
    ],
    [
      '제3조 (약관의 효력 및 변경)',
      '1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 공지함으로써 효력이 발생합니다.',
      '2. 회사는 관련 법령을 위배하지 않는 범위에서 이 약관을 변경할 수 있으며, 변경 시 적용일자 및 변경사유를 명시하여 사전에 공지합니다.',
    ],
    [
      '제4조 (서비스의 제공 및 변경)',
      '1. 회사는 다음과 같은 서비스를 제공합니다.\n  ● 게임별 일일·주간·월간 퀘스트 체크 기능\n  ● 캐릭터별 목표 관리 기능\n  ● 계정 연동을 통한 데이터 동기화 기능',
      '2. 회사는 운영상, 기술상 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경할 수 있습니다.',
      '3. 비회원이 사용하는 데이터는 이용자의 기기에만 저장되며, 앱 삭제 시 함께 삭제됩니다.',
    ],
    [
      '제5조 (회원가입 및 탈퇴)',
      '1. 이용자는 회사가 정한 절차에 따라 회원가입을 신청하며, 회사가 이를 승낙함으로써 회원가입이 완료됩니다.',
      '2. 회원가입은 만 14세 이상만 할 수 있습니다. 만 14세 미만은 비회원으로 이용할 수 있습니다.',
      '3. 회원은 언제든지 마이페이지를 통해 탈퇴를 요청할 수 있으며, 회사는 관련 법령이 정하는 바에 따라 이를 즉시 처리합니다.',
      '4. 회원이 탈퇴하면 계정과 관련 데이터(서비스 데이터, 동의 이력, 문의 내역, 이미지)는 즉시 삭제되며 복구할 수 없습니다.',
    ],
    [
      '제6조 (이용자의 의무)',
      '이용자는 다음 행위를 해서는 안 됩니다.\n  ● 타인의 계정 또는 정보를 도용하는 행위\n  ● 서비스의 정상적인 운영을 방해하는 행위\n  ● 법령 또는 공공질서에 위반되는 행위',
    ],
    [
      '제7조 (서비스 중단 및 책임의 제한)',
      '1. 회사는 시스템 점검, 천재지변 등 불가피한 사유가 있는 경우 서비스 제공을 일시적으로 중단할 수 있습니다.',
      '2. 회사는 무료로 제공하는 서비스와 관련하여 회사의 고의 또는 중대한 과실이 없는 한 이용자에게 발생한 손해에 대해 책임을 지지 않습니다.',
      '3. 비회원이 기기에 저장한 데이터는 기기 변경, 앱 삭제 등으로 사라질 수 있으며, 회사는 이를 복구할 수 없습니다.',
    ],
    [
      '제8조 (개인정보의 보호)',
      '회사는 이용자의 개인정보를 「개인정보 처리방침」에 따라 보호하며, 자세한 내용은 앱의 "이용약관 및 개인정보처리방침" 화면에서 확인할 수 있습니다.',
    ],
    [
      '제9조 (준거법 및 문의)',
      '1. 이 약관은 대한민국 법령에 따라 해석되고 적용됩니다.',
      '2. 서비스 이용 관련 문의는 $supportEmail 로 할 수 있습니다.',
    ],
  ];

  // 2) 개인정보 수집 및 이용 동의 (필수)
  List<List<String>> terms1 = [
    [
      '수집·이용 목적',
      '1. 회원 가입 의사 확인, 회원 식별·인증 및 서비스 부정이용 방지',
      '2. 게임·퀘스트 데이터의 계정 연동 및 기기 간 동기화',
      '3. 고객 문의 접수, 답변 및 민원 처리',
      '4. 약관 및 개인정보 수집·이용 동의 이력 관리',
    ],
    [
      '수집 항목',
      '1. [필수/일반 가입] 이메일 주소, 비밀번호, 닉네임\n  ※ 비밀번호는 암호화되어 관리됩니다.',
      '2. [필수/구글 가입] 구글 계정 이메일 주소, 소셜 고유 식별자(UID), 구글 계정 이름(닉네임으로 사용)',
      '3. [선택/프로필] 프로필 이미지 (직접 등록한 경우에만 저장)',
      '4. [필수/서비스 이용] 계정에 연동된 게임·캐릭터·퀘스트 설정 및 완료 기록',
      '5. [고객 문의 시] 문의자 이메일 주소·문의 제목·내용(필수), 첨부 이미지(선택)',
      '6. [필수/약관 동의] 약관 동의 여부 및 동의 일시',
      '※ 비회원으로 이용 시 데이터는 기기에만 저장되며 서버로 수집되지 않습니다.',
    ],
    [
      '보유 및 이용 기간',
      '회원 탈퇴 시까지 보유하며, 탈퇴 즉시 파기합니다. (고객 문의 내역 및 첨부 이미지 포함)',
      '현재 관련 법령에 따라 별도로 보존하는 개인정보는 없습니다.',
    ],
    [
      '개인정보 처리 위탁 및 국외 이전',
      '● 수탁자: Google LLC (Firebase)\n  - 위탁 업무: 회원 인증, 데이터 및 이미지 저장',
      '위 업무 처리 과정에서 개인정보가 국외(미국 등 Google 서버)로 이전·보관됩니다. 이전 항목, 국가, 시기·방법, 거부 방법은 「개인정보 처리방침」의 "개인정보의 국외 이전"에서 확인할 수 있습니다.',
    ],
    [
      '동의 거부 권리 및 불이익',
      '위 개인정보 수집·이용에 대한 동의를 거부할 수 있습니다. 다만 필수항목 동의를 거부하면 회원가입이 불가능하며, 비회원으로 기기 내 저장 기능은 이용하실 수 있습니다. 고객 문의 시 이메일 주소와 문의 내용을 제공하지 않으면 문의 접수가 제한됩니다.',
      '필수 항목 동의는 개별 철회가 불가하며, 회원 탈퇴를 통해 철회할 수 있습니다.',
    ],
    ['만 14세 미만 아동', '회원가입은 만 14세 이상만 할 수 있으며, 만 14세 미만 아동의 개인정보는 수집하지 않습니다.'],
  ];

  // 3) 마케팅 정보 수신 동의 (선택)
  List<List<String>> terms2 = [
    ['수집·이용 목적', '신규 서비스 안내, 이벤트 정보 제공'],
    ['수집 항목', '이메일 주소(회원 계정 이메일), 수신 동의 여부 및 동의·철회 일시'],
    ['보유 및 이용 기간', '회원 탈퇴 시 또는 동의 철회 시까지'],
    ['전송 방법', '이메일 (발신: $devName)'],
    [
      '동의 거부권 및 불이익',
      '위 마케팅 정보 수신 동의는 선택 사항입니다. 동의를 거부하시더라도 기본 서비스 이용은 제한되지 않습니다.',
      '동의 후에도 언제든지 마이페이지 → 이용약관 및 개인정보처리방침 → 마케팅 정보 수신 동의 스위치를 OFF로 변경하여 철회할 수 있습니다.',
    ],
  ];
  List<List<String>> termsDetails = [];
  List<String> termsDays = [
    '시행일 : 2026.10.07 버전 1.0',
    '시행일 : 2026.10.07 버전 1.0',
    '시행일 : 2026.10.07 버전 1.0',
  ];
  final List<String> termsTitles = [
    '서비스 이용약관',
    '개인정보 수집 및 이용 동의',
    '마케팅 정보 수신 동의',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.termsIndex == 0) {
      termsDetails = terms0;
    } else if (widget.termsIndex == 1) {
      termsDetails = terms1;
    } else {
      termsDetails = terms2;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: termsTitles[widget.termsIndex]),
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
                        List<String> termsDetail = termsDetails[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < termsDetail.length; i++)
                              Text(
                                '${termsDetail[i]}',
                                style: i == 0
                                    ? textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      )
                                    : textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                              ),
                            SizedBox(height: 12),
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
