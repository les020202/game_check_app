class AgreementStatus {
  final bool agreed;
  final DateTime? agreedAt;

  AgreementStatus({required this.agreed, this.agreedAt});
}

class UserAgreement {
  final String userId;
  final AgreementStatus termsOfService;   // 필수
  final AgreementStatus privacyPolicy;    // 필수
  final bool marketingConsent;            // 선택

  UserAgreement({
    required this.userId,
    required this.termsOfService,
    required this.privacyPolicy,
    required this.marketingConsent,
  });
}