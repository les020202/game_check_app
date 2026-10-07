import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_agreement.dart';
import '../models/inquiry.dart';
import '../models/inquiry_status.dart';

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
    if (a.marketingUpdatedAt != null)
      'marketingUpdatedAt': Timestamp.fromDate(a.marketingUpdatedAt!),
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
    marketingUpdatedAt: (d['marketingUpdatedAt'] as Timestamp?)?.toDate(),
  );

  // ---------- Inquiry ----------
  Map<String, dynamic> _inquiryToMap(Inquiry i) => {
    'id': i.id,
    'userId': uid,
    'contactEmail': i.contactEmail,
    'title': i.title,
    'content': i.content,
    'tag': i.tag,
    'status': i.status.name, // 'pending' | 'answered'
    'imageUrl': i.imageUrl,
    'createdAt': Timestamp.fromDate(i.createdAt),
  };

  Inquiry _toInquiry(Map<String, dynamic> d) => Inquiry(
    id: d['id'] as String,
    userId: d['userId'] as String,
    contactEmail: d['contactEmail'] as String,
    title: d['title'] as String,
    content: d['content'] as String,
    tag: d['tag'] as String,
    status: InquiryStatus.values.byName(d['status'] as String),
    imageUrl: d['imageUrl'] as String?,
    createdAt: (d['createdAt'] as Timestamp).toDate(),
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
        'marketingUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('updateMarketingConsent error');
    }
  }

  //고객센터 문의 기능
  Future<List<Inquiry>> getInquiries() async {
    try {
      final snap = await _fs
          .collection('inquiries')
          .where('userId', isEqualTo: uid)
          .get();
      final list = snap.docs.map((d) => _toInquiry(d.data())).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순
      return list;
    } catch (e) {
      throw Exception('getInquiries error');
    }
  }

  Future<void> addInquiry(Inquiry inquiry) async {
    try {
      await _fs
          .collection('inquiries')
          .doc(inquiry.id)
          .set(_inquiryToMap(inquiry));
    } catch (e) {
      throw Exception('addInquiry error');
    }
  }
}
