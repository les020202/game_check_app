import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_agreement.dart';

class FirestoreSupportService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final String uid;
  FirestoreSupportService(this.uid);

  // ---------- 매핑 변환 함수(Map <-> Model) ----------
  // ---------- AgreementStatus ----------
  Map<String, dynamic> _agreementStatusToMap(AgreementStatus s) => {
    'agreed': s.agreed,
    'agreedAt': Timestamp.fromDate(s.agreedAt),
  };

  AgreementStatus _toAgreementStatus(Map<String, dynamic> d) => AgreementStatus(
    agreed: d['agreed'] as bool,
    agreedAt: (d['agreedAt'] as Timestamp).toDate(),
  );

  // ---------- UserAgreement ----------
  Map<String, dynamic> _userAgreementToMap(UserAgreement a) => {
    'uid': a.uid,
    'termsOfService': _agreementStatusToMap(a.termsOfService),
    'privacyPolicy': _agreementStatusToMap(a.privacyPolicy),
    'marketingConsent': a.marketingConsent,
  };

  UserAgreement _toUserAgreement(Map<String, dynamic> d) => UserAgreement(
    uid: d['uid'] as String,
    termsOfService: _toAgreementStatus(
      d['termsOfService'] as Map<String, dynamic>,
    ),
    privacyPolicy: _toAgreementStatus(
      d['privacyPolicy'] as Map<String, dynamic>,
    ),
    marketingConsent: d['marketingConsent'] as bool,
  );


  Future<UserAgreement?> getUserAgreement() async {
    try {
      final doc = await _fs.collection('userAgreements').doc(uid).get();
      if (!doc.exists) return null;
      return _toUserAgreement(doc.data()!);
    } catch (e) {
      throw Exception('getUserAgreement error');
    }
  }

  Future<void> setUserAgreement(UserAgreement agreement) async {
    try {
      await _fs
          .collection('userAgreements')
          .doc(uid)
          .set(_userAgreementToMap(agreement));
    } catch (e) {
      throw Exception('setUserAgreement error');
    }
  }

  Future<void> updateMarketingConsent(bool value) async {
    try {
      await _fs.collection('userAgreements').doc(uid).update({
        'marketingConsent': value,
      });
    } catch (e) {
      throw Exception('updateMarketingConsent error');
    }
  }
}
