class AgreementStatus {
  final bool agreed;
  final DateTime agreedAt;

  AgreementStatus({required this.agreed, required this.agreedAt});
}

class UserAgreement {
  final String uid;
  final AgreementStatus termsOfService;   // 필수
  final AgreementStatus privacyPolicy;    // 필수
  final bool marketingConsent;            // 선택
  
  UserAgreement({
    required this.uid,
    required this.termsOfService,
    required this.privacyPolicy,
    required this.marketingConsent,
  });
}