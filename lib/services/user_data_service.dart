import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_storage_service.dart';

class UserDataService {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const _ownedCollections = [
    'questLogs',
    'characterQuests',
    'dailys',
    'characters',
    'games',
  ];

  /// 회원 탈퇴 시 사용자의 모든 데이터를 삭제한다.
  /// 인증 계정을 지우기 "전에" 호출해야 한다 (지운 뒤엔 권한이 없어짐).
  /// 중간에 실패해도 다시 호출하면 이어서 지워진다.
  Future<void> deleteAllUserData(String uid) async {
    // 1) 문의 + 첨부 이미지
    final inquiries = await _fs
        .collection('inquiries')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in inquiries.docs) {
      final url = doc.data()['imageUrl'] as String?;
      if (url != null) {
        try {
          await _storage.refFromURL(url).delete();
        } on FirebaseException catch (e) {
          if (e.code != 'object-not-found') rethrow;
        }
      }
    }
    await _deleteRefs(inquiries.docs.map((d) => d.reference).toList());

    // 2) 게임 관련 데이터
    for (final col in _ownedCollections) {
      final snap = await _fs
          .collection(col)
          .where('userId', isEqualTo: uid)
          .get();
      await _deleteRefs(snap.docs.map((d) => d.reference).toList());
    }

    // 3) 약관 동의 기록
    await _fs.collection('userAgreements').doc(uid).delete();

    // 4) 프로필 이미지 (없으면 무시됨)
    await FirebaseStorageService().deleteProfileImage(uid);
  }

  Future<void> _deleteRefs(List<DocumentReference> refs) async {
    for (var i = 0; i < refs.length; i += 450) {
      final batch = _fs.batch();
      for (final ref in refs.skip(i).take(450)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }
}