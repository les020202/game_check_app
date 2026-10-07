import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final storageRef = FirebaseStorage.instance.ref();
  Future<String> uploadProfileImage({
    required Uint8List bytes,
    required String path,
    String? uid,
  }) async {
    if (uid == null) throw Exception('잘못된 접근입니다');
    try {
      final profileRef = storageRef.child(
        'user_profiles/${uid}_profile_image.png',
      );
      final metadata = SettableMetadata(
        contentType: 'image/png',
        customMetadata: {'picked-file-path': path},
      );
      await profileRef.putData(bytes, metadata);
      final downloadUrl = await profileRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('upload 실패');
    }
  }

  Future<void> deleteProfileImage(String? uid) async {
    if (uid == null) throw Exception('잘못된 접근입니다.');
    try {
      await storageRef.child('user_profiles/${uid}_profile_image.png').delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return;
      throw Exception('delete 실패');
    }
  }

  //문의 이미지 업로드
  Future<String> uploadInquiryImage({
    required Uint8List bytes,
    required String path,
    required String uid,
    required String inquiryId,
  }) async {
    try {
      final isPng = path.toLowerCase().endsWith('.png');
      final ref = storageRef.child(
        'inquiries/$uid/$inquiryId.${isPng ? 'png' : 'jpg'}',
      );
      await ref.putData(
        bytes,
        SettableMetadata(contentType: isPng ? 'image/png' : 'image/jpeg'),
      );
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('upload 실패');
    }
  }

  
}
