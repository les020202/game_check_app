import 'package:flutter/material.dart';

import '../../models/user_agreement.dart';
import '../../services/firestore_support_service.dart';
import 'package:uuid/uuid.dart';
import '../../models/inquiry.dart';
import '../../models/inquiry_status.dart';

class FirestoreSupportProvider extends ChangeNotifier {
  FirestoreSupportService _service;
  FirestoreSupportProvider(this._service);

  UserAgreement? _agreement;
  bool _disposed = false;
  List<Inquiry> _inquiries = [];

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  //약관
  UserAgreement? get agreement => _agreement;

  Future<void> loadAgreement() async {
    _agreement = await _service.getUserAgreement();
    notifyListeners();
  }

  // Future<void> saveAgreement(UserAgreement agreement) async {
  //   await _service.setUserAgreement(agreement);
  //   await loadAgreement();
  // }

  Future<void> setMarketingConsent(bool value) async {
    await _service.updateMarketingConsent(value);
    await loadAgreement();
  }

  //고객센터 문의
  List<Inquiry> get inquiries => List.unmodifiable(_inquiries);

  Future<void> loadInquiries() async {
    _inquiries = await _service.getInquiries();
    notifyListeners();
  }

  Future<void> addInquiry({
    String? id,
    required String contactEmail,
    required String tag,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    final inquiry = Inquiry(
      id: id ?? const Uuid().v4(),
      userId: _service.uid,
      contactEmail: contactEmail,
      title: title,
      content: content,
      tag: tag,
      status: InquiryStatus.pending,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );
    await _service.addInquiry(inquiry);
    await loadInquiries();
  }
}
